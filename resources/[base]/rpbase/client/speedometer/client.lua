Citizen.CreateThread(function()
    while true do
        local wait = 3000
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local speed = GetEntitySpeed(vehicle) * 3.6
            local rpm = GetVehicleCurrentRpm(vehicle)
            local speedRounded = math.ceil(speed)
            local speedString = tostring(speedRounded)
            local speedLength = string.len(speedString)
            local doorLocked = GetVehicleDoorLockStatus(vehicle)
            local engineHealth = GetVehicleEngineHealth(vehicle)
            local fuelLevel = GetVehicleFuelLevel(vehicle)
            local fuelLevelRounded = math.ceil(fuelLevel)
            if speedLength == 1 then
                speedString = "00" .. speedString
            elseif speedLength == 2 then
                speedString = "0" .. speedString
            end
            SendNUIMessage({
                type = "speed",
                display = true,
                speed = speedString,
                rpm = rpm,
                doorLocked = doorLocked,
                engineHealth = engineHealth,    
                fuelLevel = fuelLevelRounded

            })
            wait = 100
        else
            SendNUIMessage({
                type = "speed",
                display = false
            })
        end
        Wait(wait)
    end
end)

