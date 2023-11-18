local JobInfo = {
    jobName = 'Pescar',
    pedCoords = vec3(1321.358, 4314.422, 38.32825),
    pedHeading = 76.535430908203,
    ped = "a_m_m_polynesian_01",
    pedText = "~y~[~w~Fisherman~y~]",
    skills = {
        [1] = {
            level = 1,
            info = '~w~Loc de pescuit~n~~y~[~w~/fish~y~]',
            animation = {scenario = "WORLD_HUMAN_STAND_FISHING"},
            duration = {min = 6000, max = 12000},
            carryMax = 1,
            fishCoords = {
                vector3(1310.862, 4260.712, 33.89673),
                vector3(1309.187, 4252.101, 33.89673),
                vector3(1307.38, 4244.677, 33.89673),
                vector3(1303.846, 4254.91, 33.89673),
                vector3(1302.725, 4248.541, 33.89673),
                vector3(1309.767, 4229.262, 33.91357),
                vector3(1301.288, 4239.692, 33.89673),
                vector3(1299.864, 4233.231, 33.89673),
                vector3(1298.123, 4226.4, 33.93042),
                vector3(1297.174, 4219.517, 33.89673),
                vector3(1298.664, 4215.046, 33.89673),
                vector3(1302.277, 4218.066, 33.89673),
                vector3(1302.277, 4218.066, 33.89673),
                vector3(1316.941, 4228.088, 33.91357),

            },
            fishes = {
                ['sturion'] = {chance = 30, priceMin = 5000, priceMax = 10000},
                ['somon'] = {chance = 15, priceMin = 15000, priceMax = 25000},
                ['somn'] = {chance = 40, priceMin = 3000, priceMax = 8000},
                ['crap'] = {chance = 45, priceMin = 5000, priceMax = 12000},
            }
        },
        [2] = {
            level = 2,
            info = '~w~Loc de pescuit~n~~y~[~w~/fish~y~]',
            animation = {scenario = "WORLD_HUMAN_STAND_FISHING"},
            duration = {min = 6000, max = 12000},
            carryMax = 2,
            fishCoords = {
                vector3(1310.862, 4260.712, 33.89673),
                vector3(1309.187, 4252.101, 33.89673),
                vector3(1307.38, 4244.677, 33.89673),
                vector3(1303.846, 4254.91, 33.89673),
                vector3(1302.725, 4248.541, 33.89673),
                vector3(1309.767, 4229.262, 33.91357),
                vector3(1301.288, 4239.692, 33.89673),
                vector3(1299.864, 4233.231, 33.89673),
                vector3(1298.123, 4226.4, 33.93042),
                vector3(1297.174, 4219.517, 33.89673),
                vector3(1298.664, 4215.046, 33.89673),
                vector3(1302.277, 4218.066, 33.89673),
                vector3(1302.277, 4218.066, 33.89673),
                vector3(1316.941, 4228.088, 33.91357),
            },
            fishes = {
                ['Sturion'] = {chance = 40, priceMin = 10000, priceMax = 20000},
                ['Somon'] = {chance = 35, priceMin = 15000, priceMax = 40000},
                ['Somn'] = {chance = 60, priceMin = 10000, priceMax = 15000},
                ['Crap'] = {chance = 65, priceMin = 10000, priceMax = 20000},
            }
        },
    }
}

AddEventHandler('Jobs:Check', function ()
    local dist = #(JobInfo.pedCoords - GetEntityCoords(PlayerPedId()))
    if dist < 3.0 then
        PlayerData.job.name = 'Fisherman';
        if table.empty(PlayerData.skills) then
            local fish = 
            table.insert(PlayerData.skills, {
                ['fish'] = {
                    level = 1,
                    experience = 0,
                }
            })
        end
        
        Core.SavePlayer()
        sendNotification("Job", "Te-ai angajat ca Fisherman.")
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        TaskSetBlockingOfNonTemporaryEvents(PlayerId(), true)
    end
end)

