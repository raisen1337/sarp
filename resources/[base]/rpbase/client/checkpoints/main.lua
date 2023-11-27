checkpoints = {}

DeleteCP = function(cp)
    if not table.empty(checkpoints) then
        for k,v in pairs(checkpoints) do
            if v.id == cp.id then
                RemoveBlip(v.blip)
                table.remove(checkpoints, k)
                return
            end
        end
    end
end

DoesCPExist = function(cp)
    if not table.empty(checkpoints) then
        for k,v in pairs(checkpoints) do
            if v.id == cp.id then
                return true
            end
        end
    end
    return false
end

ModifyCP = function(cp, type, coords, color, radius, visible)
    if not table.empty(checkpoints) then
        for k,v in pairs(checkpoints) do
            if v.id == cp.id then
                v.type = type
                v.coords = coords
                v.color = color
                v.radius = radius
                v.visible = visible
                SetBlipCoords(v.blip, coords)
                return
            end
        end
    end
end

Core.HasCheckpoint = function(cb)
    if not table.empty(checkpoints) then
        cb(true)
    else
        cb(false)
    end
end

Core.GetActiveCheckpoint = function()
    if not table.empty(checkpoints) then
        return checkpoints[1]
    end
    return nil
end

Core.DeleteAllCps = function()
    if not table.empty(checkpoints) then
        for k,v in pairs(checkpoints) do
            RemoveBlip(v.blip)
            table.remove(checkpoints, k)
        end
    end
end

CreateCP = function(type, coords1, color, radius, visible, callback)
    if not table.empty(checkpoints) then
        for k,v in pairs(checkpoints) do
            local dist = #(v.coords - coords1)
            if dist < 1.0 then
                return
            end
        end
    end
    local blip = CreateBlip(coords1, "Destinatie", 1, 1)
    SetBlipAsShortRange(blip, false)
    local cp = {id= #checkpoints + 1, type = type, coords = coords1, color = color, visible = visible, radius = radius, callback = callback, blip = blip}
    table.insert(checkpoints, {id = #checkpoints + 1, type = type, coords = coords1, color = color, visible = visible, radius = radius, callback = callback, blip = blip})
    return cp
end

Citizen.CreateThread(function ()
    while true do
        local wait = 5000
        
        if not table.empty(checkpoints) then
            for k,v in pairs(checkpoints) do
                local pCoords = GetEntityCoords(PlayerPedId())
                local dist = #(pCoords - vec3(v.coords.x, v.coords.y, v.coords.z))
                if dist <= v.visible then
                    wait = 1
                    DrawMarker(v.type, v.coords.x, v.coords.y, v.coords.z - 1.2, 0, 0, 0, 0, 0, 0, v.radius, v.radius, v.radius, v.color[1], v.color[2], v.color[3], v.color[4], false, false, false, false, false, false, false)
                    if dist <= .5 then
                        if v.callback then
                            v.callback()
                        end
                        RemoveBlip(v.blip)
                        table.remove(checkpoints, k)
                        wait = 5000
                    end
                end
            end
        end
        Wait(wait)
    end
end)

Citizen.CreateThread(function ()
    while true do
        local wait = 3005
        local closestCheckpoint = nil
        local closestDistance = -1
        
        if not table.empty(checkpoints) then
            for k, v in pairs(checkpoints) do
                local pCoords = GetEntityCoords(PlayerPedId())
                local dist = #(pCoords - vec3(v.coords.x, v.coords.y, v.coords.z))
                
                if closestCheckpoint == nil or dist < closestDistance then
                    closestCheckpoint = v
                    closestDistance = dist
                end
            end
            
            if closestCheckpoint ~= nil then
                showSubtitle('Distance: ^3'..closestDistance, 5000, true)
            end
        end
        
        Wait(wait)
    end
end)
