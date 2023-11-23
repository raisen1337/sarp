local fruitsInHands = false
local collecting = false
local JobInfo = {
    jobName = 'Fermier',
    pedCoords = vec3(2310.2756347656,4885.1435546875,41.808258056641),
    pedHeading = 42.584995269775,
    ped = "a_m_m_farmer_01",
    jobBlip = 210, 
    jobBlipColor = 2,
    pedText = "~g~[~w~Fermier~g~]",
    places = {
        ['Pomi fructiferi'] = {
            {text = 'Apasa ~g~E~w~ pentru a culege fructele.', coords = vector3(2303.531, 4995.985, 42.45914), cb = function() collectFruits() end},
            {text = 'Apasa ~g~E~w~ pentru a culege fructele.', coords = vector3(2316.161, 4993.749, 42.06272), cb = function() collectFruits() end},
            {text = 'Apasa ~g~E~w~ pentru a culege fructele.', coords = vector3(2316.457, 4984.318, 41.80784), cb = function() collectFruits() end},
            {text = 'Apasa ~g~E~w~ pentru a culege fructele.', coords = vector3(2330.891, 4995.968, 42.11561), cb = function() collectFruits() end},
            {text = 'Apasa ~g~E~w~ pentru a culege fructele.', coords = vector3(2317.814, 5008.016, 42.47771), cb = function() collectFruits() end},
            {text = 'Apasa ~g~E~w~ pentru a culege fructele.', coords = vector3(2330.079, 5007.942, 42.35577), cb = function() collectFruits() end},
            {text = 'Apasa ~g~E~w~ pentru a culege fructele.', coords = vector3(2342.826, 5008.026, 42.69398), cb = function() collectFruits() end},
            {text = 'Apasa ~g~E~w~ pentru a culege fructele.', coords = vector3(2331.004, 5021.266, 42.87221), cb = function() collectFruits() end},
            {text = 'Apasa ~g~E~w~ pentru a culege fructele.', coords = vector3(2329.484, 5036.436, 44.38963), cb = function() collectFruits() end},
            {text = 'Apasa ~g~E~w~ pentru a culege fructele.', coords = vector3(2341.254, 5035.288, 44.33813), cb = function() collectFruits() end},
            {text = 'Apasa ~g~E~w~ pentru a culege fructele.', coords = vector3(2356.453, 5021.042, 43.87039), cb = function() collectFruits() end}
        },
        ['Frunze'] = {
            {text = 'Apasa ~g~E~w~ pentru a sufla frunzele.', coords = vector3(2443.239, 4954.125, 45.41265), cb = function() blowLeaves() end},
            {text = 'Apasa ~g~E~w~ pentru a sufla frunzele.', coords = vector3(2452.724, 4959.479, 45.38784), cb = function() blowLeaves() end},
            {text = 'Apasa ~g~E~w~ pentru a sufla frunzele.', coords = vector3(2457.784, 4938.914, 45.18782), cb = function() blowLeaves() end},
            {text = 'Apasa ~g~E~w~ pentru a sufla frunzele.', coords = vector3(2437.48, 4940.375, 44.95733), cb = function() blowLeaves() end}
        }
    }
}

Citizen.CreateThread(function()
    while true do
        local wait = 1000
        if fruitsInHands then
            wait = 0
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
        end
        Wait(wait)
    end
end)

local fruit = false
local alreadyBlowing = false
function blowLeaves()
    if alreadyBlowing then return end
    local scenarioName = 'WORLD_HUMAN_GARDENER_LEAF_BLOWER'
    local scenarioDict = 'Leafblower'

    TaskStartScenarioInPlace(PlayerPedId(), scenarioName, 100000, true)

    local ped = PlayerPedId()
    alreadyBlowing = true
    Core.ProgressBar(10, 100, true, false, nil, true, function ()
        alreadyBlowing = false
        ClearPedTasksImmediately(ped)
        local payout = math.random(100, 300)
        PlayerData.cash = PlayerData.cash + payout
        TriggerEvent('chat:addMessage', {
            args = {'^*^gNicu Fermieru^0: Ai primit '..FormatNumber(payout)..'$ pentru frunzele suflate.'}
        })
        Core.SavePlayer()
    end)
end

function collectFruits()
    if fruitsInHands then return end
    if collecting then return end
    if PlayerData.job.name ~= JobInfo.jobName then return end
    for k,v in pairs(JobInfo.places['Pomi fructiferi']) do
        local dist = #(v.coords - GetEntityCoords(PlayerPedId()))
        if dist <= 2.0 then
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local animdict = "amb@world_human_gardener_plant@male@base"
            local animname = "base"
            collecting = true
            Core.ProgressBar(5, 100, true, {dict = animdict, anim = animname}, nil, true, function ()
                collecting = false
                fruitsInHands = true
                local model = GetHashKey("prop_fruit_basket")
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Wait(0)
                end
                fruit = CreateObject(model, pedCoords.x, pedCoords.y, pedCoords.z, true, true, true)
                SetEntityHeading(fruit, GetEntityHeading(ped))
                SetEntityAsMissionEntity(fruit, true, true)
                SetModelAsNoLongerNeeded(model)

                local animdict = 'anim@heists@box_carry@'
                local animname = 'idle'

                RequestAnimDict(animdict)
                while not HasAnimDictLoaded(animdict) do
                    Wait(0)
                end
                local animdict = 'anim@heists@box_carry@'
                local animname = 'idle'

                RequestAnimDict(animdict)
                while not HasAnimDictLoaded(animdict) do
                    Wait(0)
                end

                -- Attach entity to look like it's holding a box with both hands
                AttachEntityToEntity(fruit, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) -- object is attached to right hand    
                TriggerEvent('chat:addMessage', {
                    args = {'^*^gNicu Fermieru^0: Adu-mi fructele culese de tine, '..PlayerData.user..'!'}
                })
            end)
        end
    end
