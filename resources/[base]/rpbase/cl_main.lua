Core = {}

Core.ServerCallbacks = {}
PlayerData = {}

ClientVehicles = false

AddEventHandler('onClientMapStart', function()
  setAutoSpawn(true)
  forceRespawn()
end)

function Core.GetPlayerData()
  if not PlayerData or table.empty(PlayerData) then
    Core.TriggerCallback("Player:GetData", function(data)
      PlayerData = data
      return data
    end)
  end
  return PlayerData
end

RegisterNetEvent("Player:UpdateData", function()
  Core.GetPlayerData()
end)

function Core.SavePlayer()
  PlayerData = PlayerData
  if PlayerData.user == nil then return end
  TriggerServerEvent("Player:Save", json.encode(PlayerData))
  Wait(500)
  Core.UpdateAmmo(Core.GetPlayerAmmo())
end

function Core.SaveHouse(house)
  TriggerServerEvent('Houses:Save', house)
end

function Core.TriggerCallback(name, cb, ...)
  Core.ServerCallbacks[name] = cb
  TriggerServerEvent('Core:Server:TriggerCallback', name, ...)
end

function SendChatMessage(message)
  TriggerEvent('chatMessage', "", {255, 255, 255}, message)
end

exports('InitCore', function()
  return Core
end)

local entityEnumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end

    local enum = { handle = iter, destructor = disposeFunc }
    setmetatable(enum, entityEnumerator)

    local next = true
    repeat
      coroutine.yield(id)
      next, id = moveFunc(iter)
    until not next

    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function EnumerateObjects()
  return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
  return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
  return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

RegisterNetEvent('Vehicles:Update', function(vehicles)
  if not ClientVehicles then
    ClientVehicles = vehicles
  else
    ClientVehicles = vehicles
  end
end)

function GetVehicles()
  if not ClientVehicles then
    local a = false
    return a
  end
  return ClientVehicles
end

function CreateCar(model, coords, heading, isnet, tsc, putin, plate)
  local x = coords.x
  local y = coords.y
  local z = coords.z
  local vehiclehash = GetHashKey(model)
  RequestModel(vehiclehash)




  local waiting = 0
  while not HasModelLoaded(vehiclehash) do
    waiting = waiting + 100
    Citizen.Wait(100)
    if waiting > 5000 then
      sendNotification("Masina indisponibila", "Nu am putut incarca masina.", 'error')
      break
    end
  end

  local veh = CreateVehicle(vehiclehash, x, y, z, heading, isnet, tsc)
  if plate then
    SetVehicleNumberPlateText(veh, plate)
  end
  if putin then
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
  end
  local netID = NetworkGetNetworkIdFromEntity(veh)

  SetNetworkIdExistsOnAllMachines(netID, true)


  if not ClientVehicles then
    ClientVehicles = {}
    table.insert(ClientVehicles, {netID = netID, localId = veh})
  else
    table.insert(ClientVehicles, {netID = netID, localId = veh})
  end

  TriggerServerEvent("Vehicles:Insert", {netID = netID, localId = veh})

  return veh
end

function GetAllVehicles()
  local ret = {}
  for veh in EnumerateVehicles() do
    table.insert(ret, veh)
  end
  return ret
end

AddEventHandler('onClientResourceStop', function(resourceName)
  Core.TriggerCallback("AC:ReportAnomaly", function()
  end, 'rstop')
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
 
end)

local syncedAmmo = false

function isVehicleRegistered(veh)
  local found = false
  if not ClientVehicles then
    found = false
    return found
  end
  if table.empty(ClientVehicles) then
    found = false
    return found
  end
  for k, v in pairs(ClientVehicles) do
    if v.netID == NetworkGetNetworkIdFromEntity(veh) then
      found = true
      break
    end
  end
  return found
end

