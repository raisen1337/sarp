Citizen.CreateThread(function()
    SetTextChatEnabled(false)
    SetNuiFocus(false)
end)

local chatOn = false

local lastChatMsg = false

RegisterNetEvent('chat:addMessage', function (message)
    local chatMsg = ''
    if type(message) == 'table' then
        local chatMsgs = message.args
        for k,v in pairs(chatMsgs) do
            chatMsg = chatMsg .. ' ' .. v
        end
    else
        chatMsg = message
    end
    SendNUIMessage({action = 'addChatMessage', message = chatMsg})
end)

SetInterval(1, function()
    if chatOn then
        SetNuiFocus(true, true)
    end
end)

RegisterCommand('openchat', function()
    if chatOn then
        chatOn = false
        SetNuiFocus(false)
        SendNUIMessage({action = 'openChat'})
    else
        chatOn = true
        SetNuiFocus(true, true)
        SendNUIMessage({action = 'openChat'})
        local suggestions = {}
        for k,v in pairs(GetRegisteredCommands()) do
            table.insert(suggestions, {name = '/'..v.name, help = v.help})
        end
        SendNUIMessage({action = 'setSuggestions', suggestions = suggestions})
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

RegisterNUICallback('closeChat', function ()
    chatOn = false
    SetNuiFocus(false)
end)

local continuousMessagesSent = 0

Citizen.CreateThread(function ()
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
    if string.sub(data.message, 1, 1) == '/' then
        local args = {}
        for word in string.gmatch(data.message, '[^%s]+') do
            table.insert(args, word)
        end
        local command = string.gsub(args[1], '/', '')
        table.remove(args, 1)
        ExecuteCommand(command, args)
        return
    end
    if lastChatMsg == data.message then
        return
    else
        lastChatMsg = data.message
        if continuousMessagesSent >= 5 then
            TriggerEvent('chat:addMessage', { args = { "[^3SERVER^0]: Ai trimis prea multe mesaje, mai asteapta." } })
            return
        else
            continuousMessagesSent = continuousMessagesSent + 1
        end
        TriggerServerEvent('sv:chat:addMessage', data.message)
    end
end)

