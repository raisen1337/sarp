checkpoints = {}

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
    print('Cp created with type: '..type..' and colors: '..json.encode(color)..'!')
    
    table.insert(checkpoints, {type = type, coords = coords1, color = color, visible = visible, radius = radius, callback = callback, blip = blip})
    return
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
                        sendNotification('Destinatie', "Ai ajuns la destinatie", 'success')
                        wait = 5000
                    end
                end
            end
        end
        Wait(wait)
    end
end)