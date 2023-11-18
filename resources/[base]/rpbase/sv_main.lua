Core = {}
Core.ServerCallbacks = {}
ServerVehicles = {}

function Core.CreateCallback(name, cb)
    Core.ServerCallbacks[name] = cb
end

function Core.TriggerCallback(name, source, cb, ...)
    if not Core.ServerCallbacks[name] then return end
    Core.ServerCallbacks[name](source, cb, ...)
end

exports('InitCore', function()
    return Core
end)

RegisterNetEvent("showPlayerNametags", function()
    local src = source
    TriggerClientEvent('txcl:showPlayerIDsd', src, true)
end)

RegisterNetEvent('Vehicles:Insert', function(vehicle)
    table.insert(ServerVehicles, vehicle)
    TriggerClientEvent("Vehicles:Update", source, ServerVehicles)
end)

RegisterNetEvent('Vehicles:Remove', function(key)
    table.remove(ServerVehicles, key)
    TriggerClientEvent("Vehicles:Update", source, ServerVehicles)
end)

Core.CreateCallback('Vehicles:Get', function(source, cb)
    cb(ServerVehicles)
end)

