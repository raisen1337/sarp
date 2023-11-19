local bizBlips = {}
local bizInfo = {}
local closestBiz = false

LoadBusinesses = function()
    Core.TriggerCallback("Business:LoadAll", function(cb)
        bizInfo = cb
        if not table.empty(bizInfo) then
            for k, v in pairs(bizInfo) do
                local bizData = json.decode(v.data)
                if bizData.owner == 'The State' then
                    local blip = CreateBlip(bizData.coords, bizData.name, bizData.blip, 0)
                    table.insert(bizBlips, {blip = blip})
                else
                    local blip = CreateBlip(bizData.coords, bizData.name, bizData.blip, 0)
                    table.insert(bizBlips, {blip = blip})
                end
            end
        end
    end)
end

UnloadBusinesses = function()
    bizInfo = nil
    for k,v in pairs(bizBlips) do
        RemoveBlip(v.blip)
    end
    bizBlips = {}
end

RegisterNetEvent('Business:Update', function ()
    --print
    bizInfo = nil
    for k,v in pairs(bizBlips) do
        RemoveBlip(v.blip)
    end
    bizBlips = {}

    Core.TriggerCallback("Business:LoadAll", function(cb)
        bizInfo = cb
        for k, v in pairs(bizInfo) do
            local bizData = json.decode(v.data)
            if bizData.owner == 0 then
                local blip = CreateBlip(bizData.coords, bizData.name, bizData.blip, 0)
                table.insert(bizBlips, {blip = blip})
            else
                local blip = CreateBlip(bizData.coords, bizData.name, bizData.blip, 0)
                table.insert(bizBlips, {blip = blip})
            end
        end
    end)
end)

UpdateBusinesses = function()

    bizInfo = nil
    for k,v in pairs(bizBlips) do
        RemoveBlip(v.blip)
    end
    bizBlips = {}

    Core.TriggerCallback("Business:LoadAll", function(cb)
        bizInfo = cb
        for k, v in pairs(bizInfo) do
            local bizData = json.decode(v.data)
            if bizData.owner == 0 then
                local blip = CreateBlip(bizData.coords, bizData.name, bizData.blip, 0)
                table.insert(bizBlips, {blip = blip})
            else
                local blip = CreateBlip(bizData.coords, bizData.name, bizData.blip, 0)
                table.insert(bizBlips, {blip = blip})
            end
        end
    end)
end
Citizen.CreateThread(function()
    while true do
        local closestHouseWait = 2000
        if closestBiz then
            local bizData = jd(closestBiz.data)
            local pCoords = GetPlayerCoords()
            local bizCoords = vec3(bizData.coords.x, bizData.coords.y, bizData.coords.z)
            closestHouseWait = 1
            local dist = #(pCoords - bizCoords)
        
            if dist > 7 then
                closestBiz = false
                closestHouseWait = 2000
                TriggerEvent("Business:NearBiz", false)
            else
                TriggerEvent("Business:NearBiz", closestBiz)
            end
        end
        Wait(closestHouseWait)
    end
end)
Citizen.CreateThread(function()
    while true do 
        local bizWait = 2000
        if bizInfo then
            local pCoords = GetPlayerCoords()
            for k,v in pairs(bizInfo) do
                local bizData = jd(v.data)
                local bizCoords = vec3(bizData.coords.x, bizData.coords.y, bizData.coords.z)
                local dist = #(pCoords - bizCoords)
                if dist < 3.0 then
                    bizWait = 1
                    closestBiz = v
                    if bizData.owner == 0 then
                        DrawText3D(bizData.coords.x, bizData.coords.y, bizData.coords.z, "~y~[~w~"..bizData.name.."~y~]~w~~n~Owner:~y~ "..bizData.ownerName.."~w~~n~Pret: ~y~$"..FormatNumber(bizData.price).."~n~~w~~y~[~w~/buybiz~y~]")
                    else
                        DrawText3D(bizData.coords.x, bizData.coords.y, bizData.coords.z, "~y~[~w~"..bizData.name.."~y~]~w~~n~Owner:~y~ "..bizData.ownerName.."~w~")
                    end
                    DrawMarker(29, bizData.coords.x, bizData.coords.y, bizData.coords.z, 0, 0, 0, 0, 0, 0, 0.9, 0.9, 0.9, 255, 209, 82, 255, true, false, false, true, false, false, false)
                end
            end
        end
        Wait(bizWait)
    end
end)


 


-- TriggerScreenblurFadeIn(1)

Citizen.CreateThread(function()
    while true do 
        local bizWait = 2000
        if closestBiz then
            local pCoords = GetPlayerCoords()
            local bizData = jd(closestBiz.data)
            local bizCoords = vec3(bizData.coords.x, bizData.coords.y, bizData.coords.z)
            local dist = #(pCoords - bizCoords)
            if dist < 3.0 then
                TriggerEvent("Jobs:ClosestMarket", closestBiz)
            end
        end
        Wait(bizWait)
    end
end)

RegisterCommand('createbiz', function(source, args, rawCommand)
    local coords = GetPlayerCoords()

    if not HasAccess(7) then
        sendNotification("Eroare", Lang[Language]['NoAccessToCMD'])
        return
    end
    local businessData = {
        name = args[1],
        price = tonumber(args[2]),
        safe = 0,
        income = tonumber(args[2])/10,
        owner = 0,
        ownerName = 'The State',
        type = tonumber(args[3]),
        coords = coords,
        blip = tonumber(args[4])
    }

    Core.TriggerCallback("Business:Create", function(cb)
        if cb then
            sendNotification('Afacere', Lang[Language]['BusinessCreated'])
            TriggerServerEvent('Business:RequireUpdate')
        else
            sendNotification('Afacere', Lang[Language]['BusinessCreateFail'])
        end
    end, businessData)
end, false)

RegisterCommand("loadbiz", function(source, args, rawCommand)
    LoadBusinesses()
end)
RegisterCommand("unloadbiz", function(source, args, rawCommand)
    UnloadBusinesses()
end)

