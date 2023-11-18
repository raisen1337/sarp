local PlayerStruct = {
    user = "",
    identifier = "",
    adminLevel = 0,
    cash = 3000,
    bank = 0,
    wantedLevel = 0,
    level = 1,
    respectPoints = 0,
    premiumPoints = 0,
    hours = 0,
    banned = 0,
    banId = 1,
    bankId = generateBankId(),
    transactions = {},
    totalTransferred = 0,
    totalWithdrawn = 0,
    totalDeposited = 0,
    banReason = "No reason",
    inventory = {},
    skills = {},
    faction = {
        id = 0,
        name = "None",
        rank = 0,
        rankColor = 0,
        rankName = "None",
    },
    character = {
        ped_model = "",
        name = "",
        surname = "",
        age = 0,
        clothes = {},
    },
    position = {},
    job = {
        name = "Unemployed",
        salary = 0,
        rank = 0,
    },
}



Peds = {
    "cs_amandatownley",
    "cs_andreas",
    "cs_ashley",
    "cs_bankman",
    "cs_barry",
    "cs_beverly",
    "cs_brad",
    "cs_casey",
    "cs_chengsr",
    "cs_chrisformage",
    "cs_clay",
    "cs_dale",
    "cs_davenorton",
    "cs_debra",
    "cs_denise",
    "cs_dom",
    "cs_dreyfuss",
    "cs_drfriedlander",
    "cs_fabien",
    "cs_fbisuit_01",
    "cs_floyd",
    "cs_guadalope",
    "cs_gurk",
    "cs_hunter",
    "cs_janet",
    "cs_jewelass",
    "cs_jimmyboston",
    "cs_jimmydisanto",
    "cs_joeminuteman",
    "cs_johnnyklebitz",
    "cs_josef",
    "cs_josh",
    "cs_karen_daniels",
    "cs_lamardavis",
    "cs_lazlow",
    "cs_lestercrest",
    "cs_magenta",
    "cs_manuel",
    "cs_marnie",
    "cs_martinmadrazo",
    "cs_maryann",
    "cs_michelle",
    "cs_milton",
    "cs_molly",
    "cs_movpremf_01",
    "cs_movpremmale",
    "cs_mrk",
    "cs_mrs_thornhill",
    "cs_mrsphillips",
    "cs_natalia",
    "cs_nervousron",
    "cs_nigel",
    "cs_old_man1a",
    "cs_old_man2",
    "cs_omega",
    "cs_orleans",
    "cs_paper",
    "cs_patricia",
    "cs_priest",
    "cs_prolsec_02",
    "cs_russiandrunk",
    "cs_siemonyetarian",
    "cs_solomon",
    "cs_stevehains",
    "cs_stretch",
    "cs_tanisha",
    "cs_taocheng",
    "cs_taostranslator",
    "cs_tenniscoach",
    "cs_terry",
    "cs_tom",
    "cs_tomepsilon",
    "cs_tracydisanto",
    "cs_wade",
    "cs_zimbor",
    "g_f_importexport_01",
    "g_m_importexport_01",
    "hc_driver",
    "hc_gunman",
    "hc_hacker",
    "ig_abigail",
    "ig_agent",
    "ig_amandatownley",
    "ig_andreas",
    "ig_ashley",
    "ig_avon",
    "ig_bankman",
    "ig_barry",
    "ig_benny",
    "ig_beverly",
    "ig_brad",
    "ig_bride",
    "ig_car3guy1",
    "ig_car3guy2",
    "ig_casey",
    "ig_chef",
    "ig_chef2",
    "ig_chengsr",
    "ig_chrisformage",
    "ig_clay",
    "ig_claypain",
    "ig_dale",
    "ig_davenorton",
    "ig_denise",
    "ig_dom",
    "ig_dreyfuss",
    "ig_drfriedlander",
    "ig_fabien",
    "ig_fbisuit_01",
    "ig_floyd",
    "ig_guadalope",
    "ig_gurk",
    "ig_hunter",
    "ig_janet",
    "ig_jewelass",
    "ig_jimmyboston",
    "ig_jimmydisanto",
    "ig_joeminuteman",
    "ig_johnnyklebitz",
    "ig_josef",
    "ig_josh",
    "ig_karen_daniels",
    "ig_lamardavis",
    "ig_lazlow",
    "ig_lestercrest",
    "ig_magenta",
    "ig_manuel",
    "ig_marnie",
    "ig_maryann",
    "ig_michelle",
    "ig_milton",
    "ig_molly",
    "ig_movpremf_01",
    "ig_movpremmale",
    "ig_mrk",
    "ig_mrs_thornhill",
    "ig_mrsphillips",
    "ig_natalia",
    "ig_nervousron",
    "ig_nigel",
    "ig_old_man1a",
    "ig_old_man2",
    "ig_omega",
    "ig_orleans",
    "ig_ornate_banker",
    "ig_paper",
    "ig_patricia",
    "ig_priest",
    "ig_prolsec_02",
    "ig_russiandrunk",
    "ig_siemonyetarian",
    "ig_solomon",
    "ig_solomon_p",
    "ig_stevehains",
    "ig_stretch",
    "ig_talina",
    "ig_tanisha",
    "ig_taocheng",
    "ig_taostranslator",
    "ig_tenniscoach",
    "ig_terry",
    "ig_tom",
    "ig_tomepsilon",
    "ig_tracydisanto",
    "ig_tylerdix",
    "ig_wade",
    "ig_zimbor",
    "mp_f_avon",
    "mp_f_bennymech",
    "mp_f_boatstaff_01",
    "mp_f_cardesign_01",
    "mp_f_chbar_01",
    "mp_f_cocaine_01",
    "mp_f_counterfeit_01",
    "mp_f_deadhooker",
    "mp_f_execpa_01",
    "mp_f_execpa_02",
    "mp_f_forgery_01",
    "mp_f_freemode_01",
    "mp_f_helistaff_01",
    "mp_f_meth_01",
    "mp_f_misty_01",
    "mp_f_stripperlite",
    "mp_f_weed_01",
    "mp_g_m_pros_01",
    "mp_headtargets",
    "mp_m_avongoon",
    "mp_m_avonl",
    "mp_m_boatstaff_01",
    "mp_m_bogdangoon",
    "mp_m_claude_01",
    "mp_m_cocaine_01",
    "mp_m_counterfeit_01",
    "mp_m_exarmy_01",
    "mp_m_execpa_01",
    "mp_m_famdd_01",
    "mp_m_fibsec_01",
    "mp_m_forgery_01",
    "mp_m_freemode_01",
    "mp_m_g_vagfun_01",
    "mp_m_marston_01",
    "mp_m_meth_01",
    "mp_m_niko_01",
    "mp_m_securoguard_01",
    "mp_m_shopkeep_01",
    "mp_m_waremech_01",
    "mp_m_weapexp_01",
    "mp_m_weapwork_01",
    "mp_m_weed_01",
    "mp_s_m_armoured_01",
    "player_one",
    "player_two",
    "player_zero"
}

