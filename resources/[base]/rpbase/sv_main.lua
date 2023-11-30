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
                        if v.amount == PlayerAmmo[v.name] then return end
                        -- print('[F]PlayerAmmo['..v.name..'] = '..PlayerAmmo[v.name])
                        v.amount = PlayerAmmo[v.name]
                        exports.oxmysql:execute('UPDATE players SET data = ? WHERE identifier = ?', {json.encode(pData), pData.identifier})
                        TriggerClientEvent('Player:UpdateData', source, pData)
                        
                        return
                    else
                        -- print('[NF]PlayerAmmo['..v.name..'] = '..v.amount)
                        v.amount = PlayerAmmo[v.name]
                        exports.oxmysql:execute('UPDATE players SET data = ? WHERE identifier = ?', {json.encode(pData), pData.identifier})
                        TriggerClientEvent('Player:UpdateData', source, pData)
                        return
                    end
                end
            end
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

local playerACReports = {}
function ACBan(source)
    local src = source
    local banData = {
        banSource = src,
        banReason = 'Cheating/weird behaviour detected by anticheat.',
        banTime = 365,
    }
    local pData = Core.GetPlayerData(banData.banSource)
    local banId = generateBanId()
    
    pData.banned = 1
    pData.banId = banId
    pData.banReason = banData.banReason
    pData.banTime = banData.banTime
    pData.banTimestamp = getTimestampAfterDays(banData.banTime)
    pData.banAdmin = 'Anticheat'
    pData.banIds = {
        steamId = GetPlayerIds(banData.banSource).steamId,
        xbl = GetPlayerIds(banData.banSource).xbl,
        discord = GetPlayerIds(banData.banSource).discord,
        liveid = GetPlayerIds(banData.banSource).liveid,
        license = GetPlayerIds(banData.banSource).license,
        ip = GetPlayerIds(banData.banSource).ip,
        hwids = GetPlayerIds(banData.banSource).hashValues,
    }

    local punishment = {
        type = 'Ban',
        duration = banData.banTime,
        reason = banData.banReason,
        admin = GetPlayerName(source),
    }
    playerACReports[src] = nil

    if  pData.punishHistory then
        if table.empty(pData.punishHistory) then
            pData.punishHistory = {}
            table.insert(pData.punishHistory, punishment)
        end
    else
        pData.punishHistory = {}
        table.insert(pData.punishHistory, punishment)
    end

    
    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), pData.identifier})
    Wait(1000)
    TriggerClientEvent('Player:UpdateData', banData.banSource, pData)
    DropPlayer(banData.banSource, "You have been banned from the server. Reason: "..banData.banReason..". Ban ID: "..banId..". Ban expires in: "..banData.banTime.." days.")
end

local currentWeather = false
Core.CreateCallback('Server:GetWeather', function(source, cb)
    cb(currentWeather)
end)

Core.CreateCallback('Server:UnsyncVehicle', function(source, cb, vehicle)
    local src = source
    local players = GetPlayers()
    for k,v in pairs(players) do
        TriggerClientEvent('Client:UnsyncVehicle', v, vehicle)
    end
end)
-- SERVER script, requires OneSync!
function checkPlayerReports(source)
    local src = source
    if not playerACReports[src] then return end
    for k,v in pairs(playerACReports[src]) do
        if v.count > 3 then
            if os.time() < v.lastReport + 60 then
                print('[AC]Player '..GetPlayerName(src)..'('..src..')'..' has been detected by anticheat. Detection type: '..k..'! Count: '..v.count)
                local players = GetPlayers()
                for a,b in pairs(players) do
                    local pData = Core.GetPlayerData(b)
                    if pData.adminLevel > 0 then
                        TriggerClientEvent('chat:addMessage', b, {
                            args = { '^1[AC]: ^0Jucatorul ^1'..GetPlayerName(src)..'('..src..') ^0a fost detectat de anticheat. Detection type: ^1'..k..'!' }
                        })  
                    end
                end
                ACBan(src)
            end
        end
    end
end

AddEventHandler('explosionEvent', function(sender, ev)
    local src = sender
    print('[AC Explosion]Player '..GetPlayerName(src)..'('..src..')'..' has been detected by anticheat. Explosion type: '..ev.explosionType..'!')
    if not playerACReports[src] then
        playerACReports[src] = {}
        playerACReports[src][ev.explosionType] = {}
        playerACReports[src][ev.explosionType].count = 1
        playerACReports[src][ev.explosionType].lastReport = os.time()
    else
        if not playerACReports[src][ev.explosionType] then
            playerACReports[src][ev.explosionType] = {}
            playerACReports[src][ev.explosionType].count = 1
            playerACReports[src][ev.explosionType].lastReport = os.time()
        else
            playerACReports[src][ev.explosionType].count = playerACReports[src][ev.explosionType].count + 1
            playerACReports[src][ev.explosionType].lastReport = os.time()
        end
    end
    checkPlayerReports(src)
    CancelEvent()
end)

local weathers = {
    'EXTRASUNNY',
    'CLEAR',
    'CLOUDS',
    'SMOG',
    'FOGGY',
    'OVERCAST',
    'RAIN',
    'THUNDER',
    'CLEARING',
    'NEUTRAL',
    'SNOW',
    'BLIZZARD',
    'SNOWLIGHT',
    'XMAS',
}

