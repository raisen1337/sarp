local callbackCalls = {}
RegisterNetEvent('Core:Server:TriggerCallback', function(name, ...)
    local src = source
    if callbackCalls[src] == nil then
        callbackCalls[src] = {}
    end
    if callbackCalls[src][name] == nil then
        callbackCalls[src][name] = 0
    end
    if callbackCalls[src][name] < 6 then
        if callbackCalls[src][name] + 1 >= 6 then
            -- print('Callback limit reached for ' .. GetPlayerName(src) .. ' (' .. src .. ')' .. ' for callback ' .. name)
            callbackCalls[src][name] = 6
            return
        end
        Core.TriggerCallback(name, src, function(...)
            callbackCalls[src][name] = callbackCalls[src][name] + 1
            TriggerClientEvent('Core:Client:TriggerCallback', src, name, ...)
        end, ...)
    end
end)

Citizen.CreateThread(function ()
    while true do
        for k,v in pairs(callbackCalls) do
            for k2,v2 in pairs(v) do
                if v2 >= 6 then
                    callbackCalls[k][k2] = nil
                    -- print('Callback limit reset for ' .. GetPlayerName(k) .. ' (' .. k .. ')' .. ' for callback ' .. k2)
                end
            end
        end
        Wait(10000)
    end
end)
function flattenTable(inputTable)
    local function isTableEmpty(tbl)
        return next(tbl) == nil
    end

    local function flattenHelper(tbl, prefix)
        local flat = {}
        for k, v in pairs(tbl) do
            local key = prefix ~= "" and (prefix .. "." .. k) or k
            if type(v) == "table" and not isTableEmpty(v) then
                local nested = flattenHelper(v, key)
                for nestedKey, nestedValue in pairs(nested) do
                    flat[nestedKey] = nestedValue
                end
            else
                flat[key] = v
            end
        end
        return flat
    end

    return flattenHelper(inputTable, "")
end
-- RegisterCommand('testsave', function(source, args, rawCommand)
--     local player = source
--     local ped = GetPlayerPed(player)
--     local playerCoords = GetEntityCoords(ped)

--     local steamIdentifier = nil
--     local identifiers = GetPlayerIdentifiers(player)
--     for k,v in pairs(GetPlayerIdentifiers(player))do
    
--         if string.sub(v, 1, string.len("steam:")) == "steam:" then
--             steamIdentifier = v
--         end
        
--     end

--     local data = exports.oxmysql:executeSync("SELECT data FROM players WHERE identifier = ?", {steamIdentifier})
--     local pData = data[1].data
--     pData = json.decode(pData)

--     pData.position = playerCoords
    
--     exports.oxmysql:query("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), steamIdentifier})
--     TriggerClientEvent('Player:UpdateData', source, pData)

-- end)

AddEventHandler('playerDropped', function (reason)
    local player = source
    local ped = GetPlayerPed(player)
    local playerCoords = GetEntityCoords(ped)

    local steamIdentifier = nil
    local identifiers = GetPlayerIdentifiers(player)
    for k,v in pairs(GetPlayerIdentifiers(player))do
    
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamIdentifier = v
        end
        
    end

    local data = exports.oxmysql:executeSync("SELECT data FROM players WHERE identifier = ?", {steamIdentifier})
    local pData = data[1].data
    pData = json.decode(pData)

    pData.position = playerCoords
    
    exports.oxmysql:query("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), steamIdentifier})
    TriggerClientEvent('Player:UpdateData', player, pData)

end)