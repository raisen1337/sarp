local JobInfo = {
    jobName = 'Petrolier',
    pedCoords = vec3(2748.3688964844,1453.4514160156,24.496913909912),
    pedHeading = 157.98767089844,
    ped = "csb_trafficwarden",
    jobBlip = 653, 
    jobBlipColor = 28,
    jobCarModel = 'foodcar4',
    pedText = "~o~[~w~Petrolier~o~]",
    blips = {},
    places = {
        {text = '~o~[~w~Garaj Petrolier~o~]~n~~w~Apasa [~o~E~w~] pentru a deschide garajul.', coords = vec3(2725.1159667969,1368.5738525391,24.523971557617), heading = 180.49899291992, blip = 473, blipColor = 28, blipName = 'Garaj Petrolier'},
        {text = '~o~[~w~Remorca Petrolier~o~]~n~~w~Apasa [~o~E~w~] pentru a lua remorca.', coords = vec3(2771.2707519531,1440.6174316406,24.520572662354), heading = 0, blip = 479, blipColor = 28, blipName = 'Remorca Petrolier'},
        {text = '~o~[~w~Statie Incarcare~o~]~n~~w~Apasa [~o~E~w~] pentru a incarca petrol.', coords = vec3(1717.4716796875,-1628.140625,112.47932434082), heading = 0, blip = 467, blipColor = 28, blipName = 'Statie Incarcare Petrol'},
        {text = '~o~[~w~Statie Rafinare~o~]~n~~w~Apasa [~o~E~w~] pentru a rafina petrolul.', coords = vec3(2804.052734375,1559.6090087891,24.529273986816), heading = 0, blip = 436, blipColor = 28, blipName = 'Statie Rafinare Petrol'},
    },
    unloading = {
        {text = '~o~[~w~Benzinarie~o~]~n~~w~Apasa [~o~E~w~] pentru a descarca petrolul.', coords = vec3(1991.7398681641,3761.7236328125,32.180919647217), heading = 0, blip = 467, blipColor = 28, blipName = 'Benzinarie'},
        {text = '~o~[~w~Benzinarie~o~]~n~~w~Apasa [~o~E~w~] pentru a descarca petrolul.', coords = vec3(2706.9025878906,4344.900390625,45.720737457275), heading = 0, blip = 436, blipColor = 28, blipName = 'Benzinarie'},
        {text = '~o~[~w~Benzinarie~o~]~n~~w~Apasa [~o~E~w~] pentru a descarca petrolul.', coords = vec3(2683.8500976563,3262.5939941406,55.240505218506), heading = 0, blip = 436, blipColor = 28, blipName = 'Benzinarie'},
        {text = '~o~[~w~Benzinarie~o~]~n~~w~Apasa [~o~E~w~] pentru a descarca petrolul.', coords = vec3(1702.1296386719,4943.2548828125,42.078121185303), heading = 0, blip = 436, blipColor = 28, blipName = 'Benzinarie'},
    }
}

local petrolierGarage = MenuV:CreateMenu(false, 'Garaj Petrolier', 'topright', 155, 0, 0, 'size-125', 'none', 'menuv', 'garaj_petrolier')

local availableTrucks = {
    {spawncode = 'phantom', label = 'Phantom', price = 150000},
    {spawncode = 'hauler', label = 'Hauler', price = 100000},
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
        args = {'^*^yMarian Petrolieru^0: Ai renuntat la job-ul de Petrolier. Daca vrei sa te angajezi din nou, vino la mine.'}
    })
end)

local alreadyWorking = false

AddEventHandler('Job:StopWork', function()
    if PlayerData.job.name == 'Unemployed' then return end
    if PlayerData.job.name == JobInfo.jobName then
        if alreadyWorking then
            Core.DeleteAllCps()
            alreadyWorking = false
            TriggerEvent('chat:addMessage', {
                args = {'^*^yMarian Petrolieru^0: Te-ai oprit din lucrat!'}
            })
        end
    end
end)

