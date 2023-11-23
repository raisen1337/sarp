RegisterNetEvent('showSubtitle', function (msg, time, sound)
    showSubtitle(msg, time, sound)
end)

showSubtitle = function(msg, time, sound)
    print(sound)
    SendNUIMessage({
        action = 'showSubtitle',
        msg = msg,
        time = time,
        disablesound = sound
    })
end