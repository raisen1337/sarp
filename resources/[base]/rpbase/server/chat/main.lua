RegisterNetEvent('sv:chat:addMessage', function(message)
    print(message)
    local src = source
    local pData = Core.GetPlayerData(src)
    local chatMsg = ''
    local finalChatMsg = ''
    local tags = {}
    if type(message) == 'table' then
        local chatMsgs = message.args
        for k,v in pairs(chatMsgs) do
            chatMsg = chatMsg .. ' ' .. v
        end
    else
        chatMsg = message
    end

    finalChatMsg = ' '..GetPlayerName(src)..': '..chatMsg
    if string.sub(chatMsg, 1, 1) == '/' then
        local args = {}
        for word in string.gmatch(chatMsg, '[^%s]+') do
            table.insert(args, word)
        end
        local command = string.gsub(args[1], '/', '')
        table.remove(args, 1)
    end
    if pData.muted then
        TriggerClientEvent('chat:addMessage', src, { args = { "[^3SERVER^0]: Ai mute, nu poti vorbii." } })
        return
    end

    

    if pData.faction then
        local fData = pData.faction
        local factions = Core.GetFactions()
        if factions[fData.name] then
            table.insert(tags, {
                text = ""..factions[fData.name].color.."[^0"..factions[fData.name].name..""..factions[fData.name].color.."]^0 ",
                type = 'faction',
                index = 0
            })
        end
    end
    local admTag = ''
    if pData.adminLevel > 0 then
        for k,v in pairs(tags) do
            if v.type == 'faction' then
                admTag = "^1[^0A^1]^0 "
            else
                admTag = "^1[^0ADMIN^1]^0 "
            end
        end
    end
    
    table.insert(tags, {
        text = admTag,
        type = 'admin',
        index = 1,
    })
    
    table.sort(tags, function(a, b) return a.index > b.index end)


    for _, tag in ipairs(tags) do
        finalChatMsg = tag.text .. " "..finalChatMsg
    end

    TriggerClientEvent('chat:addMessage', -1, { args = { finalChatMsg } })
end)

Core.CreateCallback('Chat:GetSuggestions', function (source, cb)
    
    for k,v in pairs(GetRegisteredCommands()) do
        table.insert(suggestions, {name = '/'..v.name, help = v.help})
    end
    cb(suggestions)
end)

local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end


AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)