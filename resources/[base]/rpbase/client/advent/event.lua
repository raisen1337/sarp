local giftLocations = {
    {x = 2097.52099609375, y = 4688.0439453125, z = 41.057861328125},
    {x = 1788.3428955078126, y = 4659.81103515625, z = 40.87255859375, w = 65.19685363769531},
    {x = 1452.0, y = 4392.75146484375, z = 44.4110107421875, w = 192.75592041015626},
    {x = 2528.808837890625, y = 4476.474609375, z = 37.1318359375, w = 150.23622131347657},
    {x = 1943.89453125, y = 3816.909912109375, z = 32.043212890625, w = 331.6535339355469},
    {x = 1526.927490234375, y = 3698.571533203125, z = 34.5369873046875, w = 289.13385009765627},
    {x = 2900.08349609375, y = 4479.23095703125, z = 48.185302734375, w = 133.22833251953126},
    {x = 748.5889892578125, y = 3567.70556640625, z = 33.2564697265625, w = 11.33858203887939},
    {x = 452.72967529296877, y = 3517.97802734375, z = 33.7449951171875, w = 102.04724884033203},
    {x = 1829.6966552734376, y = 3633.86376953125, z = 34.4022216796875, w = 223.93701171875}
}

local giftLocation = {}
local giftObj = false
local giftBlip = false

collectGift = function()
    local random = math.random(1, #giftLocations)
    giftLocation = giftLocations[random]
    if not PlayerData.giftsCollected then
        PlayerData.giftsCollected = 0
    end

    if PlayerData.giftsCollected + 1 == 30 then
        PlayerData.giftsCollected = 30
        Core.SavePlayer()
        DeleteObject(giftObj)
        giftObj = false
        if DoesBlipExist(giftBlip) then
            RemoveBlip(giftBlip)
        end
        giftBlip = false
        TriggerEvent("chat:addMessage", {
            args = {"^1[Christmas Quest]^0: Ai colectat toate ^1cadourile^0, ti-am setat pe harta locul unde sa le duci!"}
        })

        SendNUIMessage({
            action = 'updateGifts',
            gifts = PlayerData.giftsCollected
        })
        return
    else
        PlayerData.giftsCollected = PlayerData.giftsCollected + 1
        Core.SavePlayer()

        TriggerEvent("chat:addMessage", {
            args = {"^1[Christmas Quest]^0: Ai colectat un ^1cadou^0, ti-am setat pe harta o noua posibila locatie!"}
        })
        DeleteObject(giftObj)
        giftObj = false

        giftObj = Core.CreateObject("vms_gift", vec3(giftLocations[random].x , giftLocations[random].y, giftLocations[random].z - 1), false, true, false)

        giftBlip = AddBlipForCoord(giftLocations[random].x , giftLocations[random].y, giftLocations[random].z)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, 80)
        SetBlipAsShortRange(blip, true)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, 6.0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Zona Cadou")
        EndTextCommandSetBlipName(blip)
        SendNUIMessage({
            action = 'updateGifts',
            gifts = PlayerData.giftsCollected
        })
        return
    end

    
end

local progress = false

Citizen.CreateThread(function ()
    while not LoggedIn do
        Wait(1)
    end
    while true do
        local wait = 3000
        SendNUIMessage({
            action = 'updateGifts',
            gifts = PlayerData.giftsCollected
        })
        if table.empty(giftLocation) then
            local random = math.random(1, #giftLocations)
            giftLocation = giftLocations[random]
            if not giftObj then
                if PlayerData.giftsCollected == 30 then
                    return
                end
                print('da')
                giftObj = Core.CreateObject("vms_gift", vec3(giftLocations[random].x , giftLocations[random].y, giftLocations[random].z - 1), false, true, false)
             
                giftBlip = AddBlipForCoord(giftLocations[random].x , giftLocations[random].y, giftLocations[random].z)
                SetBlipSprite(blip, 1)
                SetBlipColour(blip, 1)
                SetBlipAlpha(blip, 80)
                SetBlipAsShortRange(blip, true)
                SetBlipDisplay(blip, 2)
                SetBlipScale(blip, 6.0)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Zona Cadou")
                EndTextCommandSetBlipName(blip)
            end
        else
            local dist = #(vec3(giftLocation.x, giftLocation.y, giftLocation.z) - GetEntityCoords(PlayerPedId()))
            if dist < 4.0 then
                wait = 1
                if giftBlip then
                    RemoveBlip(giftBlip)
                    giftBlip = false
                end
                DrawText3D(GetEntityCoords(giftObj).x, GetEntityCoords(giftObj).y, GetEntityCoords(giftObj).z, "Apasa ~r~[E]~w~ pentru a deschide cadoul")
                if IsControlJustPressed(0, 38) then
                    if not progress then
                        progress = true
                        Core.ProgressBar(3, 100, true, false, false, true, function()
                            progress = false
                            collectGift()
                        end, function()
                        end)
                    end
                end
            end
        end
        Wait(wait)
    end
end)
