Core.CreateCallback('Core:GetPlayers', function(source, cb)
    local players = {}
    for k,v in pairs(GetPlayers()) do
        table.insert(players, {
            name = GetPlayerName(v),
            source = v
        })
    end
    cb(players)
end)

generateBankId = function()
    local banId = math.random(100000, 999999)
    local result = exports.oxmysql:executeSync('SELECT * FROM players')
    for k, v in pairs(result) do
        local pData = json.decode(v.data)
        if pData.bankId == banId then
            generateBankId()
        else
            return banId
        end
    end
end


generateBanId = function()
    local banId = ""..math.random(1000, 9999).."-"..math.random(10000, 99999)..''
    local result = exports.oxmysql:executeSync('SELECT * FROM players')
    for k, v in pairs(result) do
        local pData = json.decode(v.data)
        if pData.banId == banId then
            generateBanId()
        else
            return banId
        end
    end
end

Core.CreateCallback("Admin:HandleKick", function(source, cb, kickData)
    local pData = Core.GetPlayerData(kickData.kickSource)

    local punishment = {
        type = 'Kick',
        reason = kickData.kickReason,
        admin = GetPlayerName(source),
    }

    Wait(1000)
    Core.InsertPunishment(kickData.kickSource, punishment)

    --DropPlayer(kickData.kickSource, "You have been kick from this server by admin: "..GetPlayerName(source).." with reason: "..kickData.kickReason.."!")
    cb(true)
end)

Core.CreateCallback('Admin:UpdateVehicleData', function(source, cb, vData)
    exports.oxmysql:executeSync("UPDATE vehicles SET owner = ? WHERE id = ?", {vData.owner, vData.id})
    exports.oxmysql:executeSync("UPDATE vehicles SET data = ? WHERE id = ?", {json.encode(vData), vData.id})
    cb(true)
end)

Core.CreateCallback('Admin:RemoveOwnedVehicle', function(source, cb, plate)
    exports.oxmysql:executeSync("DELETE FROM vehicles WHERE plate = ?", {plate})
    cb(true)
end)

Core.CreateCallback('Core:GetPlayerCoords', function(source, cb, id)
    cb(GetEntityCoords(GetPlayerPed(id)))
end)

Core.CreateCallback('Admin:ChangeHouseData', function(source, cb, hData)
    exports.oxmysql:executeSync("UPDATE houses SET owner = ? WHERE id = ?", {hData.owner, hData.id})
    exports.oxmysql:executeSync("UPDATE houses SET data = ? WHERE id = ?", {json.encode(hData), hData.id})
    cb(true)
end)

Core.CreateCallback('Server:GetAllOwnedVehicles', function(source, cb)
    local result = exports.oxmysql:executeSync("SELECT * FROM vehicles")
    cb(result)
end)

Core.CreateCallback('Server:GetAllHouses', function(source, cb)
    local result = exports.oxmysql:executeSync("SELECT * FROM houses")
    cb(result)
end)

local tickets = {}

Core.CreateCallback("Core:CallRemoteEvent", function(source, cb, event, src)
    TriggerClientEvent(event, src)
end)

