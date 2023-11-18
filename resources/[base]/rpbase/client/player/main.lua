function reloadScripts()
    ExecuteCommand('loadhouses')
    LoggedIn = true
end


local SelectGender = MenuV:CreateMenu(false, "Selecteaza sexul", "center", 255, 0, 0, 'size-150', 'none', 'menuv', 'selectgender')

local function LoadModel(model)
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end
        return true
    end
    return false
end

SelectGender:AddButton({
    label = 'Barbat',
    icon = '🙍‍♂️'
}):On('select', function()
    SetEntityVisible(PlayerPedId(), true)
    FreezeEntityPosition(PlayerPedId(), false)
    local model = 'mp_m_freemode_01'
    if LoadModel(model) then
        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(PlayerPedId())
        SetModelAsNoLongerNeeded(model)
    end

    TriggerEvent('chat:clear')
    TriggerEvent('Identity:OpenSetup')
    PlayerData.character['ped_model'] = model
    Core.SavePlayer()
    LoggedIn = true
    Core.startPayday()
end)

SelectGender:AddButton({
    label = 'Femeie',
    icon = '🙍‍♀️'
}):On('select', function()
    SetEntityVisible(PlayerPedId(), true)
    FreezeEntityPosition(PlayerPedId(), false)
    local model = 'mp_f_freemode_01'
    if LoadModel(model) then
        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(PlayerPedId())
        SetModelAsNoLongerNeeded(model)
    end

    TriggerEvent('chat:clear')
    TriggerEvent('Identity:OpenSetup')
    PlayerData.character['ped_model'] = model
    Core.SavePlayer()
    LoggedIn = true
    Core.startPayday()
end)


AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  PlayerSpawned()
end)

PlayerCoords = function()
    local pCoords = GetEntityCoords(PlayerPedId())
    return pCoords
end

RegisterCommand('dv', function()
    if GetVehiclePedIsIn(PlayerPedId(), false) then
        DeleteCar(GetVehiclePedIsIn(PlayerPedId(), false))
        sendNotification("Vehicul", "Vehiculul tau a fost sters.", 'success')
    else
        sendNotification("Vehicul", "Nu esti intr-un vehicul.", 'error')
    end
end)


