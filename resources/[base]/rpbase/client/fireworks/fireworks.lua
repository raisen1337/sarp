local box = nil
local animlib = 'anim@mp_fireworks'

local fireworkData = {
    proj_indep_firework = {
        "scr_indep_firework_grd_burst",
        "scr_indep_firework_air_burst",
    },
    scr_indep_fireworks = {
        "scr_indep_firework_starburst",
        "scr_indep_firework_trailburst",
    },
    proj_indep_firework_v2 = {
        "scr_firework_indep_burst_rwb",
    },
    proj_xmas_firework = {
        "scr_firework_xmas_ring_burst_rgw",
    },

    

    
}

local mainCoords = {
    vec3(-93.62637, 6382.497, 58.78394),
    vec3(1759.635, 3734.967, 59.99707),
    vec3(727.3582, 4393.477, 200.137),
    vector3(893.1693, 1901.842, 146.6051),
    vector3(-72.94945, 6445.952, 50.34216),
}

function LaunchFireworks()
    local startTime = GetGameTimer()
    while GetGameTimer() - startTime < 15000 do -- Run for 15 seconds
        Wait(1000)
        for a, b in pairs(mainCoords) do
            for assetName, particles in pairs(fireworkData) do
                for _, particleName in ipairs(particles) do
                    RequestNamedPtfxAsset(assetName)
                    while not HasNamedPtfxAssetLoaded(assetName) do
                        Citizen.Wait(1)
                    end
                    UseParticleFxAssetNextCall(assetName)
                    
                    local randomRange = math.random(10, 500)

                    local particleX, particleY, particleZ = spawnVehicleWithinRadius(vec3(b.x, b.y, b.z), randomRange)

                    StartParticleFxNonLoopedAtCoord(particleName, spawnVehicleWithinRadius(vec3(b.x, b.y, b.z), randomRange)[1], spawnVehicleWithinRadius(vec3(b.x, b.y, b.z), randomRange)[2], spawnVehicleWithinRadius(vec3(b.x, b.y, b.z), 0)[3] + 50, 0.0, 0.0, 0.0, 3.0, false, false, false, false)
                    
                    local r = math.random(0, 30) / 100
                    local g = math.random(0, 100) / 100
                    local b = math.random(0, 100) / 100

                    SetParticleFxNonLoopedColour(r, g, b)
                    SetParticleFxNonLoopedAlpha(1.0)
                end
            end
        end
    end
end

-- RegisterCommand('testfireworks', function ()
--    LaunchFireworks() 
-- end)