Core.CreateCallback('Admin:HandleJail', function(source, cb, jailData)
    local src = jailData.jailSource
    local pData = Core.GetPlayerData(jailData.jailSource)
    local punishment = {
        type = 'Jail',
        duration = jailData.jailTime,
        reason = jailData.jailReason,
        admin = GetPlayerName(source),
    }
   
    if jailData.jailTime == 0 then
        if pData.ajail then
            pData.ajail = false
            pData.ajailReason = nil
            pData.jailcps = nil
            pData.jailAdmin = nil
            exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), pData.identifier})
            cb(false)
            --send chat message
            TriggerClientEvent('chat:addMessage', -1, {
                multiline = true,
                args = {'^3[^0Admin Jail^3] ^0'..GetPlayerName(jailData.jailSource)..'('..jailData.jailSource..') a fost scos de la Admin Jail de '..GetPlayerName(source)..'('..source..')!'}
            })
            print("Player "..GetPlayerName(jailData.jailSource).."("..jailData.jailSource..") has been unjailed by "..GetPlayerName(source).."("..source..")!")
            return
        else
            cb(false)
            return
        end
    end
    pData.ajail = true
    pData.ajailReason = jailData.jailReason
    pData.jailcps = jailData.jailTime
    pData.jailAdmin = GetPlayerName(source)
    print("Player "..GetPlayerName(jailData.jailSource).."("..jailData.jailSource..") has been jailed by "..GetPlayerName(source).."("..source..") for "..jailData.jailTime.." cps with reason: "..jailData.jailReason.."!")
    
    TriggerClientEvent('chat:addMessage', -1, {
        multiline = true,
        args = {'^3[^0Admin Jail^3] ^0'..GetPlayerName(jailData.jailSource)..'('..jailData.jailSource..') a primit Admin Jail de la '..GetPlayerName(source)..'('..source..') pentru '..jailData.jailTime..' checkpoints cu motivul: '..jailData.jailReason..'!'}
    })

    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), pData.identifier})
    Wait(1000)
    
    Core.InsertPunishment(src, punishment)

    cb(true)
end)

-- make a callback called Admin:Log that saves the adminLog  to a file with player name, and if that file exists, insert the log into it

Core.CreateCallback('Admin:TeleportPlayer', function(source, cb, id, coords)
    local players = GetPlayers()
    for k,v in pairs(players) do
        if v == id then
            local ped = GetPlayerPed(id)
            SetEntityCoords(ped, coords.x, coords.y, coords.z)
            cb(true)
            break
        end
    end
end)

Core.CreateCallback('Admin:RevivePlayer', function(source, cb, id)
    local src = id
    local pData = Core.GetPlayerData(id)
    
    if pData.dead then
        pData.dead = false
        exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), pData.identifier})
        Wait(1000)
        TriggerClientEvent('chat:addMessage', -1, {
            multiline = true,
            args = {'^3[^0Admin^3] ^0'..GetPlayerName(id)..'('..id..') a primit revive de la'..GetPlayerName(source)..'('..source..')!'}
        })
        cb(true)
    else
        cb(false)
    end
end)


local function SaveLogToFile(pData, logText)
    local userLogsFile = LoadResourceFile(GetCurrentResourceName(), "logs/"..pData.user..".log")
    local serverLogsFile = LoadResourceFile(GetCurrentResourceName(), "server.log")
    if serverLogsFile then
        logText = "["..os.date("%d/%m/%Y - %H:%M").."] - "..logText
        SaveResourceFile(GetCurrentResourceName(), "server.log", serverLogsFile.."\n"..logText, -1)
    else
        logText = "["..os.date("%d/%m/%Y - %H:%M").."] - "..logText
        SaveResourceFile(GetCurrentResourceName(), "server.log", logText, -1)
    end
    if userLogsFile then
        logText = "["..os.date("%d/%m/%Y - %H:%M").."] - "..logText
        SaveResourceFile(GetCurrentResourceName(), "logs/"..pData.user..".log", userLogsFile.."\n"..logText, -1)
    else
        logText = "["..os.date("%d/%m/%Y - %H:%M").."] - "..logText
        SaveResourceFile(GetCurrentResourceName(), "logs/"..pData.user..".log", logText, -1)
    end
end

Core.CreateCallback('Admin:Log', function(source, cb, logText)
    local src = source
    local pData = Core.GetPlayerData(src)
    print(logText)

    SaveLogToFile(pData, logText)
end)


Core.CreateCallback("Admin:GetTickets", function(source, cb)
    cb(tickets)
end)

