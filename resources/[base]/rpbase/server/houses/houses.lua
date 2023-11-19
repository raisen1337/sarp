

local housesTypes = {
    ["Normal"] = {
        shellObject = "furnitured_midapart",
        exit = vector3(1.350, -10.079, -18.94013),
        level = 3,
    },
    ['Low'] = {
        shellObject = 'shell_trailer',
        exit = vector3(-1.410, -2.052, -17.09571),
        level = 1,
    },
    ['Medium'] = {
        shellObject = "standardmotel_shell",
        exit = vector3(-0.255, -2.364, -18.99078),
        level = 2,
    }
}

Core.CreateCallback('Houses:Get', function (source, cb)
    local result = exports.oxmysql:executeSync("SELECT * FROM houses")
    if #result > 0 then
        cb(result)
    else
        cb(false)
    end
end)

Core.CreateCallback('Houses:DeleteHouse', function(source, cb, id)
    --print
    local result = exports.oxmysql:executeSync('DELETE FROM houses WHERE id = ?', {id})
    print(je(result))
    cb(true)
end)

Core.CreateCallback('Houses:SellHouseToPlayer', function(source, cb, selldata)
    local sellPlayerId = GetPlayerSteamId(selldata.pid)

    if not sellPlayerId then
        return
    end

    local src = source
    local playerId = GetPlayerSteamId(src)

    local sellPlayerResult = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {sellPlayerId})
    local playerData = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {playerId})
    local houseData = exports.oxmysql:executeSync("SELECT * FROM houses WHERE id = ?", {selldata.sellhouse})
    
    local spData = json.decode(sellPlayerResult[1].data)
    local pData = json.decode(playerData[1].data)

    local hData = json.decode(houseData[1].data)

    if not spData.transactionsActive then
        local cbInfo = {
            success = false,
            msg = "Jucatorul are tranzactiile oprite.",
        }
        cb(cbInfo)
        TriggerClientEvent("Notify:Send", selldata.pid, "Casa", "Jucatorul "..GetPlayerName(src).." a incercat sa-ti vanda casa lui, dar ai tranzactiile oprite! Foloseste /tog pentru a le pornii!", 'error')
        return
    end
    if spData.transactionsActive then
        spData.transactionsActive = false

        exports.oxmysql:query("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(spData), sellPlayerId})
        
        sellPlayerResult = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {sellPlayerId})
        spData = json.decode(sellPlayerResult[1].data)

        TriggerClientEvent("Notify:Send", selldata.pid, "Casa", "Jucatorul "..GetPlayerName(src).." a incercat sa-ti vanda casa lui pentru suma de: $"..selldata.price.."! Tranzactiile ti-au fost oprite automat, ai 15 secunde sa le pornesti daca esti deacord ca tranzactia sa decurga.", 'error')
        TriggerClientEvent("Notify:Send", src, "Casa", "Se asteapta raspunsul jucatorului "..GetPlayerName(selldata.pid)..'..', 'error')

        TriggerClientEvent('Players:TransactionsTog', selldata.pid)

        Wait(15000)

        if not spData.transactionsActive then
            TriggerClientEvent("Notify:Send", selldata.pid, "Casa", "Tranzactia nu a decurs deoarece nu ti-ai pornit tranzactiile.", 'error')
            TriggerClientEvent("Notify:Send", src, "Casa", "Jucatorul "..GetPlayerName(selldata.pid)..' a refuzat tranzactia.', 'error')
            return
        end

        if spData.cash >= selldata.price then
            spData.cash = spData.cash - selldata.price
            if spData.rentedHouse == selldata.sellhouse then
                spData.rentedHouse = 0
                spData.rentValue = 0
               
                for k,v in pairs(hData.tenants) do
                   if v.tenantId == sellPlayerId then
                        table.remove(hData.tenants, k)
                   end 
                end
            end
            hData.owner = GetPlayerName(selldata.pid)
            hData.ownerId = sellPlayerId
            local cbInfo = {
                success = true,
                msg = "",
            }
            TriggerClientEvent("Notify:Send", selldata.pid, "Casa", "Ai cumparat casa de la "..GetPlayerName(src).." cu success!", 'success')
            TriggerClientEvent("Notify:Send", selldata.pid, "Casa", "Tranzactiile ti-au fost oprite deoarece ai realizat o tranzactie. Foloseste /tog pentru a le reactiva.", 'success')
           
            spData.transactionsActive = false
            exports.oxmysql:query("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(spData), sellPlayerId})
            exports.oxmysql:query("UPDATE houses SET data = ?, owner = ? WHERE id = ?", {json.encode(hData), sellPlayerId, selldata.sellhouse})
            for k,v in pairs(GetPlayers()) do
                TriggerClientEvent("Houses:Update", v)
            end
            cb(cbInfo)
        else
            local cbInfo = {
                success = false,
                msg = "Jucatorul nu are suficienti bani.",
            }
            cb(cbInfo)
            TriggerClientEvent("Notify:Send", selldata.pid, "Casa", "Nu ai suficienti bani pentru a cumpara casa de la "..GetPlayerName(src).."!", 'error')
        end
    end
    

end)

