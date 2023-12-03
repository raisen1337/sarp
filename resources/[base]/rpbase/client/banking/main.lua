

OpenBank = function()
    TriggerScreenblurFadeIn(1)
    if PlayerData.totalDeposited == nil then
        PlayerData.totalDeposited = 0
    end
    if PlayerData.totalTransferred == nil then
        PlayerData.totalTransferred = 0
    end
    if PlayerData.totalWithdrawn == nil then
        PlayerData.totalWithdrawn = 0
    end

    SendNUIMessage({
        action = "openBanking",
        data = {
            playerCash = PlayerData.cash,
            playerBank = PlayerData.bank,
            playerBankId = PlayerData.bankId ,
            playerName = PlayerData.character.name.." "..PlayerData.character.surname or 'Nume Prenume',
            transactions = PlayerData.transactions or {},
            totalTransferred = PlayerData.totalTransferred,
            totalWithdrawn = PlayerData.totalWithdrawn,
            totalDeposited = PlayerData.totalDeposited,
        }
    })

    SetNuiFocus(true, true)
end

RegisterCommand('bank',function ()
    OpenBank()
end)

RegisterNUICallback('closeBank', function()
    TriggerScreenblurFadeOut(1)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('keepFocus', function()
    SetNuiFocus(true, true)
end)

local atmProps = {
    'prop_atm_01',
    'prop_atm_02',
    'prop_atm_03',
    'prop_fleeca_atm',
}

local atmBlips = {}
local atms = {}

local closestAtm = nil
-- Citizen.CreateThread(function ()
--     while true do
--         local wait = 3000
--         local pPos = GetEntityCoords(PlayerPedId())
--         for k,v in pairs(atmProps) do
--             local atm = GetClosestObjectOfType(pPos.x, pPos.y, pPos.z, 6000.0, GetHashKey(v), false, false, false)
--             if atm ~= 0 then
--                 if not table.empty(atms) then
--                     for _, at in pairs(atms) do
--                         if at == atm then
--                             break
--                         else
--                             table.insert(atms, atm)
--                         end
--                     end
--                 else
--                     table.insert(atms, atm)
--                 end
--                 if not table.empty(atmBlips) then
--                     for _, bp in pairs(atmBlips) do
--                         if not DoesBlipExist(bp) then
--                             table.clear(atmBlips) -- Clear existing blips
--                             break
--                         end
--                     end
--                 end

--                 for _, atm in pairs(atms) do
--                     local blipExists = false
--                     for _, bp in pairs(atmBlips) do
--                         if DoesBlipExist(bp) and GetBlipCoords(bp) == GetEntityCoords(atm) then
--                             blipExists = true
--                             break
--                         end
--                     end

--                     if not blipExists then
--                         local blip = CreateBlip(GetEntityCoords(atm), "ATM", 207, 2)
--                         table.insert(atmBlips, blip)
--                     end
--                 end
--             end
--         end
        
--         Wait(wait)
--     end
   
-- end)

-- Citizen.CreateThread(function ()
--     while true do
--         local wait = 3000
--         if not table.empty(atms) then
--             local playerPed = PlayerPedId()
--             local playerCoords = GetEntityCoords(playerPed)
--             for _, atm in pairs(atms) do
--                 local atmCoords = GetEntityCoords(atm)
--                 local distance = #(playerCoords - atmCoords)
--                 if distance < 2.0 then
--                     closestAtm = atm
--                 end
--             end
--         end

--         if closestAtm ~= nil then
--             local playerPed = PlayerPedId()
--             local playerCoords = GetEntityCoords(playerPed)
--             local atmCoords = GetEntityCoords(closestAtm)
--             local distance = #(playerCoords - atmCoords)
--             if distance < 2.0 then
--                 wait = 1
--                 DrawText3D(atmCoords.x, atmCoords.y, atmCoords.z + 1, "[~g~Bancomat~w~]~n~Apasa ~g~[E]~w~ pentru a accesa bancomatul")
--                 if IsControlJustPressed(0, 38) then
--                     OpenBank()
--                 end
--             end
--         end
--         Wait(wait)
--     end
-- end)

RegisterNUICallback('tryTransaction', function(data)
    -- print(je(data))
    Core.TriggerCallback("Banking:TryTransaction", function(cb)
        if cb == true then
            Wait(300)
            Core.TriggerCallback('Player:GetData', function(PlayerData)
                if PlayerData.totalDeposited == nil then
                    PlayerData.totalDeposited = 0
                end
                if PlayerData.totalTransferred == nil then
                    PlayerData.totalTransferred = 0
                end
                if PlayerData.totalWithdrawn == nil then
                    PlayerData.totalWithdrawn = 0
                end
                --print
                SendNUIMessage({
                    action = "updateBanking",
                    data = {
                        playerCash = PlayerData.cash,
                        playerBank = PlayerData.bank,
                        playerBankId = PlayerData.bankId ,
                        playerName = PlayerData.character.name.." "..PlayerData.character.surname or 'Nume Prenume',
                        transactions = PlayerData.transactions or {},
                        totalTransferred = PlayerData.totalTransferred,
                        totalWithdrawn = PlayerData.totalWithdrawn,
                        totalDeposited = PlayerData.totalDeposited,
                    }
                })
            end)
        else
            sendNotification('Eroare', cb.error, 'error')
        end
    end, data)
end)
