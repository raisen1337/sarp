-- 103

local JobInfo = {
    jobName = 'PizzaBoy',
    pedCoords = vec3(-290.52420043945,6133.5678710938,31.54686164856),
    pedHeading = 219.19836425781,
    ped = "s_m_m_linecook",
    jobBlip = 103, 
    jobBlipColor = 28,
    jobCarModel = 'foodcar4',
    pedText = "~o~[~w~PizzaBoy~o~]",
    places = {
        ['Delivery Place'] = {
            {
                text = 'Apasa ~g~E~w~ pentru a culege fructele.',
                coords = vector3(-374.3736267089844, 6190.81298828125, 31.7230224609375),
                cb = function() deliveryPizza() end
            },
            {
                text = 'Apasa ~g~E~w~ pentru a culege fructele.',
                coords = vector3(-356.8615417480469, 6207.12548828125, 31.841064453125),
                w = 0.0,
                cb = function() deliveryPizza() end
            },
            {
                text = 'Apasa ~g~E~w~ pentru a culege fructele.',
                coords = vector3(-347.3538513183594, 6225.20458984375, 31.874755859375),
                w = 34.0157470703125,
                cb = function() deliveryPizza() end
            },
            {
                text = 'Apasa ~g~E~w~ pentru a culege fructele.',
                coords = vector3(-360.23736572265627, 6260.59765625, 31.8916015625),
                w = 130.39370727539063,
                cb = function() deliveryPizza() end
            },
            {
                text = 'Apasa ~g~E~w~ pentru a culege fructele.',
                coords = vector3(-332.5845947265625, 6302.13623046875, 33.087890625),
                w = 238.1102294921875,
                cb = function() deliveryPizza() end
            },
            {
                text = 'Apasa ~g~E~w~ pentru a culege fructele.',
                coords = vector3(-302.9274597167969, 6327.40234375, 32.8857421875),
                w = 232.44094848632813,
                cb = function() deliveryPizza() end
            },
            {
                text = 'Apasa ~g~E~w~ pentru a culege fructele.',
                coords = vector3(-272.5714111328125, 6400.86572265625, 31.5040283203125),
                w = 25.511812210083,
                cb = function() deliveryPizza() end
            },
            {
                text = 'Apasa ~g~E~w~ pentru a culege fructele.',
                coords = vector3(-227.23516845703126, 6377.3935546875, 31.7568359375),
                w = 232.44094848632813,
                cb = function() deliveryPizza() end
            },
            {
                text = 'Apasa ~g~E~w~ pentru a culege fructele.',
                coords = vector3(-214.4835205078125, 6444.25048828125, 31.3018798828125),
                w = 110.55118560791016,
                cb = function() deliveryPizza() end
            },
            {
                text = 'Apasa ~g~E~w~ pentru a culege fructele.',
                coords = vector3(76.24615478515625, 6492.791015625, 31.7230224609375),
                w = 99.21259307861328,
                cb = function() deliveryPizza() end
            }
        }
    }

}

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

AddEventHandler('Jobs:Quit', function ()
    if PlayerData.job.name ~= JobInfo.jobName then return end
    if PlayerData.job.name == 'Unemployed' then return end
    PlayerData.job.name = 'Unemployed'
    Core.SavePlayer()
    TriggerEvent('chat:addMessage', {
        args = {'^*^yGicu Pizzeru^0: Ai renuntat la job-ul de PizzaBoy. Daca vrei sa te angajezi din nou, vino la mine.'}
    })
end)