Citizen.CreateThread(function ()
    local model = JobInfo.ped
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        local ped = CreatePed(false, GetHashKey(model), JobInfo.pedCoords.x, JobInfo.pedCoords.y, JobInfo.pedCoords.z - 1, JobInfo.pedHeading, false, false)
        SetModelAsNoLongerNeeded(model)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        TaskSetBlockingOfNonTemporaryEvents(ped, true)
        CreateBlip(JobInfo.pedCoords, "Fisherman", 68, 53)
    end
end)

Citizen.CreateThread(function ()
    while true do
        local fishWait = 2000
        
        if PlayerData.job then
            if PlayerData.job.name:lower() == 'fisherman' then
                
                local skillData = JobInfo.skills[PlayerData.skills[1]['fish'].level]
                local pCoords = GetEntityCoords(PlayerPedId())
                local peddist = #(pCoords - JobInfo.pedCoords)

                if peddist < 3.0 then
                    fishWait = 1
                    DrawText3D(JobInfo.pedCoords.x, JobInfo.pedCoords.y, JobInfo.pedCoords.z, JobInfo.pedText.."~w~~n~Esti angajat deja.")
                    DrawText3D(JobInfo.pedCoords.x, JobInfo.pedCoords.y, JobInfo.pedCoords.z - 0.25, "Nivel Skill: ~y~"..PlayerData.skills[1].fish.level)
                end

                for k,v in pairs(skillData.fishCoords) do
                    local dist = #(pCoords - v)
                    if dist < 6 then
                        fishWait = 1
                        DrawMarker(6, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 255, 209, 82, 255, true, false, false, true, false, false, false)
                        DrawMarker(32, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, -0.3, -0.3, -0.3, 255, 209, 82, 255, true, false, false, true, false, false, false)
                        DrawText3D(v.x, v.y, v.z, skillData.info)
                    end
                end
            else
                fishWait = 1
                local pCoords = GetEntityCoords(PlayerPedId())
                local peddist = #(pCoords - JobInfo.pedCoords)
                if peddist < 3.0 then
                    DrawText3D(JobInfo.pedCoords.x, JobInfo.pedCoords.y, JobInfo.pedCoords.z, JobInfo.pedText.."~n~Foloseste ~y~[~w~/getjob~y~] sau ~y~[~w~/quitjob~y~]")
                end
            end
        else
            local pCoords = GetEntityCoords(PlayerPedId())
            local peddist = #(pCoords - JobInfo.pedCoords)
            if peddist < 3.0 then
                DrawText3D(JobInfo.pedCoords.x, JobInfo.pedCoords.y, JobInfo.pedCoords.z, JobInfo.pedText.."~n~Foloseste ~y~[~w~/getjob~y~] sau ~y~[~w~/quitjob~y~]")
            end
        end
        Wait(fishWait)
    end
end)

function getRandomFish(fishes)
    local totalWeight = 0
    for fishName, fishData in pairs(fishes) do
        totalWeight = totalWeight + fishData.chance
    end
    
    local randomValue = math.random(1, totalWeight)
    local accumulatedWeight = 0
    
    for fishName, fishData in pairs(fishes) do
        accumulatedWeight = accumulatedWeight + fishData.chance
        if randomValue <= accumulatedWeight then
            return {fish = fishName, price = math.random(fishData.priceMin, fishData.priceMax)}
        end
    end
    
    return {fish = "crap", price = math.random(5000, 12000)}  -- Return nil if no fish is selected (unlikely but handling it)
end


--Comenzi

local pestiPrins = {}
local fishing = false

local cam = nil
local inBarca = false

