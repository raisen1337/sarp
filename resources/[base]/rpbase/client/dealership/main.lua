local menu1 = MenuV:CreateMenu(false, "Masini personale", "centerright", 0, 0, 0, 'size-150', 'none', 'menuv', 'personal-vehs')
local menu2 = MenuV:CreateMenu(false, "Masina", "centerright", 0, 0, 0, 'size-150', 'none', 'menuv', 'personal-veh')
local menu3 = MenuV:CreateMenu(false, "Masini personale", "centerright", 0, 0, 0, 'size-150', 'none', 'menuv', 'personal-veh-load')

function all_trim(s)
    return s:match("^%s*(.-)%s*$")
end

rainbowveh = false
rainbowplate = false
-- Citizen.CreateThread(function()
--     local function RGBRainbow(frequency)
--         local result = {}
--         local curtime = GetGameTimer() / 1000

--         result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
--         result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
--         result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

--         return result
--     end
--     while true do
--         local rainbow = RGBRainbow(5)
--         Citizen.Wait(0)
--         if rainbowveh then
--             if IsPedInAnyVehicle(PlayerPedId(), true) and GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId())) == rainbowplate then
--                 veh = GetVehiclePedIsUsing(PlayerPedId())
--                 SetVehicleCustomPrimaryColour(veh, rainbow.r, rainbow.g, rainbow.b)
--                 SetVehicleCustomSecondaryColour(veh, rainbow.r, rainbow.g, rainbow.b)
--             else
--                 rainbowveh = false
--             end
--         end
--     end
-- end)