function deliveryPizza()
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        Core.ProgressBar(4, 100, true, nil, nil, true, function ()
            local random = math.random(100, 300)
            sendNotification("Job", "Ai livrat o pizza si ai primit: "..FormatNumber(random).."$", 'success')
            PlayerData.cash = PlayerData.cash + random
            local tips = 0
            --make a chance to get tips
            if math.random(1, 100) <= 10 then
                tips = math.random(100, 300)
                sendNotification("Job", "Ai primit bacsis: "..FormatNumber(tips).."$", 'success')
                PlayerData.cash = PlayerData.cash + tips
            end
            Core.SavePlayer()
            local randomIndex = math.random(1, #JobInfo.places['Delivery Place'])
            local randomPlace = JobInfo.places['Delivery Place'][randomIndex]
            CreateCP(1, randomPlace.coords, {245, 197, 66, 255}, 1.0, 5.0, randomPlace.cb)
            TriggerEvent('chat:addMessage', {
                args = {'^*^yGicu Pizzeru^0: Ai livrat o pizza si ai primit '..FormatNumber(random)..'$ si ai primit '..FormatNumber(tips)..'$ bacsis!'}
            })
        end)
    end
end

RegisterCommand('startwork', function()
    TriggerEvent('Job:StartWork')
end)

RegisterCommand('stopwork', function()
    TriggerEvent('Job:StopWork')
end)

local alreadyWorking = false
local jobCar = false
Citizen.CreateThread(function ()
    while true do
        wait = 3000
        if alreadyWorking then
            wait = 1
            for _, i in ipairs(GetActivePlayers()) do
                if i ~= PlayerId() then
                  local closestPlayerPed = GetPlayerPed(i)
                  local veh = GetVehiclePedIsIn(closestPlayerPed, false)
                  SetEntityNoCollisionEntity(veh, GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
                end
            end
        end
        Wait(3000)
    end
end)

AddEventHandler('Job:StopWork', function()
    if PlayerData.job.name == 'Unemployed' then return end
    if PlayerData.job.name == JobInfo.jobName then
        if alreadyWorking then
            Core.DeleteAllCps()
            if DoesEntityExist(jobCar) then
                DeleteEntity(jobCar)
            end
            alreadyWorking = false
            TriggerEvent('chat:addMessage', {
                args = {'^*^yGicu Pizzeru^0: Te-ai oprit din lucrat!'}
            })
        end
    end
end)

AddEventHandler('Job:StartWork', function()
    if PlayerData.job.name == 'Unemployed' then return end
    if PlayerData.job.name == JobInfo.jobName then
        local dist = #(JobInfo.pedCoords - GetEntityCoords(PlayerPedId()))
        if dist > 5.0 then
            sendNotification("Job", "Trebuie sa fii aproape de angajator pentru a incepe sa lucrezi.", 'error')
            return
        end
        if not alreadyWorking then
            Core.HasCheckpoint(function(has)
                if has then
                    Core.DeleteAllCps()
                end
            end)
            Wait(100)
            jobCar = CreateCar(JobInfo.jobCarModel, vector3(-305.34680175781,6118.919921875,31.499395370483), 224.9151763916, true, true, true, "PIZZA", false)
            alreadyWorking = true
            local randomIndex = math.random(1, #JobInfo.places['Delivery Place'])
            local randomPlace = JobInfo.places['Delivery Place'][randomIndex]
            CreateCP(1, randomPlace.coords, {245, 197, 66, 255}, 1.0, 5.0, randomPlace.cb)
            TriggerEvent('chat:addMessage', {
                args = {'^*^yGicu Pizzeru^0: Ai inceput sa lucrezi. Du-te la locul marcat pe harta pentru a livra!'}
            })
            TriggerEvent('chat:addMessage', {
                args = {'^*^yGicu Pizzeru^0: Te poti oprii din a lucra folosind comanda /stopwork!'}
            })
        end
    end
end)


Citizen.CreateThread(function ()
    while true do
        local wait = 3000
        local dist = #(JobInfo.pedCoords - GetEntityCoords(PlayerPedId()))
        if dist <= 5.0 then
            wait = 0
            if PlayerData.job then
                if PlayerData.job.name ~= JobInfo.jobName then
                    if dist <= 2.0 then
                        DrawText3D(JobInfo.pedCoords.x, JobInfo.pedCoords.y, JobInfo.pedCoords.z, JobInfo.pedText.. '~n~Foloseste ~o~[~w~/getjob~o~] sau ~o~[~w~/quitjob~o~]')
                    end
                else
                    if dist <= 2.0 then
                        DrawText3D(JobInfo.pedCoords.x, JobInfo.pedCoords.y, JobInfo.pedCoords.z, JobInfo.pedText.. '~n~~o~Esti angajat deja.')
                    end
                end
            end
        end
        Wait(wait)
    end
end)

AddEventHandler('Jobs:Check', function (bypass, jobName)
    if bypass then
        if jobName == JobInfo.jobName then
            PlayerData.job.name = 'PizzaBoy';
            if table.empty(PlayerData.skills) then
                table.insert(PlayerData.skills, {
                    ['pizzaboy'] = {
                        level = 1,
                        experience = 0,
                    }
                })
            end
            Core.SavePlayer()
            sendNotification("Job", "Te-ai angajat ca PizzaBoy.")
            TriggerEvent('chat:addMessage', {
                args = {'^yGicu Pizzeru^0: Noroc, '..PlayerData.user..'! Bine ai venit la pizzerie. Foloseste comanda [^y/startwork^0], pentru a incepe sa lucrezi!'}
            })
            return
        end
    end
    local dist = #(JobInfo.pedCoords - GetEntityCoords(PlayerPedId()))
    if dist < 5.0 then
        PlayerData.job.name = 'PizzaBoy';
        if table.empty(PlayerData.skills) then
            table.insert(PlayerData.skills, {
                ['pizzaboy'] = {
                    level = 1,
                    experience = 0,
                }
            })
        end
        Core.SavePlayer()
        sendNotification("Job", "Te-ai angajat ca PizzaBoy.")
        TriggerEvent('chat:addMessage', {
            args = {'^yGicu Pizzeru^0: Noroc, '..PlayerData.user..'! Bine ai venit la pizzerie. Foloseste comanda [^y/startwork^0], pentru a incepe sa lucrezi!'}
        })
    end
end)
