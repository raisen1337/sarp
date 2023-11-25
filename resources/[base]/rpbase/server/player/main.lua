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

Config = {}

Config.Items = {
    {
        model = "weapon_carbinerifle",
        name = "Carbine",
        type = "weapon",
    },
    {
        model = "weapon_stungun_mp",
        name = "Taser",
        type = "weapon",
    },
    {
        model = "weapon_pistol",
        name = "Pistol",
        type = "weapon",
    },
    {
        model = "weapon_combatpistol",
        name = "Combat Pistol",
        type = "weapon",
    },
    {
        model = "weapon_pumpshotgun",
        name = "Pump Shotgun",
        type = "weapon",
    },
    {
        model = "weapon_sniperrifle",
        name = "Sniper",
        type = "weapon",
    },
    {
        model = "weapon_heavypistol",
        name = "Heavy Pistol",
        type = "weapon",
    },
    {
        model = "weapon_smg",
        name = "SMG",
        type = "weapon",
    },
    {
        model = "weapon_nightstick",
        name = "Nightstick",
        type = "weapon",
    },
    {
        model = 'armour',
        name = "Armour",
        type = "item",
    },
    {
        model = 'medkit',
        name = "Medkit",
        type = "item",
    },
    {
        model = "rifle_ammo",
        name = "Rifle Ammo",
        type = "ammo",
    },
    {
        model = "shotgun_ammo",
        name = "Shotgun Ammo",
        type = "ammo",
    },
    {
        model = "pistol_ammo",
        name = "Pistol Ammo",
        type = "ammo",
    },
    {
        model = "smg_ammo",
        name = "SMG Ammo",
        type = "ammo",
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
    ----print(getCurrentTimestamp())
    local player = source
    local steamIdentifier
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()

    -- mandatory wait!
    Wait(0)

    deferrals.update(string.format("Hello %s. Your Steam ID is being checked.", name))
    
    ------print

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
        --print('[RPBase]: Player '..name..'('..steamIdentifier..') is connected to the server.')
        ------print

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
                            ------print
                            for key, value in pairs(banIds) do
                                if value ~= nil then
                                    if value == playerIds[key] and not foundMatch then
                                        if bpData.banned == 1 then
                                            Wait(0)
                                            foundMatch = true
                                            foundData = bpData
                                            --print('Id: '..key.." matched from account: "..bpData.user.." ("..value.." | "..playerIds[key]..")")
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
                        ------print
                        for key, value in pairs(banIds) do
                            if value ~= nil then
                                if value == playerIds[key] and not foundMatch then
                                    if bpData.banned == 1 then
                                        Wait(0)
                                        foundMatch = true
                                        foundData = bpData
                                        ----print('Id: '..key.." matched from account: "..bpData.user.." ("..value.." | "..playerIds[key]..")")
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
                    ------print
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
    local src = source
    TriggerClientEvent("cl-time:update", src, os.date("%H"), os.date("%M"), os.date("%S"))
    ----print("Updated time on "..GetPlayerName(source))
    ----print(os.date("%H"), os.date("%M"), os.date("%S"))
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
    local data = exports.oxmysql:executeSync("SELECT data FROM players WHERE identifier = ?", {steamIdentifier})

    local pData = json.decode(data[1].data)

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
    ------print
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

Core.CreateCallback('Admin:MutePlayer', function(source, cb, id, muteTime, muteReason)
    --print("MutePlayer callback called")
    local src = source
    local mpData = Core.GetPlayerData(id)
    local pData = Core.GetPlayerData(src)

    -- if mpData.adminLevel >= 6 then
    --     TriggerClientEvent('Notify:Send', src, "Admin", "Nu il poti amutii pe "..mpData.user.." pentru ca este admin!", "error")
    --     cb(false)
    --     return
    -- end

    if not mpData.muted then
        mpData.muted = false
    end

    if mpData.muted then
        TriggerClientEvent('Notify:Send', src, "Admin", "Nu il poti amutii pe "..mpData.user.." pentru ca este deja amutit!", "error")
        cb(false)
        return
    end

    mpData.muted = true
    mpData.muteTime = muteTime
    mpData.muteReason = muteReason

    

    --print("Punishment inserted")

    TriggerClientEvent('Notify:Send', id, "Admin", "Ai fost amutit de catre "..pData.user.." pentru "..muteTime.." minute pentru: "..muteReason.."!", "success")
    TriggerClientEvent('Notify:Send', src, "Admin", "Ai amutit cu succes pe "..mpData.user.." pentru "..muteTime.." minute pentru: "..muteReason.."!", "success")

    --chat message
    TriggerClientEvent('chat:addMessage', -1, {
        multiline = true,
        args = {'^3[^0Admin Mute^3] ^0'..GetPlayerName(id)..'('..id..') a primit mute de la '..GetPlayerName(src)..'('..src..') pentru '..muteTime..' minute pentru: '..muteReason..'!'}
    })

    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(mpData), mpData.identifier})
    --print("Player data updated")

    Wait(1000)
    Core.InsertPunishment(id, {
        type = "Mute",
        reason = muteReason,
        duration = muteTime,
        admin = pData.user,
    })
end)

