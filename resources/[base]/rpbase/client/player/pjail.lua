jailDoorModel = 'prison_prop_jaildoor'

local closestJailDoor = nil

local jailCells = {
    vec3(-3708.9685058594, -4052.9731445313, 57.6686668396),
    vec3(-3708.9653320313, -4049.0009765625, 57.668647766113),
    vec3(-3708.5070800781, -4045.3596191406, 57.668495178223),
    vec3(-3708.931640625, -4041.1508789063, 57.668655395508),
}

inCell = true

Citizen.CreateThread(function()
    while true do
        local wait = 3005
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        pData = PlayerData
        if pData then
            if pData.jail then
                wait = 1
                playerCoords = GetEntityCoords(playerPed)
                SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)

                DisableControlAction(0, 257, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 141, true)
                DisableControlAction(0, 263, true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 21, true)
                DisableControlAction(0, 32, true)
                DisableControlAction(0, 33, true)
                DisableControlAction(0, 34, true)
                DisableControlAction(0, 35, true)
                DisableControlAction(0, 22, true)

                for k, v in pairs(jailCells) do
                    local distance = #(playerCoords - v)
                    if distance > 100.0 then
                        SetEntityCoords(playerPed, jailCells[math.random(1, #jailCells)])
                        ClearPedTasksImmediately(playerPed)
                        inCell = true
                        Core.TriggerCallback("Player:SetRouting", function() end, math.random(1, 10000))
                        break
                    end
                end
                if not closestJailDoor then
                    closestJailDoor = GetClosestObjectOfType(playerCoords, 3.0, 430324891, false, false)
                else
                    local doorCoords = GetEntityCoords(closestJailDoor)
                    local distance = #(playerCoords - doorCoords)
                    if distance > 2.0 then
                        closestJailDoor = GetClosestObjectOfType(playerCoords, 3.0, 430324891, false, false)
                    end
                    FreezeEntityPosition(closestJailDoor, true)
                end
            else
                wait = 3005
            end
        end
        Wait(wait)
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = 5000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        pData = PlayerData
        if pData then
            if pData.jail and not inCell then
                for k, v in pairs(jailCells) do
                    local distance = #(playerCoords - v)
                    if distance > 100.0 then
                        SetEntityCoords(playerPed, jailCells[math.random(1, #jailCells)])
                        ClearPedTasksImmediately(playerPed)
                        inCell = true
                        Core.TriggerCallback("Player:SetRouting", function() end, math.random(1, 10000))
                        break
                    end
                end
            elseif pData.jail and inCell then
                if pData.jailTime - 1 > 0 then
                    pData.jailTime = pData.jailTime - 1
                    Core.SavePlayer()
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0 },
                        multiline = true,
                        args = { "Jail", "Mai ai " .. pData.jailTime .. " minut(e) ramase!" }
                    })
                else
                    pData.jailTime = 0
                    pData.jail = false
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0 },
                        multiline = true,
                        args = { "Jail", "Ti-ai terminat sentinta!" }
                    })
                    Core.SavePlayer()

                    Core.TriggerCallback("Player:SetRouting", function() end, 1)
                    SetEntityCoords(PlayerPedId(), 1829.3596191406, 3680.4692382813, 34.335926055908)
                end
            end
        end
        Wait(wait)
    end
end)
