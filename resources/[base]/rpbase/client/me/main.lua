-- @desc Client-side /me handling
-- @author Elio
-- @version 3.0

local peds = {}

-- Localization
local GetGameTimer = GetGameTimer

-- @desc Draw text in 3d
-- @param coords world coordinates to where you want to draw the text
-- @param text the text to display
local function draw3dText(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    
    -- Experimental math to scale the text down
    local scale = 200 / (GetGameplayCamFov() * dist)

    -- Format the text
    SetTextColour(255, 255, 255, 255)
    SetTextScale(0.0, 0.50 * scale)
    SetTextFont(2)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)

    -- Diplay the text
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()

end

-- @desc Display the text above the head of a ped
-- @param ped the target ped
-- @param text the text to display
local function displayText(ped, text)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local targetPos = GetEntityCoords(ped)
    local dist = #(playerPos - targetPos)
    local los = HasEntityClearLosToEntity(playerPed, ped, 17)

    if dist <= 4 and los then
        local exists = peds[ped] ~= nil

        if ped ~= playerPed then
            peds[ped] = {
                time = GetGameTimer() + 3000,
                text = text
            }
    
            if not exists then
                local display = true
    
                while display do
                    Wait(0)
                    local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 1.2)
                    DrawText3D(pos.x, pos.y, pos.z, peds[ped].text)
                    display = GetGameTimer() <= peds[ped].time
                end
                peds[ped] = nil
            end
        end
       
    end
end

-- @desc Trigger the display of teh text for a player
-- @param text text to display
-- @param target the target server id
local function onShareDisplay(text, target)
    local player = GetPlayerFromServerId(target)
    if player ~= -1 or target == GetPlayerServerId(PlayerId()) then
        local ped = GetPlayerPed(player)
        displayText(ped, text)
    end
end

-- Register the event
RegisterNetEvent('3dme:shareDisplay', onShareDisplay)

-- Add the chat suggestion
