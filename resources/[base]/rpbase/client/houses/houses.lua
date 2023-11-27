housesTypes = {
    ['Low'] = {
        shellObject = 'shell_trailer',
        exit = vector3(-1.410, -2.052, -17.09571),
        level = 1,
        type = 'Low',
    },
    ['Medium'] = {
        shellObject = "standardmotel_shell",
        exit = vector3(-0.255, -2.364, -18.99078),
        level = 2,
        type = 'Medium',
    },
    ["Normal"] = {
        shellObject = "furnitured_midapart",
        exit = vector3(1.350, -10.079, -18.94013),
        level = 3,
        type = 'Normal',
    },
}

local housesInfo = false
local closestHouse = nil
local houseBlips = {}
local houseObj = nil
local tosellHouse = nil
local selltoplayerid = 0
local sellprice = 0

CreateShell = function(shell, spawn)
    local model = shell.shellObject
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1000)
    end
    local house = CreateObject(model, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
    return house
end


function FormatNumber(amount)
    amount = tostring(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end



CreateBlip = function(coords, name, icon, color)
    local mapBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(mapBlip, icon)
    SetBlipDisplay(mapBlip, 4)
    SetBlipScale(mapBlip, 0.6)
    SetBlipColour(mapBlip, color)
    SetBlipAsShortRange(mapBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(mapBlip)
    return mapBlip
end

Citizen.CreateThread(function ()
    while true do
        
        local houseWait = 2000
        if housesInfo then
            local pCoords = GetEntityCoords(PlayerPedId())
            for k,v in pairs(housesInfo) do
                local houseData = json.decode(v.data)
                local houseEnter = vec3(houseData.enter.x, houseData.enter.y, houseData.enter.z)
                local houseExit = vec3(houseData.enter.x + houseData.exit.x, houseData.enter.y + houseData.exit.y, houseData.enter.z + houseData.exit.z)

                local distance = #(pCoords - houseEnter)
                local distance2 = #(pCoords - houseExit)
                
                if distance < 3 then
                    houseWait = 1
                    if houseData.owner == 'The State' then
                        houseData.tag = "~w~[~y~"..houseData.owner.."~w~]~n~"
                        DrawText3D(houseEnter.x, houseEnter.y, houseEnter.z, houseData.tag.."~y~"..houseData.name.."~n~~w~Tipul casei: "..houseData.type.."~n~Pret: $"..FormatNumber(houseData.price))
                        DrawText3D(houseEnter.x, houseEnter.y, houseEnter.z - 0.55, '~y~(~w~/buyhouse~y~)')
                        DrawMarker(0, houseEnter.x, houseEnter.y, houseEnter.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 209, 82, 255, true, false, false, true, false, false, false)
                        closestHouse = v
                    else
                        if not houseData.locked then
                            DrawMarker(0, houseEnter.x, houseEnter.y, houseEnter.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 0, 255, 0, 255, true, false, false, true, false, false, false)
                        else
                            DrawMarker(0, houseEnter.x, houseEnter.y, houseEnter.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 0, 0, 255, true, false, false, true, false, false, false)
                        end
                        DrawText3D(houseEnter.x, houseEnter.y, houseEnter.z, "~r~"..houseData.name.."~n~~w~Tipul casei: "..houseData.type.."~n~".."Owner: "..houseData.owner.."".."~n~Rent: $"..FormatNumber(houseData.rent).."~n~Tenants: "..#houseData.tenants.."")
                        closestHouse = v
                    end
                end
                if distance2 < 3 then
                    houseWait = 1
                    if houseData.owner ~= 'The State' or houseData.ownerId ~= 0 then
                        DrawText3D(houseExit.x, houseExit.y, houseExit.z, "Casa lui ~r~"..houseData.owner.."~n~~w~~r~(~w~/exit~r~)")
                    else
                        DrawText3D(houseExit.x, houseExit.y, houseExit.z, "Casa nedetinuta~n~~w~~r~(~w~/exit~r~)")
                    end
                    if not houseData.locked then
                        DrawMarker(0, houseExit.x, houseExit.y, houseExit.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 0, 255, 0, 255, true, false, false, true, false, false, false)
                    else
                        DrawMarker(0, houseExit.x, houseExit.y, houseExit.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 0, 0, 255, true, false, false, true, false, false, false)
                    end
                    closestHouse = v
                end
            end
        end
        Wait(houseWait)

    end
end)

function loadHouses(houses)
    housesInfo = houses
    if not houses == false or not houses == "false" then
        for k,v in pairs(housesInfo) do
            local houseData = json.decode(v.data)
            local houseEnter = vec3(houseData.enter.x, houseData.enter.y, houseData.enter.z)
            if houseData.owner == 'The State' then
                local blip = CreateBlip(houseEnter, "Casa", 40, 2)
                table.insert(houseBlips, {blip = blip})
            else
                local blip = CreateBlip(houseEnter, "Casa", 40, 1)
                table.insert(houseBlips, {blip = blip})
            end
        end
    end
end

RegisterCommand('rent', function ()
    if not closestHouse or closestHouse == nil then
        sendNotification("Eroare", Lang[Language]['NotNearHouse'], "error")
        return
    end

    local hData = json.decode(closestHouse.data)
    Core.TriggerCallback("Houses:IsOwner", function(is)
        if not is then
            Core.TriggerCallback('Houses:IsTenant', function(isTenant)
                --print
                if not isTenant then
                    if PlayerData.rentedHouse == 0 or not PlayerData.rentedHouse then
                        if PlayerData.cash >= hData.rent then
                            PlayerData.cash = PlayerData.cash - hData.rent
                            PlayerData.rentedHouse = closestHouse.id
                            PlayerData.rentValue = hData.rent
                            TriggerServerEvent("Houses:AddTenant", closestHouse)
                            Core.SavePlayer()
                            TriggerServerEvent("Houses:RequireUpdate")
                            sendNotification("Casa", 'Ai devenit chirias la casa cu numarul '..closestHouse.id..' si ai platit $'..FormatNumber(hData.rent)..'!', "success")
                        else
                            sendNotification("Eroare", Lang[Language]['NotEnoughMoney'], "error")
                        end
                    else
                        sendNotification("Eroare", Lang[Language]['AlreadyRentOthers'], "error")
                    end
                end
            end, closestHouse)
        else
            sendNotification("Eroare", Lang[Language]['CantRentOwnHouse'], "error")
        end
        
    end, closestHouse)
    
end)



RegisterCommand('unload', function()
   housesInfo = nil
   for k,v in pairs(houseBlips) do
        RemoveBlip(v.blip)
   end
   houseBlips = {}
end)

function UpdateHouses(houses)
    for k,v in pairs(houseBlips) do
        RemoveBlip(v.blip)
   end
   houseBlips = {}

   housesInfo = houses

   if housesInfo then
    for k,v in pairs(housesInfo) do
        local houseData = json.decode(v.data)
        local houseEnter = vec3(houseData.enter.x, houseData.enter.y, houseData.enter.z)
        if houseData.owner == 'The State' then
            local blip = CreateBlip(houseEnter, "Casa", 40, 2)
            table.insert(houseBlips, {blip = blip})
        else
            local blip = CreateBlip(houseEnter, "Casa", 40, 1)
            table.insert(houseBlips, {blip = blip})
        end
    end
   end
end

RegisterNetEvent("Houses:Update", function()
    Core.TriggerCallback("Houses:Get", function (data)
        UpdateHouses(data)
    end)
end)

RegisterCommand('exit', function()
    if not closestHouse or closestHouse == nil then
        sendNotification("Eroare", Lang[Language]['NotNearHouse'], "error")
        return
    end

    if  PlayerData.inHouseId == 0 then
        sendNotification("Eroare", Lang[Language]['NotInHouse'], "error")
        return
    end

    local hData = json.decode(closestHouse.data)

    if hData.locked then
        sendNotification("Eroare", Lang[Language]['HouseIsLocked'], "error")
        return
    end

    ExitHouse(closestHouse)
end)

RegisterCommand('enter', function()
    if not closestHouse or closestHouse == nil then
        sendNotification("Eroare", Lang[Language]['NotNearHouse'], "error")
        return
    end

    local hData = json.decode(closestHouse.data)

    if  PlayerData.inHouseId ~= 0 then
        sendNotification("Eroare", Lang[Language]['AlreadyInHouse'], "error")
        return
    end
    if hData.locked then
        sendNotification("Eroare", Lang[Language]['HouseIsLocked'], "error")
        return
    end

    EnterHouse(closestHouse)
end)

function EnterHouse(house)

    local houseData = json.decode(house.data)
    local createShellCoords = GetEntityCoords(PlayerPedId())
    --print
    local shellData = CreateShell(housesTypes[houseData.type], vec3(houseData.enter.x, houseData.enter.y, houseData.enter.z - 20.0))

    --print

    local pCoords = GetEntityCoords(PlayerPedId())
    local newCoords = vec3(houseData.enter.x + housesTypes[houseData.type].exit.x, houseData.enter.y + housesTypes[houseData.type].exit.y, houseData.enter.z + housesTypes[houseData.type].exit.z)
    SetEntityCoords(PlayerPedId(), newCoords)

    houseObj = shellData

    PlayerData.inHouseId = house.id
    Core.SavePlayer()
    
    Wait(1000)

    FreezeEntityPosition(PlayerPedId(), false)

end
function ExitHouse(house)
    local houseData = json.decode(house.data)

    local newCoords = vec3(houseData.enter.x, houseData.enter.y, houseData.enter.z)

    local modelHash = GetHashKey(houseData.shell)
    local nearestObject = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, modelHash, false, true, true)
    
    SetEntityCoords(PlayerPedId(), newCoords)

    PlayerData.inHouseId = 0
    Core.SavePlayer()
    DeleteObject(houseObj)
end



Citizen.CreateThread(function()
    while true do
        local closestHouseWait = 2000
        if closestHouse then
            local hData = json.decode(closestHouse.data)
            local pCoords = GetEntityCoords(PlayerPedId())
            local hCoords = vec3(hData.enter.x, hData.enter.y, hData.enter.z)
            closestHouseWait = 1
            local dist = #(pCoords - hCoords)
        
            if dist > 3 then
                closestHouse = false
                closestHouseWait = 2000
            end
        end
        Wait(closestHouseWait)
    end
end)

RegisterCommand('lock', function()
    if not closestHouse or closestHouse == nil then
        sendNotification("Eroare", Lang[Language]['NotNearHouse'], "error")
        return
    end

    local hData = json.decode(closestHouse.data)

    Core.TriggerCallback("Houses:IsOwner", function(isOwner)
        if isOwner then
            if hData.locked then
                hData.locked = false;
                closestHouse.data = json.encode(hData)
                sendNotification("Casa ta", 'Ti-ai descuiat casa.', "success")
                Core.SaveHouse(closestHouse)
            else
                hData.locked = true;
                closestHouse.data = json.encode(hData)
                sendNotification("Casa ta", 'Ti-ai incuiat casa.', "success")
                Core.SaveHouse(closestHouse)
            end
        else
            sendNotification("Casa", 'Nu detii aceasta casa.', "error")
        end
    end, closestHouse)
end)

local cam = nil

RegisterCommand("buyhouse", function ()
    if not closestHouse or closestHouse == nil then
        sendNotification("Eroare", Lang[Language]['NotNearHouse'], "error")
        return
    end
    local hData = json.decode(closestHouse.data)
    local hPrice = hData.price
    local pCoords = GetEntityCoords(PlayerPedId())
    local hCoords = vec3(hData.enter.x, hData.enter.y, hData.enter.z)

    local dist = #(pCoords - hCoords)

    if dist > 4 then
        closestHouse = false
        sendNotification("Eroare", Lang[Language]['NotNearHouse'], "error")
        return
    end

    if not hData.campos then
        sendNotification("Eroare", Lang[Language]['HouseNotComplete'], "error")
        return
    end

    if hData.owner ~= "The State" or hData.ownerId ~= 0 then
        sendNotification("Eroare", Lang[Language]['HouseOwned'], "error")
        return
    end

    if PlayerData.cash < hData.price then
        sendNotification("Eroare", 'Nu ai destui bani.', "error")
        return
    end

    PlayerData.cash = PlayerData.cash - hData.price

    Core.SavePlayer()

    hData.owner = GetPlayerName(PlayerId())

    propertyBought("Ai cumparat aceasta proprietate")
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(cam, true)

    SetCamCoord(cam, hData.campos.x, hData.campos.y, hData.campos.z)
    PointCamAtCoord(cam, hData.enter.x, hData.enter.y, hData.enter.z)

    hData = json.encode(hData)

    RenderScriptCams(1, 0, 0, 1, 1)

    sendNotification("Ai cumparat o proprietate", 'Ai cumparat aceasta proprietate!', "success")
    TriggerServerEvent('Houses:Buy', closestHouse)

    Wait(6000)
    DestroyCam(cam, false)
    SetCamActive(cam, false)
    RenderScriptCams(0, false, 100, false, false)

end)

RegisterNetEvent("Houses:ChangeRentHandle", function(response)
    if tonumber(response) then
        local hData = json.decode(tosellHouse.data)
        hData.rent = tonumber(response)
        tosellHouse.data = json.encode(hData)
        Core.SaveHouse(tosellHouse)
        

        sendNotification("Casa", 'Ai schimbat pretul chiriei!', "success")
        TriggerServerEvent("Houses:RequireUpdate")
        tosellHouse = nil
    else
        sendNotification("Invalid response", 'Ai introdus o valoare invalida.', "error")
    end
end)

RegisterNetEvent("Houses:HandleSellToPlayer", function (response)
    if tonumber(response) then
        response = tonumber(response)
        Core.TriggerCallback("Players:IsOnline", function(isOnline)
            --print
            if isOnline then
                selltoplayerid = response
                ShowDialog('Vinde casa', "Scrie suma cu care vrei sa vinzi casa jucatorului respectiv.", 'Houses:SellToPlayer', true, true, "client")
            else
                sendNotification("Invalid response", 'Jucatorul nu este online.', "error")
            end
        end, response)
    else
        sendNotification("Invalid response", 'Ai introdus o valoare invalida.', "error")
    end
end)

RegisterNetEvent("Houses:SellToPlayer", function(response)
    if tonumber(response) then
        response = tonumber(response)
        sellprice = response

        local sellData = {
            pid = selltoplayerid,
            price = sellprice,
            sellhouse = tosellHouse.id
        }
        Core.TriggerCallback("Houses:SellHouseToPlayer", function(status)
            if status.success then
                sendNotification("Vinde casa", 'Ai vandut casa unui jucator cu sucess.', "success")

                MenuV:CloseAll()
                PlayerData.cash = PlayerData.cash + sellprice
                Core.SavePlayer()

                selltoplayerid = 0
                sellprice = 0
                tosellHouse = false
            else
                sendNotification("Vinde casa", status.msg, "error")
            end
        end, sellData)
    else
        sendNotification("Invalid response", 'Ai introdus o valoare invalida.', "error")
    end
end)

RegisterNetEvent("Houses:HandleCheck", function (response)

    if response:lower() == 'da' then
       
        local hData = json.decode(tosellHouse.data)

        local sell = hData.price /1.4
        sell = math.floor(sell)
        --print
        PlayerData.cash = PlayerData.cash + math.floor(sell)

        Core.SavePlayer()
    
        hData = json.encode(hData)
    
        TriggerServerEvent('Houses:Sell', tosellHouse)
        tosellHouse = false
        sendNotification("Ai vandut casa", 'Ai primit $'..FormatNumber(math.floor(sell))..' din vanzarea casei.', "success")
        return
      
    else
        sendNotification("Eroare", Lang[Language]['InvalidResponse'], "error")
    end
    
end)

RegisterCommand('loadhouses', function()
    Core.TriggerCallback("Houses:Get", function (data)
        loadHouses(data)
    end)
end)

local housesMenu = MenuV:CreateMenu(false, 'Casele tale', 'centerright', 0, 0, 0, 'size-125', 'none', 'menuv', 'houses-menu')
local houseLoadingMenu = MenuV:CreateMenu(false, 'Incarcam casele', 'centerright', 0, 0, 0, 'size-125', 'none', 'menuv', 'house-loading-menu')
local houseMenu = MenuV:CreateMenu(false, 'Casa', 'centerright', 0, 0, 0, 'size-125', 'none', 'menuv', 'house-menu')
local chiriasiMenu = MenuV:CreateMenu(false, 'Chiriasi', 'centerright', 0, 0, 0, 'size-125', 'none', 'menuv', 'renters-menu')
local chiriasMenu = MenuV:CreateMenu(false, 'Chiriasi', 'centerright', 0, 0, 0, 'size-125', 'none', 'menuv', 'renter-menu')
local sellHousemenu = MenuV:CreateMenu(false, 'Vinde casa', 'centerright', 0, 0, 0, 'size-125', 'none', 'menuv', 'sellhouse-menu')

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

RegisterCommand('houses', function()

    housesMenu:ClearItems()
    houseMenu:ClearItems()
    houseLoadingMenu:ClearItems()

    houseLoadingMenu:AddButton({
        label = 'Incarcam casele..',
        disabled = true
    })

    MenuV:OpenMenu(houseLoadingMenu)

    
    
    Wait(300)

    local hasRent = false
    
   

    Core.TriggerCallback('Houses:GetRentedHouse', function (house)
        housesMenu:AddButton({
            label = "Casa la care ai chirie:",
            icon = '',
            disabled = true
        })
        if house then
            hasRent = true
            local hsData = json.decode(house.data)
            
            

            local hbtn = housesMenu:AddButton({
                label = "[RENT]: Casa #"..house.id.." - ["..hsData.location.."]",
                icon = '🏡'
            })

            hbtn:On('select', function ()

                houseMenu:SetSubtitle('Casa #'..house.id.." - ["..hsData.location.."]")

                local cancelRent = houseMenu:AddButton({
                    label = "Anuleaza chiria",
                    icon = '🔴'
                })

                cancelRent:On('select', function ()
                    TriggerServerEvent('Houses:RemoveTenant', house)
                    PlayerData.rentedHouse = 0
                    Core.SavePlayer()
                    MenuV:CloseAll()
                    TriggerServerEvent("Houses:RequireUpdate")

                end)

                local seeTenants = houseMenu:AddButton({
                    label = "Chiriasi",
                    icon = '🙎‍♂️'
                })

                seeTenants:On('select', function ()
                    MenuV:CloseAll()
                    chiriasiMenu:ClearItems()
                    Core.TriggerCallback("Houses:GetHouseTenants", function (tenants)
                        for _,tenant in pairs(tenants) do
                            chiriasiMenu:AddButton({
                                label = ""..tenant.name,
                                icon = "🙍‍♂️"
                            })
                        end
                    end, house)
                    MenuV:OpenMenu(chiriasiMenu)
                end)  

                MenuV:CloseAll()
                MenuV:OpenMenu(houseMenu)
            end)
        else
            housesMenu:AddButton({
                label = "Nu ai chirie la nicio casa.",
                icon = '🏡',
                disabled = true
            })
        end
    end)

   

    Core.TriggerCallback('Houses:GetOwnedByPlayer', function(houses)
        housesMenu:AddButton({
            label = "Case pe care le detii:",
            icon = '',
            disabled = true
        })
        for k,v in pairs(houses) do
            if not houses and not hasRent then
                housesMenu:AddButton({
                    label = "Nu ai case detinute.",
                    icon = '🏡'
                })
                
                return
            end
            local hData = json.decode(v.data)

            local house = housesMenu:AddButton({
                label = "Casa #"..v.id.." - ["..hData.location.."]",
                icon = '🏡'
            })

            house:On('select', function()
                local setCp = houseMenu:AddButton({
                    label = "Seteaza checkpoint",
                    icon = '🔴'
                })

                setCp:On('select', function()
                    --print
                    CreateCP(1, vec3(hData.enter.x, hData.enter.y, hData.enter.z), {255, 0, 0, 255}, 1.0, 25, function()
                    end)
                end)

                local changeRent = houseMenu:AddButton({
                    label = "Schimba pretul chiriei",
                    icon = '🤑'
                })

                changeRent:On("select", function ()
                    tosellHouse = v
                    ShowDialog("Schimba pretul chiriei", "Scrie mai jos pretul pe care vrei sa-l plateasca chiriasii.", "Houses:ChangeRentHandle", true, true, "client")
                    MenuV:CloseAll()
                end)
    
                local sellHouse = houseMenu:AddButton({
                    label = "Vinde casa",
                    icon = '💸'
                })

                sellHouse:On('select', function ()
                    if hData.owner == "The State" or hData.ownerId == 0 then
                        sendNotification("Eroare", Lang[Language]['HouseNotOwned'], "error")
                        return
                    end
                
                    Core.TriggerCallback("Houses:IsOwner", function(isOwner)
                        if isOwner then
                            local sellAmount = hData.price / 1.4
                            tosellHouse = v
                            sellHousemenu:ClearItems()

                            sellHousemenu:AddButton({
                                label = 'Vinde casa la stat',
                                icon = "💸"
                            }):On('select', function ()
                                ShowDialog("Vinzi casa", "Esti sigur ca vrei sa vinzi aceasta casa pentru $"..FormatNumber(math.floor(sellAmount)).."? Scrie DA mai jos daca esti deacord.", "Houses:HandleCheck", true, true, "client")
                            end)

                            sellHousemenu:AddButton({
                                label = 'Vinde casa unui jucator',
                                icon = "🙍‍♂️"
                            }):On('select', function ()
                                tosellHouse = v
                                ShowDialog("Vinzi casa", "Scrie mai jos ID-ul jucatorului caruia vrei sa-i vinzi casa.", "Houses:HandleSellToPlayer", true, true, "client")
                            end)

                            MenuV:CloseAll()
                            MenuV:OpenMenu(sellHousemenu)
                        end
                    end, v)
                end)
    
                local seeTenants = houseMenu:AddButton({
                    label = "Chiriasi",
                    icon = '🙎‍♂️'
                })

                seeTenants:On('select', function ()
                    MenuV:CloseAll()
                    chiriasiMenu:ClearItems()
                    Core.TriggerCallback("Houses:GetHouseTenants", function (tenants)
                        for _,tenant in pairs(tenants) do
                            local chirieMember = chiriasiMenu:AddButton({
                                label = ""..tenant.name,
                                icon = "🙍‍♂️"
                            })

                            chiriasMenu:SetSubtitle("Chirias: "..tenant.name)
                            chirieMember:On('select', function ()
                                MenuV:CloseAll()
                                chiriasMenu:ClearItems()

                                chiriasMenu:AddButton({
                                    label = 'Kick',
                                    icon = '🦶'
                                }):On('select', function ()
                                    MenuV:CloseAll()
                                    TriggerServerEvent("Houses:RemoveTenantById", tenant.tenantId, v.id)
                                end)
                                MenuV:OpenMenu(chiriasMenu)
                            end)
                        end
                            
                    end, v)
                    MenuV:OpenMenu(chiriasiMenu)
                end)           
                
               

                
    
                houseMenu:AddButton({
                    label = 'Upgradeuri casa',
                    disabled = true
                })

                if not hData.upgrades then
                    local remoteLock = houseMenu:AddButton({
                        label = "Incuietoare la distanta ($500.000)",
                        icon = '🔐'
                    })

                    remoteLock:On("select", function()
                        if PlayerData.cash < 500000 then
                            sendNotification("Casa", "Nu ai suficienti bani.", 'error')
                            return
                        end
                        if PlayerData.cash >= 500000 then
                            PlayerData.cash = PlayerData.cash - 500000
                            if not hData.upgrades then
                                hData.upgrades = {}
                            end
                            hData.upgrades.remoteLock = true
                            v.data = json.encode(hData)
                            Core.SaveHouse(v)
                            Core.SavePlayer()
                            sendNotification("Casa", "Ai cumparat un upgrade pentru casa.")
                            MenuV:CloseAll()
                        end
                    end)
                else
                    if hData.upgrades.remoteLock then
                        local lockUnlock = houseMenu:AddButton({
                            label = "Incuie/Descuie casa",
                            icon = '🔒'
                        })

                        lockUnlock:On('select', function ()
                            Core.TriggerCallback("Houses:IsOwner", function(isOwner)
                                if isOwner then
                                    if hData.locked then
                                        hData.locked = false;
                                        v.data = json.encode(hData)
                                        sendNotification("Casa ta", 'Ti-ai descuiat casa.', "success")
                                        Core.SaveHouse(v)
                                    else
                                        hData.locked = true;
                                        v.data = json.encode(hData)
                                        sendNotification("Casa ta", 'Ti-ai incuiat casa.', "success")
                                        Core.SaveHouse(v)
                                    end
                                else
                                    sendNotification("Casa", 'Nu detii aceasta casa.', "error")
                                end
                            end, v)
                        end)
                    end
                end

                
                local upgradeInterior = houseMenu:AddButton({
                    label = "Upgrade interior ($250.000)",
                    icon = '🆙'
                })

                upgradeInterior:On("select", function ()
                    if PlayerData.cash < 250000 then
                        sendNotification("Casa", "Nu ai suficienti bani.", 'error')
                        return
                    end
                    -- print(tablelength(housesTypes), hData.level)
                    if hData.level >= tablelength(housesTypes) then
                        sendNotification("Casa", "Nu mai poti upgrada interiorul.", 'error')
                        return
                    end
                    
                    for k,value in pairs(housesTypes) do
                        if value.level == (hData.level + 1) then
                            hData.shell = value.shellObject
                            hData.level = hData.level + 1
                            hData.exit = value.exit
                            hData.type = value.type
                            v.data = json.encode(hData)
                            Core.SaveHouse(v)
                            Core.SaveHouse(v)
                            sendNotification("Casa", "Ai cumparat un upgrade.", 'success')
                            Wait(500)
                            TriggerServerEvent("Houses:RequireUpdate")

                            return
                        end
                    end
                end)
                

                MenuV:CloseAll()

                houseMenu:SetSubtitle('Casa #'..v.id.." - ["..hData.location.."]")

                MenuV:OpenMenu(houseMenu)
            end)
        end
    end)

    MenuV:CloseAll()

    MenuV:OpenMenu(housesMenu)

end)

RegisterCommand('sethousecam', function(source, args, rawCommand)
    if not HasAccess(7) then
        sendNotification("Eroare", Lang[Language]['NoAccessToCMD'], "error")
        return
    end
    local houseId = tonumber(args[1])

    local coords = GetEntityCoords(PlayerPedId())

    Core.TriggerCallback("Houses:GetHouseById", function(house)
        local hData = json.decode(house.data)

        hData.campos = coords

        house.data = json.encode(hData)

        Core.SaveHouse(house)
        sendNotification("Casa", 'Ai setat coordonatele de camera a casei cu id: '..houseId..'!', "success")
    end, houseId)
end)

RegisterCommand("createhouse", function(source, args, rawCommand)
    if not HasAccess(7) then
        sendNotification("Eroare", Lang[Language]['NoAccessToCMD'], "error")
        return
    end
    
    local house_type = args[1]
    local house_price = tonumber(args[2])
    local shell_data = housesTypes[house_type]
    local pCoords = GetEntityCoords(PlayerPedId())
    local houseData = {
        id = 0,
        name = 'Casa',
        price = house_price,
        level = shell_data.level,
        shell = shell_data.shellObject,
        locked = false,
        type = house_type,
        enter = GetEntityCoords(PlayerPedId()),
        exit = shell_data.exit,
        location = GetNameOfZone(pCoords.x, pCoords.y, pCoords.z).." - "..GetStreetNameFromHashKey(GetStreetNameAtCoord(pCoords.x, pCoords.y, pCoords.z)),
        tenants = {},
        rent = 125000,
        ownerId = 0,
        owner = 'The State'
    }
    sendNotification("Casa", 'Ai creat o casa de tip: '..house_type..' cu pretul de: $'..FormatNumber(house_price)..'!', "success")
    TriggerServerEvent("Houses:Create", houseData)
end)


function CalculateOffset(vector1, vector2)
    local offsetX = vector2.x - vector1.x
    local offsetY = vector2.y - vector1.y
    local offsetZ = vector2.z - vector1.z
    
    return vector3(offsetX, offsetY, offsetZ)
end


RegisterNetEvent('Shell:Create', function(shell)
    local shellExit = housesTypes[shell].exit
    local createShellCoords = GetEntityCoords(PlayerPedId())
    
    --print

    local shellData = CreateShell(housesTypes[shell], vec3(createShellCoords.x, createShellCoords.y, createShellCoords.z - 20.0))
    --to be continued, ai aflat offsetu bun, acuma te descurci cu restu
    -- de creat shell atunci cand intra in casa, maine faci logica la db save si render 3dtext
end)