RegisterNetEvent("Houses:RequireUpdate", function()
    for k,v in pairs(GetPlayers()) do
        TriggerClientEvent("Houses:Update", v)
    end
end)

RegisterNetEvent("Houses:Save", function(house)
    local src = source
    local hData = json.decode(house.data)

    exports.oxmysql:query('UPDATE houses SET owner = ?, data = ? WHERE id = ?', {hData.ownerId, json.encode(hData), house.id})

    for k,v in pairs(GetPlayers()) do
        TriggerClientEvent("Houses:Update", v)
    end
end)

Core.CreateCallback("Houses:GetHouseById", function(source, cb, hid)
    local result = exports.oxmysql:executeSync("SELECT * FROM houses WHERE id = ?", {hid})
    if #result > 0 then
        cb(result[1])
    else
        cb(false)
    end
end)
function table.empty (self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end

Core.CreateCallback("Houses:IsTenant", function(source, cb, hid)
    local src = source
    local result = exports.oxmysql:executeSync("SELECT * FROM houses WHERE id = ?", {hid.id})

    local hData = json.decode(result[1].data)

    local tenants = hData.tenants
    
    local isTenant = false

    if not table.empty(tenants) then
        for k,v in pairs(tenants) do
            if v.tenantId ~= GetPlayerSteamId(src) then
                isTenant = false
            else
                isTenant = true
            end
        end
    else
        isTenant = false
    end
    cb(isTenant)
end)

Core.CreateCallback('Houses:GetHouseTenants', function(source, cb, house)
    local src = source
    local result = exports.oxmysql:executeSync("SELECT * FROM houses WHERE id = ?", {house.id})

    local hData = json.decode(result[1].data)

    local tenants = hData.tenants
    cb(tenants)
end)

RegisterNetEvent("Houses:RemoveTenant", function(house)
    local src = source
    local result = exports.oxmysql:executeSync("SELECT * FROM houses WHERE id = ?", {house.id})

    local player = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {GetPlayerSteamId(src)})

    local pData = json.decode(player[1].data)

    pData.rentedHouse = 0;

    local hData = json.decode(result[1].data)

    local tenants = hData.tenants
    
    local isTenant = false

    if not table.empty(tenants) then
        for k,v in pairs(tenants) do
            if v.tenantId == GetPlayerSteamId(src) then
                table.remove(tenants, k)
            end
        end
    end

    exports.oxmysql:query("UPDATE houses SET data = ? WHERE id = ?", {json.encode(hData), house.id})
    exports.oxmysql:query("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), GetPlayerSteamId(src)})
    
end)



Core.CreateCallback("Houses:GetRentedHouse", function(source, cb)
    local src = source
    local result = exports.oxmysql:executeSync("SELECT * FROM houses")

    local rentedHouse = false

    for k, v in pairs(result) do
        local hData = json.decode(v.data)
        local tenants = hData.tenants

        for _, tenant in pairs(tenants) do
            if tenant.tenantId == GetPlayerSteamId(src) then
                rentedHouse = v
            end
        end
    end
    cb(rentedHouse)
end)

RegisterNetEvent("Houses:AddTenant", function(house)
    local src = source
    local result = exports.oxmysql:executeSync("SELECT * FROM houses WHERE id = ?", {house.id})

    local hData = json.decode(result[1].data)

    local tenants = hData.tenants

    table.insert(tenants, {
        name = GetPlayerName(src),
        tenantId = GetPlayerSteamId(src)
    })

    exports.oxmysql:query("UPDATE houses SET data = ? WHERE id = ?", {json.encode(hData), house.id})
    
end)

Core.CreateCallback('Houses:GetOwnedById', function(source, cb, id)
    local src = source
    local result = exports.oxmysql:executeSync("SELECT * FROM houses WHERE owner = ?", {GetPlayerSteamId(id)})
    
    cb(result)
end)


Core.CreateCallback('Houses:GetOwnedByPlayer', function(source, cb)
    local src = source
    local result = exports.oxmysql:executeSync("SELECT * FROM houses WHERE owner = ?", {GetPlayerSteamId(src)})
    
   
    cb(result)

end)

Core.CreateCallback("Houses:IsOwner", function(source, cb, house)
    local src = source
    local result = exports.oxmysql:executeSync("SELECT * FROM houses WHERE id = ?", {house.id})
    local hData = json.decode(result[1].data)
    if hData.ownerId == GetPlayerSteamId(src) then
        cb(true)
    else
        cb(false)
    end
end)

Core.CreateCallback("Houses:GetTypes", function(source, cb)
    cb(housesTypes)
end)

RegisterNetEvent("Houses:Create", function(data)
    local result = exports.oxmysql:executeSync('SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = "houses"')
    if result[1] then
        local nextAutoIncrement = result[1]['AUTO_INCREMENT']
        data.id = nextAutoIncrement
        data.name = "Casa #"..data.id
    else
        data.id = 1
        data.name = "Casa #"..data.id
    end

    exports.oxmysql:query("INSERT INTO houses(owner, data) VALUES (?, ?)", {"The State", json.encode(data)})
end)

RegisterNetEvent("Houses:Sell", function(house)
    local src = source
    local hData = json.decode(house.data)

    hData.ownerId = 0
    hData.owner = "The State"
    hData.locked = false

    exports.oxmysql:query('UPDATE houses SET owner = ?, data = ? WHERE id = ?', {hData.owner, json.encode(hData), house.id})

    for k,v in pairs(GetPlayers()) do
        TriggerClientEvent("Houses:Update", v)
    end
end)

RegisterNetEvent("Houses:RemoveTenantById", function(tenantId, house)
    local src = source
    local result = exports.oxmysql:executeSync("SELECT * FROM houses WHERE id = ?", {house})

    local player = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {tenantId})

    local pData = json.decode(player[1].data)

    pData.rentedHouse = 0;

    local hData = json.decode(result[1].data)

    local tenants = hData.tenants
    
    local isTenant = false

    if not table.empty(tenants) then
        for k,v in pairs(tenants) do
            if v.tenantId == tenantId then
                table.remove(tenants, k)
            end
        end
    end

    exports.oxmysql:query("UPDATE houses SET data = ? WHERE id = ?", {json.encode(hData), house})
    exports.oxmysql:query("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), tenantId})

    for k,v in pairs(GetPlayers()) do
        TriggerClientEvent("Houses:Update", v)
    end
    
end)

RegisterNetEvent("Houses:Buy", function(house)
    local src = source
    local hData = json.decode(house.data)

    hData.ownerId = GetPlayerSteamId(src)
    hData.owner = GetPlayerName(src)

    exports.oxmysql:query('UPDATE houses SET owner = ?, data = ? WHERE id = ?', {hData.ownerId, json.encode(hData), house.id})

    for k,v in pairs(GetPlayers()) do
        TriggerClientEvent("Houses:Update", v)
    end
end)