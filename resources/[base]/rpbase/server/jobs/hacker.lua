hackDelayPlayers = {}

Core.CreateCallback('Hacker:CanHack', function(source, cb)
    local src = source
    for k, v in pairs(hackDelayPlayers) do
        if v.src == src then
            cb(false)
            return
        end
    end
    cb(true)
end)

Core.CreateCallback('Hacker:Limit', function(source, cb)
    for k, v in pairs(hackDelayPlayers) do
        if v.src == source then
            table.remove(hackDelayPlayers, k)
        end
    end
    table.insert(hackDelayPlayers, { src = source, hackedAt = os.time() })
end)

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        for k, v in pairs(hackDelayPlayers) do
            if v.hackedAt + (10 * 60) < os.time() then
                table.remove(hackDelayPlayers, k)
            end
        end
    end
end)
