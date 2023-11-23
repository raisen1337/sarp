Factions = {}
LoadFactions = function()
    Core.TriggerCallback('Factions:GetFactions', function(data)
        Factions = data
        for k,v in pairs(Factions) do
            CreateBlip(v.coords.main, v.blipName, v.blip, v.blipColor)
           
            if v.coords.helicopter then
                CreateBlip(v.coords.helicopter, 'Helicopter - '..v.name, 64, v.blipColor)
            end
            if v.coords.vehicleArea then
                CreateBlip(v.coords.vehicleArea, 'Garaj - '..v.name, 357, v.blipColor)
            end
            if v.coords.armory then
                CreateBlip(v.coords.armory, 'Armory - '..v.name, 150, v.blipColor)
            end
          
        end
    end)
end

Wait(2000)
LoadFactions()




local canSpawnVehicle = false

local currentCar = false

local canSpawnHeli = false

local canAccessArmory = false

local factionsMenu = MenuV:CreateMenu(false, "Meniu Factiune", "center", 255, 0, 0, 'size-150', 'none', 'menuv', 'factions-main')
local factionMembers = MenuV:CreateMenu(false, "Membrii", "center", 255, 0, 0, 'size-150', 'none', 'menuv', 'factions-members')
local factionMember = MenuV:CreateMenu(false, "Detalii", "center", 255, 0, 0, 'size-150', 'none', 'menuv', 'factions-member')
local factionVehicle = MenuV:CreateMenu(false, "Vehicul", "center", 255, 0, 0, 'size-150', 'none', 'menuv', 'factions-vehicle')

local factionArmorySubmenu = MenuV:CreateMenu(false, "Armory", "center", 255, 0, 0, 'size-150', 'none', 'menuv', 'factions-armory-submenu')
local factionArmoryMenu = MenuV:CreateMenu(false, "Armory", "center", 255, 0, 0, 'size-150', 'none', 'menuv', 'factions-armory')
local factionVehicles = MenuV:CreateMenu(false, "Vehicule", "center", 255, 0, 0, 'size-150', 'none', 'menuv', 'factions-vehicles')

local playerFaction = {}

