local hackerTowers = {
    [1] = {
        top = { coords = vector3(-228.356, 6260.149, 106.9238), text = "" },
        bottom = { coords = vector3(-228.2769, 6259.701, 31.47034), text = "Apasa ~r~[E]~w~ pentru a hackuii turnul." },
        camera = { coords = vector4(-219.8637, 6258.461, 108.0022, 79.37008), text = "" }
    },
    [2] = {
        top = { coords = vector3(1868.4, 3715.226, 113.7311), text = "" },
        bottom = { coords = vector3(1871.644, 3713.644, 33.0542), text = "Apasa ~r~[E]~w~ pentru a hackuii turnul." },
        camera = { coords = vector4(1877.789, 3715.279, 114.8433, 87.87402), text = "" }
    },
    [3] = {
        top = { coords = vector3(1244.413, 2709.969, 113.411), text = "" },
        bottom = { coords = vector3(1245.27, 2709.336, 37.99121), text = "Apasa ~r~[E]~w~ pentru a hackuii turnul." },
        camera = { coords = vector4(1237.569, 2713.754, 115.0117, 240.9449), text = "" }
    }
}

local hackedTowers, hackInProgress, hackCam, droneCam, inDrone, initPos, enteredDrone, beeping, infodPlayer, towerBlips, canHack =
    {}, false,
    false, false,
    false,
    false,
    false,
    false,
    false,
    false

hackTower = function(id, v)
    Core.TriggerCallback('Hacker:CanHack', function(can)
        if not can then
            TriggerEvent('chat:addMessage', {
                args = { '^1[HACKER]^0 Nu poti hackuii deoarece ai hackuit prea recent.' }
            })
            return
        else
            hackInProgress = true
            -- Fade out
            DoScreenFadeOut(1000)
            while not IsScreenFadedOut() do
                Citizen.Wait(0)
            end

            -- Teleport and rotation
            SetEntityCoords(PlayerPedId(), v.top.coords.x, v.top.coords.y, v.top.coords.z - 1)
            rotation(-180.0)

            -- Fade in
            DoScreenFadeIn(1000)
            while not IsScreenFadedIn() do
                Citizen.Wait(0)
            end

            hackCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            --start scenario WORLD_HUMAN_TOURIST_MOBILE
            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_TOURIST_MOBILE", 0, true)
            SetCamCoord(hackCam, v.camera.coords.x, v.camera.coords.y, v.camera.coords.z)
            PointCamAtCoord(hackCam, v.top.coords.x, v.top.coords.y, v.top.coords.z)
            SetCamActive(hackCam, true)
            RenderScriptCams(true, false, 0, true, true)


            Core.ProgressBar(5, 100, false, false, false, false, function()
                hackInProgress = false
                table.insert(hackedTowers, { id = id, hacked = true, data = v })
                Core.TriggerCallback('Hacker:Limit', function() end)

                SetEntityVisible(PlayerPedId(), false)
                TriggerEvent('chat:addMessage', {
                    args = { '^1[HACKER]^0 Ai hackuit turnul cu succes. Esti in modul drona acum, cauta bancomate pe care sa le hackuiesti.' }
                })

                RenderScriptCams(false, false, 0, true, true)
                DestroyCam(hackCam, true)
                ClearPedTasks(PlayerPedId())
                -- Fade out
                DoScreenFadeOut(1000)
                while not IsScreenFadedOut() do
                    Citizen.Wait(0)
                end

                -- Fade in
                DoScreenFadeIn(1000)
                while not IsScreenFadedIn() do
                    Citizen.Wait(0)
                end

                SetEntityCoords(PlayerPedId(), v.bottom.coords.x, v.bottom.coords.y,
                    v.bottom.coords.z)
                rotation(0.0)
                initPos = GetEntityCoords(PlayerPedId())
                inDrone = true
                enteredDrone = true
            end)
        end
    end)
end

RegisterCommand('hacker', function()
    PlayerData.job.name = 'Hacker'
    Core.SavePlayer()
end)

local delay = 1000
startBeeping = function(frequency)
    if not beeping then
        beeping = true
        Citizen.CreateThread(function()
            if frequency == "fast" then
                delay = 600
            elseif frequency == "slow" then
                delay = 1500
            elseif frequency == "faster" then
                delay = 400
            end

            while true do
                if beeping then
                    print(delay)
                    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                end
                Wait(delay)
            end
        end)
    end
end

local atmProps = {
    'prop_atm_01',
    'prop_atm_02',
    'prop_atm_03',
    'prop_fleeca_atm',
    'prop_atm_03_b',
    'prop_atm_04',
    'prop_atm_05',
    'prop_atm_06',
}
local hackingAtm = false
local hackedAtms = {}