mugShot = {
    characterPos = {1853.8549804688, 3677.7626953125, 34.317993164062, 116.22047424316},
    cameraPos = {1852.087890625, 3676.6286621094, 34.317993164062},
}

function onMeCommand(source, args)
    local text = '"' .. "" .. table.concat(args, " ") .. '"'
    TriggerClientEvent('3dme:shareDisplay', -1, text, source)
end
RegisterCommand('me', onMeCommand)
local function OnPlayerConnecting(name, setKickReason, deferrals)
    print(getCurrentTimestamp())
    local player = source
    local steamIdentifier
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()

    -- mandatory wait!
    Wait(0)

    deferrals.update(string.format("Hello %s. Your Steam ID is being checked.", name))
    
    print('[RPBase]: Player '..name..' is trying to join the server.')

    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end

    -- mandatory wait!
    Wait(0)

    if not steamIdentifier then
        deferrals.done("Steam needs to be running in order to join this server.")
    else
        print('[RPBase]: Player '..name..'('..steamIdentifier..') is connected to the server.')
        print('[RPBase]: Checking if identifier '..steamIdentifier..' exists in database.')

        exports.oxmysql:query("SELECT * FROM players WHERE identifier = ?", {steamIdentifier}, function(result)
            if result[1] then
                Wait(0)
                local pData = json.decode(result[1].data)
                
                if pData.banned == 1 then
                    if pData.banTimestamp <= getCurrentTimestamp() then
                        pData.banned = 0
                        deferrals.done("Your ban has expired. Please rejoin.")
                        exports.oxmysql:execute('UPDATE players SET data = ? WHERE identifier = ?', {json.encode(pData), pData.identifier})
                    else
                        deferrals.done("You have been banned from this server for: "..pData.banReason..". Please visit "..Discord.." to appeal your ban and obtain info about it. Your BanID is: ["..pData.banId.."].")
                    end
                else
                    local result2 = exports.oxmysql:executeSync('SELECT * FROM players')
                    local playerIds = GetPlayerIds(player)
                    local foundMatch = false -- Initialize a flag to track if any match is found
                    local foundData = {}
                    for k, v in pairs(result2) do
                        local bpData = json.decode(v.data)
                        local banIds = bpData.banIds
                        deferrals.update("🔨 Checking if you are banned on other accounts..")
                        if banIds then
                            print(banIds['steamId'], playerIds['steamId'])
                            for key, value in pairs(banIds) do
                                if value ~= nil then
                                    if value == playerIds[key] and not foundMatch then
                                        if bpData.banned == 1 then
                                            Wait(0)
                                            foundMatch = true
                                            foundData = bpData
                                            print('Id: '..key.." matched from account: "..bpData.user.." ("..value.." | "..playerIds[key]..")")
                                        else
                                            foundMatch = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if foundMatch then
                        Wait(0)
                        deferrals.done("You have been banned from this server for: "..foundData.banReason..". Please visit "..Discord.." to appeal your ban and obtain info about it. Your BanID is: ["..foundData.banId.."].")
                    end
                    if not foundMatch then
                        Wait(0)
                        deferrals.done()
                    end
                end
                return
            else
                if Whitelist.Toggled then
                    Wait(0)
                    deferrals.done("Server is accepting only whitelisted connections!")
                    return
                end
                local result2 = exports.oxmysql:executeSync('SELECT * FROM players')
                local playerIds = GetPlayerIds(player)
                local foundMatch = false -- Initialize a flag to track if any match is found
                local foundData = {}
                for k, v in pairs(result2) do
                    local bpData = json.decode(v.data)
                    local banIds = bpData.banIds
                    deferrals.update("🔨 Checking if you are banned on other accounts..")
                    if banIds then
                        print(banIds['steamId'], playerIds['steamId'])
                        for key, value in pairs(banIds) do
                            if value ~= nil then
                                if value == playerIds[key] and not foundMatch then
                                    if bpData.banned == 1 then
                                        Wait(0)
                                        foundMatch = true
                                        foundData = bpData
                                        print('Id: '..key.." matched from account: "..bpData.user.." ("..value.." | "..playerIds[key]..")")
                                    else
                                        foundMatch = false
                                    end
                                end
                            end
                        end
                    end
                end
                if foundMatch then
                    Wait(0)
                    deferrals.done("You have been banned from this server for: "..foundData.banReason..". Please visit "..Discord.." to appeal your ban and obtain info about it. Your BanID is: ["..foundData.banId.."].")
                end
                if not foundMatch then
                    Wait(0)
                    local PlayerStruct = {
                        user = "",
                        identifier = "",
                        adminLevel = 0,
                        cash = 3000,
                        bank = 0,
                        wantedLevel = 0,
                        level = 1,
                        respectPoints = 0,
                        premiumPoints = 0,
                        hours = 0,
                        banned = 0,
                        banId = 1,
                        bankId = generateBankId(),
                        transactions = {},
                        totalTransferred = 0,
                        totalWithdrawn = 0,
                        totalDeposited = 0,
                        banReason = "No reason",
                        inventory = {},
                        skills = {},
                        faction = {
                            id = 0,
                            name = "None",
                            rank = 0,
                            rankColor = 0,
                            rankName = "None",
                        },
                        character = {
                            ped_model = "",
                            name = "",
                            surname = "",
                            age = 0,
                            clothes = {},
                        },
                        position = {},
                        job = {
                            name = "Unemployed",
                            salary = 0,
                            rank = 0,
                        },
                        banIds = {
                            steamId = GetPlayerIds(player).steamId,
                            xbl = GetPlayerIds(player).xbl,
                            discord = GetPlayerIds(player).discord,
                            liveid = GetPlayerIds(player).liveid,
                            license = GetPlayerIds(player).license,
                            ip = GetPlayerIds(player).ip,
                            hwids = GetPlayerIds(player).hashValues,
                        }
                    }
                    
                    PlayerStruct.user = name
                    PlayerStruct.identifier = steamIdentifier
                    PlayerStruct = json.encode(PlayerStruct)
    
                    exports.oxmysql:query("INSERT INTO players(user, identifier, data) VALUES(?, ?, ?)", {name, steamIdentifier, PlayerStruct})
                    print('[RPBase]: Player '..name..' has been registered in the database.')
                    deferrals.done()
                end
            
            end
        end)

        Wait(0)

    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)

