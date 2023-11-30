local playerMenu = MenuV:CreateMenu(false, "Meniu jucator", "centerright", 0, 0, 0, 'size-150', 'none', 'menuv',
    'playermenu-main')
local playerOptions = MenuV:CreateMenu(false, "Optiuni jucator", "centerright", 0, 0, 0, 'size-150', 'none', 'menuv',
    'playermenu-options')
local wantedPlayers = MenuV:CreateMenu(false, "Wanted players", "centerright", 0, 0, 0, 'size-150', 'none', 'menuv',
    'playermenu-wantedplayers')
local wantedPlayer = MenuV:CreateMenu(false, "Wanted", "centerright", 0, 0, 0, 'size-150', 'none', 'menuv',
    'playermenu-wantedplayer')
local factions = {}

local targetCp = {}
local targetPlayer = {}

local playerOptionsBuild = false

Citizen.CreateThread(function()
    while true do
        local wait = 3005
        if not table.empty(targetCp) then
            if DoesCPExist(targetCp) then
                wait = 3005
                Core.TriggerCallback('Core:GetPlayerById', function(player)
                    if player then
                        targetPlayer = player
                        ModifyCP(targetCp, 1, targetPlayer.coords, { 255, 0, 0, 100 }, 5.0, 100.0)
                    end
                end, targetPlayer.id)
            else
                wait = 3005
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent('updatetargetdata', function(a, b)
    targetCp = a
    targetPlayer = b
end)
BuildPlayerOptions = function()
    local pData = Core.GetPlayerData()
    local fData = pData.faction
    if fData then
        if factions[fData.name] then
            playerOptions:AddButton({
                label = 'Optiuni factiune',
                icon = '',
                value = 0,
                disabled = true
            })
            if factions[fData.name].type == 'ems' then
                playerOptions:AddButton({
                    label = 'Trateaza jucator',
                    icon = '💊',
                    value = 0,
                    disabled = false
                }):On('select', function()
                    local nearestPed = GetPedInFront()

                    local healPlayer

                    if nearestPed then
                        healPlayer = GetNearestPlayer()
                        
                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            sendNotification('Tratament', 'Nu poti trata un jucator dintr-o masina.', 'error')
                            return
                        end
                        if healPlayer then
                            Core.TriggerCallback('EMS:Heal', function(healed)
                                if healed then
                                    sendNotification('Tratament', 'L-ai tratat pe ' .. GetPlayerName(healPlayer).. '!', 'success')
                                else
                                    SetEntityHealth(nearestPed, 200)
                                end
                            end, healPlayer)
                        else
                            sendNotification('Tratament', 'Nu exista jucatori in apropiere.', 'error')
                        end
                    end
                end)
            end
            if factions[fData.name].type == 'lege' or factions[fData.name].type == 'mafie' then
                playerOptions:AddButton({
                    label = 'Incatuseaza jucator',
                    icon = '👮‍♂️',
                    value = 0,
                }):On('select', function()
                    local nearestPed = GetPedInFront()
    
                    local cuffPlayer
                    if nearestPed then
                        cuffPlayer = GetNearestPlayer()
                 
                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            sendNotification('Catuse', 'Nu poti incatusa un jucator dintr-o masina.', 'error')
                            return
                        end
    
                        Core.TriggerCallback('Police:Cuff', function(cuffed)
                            if cuffed then
                                --sendNotification('Catuse', 'L-ai incatusat pe ' .. GetPlayerName(cuffPlayer).. '!', 'success')
                            else
                                --sendNotification('Catuse', 'Jucatorul nu a putut fi incatusat!', 'error')
                            end
                        end, cuffPlayer)
                    end
                end)
            end
            if factions[fData.name].type == 'lege' then
                playerOptions:AddButton({
                    label = 'Lista wanted',
                    icon = '⭐',
                }):On('select', function()
                    Core.TriggerCallback("Police:GetWanted", function(wanteds)
                        if table.empty(wanteds) then
                            sendNotification('Wanted', 'Nu exista jucatori wanted.', 'error')
                            return
                        end
                        wantedPlayers:ClearItems()
                        for k, v in pairs(wanteds) do
                            if v.level > 0 then
                                wantedPlayers:AddButton({
                                    label = v.name .. '[' .. v.level .. '⭐]',
                                    icon = '⭐',
                                    value = 0,
                                    description = v.reason,
                                }):On('select', function()
                                    wantedPlayer:ClearItems()
                                    wantedPlayer:AddButton({
                                        label = 'Nume: ' .. v.name,
                                        icon = '👤',
                                        value = 0,
                                        description = v.reason,
                                        disabled = true
                                    })
                                    wantedPlayer:AddButton({
                                        label = 'Wanted level: ' .. v.level,
                                        icon = '⭐',
                                        value = 0,
                                        description = v.reason,
                                        disabled = true
                                    })
                                    wantedPlayer:AddButton({
                                        label = 'Reason: ' .. v.reason,
                                        icon = '📃',
                                        value = 0,
                                        description = v.reason,
                                        disabled = true
                                    })
                                    wantedPlayer:AddButton({
                                        label = 'Optiuni',
                                        icon = '',
                                        value = 0,
                                        description = v.reason,
                                        disabled = true
                                    })
    
                                    wantedPlayer:AddButton({
                                        label = 'Sterge',
                                        icon = '❌',
                                        value = 0,
                                        description = v.reason,
                                    }):On('select', function()
                                        Core.TriggerCallback('Police:SetWanted', function(cb)
                                            MenuV:CloseAll()
                                        end, v.id, 0, '')
                                    end)
    
                                    wantedPlayer:AddButton({
                                        label = 'Modifica',
                                        icon = '✏️',
                                        value = 0,
                                        description = v.reason,
                                    }):On('select', function()
                                        ShowDialog("Seteaza wanted", 'Scrie mai jos nivelul de wanted.', 'wanted', true,
                                            false, 'c')
                                        event = Core.AddEventHandler('wanted', function(level)
                                            RemoveEventHandler(event)
                                            if tonumber(level) then
                                                level = tonumber(level)
                                                ShowDialog("Seteaza wanted", 'Scrie motivul wantedului mai jos.', 'wanted',
                                                    true, false, 'c')
                                                event = Core.AddEventHandler('wanted', function(reason)
                                                    RemoveEventHandler(event)
                                                    if string.len(reason) > 0 then
                                                        Core.TriggerCallback('Police:SetWanted', function()
                                                            sendNotification("Wanted",
                                                                'Ai dat wanted level ' .. level .. ' unui jucator!')
                                                        end, v.id, level, reason)
                                                    else
                                                        sendNotification("Wanted", 'Invalid reason', 'error')
                                                    end
                                                end)
                                            else
                                                sendNotification("Wanted", 'Invalid level', 'error')
                                            end
                                        end)
                                    end)
    
                                    wantedPlayer:AddButton({
                                        label = 'Seteaza checkpoint',
                                        icon = '🔴',
                                        value = 0,
                                        description = v.reason,
                                    }):On('select', function()
                                        if table.empty(targetCp) then
                                            Core.TriggerCallback('Core:GetPlayerById', function(player)
                                                if player then
                                                    local targetPlayer = player
                                                    local targetCp = CreateCP(1, player.coords, { 255, 0, 0, 255 }, 5.0,
                                                        200.0, function()
                                                    end)
    
                                                    TriggerServerEvent('sv:updatetargetdata', targetCp, targetPlayer)
                                                    sendNotification('Checkpoint', 'Ai setat checkpoint la infractor!',
                                                        'success')
                                                end
                                            end, v.id)
                                        else
                                            DeleteCP(targetCp)
                                            targetCp = {}
                                            sendNotification('Checkpoint', 'Ti-ai anulat checkpointul', 'success')
                                        end
                                    end)
    
                                    MenuV:OpenMenu(wantedPlayer)
                                end)
                            end
                        end
                        MenuV:OpenMenu(wantedPlayers)
                    end)
                end)
                playerOptions:AddButton({
                    label = 'Amendeaza',
                    icon = '📃',
                })
                playerOptions:AddButton({
                    label = 'Aresteaza',
                    icon = '🚧',
                }):On('select', function()
                    ShowDialog("Aresteaza", 'Scrie mai jos ID-ul jucatorului caruia vrei sa-l arestezi.', 'arest', true,
                        false, 'c')
                    local event
                    event = Core.AddEventHandler('arest', function(id)
                        RemoveEventHandler(event)
                        if tonumber(id) then
                            id = tonumber(id)
                            if IsPlayerConnected(id) then
                                ShowDialog("Aresteaza", 'Scrie mai jos timpul de arestare.', 'arest', true, false, 'c')
                                event = Core.AddEventHandler('arest', function(time)
                                    RemoveEventHandler(event)
                                    if tonumber(time) then
                                        time = tonumber(time)
                                        ShowDialog("Aresteaza", 'Scrie motivul arestarii mai jos.', 'arest', true, false, 'c')
                                        event = Core.AddEventHandler('arest', function(reason)
                                            RemoveEventHandler(event)
                                            if string.len(reason) > 0 then
                                                Core.TriggerCallback("Core:GetNearestPlayer", function(closestPlayer)
                                                    if not closestPlayer then
                                                        sendNotification("Arest", 'Nu exista jucatori in apropiere!', 'error')
                                                        return
                                                    end
                                                    closestPlayer = tonumber(closestPlayer)
                                                    id = tonumber(id)
                                                    if closestPlayer ~= id then
                                                        sendNotification("Arest",
                                                            'Nu poti aresta un jucator care nu e langa tine!', 'error')
                                                        return
                                                    end
    
                                                    Core.TriggerCallback('Core:GetPlayerById', function(player)
                                                        Core.TriggerCallback('Police:Arrest', function()
                                                        end, id, time, reason)
                                                        Core.TriggerCallback('Admin:Log', function()
                                                        end, 'arest',
                                                            '[^2POLITIE^0] Politistul ' ..
                                                            GetPlayerName(PlayerId()) ..
                                                            ' l-a arestat pe ' ..
                                                            GetPlayerName(id) ..
                                                            ' pentru ' .. time .. ' minute pentru ' .. reason .. '.')
                                                    end, id)
                                                end)
                                            else
                                                sendNotification("Arest", 'Invalid reason', 'error')
                                            end
                                        end)
                                    else
                                        sendNotification("Arest", 'Invalid time', 'error')
                                    end
                                end)
                            else
                                sendNotification("Arest", 'Invalid id', 'error')
                            end
                        else
                            sendNotification("Arest", 'Invalid id', 'error')
                        end
                    end)
                end)
                playerOptions:AddButton({
                    label = 'Scoate din arest',
                    icon = '🚧',
                }):On('select', function()
                    ShowDialog("Scoate din arest", 'Scrie mai jos ID-ul jucatorului caruia vrei sa-l scoti din arest.',
                        'unarest', true, false, 'c')
                    local event
                    event = Core.AddEventHandler('unarest', function(id)
                        RemoveEventHandler(event)
                        if tonumber(id) then
                            id = tonumber(id)
                            if IsPlayerConnected(id) then
                                Core.TriggerCallback('Police:Free', function()
                                end, id)
                                Core.TriggerCallback('Admin:Log', function()
                                end, 'unarest',
                                    '[^2POLITIE^0] Politistul ' ..
                                    GetPlayerName(PlayerId()) .. ' l-a scos din arest pe ' .. GetPlayerName(id) .. '.')
                            else
                                sendNotification("Unarest", 'Invalid id', 'error')
                            end
                        else
                            sendNotification("Unarest", 'Invalid id', 'error')
                        end
                    end)
                end)
                playerOptions:AddButton({
                    label = 'Seteaza wanted',
                    icon = '⭐',
                }):On('select', function()
                    ShowDialog("Seteaza wanted", 'Scrie mai jos ID-ul jucatorului caruia vrei sa-i dai wanted.', 'wanted',
                        true, false, 'c')
                    local event
                    event = Core.AddEventHandler('wanted', function(id)
                        RemoveEventHandler(event)
                        if tonumber(id) then
                            id = tonumber(id)
                            if IsPlayerConnected(id) then
                                ShowDialog("Seteaza wanted", 'Scrie mai jos nivelul de wanted.', 'wanted', true, false, 'c')
                                event = Core.AddEventHandler('wanted', function(level)
                                    RemoveEventHandler(event)
                                    if tonumber(level) then
                                        level = tonumber(level)
                                        ShowDialog("Seteaza wanted", 'Scrie motivul wantedului mai jos.', 'wanted', true,
                                            false, 'c')
                                        event = Core.AddEventHandler('wanted', function(reason)
                                            RemoveEventHandler(event)
                                            if string.len(reason) > 0 then
                                                Core.TriggerCallback('Police:SetWanted', function()
                                                    sendNotification("Wanted",
                                                        'Ai dat wanted level ' .. level .. ' unui jucator!')
                                                end, id, level, reason)
                                            else
                                                sendNotification("Wanted", 'Invalid reason', 'error')
                                            end
                                        end)
                                    else
                                        sendNotification("Wanted", 'Invalid level', 'error')
                                    end
                                end)
                            else
                                sendNotification("Wanted", 'Invalid id', 'error')
                            end
                        else
                            sendNotification("Wanted", 'Invalid id', 'error')
                        end
                    end)
                end)
            end
        else
            --sendNotification('Factiune', 'Nu esti intr-o factiune!', 'error')
        end
    end
    


    playerOptions:AddButton({
        label = 'Optiuni player',
        icon = '',
        value = 0,
        disabled = true
    })
    playerOptions:AddButton({
        label = 'Ofera bani',
        icon = '💸',
        value = 0,
        select = function()
            --write code to get the nearest player id and give money to him
        end
    })
    playerOptionsBuild = true
end
function BuildPlayerMenu()
    playerMenu:ClearItems()
    local pData = Core.GetPlayerData()
    local fData = pData.faction
    if not pData then
        return
    end
    BuildPlayerOptions()
    --print
    if pData.adminLevel > 0 then
        playerMenu:AddButton({
            label = 'Admin',
            icon = '👑',
            value = 0,
            select = function()
                ExecuteCommand('admin')
            end
        })
        if pData.adminLevel >= 7 then
            playerMenu:AddButton({
                label = 'Ticket admin',
                icon = '🆘',
                value = 0,
                select = function()
                    ExecuteCommand('createticket')
                end
            })
        end
    else
        playerMenu:AddButton({
            label = 'Ticket admin',
            icon = '🆘',
            value = 0,
            select = function()
                ExecuteCommand('createticket')
            end
        })
    end



    playerMenu:AddButton({
        label = 'Masini detinute',
        icon = '🚗',
        value = 0,
        select = function()
            MenuV:CloseAll()
            ExecuteCommand('v')
        end
    })

    playerMenu:AddButton({
        label = 'Case detinute',
        icon = '🏠',
        value = 0,
        select = function()
            MenuV:CloseAll()
            ExecuteCommand('houses')
        end
    })

    local factionData = pData.faction

    playerMenu:AddButton({
        label = 'Optiuni jucator',
        icon = '🙍‍♂️',
        value = 0,
    }):On('select', function()
        playerOptions:ClearItems()
        BuildPlayerOptions()
        MenuV:OpenMenu(playerOptions)
    end)


    if factionData.id ~= 0 then
        playerMenu:AddButton({
            label = 'Factiune',
            icon = '💼',
            value = 0,
            select = function()
                ExecuteCommand('faction')
            end
        })
    end

    if table.empty(factions) then
        Core.TriggerCallback('Factions:GetFactions', function(data)
            factions = data
        end)
        return
    end



    
end



local pMenuOpen = false
local closedTimes = 0
playerMenu:On('close', function ()
    pMenuOpen = false
    closedTimes = closedTimes + 1
end)



Citizen.CreateThread(function()
    while true do
        Wait(4000)
        if closedTimes >= 4 then
            closedTimes = 0
        end
    end
end)



RegisterCommand('pmenu', function()
    if MenuV.CurrentMenu == nil or not MenuV.CurrentMenu then
        if closedTimes >= 4 then
            return
        end
        Core.ClearEvents()
        BuildPlayerMenu()
        MenuV:OpenMenu(playerMenu)
    end
end)

RegisterKeyMapping('pmenu', 'Open Player Menu', 'keyboard', 'K')