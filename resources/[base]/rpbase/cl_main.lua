Core = {}

Core.ServerCallbacks = {}
PlayerData = {}

ClientVehicles = false

AddEventHandler('onClientMapStart', function()
	setAutoSpawn(true)
	forceRespawn()
end)

local eventHandlers = {}

Core.AddEventHandler = function(eventName, cb)
	local event = AddEventHandler(eventName, cb)
	table.insert(eventHandlers, { event = event, name = eventName })
	SetTimeout(20000, function()
		RemoveEventHandler(event)
	end)
	return event
end

Core.ClearEvents = function()
	for k,v in pairs(eventHandlers) do
		RemoveEventHandler(v.event)
	end
	eventHandlers = {}
end

Core.ClearEvent = function(eventName)
	for k,v in pairs(eventHandlers) do
		if v.name == eventName then
			RemoveEventHandler(v.event)
			table.remove(eventHandlers, k)
		end
	end
end

local requireUpdate = false

Citizen.CreateThread(function()
	while true do
		Wait(20000)
		if not requireUpdate then
			requireUpdate = true
		end
	end
end)

function Core.GetPlayerData()
	if requireUpdate then
		requireUpdate = false
		Core.TriggerCallback('Player:GetData', function(data)
			PlayerData = data
		end)
		return PlayerData
	end
	if PlayerData and not table.empty(PlayerData) then
		return PlayerData
	end
	
	Core.TriggerCallback("Player:GetData", function(data)
		PlayerData = data
		return data
	end)
	return PlayerData
end
currentWeather = false
function Core.GetWeather()
	Core.TriggerCallback('Server:GetWeather', function(weather)
		if not weather then
			weather = 'EXTRASUNNY'
		end
		currentWeather = weather
		if currentWeather == 'snow_only' then
			snowOn = true
			ForceSnowPass(snowOn)

		else
			snowOn = false
			ForceSnowPass(snowOn)

		end
	end)
	return currentWeather
end



Citizen.CreateThread(function()
	while true do
		Wait(3000)
		Core.TriggerCallback('Server:SyncWeather', function()
		end)
	end
end)

function Core.SetWeather(weather)
	if type(weather) == "boolean" then
		weather = 'EXTRASUNNY'
	end
	if weather:lower() == 'snow_only' then
		snowOn = true
		ForceSnowPass(snowOn)

	end
	
	if weather:lower() == 'snow_off' then
		snowOn = false
		ForceSnowPass(snowOn)

	end
	currentWeather = weather
	SetWeatherTypePersist(weather)
	SetWeatherTypeNow(weather)
	SetWeatherTypeNowPersist(weather)
end

RegisterNetEvent('Client:SyncSeason', function(season)
	if season == 'winter' then
		snowOn = true
		ForceSnowPass(snowOn)

	else
		snowOn = false
		ForceSnowPass(snowOn)

	end
end)

RegisterNetEvent('Client:SyncWeather', function(weather)
	weather = weather:lower()
	Core.SetWeather(weather)
end)

RegisterCommand('killcp', function ()
	Core.HasCheckpoint(function(has)
		if has then
			Core.DeleteAllCps()
		end
	end)
end)

RegisterCommand('testbox', function()
	Core.ShowDialogBox('Test', 'test', true, true, function (da)
		-- print(da)
	end)
end)

Citizen.CreateThread(function ()
    while true do
		local wait = 1000
        local weather = GetPrevWeatherTypeHashName()
		if not weather then
			weather = 'extrasunny'
		end
		weather = string.upper(weather)
		if weather == 'XMAS' or weather == 'BLIZZARD' or weather == 'THUNDER' or weather == 'RAIN' or snowOn then
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
				local speed = GetEntitySpeed(vehicle) * 3.6
				local speedRounded = math.ceil(speed)
				local rpm = GetVehicleCurrentRpm(vehicle)
				if rpm >= 0.8 then
					local chance = math.random(1, 100)
					if chance <= 20 then
						SetVehicleReduceGrip(vehicle, true)
					end
				else
					SetVehicleReduceGrip(vehicle, false)
				end
			end
		end
		if weather == 'RAIN' or weather == 'THUNDER' then
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				wait = 1
				local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
				if IsControlPressed(0, 72) then
					-- print('Braking')
					SetVehicleReduceGrip(vehicle, true)
					Wait(1000)
					SetVehicleReduceGrip(vehicle, false)
					wait = 2000
				else
					SetVehicleReduceGrip(vehicle, false)
				end
			end
		end
		Wait(wait)
    end
end)

