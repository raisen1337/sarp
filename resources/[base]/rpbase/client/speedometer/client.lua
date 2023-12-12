local vehicleConsumptions = {
    ['Sports'] = {
        id = 6,
        consumption = 12.5
    },
    ['Sports Classics'] = {
        id = 5,
        consumption = 8.0
    },
    ['Super'] = {
        id = 7,
        consumption = 8.5
    },
    ['Muscle'] = {
        id = 4,
        consumption = 10.0
    },
    ['Off-Road'] = {
        id = 9,
        consumption = 12.0
    },
    ['SUV'] = {
        id = 2,
        consumption = 9.0
    },
    ['Sedans'] = {
        id = 1,
        consumption = 7.5
    },
    ['Coupes'] = {
        id = 3,
        consumption = 7.0
    },
    ['Compacts'] = {
        id = 0,
        consumption = 6.5
    },
    ['Vans'] = {
        id = 12,
        consumption = 9.5
    },
    ['Motorcycles'] = {
        id = 8,
        consumption = 15.0
    },
    ['Cycles'] = {
        id = 13,
        consumption = 5.0
    },
    ['Boats'] = {
        id = 14,
        consumption = 20.0
    },
    ['Helicopters'] = {
        id = 15,
        consumption = 30.0
    },
    ['Planes'] = {
        id = 16,
        consumption = 40.0
    },
    ['Service'] = {
        id = 17,
        consumption = 8.0
    },
    ['Emergency'] = {
        id = 18,
        consumption = 8.0
    },
    ['Military'] = {
        id = 19,
        consumption = 8.0
    },
    ['Commercial'] = {
        id = 20,
        consumption = 8.0
    },
    ['Trains'] = {
        id = 21,
        consumption = 8.0
    }
}

Citizen.CreateThread(function()
    while true do
        wait = 1000
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local speed = GetEntitySpeed(vehicle) * 3.6
            local health = GetVehicleEngineHealth(vehicle)

            if health <= 600 then
                SetVehicleMaxSpeed(vehicle, math.random(40, 70) / 3.6)
                SetVehicleEngineHealth(vehicle, 300.0)
            elseif health >= 800 then
                SetVehicleMaxSpeed(vehicle, 999.0)
            end

            -- Calculate fuel consumption based on vehicle type and speed
            local vehicleType = GetVehicleClass(vehicle)
            local fuelConsumption = 20.0
            for k, v in pairs(vehicleConsumptions) do
                if v.id == vehicleType then
                    fuelConsumption = (v.consumption / 10000) * (speed / 100)
                    break
                end
            end

            -- Reduce fuel level based on consumption
            local fuelLevel = GetVehicleFuelLevel(vehicle)
            fuelLevel = fuelLevel - fuelConsumption
            SetVehicleFuelLevel(vehicle, fuelLevel)

            -- Update speedometer display
            local speedRounded = math.ceil(speed)
            local speedString = string.format("%03d", speedRounded)
            local doorLocked = GetVehicleDoorLockStatus(vehicle)
            local engineHealth = GetVehicleEngineHealth(vehicle)
            local fuelLevelRounded = math.ceil(fuelLevel)

            local lightsOn = false
            local a, b, c = GetVehicleLightsState(vehicle)
            if b == 1 or c == 1 then
                lightsOn = true
            end

            SendNUIMessage({
                type = "speed",
                display = true,
                speed = speedString,
                vehicleGear = GetVehicleCurrentGear(vehicle),
                locked = doorLocked,
                engineHealth = engineHealth,
                lights = lightsOn,
                fuelLevel = fuelLevelRounded
            })

            wait = 100
        else
            SendNUIMessage({
                type = "speed",
                display = false
            })
            wait = 6000
        end

        Wait(wait)
    end
end)

RegisterCommand('lockveh', function()
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        local nearestVehicle, closestDistance = GetClosestVehicle(GetEntityCoords(PlayerPedId()))
        if not nearestVehicle then
            sendNotification('Masina', 'Nu esti langa nicio masina', 'error')
            return
        end
        if closestDistance < 2.0 then
            local plate = all_trim(GetVehicleNumberPlateText(nearestVehicle))
            local locked = GetVehicleDoorLockStatus(nearestVehicle)
            Core.TriggerCallback('Vehicle:IsOwnedByPlayer', function(owned)
                if owned then
                    if locked == 1 then
                        sendNotification('Masina', 'Ti-ai inchis masina', 'success')
                        SetVehicleDoorsLocked(nearestVehicle, 2)
                        SetVehicleDoorsLockedForAllPlayers(nearestVehicle, true)
                    elseif locked == 2 then
                        sendNotification('Masina', 'Ti-ai deschis masina', 'success')
                        SetVehicleDoorsLocked(nearestVehicle, 1)
                        SetVehicleDoorsLockedForAllPlayers(nearestVehicle, false)
                    end
                else
                    sendNotification('Masina', 'Masina nu iti apartine', 'error')
                end
            end, plate)
        else
            sendNotification('Masina', 'Nu esti langa nicio masina', 'error')
        end
    else
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local plate = all_trim(GetVehicleNumberPlateText(vehicle))
        local locked = GetVehicleDoorLockStatus(vehicle)
        Core.TriggerCallback('Vehicle:IsOwnedByPlayer', function(owned)
            if owned then
                if locked == 1 then
                    sendNotification('Masina', 'Ti-ai inchis masina', 'success')
                    SetVehicleDoorsLocked(vehicle, 2)
                    SetVehicleDoorsLockedForAllPlayers(vehicle, true)
                elseif locked == 2 then
                    sendNotification('Masina', 'Ti-ai deschis masina', 'success')
                    SetVehicleDoorsLocked(vehicle, 1)
                    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                end
            else
                sendNotification('Masina', 'Masina nu iti apartine', 'error')
            end
        end, plate)
    end
end)

RegisterKeyMapping('lockveh', 'Inchide/Deschide masina', 'keyboard', 'l')