Core.CreateCallback("Players:GetCount", function(source, cb)
    cb(#GetPlayers())
end)

RegisterNetEvent("Scoreboard:AddPlayer", function()
    local src = source
    local player = {
        playerName = GetPlayerName(src),
        playerId = src,
        playerLevel = Core.GetPlayerLevel(src)
    }
    TriggerClientEvent("Scoreboard:AddPlayer", -1, player)
end)

RegisterNetEvent("sv-time:update", function()
    TriggerClientEvent("cl-time:update", source, os.date("%H"), os.date("%M"), os.date("%S"))
    print("Updated time on "..GetPlayerName(source))
    print(os.date("%H"), os.date("%M"), os.date("%S"))
end)

RegisterNetEvent("Scoreboard:SetScoreboard", function()
    local src = source
    local players = GetPlayers()
    for k,v in pairs(players) do
        local player = {
            playerName = GetPlayerName(v),
            playerId = v,
            playerLevel = Core.GetPlayerLevel(v)
        }
        TriggerClientEvent("Scoreboard:AddPlayer", src, player)
    end
end)

Core.GetPlayerLevel = function(s) 
    local src = s

    local steamIdentifier = nil
    local identifiers = GetPlayerIdentifiers(src)

    for k,v in pairs(GetPlayerIdentifiers(src))do
    
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamIdentifier = v
        end
        
    end
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {steamIdentifier})

    local pData = json.decode(result[1].data)

    return pData.level