Citizen.CreateThread(function()
    --pick a random weather every 10 minutes
    while true do
        local players = GetPlayers()
        local season = 'summer'
        local currentMonth = tonumber(os.date("%m"))
        local isWinter = false
        if currentMonth == 12 or currentMonth == 1 or currentMonth == 2 then
            isWinter = true
        end
        
        local randomWeather
        if isWinter then
            -- Increase chance of snowy weather in winter
            randomWeather = GetRandomWeatherWithIncreasedChance({'EXTRASUNNY', "SNOW", "SNOWLIGHT", 'BLIZZARD', 'XMAS', 'SMOG'}, 0.8)
            season = 'winter'
        else
            -- Normal random weather selection without snowy weathers
            local filteredWeathers = {}
            for i = 1, #weathers do
                if not string.find(weathers[i], "BLIZZARD") and not string.find(weathers[i], "XMAS") and not string.find(weathers[i], "SNOW") and not string.find(weathers[i], "SNOWLIGHT") then
                    table.insert(filteredWeathers, weathers[i])
                end
            end
            season = 'summer'
            randomWeather = filteredWeathers[math.random(1, #filteredWeathers)]
        end
        
        currentWeather = randomWeather
        
        for k, v in pairs(players) do
            TriggerClientEvent('Client:SyncSeason', v, season)
            TriggerClientEvent('Client:SyncWeather', v, randomWeather)
        end
        Wait(600000)
    end
end)



GetRandomWeatherWithIncreasedChance = function(weathers, chance)
    local random = math.random()
    if random <= chance then
        return weathers[math.random(1, #weathers)]
    else
        return weathers[math.random(1, #weathers)]
    end
end

function SyncWeatherAndSeason()
    Wait(4000)
    local players = GetPlayers()
    local season = 'summer'
    local currentMonth = tonumber(os.date("%m"))
    local isWinter = false
    if currentMonth == 12 or currentMonth == 1 or currentMonth == 2 then
        isWinter = true
    end
    
    local randomWeather
    if isWinter then
        -- Increase chance of snowy weather in winter
        randomWeather = GetRandomWeatherWithIncreasedChance({'EXTRASUNNY', "SNOW", "SNOWLIGHT", 'BLIZZARD', 'XMAS', 'SMOG'}, 0.8)
        season = 'winter'
    else
        -- Normal random weather selection without snowy weathers
        local filteredWeathers = {}
        for i = 1, #weathers do
            if not string.find(weathers[i], "BLIZZARD") and not string.find(weathers[i], "XMAS") and not string.find(weathers[i], "SNOW") and not string.find(weathers[i], "SNOWLIGHT") then
                table.insert(filteredWeathers, weathers[i])
            end
        end
        season = 'summer'
        randomWeather = filteredWeathers[math.random(1, #filteredWeathers)]
    end
    
    currentWeather = randomWeather
    
    for k, v in pairs(players) do
        TriggerClientEvent('Client:SyncSeason', v, season)
        TriggerClientEvent('Client:SyncWeather', v, randomWeather)
    end
end

SyncWeatherAndSeason()


Core.CreateCallback('Server:SetWeather', function (source, cb, weather)
    currentWeather = weather
    local players = GetPlayers()
    for k, v in pairs(players) do
        TriggerClientEvent('Client:SyncWeather', v, weather)
    end
    cb(true)
end)

Core.CreateCallback('Server:SyncWeather', function (source, cb)
    local players = GetPlayers()
    if not currentWeather then
        currentWeather = 'EXTRASUNNY'
    end
    for k, v in pairs(players) do
        TriggerClientEvent('Client:SyncWeather', v, currentWeather)
    end
    cb(currentWeather)
end)

Core.CreateCallback('AC:ReportAnomaly', function(source, cb, type)
    local src = source
    print('[AC]Player '..GetPlayerName(src)..'('..src..')'..' has been detected by anticheat. Detection type: '..type..'!')
    if not playerACReports[src] then
        playerACReports[src] = {}
        playerACReports[src][type] = {}
        playerACReports[src][type].count = 1
        playerACReports[src][type].lastReport = os.time()
    else
        if not playerACReports[src][type] then
            playerACReports[src][type] = {}
            playerACReports[src][type].count = 1
            playerACReports[src][type].lastReport = os.time()
        else
            playerACReports[src][type].count = playerACReports[src][type].count + 1
            playerACReports[src][type].lastReport = os.time()
        end
    end
    checkPlayerReports(src)
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
    TriggerClientEvent('Player:UpdateData', source, pData)

    cb(true)
end)

Core.CreateCallback('Clothing:GetClothing', function(source, cb)
    local data = exports.oxmysql:executeSync("SELECT data FROM players WHERE identifier = ?", {GetPlayerSteamId(source)})
    if data[1] then
        local pData = json.decode(data[1].data)

        if not pData.clothing then
            pData.clothing = {}
        end
        if type(pData.clothing) ~= 'table' then pData.clothing = {} end
        cb(pData.clothing)
    end
    
end)