Core.TeleportToCp = function (cp)
	local coords = cp.coords
	local heading = cp.heading
	local ped = PlayerPedId()

	-- Fade out screen
	DoScreenFadeOut(500)

	-- Wait for screen to fade out
	Citizen.Wait(500)

	-- Teleport player
	SetEntityCoords(ped, coords.x, coords.y, coords.z)
	SetEntityHeading(ped, heading)

	-- Fade in screen
	DoScreenFadeIn(500)

	-- Wait for screen to fade in
	Citizen.Wait(500)
end

RegisterCommand('setw', function()
	Core.ShowDialogBox('Set Weather', 'Type the weather name', true, false, function(result)
		if string.len(result) > 0 then
			Core.TriggerCallback('Server:SetWeather', function()
				Core.SetWeather(string.upper(result))
			end, result)
			Core.ClearEvent('weather')
		end
	end)

end)


progressBars = {}
currentProgress = false

Core.ProgressBar = function(duration, percentage, canClose, animation, prop, freeze, cb, closecb)
	
	local id = math.random(1, 9999999)
	local this = {}
	this.id = id
	this.duration = duration
	this.percentage = percentage
	this.canClose = canClose
	this.animation = animation

	progressBars[id] = this

	if freeze then
		FreezeEntityPosition(PlayerPedId(), true)
	end

	if animation then
		RequestAnimDict(animation.dict)
		while not HasAnimDictLoaded(animation.dict) do
			Citizen.Wait(0)
		end
		TaskPlayAnim(PlayerPedId(), animation.dict, animation.name, 8.0, -8.0, -1, 1, 0, false, false, false)
	end

	if prop then
		RequestModel(prop.prop)
		while not HasModelLoaded(prop.prop) do
			Citizen.Wait(0)
		end
		prop.prop = CreateObject(prop.prop, GetEntityCoords(PlayerPedId()), true, false, false)
		AttachEntityToEntity(prop.prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), prop.boneIndex), prop.x, prop.y,
			prop.z, prop.xR, prop.yR, prop.zR, false, false, false, false, 2, true)
	end
	
	
	SendNUIMessage({
		action = "setProgress",
		duration = duration,
		percentage = percentage,
		canCancel = canClose,
	})
	currentProgress = this
	
	if cb then
		SetTimeout(duration * 1000, function()
			if not this then
				return
			end
			if not currentProgress then
				return
			end
			if animation then
				ClearPedTasksImmediately(PlayerPedId())
			end
			if prop then
				DeleteEntity(prop.prop)
			end
			FreezeEntityPosition(PlayerPedId(), false)
			if freeze then
				FreezeEntityPosition(PlayerPedId(), false)
			end
			this = false
			currentProgress = false
			cb()
		end)
	end
	if closecb then
		Citizen.CreateThread(function()
			while true do
				local wait = 1
				if this then
					if this.canClose then
						wait = 1
						if IsControlJustPressed(0, 200) then
							closecb()
							Wait(300)
							currentProgress = false
							this = false
							
						end
					else
						wait = 1000
					end
				else
					wait = 1000
				end
				Wait(wait)
			end
		end)
	end
	return this
end

Core.CancelProgressBar = function()

	if currentProgress.animation then
		ClearPedTasksImmediately(PlayerPedId())
		StopAnimTask(PlayerPedId(), currentProgress.animation.dict, currentProgress.animation.name, 1.0)
	end

	if currentProgress.prop then
		DeleteEntity(currentProgress.prop.prop)
	end
	FreezeEntityPosition(PlayerPedId(), false)

	if currentProgress.freeze then
		FreezeEntityPosition(PlayerPedId(), false)
	end


	currentProgress = false
	SendNUIMessage({
		action = "cancelProgress"
	})
end

RegisterCommand('testprogress', function()
	--progress bar with hammering animation
	Core.ProgressBar(3, 100, true, { dict = "melee@large_wpn@streamed_core", name = "ground_attack_on_spot" },
		{ prop = "prop_tool_pickaxe", boneIndex = 57005, x = 0.15, y = 0.0, z = 0.0, xR = 0.0, yR = 0.0, zR = 0.0 },
		function()
			--callback
		end)
end)

Citizen.CreateThread(function()
	while true do
		local wait = 1000
		if currentProgress and not table.empty(currentProgress) then
			if currentProgress.canClose then
				wait = 1
				if IsControlJustPressed(0, 200) then
					Core.CancelProgressBar()
				end
			else
				wait = 1000
			end
		end
		Wait(wait)
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(6000)
		Core.TriggerCallback('Player:GetData', function(data)
			PlayerData = data
		end)
	end
end)