RegisterCommand('faction', function()
    if not table.empty(Factions) then
        local pData = Core.GetPlayerData()
        local fData = pData.faction

        if fData.id ~= 0 then
            factionsMenu:ClearItems()
            for k,v in pairs(Factions) do
                if fData.id == v.id then
                    playerFaction = v
                    
                    factionsMenu:AddButton({
                        label = v.name,
                        icon = '💼',
                        disabled = true,
                        value = 'faction',
                    })
                    factionsMenu:AddButton({
                        label = "Numele tau: "..pData.user,
                        icon = '👤',
                        disabled = true,
                    })
                    factionsMenu:AddButton({
                        label = "Rankul tau: "..fData.rankName.." ("..fData.rank..")",
                        icon = '💼',
                        disabled = true,
                    })
                    factionsMenu:AddButton({
                        label = "Salariul tau: "..FormatNumber(Factions[fData.name].ranks[fData.rank].salary).."$",
                        icon = '💵',
                        disabled = true,
                    })
                    factionsMenu:AddButton({
                        label = "Optiuni",
                        icon = '',
                        disabled = true,
                    })

                    if canSpawnVehicle then
                        factionsMenu:AddButton({
                            label = 'Vehicule',
                            icon = '🚗',
                            value = 'vehicles',
                        }):On('select', function()
                            factionVehicles:ClearItems()
                            for k,v in pairs(playerFaction.vehicles) do
                                if fData.rank >= v.rank then
                                    if v.type == 'car' then
                                        factionVehicles:AddButton({
                                            label = v.name,
                                            icon = '🚗',
                                            value = 0,
                                        }):On('select', function()
                                            MenuV:CloseAll()
                                            if currentCar then
                                                if DoesEntityExist(currentCar) then
                                                    DeleteEntity(currentCar)
                                                    Wait(1500)
                                                end
                                            end
                                            currentCar = CreateCar(v.model, PlayerCoords(), GetEntityHeading(PlayerPedId()), true, true, true, 'PD'..math.random(1000, 9999))
                                        end)
                                    end
                                   
                                end
                            end
                            MenuV:OpenMenu(factionVehicles)
                        end)
                    end

                    if canSpawnHeli then
                        
                        factionsMenu:AddButton({
                            label = 'Helicopter',
                            icon = '🚁',
                            value = 'helicopters',
                        }):On('select', function()
                            factionVehicles:ClearItems()
                            for k,v in pairs(playerFaction.vehicles) do
                                if fData.rank >= v.rank then
                                    if v.type == 'heli' then
                                        factionVehicles:AddButton({
                                            label = v.name,
                                            icon = '🚁',
                                            value = 0,
                                        }):On('select', function()
                                            MenuV:CloseAll()
                                            if currentCar then
                                                DeleteEntity(currentCar)
                                                Wait(1500)
                                            end
                                            currentCar = CreateCar(v.model, PlayerCoords(), playerFaction.coords.helicopter.w, true, true, true, 'PD'..math.random(1000, 9999))
                                        end)
                                        MenuV:OpenMenu(factionVehicles)
                                    end
                                end
                            end
                        end)
                    end
                    

                    if canAccessArmory then
                        factionArmorySubmenu:ClearItems()

                        factionsMenu:AddButton({
                            label = 'Armory',
                            icon = '🔧',
                            value = 'armory',
                        }):On('select', function()
                            factionArmorySubmenu:ClearItems()
                            factionArmoryMenu:ClearItems()
                            for k,v in pairs(playerFaction.armory) do
                                if fData.rank >= v.rank then
                                    factionArmorySubmenu:ClearItems()

                                    factionArmoryMenu:AddButton({
                                        label = v.name,
                                        icon = '🔧',
                                        value = 0,
                                    }):On('select', function()
                                        factionArmorySubmenu:ClearItems()
                                        factionArmorySubmenu:AddButton({
                                            label = 'Nume: '..v.name,
                                            icon = '📃',
                                            disabled = true,
                                        })
                                        if v.name == 'Armour' then
                                            factionArmorySubmenu:AddButton({
                                                label = 'Cost: $'..FormatNumber(v.ammoCost)..'',
                                                icon = '💰',
                                                disabled = true,
                                            })
                                        elseif v.name == 'Medkit' then
                                            factionArmorySubmenu:AddButton({
                                                label = 'Cost: $'..FormatNumber(v.ammoCost)..'',
                                                icon = '💰',
                                                disabled = true,
                                            })
                                        else
                                            factionArmorySubmenu:AddButton({
                                                label = 'Cost munitie: $'..FormatNumber(v.ammoCost)..'/glont',
                                                icon = '💰',
                                                disabled = true,
                                            })
                                        end
                                       
                                        factionArmorySubmenu:AddButton({
                                            label = 'Optiuni',
                                            icon = '',
                                            disabled = true,
                                        })
                                        if v.name == 'Armour' then
                                            factionArmorySubmenu:AddButton({
                                                label = 'Cumpara armura',
                                                icon = '🛡'
                                            })
                                        elseif v.name == 'Medkit' then
                                            factionArmorySubmenu:AddButton({
                                                label = 'Cumpara Medkit',
                                                icon = '💉',
                                            })
                                        else
                                            factionArmorySubmenu:AddButton({
                                                label = 'Cumpara arma',
                                                icon = '💸',
                                            }):On('select', function()
                                                MenuV:CloseAll()
                                                --print
                                                --print
                                                if pData.cash >= v.weaponCost then
                                                    pData.cash = pData.cash - v.weaponCost
                                                    Core.TriggerCallback('Player:AddItem', function(cb)
                                                        
                                                        GiveWeaponToPed(PlayerPedId(), GetHashKey(v.model), 1, false, false)
                                                        --print
                                                       
                                                    end, v.model, 1)
                                                    Core.TriggerCallback('Player:Pay', function (cb)
                                                                
                                                    end, 'cash', v.weaponCost)
                                                    return
                                                else
                                                    sendNotification('Eroare', 'Nu ai destui bani', 'error')
                                                end
                                            end)
                                            factionArmorySubmenu:AddButton({
                                                label = 'Cumpara munitie',
                                                icon = '💸',
                                            }):On('select', function()
                                                MenuV:CloseAll()
                                                --print
                                                
                                                ShowDialog('Cumpara munitie', 'Scrie mai jos cata munitie ai nevoie! (Ex: 150).', 'buyammo', true, false, 'c')
                                                local event;
                                                event = AddEventHandler('buyammo', function(ammo)
                                                    RemoveEventHandler(event)
                                                    if tonumber(ammo) then
                                                        if pData.cash >= tonumber(ammo) * v.ammoCost then
                                                            pData.cash = pData.cash - tonumber(ammo) * v.ammoCost
                                                            ammo = tonumber(ammo)
                                            
                                                            Core.TriggerCallback('Player:AddItem', function(cb)
                                                                --print
                                                               
                                                                AddAmmoToPed(PlayerPedId(), GetHashKey(v.model), ammo)
                                                                --print
                                                              
                                                            end, v.ammoName, ammo)
                                                            Core.TriggerCallback('Player:Pay', function (cb)

                                                            end, 'cash', tonumber(ammo) * v.ammoCost)
                                                          
                                                            
                                                            return
                                                        else
                                                            sendNotification('Armory', 'Nu ai destui bani.', 'error')
                                                            --print
                                                        end
                                                    end
                                                end)
                                            end)
                                        end
                                        MenuV:OpenMenu(factionArmorySubmenu)
                                    end)
                                end
                            end
                            MenuV:OpenMenu(factionArmoryMenu)
                        end)
                    end
                    if fData.rank == 3 then
                        factionsMenu:AddButton({
                            label = 'Membrii',
                            icon = '👥',
                            value = 'members',
                            description = "",
                        }):On('select', function()
                            factionMembers:ClearItems()
                            Core.TriggerCallback('Factions:GetFactionMembers', function(data)
                                for _,user in pairs(data) do
                                    factionMembers:AddButton({
                                        label = user.name,
                                        icon = '🙍‍♂️',
                                        value = 0,
                                    }):On('select', function()
                                        factionMember:ClearItems()
                                        factionMember:AddButton({
                                            label = 'Nume: '..user.name,
                                            icon = '👤',
                                            disabled = true,
                                            value = 0,
                                        })
                                        factionMember:AddButton({
                                            label = 'Rank: '..user.rankName..' ('..user.rank..')',
                                            icon = '💼',
                                            disabled = true,
                                        })
                                        factionMember:AddButton({
                                            label = 'Salariu: '..FormatNumber(user.salary)..'$',
                                            icon = '💵',
                                            disabled = true,
                                        })
                                        factionMember:AddButton({
                                            label = 'Optiuni',
                                            icon = '',
                                            disabled = true,
                                        })
                                        if fData.rank == 3 then
                                            factionMember:AddButton({
                                                label = 'Promoveaza',
                                                icon = '📝',
                                                value = 'promote',
                                                description = "",
                                            }):On('select', function()
                                                Core.TriggerCallback('Factions:PromoteMember', function(cb)
                                                    if cb then
                                                        MenuV:CloseAll()
                                                        sendNotification('Factiune', 'L-ai promovat pe: '..user.name..'!', 'success')
                                                    end
                                                end, user.identifier)
                                            end)
                                            factionMember:AddButton({
                                                label = 'Degradeaza',
                                                icon = '📝',
                                                value = 'demote',
                                                description = "",
                                            }):On('select', function ()
                                                Core.TriggerCallback('Factions:DemoteMember', function(cb)
                                                    if cb then
                                                        MenuV:CloseAll()
                                                        sendNotification('Factiune', 'L-ai degradat pe: '..user.name..'!', 'success')
                                                    end
                                                end, user.identifier)
                                            end)
                                            factionMember:AddButton({
                                                label = 'Kick',
                                                icon = '🚫',
                                            }):On('select', function ()
                                                Core.TriggerCallback('Factions:KickMember', function(cb)
                                                    if cb then
                                                        MenuV:CloseAll()
                                                        sendNotification('Factiune', 'L-ai dat afara pe: '..user.name..'!', 'success')
                                                    end
                                                end, user.identifier)
                                            end)
                                        end
                                        MenuV:OpenMenu(factionMember)
                                    end)
                                end
                            end, v.id)
                            MenuV:OpenMenu(factionMembers)
                        end)
                    end
                    
                    MenuV:OpenMenu(factionsMenu)
                end
            end
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
        wait = 5000
        
        local pData = Core.GetPlayerData()
        local fData = pData.faction
     
        if not table.empty(Factions) then
            for k,v in pairs(Factions) do
                if fData.id == v.id then
                    coords = v.coords
                    local dist = {}
                    local pCoords = PlayerCoords()
                    dist[1] = #(pCoords - vec3(coords.vehicleArea.x, coords.vehicleArea.y, coords.vehicleArea.z))
                    if dist[1] < 15.0 then
                        wait = 1
                        DrawText3D(coords.vehicleArea.x, coords.vehicleArea.y, coords.vehicleArea.z, "Vehicle Area - 15m radius.")
                        DrawMarker(1, coords.vehicleArea.x, coords.vehicleArea.y, coords.vehicleArea.z - 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 15.0, 15.0, 1.0, 255, 255, 255, 50, false, true, 2, false, false, false, false)
                        canSpawnVehicle = true
                    else
                        canSpawnVehicle = false
                    end
                    
                    if coords.helicopter then
                        dist[2] = #(pCoords - vec3(coords.helicopter.x, coords.helicopter.y, coords.helicopter.z))
                        if dist[2] < 2.0 then
                            wait = 1
                            DrawText3D(coords.helicopter.x, coords.helicopter.y, coords.helicopter.z, "Helicopter")
                            DrawMarker(1, coords.helicopter.x, coords.helicopter.y, coords.helicopter.z - 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
                            canSpawnHeli = true
                        else
                            canSpawnHeli = false
                        end
                    end
                    
                    if coords.armory then
                        dist[3] = #(pCoords - vec3(coords.armory.x, coords.armory.y, coords.armory.z))
                        if dist[3] < 10.0 then
                            wait = 1
                            DrawText3D(coords.armory.x, coords.armory.y, coords.armory.z, "Armory")
                            canAccessArmory = true
                        else
                            canAccessArmory = false
                        end
                    end
                end
            end
        end
        Wait(wait)
    end
end)