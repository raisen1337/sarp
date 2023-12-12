--                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     --[[
-- ---------------------------------------------------
-- HEAD LABELS (C_HLABELS.LUA) by MrDaGree | Edited by Zeemah
-- ---------------------------------------------------
-- Last revision: JUN 26 2020
-- ---------------------------------------------------
-- NOTES

-- ---------------------------------------------------
-- ]]

-- local comicSans = false
-- local disPlayerNames = 15

-- RegisterFontFile("comic")
-- fontId = RegisterFontId("Comic Sans MS")

-- RegisterNetEvent('setHeadLabelDistance')
-- AddEventHandler('setHeadLabelDistance', function(distance)
-- 	disPlayerNames = distance
-- 	TriggerServerEvent("onClientHeadLabelRangeChange", distance)
-- end)

-- local LocalPlayer = {
-- 	Ped = {
-- 		Handle = 0
-- 	}
-- }
-- CreateThread(function()
-- 	while true do

-- 		LocalPlayer.Ped.Handle = PlayerPedId()
-- 		Wait(500)
-- 	end
-- end)
function DrawText3D(x, y, z, text, r, g, b, a)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	if r and g and b and a then
		SetTextColour(r, g, b, a)
	else
		SetTextColour(255, 255, 255, 215)
	end
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x, y, z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	ClearDrawOrigin()
end

-- local fivemGamerTagCompsEnum = {
--     GamerName = 0,
--     CrewTag = 1,
--     HealthArmour = 2,
--     BigText = 3,
--     AudioIcon = 4,
--     UsingMenu = 5,
--     PassiveMode = 6,
--     WantedStars = 7,
--     Driver = 8,
--     CoDriver = 9,
--     Tagged = 12,
--     GamerNameNearby = 13,
--     Arrow = 14,
--     Packages = 15,
--     InvIfPedIsFollowing = 16,
--     RankText = 17,
--     Typing = 18
-- }

-- function ManageHeadLabels()
-- 	for _, i in pairs(GetActivePlayers()) do
-- 		if NetworkIsPlayerActive(i) then

-- 			local iPed = GetPlayerPed(i)
-- 			local lPlayer = PlayerId()
-- 			if iPed ~= LocalPlayer.Ped.Handle then
-- 				if DoesEntityExist(iPed) then
-- 					local headLabelId = CreateMpGamerTag(iPed, " ", 0, 0, " ", 0)
-- 										SetMpGamerTagName(headLabelId, GetPlayerName(i).."("..GetPlayerServerId(i)..")")
--                                         SetMpGamerTagVisibility(headLabelId, fivemGamerTagCompsEnum.GamerName, 1)
-- 										SetMpGamerTagVisibility(headLabelId, 0, true)
--                                         SetMpGamerTagHealthBarColor(headLabelId, 6)
--                                         SetMpGamerTagAlpha(headLabelId, fivemGamerTagCompsEnum.HealthArmour, 255)
--                                         SetMpGamerTagVisibility(headLabelId, fivemGamerTagCompsEnum.HealthArmour, 1)
--                                         if NetworkIsPlayerTalking(i) then
--                                             SetMpGamerTagVisibility(headLabelId, fivemGamerTagCompsEnum.AudioIcon, true)
--                                             SetMpGamerTagColour(headLabelId, fivemGamerTagCompsEnum.AudioIcon, 12) --HUD_COLOUR_YELLOW
--                                             SetMpGamerTagColour(headLabelId, fivemGamerTagCompsEnum.GamerName, 12) --HUD_COLOUR_YELLOW
--                                         else
--                                             SetMpGamerTagVisibility(headLabelId, fivemGamerTagCompsEnum.AudioIcon, false)
--                                             SetMpGamerTagColour(headLabelId, fivemGamerTagCompsEnum.AudioIcon, 0)
--                                             SetMpGamerTagColour(headLabelId, fivemGamerTagCompsEnum.GamerName, 0)
--                                         end

-- 					distance = #(GetEntityCoords(LocalPlayer.Ped.Handle) - GetEntityCoords(iPed))
--                     if distance > 15 then
--                         SetMpGamerTagVisibility(headLabelId, 0, false)
--                         SetMpGamerTagVisibility(headLabelId, fivemGamerTagCompsEnum.HealthArmour, false)


--                     end
-- 				end
--             end
-- 		end
-- 	end
-- end

-- Citizen.CreateThread(function()
-- 	while true do
-- 		ManageHeadLabels()
-- 		Citizen.Wait(0)
-- 	end
-- end)
local nearestPlayer = false
Core.GetNearestPlayerData = function()
	Core.TriggerCallback('Core:GetNearestPlayerData', function(player)
		nearestPlayer = player
	end)
	return nearestPlayer
end

Citizen.CreateThread(function()
	while true do
		local wait = 3000
		nearestPlayer = Core.GetNearestPlayerData()
		Wait(wait)
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = 5000
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local nearestPed = GetPedInFront()
		local networkPlayer = NetworkGetPlayerIndexFromPed(nearestPed)
		local tags = {}
		if nearestPed then
			if nearestPlayer and networkPlayer then
				local headPos = GetPedBoneCoords(nearestPed, 0x796e, 0.0, 0.0, 0.0)
				if headPos.x ~= 0 then
					wait = 0
					if #(playerCoords - headPos) < 4 then
						if nearestPlayer.adminLevel > 0 then
							table.insert(tags, '~r~ADMIN~w~~n~')
						end
						DrawText3D(headPos.x, headPos.y, headPos.z + 0.4,
							table.concat(tags) .. "" .. nearestPlayer.user .. "(" .. nearestPlayer.source .. ")", 255,
							255, 255, 255)
					end
				end
			end
		end

		Wait(wait)
	end
end)
