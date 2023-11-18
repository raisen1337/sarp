RegisterCommand('moddata', function()
    local veh = GetVehiclePedIsUsing(PlayerPedId())

    local mods = GetVehicleModData(vehicle, modType, modIndex)
end)