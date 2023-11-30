local adminMenu = MenuV:CreateMenu(false, "Meniu Admin", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-main')
local playerList = MenuV:CreateMenu(false, "Lista jucatori", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-playerlist')
local playerOptions = MenuV:CreateMenu(false, "Optiuni jucator", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-playeropt')
local playerHouses = MenuV:CreateMenu(false, "Casele jucatorului", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-playerhouses')
local playerHouse = MenuV:CreateMenu(false, "Casa jucatorului", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-playerhouse')
local playerBizs = MenuV:CreateMenu(false, "Afacerile jucatorului", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-playerbizs')
local playerBiz = MenuV:CreateMenu(false, "Afacerea jucatorului", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-playerbiz')
local houseTenants = MenuV:CreateMenu(false, "Chiriasi", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-playerhousetenants')
local playerCars = MenuV:CreateMenu(false, "Masini jucator", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-playercars')
local playerCar = MenuV:CreateMenu(false, "Masina jucator", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-playercar')
local playerPunishes = MenuV:CreateMenu(false, "Sanctiuni jucator", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-playerpunishes')
local playerPunish = MenuV:CreateMenu(false, "Sanctiune jucator", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-playerpunish')
local serverHousesMenu = MenuV:CreateMenu(false, "Meniu case", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-serverhousesMenu')
local serverHouses = MenuV:CreateMenu(false, "Lista case", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-serverhouses')
local serverHouse = MenuV:CreateMenu(false, "Casa", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-serverhouse')
local serverCars = MenuV:CreateMenu(false, "Masini detinute", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-servercars')
local serverCar = MenuV:CreateMenu(false, "Masina detinuta", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-servercar')
local personalSettings = MenuV:CreateMenu(false, "Optiuni personale", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-personalsettings')
local personalSetting = MenuV:CreateMenu(false, "Optiuni personale", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-personalsetting')
local businessesSettings = MenuV:CreateMenu(false, "Optiuni afaceri", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-serverbizsettings')
local businessesList = MenuV:CreateMenu(false, "Lista afaceri", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-serverbizlist')
local businessCfg = MenuV:CreateMenu(false, "Optiuni afacere", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-serverbizcfg')
local sanctionsMenu = MenuV:CreateMenu(false, "Sanctiuni", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-sanctionsmenu')
local ticketsList = MenuV:CreateMenu(false, "Tickete in desfasurare", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-ticketslist')
local economyMenu = MenuV:CreateMenu(false, "Economie", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-economymenu')
local playerSubOptions = MenuV:CreateMenu(false, "Optiuni jucator", "centerright", 255, 0, 0, 'size-150', 'none', 'menuv', 'admin-playersubopt')
local createHouseData = {
    price = 0,
    type = 'Low',
}

local createBizData = {
    name = '',
    price = '',
    type = 0,
    blip = 0,
}
local inNoClip = false

function noClip()
    local ped = PlayerPedId()
    local inVehicle = IsPedInAnyVehicle(ped, false)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local speed = 1.0
    if IsControlPressed(0, 21) then
        speed = 5.0
    end
    if IsControlJustPressed(0, 21) then
        inNoClip = not inNoClip
    end
    if inNoClip then
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
        if inVehicle then
            SetEntityInvincible(vehicle, true)
            SetEntityVisible(vehicle, false, false)
            SetEntityCollision(vehicle, false, false)
            local coords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 5.0, 0.0)
            SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, true, true, true)
        else
            local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
            SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, true, true, true)
        end
        if IsControlPressed(0, 32) then
            local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, speed, 0.0)
            SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, true, true, true)
        end
        if IsControlPressed(0, 269) then
            local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, -speed, 0.0)
            SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, true, true, true)
        end
        if IsControlPressed(0, 266) then
            local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 1.0)
            SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, true, true, true)
        end
        if IsControlPressed(0, 267) then
            local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -1.0)
            SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, true, true, true)
        end
        if IsControlPressed(0, 34) then
            local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 0.0)
            SetEntityHeading(ped, GetEntityHeading(ped) + 3.0)
        end
        if IsControlPressed(0, 35) then
            local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 0.0)
            SetEntityHeading(ped, GetEntityHeading(ped) - 3.0)
        end
    else
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
        if inVehicle then
            SetEntityInvincible(vehicle, false)
            SetEntityVisible(vehicle, true, false)
            SetEntityCollision(vehicle, true, true)
        end
    end
end

local godModeOn = false

local ticketCooldown = 0

Citizen.CreateThread(function ()
    while true do
        if ticketCooldown > 0 then
            ticketCooldown = ticketCooldown - 1
            if ticketCooldown == 0 then
                sendNotification("Ticket", "Ticket-ul tau a expirat.", "error")
            end

        end
        Wait(60000)
    end
end)

RegisterCommand('tickets', function()
    if Core.GetPlayerData().adminLevel > 0 then
        Core.TriggerCallback('Admin:GetTickets', function(tickets)
            ticketsList:ClearItems()
            if #tickets > 0 then
                for k, v in pairs(tickets) do
                    if not v.solved then
                        ticketsList:AddButton({
                            label = 'Ticket ID: '..v.ticketId,
                            disabled = true
                        })
                        ticketsList:AddButton({
                            label = 'Jucator: '..v.name .. ' - ' .. v.id,
                            icon = '👤',
                            disabled = true
                        })
                        ticketsList:AddButton({
                            label = 'Mesaj: '..v.message,
                            icon = '📃',
                            disabled = true
                        })
                        ticketsList:AddButton({
                            label = 'Rezolva ticket',
                            icon = '✅',
                        }):On('select', function()
                            MenuV:CloseAll()
                            Core.TriggerCallback('Admin:Log', function() end, 'a luat ticket-ul cu id-ul '..v.ticketId)
                            ExecuteCommand('taketicket '..v.ticketId)
                        end)
                    end
                end
                MenuV:OpenMenu(ticketsList)
            else
                sendNotification("Ticket", "Nu ai niciun ticket in desfasurare.", "error")
            end
        end)
    end
end)

RegisterCommand('taketicket', function(source, args, rawCommand)
    local pData = Core.GetPlayerData()
    if pData.adminLevel > 0 then
        Core.TriggerCallback('Admin:GetTickets', function(tickets)
            --print(je(tickets), #tickets)
            if #tickets > 0 then
                for k, v in pairs(tickets) do
                    if tonumber(args[1]) then
                        if tonumber(args[1]) == v.ticketId then
                            if not v.solved then
                                --print
                                Core.TriggerCallback('Core:GetPlayers', function(players)
                                    for a,b in pairs(players) do
                                       b.source = tonumber(b.source)
                                       v.id = tonumber(v.id)
                                       if b.source == v.id then
                                           Core.TriggerCallback("Core:GetPlayerCoords", function(coords)
                                               SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
                                               --print
                                               Core.TriggerCallback('Admin:Log', function() end, 'a rezolvat ticket-ul cu id-ul '..v.ticketId)
                                               Core.TriggerCallback('Admin:SolveTicket', function(cb) end, v.ticketId)
                                               Core.TriggerCallback('Core:CallRemoteEvent', function() end, 'solveTicket', v.id)
                                           end, b.source)
                                       end
                                    end
                                end)
                            end
                        end
                    else
                        if not v.solved then
                            --print
                            Core.TriggerCallback('Core:GetPlayers', function(players)
                                for a,b in pairs(players) do
                                   b.source = tonumber(b.source)
                                   v.id = tonumber(v.id)
                                   if b.source == v.id then
                                       Core.TriggerCallback("Core:GetPlayerCoords", function(coords)
                                           SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
                                           --print
                                           Core.TriggerCallback('Admin:SolveTicket', function(cb) end, v.ticketId)
                                           Core.TriggerCallback('Core:CallRemoteEvent', function() end, 'solveTicket', v.id)
                                       end, b.source)
                                   end
                                end
                            end)
                        end
                    end
                    
                end
            end
        end)
    end
end)

RegisterNetEvent("solveTicket", function()
    ticketCooldown = 0
    sendNotification("Ticket", "Ticketul tau a fost preluat.", "success")

end)

RegisterCommand('createticket', function()
   
    Core.TriggerCallback('Admin:GetTickets', function(tickets)
        for k,v in pairs(tickets) do
            if v.id == GetPlayerServerId(PlayerId()) then
                if not v.solved then
                    sendNotification("Ticket", "Ai deja un ticket in desfasurare.", "error")
                    return
                end
            else
                if ticketCooldown > 0 then
                    sendNotification("Ticket", "Trebuie sa mai astepti "..ticketCooldown.." minute.", "error")
                    return
                end
            end
        end
        local pData = Core.GetPlayerData()
    if pData.adminLevel > 0  then
        if pData.adminLevel >= 7 then
            ShowDialog('Ticket', 'Scrie mai jos motivul pentru care ai nevoie de asistenta!', 'ticket', true, false, 'c')
            local event
            event = AddEventHandler('ticket', function(ticketMsg)
                RemoveEventHandler(event)
                Core.TriggerCallback('Admin:SendTicket', function(ticket)
                    if ticket then
                        ticketCooldown = 10
                        
                        sendNotification("Ticket", "Ai trimis ticket-ul cu succes. Asteapta pana un admin te va ajuta.", "success")
                    else
                        sendNotification("Ticket", "Nu sunt membrii staff online!", "error")
                    end
                end, ticketMsg)
                return
            end)
        else
            sendNotification("Ticket", "Nu poti sa faci ticket ca admin!", "error")
        end
    else
        ShowDialog('Ticket', 'Scrie mai jos motivul pentru care ai nevoie de asistenta!', 'ticket', true, false, 'c')
        local event
        event = AddEventHandler('ticket', function(ticketMsg)
            RemoveEventHandler(event)
            Core.TriggerCallback('Admin:SendTicket', function(ticket)
                if ticket then
                    ticketCooldown = 2
                    sendNotification("Ticket", "Ai trimis ticket-ul cu succes. Asteapta pana un admin te va ajuta.", "success")
                else
                    sendNotification("Ticket", "Nu sunt membrii staff online!", "error")
                end
            end, ticketMsg)
            return
        end)
    end
    end)
   
end)


RegisterCommand('admin', function()
    adminMenu:ClearItems()
    local pData = PlayerData
    if HasAccess(1) then

        adminMenu:AddButton({
            icon = '🙍‍♂️',
            label = 'Jucatori online',
            value = 0,
            description = "",
        }):On("select", function()

           Core.TriggerCallback("Core:GetPlayers", function(players)
                playerList:ClearItems()
                playerOptions:ClearItems()
                for k,v in pairs(players) do
                    playerList:AddButton({
                        icon = '🙍‍♂️',
                        label = v.name.."("..v.source..")",
                        value = 0,
                        description = "",
                    }):On("select", function()
                        playerOptions:ClearItems()
                        if HasAccess(1) then
                            playerOptions:AddButton({
                                label = 'Sanctiuni',
                                icon = '🚫',
                            }):On('select', function()
                                sanctionsMenu:ClearItems()
                                if HasAccess(6) then
                                    sanctionsMenu:AddButton({
                                        icon = "🚫",
                                        label = 'Ban',
                                        value = 0
                                    }):On("select", function()
                                        local event, aBanReason, aBanTime
                                        ShowDialog('Baneaza jucatorul '..v.name..'['..v.source..']', "Scrie mai jos motivul interdictiei.", 'Admin:HandleBanReason', true, false, 'c')
                                        event = AddEventHandler("Admin:HandleBanReason", function(banReason)
                                            if string.len(banReason) == 0 then
                                                banReason = "Nedeterminata."
                                                aBanReason = banReason
                                            end
                                            aBanReason = banReason
                                            --print
                                            ShowDialog('Baneaza jucatorul '..v.name..'['..v.source..']', "Scrie mai durata in zile a interdictiei!", 'Admin:HandleBanTime', true, false, 'c')
                                            RemoveEventHandler(event)
                                            event = AddEventHandler('Admin:HandleBanTime', function(banTime)
                                                if not tonumber(banTime) or containsSpaces(banTime) then
                                                    sendNotification("Eroare", "Nu ai introdus un timp valid.")
                                                    return
                                                else
                                                    banTime = tonumber(banTime)
                                                    aBanTime = banTime
                                                    --print
                                                    if banTime == 0 then
                                                        banTime = 99999999
                                                    end
                                                    banData = {
                                                        banReason = banReason,
                                                        banTime = banTime,
                                                        banSource = v.source
                                                    }
                                                    Core.TriggerCallback('Admin:HandleBan', function(cb)
                                                        if cb then
                                                            Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..Core.GetPlayerData().user..' a banat jucatorul '..v.name..'['..v.source..'] pe motivul: '..banReason..'!')
                                                            sendNotification("Ban", 'L-ai banat pe jucatorul: '..v.name..' pe motiv: '..v.source..'!')
                                                        end
                                                    end, banData)
                                                    RemoveEventHandler(event)
                                                end
                                            end)
                                        end)
                                    end)
                                end
                                if HasAccess(1) then
                                    --create car button
                                    
        
                                    sanctionsMenu:AddButton({
                                        label = 'Unmute',
                                        icon = '🔊',
                                        value = 0
                                    }):On('select', function()
                                        Core.TriggerCallback('Admin:UnmutePlayer', function(cb)
                                            if cb then
                                                Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..Core.GetPlayerData().user..' a scos mute-ul jucatorului '..v.name..'['..v.source..']!')
                                                sendNotification("Unmute", 'I-ai scos mute-ul lui: '..v.name..'!')
                                            end
                                        end, v.source)
                                    end)
                                    sanctionsMenu:AddButton({
                                        label = 'Mute',
                                        icon = '🔇',
                                        value = 0
                                    }):On('select', function()
                                        local event, aMuteReason, aMuteTime
                                        ShowDialog('Mute jucatorul '..v.name..'['..v.source..']', "Scrie mai jos motivul mute-ului.", 'Admin:HandleMuteReason', true, false, 'c')
                                        event = AddEventHandler("Admin:HandleMuteReason", function(muteReason)
                                            if string.len(muteReason) == 0 then
                                                muteReason = "Nedeterminata."
                                                aMuteReason = muteReason
                                            end
                                            aMuteReason = muteReason
                                            --print
                                            ShowDialog('Mute jucatorul '..v.name..'['..v.source..']', "Scrie mai durata in minute a mute-ului!", 'Admin:HandleMuteTime', true, false, 'c')
                                            RemoveEventHandler(event)
                                            event = AddEventHandler('Admin:HandleMuteTime', function(muteTime)
                                                if not tonumber(muteTime) or containsSpaces(muteTime) then
                                                    sendNotification("Eroare", "Nu ai introdus un timp valid.")
                                                    return
                                                else
                                                    muteTime = tonumber(muteTime)
                                                    aMuteTime = muteTime
                                                    --print
                                                    if muteTime == 0 then
                                                        muteTime = 99999999
                                                    end
                                                    muteData = {
                                                        muteReason = muteReason,
                                                        muteTime = muteTime,
                                                        muteSource = v.source
                                                    }
                                                    Core.TriggerCallback('Admin:MutePlayer', function(cb)
                                                        if cb then
                                                            Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..Core.GetPlayerData().user..' a dat mute jucatorului '..v.name..'['..v.source..'] pe motivul: '..muteReason..'!')
                                                            sendNotification("Mute", 'L-ai amutit pe jucatorul: '..v.name..' pe motiv: '..v.source..'!')
                                                        end
                                                    end, v.source, muteData.muteTime, muteData.muteReason)
                                                    RemoveEventHandler(event)
                                                end
                                            end)
                                        end)
                                    end)
                                end
                                if HasAccess(2) then
                                    --add unjail 
                                    sanctionsMenu:AddButton({
                                        label = 'Unjail',
                                        icon = '🚓',
                                        value = 0
                                    }):On('select', function()
                                        jailData = {
                                            jailReason = "",
                                            jailTime = 0,
                                            jailSource = v.source
                                        }
                                        Core.TriggerCallback('Admin:HandleJail', function(cb)
                                            if cb then
                                                Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..Core.GetPlayerData().user..' a scos din inchisoare jucatorul '..v.name..'['..v.source..']!')
                                                sendNotification("Jail", 'L-ai inchis pe jucatorul: '..v.name..' pe motiv: '..v.source..'!')
                                            end
                                        end, jailData)
                                    end)
                                    sanctionsMenu:AddButton({
                                        label = 'Jail',
                                        icon = '🚓',
                                        value = 0
                                    }):On('select', function()
                                        local event, aJailReason, aJailTime
                                        ShowDialog('Inchide jucatorul '..v.name..'['..v.source..']', "Scrie mai jos motivul inchisorii.", 'Admin:HandleJailReason', true, false, 'c')
                                        event = AddEventHandler("Admin:HandleJailReason", function(jailReason)
                                            if string.len(jailReason) == 0 then
                                                jailReason = "Nedeterminata."
                                                aJailReason = jailReason
                                            end
                                            aJailReason = jailReason
                                            --print
                                            ShowDialog('Inchide jucatorul '..v.name..'['..v.source..']', "Scrie mai durata in minute a inchisorii!", 'Admin:HandleJailTime', true, false, 'c')
                                            RemoveEventHandler(event)
                                            event = AddEventHandler('Admin:HandleJailTime', function(jailTime)
                                                if not tonumber(jailTime) or containsSpaces(jailTime) then
                                                    sendNotification("Eroare", "Nu ai introdus un timp valid.")
                                                    return
                                                else
                                                    jailTime = tonumber(jailTime)
                                                    aJailTime = jailTime
                                                    --print
                                                    if jailTime == 0 then
                                                        jailTime = 99999999
                                                    end
                                                    jailData = {
                                                        jailReason = jailReason,
                                                        jailTime = jailTime,
                                                        jailSource = v.source
                                                    }
                                                    Core.TriggerCallback('Admin:HandleJail', function(cb)
                                                        if cb then
                                                            Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..Core.GetPlayerData().user..' a inchis jucatorul '..v.name..'['..v.source..'] pe motivul: '..jailReason..'!')
                                                            sendNotification("Jail", 'L-ai inchis pe jucatorul: '..v.name..' pe motiv: '..v.source..'!')
                                                        end
                                                    end, jailData)
                                                    RemoveEventHandler(event)
                                                end
                                            end)
                                        end)
                                    end)
                                end
                                if HasAccess(3) then
        
                                    sanctionsMenu:AddButton({
                                        icon = "🦶",
                                        label = 'Kick',
                                        value = 0
                                    }):On("select", function()
                                        local event
                                        ShowDialog("Kick "..v.name.."["..v.source.."]", 'Scrie mai jos motivul kickului.', 'Admin:HandleKickReason', false, false, 'c')
                                        event = AddEventHandler('Admin:HandleKickReason', function(reason)
                                            kickData = {
                                                kickSource = v.source,
                                                kickReason = reason
                                            }
                                            Core.TriggerCallback("Admin:HandleKick", function(cb)
                                                if cb then
                                                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..Core.GetPlayerData().user..' a dat kick jucatorului '..v.name..'['..v.source..'] pe motivul: '..reason..'!')
                                                    sendNotification("Kick", 'L-ai dat afara pe jucatorul '..v.name..'['..v.source..'] pe motivul: '..reason..'!')
                                                end
                                                RemoveEventHandler(event)
                                            end, kickData)
                                        end)
                                    end)
                                end
                                if HasAccess(7) then
                                    sanctionsMenu:AddButton({
                                        icon = "📃",
                                        label = 'Vezi istoric sanctiuni',
                                        value = 0
                                    }):On('select', function()
                                        playerPunishes:ClearItems()
                                        local player = v.source
                                        local pname = v.name
                                        Core.TriggerCallback("Player:GetPunishes", function(punishes)
                                            if #punishes == 0 then
                                                playerPunishes:AddButton({
                                                    label = 'Nu are sanctiuni',
                                                    icon = '🚫'
                                                })
                                            else
                                                for k,v in pairs(punishes) do
                                                    playerPunishes:AddButton({
                                                        label = v.type,
                                                        icon = '⭕'
                                                    }):On('select', function()
                                                        playerPunish:ClearItems()
                                                        
                                                        playerPunish:AddButton({
                                                            label = 'Tip: '..v.type,
                                                            icon = '🔗',
                                                            disabled = true
                                                        })
        
                                                        playerPunish:AddButton({
                                                            label = 'Motiv: '..v.reason,
                                                            icon = '🔗',
                                                            disabled = true
                                                        })
        
                                                        playerPunish:AddButton({
                                                            label = 'Admin: '..v.admin,
                                                            icon = '🙍‍♂️',
                                                            disabled = true
                                                        })
        
                                                        if v.type == 'Ban' then
                                                            playerPunish:AddButton({
                                                                label = 'Durata: '..v.duration..'/day(s)',
                                                                icon = '🕛',
                                                                disabled = true
                                                            })
                                                        elseif v.type == 'Jail' then
                                                            playerPunish:AddButton({
                                                                label = 'Durata: '..v.duration..'/checkpoint(s)',
                                                                icon = '🕛',
                                                                disabled = true
                                                            })
                                                        else
                                                            playerPunish:AddButton({
                                                                label = 'Durata: '..v.duration..'/minute(s)',
                                                                icon = '🕛',
                                                                disabled = true
                                                            })
                                                        end
                                                        
        
                                                        playerPunish:AddButton({
                                                            label = 'Actiuni:',
                                                            disabled = true
                                                        })
        
                                                        playerPunish:AddButton({
                                                            label = 'Sterge',
                                                            icon = '🚫'
                                                        }):On('select', function()
                                                            local removedata = {
                                                                player = player,
                                                                key = k
                                                            }
                                                            Core.TriggerCallback('Admin:RemovePlayerPunish', function(cb)
                                                                if cb then
                                                                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..Core.GetPlayerData().user..' a scos sanctiunea cu numarul '..k..' de tip '..v.type..' a lui '..pname..'!')
                                                                    sendNotification('Admin', 'Ai scos sanctiunea cu numarul '..k..' de tip '..v.type..' a lui '..pname..'!')
                                                                end
                                                            end, removedata)
                                                        end)
        
                                                        MenuV:OpenMenu(playerPunish)
                                                    end)
                                                end
                                            end
                                        end, v.source)
                                        MenuV:OpenMenu(playerPunishes)
                                    end)
                                end
                                MenuV:OpenMenu(sanctionsMenu)
                            end)
                        end
                        
        
                        if HasAccess(7) then
                            playerOptions:AddButton({
                                label = 'Economie',
                                icon = '💸',
                            }):On('select', function()
                                economyMenu:ClearItems()
                                economyMenu:AddButton({
                                    icon = "🏠",
                                    label = 'Vezi case',
                                    value = 0
                                }):On('select', function()
                                    playerHouses:ClearItems()
                                    MenuV:CloseAll()
                                    Core.TriggerCallback("Houses:GetOwnedById", function(houses)
                                        for k,v in pairs(houses) do
                                            local hData = json.decode(v.data)
                                            playerHouses:AddButton({
                                                label = hData.name,
                                                icon = '🏠',
                                                value = 0
                                            }):On('select', function()
                                                MenuV:CloseAll()
                                                playerHouse:ClearItems()
                                                playerHouse:AddButton({
                                                    label = 'Vinde',
                                                    icon = '💰',
                                                    value = 0,
                                                }):On('select', function()
                                                    local prevOwner = hData.owner
                                                    hData.owner = 'The State'
                                                    hData.ownerId = 0
    
                                                    hData.tenants = {}
    
                                                    Core.TriggerCallback('Admin:ChangeHouseData', function(cb)
                                                        --print
                                                        if cb == true then
                                                            TriggerServerEvent("Houses:RequireUpdate")
                                                            Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..Core.GetPlayerData().user..' a vandut casa '..hData.name.. ' detinuta de '..prevOwner..'!')
                                                            sendNotification('Admin', 'Ai vandut casa '..hData.name.. ' detinuta de '..prevOwner..'!')
                                                        else
                                                            --print
                                                        end
                                                        
                                                    end, hData)
                                                end)
    
                                                playerHouse:AddButton({
                                                    label = 'Teleport',
                                                    icon = '🔗',
                                                    value = 0,
                                                }):On('select', function()
                                                    MenuV:CloseAll()
                                                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..Core.GetPlayerData().user..' s-a teleportat la casa jucatorului '..hData.owner..'!')
                                                    SetEntityCoords(PlayerPedId(), hData.enter.x, hData.enter.y, hData.enter.z)
                                                end)
    
                                                playerHouse:AddButton({
                                                    label = 'Schimba pret chirie',
                                                    icon = '💸',
                                                    value = 0,
                                                }):On('select', function()
                                                    MenuV:CloseAll()
                                                    ShowDialog('Schimba pretul chiriei pentru casa: '..hData.name..'!', 'Scrie mai jos noul pret al chiriei pentru casa '..hData.name..' detinuta de '..hData.owner..'!', 'Admin:HandleChangeHouseRentAmount', false, true, 'c')
                                                    local event 
                                                    event = AddEventHandler("Admin:HandleChangeHouseRentAmount", function(price)
                                                        hData.rent = price
                                                        Core.TriggerCallback('Admin:ChangeHouseData', function(cb)
                                                            --print
                                                            if cb == true then
                                                                TriggerServerEvent("Houses:RequireUpdate")
                                                                Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..Core.GetPlayerData().user..' a schimbat pretul chiriei casei: '..hData.name..' la '..FormatNumber(price)..'!')
                                                                sendNotification('Admin', 'Ai schimbat pretul chiriei casei: '..hData.name..' la '..FormatNumber(price)..'!')
                                                            else
                                                                --print
                                                            end
                                                            RemoveEventHandler(event)
                                                        end, hData)
                                                    end)    
                                                end)
    
                                                playerHouse:AddButton({
                                                    label = 'Vezi chiriasi',
                                                    icon = '🙍‍♂️',
                                                    value = 0,
                                                }):On('select', function()
                                                    houseTenants:ClearItems()
                                                    Core.TriggerCallback("Houses:GetHouseTenants", function(tenants)
                                                        if #tenants == 0 then
                                                            houseTenants:AddButton({
                                                                label = 'Nu are chiriasi',
                                                                disabled = true,
                                                                icon = '🚫',
                                                                value = 0
                                                            })
                                                        else
                                                            for k,v in pairs(tenants) do
                                                                Core.TriggerCallback("Player:GetDataBySteamId", function(data)
                                                                    houseTenants:AddButton({
                                                                        label = data.user,
                                                                        disabled = true,
                                                                        icon = '🙍‍♂️',
                                                                        value = 0
                                                                    })
                                                                end, v.tenantId)
                                                            end
                                                        end
                                                    end, {id = hData.id})
                                                    MenuV:CloseAll()
                                                    MenuV:OpenMenu(houseTenants)
                                                end)
                                                MenuV:OpenMenu(playerHouse)
                                            end)
                                        end
                                        MenuV:OpenMenu(playerHouses)
                                    end, v.source)
                                end)
                
                                -- economyMenu:AddButton({
                                --     icon = "🏪",
                                --     label = 'Vezi afaceri',
                                --     value = 0
                                -- })
                
                                economyMenu:AddButton({
                                    icon = "🚗",
                                    label = 'Vezi masini',
                                    value = 0
                                }):On('select', function()
                                    playerCars:ClearItems()
                                    Core.TriggerCallback("Player:GetVehiclesById", function(vehicles)
                                        if not vehicles then
                                            playerCars:AddButton({
                                                label = 'Nu detine vehicule',
                                                icon = '🚫',
                                                disabled = true
                                            })
                                        else
                                            for k,v in pairs(vehicles) do
                                                local vData = json.decode(v.data)
                                                playerCars:AddButton({
                                                    label = vData.name.."["..vData.plate.."]",
                                                    icon = '🚗',
                                                    value = 0
                                                }):On("select", function()
                                                    playerCar:ClearItems()
                                                    playerCar:AddButton({
                                                        label = 'Sterge',
                                                        icon = '🚫'
                                                    }):On('select', function()
                                                        Core.TriggerCallback("Admin:RemoveOwnedVehicle", function(cb)
                                                            if cb then
                                                                MenuV:CloseAll()
                                                                Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..Core.GetPlayerData().user..' a sters masina '..vData.name..'!')
                                                                sendNotification('Admin', 'Ai sters masina '..vData.name..'!', 'success')
                                                            end
                                                        end, vData.plate)
                                                    end)
    
                                                    if vData.addons.vip then
                                                        playerCar:AddButton({
                                                            label = 'Scoate VIP',
                                                            icon = '⭐'
                                                        }):On('select', function()
                                                            vData.addons.vip = false
                                                            vData.id = v.id
                                                            Core.TriggerCallback("Admin:UpdateVehicleData", function(cb)
                                                                if cb then
                                                                    MenuV:CloseAll()
                                                                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..Core.GetPlayerData().user..' a sters VIP-ul masinii: '..vData.plate..'!')
                                                                    sendNotification('Admin', 'Ai sters VIP-ul masinii: '..vData.name..'!', 'success')
                                                                end
                                                            end, vData)
                                                        end)
                                                    end
                                                    if vData.addons.rainbow then
                                                        playerCar:AddButton({
                                                            label = 'Scoate Rainbow',
                                                            icon = '🌈'
                                                        }):On('select', function()
                                                            vData.addons.rainbow = false
                                                            vData.id = v.id
                                                            Core.TriggerCallback("Admin:UpdateVehicleData", function(cb)
                                                                if cb then
                                                                    MenuV:CloseAll()
                                                                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..Core.GetPlayerData().user..' a sters Rainbow-ul masinii: '..vData.plate..'!')
                                                                    sendNotification('Admin', 'Ai sters Rainbow-ul masinii: '..vData.name..'!', 'success')
                                                                end
                                                            end, vData)
                                                        end)
                                                    end
                                                
                                                    playerCar:AddButton({
                                                        label = 'Schimba numar inmatriculare',
                                                        icon = '📃'
                                                    }):On('select', function()
                                                        ShowDialog('Schimba numarul de inmatriculare', 'Scrie mai jos noul numar de inmatriculare:', 'Admin:HandleChangeVehiclePlate', true, true, 'c')
                                                    
                                                        local event
                                                        event = AddEventHandler('Admin:HandleChangeVehiclePlate', function(plate)
                                                            if string.len(plate) <= 7 then
                                                                local oldplate = vData.plate
                                                                vData.plate = plate
                                                                vData.id = v.id
                                                                Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..Core.GetPlayerData().user..' a schimbat numarul de inmatriculare al masinii: '..oldplate..' in '..plate..'!')
                                                                TriggerServerEvent('Vehicles:ChangePlate', oldplate, plate)
                                                            else
                                                                sendNotification('Eroare', 'Numarul de inmatriculare trebuie sa fie de maxim 6 caractere', 'error')
                                                            end
                                                            RemoveEventHandler(event)
                                                        end)
                                                          
                                                    end)
                                                    MenuV:OpenMenu(playerCar)
                                                end)
                                                
                                            end
                                             
                                        end
                                        MenuV:OpenMenu(playerCars)
                                    end, v.source)
                                end)
                                economyMenu:AddButton({
                                    icon = "💸",
                                    label = 'Ofera bani',
                                    value = 0
                                }):On('select', function()
                                    ShowDialog('Ofera bani', 'Scrie suma de bani pe care vrei sa o oferi jucatorului: '..v.name..'['..v.source..'].', 'Admin:HandleGiveMoney', true, true, 'c')
                                    local event
                                    event = AddEventHandler('Admin:HandleGiveMoney', function(money)
                                        RemoveEventHandler(event)
                                        if not tonumber(money) then
                                            sendNotification('Admin', 'Invalid input', 'error')
                                            return
                                        end
                                        money = tonumber(money)
                                        Core.TriggerCallback('Admin:Give', function(cb)
                                            
                                                Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' i-a oferit lui '..v.name..'['..v.source..'] '..FormatNumber(money)..'$!')
                                                sendNotification('Admin', 'I-ai oferit lui '..v.name..' '..FormatNumber(money)..'$!')
                                         
                                        end, {src = v.source, type = 'cash' ,amount = money})
                                    end)
                                end)
    
                                economyMenu:AddButton({
                                    icon = "💸",
                                    label = 'Retrage bani',
                                    value = 0
                                }):On('select', function()
                                    ShowDialog('Ofera bani', 'Scrie suma de bani pe care vrei sa o retragi jucatorului: '..v.name..'['..v.source..'].', 'Admin:HandleGiveMoney', true, true, 'c')
                                    local event
                                    event = AddEventHandler('Admin:HandleGiveMoney', function(money)
                                        RemoveEventHandler(event)
                                        if not tonumber(money) then
                                            sendNotification('Admin', 'Invalid input', 'error')
                                            return
                                        end
                                        money = tonumber(money)
                                        Core.TriggerCallback('Admin:Take', function(cb)
                                            if cb then
                                                Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' i-a retras lui '..v.name..'['..v.source..'] '..FormatNumber(money)..'$!')
                                                sendNotification('Admin', 'I-ai retras lui '..v.name..' '..FormatNumber(money)..'$!')
                                            end
                                        end, {src = v.source, type = 'cash' ,amount = money})
                                    end)
                                end)
    
                                economyMenu:AddButton({
                                    icon = "⭐",
                                    label = 'Ofera puncte premium',
                                    value = 0
                                }):On('select', function()
                                    ShowDialog('Ofera bani', 'Scrie suma de puncte premium pe care vrei sa o oferi jucatorului: '..v.name..'['..v.source..'].', 'Admin:HandleGiveMoney', true, true, 'c')
                                    local event
                                    event = AddEventHandler('Admin:HandleGiveMoney', function(money)
                                        RemoveEventHandler(event)
                                        if not tonumber(money) then
                                            sendNotification('Admin', 'Invalid input', 'error')
                                            return
                                        end
                                        money = tonumber(money)
                                        Core.TriggerCallback('Admin:Give', function(cb)
                                            Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' i-a oferit lui '..v.name..' '..FormatNumber(money)..'PP!')
                                            sendNotification('Admin', 'I-ai oferit lui '..v.name..' '..FormatNumber(money)..'PP!')
                                        end, {src = v.source, type = 'premiumPoints', amount = money})
                                    end)
                                end)
    
                                economyMenu:AddButton({
                                    icon = "⭐",
                                    label = 'Retrage puncte premium',
                                    value = 0
                                }):On('select', function()
                                    ShowDialog('Ofera bani', 'Scrie suma de puncte premium pe care vrei sa o retragi jucatorului: '..v.name..'['..v.source..'].', 'Admin:HandleGiveMoney', true, true, 'c')
                                    local event
                                    event = AddEventHandler('Admin:HandleGiveMoney', function(money)
                                        RemoveEventHandler(event)
                                        if not tonumber(money) then
                                            sendNotification('Admin', 'Invalid input', 'error')
                                            return
                                        end
                                        money = tonumber(money)
                                        Core.TriggerCallback('Admin:Take', function(cb)
                                            if cb then
                                                Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' i-a retras lui '..v.name..' '..FormatNumber(money)..'PP!')
                                                sendNotification('Admin', 'I-ai retras lui '..v.name..' '..FormatNumber(money)..'PP!')
                                            end
                                        end, {src = v.source, type = 'premiumPoints', amount = money})
                                    end)
                                end)
                                MenuV:OpenMenu(economyMenu)
                            end)
                            
                            if HasAccess(1) then
                                playerOptions:AddButton({
                                    label = 'Optiuni',
                                    icon = '🔧',
                                }):On('select', function ()
                                    playerSubOptions:ClearItems()
                                    playerSubOptions:AddButton({
                                        label = 'Teleport',
                                        icon = '🔗'
                                    }):On('select', function()
                                        DoScreenFadeOut(500)
                                        Citizen.Wait(500)
                                        Core.TriggerCallback('Core:GetPlayerById', function(player)
                                            local coords = player.coords
                                            SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
                                            Citizen.Wait(500)
                                            DoScreenFadeIn(500)
                                            sendNotification('Admin', 'Te-ai teleportat la '..v.name..'!')
                                            Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..GetPlayerName(PlayerId())..' s-a teleportat la '..v.name..'!')
                                        end, v.source)
                                    end)

                                    playerSubOptions:AddButton({
                                        label = 'Revive',
                                        icon = '🚑'
                                    }):On('select', function()
                                        Core.TriggerCallback('Admin:RevivePlayer', function(cb)
                                            if cb then
                                                sendNotification('Admin', 'I-ai dat revive lui '..v.name..'!')
                                            end
                                        end, v.source)
                                    end)

                                    --tp to me
                                    playerSubOptions:AddButton({
                                        label = 'TpToMe',
                                        icon = '🔗'
                                    }):On('select', function()
                                        local coords = GetEntityCoords(PlayerPedId())
                                        Core.TriggerCallback('Admin:TeleportPlayer', function(cb)
                                            if cb then
                                                sendNotification('Admin', 'L-ai teleportat pe '..v.name..' la tine!')
                                                Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' l-a teleportat pe '..v.name..' la el!')
                                            end
                                        end, v.source, coords)
                                    end)
                                    
                                    --respawn player
                                    playerSubOptions:AddButton({
                                        label = 'Respawn',
                                        icon = '🔗'
                                    }):On('select', function()
                                        Core.TriggerCallback('Admin:TeleportPlayer', function(cb)
                                            if cb then
                                                sendNotification('Admin', 'I-ai dat respawn lui '..v.name..'!')
                                                --add log
                                                Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' l-a respawnat pe '..v.name..'!')
                                            end
                                        end, v.source, {x = 1829.4075927734, y = 3681.0861816406, z = 34.335926055908}, 'respawn')
                                    end)
                                    
                                
                                    playerSubOptions:AddButton({
                                        label = 'Seteaza admin level',
                                        icon = '🔨'
                                    }):On('select', function()
                                        ShowDialog('Admin', 'Seteaza nivel admin al jucatorului: '..v.name..'['..v.source..'].', 'Admin:HandleAdminLevelChange', true, true, 'c')
                                        local event
                                        event = AddEventHandler('Admin:HandleAdminLevelChange', function(admin)
                                            RemoveEventHandler(event)
                                            if not tonumber(admin) then
                                                sendNotification('Admin', 'Invalid input', 'error')
                                                return
                                            end
                                            Core.TriggerCallback('Admin:SetLevel', function(cb)
                                                if cb then
                                                    sendNotification('Admin', 'I-ai setat lui '..v.name..' admin level '..admin..'!')
                                                    --ADD LOG
                                                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' i-a setat lui '..v.name..' admin level '..admin..'!')
                                                end
                                            end, {src = v.source, lvl = admin})
                                            RemoveEventHandler(event)
                                        end)
                                    end)
                                   
        
                                    playerSubOptions:AddButton({
                                        icon = "💼",
                                        label = 'Seteaza factiune',
                                        value = 0
                                    }):On('select', function()
                                        ShowDialog('Seteaza factiune', 'Scrie factiunea pe care vrei sa o setezi jucatorului: '..v.name..'['..v.source..'].', 'Admin:HandleSetFaction', true, true, 'c')
                                        local event
                                        event = AddEventHandler('Admin:HandleSetFaction', function(faction)
                                            RemoveEventHandler(event)
                                            if string.len(faction) == 0 then
                                                sendNotification('Admin', 'Invalid input', 'error')
                                                return
                                            end
                                            ShowDialog('Seteaza factiune', 'Scrie rankul pe care vrei sa il aiba: '..v.name..'['..v.source..'].', 'Admin:HandleSetFaction', true, true, 'c')
                                            event = AddEventHandler('Admin:HandleSetFaction', function(rank)
                                                RemoveEventHandler(event)
                                                if not tonumber(rank) then
                                                    sendNotification('Admin', 'Invalid input', 'error')
                                                    return
                                                end
                                                if tonumber(rank) then
                                                    rank = tonumber(rank)
                                                end
                                                Core.TriggerCallback('Core:GetPlayerById', function(player)
                                                    Core.TriggerCallback('Factions:AddMemberWithRank', function(cb)
                                                        if cb then
                                                            sendNotification('Admin', 'I-ai setat factiunea lui '..v.name..' la '..faction..'!')
                                                            --ADD LOG
                                                            Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' i-a setat lui '..v.name..' factiunea '..faction..'!')
                                                        end
                                                    end, faction, rank, player.data.identifier)
                                                end, v.source)
                                            end)
                                        end)
                                    end)
                                    MenuV:OpenMenu(playerSubOptions)
                                end)
                            end
                            
            
                            
                        end
                        
                        MenuV:OpenMenu(playerOptions)
                    end)
                end
                
           end)
           MenuV:OpenMenu(playerList)
        end)

        adminMenu:AddButton({
            icon = '🙍',
            label = 'Optiuni personale',
            value = 0,
            description = "",
        }):On("select", function()
            personalSettings:ClearItems()
            if HasAccess(1) then
                personalSettings:AddButton({
                    icon = '🔴',
                    label = 'Tp To Checkpoint'
                }):On('select', function ()
                    local cp = Core.GetActiveCheckpoint()
                    Core.TeleportToCp(cp)
                end)

                personalSettings:AddButton({
                    icon = '🟣',
                    label = 'Tp To Waypoint'
                }):On('select', function ()
                    local wp = GetFirstBlipInfoId(8)
                    if wp ~= 0 then
                        local wpCoords = GetBlipCoords(wp)
                        local z = GetGroundZFor_3dCoord(wpCoords.x, wpCoords.y, wpCoords.z, 0)
                        SetEntityCoords(PlayerPedId(), wpCoords.x, wpCoords.y, z)                        
                    else
                        sendNotification('Admin', 'Nu ai setat un waypoint!', 'error')
                    end
                end)

                personalSettings:AddButton({
                    icon = '🔧',
                    label = 'Fix',
                }):On('select', function()
                    SetVehicleFixed(GetVehiclePedIsIn(PlayerPedId()))
                    sendNotification('Admin', 'Ai reparat masina in care te afli!')
                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a reparat masina in care se afla!')
                end)
                personalSettings:AddButton({
                    icon = "🚗",
                    label = 'Spawncar',
                    value = 0
                }):On('select', function()
                    ShowDialog('Spawncar', 'Scrie mai jos numele masinii pe care vrei sa o creezi.', 'Admin:HandleCreateCar', true, true, 'c')
                    local event
                    event = AddEventHandler('Admin:HandleCreateCar', function(carName)
                        if string.len(carName) == 0 then
                            sendNotification('Eroare', 'Nu ai introdus un nume valid.')
                            return
                        end
                        local car = CreateCar(carName, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), true, true, true, "ADMIN")
                        Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a creat masina '..carName..'!')
                        RemoveEventHandler(event)
                    end)
                end)
            end
            if HasAccess(5) then
                personalSettings:AddButton({
                    label = 'Godmode',
                    icon = '💉',
                }):On('select', function()
                    godModeOn = not godModeOn
                    SetEntityInvincible(PlayerPedId(), godModeOn)
                    --send notification to tell he activated or deactivated godmode
                    sendNotification('Admin', 'Ai '..(godModeOn and 'activat' or 'dezactivat')..' godmode!')
                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' '..(godModeOn and 'a activat' or 'a dezactivat')..' godmode!')
                end)
                personalSettings:AddButton({
                    label = 'Coords',
                    icon = '🗺️',
                }):On('select', function()
                    SendNUIMessage({
                        action = 'copycoords',
                        value = GetEntityCoords(PlayerPedId()).x..','..GetEntityCoords(PlayerPedId()).y..','..GetEntityCoords(PlayerPedId()).z..','..GetEntityHeading(PlayerPedId())
                    })
                    TriggerServerEvent('print', GetEntityCoords(PlayerPedId()))
                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a copiat coordonatele!')
                end)
            end
            MenuV:OpenMenu(personalSettings)
        end)    
        
        if HasAccess(7) then
            adminMenu:AddButton({
                icon = '🏠',
                label = 'Case',
                value = 0,
                description = "",
            }):On("select", function()
                serverHousesMenu:ClearItems()
                
                serverHousesMenu:AddButton({
                    label = 'Creeaza casa',
                    icon = '🏠'
                }):On('select', function()
                    --TriggerServerEvent("Houses:Create", houseData) use later
                    MenuV:CloseAll()
                    ShowDialog('Creeaza casa 1/2', 'Seteaza pretul pe care-l doresti casei.', 'admin-createhouse', true, false, 'c')
                    local event;
                    event = AddEventHandler('admin-createhouse', function(price)
                        RemoveEventHandler(event)
                        if tonumber(price) then
                            price = tonumber(price)
                            createHouseData.price = price
                            ShowDialog('Creeaza casa 2/2', 'Seteaza tipul pe care-l doresti casei.<br><br>Tipuri case:<br>- Low<br>- Medium<br>- Normal', 'admin-createhouse', true, false, 'c')
                            event = AddEventHandler('admin-createhouse', function (type)
                                RemoveEventHandler(event)
                                if type == 'Normal' or type == 'Low' or type == 'Medium' then
                                    createHouseData.type = type
                                    Core.TriggerCallback('Houses:GetTypes', function(types)
                                        --print
                                        local pCoords = PlayerCoords()
                                        local shell_data = types[createHouseData.type]
                                        local houseData = {
                                            id = 0,
                                            name = 'Casa',
                                            price = createHouseData.price,
                                            level = shell_data.level,
                                            shell = shell_data.shellObject,
                                            locked = false,
                                            type = createHouseData.type,
                                            enter = GetEntityCoords(PlayerPedId()),
                                            exit = shell_data.exit,
                                            location = GetNameOfZone(pCoords.x, pCoords.y, pCoords.z).." - "..GetStreetNameFromHashKey(GetStreetNameAtCoord(pCoords.x, pCoords.y, pCoords.z)),
                                            tenants = {},
                                            rent = 125000,
                                            ownerId = 0,
                                            owner = 'The State'
                                        }
                                        sendNotification("Casa", 'Ai creat o casa de tip: '..createHouseData.type..' cu pretul de: $'..FormatNumber(createHouseData.price)..'!', "success")
                                        Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a creat o casa de tip: '..createHouseData.type..' cu pretul de: $'..FormatNumber(createHouseData.price)..'!')
                                        TriggerServerEvent("Houses:Create", houseData)
                                    end)
                                else
                                    sendNotification('Casa', 'Invalid type.')
                                end
                            end)
                        else
                            sendNotification('Casa', 'Invalid price.', 'error')
                        end
                    end)
                end)

                serverHousesMenu:AddButton({
                    label = 'Lista case',
                    icon = '🏠'
                }):On('select', function()
                    Core.TriggerCallback('Server:GetAllHouses', function(houses)
                        serverHouses:ClearItems()
                        --print
                        if not houses or table.empty(houses) then
                            serverHouses:AddButton({
                                label = 'Nu exista case.',
                                icon = '🚫',
                                disabled = true
                            })
                            return
                        else
                            for k,v in pairs(houses) do
                                local hData = json.decode(v.data)
                                if hData.ownerId == 0 then
                                    serverHouses:AddButton({
                                        label = hData.name,
                                        icon = '🟢'
                                    }):On('select', function()
                                        serverHouse:ClearItems()
                                        serverHouse:AddButton({
                                            label = 'Detinator: '..hData.owner,
                                            icon = '🙍‍♂️',
                                            disabled = true
                                        })
                                        serverHouse:AddButton({
                                            label = 'Locatie: '..hData.location,
                                            icon = '🌍',
                                            disabled = true
                                        })
                                        serverHouse:AddButton({
                                            label = 'Rent: $'..FormatNumber(hData.rent),
                                            icon = '💸',
                                            disabled = true
                                        })
                                        serverHouse:AddButton({
                                            label = 'Pret: $'..FormatNumber(hData.price),
                                            icon = '💰',
                                            disabled = true
                                        })
                                        serverHouse:AddButton({
                                            label = 'Chiriasi: '..#hData.tenants,
                                            icon = '🔗',
                                            disabled = true
                                        })
                                        serverHouse:AddButton({
                                            label = 'Level: '..hData.level,
                                            icon = '🏠',
                                            disabled = true
                                        })
    
                                        serverHouse:AddButton({
                                            label = 'Upgrade-uri:',
                                            icon = '',
                                            disabled = true
                                        })
    
                                        if hData.upgrades and hData.upgrades.remoteLock then
                                            serverHouse:AddButton({
                                                label = 'Incuietoare la distanta',
                                                icon = '🔒',
                                                disabled = true
                                            })
                                        else
                                            serverHouse:AddButton({
                                                label = 'Nu are upgrade-uri',
                                                icon = '🚫',
                                                disabled = true
                                            })
                                        end

                                        serverHouse:AddButton({
                                            label = 'Optiuni:',
                                            icon = '',
                                            disabled = true
                                        })

                                        serverHouse:AddButton({
                                            label = 'Sterge',
                                            icon = '🚫'
                                        }):On('select', function()
                                            Core.TriggerCallback("Houses:DeleteHouse", function(cb)
                                                if cb then
                                                    MenuV:CloseMenu(serverHouse)
                                                    sendNotification('Admin', 'Ai sters casa cu id: '..hData.id..'!')
                                                    TriggerServerEvent("Houses:RequireUpdate")
                                                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a sters casa cu id: '..hData.id..'!')
                                                end
                                            end, hData.id)
                                        end)

                                        serverHouse:AddButton({
                                            label = 'Scoate la vanzare',
                                            icon = '💰'
                                        }):On('select', function()
                                            hData.owner = 'The State'
                                            hData.ownerId = 0

                                            hData.tenants = {}

                                            Core.TriggerCallback('Admin:ChangeHouseData', function(cb)
                                                if cb then
                                                    TriggerServerEvent("Houses:RequireUpdate")
                                                    sendNotification('Admin', 'Ai scos la vanzare casa cu id: '..hData.id..'!')
                                                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a scos la vanzare casa cu id: '..hData.id..'!')
                                                end
                                            end, hData)
                                        end)

                                        serverHouse:AddButton({
                                            label = 'Schimba pret',
                                            icon = '💸'
                                        }):On('select', function()
                                            local event
                                            ShowDialog("Schimba pretul casei #"..hData.id.."", 'Scrie mai jos noul pret pentru casa cu numarul '..hData.id..'!', 'Admin:HandleHousePriceAmount', true, false, 'c')
                                            event = AddEventHandler('Admin:HandleHousePriceAmount', function(amount)
                                                amount = tonumber(amount)
                                                if amount < 0 then
                                                    return
                                                end
                                                hData.price = amount
                                                Core.TriggerCallback('Admin:ChangeHouseData', function(cb)
                                                    if cb then
                                                        TriggerServerEvent("Houses:RequireUpdate")
                                                        sendNotification('Admin', 'Ai schimbat pretul casei cu id: '..hData.id..' la $'..FormatNumber(hData.price)..'!')
                                                        Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a schimbat pretul casei cu id: '..hData.id..' la $'..FormatNumber(hData.price)..'!')
                                                    end
                                                end, hData)
                                            end)
                                        end)

                                        serverHouse:AddButton({
                                            label = 'Schimba pret chirie',
                                            icon = '🪙'
                                        }):On('select', function()
                                            local event
                                            ShowDialog("Schimba pretul chiriei casei #"..hData.id.."", 'Scrie mai jos noul pret al chiriei pentru casa cu numarul '..hData.id..'!', 'Admin:HandleHousePriceAmount', true, false, 'c')
                                            event = AddEventHandler('Admin:HandleHousePriceAmount', function(amount)
                                                amount = tonumber(amount)
                                                if amount < 0 then
                                                    return
                                                end
                                                hData.rent = amount
                                                Core.TriggerCallback('Admin:ChangeHouseData', function(cb)
                                                    if cb then
                                                        TriggerServerEvent("Houses:RequireUpdate")
                                                        Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a schimbat pretul chiriei casei cu id: '..hData.id..' la $'..FormatNumber(hData.rent)..'!')
                                                        sendNotification('Admin', 'Ai schimbat pretul chiriei casei cu id: '..hData.id..' la $'..FormatNumber(hData.price)..'!')
                                                    end
                                                end, hData)
                                            end)
                                        end)

                                        -- serverHouse:AddButton({
                                        --     label = 'Seteaza level',
                                        --     icon = '⬆️'
                                        -- })

                                        serverHouse:AddButton({
                                            label = 'Da afara toti chiriasii',
                                            icon = '🦶'
                                        }):On('select', function()
                                            hData.tenants = {}

                                            Core.TriggerCallback('Admin:ChangeHouseData', function(cb)
                                                if cb then
                                                    TriggerServerEvent("Houses:RequireUpdate")
                                                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a scos toti chiriasii casei cu id: '..hData.id..'!')
                                                    sendNotification('Admin', 'Ai scos toti chiriasii casei cu id: '..hData.id..'!')
                                                end
                                            end, hData)
                                        end)
                                        MenuV:OpenMenu(serverHouse)
                                    end)
                                else
                                    serverHouses:AddButton({
                                        label = hData.name,
                                        icon = '🔴'
                                    }):On('select', function()
                                        serverHouse:ClearItems()
                                        serverHouse:AddButton({
                                            label = 'Detinator: '..hData.owner,
                                            icon = '🙍‍♂️',
                                            disabled = true
                                        })
                                        serverHouse:AddButton({
                                            label = 'Locatie: '..hData.location,
                                            icon = '🌍',
                                            disabled = true
                                        })
                                        serverHouse:AddButton({
                                            label = 'Rent: $'..FormatNumber(hData.rent),
                                            icon = '💸',
                                            disabled = true
                                        })
                                        serverHouse:AddButton({
                                            label = 'Pret: $'..FormatNumber(hData.price),
                                            icon = '💰',
                                            disabled = true
                                        })
                                        serverHouse:AddButton({
                                            label = 'Chiriasi: '..#hData.tenants,
                                            icon = '🔗',
                                            disabled = true
                                        })
                                        serverHouse:AddButton({
                                            label = 'Level: '..hData.level,
                                            icon = '🏠',
                                            disabled = true
                                        })
    
                                        serverHouse:AddButton({
                                            label = 'Upgrade-uri:',
                                            icon = '',
                                            disabled = true
                                        })
    
                                        if hData.upgrades and hData.upgrades.remoteLock then
                                            serverHouse:AddButton({
                                                label = 'Incuietoare la distanta',
                                                icon = '🔒',
                                                disabled = true
                                            })
                                        else
                                            serverHouse:AddButton({
                                                label = 'Nu are upgrade-uri',
                                                icon = '🚫',
                                                disabled = true
                                            })
                                        end

                                        serverHouse:AddButton({
                                            label = 'Optiuni:',
                                            icon = '',
                                            disabled = true
                                        })

                                        serverHouse:AddButton({
                                            label = 'Sterge',
                                            icon = '🚫'
                                        }):On('select', function()
                                            Core.TriggerCallback("Houses:DeleteHouse", function(cb)
                                                if cb then
                                                    MenuV:CloseMenu(serverHouse)
                                                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a sters casa cu id: '..hData.id..'!')
                                                    sendNotification('Admin', 'Ai sters casa cu id: '..hData.id..'!')
                                                    TriggerServerEvent("Houses:RequireUpdate")
                                                end
                                            end, hData.id)
                                        end)

                                        serverHouse:AddButton({
                                            label = 'Scoate la vanzare',
                                            icon = '💰'
                                        }):On('select', function()
                                            hData.owner = 'The State'
                                            hData.ownerId = 0

                                            hData.tenants = {}

                                            Core.TriggerCallback('Admin:ChangeHouseData', function(cb)
                                                if cb then
                                                    TriggerServerEvent("Houses:RequireUpdate")
                                                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a scos la vanzare casa cu id: '..hData.id..'!')
                                                    sendNotification('Admin', 'Ai scos la vanzare casa cu id: '..hData.id..'!')
                                                end
                                            end, hData)
                                        end)

                                        serverHouse:AddButton({
                                            label = 'Schimba pret',
                                            icon = '💸'
                                        }):On('select', function()
                                            local event
                                            ShowDialog("Schimba pretul casei #"..hData.id.."", 'Scrie mai jos noul pret pentru casa cu numarul '..hData.id..'!', 'Admin:HandleHousePriceAmount', true, false, 'c')
                                            event = AddEventHandler('Admin:HandleHousePriceAmount', function(amount)
                                                amount = tonumber(amount)
                                                if amount < 0 then
                                                    return
                                                end
                                                hData.price = amount
                                                Core.TriggerCallback('Admin:ChangeHouseData', function(cb)
                                                    if cb then
                                                        TriggerServerEvent("Houses:RequireUpdate")
                                                        Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a schimbat pretul casei cu id: '..hData.id..' la $'..FormatNumber(hData.price)..'!')
                                                        sendNotification('Admin', 'Ai schimbat pretul casei cu id: '..hData.id..' la $'..FormatNumber(hData.price)..'!')
                                                    end
                                                end, hData)
                                            end)
                                        end)

                                        serverHouse:AddButton({
                                            label = 'Schimba pret chirie',
                                            icon = '🪙'
                                        }):On('select', function()
                                            local event
                                            ShowDialog("Schimba pretul chiriei casei #"..hData.id.."", 'Scrie mai jos noul pret al chiriei pentru casa cu numarul '..hData.id..'!', 'Admin:HandleHousePriceAmount', true, false, 'c')
                                            event = AddEventHandler('Admin:HandleHousePriceAmount', function(amount)
                                                amount = tonumber(amount)
                                                if amount < 0 then
                                                    return
                                                end
                                                hData.rent = amount
                                                Core.TriggerCallback('Admin:ChangeHouseData', function(cb)
                                                    if cb then
                                                        TriggerServerEvent("Houses:RequireUpdate")
                                                        Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a schimbat pretul chiriei casei cu id: '..hData.id..' la $'..FormatNumber(hData.rent)..'!')
                                                        sendNotification('Admin', 'Ai schimbat pretul chiriei casei cu id: '..hData.id..' la $'..FormatNumber(hData.price)..'!')
                                                    end
                                                end, hData)
                                            end)
                                        end)

                                        -- serverHouse:AddButton({
                                        --     label = 'Seteaza level',
                                        --     icon = '⬆️'
                                        -- })

                                        serverHouse:AddButton({
                                            label = 'Da afara toti chiriasii',
                                            icon = '🦶'
                                        }):On('select', function()
                                            hData.tenants = {}

                                            Core.TriggerCallback('Admin:ChangeHouseData', function(cb)
                                                if cb then
                                                    TriggerServerEvent("Houses:RequireUpdate")
                                                    Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a scos toti chiriasii casei cu id: '..hData.id..'!')
                                                    sendNotification('Admin', 'Ai scos toti chiriasii casei cu id: '..hData.id..'!')
                                                end
                                            end, hData)
                                        end)
    
                                        MenuV:OpenMenu(serverHouse)
                                    end)
                                end
                                
                            end
                        end
                    end)
                    MenuV:OpenMenu(serverHouses)

                end)

                
                MenuV:OpenMenu(serverHousesMenu)
            end)
            adminMenu:AddButton({
                icon = '🎫',
                label = 'Tickete',
                value = 0,
            }):On('select', function()
                ExecuteCommand('tickets')
            end)
            adminMenu:AddButton({
                icon = '🏪',
                label = 'Afaceri',
                value = 0,
                description = "",
            }):On("select", function()
                businessesSettings:ClearItems()

                businessesSettings:AddButton({
                    icon = '📃',
                    label = 'Creeaza afacere',
                    value = 0,
                    description = ""
                }):On('select', function()
                    MenuV:CloseAll()
                    ShowDialog('Creeaza afacere 1/4', 'Scrie mai jos numele dorit pentru afacere.', 'admin-createbiz', true, false, "c")
                    local event;
                    event = AddEventHandler('admin-createbiz', function(bizname)
                        if string.len(bizname) > 3 then
                            createBizData.name = bizname
                            RemoveEventHandler(event)
                            ShowDialog('Creeaza afacere 2/4', 'Scrie mai jos pretul dorit pentru afacere.', 'admin-createbiz', true, false, 'c')
                            event = AddEventHandler('admin-createbiz', function(bizprice)
                                if tonumber(bizprice) then
                                    createBizData.price = tonumber(bizprice)
                                    RemoveEventHandler(event)
                                    ShowDialog('Creeaza afacere 3/4', 'Scrie mai jos pretul tipul afacerii\n\nTipuri afaceri:\n1 - 24/7\n2 - Clothing', 'admin-createbiz', true, false, 'c')
                                    event = AddEventHandler('admin-createbiz', function(biztype)
                                        if tonumber(biztype) then
                                            biztype = tonumber(biztype)
                                            if biztype > 0 then
                                                createBizData.type = tonumber(biztype)
                                                RemoveEventHandler(event)
                                                ShowDialog('Creeaza afacere 4/4', 'Scrie mai jos blip-id-ul afacerii.', 'admin-createbiz', true, false, 'c')
                                                event = AddEventHandler('admin-createbiz', function(bizblip)
                                                    RemoveEventHandler(event)

                                                    if tonumber(bizblip) then
                                                        bizblip = tonumber(bizblip)
                                                        createBizData.blip = tonumber(bizblip)
                                                        local businessData = {
                                                            name = createBizData.name,
                                                            price = createBizData.price,
                                                            safe = 0,
                                                            income = tonumber(createBizData.price)/10,
                                                            owner = 0,
                                                            ownerName = 'The State',
                                                            type = createBizData.type,
                                                            coords = GetEntityCoords(PlayerPedId()),
                                                            blip = createBizData.blip
                                                        }
                                                    
                                                        Core.TriggerCallback("Business:Create", function(cb)
                                                            if cb then
                                                                Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a creat o afacere cu numele: '..createBizData.name..'!')
                                                                sendNotification('Afacere', Lang[Language]['BusinessCreated'])
                                                                TriggerServerEvent('Business:RequireUpdate')
                                                            else
                                                                sendNotification('Afacere', Lang[Language]['BusinessCreateFail'])
                                                            end
                                                        end, businessData)
                                                    else
                                                        sendNotification('Afaceri', 'Invalid business blip', 'error')
                                                    end
                                                end)
                                            else
                                                sendNotification('Afaceri', 'Invalid business type.', 'error')
                                            end
                                        else
                                            sendNotification('Afaceri', 'Invalid business type.', 'error')
                                        end
                                    end)
                                else
                                    sendNotification('Afaceri', 'Pretul trebuie sa fie in cifre.', 'error')
                                end
                            end)
                        else
                            sendNotification('Afaceri', 'Numele trebuie sa aiba mai mult de 3 caractere.', 'error')
                        end
                        
                    end)
                end)

                businessesSettings:AddButton({
                    icon = '📃',
                    label = 'Vezi afacerile',
                    value = 0,
                    description = ""
                }):On('select', function()
                    
                    businessesList:ClearItems()
                    Core.TriggerCallback('Business:Get', function(businesses)
                        if #businesses == 0 then
                            businessesList:AddButton({
                                label = 'Nu exista afaceri',
                                icon = '🚫',
                            })
                        else
                            for k,v in pairs(businesses) do
                                local bData = jd(v.data)
                                businessesList:AddButton({
                                    label = ''..bData.name,
                                    icon = '🏪'
                                }):On('select', function()
                                    businessCfg:ClearItems()
                                    --create buttons for business owner, name and price, disabled
                                    local businessOwner = businessCfg:AddButton({
                                        label = 'Proprietar: '..bData.ownerName,
                                        icon = '👤',
                                        disabled = true
                                    })
                                    local businessName = businessCfg:AddButton({
                                        label = 'Nume: '..bData.name,
                                        icon = '🏪',
                                        disabled = true
                                    })
                                    local businessPrice = businessCfg:AddButton({
                                        label = 'Pret: '..FormatNumber(bData.price)..'$', --bData.price,
                                        icon = '💰',
                                        disabled = true
                                    })
                                    local businessPrice = businessCfg:AddButton({
                                        label = 'Optiuni',
                                        icon = '',
                                        disabled = true
                                    })
                                    businessCfg:AddButton({
                                        label = 'Sterge',
                                        icon = '🚫'
                                    }):On('select', function()
                                        Core.TriggerCallback('Business:Delete', function(cb)
                                            if cb then
                                                Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a sters o afacere cu numele: '..bData.name..'!')
                                                sendNotification('Afacere', Lang[Language]['BusinessRemoved'])
                                                TriggerServerEvent('Business:RequireUpdate')
                                            else
                                                sendNotification('Afacere', Lang[Language]['BusinessRemoveFail'])
                                            end
                                        end, bData.id)
                                    end)
                                    businessCfg:AddButton({
                                        label = 'Editare nume',
                                        icon = '✏️'
                                    }):On('select', function()
                                        MenuV:CloseAll()

                                        ShowDialog('Editare afacere', 'Scrie mai jos numele dorit pentru afacere.', 'admin-createbiz', true, false, 'c')
                                        local event;
                                        event = AddEventHandler('admin-createbiz', function(bizname)
                                            RemoveEventHandler(event)
                                            if string.len(bizname) > 3 then
                                                Core.TriggerCallback('Business:EditBusiness', function(cb)
                                                    if cb then
                                                        Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a editat o afacere cu numele: '..bData.name..'!')
                                                        sendNotification('Afacere', Lang[Language]['BusinessUpdated'])
                                                        TriggerServerEvent('Business:RequireUpdate')
                                                    else
                                                        sendNotification('Afacere', Lang[Language]['BusinessUpdateFail'])
                                                    end
                                                end, bData.id, 'name', bizname)
                                            else
                                                sendNotification('Afacere', 'Numele trebuie sa aiba mai mult de 3 caractere.', 'error')
                                            end
                                        end)
                                    end)
                                    businessCfg:AddButton({
                                        label = 'Editare pret',
                                        icon = '💰'
                                    }):On('select', function()
                                        MenuV:CloseAll()

                                        ShowDialog('Editare afacere', 'Scrie mai jos pretul dorit pentru afacere.', 'admin-createbiz', true, false, 'c')
                                        local event;
                                        event = AddEventHandler('admin-createbiz', function(bizprice)
                                            RemoveEventHandler(event)
                                            if tonumber(bizprice) then
                                                Core.TriggerCallback('Business:EditBusiness', function(cb)
                                                    if cb then
                                                        Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a editat o afacere cu numele: '..bData.name..'!')
                                                        sendNotification('Afacere', Lang[Language]['BusinessUpdated'])
                                                        TriggerServerEvent('Business:RequireUpdate')
                                                    else
                                                        sendNotification('Afacere', Lang[Language]['BusinessUpdateFail'])
                                                    end
                                                end, bData.id, 'price', bizprice)
                                            else
                                                sendNotification('Afacere', 'Pretul trebuie sa fie in cifre.', 'error')
                                            end
                                        end)
                                    end)
                                    businessCfg:AddButton({
                                        label = 'Teleport',
                                        icon = '🗺️'
                                    }):On('select', function()
                                        local bCoords = bData.coords
                                        Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' s-a teleportat la afacerea cu numele: '..bData.name..'!')
                                        SetEntityCoords(PlayerPedId(), bCoords.x, bCoords.y, bCoords.z, 0, 0, 0, 0)
                                        sendNotification('Afacere', 'Te-ai teleportat la afacere.')
                                    end)
                                    MenuV:OpenMenu(businessCfg)
                                end)
                            end
                        end
                        MenuV:OpenMenu(businessesList)
                    end)
                end)

                MenuV:OpenMenu(businessesSettings)


            end)
            
            adminMenu:AddButton({
                icon = '🚗',
                label = 'Vehicule',
                value = 0,
                description = "",
            }):On("select", function()
               serverCars:ClearItems()
               Core.TriggerCallback('Server:GetAllOwnedVehicles', function(vehicles)
                 if #vehicles == 0 then
                    serverCars:AddButton({
                        label = 'Nu exista masini detinute',
                        icon = '🚫',
                    })
                else
                    for k,v in pairs(vehicles) do
                        local vData = json.decode(v.data)
                        serverCars:AddButton({
                            label = ''..v.plate..' - '..v.name,
                            icon = '🚘'
                        }):On('select', function()
                            serverCar:ClearItems()
                            serverCar:AddButton({
                                label = 'Sterge',
                                icon = '🚫'
                            }):On('select', function()
                                Core.TriggerCallback('Admin:RemoveOwnedVehicle', function(cb)
                                    if cb then
                                        Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a sters masina cu numarul de inmatriculare: '..v.plate..'!')
                                        sendNotification('Admin', 'Ai sters masina: '..vData.name..'['..vData.plate..']!')
                                        MenuV:CloseAll()
                                    end
                                end, vData.plate)
                            end)

                            serverCar:AddButton({
                                label = 'Schimba numar inmatriculare',
                                icon = '📄'
                            }):On('select', function()
                                ShowDialog('Schimba numarul de inmatriculare', 'Scrie mai jos noul numar de inmatriculare:', 'Admin:HandleChangeVehiclePlate', true, true, 'c')
                                                
                                local event
                                event = AddEventHandler('Admin:HandleChangeVehiclePlate', function(plate)
                                    if string.len(plate) <= 7 then
                                        local oldplate = vData.plate
                                        vData.plate = plate
                                        vData.id = v.id
                                        Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a schimbat numarul de inmatriculare de la: '..oldplate..' la '..plate..'!')
                                        TriggerServerEvent('Vehicles:ChangePlate', oldplate, plate)
                                    else
                                        sendNotification('Eroare', 'Numarul de inmatriculare trebuie sa fie de maxim 6 caractere', 'error')
                                    end
                                    RemoveEventHandler(event)
                                end)
                            end)
                            if not vData.addons then
                                vData.addons = {}
                            end
                            if not vData.addons.vip then
                                serverCar:AddButton({
                                    label = 'Adauga VIP',
                                    icon = '⭐'
                                }):On('select', function()
                                    vData.addons.vip = true
                                    vData.id = v.id
                                    Core.TriggerCallback("Admin:UpdateVehicleData", function(cb)
                                        if cb then
                                            MenuV:CloseAll()
                                            Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a adaugat VIP masinii: '..vData.name..'!')
                                            sendNotification('Admin', 'Ai adaugat VIP masinii: '..vData.name..'!', 'success')
                                        end
                                    end, vData)
                                end)
                            else
                                serverCar:AddButton({
                                    label = 'Scoate VIP',
                                    icon = '⭐'
                                }):On('select', function()
                                    vData.addons.vip = false
                                    vData.id = v.id
                                    Core.TriggerCallback("Admin:UpdateVehicleData", function(cb)
                                        if cb then
                                            MenuV:CloseAll()
                                            Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a scos VIP-ul masinii: '..vData.name..'!')
                                            sendNotification('Admin', 'Ai scos VIP-ul masinii: '..vData.name..'!', 'success')
                                        end
                                    end, vData)
                                end)
                            end

                            if not vData.addons.rainbow or not vData.addons then
                                serverCar:AddButton({
                                    label = 'Adauga Rainbow',
                                    icon = '🌈'
                                }):On('select', function()
                                    vData.addons.rainbow = true
                                    vData.id = v.id
                                    Core.TriggerCallback("Admin:UpdateVehicleData", function(cb)
                                        if cb then
                                            MenuV:CloseAll()
                                            Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a adaugat Rainbow masinii: '..vData.name..'!')
                                            sendNotification('Admin', 'Ai adaugat Rainbow masinii: '..vData.name..'!', 'success')
                                        end
                                    end, vData)
                                end)
                            else
                                serverCar:AddButton({
                                    label = 'Scoate Rainbow',
                                    icon = '🌈'
                                }):On('select', function()
                                    vData.addons.rainbow = false
                                    vData.id = v.id
                                    Core.TriggerCallback("Admin:UpdateVehicleData", function(cb)
                                        if cb then
                                            MenuV:CloseAll()
                                            Core.TriggerCallback('Admin:Log', function() end, '[^3ADMIN^0] Adminul '..pData.user..' a scos Rainbow-ul masinii: '..vData.name..'!')
                                            sendNotification('Admin', 'Ai sters Rainbow-ul masinii: '..vData.name..'!', 'success')
                                        end
                                    end, vData)
                                end)
                            end

                            MenuV:OpenMenu(serverCar)
                        end)
                    end
                    MenuV:OpenMenu(serverCars)
                end
               end)
            end)
        end
        
        MenuV:OpenMenu(adminMenu)
    else
        sendNotification("Admin", Lang[Language]['NoAccessToCMD'])
        
        return
    end
   
end, restricted)