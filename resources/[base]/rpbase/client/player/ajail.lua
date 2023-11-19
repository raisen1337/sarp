JailCPs = {
    [1] = vector3(-806.1299, 5421.814, 33.9275),
    [2] = vector3(-776.3624, 5433.099, 35.82045),
    [3] = vector3(-689.882, 5420.851, 46.81596),
    [4] = vector3(-659.4759, 5332.257, 62.66069),
    [5] = vector3(-712.8172, 5293.07, 72.1179),
    [6] = vector3(-660.7228, 5228.62, 78.62851),
    [7] = vector3(-579.9575, 5210.536, 81.89655),
    [8] = vector3(-543.6511, 5177.385, 92.58192),
    [9] = vector3(-600.2866, 5147.479, 111.1885),
    [10] = vector3(-592.1946, 5074.017, 133.5317),
    [11] = vector3(-519.1971, 5025.51, 133.8649),
    [12] = vector3(-445.5408, 4940.364, 164.3372),
    [13] = vector3(-389.8724, 4901.144, 193.2227),
    [14] = vector3(-373.8256, 4829.277, 215.2096),
    [15] = vector3(-319.8863, 4738.004, 230.5051),
    [16] = vector3(-293.7195, 4670.729, 243.5225),
    [17] = vector3(-355.5161, 4685.686, 253.1335),
    [18] = vector3(-421.5608, 4711.147, 257.4976),
    [19] = vector3(-452.3119, 4738.238, 244.2226),
    [20] = vector3(-529.2167, 4731.787, 228.4425),
    [21] = vector3(-576.3417, 4759.433, 210.2409),
    [22] = vector3(-536.4451, 4819.995, 188.5536),
    [23] = vector3(-543.1235, 4854.989, 175.5908),
    [24] = vector3(-570.0779, 4887.718, 168.5506),
    [25] = vector3(-579.6143, 4944.655, 163.0997)
}

-- function to select random cp if the distance from actual is greater than 10
function newJailCp()
    local random = math.random(1, 25)
    local distance = #(GetEntityCoords(PlayerPedId()) - JailCPs[random])
    if distance > 10 then
        return JailCPs[random]
    else
        return SelectJailCP()
    end
end

jailCar = false
inJail = false

jailCP = {}

function nextCP()
    if PlayerData.jailcps - 1 > 0 then
        PlayerData.jailcps = PlayerData.jailcps - 1
        Core.SavePlayer()
        jailCP = CreateCP(1, newJailCp(), {255, 0, 0, 100}, 5.0, 100.0, nextCP)
        sendNotification("Admin Jail", "Mai ai " .. PlayerData.jailcps .. " checkpoint-uri ramase!", "success")
    else
        inJail = false
        SetEntityInvincible(jailCar, false)
        SetEntityInvincible(PlayerPedId(), false)
        DeleteCar(jailCar)
        DeleteCP(jailCP)
        PlayerData.jailcps = 0
        PlayerData.ajail = false
        Core.SavePlayer()
        SetEntityCoords(PlayerPedId(), 1829.3596191406,3680.4692382813,34.335926055908)
        jailCar = false
        jailCP = {}
    end
end



Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if PlayerData and not table.empty(PlayerData) then
            if PlayerData.ajail and inJail then
                if not IsPedInVehicle(PlayerPedId(), jailCar, false) then
                    SetPedIntoVehicle(PlayerPedId(), jailCar, -1)
                end
            end
            if PlayerData.ajail and not inJail then
                SetEntityCoords(PlayerPedId(), -782.75366210938,5431.8149414063,36.010246276855)
                jailCar = CreateCar('dune', vec3(-782.75366210938,5431.8149414063,36.010246276855), 271.21575927734, false, true, true, "JAIL")
                SetEntityInvincible(jailCar, true)
                SetEntityInvincible(PlayerPedId(), true)

                SetEntityAsMissionEntity(jailCar, true, true)
                if PlayerData.jailcps > 0 then
                    if not IsPedInVehicle(PlayerPedId(), jailCar, false) then
                        SetPedIntoVehicle(PlayerPedId(), jailCar, -1)
                    end
                    inJail = true
                    if table.empty(jailCP) then
                        jailCP = CreateCP(1, newJailCp(), {255, 0, 0, 100}, 5.0, 100.0, nextCP)
                    end
                else
                    if inJail then
                        inJail = false
                        SetEntityInvincible(jailCar, false)
                        SetEntityInvincible(PlayerPedId(), false)
                        DeleteCar(jailCar)
                        DeleteCP(jailCP)

                        SetEntityCoords(PlayerPedId(), 1829.3596191406,3680.4692382813,34.335926055908)
                        jailCar = false
                        jailCP = {}
                    end
                end
            end
        end
    end
end)


