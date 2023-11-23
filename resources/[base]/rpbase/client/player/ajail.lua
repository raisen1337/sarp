JailCPs = {
    [1] = vector3(-3724.98046875,-4076.0217285156,57.426204681396),
    [2] = vector3(-3749.298828125,-4102.3969726563,57.431755065918),
    [3] = vector3(-3779.3076171875,-4109.822265625,57.431915283203),
    [4] = vector3(-3774.2868652344,-4089.1396484375,57.432613372803),
    [5] = vector3(-3732.7478027344,-4078.1896972656,57.432205200195),
    [6] = vector3(-3758.5190429688,-4116.0639648438,57.431922912598),
    [7] = vector3(-3776.4050292969,-4108.3344726563,57.432594299316)
}

-- function to select random cp if the distance from actual is greater than 10
function newJailCp()
    local random = math.random(1, 7)
    return JailCPs[random]
   
end

jailCar = false
inJail = false

jailCP = {}

Citizen.CreateThread(function()
    while true do
        local wait = 3005
        if not PlayerData then
            Citizen.Wait(1000)
        end
        if PlayerData.ajail then
            wait = 1
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 141, true)
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 35, true)
            DisableControlAction(0, 22, true)
        else
            wait = 3005
        end
        Wait(wait)
    end
end)

function nextCP()
    if PlayerData.jailcps - 1 > 0 then
        PlayerData.jailcps = PlayerData.jailcps - 1
        Core.SavePlayer()
        FreezeEntityPosition(PlayerPedId(), false)

        jailCP = CreateCP(1, newJailCp(), {255, 0, 0, 100}, 1.0, 100.0, nextCP)
        sendNotification("Admin Jail", "Mai ai " .. PlayerData.jailcps .. " checkpoint-uri ramase!", "success")
    else
        inJail = false
        SetEntityInvincible(jailCar, false)
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityInvincible(PlayerPedId(), false)
        DeleteCP(jailCP)
        PlayerData.jailcps = 0
        PlayerData.ajail = false
        Core.SavePlayer()
        Core.TriggerCallback("Player:SetRouting", function()end, 0)
        SetEntityCoords(PlayerPedId(), 1829.3596191406,3680.4692382813,34.335926055908)
        jailCP = {}
    end
end


Citizen.CreateThread(function()
    while true do
        Wait(3000)
        if PlayerData and not table.empty(PlayerData) then
            if PlayerData.ajail and inJail then
                local jailc = vec3(-3696.7248535156,-4046.2724609375,57.66869354248)
                local dist = #(GetEntityCoords(PlayerPedId()) - jailc)
                if dist > 400 then
                    FreezeEntityPosition(PlayerPedId(), false)

                    SetEntityCoords(PlayerPedId(), -3696.7248535156,-4046.2724609375,57.66869354248)
                end
                Core.TriggerCallback("Player:SetRouting", function()end, math.random(1, 10000))
            end
            if PlayerData.ajail and not inJail then
                SetEntityCoords(PlayerPedId(), -3696.7248535156,-4046.2724609375,57.66869354248)
                SetEntityInvincible(PlayerPedId(), true)
                FreezeEntityPosition(PlayerPedId(), false)

                SetEntityAsMissionEntity(jailCar, true, true)
                if PlayerData.jailcps > 0 then
                    inJail = true
                    if table.empty(jailCP) then
                        jailCP = CreateCP(1, newJailCp(), {255, 0, 0, 100}, 1.0, 100.0, function()
                            FreezeEntityPosition(PlayerPedId(), true)
                            ClearPedTasksImmediately(PlayerPedId())
                            showSubtitle("Asteapta ^315 secunde ^0pentru a putea trece la urmatorul ^3checkpoint.", 12000)
                            Wait(15000)
                            nextCP()
                            FreezeEntityPosition(PlayerPedId(), false)
                        end)
                    end
                else
                    if inJail then
                        inJail = false
                        FreezeEntityPosition(PlayerPedId(), false)
                        SetEntityInvincible(PlayerPedId(), false)
                        DeleteCP(jailCP)
                        Core.TriggerCallback("Player:SetRouting", function()end, 0)

                        SetEntityCoords(PlayerPedId(), 1829.3596191406,3680.4692382813,34.335926055908)
                        jailCP = {}
                    end
                end
            elseif not PlayerData.ajail and inJail then
                inJail = false
                FreezeEntityPosition(PlayerPedId(), false)
                SetEntityInvincible(PlayerPedId(), false)
                DeleteCar(jailCar)
                DeleteCP(jailCP)
                Core.TriggerCallback("Player:SetRouting", function()end, 0)

                SetEntityCoords(PlayerPedId(), 1829.3596191406,3680.4692382813,34.335926055908)
                jailCar = false
                jailCP = {}
            end
        end
    end
end)