end

Core.CreateCallback("Identity:Check", function(source, cb)
    local src = source

    local steamIdentifier = nil
    local identifiers = GetPlayerIdentifiers(src)

    for k,v in pairs(GetPlayerIdentifiers(src))do
    
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamIdentifier = v
        end
        
    end
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {steamIdentifier})

    local pData = json.decode(result[1].data)
    print(pData.character.name, pData.character.surname)
    if string.len(pData.character.name..""..pData.character.surname) > 0 then
        cb(true)
    else
        cb(false)
    end
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    local registeredCommands = GetRegisteredCommands()
    for _, cmd in pairs(registeredCommands) do
        if cmd.name ~= command then
            local str = "^3[SERVER]:^0 "..Lang[Language]['CommandNotRegistered']..""
            str = str:format(command)
            TriggerClientEvent('chatMessage', source, "",  { 255, 255, 255 }, str)
            break
        end
    end
    CancelEvent()
end)

Core.InsertPunishment = function(source, punishment)
    local pData = Core.GetPlayerData(source)

    if not pData.punishHistory or table.empty(pData.punishHistory) then
        pData.punishHistory = {}
        table.insert(pData.punishHistory, punishment)
    else
        table.insert(pData.punishHistory, punishment)
    end

    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), pData.identifier})
end

