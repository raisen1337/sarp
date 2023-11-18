Core = {}

Core.ServerCallbacks = {}
PlayerData = {}

ClientVehicles = false

AddEventHandler('onClientMapStart', function()
  setAutoSpawn(true)
  forceRespawn()
end)

function Core.GetPlayerData()
  if #PlayerData == 0 or PlayerData == nil or PlayerData == {} then
    Core.TriggerCallback("Player:GetData", function(result)
      PlayerData = result
    end)
  else
    return PlayerData
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
  ClientVehicles = vehicles
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

  if not ClientVehicles then
    ClientVehicles = {}
  end
  table.insert(ClientVehicles, veh)

  TriggerServerEvent("Vehicles:Insert", veh)

  return veh
end

DeleteCar = function(car)
  if not ClientVehicles then
    while DoesEntityExist(car) == 1 do
      Wait(1)
      DeleteEntity(car)
    end
  end
  if table.empty(ClientVehicles) then
    while DoesEntityExist(car) == 1 do
      Wait(1)
      DeleteEntity(car)
    end
  end
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

