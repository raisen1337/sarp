

RegisterCommand('test', function()
    --print
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
    --print

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
end)

RegisterNUICallback('closeBank', function()
    TriggerScreenblurFadeOut(1)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('keepFocus', function()
    SetNuiFocus(true, true)
end)

RegisterNUICallback('tryTransaction', function(data)
    print(je(data))
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