Core.CreateCallback("Player:Revive", function(source, cb)
    local src = source
    local pData = Core.GetPlayerData(src)
    if pData.dead then
        pData.dead = false
    else
        pData.dead = false
    end
    Wait(1000)
    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), pData.identifier})
    cb(true)
end)

--now do a unmute callback
Core.CreateCallback('Admin:UnmutePlayer', function(source, cb, id)
    local src = source
    local mpData = Core.GetPlayerData(id)
    local pData = Core.GetPlayerData(src)

    if not mpData.muted then
        TriggerClientEvent('Notify:Send', src, "Admin", "Nu il poti amutii pe "..mpData.user.." pentru ca nu este amutit!", "error")
        cb(false)
        return
    end

    mpData.muted = false
    mpData.muteTime = 0
    mpData.muteReason = ""

    --send chat message
    TriggerClientEvent('chat:addMessage', -1, {
        multiline = true,
        args = {'^3[^0Admin Mute^3] ^0'..GetPlayerName(id)..'('..id..') a primit unmute de la '..GetPlayerName(src)..'('..src..')!'}
    })

    TriggerClientEvent('Notify:Send', id, "Admin", "Ai fost dezamutit de catre "..pData.user.."!", "success")
    TriggerClientEvent('Notify:Send', src, "Admin", "Ai dezamutit cu succes pe "..mpData.user.."!", "success")

    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(mpData), mpData.identifier})
end)

--now do a unmute after expiring time callback
Core.CreateCallback('Admin:MuteExpire', function(source, cb, id)
    local src = source
    local mpData = Core.GetPlayerData(id)
    local pData = Core.GetPlayerData(src)

    if mpData.adminLevel > 0 then
        cb(false)
        return
    end

    if not mpData.muted then
        cb(false)
        return
    end

    mpData.muted = false
    mpData.muteTime = 0
    mpData.muteReason = ""

    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(mpData), mpData.identifier})
end)

Core.CreateCallback('Police:Arrest', function(source, cb, id, time, reason)
    local tData = Core.GetPlayerData(id)
    local pData = Core.GetPlayerData(source)
    if not tData.jail then
        tData.jail = true
    else
        cb(false)
        TriggerClientEvent('Notify:Send', source, "Politie", "Jucatorul nu deja in arest!", "error")
        return
    end

    if not tData.jailTime then
        tData.jailTime = time
    else
        tData.jailTime = time
    end

    if not tData.jailReason then
        tData.jailReason = reason
    else
        tData.jailReason = reason
    end

    if not tData.wantedLevel then
        tData.wantedLevel = 0
    else
        tData.wantedLevel = 0
    end

    TriggerClientEvent('Notify:Send', id, "Politie", "Ai fost arestat de catre "..pData.user.." pentru "..time.." minute pentru: "..reason.."!", "success")
    TriggerClientEvent('Notify:Send', source, "Politie", "Ai arestat cu succes pe "..tData.user.." pentru "..time.." minute pentru: "..reason.."!", "success")

    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(tData), tData.identifier})
    cb(true)
