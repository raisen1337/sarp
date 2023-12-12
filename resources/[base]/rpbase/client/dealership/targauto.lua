local a = {
    {
        x = 37.4373664855957,
        y = 6379.4375,
        z = 31.217529296875,
        w = 212.59841918945313,
    },
    {
        x = 39.8901138305664,
        y = 6382.41748046875,
        z = 31.217529296875,
        w = 212.59841918945313
    },
    {
        x = 42.55384826660156,
        y = 6385.279296875,
        z = 31.217529296875,
        w = 215.43309020996095
    },
    {
        x = 45.21758651733398,
        y = 6388.28564453125,
        z = 31.217529296875,
        w = 209.76377868652345
    },
    {
        x = 47.84176254272461,
        y = 6391.173828125,
        z = 31.217529296875,
        w = 206.92913818359376
    },
    {
        x = 50.42637634277344,
        y = 6393.75830078125,
        z = 31.217529296875,
        w = 212.59841918945313
    },
    {
        x = 48.51428985595703,
        y = 6362.4921875,
        z = 31.234375,
        w = 212.59841918945313
    },
    {
        x = 51.16484069824219,
        y = 6365.64404296875,
        z = 31.234375,
        w = 212.59841918945313
    },
    {
        x = 53.84176254272461,
        y = 6368.68994140625,
        z = 31.234375,
        w = 209.76377868652345
    },
    {
        x = 60.67252731323242,
        y = 6374.2548828125,
        z = 31.234375,
        w = 31.18110275268554
    },
    {
        x = 63.41538619995117,
        y = 6377.06396484375,
        z = 31.234375,
        w = 31.18110275268554
    },
    {
        x = 66.22417449951172,
        y = 6379.79345703125,
        z = 31.234375,
        w = 31.18110275268554
    }
}

local saleVehicles = {}
local closestVehicle = nil
-- Core.TriggerCallback('Server:GetSaleVehicles')

local function refreshSaleVehicles(vehicle)
    table.insert(saleVehicles, vehicle)
    local position = #saleVehicles
    if position <= 12 then
        local spawnPosition = a[position]
        if spawnPosition then
            local pos = vec3(spawnPosition.x, spawnPosition.y, spawnPosition.z)
            spawnPosition.occupied = true
            spawnPosition.model = vehicle.model
            spawnPosition.name = vehicle.name
            spawnPosition.price = vehicle.price
            local spawnedVehicle = CreateCar(vehicle.model, pos, spawnPosition.w, false, true, false, "TGAUTO", true)
            SetVehicleDoorsLocked(spawnedVehicle, 2)
            SetVehicleDoorsLockedForAllPlayers(spawnedVehicle, true)
            SetVehicleDoorsLockedForPlayer(spawnedVehicle, PlayerId(), false)
            SetVehicleEngineOn(spawnedVehicle, false, true, true)
            SetVehicleUndriveable(spawnedVehicle, true)

            spawnPosition.id = spawnedVehicle

            local vehicle = spawnedVehicle

            SetVehicleOnGroundProperly(spawnedVehicle)
            -- Add random modifications to the vehicle
            if GetNumVehicleMods(vehicle, 1) > 0 then
                SetVehicleMod(vehicle, 1, math.random(1, GetNumVehicleMods(vehicle, 1))) -- Set random bumper modification
            end

            if GetNumVehicleMods(vehicle, 2) > 0 then
                SetVehicleMod(vehicle, 2, math.random(1, GetNumVehicleMods(vehicle, 2))) -- Set random color modification
            end

            if GetNumVehicleMods(vehicle, 0) > 0 then
                SetVehicleMod(vehicle, 0, math.random(1, GetNumVehicleMods(vehicle, 0))) -- Set random spoiler modification
            end

            if GetNumVehicleMods(vehicle, 4) > 0 then
                SetVehicleMod(vehicle, 4, math.random(1, GetNumVehicleMods(vehicle, 4))) -- Set random exhaust modification
            end

            if GetNumVehicleMods(vehicle, 10) > 0 then
                SetVehicleMod(vehicle, 10, math.random(1, GetNumVehicleMods(vehicle, 10))) -- Set random roof modification
            end

            if GetNumVehicleMods(vehicle, 7) > 0 then
                SetVehicleMod(vehicle, 7, math.random(1, GetNumVehicleMods(vehicle, 7))) -- Set random wheel modification
            end

            if GetNumVehicleMods(vehicle, 6) > 0 then
                SetVehicleMod(vehicle, 6, math.random(1, GetNumVehicleMods(vehicle, 6))) -- Set random hood modification
            end
        end
    end
