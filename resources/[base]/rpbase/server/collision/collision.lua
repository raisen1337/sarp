RegisterNetEvent('Collision:Toggle', function(toggle)
    local src = source
    for _, i in ipairs(GetActivePlayers()) do
        if i ~= PlayerId() then
          local closestPlayerPed = GetPlayerPed(i)
          local veh = GetVehiclePedIsIn(closestPlayerPed, false)
          SetEntityNoCollisionEntity(veh, GetVehiclePedIsIn(GetPlayerPed(src), false), false)
        end
  end
end)