PlayerSpawned = function()
    SetEntityVisible(PlayerPedId(), false)
    
    Core.TriggerCallback('Player:GetData', function(result)
        PlayerData = result
        ClientVehicles = GetVehicles()
        TriggerServerEvent("Scoreboard:AddPlayer")
        TriggerServerEvent("Scoreboard:SetScoreboard")
        print(PlayerData.position)
        if not PlayerData.position or table.empty(PlayerData.position) then
            SetEntityCoords(PlayerPedId(), mugShot.characterPos[1], mugShot.characterPos[2], mugShot.characterPos[3] - 1)
            SetEntityHeading(PlayerPedId(), mugShot.characterPos[4])
            FreezeEntityPosition(PlayerPedId(), true)
            SetEntityVisible(PlayerPedId(), false)
            MenuV:OpenMenu(SelectGender)
            LoggedIn = true
        else
            SetEntityCoords(PlayerPedId(), PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + 1)
            FreezeEntityPosition(PlayerPedId(), true)
            RequestCollisionAtCoord(PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
            SetEntityVisible(PlayerPedId(), false)
            FreezeEntityPosition(PlayerPedId(), false)

            local model = PlayerData.character['ped_model']
            if IsModelInCdimage(model) and IsModelValid(model) then
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetPedDefaultComponentVariation(PlayerPedId())
                SetModelAsNoLongerNeeded(model)
                SetEntityVisible(PlayerPedId(), true)
                Core.TriggerCallback('Clothing:GetClothing', function(cb)
                    LoadPed(cb)
                end)
                if PlayerData.inHouseId ~= 0 then
                    Core.TriggerCallback("Houses:GetHouseById", function(house)
                        if house then
                            EnterHouse(house)
                        end
                    end, PlayerData.inHouseId)
                end
                Core.SavePlayer()
                Core.startPayday()
                LoggedIn = true
            end
        end
    end)
    Wait(3000)
    LoggedIn = true
    ExecuteCommand('loadbiz')
    ExecuteCommand('loadhouses')
end

SetMillisecondsPerGameMinute(60000)

Citizen.CreateThread(function()
    while true do
        TriggerServerEvent('sv-time:update')
        Wait(60000)
    end
end)

RegisterNetEvent('cl-time:update', function(h, m, s)
    NetworkOverrideClockTime(h, m, s)
end)

local payDayTime = 60

RegisterCommand('savedata', function()
    local coords = GetEntityCoords(PlayerPedId())
    PlayerData.position = coords
    Wait(500)
    Core.SavePlayer()
end)

function Core.startPayday()
    SendNUIMessage({
        action = 'startPayday',
        time = payDayTime,
    })
    Wait(payDayTime * (60 * 1000))
    Core.TriggerCallback('PayDay:Finish', function(total)
        SendNUIMessage({
            action = 'payday',
            paydayInfo = 'Payday: $'..FormatNumber(total.check)..'<br>Salariu: $'..FormatNumber(total.job).."<br>VIP Bonus: $"..FormatNumber(total.vip)
        })
    end)
    Core.startPayday()
end

function GetPlayerCoords()
    return GetEntityCoords(PlayerPedId())
end


RegisterCommand('fmmtwaxx', function ()
    Core.startPayday()
end)

function HasAccess(level)
    if PlayerData.adminLevel >= level then
        return true
    else
        return false
    end
end

local cam = nil

selectedPed = 1

local pedWait = 100000000

function table.empty (self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end

missionPassed = function(missionText)
    SendNUIMessage({
        action = 'missionPassed',
        missionText = missionText
    })
end

  
propertyBought = function(missionText)
    SendNUIMessage({
        action = 'propertyBought',
        missionText = missionText
    })
end

RegisterNetEvent("MissionPassed:Show", function(msg)
    missionPassed(msg)
end)

RegisterCommand('spawnme', function()
    LoggedIn = true
    PlayerSpawned()
end)
-- local skinSet = false
-- Citizen.CreateThread(function()
--     while true do
--         if LoggedIn and not skinSet then
--             ExecuteCommand('fixskin')
--             Core.TriggerCallback('Clothing:GetClothing', function(cb)
--                 LoadPed(cb)
--             end)
--             skinSet = true
--             TriggerEvent("Clothing:FixSkin")
--         end
--         Wait(1000)
--     end
-- end)

RegisterNetEvent("Hud:Tog", function(tog)
    if tog then
        SendNUIMessage({
            action = "fixShow",
        })
        SendNUIMessage({
            action = "showHud",
            onlinePlayers = onlinePlayers or 0 ,
            cash = PlayerData.cash or 0,
            bank = PlayerData.bank or 0,
            wantedLevel = PlayerData.wantedLevel or 0,
            playerJob = PlayerData.job.name or "Unemployed",
            playerLevel = PlayerData.level or 1,
        })
    else
        SendNUIMessage({
            action = "hideHud",
        })
    end
end)

showHud = function(onlinePlayers)
    if not PlayerData then
        PlayerData = Core.GetPlayerData()
        return
    end
    if not PlayerData.job then
        PlayerData = Core.GetPlayerData()
        return
    end
    if not LoggedIn then return end
    SendNUIMessage({
        action = "showHud",
        onlinePlayers = onlinePlayers or 0 ,
        cash = PlayerData.cash or 0,
        bank = PlayerData.bank or 0,
        wantedLevel = PlayerData.wantedLevel or 0,
        playerJob = PlayerData.job.name or "Unemployed",
        playerLevel = PlayerData.level or 1,
    })
    SendNUIMessage({
        action = "showStatus",
    })
end

Citizen.CreateThread(function()
    while true do
        Wait(2000)
        
        Core.TriggerCallback('Players:GetCount', function(count)
            showHud(count)
        end)
        Core.TriggerCallback("Player:GetData", function(result)
            PlayerData = result
        end)
        local coords = GetEntityCoords(PlayerPedId())
        PlayerData.position = coords
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HideHudComponentThisFrame(3) -- CASH
		HideHudComponentThisFrame(4) -- MP CASH
		HideHudComponentThisFrame(2) -- weapon icon
		HideHudComponentThisFrame(9) -- STREET NAME
		HideHudComponentThisFrame(7) -- Area NAME
		HideHudComponentThisFrame(8) -- Vehicle Class
		HideHudComponentThisFrame(6) -- Vehicle Name 
	end
end)

Citizen.CreateThread(function ()
    while true do
        Wait(2000)
        local health = GetEntityHealth(PlayerPedId())
        local armour = GetPedArmour(PlayerPedId())
        SendNUIMessage({
            action = "updateStatus",
            health = health,
            armour = armour,
        })
    end
    
end)

RegisterNetEvent("Scoreboard:AddPlayer", function(player)
    SendNUIMessage({
        action = 'addPlayer',
        playerId = player.playerId,
        playerName = player.playerName,
        playerLevel = player.playerLevel,
    })
end)

RegisterNetEvent("Scoreboard:RemovePlayer", function(player)
    SendNUIMessage({
        action = 'removePlayer',
        playerId = player.playerId,
    })
end)

Citizen.CreateThread(function ()
    while true do
        Wait(1)
        if IsControlJustPressed(0, 212) then
            if scoreboardActive then
                SendNUIMessage({
                    action = 'hideScoreboard',
                })
                scoreboardActive = false;
            else
                TriggerServerEvent("Scoreboard:SetScoreboard")
                SendNUIMessage({
                    action = 'showScoreboard',
                })
                scoreboardActive = true;
            end
        end
        if IsControlJustReleased(0, 212) then
            if scoreboardActive then
                SendNUIMessage({
                    action = 'hideScoreboard',
                })
                scoreboardActive = false;
            else
                TriggerServerEvent("Scoreboard:SetScoreboard")
                SendNUIMessage({
                    action = 'showScoreboard',
                })
                scoreboardActive = true;
            end
        end
    end
end)

sendNotification = function(title, msg, type)
    SendNUIMessage({
        action = 'notify',
        title = title,
        msg = msg,
        type = type or 'success'
    })
end

RegisterNetEvent("Players:TransactionsTog", function()
    PlayerData.transactionsActive = false
    Core.SavePlayer()
    MenuV:CloseAll()
end)

local chatTog = true
local hudTog = true
local togRadar = false

local togMenu = MenuV:CreateMenu(false, 'Toggles', 'center', 0, 0, 0, 'size-125', 'none', 'menuv', 'toggles-menu')
RegisterCommand('tog', function ()
    togMenu:ClearItems()

    if not PlayerData.transactionsActive then
        togMenu:AddButton({
            label = "Tranzactii",
            icon = "🔴"
        }):On('select', function ()
            PlayerData.transactionsActive = true
            sendNotification("Toggle", 'Ti-ai pornit tranzactiile. Acestea se vor oprii cand realizezi o tranzactie', 'success')
            Core.SavePlayer()
            MenuV:CloseAll()
        end)
    end
    if PlayerData.transactionsActive then
        togMenu:AddButton({
            label = "Tranzactii",
            icon = "🟢"
        }):On('select', function ()
            PlayerData.transactionsActive = false
            sendNotification("Toggle", 'Ti-ai oprit tranzactiile.', 'success')
            Core.SavePlayer()
            MenuV:CloseAll()
        end)
    end

    if chatTog then
        togMenu:AddButton({
            label = 'Chat',
            icon = '🔴'
        }):On("select", function ()
            chatTog = false
            TriggerEvent("Chat:Tog", false)
            MenuV:CloseAll()
        end)
    else
        togMenu:AddButton({
            label = 'Chat',
            icon = '🟢'
        }):On("select", function ()
            chatTog = true
            TriggerEvent("Chat:Tog", true)
            MenuV:CloseAll()
        end)
    end

    if hudTog then
        togMenu:AddButton({
            label = 'Hud',
            icon = '🔴'
        }):On("select", function ()
            hudTog = false
            TriggerEvent("Hud:Tog", hudTog)
            MenuV:CloseAll()
        end)
    else
        togMenu:AddButton({
            label = 'Hud',
            icon = '🟢'
        }):On("select", function ()
            hudTog = true
            TriggerEvent("Hud:Tog", hudTog)
            MenuV:CloseAll()
        end)
    end

    if not togRadar then
        togMenu:AddButton({
            label = 'Radar',
            icon = '🔴'
        }):On("select", function ()
            togRadar = true
            DisplayRadar(not togRadar)
            MenuV:CloseAll()
        end)
    else
        togMenu:AddButton({
            label = 'Radar',
            icon = '🟢'
        }):On("select", function ()
            togRadar = false
            DisplayRadar(not togRadar)
            MenuV:CloseAll()
        end)
    end
    MenuV:OpenMenu(togMenu)
end)

RegisterNetEvent("Notify:Send", function(title, msg, type)
    sendNotification(title, msg, type)
end)

RegisterNetEvent("Ped:Change", function(id)
    local pedId = tonumber(id)
    

    local hash = GetHashKey(Peds[pedId])
    local n = 0

    local model = Peds[pedId]
    if IsModelInCdimage(model) and IsModelValid(model) then
      RequestModel(model)
      while not HasModelLoaded(model) do
        Wait(0)
      end
      SetPlayerModel(PlayerId(), model)
      SetModelAsNoLongerNeeded(model)
    end
    ExecuteCommand('fixskin')
    Core.TriggerCallback('Clothing:GetClothing', function(cb)
        LoadPed(cb)
    end)
end)
local density = 0.0 -- Anything between 0.0 and 1.0 is a valid density, anything lower/higher is pointless
Citizen.CreateThread(function()
	while true do
	    Citizen.Wait(0)
	    SetVehicleDensityMultiplierThisFrame(density)
	    SetPedDensityMultiplierThisFrame(0.4)
	    SetRandomVehicleDensityMultiplierThisFrame(density)
	    SetParkedVehicleDensityMultiplierThisFrame(0.4)
	    SetScenarioPedDensityMultiplierThisFrame(0.4, 0.4)
	end
end)
Citizen.CreateThread(function()
    while true do
        Wait(1)
        local coords = GetEntityCoords(PlayerPedId())
        local distance = #(coords - vector3(1829.4066162109, 3681.0725097656, 34.334838867188))
        if distance < 3.0 then
            DrawMarker(0, 1829.4066162109, 3681.0725097656, 34.334838867188, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 209, 82, 255, true, false, false, true, false, false, false)
            DrawText3D(1829.4066162109, 3681.0725097656, 34.334838867188, "~y~Identitate~n~~w~Aici iti poti seta identitatea caracterului.~n~~y~(~w~/identitate~y~)~w~")
        end
    end
end)

RegisterCommand('identitate', function ()
    local distance = #(GetEntityCoords(PlayerPedId()) - vec3(1829.4066162109, 3681.0725097656, 34.334838867188))
    if distance < 4 then
        TriggerEvent('Identity:OpenSetup')
    else
        sendNotification("Identitate", "Nu esti la locul unde trebuie sa folosesti aceasta comanda.", 'error')
    end
end)

RegisterCommand('stats', function()
    local statsMsg = [[
       
       ^0Username: ^3%s^0 | Level: ^3%s^0 | Job: ^3%s^0 | Job Rank: ^3%s^0 | Nume: ^3%s^0 | Prenume: ^3%s^0
        Cash: $^3%s^0 | Bani in banca: $^3%s^0 | Wanted Level: ^3%s^0 | Admin Level: ^3%s^0
        Ped Model: ^3%s^0 | Identifier: ^3%s^0 
    ]]
    statsMsg = statsMsg:format(PlayerData.user, PlayerData.level, PlayerData.job.name, PlayerData.job.rank, PlayerData.character.name, PlayerData.character.surname, PlayerData.cash, PlayerData.bank, PlayerData.wantedLevel, PlayerData.adminLevel, PlayerData.character.ped_model, PlayerData.identifier)

    TriggerEvent('chatMessage', "", { 255, 255, 255 }, statsMsg)
end)

RegisterCommand('getjob', function()
    TriggerEvent("Jobs:Check")
end)

AddEventHandler('playerSpawned', PlayerSpawned)