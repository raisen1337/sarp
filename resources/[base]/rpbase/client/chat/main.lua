Citizen.CreateThread(function()
    SetTextChatEnabled(false)
    SetNuiFocus(false)
end)

local chatOn = false

local lastChatMsg = false
local forbiddenWords = {
    "muie",
    "pula",
    "pizda",
    'sugi',
    'fgm',
    'fmm',
    'sug1',
    'sug',
    'fututi',
    'futu-ti',
    'coaie',
    'coaiele',
    'sug',
    'p1zda',
    'mortii ma-tii',
    'ma-tii',
    'pula in ma-ta',
    'pula-n ma-ta',
}

local function containsForbiddenWord(message)
    local replacements = {
        { "a", "[@4aA]" },
        { "i", "[iI1!]" },
        { "e", "[eE3]" },
        { "o", "[oO0]" },
        { "s", "[sS5$]" },
        { "t", "[tT7]" },
        { "g", "[gG69$]" }, -- Updated to include '9' as 'g'
        { "u", "[uU]" },
        { "m", "[mM]" },
        { "-", "[%-%s]*" }, -- Handle hyphen variations with potential spaces
        { "1", "[1iI!l]" },
        { "3", "[3eE]" },
        { "4", "[4aA]" },
        { "7", "[7tT]" },
        { "$", "[$sSgG]" }, -- Handling variations for '$'
        { "9", "[9gG$]" },  -- Handling '9' as 'g'
    }

    for _, word in ipairs(forbiddenWords) do
        local pattern = word:gsub(".", replacements)
        if string.find(message, "%f[%a]" .. pattern .. "%f[%A]") then
            return true
        end
    end
    return false
end





local function containsIPAddress(message)
    local ipAddressPattern = "%d+%.%d+%.%d+%.%d+"
    if string.find(message, ipAddressPattern) then
        return true
    end
    return false
end

local function containsAdvertising(message)
    local advertisingPattern = "cfx%.re/join/"
    if string.find(message, advertisingPattern) then
        return true
    end
    return false
end
RegisterNetEvent('chat:addMessage', function(message)
    local chatMsg = ''
    if type(message) == 'table' then
        local chatMsgs = message.args
        for k, v in pairs(chatMsgs) do
            chatMsg = chatMsg .. ' ' .. v
        end
    else
        chatMsg = message
    end
    if containsForbiddenWord(chatMsg) then
        TriggerEvent('chat:addMessage', { args = { "[^3SERVER^0]: Mesajul tău conține cuvinte interzise." } })
        return
    end

    if containsIPAddress(chatMsg) then
        TriggerEvent('chat:addMessage', { args = { "[^3SERVER^0]: Mesajul tău conține o adresă IP." } })
        return
    end

    if containsAdvertising(chatMsg) then
        TriggerEvent('chat:addMessage', { args = { "[^3SERVER^0]: Mesajul tău conține reclame." } })
        return
    end
    SendNUIMessage({ action = 'addChatMessage', message = chatMsg })
end)

SetInterval(1000, function()
    if chatOn then
        SetNuiFocus(true, true)
    end
end)

local randomChatMsgs = {
    '^b[SERVER]: ^0Daca ai probleme cu serverul, te rugam sa ne contactezi pe discord: ^5https://discord.gg/voltro',
    '^b[SERVER]: ^0Consideri ca un jucator incalca regulamentul? Fa un ticket! (K)',
    '^b[SERVER]: ^0Nu stii ce job sa faci? Scrie ^b/jobs^0 pentru a vedea toate joburile disponibile!',
    '^b[SERVER]: ^0Nu stii cum sa iti cumperi o masina? Mergi la ^bTargul Auto^0!',
}

Citizen.CreateThread(function()
    local lastRandomMsg = ""

    while true do
        Wait(60000)
        local randomMsg = randomChatMsgs[math.random(1, #randomChatMsgs)]
        if randomMsg ~= lastRandomMsg then
            TriggerEvent('chat:addMessage', { args = { randomMsg } })
            lastRandomMsg = randomMsg
        end
    end
end)

RegisterCommand('openchat', function()
    if chatOn then
        chatOn = false
        SetNuiFocus(false)
        SendNUIMessage({ action = 'openChat' })
    else
        chatOn = true
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'openChat' })
        local suggestions = {}
        for k, v in pairs(GetRegisteredCommands()) do
            table.insert(suggestions, { name = '/' .. v.name, help = v.help })
        end
        SendNUIMessage({ action = 'setSuggestions', suggestions = suggestions })
    end
end)

RegisterKeyMapping('openchat', 'Open Chat', 'keyboard', 'T')

-- watchForKeyPress()

-- Citizen.CreateThread(function ()
--     while true do
--         Citizen.Wait(0)
--         if IsControlJustPressed(1, 245) then
--             if chatOn then
--                 chatOn = false
--                 SetNuiFocus(false)
--                 SendNUIMessage({action = 'openChat'})
--             else
--                 chatOn = true
--                 SetNuiFocus(true, true)
--                 SendNUIMessage({action = 'openChat'})
--                 Core.TriggerCallback('Chat:GetSuggestions', function(suggestions)
--                     for k,v in pairs(GetRegisteredCommands()) do
--                         table.insert(suggestions, {name = '/'..v.name, help = v.help})
--                     end
--                     SendNUIMessage({action = 'setSuggestions', suggestions = suggestions})
--                 end)
--             end
--         end
--     end
-- end)

RegisterNUICallback('closeChat', function()
    chatOn = false
    SetNuiFocus(false)
end)

local continuousMessagesSent = 0

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        if lastChatMsg then
            lastChatMsg = false
        end
        if continuousMessagesSent == 5 then
            continuousMessagesSent = 0
        end
    end
end)



RegisterNUICallback('sendChatMessage', function(data)
    local message = data.message



    if string.sub(message, 1, 1) == '/' then
        local args = {}
        for word in string.gmatch(message, '[^%s]+') do
            table.insert(args, word)
        end
        local command = string.gsub(args[1], '/', '')
        table.remove(args, 1)
        ExecuteCommand(command, args)
        return
    end

    if lastChatMsg == message then
        return
    else
        lastChatMsg = message
        if continuousMessagesSent >= 5 then
            TriggerEvent('chat:addMessage',
                { args = { "[^3SERVER^0]: Ai trimis prea multe mesaje, te rugăm să aștepți." } })
            return
        else
            continuousMessagesSent = continuousMessagesSent + 1
        end
        TriggerServerEvent('sv:chat:addMessage', message)
    end
end)
