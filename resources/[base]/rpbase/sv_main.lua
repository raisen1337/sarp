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
function SetInterval(ms, cb)
    local interval = ms
    local nextTime = GetGameTimer() + interval
    local active = true

    local function update()
        if not active then return end
        local time = GetGameTimer()
        if time >= nextTime then
            nextTime = time + interval
            cb()
        end
        SetTimeout(0, update)
    end

    SetTimeout(0, update)

    return {
        clear = function() active = false end
    }
end

Core.CreateCallback('Core:UpdatePlayerAmmo', function(source, cb, ammoTable)
    local PlayerAmmo = ammoTable
    local pAmmo = {}
    if not table.empty(PlayerAmmo) then

        local pData = Core.GetPlayerData(source)
        local Inventory = pData.inventory
        if not table.empty(Inventory) then
            for k, v in pairs(Inventory) do
                if v.type == 'ammo' then
                    if PlayerAmmo[v.name] then
                        table.insert(pAmmo, {name = v.name, amount = PlayerAmmo[v.name], type = 'ammo'})
                        PlayerAmmo = pAmmo
                    else
                        table.insert(pAmmo, {name = v.name, amount = v.amount, type = 'ammo'})
                        PlayerAmmo = pAmmo
                    end
                end
            end
            PlayerAmmo = pAmmo
            exports.oxmysql:execute('UPDATE players SET data = ? WHERE identifier = ?', {json.encode(pData), pData.identifier})
        end
    else
        --print('PlayerAmmo is empty')
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
        if targetped ~= ped and dist < 3.0 then
            cb(v)
            return
        end
       
        -- if GetPlayerPed(source) ~= targetped and dist < 3.0 then
        --     cb(v)
        --     return
        -- end
    end
    cb(false)
end)
local annoDelay = false
Core.CreateCallback('Police:AnnounceShooting', function(source, cb, zone, crossing)
    local players = GetPlayers()
    for k, v in pairs(players) do
        local pData = Core.GetPlayerData(v)
        local fData = pData.faction
        if factions[fData.name].type == 'lege' then
            if not annoDelay then
                annoDelay = true
                SetTimeout(5000, function()
                    annoDelay = false
                end)
            else
                return
            end
            TriggerClientEvent('Notify:Send', v, "Politie", 'Shots fired in '..zone..' near '..crossing)
            cb(true)
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

RegisterNetEvent('s:Player:Update', function(data)
    local src = source
    TriggerClientEvent('Player:Update', src, data)
end)

RegisterNetEvent("showPlayerNametags", function()
    local src = source
    TriggerClientEvent('txcl:showPlayerIDsd', src, true)
end)

Core.CreateCallback('Player:SetRouting', function(source, cb, routing)
    SetPlayerRoutingBucket(source, routing)
    cb(true)
end)

RegisterNetEvent('Vehicles:Insert', function(vehicle)
    table.insert(ServerVehicles, vehicle)
    for k,v in pairs(GetPlayers()) do
        TriggerClientEvent("Vehicles:Update", v, ServerVehicles)
    end
end)

RegisterNetEvent('Vehicles:Remove', function(key)
    table.remove(ServerVehicles, key)
    for k,v in pairs(GetPlayers()) do
        TriggerClientEvent("Vehicles:Update", v, ServerVehicles)
    end
end)

Core.CreateCallback('Vehicles:Get', function(source, cb)
    cb(ServerVehicles)
end)

Core.CreateCallback('Clothing:UpdateClothes', function(source, cb, data)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {GetPlayerSteamId(source)})

    local pData = json.decode(result[1].data)
    pData.clothing = data

    exports.oxmysql:executeSync('UPDATE players SET data = ? WHERE identifier = ?', {je(pData), pData.identifier})
    cb(true)
end)

Core.CreateCallback('Clothing:GetClothing', function(source, cb)
    local data = exports.oxmysql:executeSync("SELECT data FROM players WHERE identifier = ?", {GetPlayerSteamId(source)})
    
    local pData = json.decode(data[1].data)

    if not pData.clothing then
        pData.clothing = {}
    end
    if type(pData.clothing) ~= 'table' then pData.clothing = {} end
    cb(pData.clothing)
end)