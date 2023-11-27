Core.CreateCallback('Dealership:GetConfig', function(source, cb)
    cb(json.encode(dealershipConfig))
end)

function GetPlayerSteamId(source)
    local src = source
    local steamIdentifier = nil
    local identifiers = GetPlayerIdentifiers(src)

    for k, v in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamIdentifier = v
        end
    end
    return steamIdentifier
end

function GetPlayerIds(source)
    local playerdata = {
        steamId = false,
        license = false,
        discordId = false,
        xboxLiveId = false,
        liveId = false,
        ip = false,
        hashValues = {}
    }

    local identifiers = GetPlayerIdentifiers(source)

    for _, identifier in ipairs(identifiers) do
        if string.sub(identifier, 1, string.len("steam:")) == "steam:" then
            playerdata.steamId = identifier
        elseif string.sub(identifier, 1, string.len("license:")) == "license:" then
            playerdata.license = identifier
        elseif string.sub(identifier, 1, string.len("xbl:")) == "xbl:" then
            playerdata.xbl = identifier
        elseif string.sub(identifier, 1, string.len("ip:")) == "ip:" then
            playerdata.ip = identifier
        elseif string.sub(identifier, 1, string.len("discord:")) == "discord:" then
            playerdata.discord = identifier
        elseif string.sub(identifier, 1, string.len("live:")) == "live:" then
            playerdata.live = identifier
        else
            if identifier ~= nil then
                table.insert(playerdata.hashValues, identifier)
            end
        end
    end

    local hwids = {}

    for i = 1, GetNumPlayerTokens(source) do
        local token = GetPlayerToken(source, i)
        if token ~= nil then
            table.insert(hwids, token)
        end
    end

    if #hwids > 0 then
        table.insert(playerdata.hashValues, hwids)
    end

    return playerdata
end

Core.CreateCallback("Dealership:BuyCar", function(source, cb, car)
    local src = source

    local steamIdentifier = nil
    local identifiers = GetPlayerIdentifiers(src)

    for k, v in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamIdentifier = v
        end
    end
    
    local carData = {
        name = car.name,
        spawncode = car.spawncode,
        plate = car.plate,
        owner = steamIdentifier,
        mods = car.mods,
        addons = {}
    }

    carData = json.encode(carData)
    exports.oxmysql:query("INSERT INTO vehicles(name, owner, plate, data) VALUES(?, ?, ?, ?)",{ car.name, steamIdentifier, car.plate, carData })
    cb(true)
end)

RegisterNetEvent('Vehicles:Save', function(vData)
    exports.oxmysql:query("UPDATE vehicles SET data = ? WHERE plate = ?", {json.encode(vData), vData.plate})
end)

Core.CreateCallback('Plates:Check', function(source, cb, plate)
    local exists = false
    local result = exports.oxmysql:executeSync("SELECT * FROM vehicles WHERE plate = ?", {plate})
    cb(#result)
end)

Core.CreateCallback('Server:AddSaleVehicle', function (source, cb, name, model, price)
    local vehicle = {
        name = name,
        model = model,
        price = price,
    }
    exports.oxmysql:query("INSERT INTO sale_vehicles(data) VALUES(?)", {je(vehicle)})
    Wait(500)
    cb(Core.GetSaleVehicles())
end)

Core.GetSaleVehicles = function()
    local vehicles = {}
    local result = exports.oxmysql:executeSync('SELECT * FROM sale_vehicles')
    if result[1] then
        for k, v in pairs(result) do
            local data = json.decode(v.data)
            table.insert(vehicles, data)
        end
    end
    return vehicles
end

Core.CreateCallback('Server:GetSaleVehicles', function(source, cb)
    cb(Core.GetSaleVehicles())
end)


RegisterNetEvent("Vehicles:ChangePlate", function(oldplate, newplate)
    local src = source
    local result = exports.oxmysql:executeSync("SELECT * FROM vehicles WHERE plate = ?", {oldplate})
    local result2 = exports.oxmysql:executeSync("SELECT * FROM vehicles WHERE plate = ?", {newplate})
    if result2[1] then
        TriggerClientEvent('Notify:Send', src, "Eroare", 'Exista deja o masina cu acest numar de inmatriculare!', 'error')
        return
    end
    if not result[1] then
        return
    else
        local vData = json.decode(result[1].data)
        vData.plate = newplate
        exports.oxmysql:executeSync("UPDATE vehicles SET plate = ? WHERE plate = ?", {newplate, oldplate})
        exports.oxmysql:executeSync("UPDATE vehicles SET data = ? WHERE plate = ?", {json.encode(vData), newplate})
    end
end)

Core.CreateCallback('Core:GetVehicleMods', function(source, cb, plate)
    local mods = false
    local result = exports.oxmysql:executeSync("SELECT * FROM vehicles WHERE plate = ?", {plate})
    if result[1] then
        local vData = json.decode(result[1].data)
        if vData.mods then
            mods = vData.mods
        end
    end
  
    cb(mods)
end)

GeneratePlate = function()
    local plate = 'LS '..math.random(10000, 99999)
    local result = exports.oxmysql:executeSync("SELECT * FROM vehicles WHERE plate = ?", {plate})
    if not result[1] then
        return plate
    else
        GeneratePlate()
        return
    end
end

Core.CreateCallback('Dealership:GeneratePlate', function(source, cb)
    local plate = GeneratePlate()
    cb(plate)
end)

Core.CreateCallback("Player:GetVehiclesById", function(source, cb, id)
    local src = id

    local steamIdentifier = GetPlayerSteamId(src)

    local result = exports.oxmysql:executeSync("SELECT * FROM vehicles WHERE owner = ?", {steamIdentifier})
    if result[1] then
        cb(result)
    else
        cb(false)
    end
end)

Core.CreateCallback("Player:GetVehicles", function(source, cb)
    local src = source

    local steamIdentifier = GetPlayerSteamId(src)

    local result = exports.oxmysql:executeSync("SELECT * FROM vehicles WHERE owner = ?", {steamIdentifier})
    if result[1] then
        cb(result)
    else
        cb(false)
    end
end)