Core.CreateCallback('Player:GetData', function(source, cb)

    local src = source

    local steamIdentifier = nil
    local identifiers = GetPlayerIdentifiers(src)

    for k,v in pairs(GetPlayerIdentifiers(source))do
    
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamIdentifier = v
        end
        
    end
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {steamIdentifier})

    if result[1] then
        cb(json.decode(result[1].data))
    else
        local name = GetPlayerName(src)
        local PlayerStruct = {
            user = "",
            identifier = "",
            adminLevel = 0,
            cash = 3000,
            bank = 0,
            wantedLevel = 0,
            level = 1,
            respectPoints = 0,
            premiumPoints = 0,
            hours = 0,
            banned = 0,
            banId = 1,
            bankId = generateBankId(),
            transactions = {},
            totalTransferred = 0,
            totalWithdrawn = 0,
            totalDeposited = 0,
            banReason = "No reason",
            inventory = {},
            skills = {},
            faction = {
                id = 0,
                name = "None",
                rank = 0,
                rankColor = 0,
                rankName = "None",
            },
            character = {
                ped_model = "",
                name = "",
                surname = "",
                age = 0,
                clothes = {},
            },
            position = {},
            job = {
                name = "Unemployed",
                salary = 0,
                rank = 0,
            },
            banIds = {
                steamId = GetPlayerIds(src).steamId,
                xbl = GetPlayerIds(src).xbl,
                discord = GetPlayerIds(src).discord,
                liveid = GetPlayerIds(src).liveid,
                license = GetPlayerIds(src).license,
                ip = GetPlayerIds(src).ip,
                hwids = GetPlayerIds(src).hashValues,
            }
        }
        
        PlayerStruct.user = name
        PlayerStruct.identifier = steamIdentifier
        PlayerStruct = json.encode(PlayerStruct)

        exports.oxmysql:query("INSERT INTO players(user, identifier, data) VALUES(?, ?, ?)", {name, steamIdentifier, PlayerStruct})
        print('[RPBase]: Player '..name..' has been registered in the database.')
        cb(json.decode(PlayerStruct))
    end
end)

Core.CreateCallback("Player:GetDataBySteamId", function(source, cb, steamId)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {steamId})
    if result[1] then
        cb(json.decode(result[1].data))
    else
        cb(false)
    end
end)

Core.GetPlayerData = function(source)
    local src = source

    local steamIdentifier = nil
    local identifiers = GetPlayerIdentifiers(src)

    for k,v in pairs(GetPlayerIdentifiers(source))do
    
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamIdentifier = v
        end
        
    end

  
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {steamIdentifier})
    if result[1] then
        return json.decode(result[1].data)
    else
        return false
    end
end

Core.CreateCallback("Players:IsOnline", function (source, cb, id)
    if GetPlayerPing(id) then
        cb(true)
    else
        cb(false)
    end
   
end)

Citizen.CreateThread(function()
    while true do
        Wait(300000)
        for k,v in pairs(GetPlayers()) do
            local src = v
            local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {GetPlayerSteamId(src)})
            local pData = json.decode(result[1].data)
            local increasePerInterval = 1 / 12
            if not pData.hours then
                pData.hours = 0
            end
            pData.hours = math.floor(pData.hours + increasePerInterval)
            exports.oxmysql:query("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), GetPlayerSteamId(src)})
        end
    end
end)

Core.CreateCallback('PayDay:Finish', function(source, cb)
    local src = source

    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {GetPlayerSteamId(src)})
    local pData = json.decode(result[1].data)

    local totalPay = 0
    local pdData = {}

    if pData.job.salary ~= 0 then
        totalPay = totalPay + pData.job.salary
        pdData.check = 50000
        pdData.job = pData.job.salary
    else
        totalPay = totalPay + 50000
        pdData.check = 50000
        pdData.job = 0
    end

    if pData.vip then
        totalPay = totalPay + 100000
        pdData.vip = 100000
    else
        pdData.vip = 0
    end

    pData.cash = pData.cash + totalPay

    exports.oxmysql:query("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), GetPlayerSteamId(src)})
    cb(pdData)
end)



Core.CreateCallback('Player:GetPunishes', function(source, cb, player)
    local steamId = GetPlayerSteamId(player)

    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {steamId})

    if result[1] then
        local pData = json.decode(result[1].data)
        if pData.punishHistory then
            cb(pData.punishHistory)
        else
            cb({})
        end
    end
end)

RegisterNetEvent("Player:Save", function(pData)
    local src = source
    pData = json.decode(pData)
    exports.oxmysql:query("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), pData.identifier})
    print("Player "..pData.user.." saved!")
    Wait(2000)
    TriggerClientEvent("Player:UpdateData", src)
end)
