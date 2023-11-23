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

Core.SetVehicleProperties = function(vehicle, data)


	if (data == nil) then return end

	SetVehicleModKit(vehicle, 0)
	SetVehicleAutoRepairDisabled(vehicle, false)

	if (data.plateIndex) then
		SetVehicleNumberPlateTextIndex(vehicle, data.plateIndex)
	end

	if (data.fuelLevel) then
		SetVehicleFuelLevel(vehicle, data.fuelLevel + 0.0)
	end

	if (data.dirtLevel) then
		SetVehicleDirtLevel(vehicle, data.dirtLevel + 0.0)
	end
  print(data.color1, data.color2)

	if (data.color1) then
    SetVehicleCustomPrimaryColour(vehicle, data.color1, data.color2, data.color3)
	end

	if (data.color1Custom) then
		SetVehicleCustomPrimaryColour(vehicle, data.color1Custom[1], data.color1Custom[2], data.color1Custom[3])
	end

	if (data.color2) then
		ClearVehicleCustomSecondaryColour(vehicle)

		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, data.color1, data.color2)
	end

	if (data.color2Custom) then
		SetVehicleCustomSecondaryColour(vehicle, data.color2Custom[1], data.color2Custom[2], data.color2Custom[3])
	end

	if (data.color1Type) then
		SetVehicleModColor_1(vehicle, data.color1Type)
	end

	if (data.color2Type) then
		SetVehicleModColor_2(vehicle, data.color2Type)
	end

	if (data.pearlescentColor) then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, data.pearlescentColor, wheelColor)
	end

	if (data.wheelColor) then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, pearlescentColor, data.wheelColor)
	end

	if (data.wheels) then
		SetVehicleWheelType(vehicle, data.wheels)
	end


	if (data.windowTint) then
		SetVehicleWindowTint(vehicle, data.windowTint)
	end

	if (data.extras) then
		for id = 0, 25 do
			if (DoesExtraExist(vehicle, id)) then
				SetVehicleExtra(vehicle, id, data.extras[tostring(id)] and 0 or 1)
			end
		end
	end

	if (data.neonEnabled) then
		SetVehicleNeonLightEnabled(vehicle, 0, data.neonEnabled[1] == true or data.neonEnabled[1] == 1)
		SetVehicleNeonLightEnabled(vehicle, 1, data.neonEnabled[2] == true or data.neonEnabled[2] == 1)
		SetVehicleNeonLightEnabled(vehicle, 2, data.neonEnabled[3] == true or data.neonEnabled[3] == 1)
		SetVehicleNeonLightEnabled(vehicle, 3, data.neonEnabled[4] == true or data.neonEnabled[4] == 1)
	end

	if (data.neonColor) then
		SetVehicleNeonLightsColour(vehicle, data.neonColor[1], data.neonColor[2], data.neonColor[3])
	end

	if (data.modSmokeEnabled) then
		ToggleVehicleMod(vehicle, 20, true)
	end

	if (data.tyreSmokeColor) then
		SetVehicleTyreSmokeColor(vehicle, data.tyreSmokeColor[1], data.tyreSmokeColor[2], data.tyreSmokeColor[3])
	end

	if (data.dashboardColor) then
		SetVehicleDashboardColour(vehicle, data.dashboardColor)
	end

	if (data.interiorColor) then
		SetVehicleInteriorColour(vehicle, data.interiorColor)
	end

	if (data.modSpoilers) then
		SetVehicleMod(vehicle, 0, data.modSpoilers, false)
	end

	if (data.modFrontBumper) then
		SetVehicleMod(vehicle, 1, data.modFrontBumper, false)
	end

	if (data.modRearBumper) then
		SetVehicleMod(vehicle, 2, data.modRearBumper, false)
	end

	if (data.modSideSkirt) then
		SetVehicleMod(vehicle, 3, data.modSideSkirt, false)
	end

	if (data.modExhaust) then
		SetVehicleMod(vehicle, 4, data.modExhaust, false)
	end

	if (data.modFrame) then
		SetVehicleMod(vehicle, 5, data.modFrame, false)
	end

	if (data.modGrille) then
		SetVehicleMod(vehicle, 6, data.modGrille, false)
	end

	if (data.modHood) then
		SetVehicleMod(vehicle, 7, data.modHood, false)
	end

	if (data.modFender) then
		SetVehicleMod(vehicle, 8, data.modFender, false)
	end

	if (data.modRightFender) then
		SetVehicleMod(vehicle, 9, data.modRightFender, false)
	end

	if (data.modRoof) then
		SetVehicleMod(vehicle, 10, data.modRoof, false)
	end

	if (data.modEngine) then
		SetVehicleMod(vehicle, 11, data.modEngine, false)
	end

	if (data.modBrakes) then
		SetVehicleMod(vehicle, 12, data.modBrakes, false)
	end

	if (data.modTransmission) then
		SetVehicleMod(vehicle, 13, data.modTransmission, false)
	end

	if (data.modHorns) then
		SetVehicleMod(vehicle, 14, data.modHorns, false)
	end

	if (data.modSuspension) then
		SetVehicleMod(vehicle, 15, data.modSuspension, false)
	end

	if (data.modArmor) then
		SetVehicleMod(vehicle, 16, data.modArmor, false)
	end

	if (data.modTurbo) then
		ToggleVehicleMod(vehicle,  18, data.modTurbo)
	end

	if (data.modXenon) then
		ToggleVehicleMod(vehicle, 22, true)
		SetVehicleXenonLightsColour(vehicle, data.modXenon)
	end

	if (data.modFrontWheels) then
		SetVehicleMod(vehicle, 23, data.modFrontWheels, false)
	end

	if (data.modBackWheels) then
		SetVehicleMod(vehicle, 24, data.modBackWheels, false)
	end

	if (data.modPlateHolder) then
		SetVehicleMod(vehicle, 25, data.modPlateHolder, false)
	end

	if (data.modVanityPlate) then
		SetVehicleMod(vehicle, 26, data.modVanityPlate, false)
	end

	if (data.modTrimA) then
		SetVehicleMod(vehicle, 27, data.modTrimA, false)
	end

	if (data.modOrnaments) then
		SetVehicleMod(vehicle, 28, data.modOrnaments, false)
	end

	if (data.modDashboard) then
		SetVehicleMod(vehicle, 29, data.modDashboard, false)
	end

	if (data.modDial) then
		SetVehicleMod(vehicle, 30, data.modDial, false)
	end

	if (data.modDoorSpeaker) then
		SetVehicleMod(vehicle, 31, data.modDoorSpeaker, false)
	end

	if (data.modSeats) then
		SetVehicleMod(vehicle, 32, data.modSeats, false)
	end

	if (data.modSteeringWheel) then
		SetVehicleMod(vehicle, 33, data.modSteeringWheel, false)
	end

	if (data.modShifterLeavers) then
		SetVehicleMod(vehicle, 34, data.modShifterLeavers, false)
	end

	if (data.modAPlate) then
		SetVehicleMod(vehicle, 35, data.modAPlate, false)
	end

	if (data.modSpeakers) then
		SetVehicleMod(vehicle, 36, data.modSpeakers, false)
	end

	if (data.modTrunk) then
		SetVehicleMod(vehicle, 37, data.modTrunk, false)
	end

	if (data.modHydrolic) then
		SetVehicleMod(vehicle, 38, data.modHydrolic, false)
	end

	if (data.modEngineBlock) then
		SetVehicleMod(vehicle, 39, data.modEngineBlock, false)
	end

	if (data.modAirFilter) then
		SetVehicleMod(vehicle, 40, data.modAirFilter, false)
	end

	if (data.modStruts) then
		SetVehicleMod(vehicle, 41, data.modStruts, false)
	end

	if (data.modArchCover) then
		SetVehicleMod(vehicle, 42, data.modArchCover, false)
	end

	if (data.modAerials) then
		SetVehicleMod(vehicle, 43, data.modAerials, false)
	end

	if (data.modTrimB) then
		SetVehicleMod(vehicle, 44, data.modTrimB, false)
	end

	if (data.modTank) then
		SetVehicleMod(vehicle, 45, data.modTank, false)
	end

	if (data.modWindows) then
		SetVehicleMod(vehicle, 46, data.modWindows, false)
	end

	if (data.modLivery) then
		SetVehicleMod(vehicle, 48, data.modLivery, false)
	end

	if (data.livery) then
		SetVehicleLivery(vehicle, data.livery)
	end
