local mapBlips = {
    ['Identitate'] = {
        icon = 480,
        name = "Identitate",
        color = 70,
        coords = vec3(1829.4066162109, 3681.0725097656, 34.334838867188)
    },
}

for k,v in pairs(mapBlips) do
    local mapBlip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
    SetBlipSprite(mapBlip, v.icon)
    SetBlipDisplay(mapBlip, 4)
    SetBlipScale(mapBlip, 0.6)
    SetBlipColour(mapBlip, v.color)
    SetBlipAsShortRange(mapBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(v.name)
    EndTextCommandSetBlipName(mapBlip)
end

