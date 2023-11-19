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

Core.GetFactions = function()
    return factions
end

Core.CreateCallback('Core:UpdatePlayerAmmo', function(source, cb, ammoTable)
    local PlayerAmmo = ammoTable

    if not table.empty(PlayerAmmo) then
        local pData = Core.GetPlayerData(source)
        local Inventory = pData.inventory

        if not table.empty(Inventory) then
            for k, v in pairs(Inventory) do
                if v.type == 'ammo' then
                    if v.name == 'pistol_ammo' then
                        v.amount = ammoTable['pistol_ammo']
                        pData.inventory = Inventory
                        --print
                    elseif v.name == 'smg_ammo' then
                        v.amount = ammoTable['smg_ammo']
                        pData.inventory = Inventory
                        --print
                    elseif v.name == 'rifle_ammo' then
                        v.amount = ammoTable['rifle_ammo']
                        pData.inventory = Inventory
                        --print
                    elseif v.name == 'shotgun_ammo' then
                        v.amount = ammoTable['shotgun_ammo']
                        pData.inventory = Inventory
                        --print
                    end
                end
            end
            exports.oxmysql:execute('UPDATE players SET data = ? WHERE identifier = ?', {json.encode(pData), pData.identifier})
        end
    end
    
end)

Core.CreateCallback('Core:IsOnline', function(source, cb, id)
    local players = GetPlayers()
    local isOnline = false
    for k, v in pairs(players) do
        if tonumber(v) == tonumber(id) then
            isOnline = true
            cb(isOnline)
            return
        end
    end
    cb(isOnline)
end)

Core.CreateCallback('Core:GetNearestPlayer', function (source, cb)
    local ped = GetPlayerPed(source)
    local pos = GetEntityCoords(ped)

    local players = GetPlayers()
    for k, v in pairs(players) do
        local targetped = GetPlayerPed(v)
        local targetPos = GetEntityCoords(targetped)
        local dist = #(pos - targetPos)
        if GetPlayerPed(source) ~= targetped and dist < 3.0 then
            cb(v)
            return
        end
    end
end)



Core.CreateCallback('AC:ReportAnomaly', function(source, cb, type)
    local src = source
    if type == 'vehicle' then
        print('Player '..GetPlayerName(src)..'(' .. src .. ') has been detected in a unregistered vehicle! (Maybe hacker).')
    end
    if type == 'weapon' then
        print('Player '..GetPlayerName(src)..'(' .. src .. ') has been detected with an unregistered weapon! (Maybe hacker).')
    end
    if type == 'ammo' then
        print('Player '..GetPlayerName(src)..'(' .. src .. ') has been detected with an more weapon ammo than it should! (Maybe hacker).')
    end
    if type == 'rstop' then
        print('Player '..GetPlayerName(src)..'(' .. src .. ') has stopped a resource! (Maybe hacker).')
    end
    cb(true)
end)

Core.CreateCallback('Core:GetPlayerAmmo', function(source, cb)
    local pData = Core.GetPlayerData(source)
    local Inventory = pData.inventory
    local pAmmo = {}
    if not table.empty(Inventory) then
        for k, v in pairs(Inventory) do
            if v.type == 'ammo' then
                pAmmo[v.name] = v.amount
            end
        end
    end
    cb(pAmmo)
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

