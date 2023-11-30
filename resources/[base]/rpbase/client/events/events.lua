RegisterNetEvent('Core:Client:TriggerCallback', function(name, ...)
    if Core.ServerCallbacks[name] then
        Core.ServerCallbacks[name](...)
        Core.ServerCallbacks[name] = nil
    end
end)