end





local jobBlips = {}

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
        CreateBlip(JobInfo.pedCoords, JobInfo.jobName, JobInfo.jobBlip, JobInfo.jobBlipColor)
    end
end)

Citizen.CreateThread(function ()
    while not PlayerData.job do
        Wait(100)
    end
    if PlayerData.job.name == JobInfo.jobName then
        local places = JobInfo.places
        for k,v in pairs(places) do
            for i = 1, #v do
                local blip = CreateBlip(v[i].coords, k, 1, 2)
                table.insert(jobBlips, blip)
            end
        end
    end
end)

AddEventHandler('Jobs:Quit', function ()
    PlayerData.job.name = 'Unemployed'
    for k,v in pairs(jobBlips) do
        RemoveBlip(v)
    end
    jobBlips = {}
    Core.SavePlayer()
    TriggerEvent('chat:addMessage', {
        args = {'^*^gNicu Fermieru^0: Ai renuntat la job-ul de Fermier. Daca vrei sa te angajezi din nou, vino la mine.'}
    })
end)

AddEventHandler('Jobs:Check', function ()
    local dist = #(JobInfo.pedCoords - GetEntityCoords(PlayerPedId()))
    if dist < 3.0 then
        PlayerData.job.name = 'Fermier';
        if table.empty(PlayerData.skills) then
            table.insert(PlayerData.skills, {
                ['fermier'] = {
                    level = 1,
                    experience = 0,
                }
            })
        end
        local places = JobInfo.places
        for k,v in pairs(places) do
            for i = 1, #v do
                print(v[i].coords)
                local blip = CreateBlip(v[i].coords, k, 1, 2)
                table.insert(jobBlips, blip)
            end
        end
        Core.SavePlayer()
        sendNotification("Job", "Te-ai angajat ca Fermier.")
        TriggerEvent('chat:addMessage', {
            args = {'^gNicu Fermieru^0: Noroc, '..PlayerData.user..'! Bine ai venit la ferma. Ai pe ^gharta^0 locurile unde poti sa lucrezi. Succes!'}
        })
    end
end)


Citizen.CreateThread(function ()
    while true do
        local wait = 3000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local dist = #(JobInfo.pedCoords - pedCoords)
        for k, v in pairs(JobInfo.places) do
            for i = 1, #v do
                local dist = #(v[i].coords - pedCoords)
                if dist <= 5.0 then
                    wait = 0
                    if PlayerData.job then
                        if PlayerData.job.name == JobInfo.jobName then
                            if dist <= 2.0 then
                                DrawText3D(v[i].coords.x, v[i].coords.y, v[i].coords.z, v[i].text)
                                if IsControlJustPressed(0, 38) then
                                    v[i].cb()
                                end
                            end
                        end
                    end
                end
            end
        end
        if dist <= 5.0 then
            wait = 0
            if PlayerData.job then
                if PlayerData.job.name ~= JobInfo.jobName then
                    if dist <= 2.0 then
                        DrawText3D(JobInfo.pedCoords.x, JobInfo.pedCoords.y, JobInfo.pedCoords.z, JobInfo.pedText.. '~n~Foloseste ~g~[~w~/getjob~g~] sau ~g~[~w~/quitjob~g~]')
                    end
                else
                    for k,v in pairs(JobInfo.places['Frunze']) do
                        local dist2 = #(v.coords - pedCoords)
                        if dist2 <= 4.0 then
                            DrawMarker(1, v.coords.x, v.coords.y, v.coords.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 255, 0, 255, false, false, false, false, false, false, false)
                            DrawText3D(v.coords.x, v.coords.y, v.coords.z, v.text)
                            if IsControlJustPressed(0, 38) then
                                v.cb()
                            end
                        end
                    end
                    if dist <= 2.0 then
                        if fruitsInHands then
                            local payout = math.random(500, 1000)
                            PlayerData.cash = PlayerData.cash + payout
                            fruitsInHands = false
                            ClearPedTasksImmediately(PlayerPedId())
                            TriggerEvent('chat:addMessage', {
                                args = {'^*^gNicu Fermieru^0: Ai primit '..FormatNumber(payout)..'$ pentru fructele culese.'}
                            })
                            DeleteObject(fruit)
                            Core.SavePlayer()
                        end
                        DrawText3D(JobInfo.pedCoords.x, JobInfo.pedCoords.y, JobInfo.pedCoords.z, JobInfo.pedText.."~w~~n~Esti angajat deja.")
                        if PlayerData.skills[1].fermier then
                            DrawText3D(JobInfo.pedCoords.x, JobInfo.pedCoords.y, JobInfo.pedCoords.z - 0.1, "Nivel Skill: ~g~"..PlayerData.skills[1].fermier.level)
                        else
                            DrawText3D(JobInfo.pedCoords.x, JobInfo.pedCoords.y, JobInfo.pedCoords.z - 0.25, "Nivel Skill: ~g~1")
                        end
                    end
                end
            end
        end
        Wait(wait)
    end
end)