end

local delay = false

Citizen.CreateThread(function()
    while not LoggedIn do Wait(100) end
    while true do
        Wait(1000)
        if delay then
            delay = false
        end
        if not table.empty(a) then
            for k, v in pairs(a) do
                if v.id then
                    local vehicle = v.id
                    if GetEntityHeading(vehicle) ~= v.pos.w then
                        SetEntityHeading(vehicle, v.pos.w)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while not LoggedIn do Wait(100) end
    if LoggedIn then
        CreateBlip(vec3(51.844806671143, 6377.2495117188, 30.835720062256), 'Targ Auto', 79, 5)
        Core.TriggerCallback('Server:GetSaleVehicles', function(cb)
            if cb then
                saleVehicles = cb
                local count = 0
                local usedPositions = {}                   -- Keep track of used positions
                while count < 12 do
                    local randomIndex = math.random(1, #a) -- Get a random index from the 'a' table
                    local b = a[randomIndex]
                    if b and not usedPositions[randomIndex] then
                        local pos = vec3(b.x, b.y, b.z)
                        usedPositions[randomIndex] = true -- Mark the position as used
                        a[randomIndex].occupied = true
                        a[randomIndex].model = saleVehicles[count + 1].model
                        a[randomIndex].name = saleVehicles[count + 1].name
                        a[randomIndex].price = saleVehicles[count + 1].price
                        local vehicle = CreateCar(saleVehicles[count + 1].model, vec3(pos.x, pos.y, pos.z - 1), b.w,
                            false, false, false, "TGAUTO", true)
                        Wait(100)
                        CreateBlip(pos, 'Masina de vanzare', 326, 11)
                        a[randomIndex].id = vehicle
                        SetVehicleDoorsLocked(vehicle, 2)
                        SetVehicleDoorsLockedForAllPlayers(vehicle, true)
                        SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), false)
                        SetVehicleEngineOn(vehicle, false, true, true)
                        SetVehicleUndriveable(vehicle, true)
                        FreezeEntityPosition(vehicle, true)

                        SetVehicleOnGroundProperly(vehicle)

                        count = count + 1
                        a[randomIndex].pos = vector4(b.x, b.y, b.z, b.w)
                        saleVehicles[count].id = vehicle
                    end
                end
            end
        end)
    end
end)