RegisterNetEvent("Player:UpdateData", function(data)
	PlayerData = data
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

local callbacksCalled = {}

Citizen.CreateThread(function ()
	while true do
		Wait(3000)
		if callbacksCalled then
			for k,v in pairs(callbacksCalled) do
				if v >= 6 then
					callbacksCalled[k] = nil
				end
			end
		end
	end
end)

function Core.TriggerCallback(name, cb, ...)
	Core.ServerCallbacks[name] = cb

	if not callbacksCalled[name] then
		callbacksCalled[name] = 0
		callbacksCalled[name] = callbacksCalled[name] + 1
		if callbacksCalled[name] + 1 > 6 then
			print('Callback limit reached for ' .. name)
			callbacksCalled[name] = 6
			return
		end
	end

	TriggerServerEvent('Core:Server:TriggerCallback', name, ...)
end

function SendChatMessage(message)
	TriggerEvent('chatMessage', "", { 255, 255, 255 }, message)
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

	if(data.modLivery) then
		SetVehicleMod(vehicle, 48, data.modLivery, false)
	end

	if data.livery then
		SetVehicleLivery(vehicle, data.livery)
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
		ToggleVehicleMod(vehicle, 18, data.modTurbo)
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
	local mult = 10 ^ (numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

RegisterCommand('liverytest', function()
	local veh = GetVehiclePedIsIn(PlayerPedId())
	local livery = GetVehicleLiveryCount(veh)
	local livery2 = GetVehicleLivery(veh)
end)

Core.GetVehicleProperties = function(vehicle)
	local color1, color2, color3 = GetVehicleCustomPrimaryColour(vehicle)

	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	local extras = {}
	local livery
	local liveries = GetVehicleLiveryCount(vehicle)

	for id = 0, 12 do
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
		color1Type = 	GetVehicleModColor_1(vehicle),
		color2Type = 	GetVehicleModColor_2(vehicle),
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),
		modXenon          = GetVehicleXenonLightsColour(vehicle),

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
		modLivery         = GetVehicleMod(vehicle, 48),
		livery = GetVehicleLivery(vehicle)
	}
end




function GetVehicles()
	local vehicles = false
	if not ClientVehicles then
		vehicles = false
		return vehicles
	end
	if table.empty(ClientVehicles) then
		vehicles = false
		return vehicles
	end

	if ClientVehicles and not table.empty(ClientVehicles) then
		vehicles = ClientVehicles
		return vehicles
	end
	return vehicles
end