Citizen.CreateThread(function()
  while true do
      Wait(500)
      vehs = GetAllVehicles()
      for k,v in pairs(vehs) do
          if DoesEntityExist(v) then
              if not isVehicleRegistered(v) then
                  if IsPedInVehicle(PlayerPedId(), v) then
                    Core.TriggerCallback('AC:ReportAnomaly', function()
                    end, 'vehicle')
                  end
                  DeleteCar(v)
              end
          end
      end
      local unarmed = GetHashKey('WEAPON_UNARMED')
      if GetSelectedPedWeapon(PlayerPedId()) ~= unarmed then
        if not PlayerData then
          PlayerData = Core.GetPlayerData()
        end
          if PlayerData and not table.empty(PlayerData) then
            
            if table.empty(PlayerData.inventory) then
              if GetSelectedPedWeapon(PlayerPedId()) ~= unarmed then
                Core.TriggerCallback('AC:ReportAnomaly', function()
                end, 'weapon')
                RemoveAllPedWeapons(PlayerPedId(), true)
              end
            else
              local gunFound = false
              for k, v in pairs(PlayerData.inventory) do
                  local currentgun = GetSelectedPedWeapon(PlayerPedId())
                  local invgun = GetHashKey(v.name)
                  
                  if currentgun == invgun then
                    gunFound = true
                    -- local weaponAmmo = GetAmmoInPedWeapon(PlayerPedId(), currentgun)
                    -- local Inventory = PlayerData.inventory
                    -- local playerAmmo = Core.GetPlayerAmmo()
                    
                    -- local ammoDifference = 10 -- Define the allowable ammo difference
                    
                    -- for a, b in pairs(playerAmmo) do
                       
                    --     if weaponAmmo ~= b and (b > weaponAmmo + ammoDifference or b < weaponAmmo - ammoDifference) then
                    --         -- Perform actions when the difference in ammo is greater than the defined threshold
                    --         Core.TriggerCallback('AC:ReportAnomaly', function()
                    --         end, 'ammo')
                    --         RemoveAllPedWeapons(PlayerPedId(), true)
                    --         Inventory = PlayerData.inventory
                    --         playerAmmo = Core.GetPlayerAmmo()
                    --         for k, v in pairs(Inventory) do
                    --             if v.type == 'weapon' then
                    --                 for a, b in pairs(playerAmmo) do
                    --                     if checkWeaponPresence(v.name, a) then
                    --                         GiveWeaponToPed(PlayerPedId(), GetHashKey(v.name), b, false, false)
                    --                     end
                    --                 end
                    --             end
                    --         end
                    --     else
                    --         -- If the difference is within the threshold, update and synchronize the ammo
                    --         syncedAmmo = true
                    --         Core.UpdateAmmo(Core.GetPlayerAmmo())
                    --     end
                    -- end
                    break  -- Exit the loop since a match is found
                end
                
              end

              if not gunFound then
                  Core.TriggerCallback('AC:ReportAnomaly', function()
                  end, 'weapon')
                  RemoveAllPedWeapons(PlayerPedId(), true)

                  local Inventory = PlayerData.inventory
                  local playerAmmo = Core.GetPlayerAmmo()
                  
                  for k,v in pairs(Inventory) do
                      if v.type == 'weapon' then
                    
                          for a, b in pairs(playerAmmo) do
                              GiveWeaponToPed(PlayerPedId(), GetHashKey(v.name), 0, false, false)
                              if checkWeaponPresence(v.name, a) then
                                  SetPedAmmo(PlayerPedId(), GetHashKey(v.name), b)
                              end
                          end
                      end
                  end
              end
            end
          end
      end
  end
end)

local PlayerAmmo = {}

AddEventHandler('CEventGunShot', function()
  local weapon = GetSelectedPedWeapon(PlayerPedId())
  local ammoType = GetPedAmmoTypeFromWeapon(PlayerPedId(), weapon)
  local ammo = GetPedAmmoByType(PlayerPedId(), ammoType)
  local ammoTypes = {
    [1950175060] = 'pistol_ammo',
    [218444191] = 'rifle_ammo',
    [1820140472] = 'smg_ammo',
    [1285032059] = 'rifle_ammo',
    [-1878508229] = 'shotgun_ammo',
  }
  local ammoName = ammoTypes[ammoType]

  if ammoName then
    if not PlayerAmmo[ammoName] then
      PlayerAmmo[ammoName] = ammo
    end

    if PlayerAmmo[ammoName] then
      PlayerAmmo[ammoName] = ammo
    end
  end
end)

function Core.GetPlayerAmmo()
    local pAmmo = {}
    local callbackCompleted = false

    Core.TriggerCallback('Core:GetPlayerAmmo', function(cb)
        pAmmo = cb
        callbackCompleted = true
    end)

    while not callbackCompleted do
        Citizen.Wait(0) -- Yield execution to other scripts
    end

    return pAmmo
end

local canRun = true
local waitg = 5000
local amountSaved = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(waitg)
        local selectedWeapon = GetSelectedPedWeapon(PlayerPedId())
        if selectedWeapon == -1569615261 and canRun then
          ----print
            if amountSaved < 5 then
                amountSaved = amountSaved + 1
            end


            if amountSaved + 1 == 5 then
                amountSaved = 3
                ----print
                Wait(5000)
                amountSaved = 0
            end

            ----print
            canRun = false
            if PlayerAmmo and not table.empty(PlayerAmmo) then
              Core.UpdateAmmo(PlayerAmmo)
            else
              PlayerAmmo = Core.GetPlayerAmmo()
              Core.UpdateAmmo(Core.GetPlayerAmmo())
            end
            waitg = 1
        elseif selectedWeapon ~= -1569615261 and not canRun then
            ----print
            canRun = true
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3 * 60 * 1000)
        if PlayerAmmo and not table.empty(PlayerAmmo) then
          Core.UpdateAmmo(PlayerAmmo)
        else
          PlayerAmmo = Core.GetPlayerAmmo()
          Core.UpdateAmmo(Core.GetPlayerAmmo())
        end
    end
end)

function Core.UpdateAmmo(ammo)
    Core.TriggerCallback('Core:UpdatePlayerAmmo', function(cb)
        PlayerAmmo = cb
    end, ammo)
end

function IsPlayerConnected(id)
  local isConnected = false
  Core.TriggerCallback('Core:IsOnline', function(cb)
    isConnected = cb
  end, id)
  Wait(500)
  return isConnected
end

DeleteCar = function(car)
  if not ClientVehicles then
    while DoesEntityExist(car) == 1 do
      Wait(1)
      DeleteEntity(car)
    end
  end
  if not ClientVehicles then
    while DoesEntityExist(car) == 1 do
      Wait(1)
      DeleteEntity(car)
    end
  else
    if table.empty(ClientVehicles) then
      while DoesEntityExist(car) == 1 do
        Wait(1)
        DeleteEntity(car)
      end
    else
      for k, v in pairs(ClientVehicles) do
        if v == car then
          DeleteVehicle(car)
          table.remove(ClientVehicles, k)
          TriggerServerEvent('Vehicles:Remove', k)
        else
          DeleteVehicle(car)
        end
      end
    end
  end
  
end

