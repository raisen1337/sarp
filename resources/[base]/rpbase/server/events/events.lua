RegisterNetEvent('Core:Server:TriggerCallback', function(name, ...)
    local src = source
    Core.TriggerCallback(name, src, function(...)
        TriggerClientEvent('Core:Client:TriggerCallback', src, name, ...)
    end, ...)
end)

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

    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {steamIdentifier})
    local pData = json.decode(result[1].data)

    pData.position = playerCoords

    TriggerEvent("Player:Save", json.encode(pData))
end)