function CreateCar(model, coords, heading, isnet, tsc, putin, plate, ignore)
	if not ignore then
		ignore = true
	end
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

	if isnet then
		local netID = NetworkGetNetworkIdFromEntity(veh)
		SetNetworkIdExistsOnAllMachines(netID, true)
	end

	if not ClientVehicles then
		ClientVehicles = {}
		table.insert(ClientVehicles, { localId = veh, netID = netID, ignore = ignore })
	else
		table.insert(ClientVehicles, { localId = veh, netID = netID, ignore = ignore })
	end

	TriggerServerEvent("Vehicles:Insert", { netID = netID, localId = veh, ignore = ignore })

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
			filter = { filter }
		end
	end

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i = 1, #objects, 1 do
		local foundObject = false

		if filter == nil or (type(filter) == 'table' and #filter == 0) then
			foundObject = true
		else
			local objectModel = GetEntityModel(objects[i])

			for j = 1, #filter, 1 do
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
	local pass = false

	if not ClientVehicles or table.empty(ClientVehicles) then return false end
	for k, v in pairs(ClientVehicles) do
		if v.localId == veh then
			if v.ignore then
				pass = true
			end
			if not v.netID then
				if v.ignore then
					pass = true
				end
			else
				pass = true
			end
		end
	end
	return pass
end


Citizen.CreateThread(function()
	while true do
		Wait(6000)
		while not LoggedIn do
			Wait(1000)
		end
		local pData = false
		local PlayerData
		local gunFound = false
		while not pData do
			Wait(1000)
			pData = Core.GetPlayerData()
			PlayerData = pData
		end
		
		local vehs = GetAllVehicles()
		local notRegistered = false
		for k,v in pairs(vehs) do
			if not isVehicleRegistered(v) then
				notRegistered = v
			end
		end

		if notRegistered then
			while DoesEntityExist(notRegistered) do
				Wait(1)
				DeleteEntity(notRegistered)
				DeleteVehicle(notRegistered)
				DeleteCar(notRegistered)
			end
		end

		local unarmed = GetHashKey('WEAPON_UNARMED')
		if GetVehicles() and not table.empty(GetVehicles()) then
			for k,v in pairs(GetVehicles()) do
				if not v.netID then
					if not v.ignore then
						DeleteCar(v.localId)
					end
				end
			end
		end

		if GetSelectedPedWeapon(PlayerPedId()) ~= unarmed and GetSelectedPedWeapon(PlayerPedId()) ~= 966099553 then
			-- print(GetSelectedPedWeapon(PlayerPedId()))
			-- print('Player armed')
			local Inventory = pData.inventory
			for k,v in pairs(Inventory) do
				if v.type == 'weapon' then
					if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(v.name) then
						gunFound = true
					end

					if not gunFound then
						Core.TriggerCallback('AC:ReportAnomaly', function()
						end, 'weapon')
						RemoveAllPedWeapons(PlayerPedId(), true)
						for k, v in pairs(Inventory) do
							if v.type == 'weapon' then
								local playerAmmo = Core.GetPlayerAmmo()
								for a, b in pairs(playerAmmo) do
									if checkWeaponPresence(v.name, a) then
										GiveWeaponToPed(PlayerPedId(), GetHashKey(v.name), b, false, false)
									end
								end
							end
						end
					end
				end
			end
		end

		pData.adminLevel = pData.adminLevel or false
		if not IsGameplayCamRendering() and pData.adminLevel == 0 then
			Core.TriggerCallback('AC:ReportAnomaly', function()
			end, 'freecam')
		end
		if not IsEntityVisible(PlayerPedId()) and pData.adminLevel == 0  then
			Core.TriggerCallback('AC:ReportAnomaly', function()
			end, 'invisible')
		end
		if GetEntitySpeed(PlayerPedId()) > 150.0 and pData.adminLevel == 0   then
			Core.TriggerCallback('AC:ReportAnomaly', function()
			end, 'walk-speed/ped-speed')
		end
		if IsPedInAnyVehicle(PlayerPedId(), false) and pData.adminLevel == 0  then
			if GetEntityAlpha(GetVehiclePedIsIn(PlayerPedId())) < 255 then
				Core.TriggerCallback('AC:ReportAnomaly', function()
				end, 'invisible/maybe noclip')
			end
		end
		if GetEntityAlpha(PlayerPedId()) < 255 and pData.adminLevel == 0  then
			Core.TriggerCallback('AC:ReportAnomaly', function()
			end, 'invisible/maybe noclip')
		end

		if IsPedInAnyVehicle(PlayerPedId(), false) and pData.adminLevel == 0  then
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
			if GetEntitySpeed(veh) > 150.0 then
				Core.TriggerCallback('AC:ReportAnomaly', function()
				end, 'veh-speed/modifier')
			end
		end
		
		--detect flying/noclip
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		local ground, zPos = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z, 0)
		local height = pos.z - zPos
		if height > 10.0 and pData.adminLevel == 0  then
			Core.TriggerCallback('AC:ReportAnomaly', function()
			end, 'flying')
		end

		
	end
end)

local PlayerAmmo = {}
local delayanno = false

local await = 60000

