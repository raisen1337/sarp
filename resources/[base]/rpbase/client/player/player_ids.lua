                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --[[
---------------------------------------------------
HEAD LABELS (C_HLABELS.LUA) by MrDaGree | Edited by Zeemah
---------------------------------------------------
Last revision: JUN 26 2020
---------------------------------------------------
NOTES 

---------------------------------------------------
]]

local comicSans = false
local disPlayerNames = 15

RegisterFontFile("comic")
fontId = RegisterFontId("Comic Sans MS")

RegisterNetEvent('setHeadLabelDistance')
AddEventHandler('setHeadLabelDistance', function(distance)
	disPlayerNames = distance
	TriggerServerEvent("onClientHeadLabelRangeChange", distance)
end)

local LocalPlayer = {
	Ped = {
		Handle = 0
	}
}
CreateThread(function()
	while true do

		LocalPlayer.Ped.Handle = PlayerPedId()
		Wait(500)
	end
end)

function DrawText3D(x, y, z, text)
	local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
	local dist = #(GetGameplayCamCoords() - vec(x, y, z))

	local scale = (4.00001 / dist) * 0.3
	if scale > 0.2 then
		scale = 0.2
	elseif scale < 0.15 then
		scale = 0.15
	end

	local fov = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov

	if onScreen then
		SetTextFont(comicSans and fontId or 4)
		SetTextScale(scale, scale)
		SetTextProportional(true)
		SetTextCentre(true)
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(_x, _y - 0.025)
	end
end
local fivemGamerTagCompsEnum = {
    GamerName = 0,
    CrewTag = 1,
    HealthArmour = 2,
    BigText = 3,
    AudioIcon = 4,
    UsingMenu = 5,
    PassiveMode = 6,
    WantedStars = 7,
    Driver = 8,
    CoDriver = 9,
    Tagged = 12,
    GamerNameNearby = 13,
    Arrow = 14,
    Packages = 15,
    InvIfPedIsFollowing = 16,
    RankText = 17,
    Typing = 18
}

function ManageHeadLabels()
	for _, i in pairs(GetActivePlayers()) do
		if NetworkIsPlayerActive(i) then

			local iPed = GetPlayerPed(i)
			local lPlayer = PlayerId()
			if iPed ~= LocalPlayer.Ped.Handle then
				if DoesEntityExist(iPed) then
					local headLabelId = CreateMpGamerTag(iPed, " ", 0, 0, " ", 0)
										SetMpGamerTagName(headLabelId, GetPlayerName(i).."("..GetPlayerServerId(i)..")")
                                        SetMpGamerTagVisibility(headLabelId, fivemGamerTagCompsEnum.GamerName, 1)
										SetMpGamerTagVisibility(headLabelId, 0, true)
                                        SetMpGamerTagHealthBarColor(headLabelId, 6)
                                        SetMpGamerTagAlpha(headLabelId, fivemGamerTagCompsEnum.HealthArmour, 255)
                                        SetMpGamerTagVisibility(headLabelId, fivemGamerTagCompsEnum.HealthArmour, 1)
                                        if NetworkIsPlayerTalking(i) then
                                            SetMpGamerTagVisibility(headLabelId, fivemGamerTagCompsEnum.AudioIcon, true)
                                            SetMpGamerTagColour(headLabelId, fivemGamerTagCompsEnum.AudioIcon, 12) --HUD_COLOUR_YELLOW
                                            SetMpGamerTagColour(headLabelId, fivemGamerTagCompsEnum.GamerName, 12) --HUD_COLOUR_YELLOW
                                        else
                                            SetMpGamerTagVisibility(headLabelId, fivemGamerTagCompsEnum.AudioIcon, false)
                                            SetMpGamerTagColour(headLabelId, fivemGamerTagCompsEnum.AudioIcon, 0)
                                            SetMpGamerTagColour(headLabelId, fivemGamerTagCompsEnum.GamerName, 0)
                                        end

					distance = #(GetEntityCoords(LocalPlayer.Ped.Handle) - GetEntityCoords(iPed))
                    if distance > 15 then
                        SetMpGamerTagVisibility(headLabelId, 0, false)
                        SetMpGamerTagVisibility(headLabelId, fivemGamerTagCompsEnum.HealthArmour, false)

                        
                    end
				end
            end
		end
	end
end

Citizen.CreateThread(function()
	while true do
		ManageHeadLabels()
		Citizen.Wait(0)
	end
end)