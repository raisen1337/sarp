RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')


local Core = exports['rpbase']:InitCore()

AddEventHandler('_chat:messageEntered', function(author, color, message)
    local src = source
    local tags = {}
    local msg = ""
    if not message or not author then
        return
    end
    local pData = Core.GetPlayerData(src)

    TriggerEvent('chatMessage', src, "", msg)

    if not WasEventCanceled() then

        if pData.adminLevel > 0 then
            table.insert(tags, {
                text = "^3[Admin "..pData.adminLevel.."]",
            })
        end

        if pData.faction then
            local fData = pData.faction
            local factions = Core.GetFactions()
            table.insert(tags, {
                text = ""..factions[fData.name].color.."["..factions[fData.name].name.."]^0 ",
            })
        end

        for _, tag in ipairs(tags) do
            msg = msg .. tag.text .. " "
        end

        msg = msg .. author .. "("..src.."): " .. message
        if pData.muted then
            TriggerClientEvent('chatMessage', src, "", { 255, 255, 255 }, "[^3SERVER^0]: Ai mute, nu poti vorbii.")
            return
        else
            TriggerClientEvent('chatMessage', -1, "",  { 255, 255, 255 }, msg)
        end
    end
end)


AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    local registeredCommands = GetRegisteredCommands()
    for _, cmd in pairs(registeredCommands) do
        if cmd.name ~= command then
            break
        end
    end
    CancelEvent()
end)


-- command suggestions for clients
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

AddEventHandler('chat:init', function()
    refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)
