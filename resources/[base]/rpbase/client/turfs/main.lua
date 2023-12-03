local Turfs, Turf, attackData, inAttack = false, {}, {}, false

Core.SaveTurf = function(id, data)
    Core.TriggerCallback('Turfs:UpdateTurf', function(source, cb)

    end, id, data)
end

Core.GetTurfs = function()
    local a = {}
    Core.TriggerCallback('Turfs:GetAllTurfs', function(turfs)
        for k, v in pairs(turfs) do
            local turf = json.decode(v.data)
            table.insert(a, turf)
        end
    end)
    return a
end

Citizen.CreateThread(function()
    while not LoggedIn do
        Wait(100)
    end

    while not Turfs do
        Wait(100)
    end
    while true do
        local wait = 1000
        Wait(wait)
        if not inAttack then
            Core.TriggerCallback('Turfs:GetAttacks', function(attacks)
                for k, v in pairs(attacks) do
                    for _, turf in pairs(Turfs) do
                        if turf.id == v.id then
                            if turf.attack then
                                if PlayerData.faction.name == v.attacker then
                                    inAttack = true
                                    turf.attack = true
                                    attackData = v
                                elseif PlayerData.faction.name == v.defender then
                                    inAttack = true
                                    turf.attack = true
                                    attackData = v
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

RegisterNetEvent('Turf:AttackEnded', function(turfId)
    if Turfs and not table.empty(Turfs) then
        for k, v in pairs(Turfs) do
            if v.id == turfId then
                v.attack = false
                attackData = {}
                inAttack = false
                SendNUIMessage({
                    action = 'finishTurf'
                })
            end
        end
    end
end)

RegisterNetEvent('Turf:Reload', function(turfs)
    if Turfs and not table.empty(Turfs) then
        for k, v in pairs(Turfs) do
            RemoveBlip(v.blip)
            RemoveBlip(v.radiusBlip)
        end

        Turfs = {}
        for k, v in pairs(turfs) do
            local turf = json.decode(v.data)
            table.insert(Turfs, turf)
        end

        if not table.empty(Turfs) then
            for k, v in pairs(Turfs) do
                local blip = CreateBlip(vec3(v.x, v.y, v.z), 'Turf ' .. v.mafia .. '', v.blipId, v.blipColor)
                local radiusBlip = CreateBlipRadius(vec3(v.x, v.y, v.z), v.turfRadius, v.blipColor)

                v.blip = blip
                v.radiusBlip = radiusBlip

                Core.SaveTurf(v.id, v)
            end
        end
    end
end)

RegisterNetEvent('Turfs:AddKill', function(dead, killer)
    if inAttack then
        SendNUIMessage({
            action = 'createKill',
            dead = dead,
            killer = killer
        })
    end
end)

Citizen.CreateThread(function()
    while not LoggedIn do
        Wait(100)
    end

    while not Turfs do
        Core.TriggerCallback('Turfs:GetAllTurfs', function(turfs)
            Turfs = {}
            for k, v in pairs(turfs) do
                local turf = json.decode(v.data)
                table.insert(Turfs, turf)
            end
        end)

        Wait(100)
    end

    if not table.empty(Turfs) then
        for k, v in pairs(Turfs) do
            local blip = CreateBlip(vec3(v.x, v.y, v.z), 'Turf ' .. v.mafia .. '', v.blipId, v.blipColor)
            local radiusBlip = CreateBlipRadius(vec3(v.x, v.y, v.z), v.turfRadius, v.blipColor)

            v.blip = blip
            v.radiusBlip = radiusBlip

            Core.SaveTurf(v.id, v)
        end
    end

    while true do
        local wait = 3000
        Turf = {}
        if table.empty(Turf) then
            for k, v in pairs(Turfs) do
                local dist = #(vector3(v.x, v.y, v.z) - GetEntityCoords(PlayerPedId()))
                if dist <= v.turfRadius then
                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        if inAttack then
                            DeleteCar(GetVehiclePedIsIn(PlayerPedId()))
                            DeleteEntity(GetVehiclePedIsIn(PlayerPedId()))
                        end
                    end
                    Turf = v
                    wait = 1000
                end
            end
        end
        Wait(wait)
    end
end)
local colorChanged = false
--flashing
Citizen.CreateThread(function()
    while true do
        local wait = 1000
        if inAttack then
            if Turfs and not table.empty(Turfs) then
                for k, v in pairs(Turfs) do
                    if v.attack then
                        local blipRadius = v.radiusBlip
                        local blipColor = v.blipColor
                        if not colorChanged then
                            SetBlipColour(blipRadius, 1) -- Change blip color to 1
                            colorChanged = true
                        else
                            SetBlipColour(blipRadius, blipColor) -- Change blip color back to original
                            colorChanged = false
                        end
                    end
                end
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent('Turf:UpdateTime', function(turf, time)
    if inAttack then
        if attackData and not table.empty(attackData) then
            if turf == attackData.id then
                attackData.time = time
                SendNUIMessage({
                    action = 'updateTurfTime',
                    time = time
                })
            end
        end

        Core.TriggerCallback('Turf:GetAllKills', function(kills)
            SendNUIMessage({
                action = 'updateKillsForTeam',
                team = 'teamA',
                kills = kills.attackers
            })
            SendNUIMessage({
                action = 'updateKillsForTeam',
                team = 'teamB',
                kills = kills.defenders
            })
        end, attackData.attacker, attackData.defender)
    end
end)

AddEventHandler('playerKilled', function(data)
    Core.TriggerCallback('Turfs:PlayerKilled', function()

    end, data.killerId)
end)

Citizen.CreateThread(function()
    while true do
        local wait = 3000
        if Turfs and not table.empty(Turfs) then
            if not table.empty(Turf) then
                for k, v in pairs(Turfs) do
                    if v.id == Turf.id then
                        if v.attack then
                            wait = 0
                            local dist = #(vector3(v.x, v.y, v.z) - GetEntityCoords(PlayerPedId()))
                            if dist <= v.turfRadius then
                                DrawMarker(1, v.x, v.y, v.z - 30.0, 0, 0, 0, 0, 0, 0, v.turfRadius * 2.0,
                                    v.turfRadius * 2.0, 60.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
                            end
                        end
                    end
                end
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent('Turfs:AttackTurf', function(id, attacker, attackdata)
    attackData = attackdata

    if PlayerData.faction.name == attackData.attacker then
        inAttack = false
    else
        inAttack = false
    end

    SendNUIMessage({
        action = 'startTurf',
        teamAName = attackData.attacker,
        teamBName = attackData.defender,
        teamAScore = 0,
        teamBScore = 0,
        time = attackData.time
    })
end)
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        Core.TriggerCallback('Turfs:StopAttacks', function()
        end)
    end
end)


RegisterCommand('attack', function()
    if inAttack then
        return
    end
    if not table.empty(Turf) then
        if not table.empty(Turfs) then
            for k, v in pairs(Turfs) do
                if v.id == Turf.id then
                    if not v.attack then
                        Core.TriggerCallback('Turfs:AttackTurf', function(canAttack)

                        end, v.id, PlayerData.faction.name)
                    else
                        -- print('Already attacked')
                    end
                end
            end
        end
    end
end)