AddEventHandler('Job:StartWork', function()
    if PlayerData.job.name == 'Unemployed' then return end
    if PlayerData.job.name == JobInfo.jobName then
       
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

local playerInfo = {}

function unloadPay()
    if playerInfo['loadedRafined'] then
        if playerInfo['unloading'] then
            TriggerEvent('chat:addMessage', {
                args = {'^*^yMarian Petrolieru^0: Asteapta pana se descarca!'}
            })
            return
        end
        playerInfo['unloading'] = true
        if not playerInfo['unloadedTimes'] then
            playerInfo['unloadedTimes'] = 0
        end
        if playerInfo['unloadedTimes'] + 1 >= 7 then
            playerInfo['unloadedTimes'] = 7
            playerInfo['loadedRafined'] = false
            playerInfo['loadedUnrafined'] = false

            TriggerEvent('chat:addMessage', {
                args = {'^*^yMarian Petrolieru^0: Ai terminat, adu camionul inapoi sau foloseste /dv.'}
            })
            return
        end
        FreezeEntityPosition(playerInfo['truck'], true)
        FreezeEntityPosition(playerInfo['trailer'], true)
        Core.ProgressBar(20, 100, false, false, false, true, function()
            local randomMoney = math.random(6000, 10000)
            playerInfo['unloading'] = false
            playerInfo['unloadedTimes'] = playerInfo['unloadedTimes'] + 1
            PlayerData.cash = PlayerData.cash + randomMoney
            FreezeEntityPosition(playerInfo['truck'], false)
            FreezeEntityPosition(playerInfo['trailer'], false)
            Core.SavePlayer()
            TriggerEvent('chat:addMessage', {
                args = {'^*^yMarian Petrolieru^0: Ai descarcat petrolul cu succes! Ai primit '..FormatNumber(randomMoney)..'$'}
            })
            Core.DeleteAllCps()
            TriggerEvent('chat:addMessage', {
                args = {'^*^yMarian Petrolieru^0: Mergi si descarca si la alta benzinarie!'}
            })
            local randomGas = math.random(1, #JobInfo.unloading)
            playerInfo['unloadedTimes'] = playerInfo['unloadedTimes'] + 1
            local cp = CreateCP(1, JobInfo['unloading'][randomGas].coords, {255, 177, 33, 255}, 10.0, 30.0, function ()
                unloadPay()
            end)
            SetBlipRoute(cp.blip, true)
        end, function ()
            playerInfo['unloading'] = false
            TriggerEvent('chat:addMessage', {
                args = {'^*^yMarian Petrolieru^0: Ai anulat descarcarea!'}
            })
        end)
        
    end
end
    

Citizen.CreateThread(function ()
    while true do
        local wait = 3000
        if not LoggedIn then
            Wait(1)
        end
        if PlayerData.job then
            if PlayerData.job.name == JobInfo.jobName then
                if alreadyWorking and not DoesEntityExist(playerInfo['truck']) then
                    wait = 0
                    alreadyWorking = false
                    if DoesEntityExist(playerInfo['trailer']) then
                        DeleteEntity(playerInfo['trailer'])
                    end
                    Core.DeleteAllCps()
                    
                    TriggerEvent('chat:addMessage', {
                        args = {'^*^yMarian Petrolieru^0: Ti-a fost anulata cursa pentru ca nu mai ai camionul!'}
                    })
                    wait = 3000
                end
                if DoesEntityExist(playerInfo['truck']) and DoesEntityExist(playerInfo['trailer']) and alreadyWorking then
                    if not IsVehicleAttachedToTrailer(playerInfo['truck']) then
                        wait = 0
                        local distanceFromTrailer = #(GetEntityCoords(playerInfo['truck']) - GetEntityCoords(playerInfo['trailer']))
                        AttachVehicleToTrailer(playerInfo['truck'], playerInfo['trailer'], distanceFromTrailer)
                    end
                end
                local dist = #(JobInfo.places[1].coords - GetEntityCoords(PlayerPedId()))
                local dist2 = #(JobInfo.places[2].coords - GetEntityCoords(PlayerPedId()))
                local dist3 = #(JobInfo.places[3].coords - GetEntityCoords(playerInfo['trailer']))
                local dist4 = #(JobInfo.places[4].coords - GetEntityCoords(playerInfo['trailer']))

                if dist3 < 10.0 and alreadyWorking and DoesEntityExist(playerInfo['trailer']) and IsVehicleAttachedToTrailer(playerInfo['truck']) then
                    if not playerInfo['loadedUnrafined'] then
                        wait = 0
                        DrawMarker(23, JobInfo.places[3].coords.x, JobInfo.places[3].coords.y, JobInfo.places[3].coords.z - 0.95, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 4.0, 255, 177, 33, 100, true, true, 0, true)
                        DrawText3D(JobInfo.places[3].coords.x, JobInfo.places[3].coords.y, JobInfo.places[3].coords.z, JobInfo.places[3].text)
                        if IsControlJustPressed(0, 38) then
                            FreezeEntityPosition(playerInfo['truck'], true)
                            FreezeEntityPosition(playerInfo['trailer'], true)
                            if playerInfo['loading'] then
                                TriggerEvent('chat:addMessage', {
                                    args = {'^*^yMarian Petrolieru^0: Asteapta pana se incarca!'}
                                })
                                return
                            end
                            playerInfo['loading'] = true
                            Core.ProgressBar(5, 100, true, false, false, true, function ()
                                FreezeEntityPosition(playerInfo['truck'], false)
                                FreezeEntityPosition(playerInfo['trailer'], false)
                                playerInfo['loadedUnrafined'] = true
                                playerInfo['loading'] = false
                                
                                for k,v in pairs(JobInfo.blips) do
                                    if v.blipName == 'Statie Rafinare Petrol' then
                                        SetBlipRoute(v.blip, true)
                                        SetBlipRouteColour(v.blip, 28)
                                    end
                                end
                            end, function ()
                                FreezeEntityPosition(playerInfo['truck'], false)
                                FreezeEntityPosition(playerInfo['trailer'], false)
                                playerInfo['loading'] = false
                                TriggerEvent('chat:addMessage', {
                                    args = {'^*^yMarian Petrolieru^0: Ai anulat incarcarea!'}
                                })
                            end)
                        end
                    end
                end
                
                if dist4 < 10.0 and alreadyWorking and DoesEntityExist(playerInfo['trailer']) and IsVehicleAttachedToTrailer(playerInfo['truck']) then
                    if playerInfo['loadedUnrafined'] and not playerInfo['loadedRafined'] then
                        wait = 0
                        DrawMarker(23, JobInfo.places[4].coords.x, JobInfo.places[4].coords.y, JobInfo.places[4].coords.z - 0.95, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 4.0, 255, 177, 33, 100, true, true, 0, true)
                        DrawText3D(JobInfo.places[4].coords.x, JobInfo.places[4].coords.y, JobInfo.places[4].coords.z, JobInfo.places[4].text)
                        if IsControlJustPressed(0, 38) then
                            FreezeEntityPosition(playerInfo['truck'], true)
                            FreezeEntityPosition(playerInfo['trailer'], true)
                            if playerInfo['loading'] then
                                TriggerEvent('chat:addMessage', {
                                    args = {'^*^yMarian Petrolieru^0: Asteapta pana se incarca!'}
                                })
                                return
                            end
                            playerInfo['loading'] = true
                            Core.ProgressBar(5, 100, true, false, false, true, function ()
                                FreezeEntityPosition(playerInfo['truck'], false)
                                FreezeEntityPosition(playerInfo['trailer'], false)
                                playerInfo['loadedRafined'] = true
                                playerInfo['loading'] = false
                                TriggerEvent('chat:addMessage', {
                                    args = {'^*^yMarian Petrolieru^0: Ai incarcat remorca cu petrol rafinat! Mergi la benzinarie si descarca-l.'}
                                })
                                local randomGas = math.random(1, #JobInfo.unloading)
                                local cp = CreateCP(1, JobInfo['unloading'][randomGas].coords, {255, 177, 33, 255}, 10.0, 30.0, function ()
                                    if not playerInfo['unloadedTimes'] or playerInfo['unloadedTimes'] < 5 then
                                        playerInfo['unloadedTimes'] = 0
                                        
                                        
                                        unloadPay()
                                        
                                    end
                                    
                                    
                                end)
                                SetBlipRoute(cp.blip, true)
                            end, function ()
                                FreezeEntityPosition(playerInfo['truck'], false)
                                FreezeEntityPosition(playerInfo['trailer'], false)
                                playerInfo['loading'] = false
                                TriggerEvent('chat:addMessage', {
                                    args = {'^*^yMarian Petrolieru^0: Ai anulat incarcarea!'}
                                })
                            end)
                        end
                 
                    end
                end

                if dist2 <= 5.0 then
                    wait = 0
                    DrawMarker(39, JobInfo.places[2].coords.x, JobInfo.places[2].coords.y, JobInfo.places[2].coords.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 177, 33, 100, true, true, 0, true)
                    DrawText3D(JobInfo.places[2].coords.x, JobInfo.places[2].coords.y, JobInfo.places[2].coords.z, JobInfo.places[2].text)
                    if IsControlJustPressed(0, 38) then
                        if DoesEntityExist(playerInfo['truck']) then
                            if IsPedInVehicle(PlayerPedId(), playerInfo['truck'], false) then
                                if not alreadyWorking then
                                    if DoesEntityExist(playerInfo['trailer']) then
                                        TriggerEvent('chat:addMessage', {
                                            args = {'^*^yMarian Petrolieru^0: Ai deja o remorca scoasa!'}
                                        })
                                        return
                                    end
                                    if IsVehicleAttachedToTrailer(playerInfo['truck']) then
                                        TriggerEvent('chat:addMessage', {
                                            args = {'^*^yMarian Petrolieru^0: Ai deja o remorca atasata!'}
                                        })
                                        return
                                    end
                                    alreadyWorking = true
                                    TriggerEvent('chat:addMessage', {
                                        args = {'^*^yMarian Petrolieru^0: Ai inceput sa lucrezi! Mergi la statia de incarcare.'}
                                    })

                                    for k,v in pairs(JobInfo.blips) do
                                        if v.blipName == 'Statie Incarcare Petrol' then
                                            SetBlipRoute(v.blip, true)
                                            SetBlipRouteColour(v.blip, 28)
                                        end
                                    end

                                    playerInfo['trailer'] = CreateCar('tanker', JobInfo.places[2].coords, GetEntityHeading(playerInfo['truck']), true, true, false, "PETROLIER", false)
                                    AttachVehicleToTrailer(playerInfo['truck'], playerInfo['trailer'], 3.0)
                                    SetEntityInvincible(playerInfo['trailer'], true)
                                else
                                    TriggerEvent('chat:addMessage', {
                                        args = {'^*^yMarian Petrolieru^0: Esti deja la munca!'}
                                    })
                                end
                            else
                                TriggerEvent('chat:addMessage', {
                                    args = {'^*^yMarian Petrolieru^0: Trebuie sa fii in camion pentru a incepe sa lucrezi!'}
                                })
                            end
                        else
                            TriggerEvent('chat:addMessage', {
                                args = {'^*^yMarian Petrolieru^0: Nu ai camionul scos din garaj!'}
                            })
                        end
                    end
                end
                if dist <= 5.0 then
                    wait = 0
                    DrawMarker(39, JobInfo.places[1].coords.x, JobInfo.places[1].coords.y, JobInfo.places[1].coords.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 177, 33, 100, true, true, 0, true)
                    DrawText3D(JobInfo.places[1].coords.x, JobInfo.places[1].coords.y, JobInfo.places[1].coords.z, JobInfo.places[1].text)
                  
                    if IsControlJustPressed(0, 38) then
                        petrolierGarage:ClearItems()

                        petrolierGarage:AddButton({
                            icon = "🚚",
                            label = 'Camioane detinute'
                        }):On('select', function()
                            if PlayerData.ownedTrucks then
                                petrolierGarage:ClearItems()
                                for _, truck in pairs(PlayerData.ownedTrucks) do
                                    petrolierGarage:AddButton({
                                        label = truck.label,
                                        icon = "🚚",
                                    }):On('select', function ()
                                        petrolierGarage:ClearItems()

                                        petrolierGarage:AddButton({
                                            disabled = true,
                                            label = "Nume: "..truck.label,
                                            icon = "🚚",
                                        })

                                        petrolierGarage:AddButton({
                                            disabled = true,
                                            label = "Pret: "..FormatNumber(truck.price).."$",
                                            icon = "💸",
                                        })

                                        petrolierGarage:AddButton({
                                            label = 'Vinde',
                                            icon = "💸",
                                        }):On('select', function ()

                                            for k,v in pairs(PlayerData.ownedTrucks) do
                                                if v.spawncode == truck.spawncode then
                                                    table.remove(PlayerData.ownedTrucks, k)
                                                    if DoesEntityExist(playerInfo['truck']) then
                                                        DeleteEntity(playerInfo['truck'])
                                                    end
                                                    PlayerData.cash = PlayerData.cash + truck.price
                                                    Core.SavePlayer()
                                                    petrolierGarage:Close()
                                                    sendNotification("Job", "Ai vandut camionul cu succes.", 'success')
                                                end
                                            end
                                        end)

                                        petrolierGarage:AddButton({
                                            icon = "🚚",
                                            label = "Scoate din garaj",
                                        }):On('select', function ()
                                            if not DoesEntityExist(playerInfo['truck']) then
                                                playerInfo['truck'] = CreateCar(truck.spawncode, JobInfo.places[1].coords, JobInfo.places[1].heading, true, true, true, "PETROLIER", false)
                                                petrolierGarage:Close()
                                                --chat msg
                                                TriggerEvent('chat:addMessage', {
                                                    args = {'^*^yMarian Petrolieru^0: Ai scos camionul din garaj! Acum mergi si ia remorca.'}
                                                })

                                                sendNotification("Job", "Ai scos camionul din garaj.", 'success')
                                            else
                                                sendNotification("Job", "Ai deja un camion scos din garaj.", 'error')
                                            end
                                        end)
                                    end)
                                end
                            else
                                petrolierGarage:ClearItems()

                                petrolierGarage:AddButton({
                                    icon = "🚫",
                                    label = 'Nu detii camioane',
                                    disabled = true
                                })

                                MenuV:Refresh();

                            end
                        end)

                        petrolierGarage:AddButton({
                            icon = "🛒",
                            label = 'Magazin Camioane'
                        }):On('select', function ()
                            if PlayerData.ownedTrucks then
                                local found = false
                                petrolierGarage:ClearItems()
                                for _, v in pairs(availableTrucks) do
                                    petrolierGarage:AddButton({
                                        label = v.label,
                                        icon = "🚚",
                                    }):On('select', function ()
                                        petrolierGarage:ClearItems()

                                        petrolierGarage:AddButton({
                                            disabled = true,
                                            label = "Nume: "..v.label,
                                            icon = "🚚",
                                        })

                                        petrolierGarage:AddButton({
                                            disabled = true,
                                            label = "Pret: "..FormatNumber(v.price).."$",
                                            icon = "💸",
                                        })

                                        petrolierGarage:AddButton({
                                            icon = "🛒",
                                            label = "Cumpara",
                                        }):On('select', function ()
                                            if PlayerData.cash >= v.price then
                                                for _, truck in pairs(PlayerData.ownedTrucks) do
                                                    if truck.spawncode == v.spawncode then
                                                        found = true
                                                        sendNotification("Job", "Deja detii acest camion.", 'error')
                                                        return
                                                    end
                                                end
                                                
                                                table.insert(PlayerData.ownedTrucks, {
                                                    spawncode = v.spawncode,
                                                    label = v.label,
                                                    price = v.price,
                                                })

                                                PlayerData.cash = PlayerData.cash - v.price
                                                Core.SavePlayer()
                                                petrolierGarage:Close()
                                            else
                                                sendNotification("Job", "Nu ai suficienti bani.", 'error')
                                            end
                                        end)
                                    end)
                                end
                            elseif table.empty(PlayerData.ownedTrucks) or not PlayerData.ownedTrucks then   
                                petrolierGarage:ClearItems()

                                for k,v in pairs(availableTrucks) do
                                    petrolierGarage:AddButton({
                                        label = v.label,
                                        icon = "🚚",
                                    }):On('select', function ()
                                        petrolierGarage:ClearItems()

                                        petrolierGarage:AddButton({
                                            disabled = true,
                                            label = "Nume: "..v.label,
                                            icon = "🚚",
                                        })

                                        petrolierGarage:AddButton({
                                            disabled = true,
                                            label = "Pret: "..FormatNumber(v.price).."$",
                                            icon = "💸",
                                        })

                                        petrolierGarage:AddButton({
                                            icon = "🛒",
                                            label = "Cumpara",
                                        }):On('select', function ()
                                            if PlayerData.cash >= v.price then
                                                if not PlayerData.ownedTrucks then
                                                    PlayerData.ownedTrucks = {}
                                                end
                                                table.insert(PlayerData.ownedTrucks, {
                                                    spawncode = v.spawncode,
                                                    label = v.label,
                                                    price = v.price,
                                                })

                                                PlayerData.cash = PlayerData.cash - v.price
                                                MenuV:CloseAll()
                                                Core.SavePlayer()
                                                petrolierGarage:Close()
                                            else
                                                sendNotification("Job", "Nu ai suficienti bani.", 'error')
                                            end
                                        end)
                                    end)
                                end

                                MenuV:Refresh();
                            end
                        end)
                        MenuV:OpenMenu(petrolierGarage)
                    end
                end
            end
        end
        Wait(wait)
    end
end)

Citizen.CreateThread(function ()
    while true do
        local wait = 5000
        if not LoggedIn then
            Wait(1)
        end
        if PlayerData.job then
            if PlayerData.job.name == JobInfo.jobName and table.empty(JobInfo.blips) then
                BuildBlips()
            end
        end
        Wait(wait)
    end
end)


BuildBlips = function ()
    for k,v in pairs(JobInfo.places) do
        local blip = CreateBlip(v.coords, v.blipName, v.blip, v.blipColor)
        table.insert(JobInfo.blips, {blip = blip, blipName = v.blipName})
    end
end

AddEventHandler('Jobs:Check', function (bypass, jobName)
    if bypass then
        if jobName == JobInfo.jobName then
            PlayerData.job.name = 'Petrolier';
            if table.empty(PlayerData.skills) then
                table.insert(PlayerData.skills, {
                    ['petrolier'] = {
                        level = 1,
                        experience = 0,
                    }
                })
            end
            BuildBlips()
            Core.SavePlayer()
            sendNotification("Job", "Te-ai angajat ca Petrolier.")
            TriggerEvent('chat:addMessage', {
                args = {'^yMarian Petrolieru^0: Noroc, '..PlayerData.user..'! Verifica locatiile de pe harta!'}
            })
            return
        end
    end
    local dist = #(JobInfo.pedCoords - GetEntityCoords(PlayerPedId()))
    if dist < 5.0 then
        PlayerData.job.name = 'Petrolier';
        if table.empty(PlayerData.skills) then
            table.insert(PlayerData.skills, {
                ['petrolier'] = {
                    level = 1,
                    experience = 0,
                }
            })
        end
        BuildBlips()
        Core.SavePlayer()
        sendNotification("Job", "Te-ai angajat ca Petrolier.")
        TriggerEvent('chat:addMessage', {
            args = {'^yMarian Petrolieru^0: Noroc, '..PlayerData.user..'!. Verifica locatiile de pe harta!'}
        })
    end
end)