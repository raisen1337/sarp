Core.CreateCallback('Banking:TryTransaction', function(source, cb, transaction)
    if not tonumber(transaction.amount) or tonumber(transaction.amount) < 0 then
        cb({
            error = 'Marlane ce incerci sa faci?'
        })
        return
    end
    print(je(transaction))
    transaction.amount = tonumber(transaction.amount)
    local src = source
    local PlayerData = Core.GetPlayerData(src)
    if transaction.type == 'withdraw' then
        if PlayerData.bank >= transaction.amount then
            PlayerData.bank = PlayerData.bank - transaction.amount
            PlayerData.cash = PlayerData.cash + transaction.amount
            if PlayerData.totalDeposited == nil then
                PlayerData.totalDeposited = 0
            end
            if PlayerData.totalTransferred == nil then
                PlayerData.totalTransferred = 0
            end
            if PlayerData.totalWithdrawn == nil then
                PlayerData.totalWithdrawn = 0
            end
            PlayerData.totalWithdrawn = PlayerData.totalWithdrawn + transaction.amount
            if PlayerData.transactions then
                table.insert(PlayerData.transactions, {
                    recipientId = 0,
                    recipient = PlayerData.character.name..' '..PlayerData.character.surname,
                    amount = transaction.amount
                })
            else
                PlayerData.transactions = {}
                table.insert(PlayerData.transactions, {
                    recipientId = 0,
                    recipient = PlayerData.character.name..' '..PlayerData.character.surname,
                    amount = transaction.amount
                })
            end
            exports.oxmysql:executeSync('UPDATE players SET data = ? WHERE identifier = ?', {je(PlayerData), PlayerData.identifier})
            cb(true)
        else
            cb({
                error = 'Nu ai atatia bani in banca.'
            })
        end
    else
        if transaction.type == 'deposit' then
            if PlayerData.cash >= transaction.amount then
                PlayerData.cash = PlayerData.cash - transaction.amount
                PlayerData.bank = PlayerData.bank + transaction.amount
                if PlayerData.totalDeposited == nil then
                    PlayerData.totalDeposited = 0
                end
                if PlayerData.totalTransferred == nil then
                    PlayerData.totalTransferred = 0
                end
                if PlayerData.totalWithdrawn == nil then
                    PlayerData.totalWithdrawn = 0
                end
                PlayerData.totalDeposited = PlayerData.totalDeposited + transaction.amount
                if PlayerData.transactions then
                    table.insert(PlayerData.transactions, {
                        recipientId = PlayerData.bankId,
                        recipient = PlayerData.character.name..' '..PlayerData.character.surname,
                        amount = transaction.amount
                    })
                else
                    PlayerData.transactions = {}
                    table.insert(PlayerData.transactions, {
                        recipientId = PlayerData.bankId,
                        recipient = PlayerData.character.name..' '..PlayerData.character.surname,
                        amount = transaction.amount
                    })
                end
                exports.oxmysql:executeSync('UPDATE players SET data = ? WHERE identifier = ?', {je(PlayerData), PlayerData.identifier})
                cb(true)
            else
                cb({
                    error = 'Nu ai atatia bani in mana.'
                })
            end
        else
            if transaction.type == 'transfer' then
                if tonumber(PlayerData.bankId) == tonumber(transaction.recipient) then
                    cb({
                        error = 'Nu iti poti transfera tie banii.'
                    })
                    return
                end
                transaction.recipient = tonumber(transaction.recipient)
                print(transaction.recipient, type(transaction.recipient))
                local recipientData = Core.GetPlayerByBankId(transaction.recipient)
                if recipientData then
                    if PlayerData.bank >= transaction.amount then
                        PlayerData.bank = PlayerData.bank - transaction.amount
                        if PlayerData.totalDeposited == nil then
                            PlayerData.totalDeposited = 0
                        end
                        if PlayerData.totalTransferred == nil then
                            PlayerData.totalTransferred = 0
                        end
                        if PlayerData.totalWithdrawn == nil then
                            PlayerData.totalWithdrawn = 0
                        end
                        PlayerData.totalTransferred = PlayerData.totalTransferred + transaction.amount
                        recipientData.bank = recipientData.bank + transaction.amount

                        if PlayerData.transactions then
                            table.insert(PlayerData.transactions, {
                                recipientId = recipientData.bankId,
                                recipient = recipientData.character.name..' '..recipientData.character.surname,
                                amount = transaction.amount
                            })
                        else
                            PlayerData.transactions = {}
                            table.insert(PlayerData.transactions, {
                                recipientId = recipientData.bankId,
                                recipient = recipientData.character.name..' '..recipientData.character.surname,
                                amount = transaction.amount
                            })
                        end

                        if recipientData.transactions then
                            table.insert(recipientData.transactions, {
                                recipientId = recipientData.bankId,
                                recipient = PlayerData.character.name..' '..PlayerData.character.surname,
                                amount = transaction.amount
                            })
                        else
                            recipientData.transactions = {}
                            table.insert(recipientData.transactions, {
                                recipientId = recipientData.bankId,
                                recipient = PlayerData.character.name..' '..PlayerData.character.surname,
                                amount = transaction.amount
                            })
                        end
                        
                        exports.oxmysql:executeSync('UPDATE players SET data = ? WHERE identifier = ?', {je(recipientData), recipientData.identifier})
                        exports.oxmysql:executeSync('UPDATE players SET data = ? WHERE identifier = ?', {je(PlayerData), PlayerData.identifier})
                        cb(true)
                    else
                        cb({
                            error = 'Nu ai atatia bani in banca.'
                        })
                    end
                else
                    cb({
                        error = 'Nu s-a gasit niciun destinatar'
                    })
                end
            end
        end
    end
end)

Core.GetPlayerByBankId = function(bid)
    bid = tonumber(bid)
    local result = exports.oxmysql:executeSync("SELECT * FROM players")
    if #result ~= 0 then
        for k,v in pairs(result) do
            local pData = jd(v.data)
            print(pData.bankId, bid, pData.bankId == bid, type(bid), type(pData.bankId))
            if pData.bankId == bid then
                return pData
            end
        end
    end
    return false
end