Citizen.CreateThread(function()
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
local weapons = {
	[-1075685676] = "WEAPON_PISTOL_MK2",
	[126349499] = "WEAPON_SNOWBALL",
	[-270015777] = "WEAPON_ASSAULTSMG",
	[615608432] = "WEAPON_MOLOTOV",
	[2024373456] = "WEAPON_SMG_MK2",
	[-1810795771] = "WEAPON_POOLCUE",
	[-1813897027] = "WEAPON_GRENADE",
	[-598887786] = "WEAPON_MARKSMANPISTOL",
	[-1654528753] = "WEAPON_BULLPUPSHOTGUN",
	[-72657034] = "GADGET_PARACHUTE",
	[-102323637] = "WEAPON_BOTTLE",
	[2144741730] = "WEAPON_COMBATMG",
	[-1121678507] = "WEAPON_MINISMG",
	[-1652067232] = "WEAPON_SWEEPERSHOTGUN",
	[961495388] = "WEAPON_ASSAULTRIFLE_MK2",
	[-86904375] = "WEAPON_CARBINERIFLE_MK2",
	[-1786099057] = "WEAPON_BAT",
	[177293209] = "WEAPON_HEAVYSNIPER_MK2",
	[600439132] = "WEAPON_BALL",
	[1432025498] = "WEAPON_PUMPSHOTGUN_MK2",
	[-1951375401] = "WEAPON_FLASHLIGHT",
	[171789620] = "WEAPON_COMBATPDW",
	[1593441988] = "WEAPON_COMBATPISTOL",
	[-2009644972] = "WEAPON_SNSPISTOL_MK2",
	[2138347493] = "WEAPON_FIREWORK",
	[1649403952] = "WEAPON_COMPACTRIFLE",
	[-619010992] = "WEAPON_MACHINEPISTOL",
	[-952879014] = "WEAPON_MARKSMANRIFLE",
	[317205821] = "WEAPON_AUTOSHOTGUN",
	[-1420407917] = "WEAPON_PROXMINE",
	[-1045183535] = "WEAPON_REVOLVER",
	[94989220] = "WEAPON_COMBATSHOTGUN",
	[-1658906650] = "WEAPON_MILITARYRIFLE",
	[1198256469] = "WEAPON_RAYCARBINE",
	[2132975508] = "WEAPON_BULLPUPRIFLE",
	[1627465347] = "WEAPON_GUSENBERG",
	[984333226] = "WEAPON_HEAVYSHOTGUN",
	[1233104067] = "WEAPON_FLARE",
	[-1716189206] = "WEAPON_KNIFE",
	[940833800] = "WEAPON_STONE_HATCHET",
	[1305664598] = "WEAPON_GRENADELAUNCHER_SMOKE",
	[727643628] = "WEAPON_CERAMICPISTOL",
	[-1074790547] = "WEAPON_ASSAULTRIFLE",
	[-1169823560] = "WEAPON_PIPEBOMB",
	[324215364] = "WEAPON_MICROSMG",
	[-1834847097] = "WEAPON_DAGGER",
	[-1466123874] = "WEAPON_MUSKET",
	[-1238556825] = "WEAPON_RAYMINIGUN",
	[-1063057011] = "WEAPON_SPECIALCARBINE",
	[1470379660] = "WEAPON_GADGETPISTOL",
	[584646201] = "WEAPON_APPISTOL",
	[-494615257] = "WEAPON_ASSAULTSHOTGUN",
	[-771403250] = "WEAPON_HEAVYPISTOL",
	[1672152130] = "WEAPON_HOMINGLAUNCHER",
	[338557568] = "WEAPON_PIPEWRENCH",
	[1785463520] = "WEAPON_MARKSMANRIFLE_MK2",
	[-1355376991] = "WEAPON_RAYPISTOL",
	[101631238] = "WEAPON_FIREEXTINGUISHER",
	[1119849093] = "WEAPON_MINIGUN",
	[883325847] = "WEAPON_PETROLCAN",
	[-102973651] = "WEAPON_HATCHET",
	[-275439685] = "WEAPON_DBSHOTGUN",
	[-1746263880] = "WEAPON_DOUBLEACTION",
	[-879347409] = "WEAPON_REVOLVER_MK2",
	[125959754] = "WEAPON_COMPACTLAUNCHER",
	[911657153] = "WEAPON_STUNGUN",
	[-2066285827] = "WEAPON_BULLPUPRIFLE_MK2",
	[-538741184] = "WEAPON_SWITCHBLADE",
	[100416529] = "WEAPON_SNIPERRIFLE",
	[-656458692] = "WEAPON_KNUCKLE",
	[-1768145561] = "WEAPON_SPECIALCARBINE_MK2",
	[1737195953] = "WEAPON_NIGHTSTICK",
	[2017895192] = "WEAPON_SAWNOFFSHOTGUN",
	[-2067956739] = "WEAPON_CROWBAR",
	[-1312131151] = "WEAPON_RPG",
	[-1568386805] = "WEAPON_GRENADELAUNCHER",
	[205991906] = "WEAPON_HEAVYSNIPER",
	[1834241177] = "WEAPON_RAILGUN",
	[-1716589765] = "WEAPON_PISTOL50",
	[736523883] = "WEAPON_SMG",
	[1317494643] = "WEAPON_HAMMER",
	[453432689] = "WEAPON_PISTOL",
	[1141786504] = "WEAPON_GOLFCLUB",
	[-1076751822] = "WEAPON_SNSPISTOL",
	[-2084633992] = "WEAPON_CARBINERIFLE",
	[487013001] = "WEAPON_PUMPSHOTGUN",
	[-1168940174] = "WEAPON_HAZARDCAN",
	[-38085395] = "WEAPON_DIGISCANNER",
	[-1853920116] = "WEAPON_NAVYREVOLVER",
	[-37975472] = "WEAPON_SMOKEGRENADE",
	[-1600701090] = "WEAPON_BZGAS",
	[-1357824103] = "WEAPON_ADVANCEDRIFLE",
	[-581044007] = "WEAPON_MACHETE",
	[741814745] = "WEAPON_STICKYBOMB",
	[-608341376] = "WEAPON_COMBATMG_MK2",
	[137902532] = "WEAPON_VINTAGEPISTOL",
	[-1660422300] = "WEAPON_MG",
	[1198879012] = "WEAPON_FLAREGUN"
}

Citizen.CreateThread(function()
	while true do
		Wait(2000)
		local weapon = GetSelectedPedWeapon(PlayerPedId())
		local bool, loadedAmmo = GetAmmoInClip(PlayerPedId(), weapon)
		local totalAmmo = GetAmmoInPedWeapon(PlayerPedId(), weapon)
		local wName = ""
		for k, v in pairs(weapons) do
			if weapon == k then
				wName = v
				break
			end
		end

		SendNUIMessage({
			action = 'updateGun',
			gun = wName,
			ammo = loadedAmmo,
			ammoMax = totalAmmo,
		})
	end
end)
local shots = 0
AddEventHandler('CEventGunShot', function(a, b, c)
	-- local shooter = GetPlayerServerId(NetworkGetEntityOwner(a))
	
	-- local weapon = GetSelectedPedWeapon(PlayerPedId())
	-- if shots < 3 then
	-- 	shots = shots + 1
	-- 	if shots + 1 == 3 then
	-- 		shots = 0
	-- 		if shooter == PlayerId() then
	-- 			Core.TriggerCallback('AC:ReportAnomaly', function()
	-- 			end, 'silent-weapon')
	-- 		end
			
	-- 	end
	-- end
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

	local bool, loadedAmmo = GetAmmoInClip(PlayerPedId(), weapon)
	local totalAmmo = GetAmmoInPedWeapon(PlayerPedId(), weapon)
	local wName = ""
	for k, v in pairs(weapons) do
		if weapon == k then
			wName = v
			break
		end
	end

	SendNUIMessage({
		action = 'updateGun',
		gun = wName,
		ammo = loadedAmmo,
		ammoMax = totalAmmo,
	})

	if ammoName then
		if not PlayerAmmo[ammoName] then
			PlayerAmmo[ammoName] = ammo
		end

		if PlayerAmmo[ammoName] then
			PlayerAmmo[ammoName] = ammo
		end
	end

	local unarmed = GetHashKey('WEAPON_UNARMED')
	if not PlayerData then
		PlayerData = Core.GetPlayerData()
	end
	

end)

function Core.GetPlayerAmmo()
	local pAmmo = {}
	local callbackCompleted = false
	if table.empty(PlayerAmmo) or not PlayerAmmo then
		Core.TriggerCallback('Core:GetPlayerAmmo', function(cb)
			pAmmo = cb
			callbackCompleted = true
		end)
	else
		pAmmo = PlayerAmmo
		callbackCompleted = true
	end

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

playerObjects = {}

Core.RequestModel = function(model)
	if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(1)
        end
    end
end

Core.CreateObject = function(model, coords, isNet, tsc, dynamic)
	Core.RequestModel(model)
	local obj = CreateObject(GetHashKey(model), coords.x, coords.y, coords.z, isNet, tsc, dynamic)
	table.insert(playerObjects, obj)
	SetModelAsNoLongerNeeded(model)
	SetModelAsNoLongerNeeded(GetHashKey(model))
	return obj
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5 * 1000)
		if PlayerAmmo and not table.empty(PlayerAmmo) then
			Core.UpdateAmmo(PlayerAmmo)
		else
			PlayerAmmo = Core.GetPlayerAmmo()
			Core.UpdateAmmo(Core.GetPlayerAmmo())
		end
	end
end)
function SetInterval(ms, cb)
	local interval = ms
	local nextTime = GetGameTimer() + interval
	local active = true

	local function update()
		if not active then return end
		local time = GetGameTimer()
		if time >= nextTime then
			nextTime = time + interval
			cb()
		end
		SetTimeout(0, update)
	end

	SetTimeout(0, update)

	return {
		clear = function() active = false end
	}
end

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