Core.CreateCallback('Admin:SolveTicket', function(source, cb, ticketId)
    for k, v in pairs(tickets) do
        if v.ticketId == ticketId then
            v.solved = true
            table.remove(tickets, k)
            print("Ticket #"..ticketId.." solved by "..GetPlayerName(source).."("..source..")")
            cb(true)
            break
        end
    end
end)

RegisterNetEvent('print', function(msg)
    print(msg)
end)

Core.CreateCallback('Admin:Give', function(source, cb, data)
    local pData = Core.GetPlayerData(data.src)

    if pData[data.type] then
        pData[data.type] = pData[data.type] + data.amount
    end

    TriggerClientEvent('chat:addMessage', -1, {
        multiline = true,
        args = {'^3[^0Admin^3] ^0'..GetPlayerName(data.src)..'('..data.src..') a primit '..FormatNumber(data.amount)..' '..data.type..' de la '..GetPlayerName(source)..'('..source..')!'}
    })

    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {je(pData), pData.identifier})
    cb(true)
end)

Core.CreateCallback('Admin:Take', function(source, cb, data)
    local pData = Core.GetPlayerData(data.src)

    if pData[data.type] then
        pData[data.type] = pData[data.type] - data.amount
    end

    TriggerClientEvent('chat:addMessage', -1, {
        multiline = true,
        args = {'^3[^0Admin^3] ^0'..GetPlayerName(source)..'('..source..') i-a scos lui '..GetPlayerName(data.src)..'('..data.src..') '..FormatNumber(data.amount)..' '..data.type..'!'}
    })


    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {je(pData), pData.identifier})
    cb(true)
end)

Core.CreateCallback('Admin:SendTicket', function(source, cb, data)
    for k, v in pairs(GetPlayers()) do
        local pData = Core.GetPlayerData(v)
        if pData.adminLevel > 0 then
            TriggerClientEvent('chat:addMessage', v, {
                    multiline = true,
                    args = {'^3[^0TICKET^3] '..GetPlayerName(source)..'('..source..') a creat un ticket cu mesajul: ^0'..data..'!'}
            })
            table.insert(tickets, {
                ticketId = #tickets + 1,
                name = GetPlayerName(source),
                id = source,
                solved = false,
                message = data
            })
            TriggerClientEvent("Notify:Send", v, "Ticket", "Un nou ticket a fost creat de "..GetPlayerName(source).."("..source..")!", "success")
            cb(true)
        else
            cb(false)
        end
    end
end)

Core.CreateCallback('Admin:SetLevel', function(source, cb, data)
    local pData = Core.GetPlayerData(data.src)

    pData.adminLevel = tonumber(data.lvl)
    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {je(pData), pData.identifier})
    cb(true)
end)

Core.CreateCallback('Admin:RemovePlayerPunish', function(source, cb, removedata)
    local steamId = GetPlayerSteamId(removedata.player)

    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {steamId})

    if result[1] then
        local pData = json.decode(result[1].data)
        if pData.punishHistory then
            table.remove(pData.punishHistory, removedata.key)
            exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), steamId})
            cb(true)
        else
            cb(false)
        end
    end
end)

Core.CreateCallback('Admin:HandleBan', function(source, cb, banData)
    local pData = Core.GetPlayerData(banData.banSource)
    local banId = generateBanId()
    
    pData.banned = 1
    pData.banId = banId
    pData.banReason = banData.banReason
    pData.banTime = banData.banTime
    pData.banTimestamp = getTimestampAfterDays(banData.banTime)
    pData.banAdmin = GetPlayerName(source)
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

    
   

    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), pData.identifier})
    Wait(1000)
    Core.InsertPunishment(banData.banSource, punishment)

    DropPlayer(banData.banSource, "You have been banned from this server by admin: "..GetPlayerName(source).." with reason: "..banData.banReason.." and duration of: "..banData.banTime.." day(s). If you wish to appeal this ban please join our discord.gg/samp.")
    cb(true)
end)