function spawnVehicleWithinRadius(center, radius)
    -- Generate a random angle in radians (0 to 2*pi)
    local angle = math.random() * 2 * math.pi
    
    -- Generate a random distance within the radius
    local distance = math.random() * radius
    
    -- Calculate X and Y offsets based on angle and distance
    local x_offset = distance * math.cos(angle)
    local y_offset = distance * math.sin(angle)
    
    -- Calculate the new spawn point
    local spawn_point = {
        center[1] + x_offset,
        center[2] + y_offset,
        center[3]  -- Keep the same Z coordinate as the center
    }
    
    return spawn_point
end




RegisterCommand('fish', function ()
    if PlayerData.job then
        if PlayerData.job.name:lower() == 'fisherman' then
            local pCoords = GetEntityCoords(PlayerPedId())
            local skillData = JobInfo.skills[PlayerData.skills[1]['fish'].level]
            for k,v in pairs(skillData.fishCoords) do
                local dist = #(pCoords - v)
                if dist < 2 then
                    if fishing then
                        return
                    end
                    if PlayerData.skills[1].fish.level == 1 and #pestiPrins >= 1 then
                        showSubtitle("Trebuie sa vinzi pestele prins la un ^324/7^0!", 4000)
                        return
                    end
        
                    if PlayerData.skills[1].fish.level == 2 and #pestiPrins >= 2 then
                        showSubtitle("Trebuie sa vinzi pestele prins la un ^324/7^0!", 4000)
                        return
                    end

                    if PlayerData.skills[1].fish.level == 3 and #pestiPrins >= 3 then
                        showSubtitle("Trebuie sa vinzi pestele prins la un ^324/7^0!", 4000)
                        return
                    end
        
                    if PlayerData.skills[1].fish.level == 1 and #pestiPrins < 1 then
                        local offsetCamera = vector3(5.367, 1.938, 0.50549)
                        local cameraCoords = vector3(pCoords.x - offsetCamera.x, pCoords.y - offsetCamera.y, pCoords.z + offsetCamera.z)
                        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
                        SetCamActive(cam, true)
                        SetCamCoord(cam, cameraCoords.x, cameraCoords.y, cameraCoords.z)
                        PointCamAtCoord(cam, pCoords.x, pCoords.y, pCoords.z)
                        RenderScriptCams(1, 0, 0, 1, 1)
                        TaskStartScenarioInPlace(PlayerPedId(), JobInfo.skills[PlayerData.skills[1].fish.level].animation.scenario, 0, true)
                        fishing = true
                        local fishDelay = math.random(JobInfo.skills[PlayerData.skills[1].fish.level].duration.min, JobInfo.skills[PlayerData.skills[1].fish.level].duration.max)
                        showSubtitle("^3Pescuiesti..", fishDelay)
                        Wait(fishDelay)
                        ClearPedTasksImmediately(PlayerPedId())
                        local fish = getRandomFish(JobInfo.skills[PlayerData.skills[1].fish.level].fishes)
                        table.insert(pestiPrins, {fish = fish.fish, price = fish.price})
                        fishing = false
                        local exp = (math.random(100, 300) / 1000)
                        PlayerData.skills[1].fish.experience = PlayerData.skills[1].fish.experience + exp
                        showSubtitle("Ai prins un ^3"..fish.fish:gsub("^%l", string.upper).."^0! (+"..tostring(exp).." exp)", fishDelay)
                        Core.SavePlayer()
                        DestroyCam(cam, false)
                        SetCamActive(cam, false)
                        RenderScriptCams(0, false, 100, false, false)
                        return
                    end
                    
                    if PlayerData.skills[1].fish.level == 2 and #pestiPrins < 2 then
                        local offsetCamera = vector3(5.367, 1.938, 0.50549)
                        local cameraCoords = vector3(pCoords.x - offsetCamera.x, pCoords.y - offsetCamera.y, pCoords.z + offsetCamera.z)
                        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
                        SetCamActive(cam, true)
                        SetCamCoord(cam, cameraCoords.x, cameraCoords.y, cameraCoords.z)
                        PointCamAtCoord(cam, pCoords.x, pCoords.y, pCoords.z)
                        RenderScriptCams(1, 0, 0, 1, 1)
                        TaskStartScenarioInPlace(PlayerPedId(), JobInfo.skills[PlayerData.skills[1].fish.level].animation.scenario, 0, true)
                        fishing = true
                        local fishDelay = math.random(JobInfo.skills[PlayerData.skills[1].fish.level].duration.min, JobInfo.skills[PlayerData.skills[1].fish.level].duration.max)
                        showSubtitle("^3Pescuiesti..", fishDelay)
                        Wait(fishDelay)
                        ClearPedTasksImmediately(PlayerPedId())
                        local fish = getRandomFish(JobInfo.skills[PlayerData.skills[1].fish.level].fishes)
                        table.insert(pestiPrins, {fish = fish.fish, price = fish.price})
                        local exp = (math.random(100, 300) / 1000)
                        PlayerData.skills[1].fish.experience = PlayerData.skills[1].fish.experience + exp
                        showSubtitle("Ai prins un ^3"..fish.fish:gsub("^%l", string.upper).."^0! (+"..tostring(exp).." exp)", fishDelay)
                        fishing = false
                        Core.SavePlayer()
                        DestroyCam(cam, false)
                        SetCamActive(cam, false)
                        RenderScriptCams(0, false, 100, false, false)
                        return
                    end
                    if PlayerData.skills[1].fish.level == 3 and #pestiPrins < 3 then
                        local offsetCamera = vector3(5.367, 1.938, 0.50549)
                        local cameraCoords = vector3(pCoords.x - offsetCamera.x, pCoords.y - offsetCamera.y, pCoords.z + offsetCamera.z)
                        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
                        SetCamActive(cam, true)
                        SetCamCoord(cam, cameraCoords.x, cameraCoords.y, cameraCoords.z)
                        PointCamAtCoord(cam, pCoords.x, pCoords.y, pCoords.z)
                        RenderScriptCams(1, 0, 0, 1, 1)
                        TaskStartScenarioInPlace(PlayerPedId(), JobInfo.skills[PlayerData.skills[1].fish.level].animation.scenario, 0, true)
                        fishing = true
                        local fishDelay = math.random(JobInfo.skills[PlayerData.skills[1].fish.level].duration.min, JobInfo.skills[PlayerData.skills[1].fish.level].duration.max)
                        showSubtitle("^3Pescuiesti..", fishDelay)
                        Wait(fishDelay)
                        ClearPedTasksImmediately(PlayerPedId())
                        local fish = getRandomFish(JobInfo.skills[PlayerData.skills[1].fish.level].fishes)
                        table.insert(pestiPrins, {fish = fish.fish, price = fish.price})
                        local exp = (math.random(100, 300) / 1000)
                        PlayerData.skills[1].fish.experience = PlayerData.skills[1].fish.experience + exp
                        showSubtitle("Ai prins un ^3"..fish.fish:gsub("^%l", string.upper).."^0! (+"..tostring(exp).." exp)", fishDelay)
                        fishing = false
                        Core.SavePlayer()
                        DestroyCam(cam, false)
                        SetCamActive(cam, false)
                        RenderScriptCams(0, false, 100, false, false)
                    end
                end
            end
        end
    end
end)

AddEventHandler("Jobs:ClosestMarket", function(market)
    local md = jd(market.data)
    if md.type == 1 then
        if not table.empty(pestiPrins) then
            for k,v in pairs(pestiPrins) do
                SendChatMessage("^3[^0Pescar^3]: Ai vandut un: "..v.fish.." pentru: ^0$"..FormatNumber(v.price))
                showSubtitle("^3[^0Pescar^3]: Ai vandut un: "..v.fish.." pentru: ^0$"..FormatNumber(v.price), 9000)
                PlayerData.cash = PlayerData.cash + v.price
                table.remove(pestiPrins, k)
                Core.SavePlayer()
            end
        end
    end
end)