end)

Core.CreateCallback("Police:Free", function(source, cb, id)
    local tData = Core.GetPlayerData(id)
    local pData = Core.GetPlayerData(source)

    if not tData.jail then
        tData.jail = false
    else
        tData.jail = false
        TriggerClientEvent('Notify:Send', source, "Politie", "Jucatorul nu este arestat!", "error")
        cb(false)
        return
    end

    if not tData.jailTime then
        tData.jailTime = 0
    else
        tData.jailTime = 0
    end

    if not tData.jailReason then
        tData.jailReason = ""
    else
        tData.jailReason = ""
    end

    TriggerClientEvent('Notify:Send', id, "Politie", "Ai fost eliberat de catre "..pData.user.."!", "success")
    TriggerClientEvent('Notify:Send', source, "Politie", "Ai eliberat cu succes pe "..tData.user.."!", "success")

    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(tData), tData.identifier})
    cb(true)
end)


Core.InsertPunishment = function(source, punishment)
    local src = source
    local pData = Core.GetPlayerData(src)
  
    if  pData.punishHistory then
        if table.empty(pData.punishHistory) then
            pData.punishHistory = {}
            table.insert(pData.punishHistory, punishment)
        end
    else
        pData.punishHistory = {}
        table.insert(pData.punishHistory, punishment)
    end

   

    local result = exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {je(pData), pData.identifier})

    -- if result.affectedRows > 0 then
    --     print("Update successful!")
    -- else
    --     print("Update failed!")
    -- end
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
        local pData = json.decode(result[1].data)
        cb(pData)
    end
end)

Core.CreateCallback('Police:Cuff', function(source, cb, player)

    --print(player)
    TriggerClientEvent('Player:GetCuffed', player)
    cb(true)
end)

Core.CreateCallback("Player:GetDataBySteamId", function(source, cb, steamId)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {steamId})
    if result[1] then
        cb(json.decode(result[1].data))
    else
        cb(false)
    end
end)

Core.GetItem = function(name)
    for _, item in pairs(Config.Items) do
        if item.name == name or item.model == name then
            return item
        end
    end
end

function FormatNumber(amount)
    amount = tostring(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

Core.CreateCallback('Player:Pay', function(source, cb, type, amount)
    local pData = Core.GetPlayerData(source)
    if pData[type] then
        pData[type] = pData[type] - amount
    end

    Wait(1500)
    --send notification
    TriggerClientEvent('Notify:Send', source, "Banca", "Ai platit "..FormatNumber(amount).."$!", "success")
    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), pData.identifier})
end)
Core.CreateCallback("Player:AddItem", function(source, cb, name, amount)
    ------print
    print('da')
    local pData = Core.GetPlayerData(source)
    local Inventory = pData.inventory
    local itemFound = false

    if not table.empty(Inventory) then
        for _, item in pairs(Inventory) do
            if item.name == name then
                if not item.amount then
                    item.amount = amount
                else
                    item.amount = item.amount + amount
                end
                itemFound = true
                break
            end
        end
    else
        itemFound = false
    end

    if not itemFound then
        table.insert(Inventory, {name = Core.GetItem(name).model, type = Core.GetItem(name).type, amount = amount})
    end

    pData.inventory = Inventory

    -- Add logging statement to ----print the updated inventory

    cb(true)
    Wait(2000)
    local result = exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), pData.identifier})

end)

