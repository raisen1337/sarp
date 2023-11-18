Core.CreateCallback("Business:Create", function(source, cb, data)
    local result = exports.oxmysql:executeSync('SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = "businesses"')
    if result[1] then
        local nextAutoIncrement = result[1]['AUTO_INCREMENT']
        data.id = nextAutoIncrement
    else
        data.id = 1
    end

    exports.oxmysql:query("INSERT INTO businesses(owner, data) VALUES(?, ?)", {'The State', json.encode(data)}, function(error, result)
        if not error then
            cb(true)
        else
            cb(error)
        end
    end)
end)

RegisterNetEvent('Business:RequireUpdate', function()
    local src = source
    for k,v in pairs(GetPlayers()) do
        TriggerClientEvent("Business:Update", v)
    end
end)

Core.CreateCallback("Business:LoadAll", function(source, cb)
    exports.oxmysql:query("SELECT * FROM businesses", function(error, result)
        if not error then
            cb(result)
        else
            cb(error)
        end
    end)
end)

Core.CreateCallback('Business:Get', function (source, cb)
    local result = exports.oxmysql:executeSync("SELECT * FROM businesses")
    if #result > 0 then
        cb(result)
    else
        cb(false)
    end
end)

Core.CreateCallback("Business:Delete", function(source, cb, id)
    print(id)
    exports.oxmysql:query("DELETE FROM businesses WHERE id = ?", {id}, function(error, result)
        if not error then
            cb(true)
        else
            cb(error)
        end
    end)
end)



Core.CreateCallback("Business:EditBusiness", function(source, cb, id, modification, data)
    print(id)
    local bData = exports.oxmysql:executeSync("SELECT * FROM businesses WHERE id = ?", {id})
    bData = jd(bData[1].data)
    if bData[modification] then
        bData[modification] = data

        exports.oxmysql:query("UPDATE businesses SET data = ? WHERE id = ?", {je(bData), id}, function(error, result)
            if not error then
                cb(true)
            else
                cb(error)
            end
        end)
    else
        cb(false)
    end
end)

Core.CreateCallback("Business:LoadById", function(source, cb, id)
    exports.oxmysql:query("SELECT * FROM businesses WHERE id = ?", {id}, function(error, result)
        if not error then
            cb(result)
        else
            cb(error)
        end
    end)
end)