Citizen.CreateThread(function()
    local closestAtm = false
    while true do
        local wait = 6000
        while not LoggedIn do
            Wait(1000)
        end
        while not inDrone do
            Wait(1000)
        end
        for k, v in pairs(atmProps) do
            local atm = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(v), false, false, false)
            if atm ~= 0 then
                closestAtm = atm
                break
            end
        end
        for k, v in pairs(hackedAtms) do
            if v.id == closestAtm then
                closestAtm = false
            end
        end
        if closestAtm then
            local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(closestAtm))
            if dist < 3.0 then
                wait = 0
                DrawText3D(GetEntityCoords(closestAtm).x, GetEntityCoords(closestAtm).y, GetEntityCoords(closestAtm).z,
                    'Apasa ~r~[E]~w~ pentru a hackuii bancomatul.')
                if IsControlJustPressed(0, 38) then
                    local hackTime = math.random(10, 20)
                    FreezeEntityPosition(PlayerPedId(), true)
                    hackingAtm = true
                    Core.ProgressBar(hackTime, 100, false, false, false, false, function()
                        local random = math.random(1, 100)
                        hackingAtm = false
                        local money = math.random(20000, 40000)
                        if random > 50 then
                            FreezeEntityPosition(PlayerPedId(), false)
                            PlayerData.cash = PlayerData.cash + money
                            TriggerEvent('chat:addMessage', {
                                args = { '^1[HACKER]^0 Ai hackuit bancomatul si ai extras ' .. FormatNumber(money) .. '$.' }
                            })
                            Core.SavePlayer()
                            table.insert(hackedAtms, { id = closestAtm, hacked = true })
                        else
                            FreezeEntityPosition(PlayerPedId(), false)
                            TriggerEvent('chat:addMessage', {
                                args = { '^1[HACKER]^0 Acest bancomat nu a putut fi hackuit. Cauta altul.' }
                            })
                        end
                    end)
                end
            end
        end

        Wait(wait)
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = 3000
        while not LoggedIn do
            Wait(1000)
        end
        if inDrone then
            wait = 1
            if IsControlJustPressed(0, 322) then
                SetEntityCoords(PlayerPedId(), initPos)
                inDrone = false
                Core.TriggerCallback('Hacker:Limit', function() end)

                SetEntityVisible(PlayerPedId(), true)
                SetEntityInvincible(PlayerPedId(), false)
                FreezeEntityPosition(PlayerPedId(), false)

                -- Fade out
                DoScreenFadeOut(1000)
                while not IsScreenFadedOut() do
                    Citizen.Wait(0)
                end

                Wait(1000)

                hackedTowers = {}
                hackInProgress = false
                beeping = false
                enteredDrone = false
                infodPlayer = false
                closestAtm = false

                hackedAtms = {}
                TriggerEvent("chat:addMessage", {
                    args = { '^1[HACKER]^0 Ai iesit din modul drona si ti-ai anulat misiunea.' }
                })

                -- Fade in
                DoScreenFadeIn(1000)
                while not IsScreenFadedIn() do
                    Citizen.Wait(0)
                end

                wait = 3000
                SetEntityVisible(PlayerPedId(), true)
                SetEntityInvincible(PlayerPedId(), false)
                FreezeEntityPosition(PlayerPedId(), false)
            end
        end
        Wait(wait)
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = 3000
        while not LoggedIn do
            Wait(1000)
        end

        if PlayerData.job.name then
            if inDrone and not hackingAtm then
                wait = 1
                local dist = #(initPos - GetEntityCoords(PlayerPedId()))
                if dist > 170 and dist < 250 and inDrone then
                    if delay ~= 1500 then
                        delay = 1500
                        startBeeping('slow')
                    end
                elseif dist > 250 and dist < 400 and inDrone then
                    if delay ~= 600 then
                        delay = 600
                        startBeeping('fast')
                    end
                elseif dist > 450 and dist < 500 and inDrone then
                    if delay ~= 300 then
                        delay = 300
                        if not infodPlayer then
                            infodPlayer = true
                            TriggerEvent('chat:addMessage', {
                                args = { '^1[HACKER]^0 Drona iese din raza de ^1actiune a turnului si vei pierde misiunea^0. Apropie-te de turn.' }
                            })
                        end
                        startBeeping('faster')
                    end
                elseif dist < 170 and inDrone then
                    beeping = false
                end
                if dist > 500.0 and inDrone then
                    TriggerEvent('chat:addMessage', {
                        args = { '^1[HACKER]^0 Drona a iesit din raza de actiune a turnului si ai pierdut misiunea.' }
                    })
                    SetEntityCoords(PlayerPedId(), initPos)

                    SetEntityVisible(PlayerPedId(), true)
                    SetEntityInvincible(PlayerPedId(), false)
                    FreezeEntityPosition(PlayerPedId(), false)
                    Wait(1000)
                    hackedTowers = {}
                    hackInProgress = false
                    beeping = false
                    inDrone = false
                    enteredDrone = false
                    infodPlayer = false
                    closestAtm = false
                    hackedAtms = {}
                elseif dist < 500.0 and inDrone then
                    wait = 1
                    local ped = PlayerPedId()
                    SetEntityVisible(PlayerPedId(), false)
                    SetEntityInvincible(PlayerPedId(), true)

                    FreezeEntityPosition(PlayerPedId(), true)


                    local forwardKey = 32   -- Replace with the desired keycode for going forward
                    local backwardKey = 33  -- Replace with the desired keycode for going backward
                    local turnLeftKey = 34  -- Replace with the desired keycode for turning left
                    local turnRightKey = 35 -- Replace with the desired keycode for turning right
                    local upKey = 55        -- Replace with the desired keycode for going up
                    local downKey = 21      -- Replace with the desired keycode for going down
                    local currentSpeed = 0
                    local yoff = 0.0
                    local zoff = 0.0

                    offsets = {
                        y = 0.5, -- [[How much distance you move forward and backward while the respective button is pressed]]
                        z = 0.2, -- [[How much distance you move upward and downward while the respective button is pressed]]
                        h = 3,   -- [[How much you rotate. ]]
                    }

                    if IsDisabledControlPressed(0, forwardKey) then
                        yoff = offsets.y
                    end

                    if IsDisabledControlPressed(0, backwardKey) then
                        yoff = -offsets.y
                    end

                    if IsDisabledControlPressed(0, turnLeftKey) then
                        SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + offsets.h)
                    end

                    if IsDisabledControlPressed(0, turnRightKey) then
                        SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - offsets.h)
                    end

                    if IsDisabledControlPressed(0, upKey) then
                        zoff = offsets.z
                    end

                    if IsDisabledControlPressed(0, downKey) then
                        zoff = -offsets.z
                    end

                    local newPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, yoff * (currentSpeed + 0.3),
                        zoff * (currentSpeed + 0.3))
                    local heading = GetEntityHeading(PlayerPedId())
                    SetEntityVelocity(PlayerPedId(), 0.0, 0.0, 0.0)
                    SetEntityRotation(PlayerPedId(), 0.0, 0.0, 0.0, 0, false)
                    SetEntityHeading(PlayerPedId(), heading)
                    SetEntityCoordsNoOffset(PlayerPedId(), newPos.x, newPos.y, newPos.z, noclipActive, noclipActive,
                        noclipActive)
                end
            end
        end

        Wait(wait)
    end