end

function Core.MathTrim(str)
  return (str:gsub("^%s*(.-)%s*$", "%1"))
end

function Core.MathRound(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

Core.GetVehicleProperties = function(vehicle)
  local color1, color2, color3 = GetVehicleCustomPrimaryColour(vehicle)
  print(color1, color2, color3)
  print(GetVehicleColor(vehicle))
  print(GetVehicleColours(vehicle))
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	local extras = {}

	for id=0, 12 do
		if DoesExtraExist(vehicle, id) then
			local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
			extras[tostring(id)] = state
		end
	end

	return {
		model             = GetEntityModel(vehicle),

		plate             = Core.MathTrim(GetVehicleNumberPlateText(vehicle)),
		plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

		bodyHealth        = Core.MathRound(GetVehicleBodyHealth(vehicle), 1),
		engineHealth      = Core.MathRound(GetVehicleEngineHealth(vehicle), 1),

		fuelLevel         = Core.MathRound(GetVehicleFuelLevel(vehicle), 1),
		dirtLevel         = Core.MathRound(GetVehicleDirtLevel(vehicle), 1),
		color1            = color1,
		color2            = color2,
    color3            = color3,

		pearlescentColor  = pearlescentColor,
		wheelColor        = wheelColor,

		wheels            = GetVehicleWheelType(vehicle),
		windowTint        = GetVehicleWindowTint(vehicle),

		neonEnabled       = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},

		extras            = extras,

		neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
		tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

		modSpoilers       = GetVehicleMod(vehicle, 0),
		modFrontBumper    = GetVehicleMod(vehicle, 1),
		modRearBumper     = GetVehicleMod(vehicle, 2),
		modSideSkirt      = GetVehicleMod(vehicle, 3),
		modExhaust        = GetVehicleMod(vehicle, 4),
		modFrame          = GetVehicleMod(vehicle, 5),
		modGrille         = GetVehicleMod(vehicle, 6),
		modHood           = GetVehicleMod(vehicle, 7),
		modFender         = GetVehicleMod(vehicle, 8),
		modRightFender    = GetVehicleMod(vehicle, 9),
		modRoof           = GetVehicleMod(vehicle, 10),

		modEngine         = GetVehicleMod(vehicle, 11),
		modBrakes         = GetVehicleMod(vehicle, 12),
		modTransmission   = GetVehicleMod(vehicle, 13),
		modHorns          = GetVehicleMod(vehicle, 14),
		modSuspension     = GetVehicleMod(vehicle, 15),
		modArmor          = GetVehicleMod(vehicle, 16),

		modTurbo          = IsToggleModOn(vehicle, 18),
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),
		modXenon          = IsToggleModOn(vehicle, 22),

		modFrontWheels    = GetVehicleMod(vehicle, 23),
		modBackWheels     = GetVehicleMod(vehicle, 24),

		modPlateHolder    = GetVehicleMod(vehicle, 25),
		modVanityPlate    = GetVehicleMod(vehicle, 26),
		modTrimA          = GetVehicleMod(vehicle, 27),
		modOrnaments      = GetVehicleMod(vehicle, 28),
		modDashboard      = GetVehicleMod(vehicle, 29),
		modDial           = GetVehicleMod(vehicle, 30),
		modDoorSpeaker    = GetVehicleMod(vehicle, 31),
		modSeats          = GetVehicleMod(vehicle, 32),
		modSteeringWheel  = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate         = GetVehicleMod(vehicle, 35),
		modSpeakers       = GetVehicleMod(vehicle, 36),
		modTrunk          = GetVehicleMod(vehicle, 37),
		modHydrolic       = GetVehicleMod(vehicle, 38),
		modEngineBlock    = GetVehicleMod(vehicle, 39),
		modAirFilter      = GetVehicleMod(vehicle, 40),
		modStruts         = GetVehicleMod(vehicle, 41),
		modArchCover      = GetVehicleMod(vehicle, 42),
		modAerials        = GetVehicleMod(vehicle, 43),
		modTrimB          = GetVehicleMod(vehicle, 44),
		modTank           = GetVehicleMod(vehicle, 45),
		modWindows        = GetVehicleMod(vehicle, 46),
		modLivery         = GetVehicleLivery(vehicle)
	}
