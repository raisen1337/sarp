RegisterCommand('advent', function ()
    Core.TriggerCallback('Advent:GetGifts', function(gifts)
        if not gifts then return end
        SendNUIMessage({
            action = 'showAdvent',
            gifts = gifts
        })
        SetNuiFocus(true, true)
    end)
end)

RegisterNUICallback('openGift', function (data)
    local gift = data.giftId

    Core.TriggerCallback('Advent:OpenGift', function (cb)
   
        if cb.cash or cb.premiumPoints then
            if cb.cash then
                PlayerData.cash = PlayerData.cash + cb.cash
            else
                cb.cash = 0
            end
            if cb.premiumPoints then
                PlayerData.premiumPoints = PlayerData.premiumPoints + cb.premiumPoints
            else
                cb.premiumPoints = 0
            end
            Core.SavePlayer()
 
            TriggerEvent('chat:addMessage', {
                args = {"[^1Advent Calendar^0]: Ai primit ^1"..FormatNumber(cb.cash).."$^0 si ^1"..FormatNumber(cb.premiumPoints).." puncte premium^0."}
            })
            return
        end
        if not cb.cash and not cb.premiumPoints then
            local spawncode = cb.spawncode
            local model = cb.model
            Core.TriggerCallback('Dealership:GeneratePlate', function(plate)
                local vehicle = v.id
                local plate = plate
                local price = 0
                local model = spawncode
                local name = model
                local mods = {}
                pData.cash = pData.cash - price
                Core.SavePlayer()
                Core.TriggerCallback('Dealership:BuyCar', function(cb)
                    if cb then
                        --chatmsg
                        TriggerEvent('chat:addMessage', {
                            args = {"[^1Advent Calendar^0]: Ai primit masina ^1"..model.."^0."}
                        })
                    else
                        sendNotification('Targ Auto', 'Nu ai cumparat masina.', 'error')
                    end
                end, {name = name, spawncode = model, plate = plate, mods = mods})
            end)
        end
    end, gift)
end)

RegisterNUICallback('closeAdvent', function ()
    SetNuiFocus(false, false)
end)