end)

Citizen.CreateThread(function()
    while not LoggedIn do
        Wait(1000)
    end
    if PlayerData.job.name == 'Hacker' then
        for k, v in pairs(hackerTowers) do
            local blip = CreateBlipRadius(v.bottom.coords, 60.0, 2)
            if not towerBlips or table.empty(towerBlips) then
                towerBlips = {}
                table.insert(towerBlips, blip)
            end
        end
    end
    while true do
        wait = 5000
        while not LoggedIn do
            Wait(1000)
        end
        while not PlayerData.job.name do
            Wait(1000)
        end
        local isNearTowerPoint = false

        if PlayerData.job.name == 'Hacker' then
            for k, v in pairs(hackerTowers) do
                local dist = #(vector3(v.bottom.coords.x, v.bottom.coords.y, v.bottom.coords.z) - GetEntityCoords(PlayerPedId()))



                if dist < 150.0 then
                    if table.empty(hackedTowers) then
                        wait = 0

                        isNearTowerPoint = true
                        DrawMarker(1, v.bottom.coords.x, v.bottom.coords.y, v.bottom.coords.z - 1, 0, 0, 0, 0, 0, 0, 10.0,
                            10.0,
                            90.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
                        if dist < 2.0 then
                            DrawText3D(v.bottom.coords.x, v.bottom.coords.y, v.bottom.coords.z, v.bottom.text)
                            if IsControlJustPressed(0, 38) then
                                hackTower(k, v)
                            end
                        end
                    else
                        for _, tower in pairs(hackedTowers) do
                            if tower.id ~= k then
                                wait = 0
                                if not towerBlip then
                                    towerBlip = CreateBlipRadius(v.bottom.coords, 30.0, 2)
                                end
                                isNearTowerPoint = true
                                DrawMarker(1, v.bottom.coords.x, v.bottom.coords.y, v.bottom.coords.z - 1, 0, 0, 0, 0, 0,
                                    0,
                                    10.0,
                                    10.0,
                                    90.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
                                if dist < 2.0 then
                                    DrawText3D(v.bottom.coords.x, v.bottom.coords.y, v.bottom.coords.z, v.bottom.text)
                                    if IsControlJustPressed(0, 38) then
                                        hackTower(k, v)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            if towerBlips and not table.empty(towerBlips) then
                for _, blip in pairs(towerBlips) do
                    if DoesBlipExist(blip) then
                        RemoveBlip(blip)
                    end
                end
            end
        end

        Wait(wait)
    end
end)