end


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
  Core.TriggerCallback('Core:GetVehicleMods', function(mods)
    if mods then
      Core.SetVehicleProperties(veh, mods)
    end
  end, plate)
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

Core.GetObjects = function()
	local objects = {}

	for object in EnumerateObjects() do
		table.insert(objects, object)
	end

	return objects
end

Core.RegisterFunction = function(delay, callback)
  while true do
    callback()
    Citizen.Wait(delay)
  end
end

Core.GetClosestObject = function(coords, radius, filter)
	local objects         = Core.GetObjects()
	local closestDistance = -1
	local closestObject   = -1
	local filter          = filter
	local coords          = coords

	if type(filter) == 'string' then
		if filter ~= '' then
			filter = {filter}
		end
	end

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #objects, 1 do
		local foundObject = false

		if filter == nil or (type(filter) == 'table' and #filter == 0) then
			foundObject = true
		else
			local objectModel = GetEntityModel(objects[i])

			for j=1, #filter, 1 do
				if objectModel == GetHashKey(filter[j]) then
					foundObject = true
				end
			end
		end

		if foundObject then
			local objectCoords = GetEntityCoords(objects[i])
			local distance     = GetDistanceBetweenCoords(objectCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > radius then
				closestObject   = objects[i]
				closestDistance = distance
			end
		end
	end

	return closestObject, closestDistance
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
      Wait(2000)
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
local delayanno = false

local await = 60000

Citizen.CreateThread(function ()
	while true do
		Wait(await)
		if delayanno then
			await = 60000
			delayanno = false
		else
			await = 3005
		end
	end
end)

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
  
  local pCoords = GetEntityCoords(PlayerPedId())
  local streetName, crossingRoad = GetStreetNameAtCoord(pCoords.x, pCoords.y, pCoords.z)
  local streetName = GetStreetNameFromHashKey(streetName)
  local crossingRoad = GetStreetNameFromHashKey(crossingRoad)
  local blip = false
  if not delayanno then
	Core.TriggerCallback('Police:AnnounceShooting', function(cb)
		if cb then
			delayanno = true
			blip = CreateBlip(pCoords, "Shots area", 161, 1)
			SetBlipScale(blip, 2.0)
			SetTimeout(60000, function ()
				RemoveBlip(blip)
				Wait(1000)
				blip = false
			end)
		end
	  end, streetName, crossingRoad)
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
		waitg = 5000
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
        Citizen.Wait(waitg)

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
        if v.localId == car then
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

