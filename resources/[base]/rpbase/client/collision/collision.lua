local starter = false
local veh

RegisterNetEvent("turnOnCollision")
AddEventHandler("turnOnCollision", function(currentVehicle)

    veh = currentVehicle
    starter = true
    toggleCollision(true, veh)

end)

RegisterNetEvent("turnOffCollision")
AddEventHandler("turnOffCollision", function(currentVehicle)

    veh = currentVehicle
    starter = false
    toggleCollision(false, veh)

end)

