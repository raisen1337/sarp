RegisterNetEvent('showSubtitle', function (msg, time)
    showSubtitle(msg, time)
end)

showSubtitle = function(msg, time)
    SendNUIMessage({
        action = 'showSubtitle',
        msg = msg,
        time = time,
    })
end