Core.CreateCallback('Player:GetAmmo', function(source, cb, type)
    local pData = Core.GetPlayerData(source)
    local Inventory = pData.inventory
    if not table.empty(Inventory) then
        for _, item in pairs(Inventory) do
            if item.type == 'ammo' then
                if string.match(item.name, type) then
                    cb(item.amount)
                else
                    cb(false)
                end
            end
        end
    else
        cb(false)
    end
    
end)

Core.CreateCallback('Player:GetPlayerWeapons', function(source, cb)
    local pData = Core.GetPlayerData(source)
    local Inventory = pData.inventory
    local weapons = {}
    if not table.empty(Inventory) then
        for k,v in pairs(inventory) do
            if v.type == "weapon" then
                table.insert(weapons, v)
            end
        end
    end
    
    cb(weapons)
end)

Core.CreateCallback('Player:GetPlayerInventory', function(source, cb)
    local pData = Core.GetPlayerData(source)
    local Inventory = pData.inventory
    cb(Inventory)
end)


Core.CreateCallback("Player:RemoveItem", function(source, cb, name, amount)
    ------print
    local pData = Core.GetPlayerData(source)
    local Inventory = pData.inventory
    local itemFound = false

    if not table.empty(Inventory) then
        for i, item in ipairs(Inventory) do
            if item.name == name then
                if item.amount - amount <= 0 then
                    table.remove(Inventory, i)
                else
                    item.amount = item.amount - amount
                end
                itemFound = true
                break
            end
        end
    end

    if not itemFound then
      
    end
    cb(true)
    Wait(2000)
    pData.inventory = Inventory
    exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), pData.identifier})

end)

Core.GetPlayerData = function(source)
    local src = source

    local steamIdentifier = nil
    local identifiers = GetPlayerIdentifiers(src)

    for k,v in pairs(GetPlayerIdentifiers(src))do
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

Core.CreateCallback('Core:GetPlayerById', function(source, cb, id)
    local players = GetPlayers()
    local player = {}
    for k, v in pairs(players) do
        if v == id then
            player = {
                id = v,
                name = GetPlayerName(v),
                ped = GetPlayerPed(v),
                coords = GetEntityCoords(GetPlayerPed(v)),
                heading = GetEntityHeading(GetPlayerPed(v)),
                data = Core.GetPlayerData(v),
            }
            cb(player)
            return
        end
    end
    cb(false)
end)

RegisterNetEvent("sv:updatetargetdata", function(a,b)
    TriggerClientEvent('updatetargetdata', source, a,b)
end)

Core.CreateCallback('Police:SetWanted', function(source, cb, id, level, reason)
    local pData = Core.GetPlayerData(id)
    pData.wantedLevel = level

    if not pData.wantedReason then
        pData.wantedReason = reason
    end

    exports.oxmysql:query("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), GetPlayerSteamId(id)})
    cb(true)
end)

Core.CreateCallback('Police:GetWanted', function (source, cb)
    local players = GetPlayers()
    local wanteds = {}
    for k, v in pairs(players) do
        local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {GetPlayerSteamId(v)})
        local pData = json.decode(result[1].data)

        if pData.wantedLevel then
            table.insert(wanteds, {
                id = v,
                level = pData.wantedLevel,
                name = pData.user,
                reason = pData.wantedReason,
            })
        end
    end
    cb(wanteds)
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
    local identifier = ""
    if type(pData) == 'table' then
        identifier = pData.identifier
        exports.oxmysql:query("UPDATE players SET data = ? WHERE identifier = ?", {je(pData), pData.identifier})
        Wait(2000)
        TriggerClientEvent("Player:UpdateData", src)
        return
    else
        pData = jd(pData)
        exports.oxmysql:query("UPDATE players SET data = ? WHERE identifier = ?", {je(pData), pData.identifier})
        Wait(2000)
        TriggerClientEvent("Player:UpdateData", src)
        return
    end
end)