Citizen.CreateThread(function()
    while true do
        local wait = 5000
        local pCoords = GetEntityCoords(PlayerPedId())
        local inRange = false
        for k, v in pairs(a) do
            local dist = #(pCoords - vector3(v.x, v.y, v.z))
            if dist < 10 then
                inRange = true
                if dist < 2 then
                    wait = 1
                    DrawMarker(0, v.x, v.y, v.z + 2, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 0, 255, 0, 100, false, true, 2,
                        false, false, false, false)
                    if v.occupied then
                        DrawText3D(v.x, v.y, v.z, '~w~[~g~' .. v.name ..
                        '~w~]~n~Pret: ~g~' .. FormatNumber(v.price) .. '~w~$', 255, 255, 255, 255)
                        DrawText3D(v.x, v.y, v.z - 0.3, 'Apasa ~g~E~w~ pentru a schimba masina.', 255, 255, 255, 255)
                        if IsControlJustPressed(0, 38) then
                            if not delay then
                                DeleteCar(v.id)
                                local randomIndex = math.random(1, #saleVehicles)
                                local vehicle = saleVehicles[randomIndex]
                                local pos = vec3(v.x, v.y, v.z)
                                local spawnedVehicle = CreateCar(vehicle.model, pos, v.w, false, true, false, "TGAUTO",
                                    true)
                                delay = true
                                a[k].id = spawnedVehicle
                                a[k].pos = vector4(pos.x, pos.y, pos.z, v.w)
                                SetVehicleDoorsLocked(spawnedVehicle, 2)
                                SetVehicleDoorsLockedForAllPlayers(spawnedVehicle, true)
                                SetVehicleDoorsLockedForPlayer(spawnedVehicle, PlayerId(), false)
                                SetVehicleEngineOn(spawnedVehicle, false, true, true)
                                SetVehicleUndriveable(spawnedVehicle, true)
                                FreezeEntityPosition(spawnedVehicle, true)
                                SetVehicleOnGroundProperly(vespawnedVehiclehicle)

                                v.model = vehicle.model
                                v.name = vehicle.name
                                v.price = vehicle.price
                            end
                            --spawn another car random from saleVehicles
                        end
                        DrawText3D(v.x, v.y, v.z - 0.5, 'Apasa ~g~G~w~ pentru a cumpara masina.', 255, 255, 255, 255)

                        -- check for G press
                        if IsControlJustPressed(0, 47) then
                            if not delay then
                                if pData.cash >= v.price then
                                    Core.TriggerCallback('Dealership:GeneratePlate', function(plate)
                                        local vehicle = v.id
                                        local plate = plate
                                        local price = v.price
                                        local model = v.model
                                        local name = v.name
                                        local mods = {}
                                        pData.cash = pData.cash - price
                                        Core.SavePlayer()
                                        Core.TriggerCallback('Dealership:BuyCar', function(cb)
                                            if cb then
                                                sendNotification('Targ Auto', 'Ai cumparat masina cu succes.', 'success')
                                                TriggerServerEvent('Dealership:RemoveSaleVehicle', name, model, price)
                                            else
                                                sendNotification('Targ Auto', 'Nu ai cumparat masina.', 'error')
                                            end
                                        end, { name = name, spawncode = model, plate = plate, mods = mods })
                                    end)
                                else
                                    sendNotification('Targ Auto', 'Nu ai suficienti bani.', 'error')
                                end
                            end
                        end
                    else
                        DrawText3D(v.x, v.y, v.z, '~w~[~g~Targ Auto~w~]~n~~g~Loc liber', 255, 255, 255, 255)
                    end
                end
            end
        end
        Wait(wait)
    end
end)

RegisterCommand('addsalevehicle', function()
    ShowDialog('Adauga masina la targul auto', "Scrie mai jos modelul masinii pe care vrei sa o adaugi.", 'targauto',
        true, false, 'c')
    local event
    event = Core.AddEventHandler('targauto', function(result)
        RemoveEventHandler(event)
        local model = result
        if model then
            ShowDialog('Adauga masina la targul auto', "Scrie mai jos numele masinii pe care vrei sa o adaugi.",
                'targauto', true, false, 'c')
            event = Core.AddEventHandler('targauto', function(result)
                RemoveEventHandler(event)
                local name = result
                if name then
                    ShowDialog('Adauga masina la targul auto', "Scrie mai jos pretul masinii pe care vrei sa o adaugi.",
                        'targauto', true, false, 'c')
                    event = Core.AddEventHandler('targauto', function(result)
                        RemoveEventHandler(event)
                        local price = tonumber(result)
                        if price then
                            Core.TriggerCallback('Server:AddSaleVehicle', function(cb)
                                if cb then
                                    saleVehicles = cb
                                    refreshSaleVehicles({ name = name, model = model, price = price })
                                    sendNotification('Targ Auto', 'Ai adaugat masina la targul auto.', 'success')
                                else
                                    sendNotification('Targ Auto', 'Nu ai adaugat masina la targul auto.', 'error')
                                end
                            end, name, model, price)
                        else
                            sendNotification('Targ Auto', 'Pretul trebuie sa fie un numar.', 'error')
                        end
                    end)
                else
                    sendNotification('Targ Auto', 'Numele masinii trebuie sa fie un text.', 'error')
                end
            end)
        end
    end)
end)