RegisterCommand('v', function()
    Core.TriggerCallback('Player:GetVehicles', function(vehicles)
        if not vehicles then
            sendNotification("Meniu vehicule", "Nu ai masini personale", "error")
            return
        end
        menu1:ClearItems()
        menu3:ClearItems()

        menu3:AddButton({
            label = "Se incarca masinile..",
            icon = '',
            value = "",
            description = ""
        })

        MenuV:OpenMenu(menu3)
        
        for k, v in pairs(vehicles) do

            local personalCar = menu1:AddButton({
                label = v.name,
                icon = '🚗',
                value = "",
                description = ""
            })

            personalCar:On("select", function()
                menu2:ClearItems()
                local vData = json.decode(v.data)

                menu2:SetSubtitle('' .. v.name .. ' - (' .. vData.plate .. ')')
                local spawnCar = menu2:AddButton({
                    label = 'Spawneaza masina',
                    icon = '🚗',
                    value = "",
                    description = ""
                })

                local teleportCar = menu2:AddButton({
                    label = 'Spawneaza masina la tine',
                    icon = '🎉',
                    value = "",
                    description = ""
                })

                local parkCar = menu2:AddButton({
                    label = 'Parcheaza masina',
                    icon = '🅿',
                    value = "",
                    description = ""
                })

                local fixCar = menu2:AddButton({
                    label = 'Fix Car (daca nu se spawneaza)',
                    icon = '🔧',
                    value = "",
                    description = ""
                })

                menu2:AddButton({
                    label = "Vehicle Upgrades",
                    value = "",
                    description = "",
                    disabled = true
                })

                local upgradeCar = menu2:AddButton({
                    label = 'Upgradeaza la VIP (300PP)',
                    icon = '💸',
                    value = "",
                    description = ""
                })

                local rainbowCar = menu2:AddButton({
                    label = 'Upgradeaza la Rainbow (300PP)',
                    icon = '🌈',
                    value = "",
                    description = ""
                })

                local changePlate = menu2:AddButton({
                    label = 'Schimba numar inmatriculare (100PP)',
                    icon = '📃',
                    value = "",
                    description = ""
                })

               
                MenuV:OpenMenu(menu2)

                fixCar:On("select", function()
                    for k,v in pairs(GetVehicles()) do
                        if not DoesEntityExist(v.localId) then
                            DeleteCar(v.localId)
                            table.remove(ClientVehicles, k)
                            sendNotification("Masini personale", "Masina a fost rezolvata!", 'success')
                        end
                    end
                end)

                rainbowCar:On('select', function()
                    if vData.addons.rainbow then 
                        sendNotification("Masini personale", "Masina are deja acest upgrade!", 'error')
                        return
                    end
                    if PlayerData.premiumPoints >= 300 then
                        PlayerData.premiumPoints = PlayerData.premiumPoints - 300
                        Core.SavePlayer()
                        vData.addons.rainbow = true
                        TriggerServerEvent("Vehicles:Save", vData)
                        sendNotification("Masini personale", "Ai cumparat Rainbow pentru masina "..v.name.."("..vData.plate..") si ai platit 300PP!", 'success')
                        MenuV:CloseAll()
                    else
                        sendNotification("Masini personale", "Nu ai suficiente puncte premium!", 'error')
                    end
                end)

                upgradeCar:On('select', function()
                    if vData.addons.vip then 
                        sendNotification("Masini personale", "Masina are deja acest upgrade!", 'error')
                        return
                    end
                    if PlayerData.premiumPoints >= 300 then
                        PlayerData.premiumPoints = PlayerData.premiumPoints - 300
                        Core.SavePlayer()
                        vData.addons.vip = true
                        TriggerServerEvent("Vehicles:Save", vData)
                        sendNotification("Masini personale", "Ai cumparat VIP pentru masina "..v.name.."("..vData.plate..") si ai platit 300PP!", 'success')
                        MenuV:CloseAll()
                    else
                        sendNotification("Masini personale", "Nu ai suficiente puncte premium!", 'error')
                    end
                end)

                changePlate:On('select', function()
                    if PlayerData.premiumPoints >= 100 then
                        
                        ShowDialog('Schimba numar inmatriculare', "Scrie mai jos noul numarul de inmatriculare al masinii: "..v.name..":", "Vehicle:ChangePlate", true, false, 'client')
                        local event
                        event = Core.AddEventHandler("Vehicle:ChangePlate", function(plate)
                            if string.len(plate) > 7 then
                                sendNotification("Masini personale", "Numarul poate avea maxim 6 caractere!", 'error')
                                RemoveEventHandler(event)
                                return
                            end
                            Core.TriggerCallback("Plates:Check", function(exist)
                                if exist >= 1 then 
                                    sendNotification("Masini personale", "Exista deja o masina cu acest numar de inmatriculare", 'error')
                                    RemoveEventHandler(event)
                                    return
                                end
                                if exist == 0 then
                                    if IsPedInAnyVehicle(PlayerPedId()) then
                                        local vehicle = GetVehiclePedIsUsing(PlayerPedId())
                                        if GetVehicleNumberPlateText(vehicle) == vData.plate then
                                            TriggerServerEvent("Vehicles:ChangePlate", v.plate, plate)
                                            v.plate = plate
                                            SetVehicleNumberPlateText(vehicle, plate)
                                            PlayerData.premiumPoints = PlayerData.premiumPoints - 100
                                            Core.SavePlayer()
                                            sendNotification("Masini personale", "Ai schimbat numarul masinii "..v.name.." la: "..plate.." pentru 100PP!", 'success')
                                            MenuV:CloseAll()
                                            RemoveEventHandler(event)
                                            return
                                        end 
                                    else
                                        TriggerServerEvent("Vehicles:ChangePlate", v.plate, plate)
                                        v.plate = plate
                                        PlayerData.premiumPoints = PlayerData.premiumPoints - 100
                                        Core.SavePlayer()
                                        sendNotification("Masini personale", "Ai schimbat numarul masinii "..v.name.." la: "..plate.." pentru 100PP!", 'success')
                                        MenuV:CloseAll()
                                        RemoveEventHandler(event)
                                        return
                                    end
                                end
                            end, plate)
                            
                        end)
                    else
                        sendNotification("Masini personale", "Nu ai suficiente puncte premium!", 'error')
                    end
                end)
                

                spawnCar:On("select", function()
                    local found = false
                    local vehicles = GetAllVehicles()
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        sendNotification("Masini personale", "Nu poti spawna masina daca esti deja in una.", 'error')
                        return
                    end
                    for k,v in pairs(vehicles) do
                        if DoesEntityExist(v) then
                            if GetVehicleNumberPlateText(v) then
                                if all_trim(GetVehicleNumberPlateText(v)) == vData.plate then
                                    found = true
                                end  
                            end
                        end
                        
                    end

                    if found then
                        sendNotification("Masini personale", "Masina este deja spawna.", 'error')
                        return
                    else
                        if vData.pos then
                            local veh = CreateCar(vData.spawncode, vData.pos, vData.pos.h, true, true, false, vData.plate)
                            Core.TriggerCallback("Core:GetVehicleMods", function(mods)
                                if mods then
                                    Core.SetVehicleProperties(veh, mods)
                                end
                            end, vData.plate)
                            sendNotification("Masini personale", "Masina a fost spawnata.", 'success')

                            local cp = CreateCP(1, vData.pos, {255, 0, 0, 255}, 5.0, 20.0, false)
                            --chat message
                            TriggerEvent("chat:addMessage", {
                                args = {"^b[Masini personale]^0", "Masina "..v.name.."^b("..vData.plate..")^0 a fost spawnata! Un ^bcheckpoint^0 ti-a fost setat."}
                            })

                            return
                        else
                            local pCoords = GetEntityCoords(PlayerPedId())
                            local veh = CreateCar(vData.spawncode, pCoords, 0, true, true, true, vData.plate)
                            Core.TriggerCallback("Core:GetVehicleMods", function(mods)
                                if mods then
                                    Core.SetVehicleProperties(veh, mods)
                                end
                            end, vData.plate)
                            TriggerEvent("chat:addMessage", {
                                args = {"^b[Masini personale]^0", "Masina "..v.name.."^b("..vData.plate..")^0 a fost spawnata! Parcheaz-o ^bundeva^0!."}
                            })
                        end
                    end
                    
                end)

                teleportCar:On("select", function()
                    if not vData.addons.vip then
                        sendNotification("Masini personale", "Aceasta masina nu este upgradata la VIP.", 'error')
                        return
                    end

                    if IsPedInAnyVehicle(PlayerPedId()) then
                        sendNotification("Masini personale", "Nu poti teleporta masina la tine daca esti deja in una.",
                            'error')
                        return
                    end

                  
           
                    local sVehs = GetAllVehicles()
                    local found = false

                    for k,v in pairs(sVehs) do
                        if GetVehicleNumberPlateText(v) then
                            if all_trim(GetVehicleNumberPlateText(v)) == vData.plate then
                                found = true
                            end
                        end
                        if found then
                            local pos = GetEntityCoords(v)
                            SetEntityCoords(v, GetEntityCoords(PlayerPedId()))
                            TaskWarpPedIntoVehicle(PlayerPedId(), v, -1)
                            sendNotification("Masini personale", "Masina a fost teleportata la tine.", 'success')
                            return
                        end
                    end

                    if not found then
                        --create vehicle at player coords
                       
                        local veh = CreateCar(vData.spawncode, GetEntityCoords(PlayerPedId()), 0, true, true, true, vData.plate)
                        Core.TriggerCallback("Core:GetVehicleMods", function(mods)
                            if mods then
                                Core.SetVehicleProperties(veh, mods)
                            end
                        end, vData.plate)
                    end
                end)

                parkCar:On("select", function()
                    if not IsPedInAnyVehicle(PlayerPedId()) then
                        sendNotification("Masini personale", "Nu esti in nicio masina.", 'error')
                        return
                    end


                    if IsPedInAnyVehicle(PlayerPedId()) then
                        if all_trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId()))) == all_trim(v.plate) then
                            vData.pos = {x = 0, y = 0, z = 0, h = 0}
                            vData.pos.x = GetEntityCoords(GetVehiclePedIsUsing(PlayerPedId())).x
                            vData.pos.y = GetEntityCoords(GetVehiclePedIsUsing(PlayerPedId())).y
                            vData.pos.z = GetEntityCoords(GetVehiclePedIsUsing(PlayerPedId())).z
                            vData.pos.h = GetEntityHeading(GetVehiclePedIsIn(PlayerPedId()))
                            TriggerServerEvent("Vehicles:Save", vData)
                            MenuV:CloseAll()
                            Core.DeleteAllCps()
                            rainbowveh = false
                            DeleteCar(GetVehiclePedIsUsing(PlayerPedId()))
                            return
                        else
                            sendNotification("Masini personale", "Aceasta masina nu-ti apartine sau nu este aceea pe care vrei sa o parchezi.", 'error')
                            return
                        end
                    end
                end)
            end)
        end

        MenuV:CloseAll()

        MenuV:OpenMenu(menu1)
    end)
end)
