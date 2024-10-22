Core.CreateCallback('Factions:GetFactions', function(source, cb)
    cb(factions)
end)

Core.CreateCallback('Factions:GetFaction', function(source, cb, fName)
    if factions[fName] then
        cb(factions[fName])
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:GetFactionRanks', function(source, cb, fName)
    if factions[fName] then
        cb(factions[fName].ranks)
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:GetFactionId', function(source, cb, fName)
    if factions[fName] then
        cb(factions[fName].id)
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:GetVehicles', function(source, cb, fName)
    if factions[fName] then
        cb(factions[fName].vehicles)
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:GetFactionRankSalary', function(source, cb, fName, fRank)
    if factions[fName] then
        cb(factions[fName].ranks[fRank].salary)
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:GetFactionRankName', function(source, cb, fName, fRank)
    if factions[fName] then
        cb(factions[fName].ranks[fRank].name)
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:GetFactionRankColor', function(source, cb, fName, fRank)
    if factions[fName] then
        cb(factions[fName].ranks[fRank].color)
    else
        cb(false)
    end
end)


Core.CreateCallback('Factions:GetFactionMembers', function(source, cb, id)
    local result = exports.oxmysql:executeSync("SELECT * FROM players")
    if result[1] then
        local members = {}
        for k, v in pairs(result) do
            local pData = json.decode(v.data)
            local fData = pData.faction
            if fData and fData.id == id then
                table.insert(members, {
                    name = pData.user,
                    rankName = fData.rankName,
                    rank = fData.rank,
                    salary = factions[fData.name].ranks[fData.rank].salary,
                    identifier = v.identifier,
                    faction = fData,
                })
                cb(members)
            end
        end
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:KickMember', function(source, cb, identifier)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", { identifier })
    if result[1] then
        local pData = json.decode(result[1].data)
        local fData = pData.faction

        fData.id = 0
        fData.name = 'None'
        fData.rank = 0
        fData.rankName = 'None'
        fData.rankColor = 0
        pData.faction = fData

        exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?",
            { json.encode(pData), identifier })

        cb(true)
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:AddMember', function(source, cb, fName, identifier)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", { identifier })
    if result[1] then
        local pData = json.decode(result[1].data)
        local fData = pData.faction
        fData.name = factions[fName].name
        fData.id = factions[fName].id
        fData.rank = 1
        fData.rankColor = factions[fName].ranks[1].color
        fData.rankName = factions[fName].ranks[1].name
        fData.salary = factions[fName].ranks[1].salary

        pData.faction = fData

        exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?",
            { json.encode(pData), identifier })
        cb(true)
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:AddMemberWithRank', function(source, cb, fName, rank, identifier)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", { identifier })
    if not factions[fName].ranks[rank] then
        cb(false)
        return
    end
    if result[1] then
        local pData = json.decode(result[1].data)
        local fData = pData.faction
        fData.name = factions[fName].name
        fData.id = factions[fName].id
        fData.rank = rank
        fData.rankColor = factions[fName].ranks[rank].color
        fData.rankName = factions[fName].ranks[rank].rank
        fData.salary = factions[fName].ranks[rank].salary

        pData.faction = fData

        exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?",
            { json.encode(pData), identifier })
        cb(true)
    else
        cb(false)
    end
end)

Core.CreateCallback('EMS:Heal', function(source, cb, player)
    local Player = Core.GetPlayerData(player)

    if Player.dead then
        Player.dead = false
        TriggerClientEvent("Notify:Send", player, "EMS", "Ai fost tratat de catre un medic!", "success")
        TriggerClientEvent('Player:UpdateData', player, Player)
        exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?",
            { json.encode(Player), Player.identifier })

        cb(true)
    else
        cb(true)
    end
end)

Core.CreateCallback('Factions:RemoveMember', function(source, cb, identifier)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", { identifier })
    if result[1] then
        local pData = json.decode(result[1].data)
        local fData = pData.faction

        fData.name = 'None'
        fData.id = 0
        fData.rank = 0
        fData.rankName = 'None'

        pData.faction = fData

        exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?",
            { json.encode(pData), identifier })
        cb(true)
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:DemoteMember', function(source, cb, identifier)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", { identifier })
    if result[1] then
        local pData = json.decode(result[1].data)
        if factions[pData.faction.name].ranks[pData.faction.rank - 1] then
            pData.faction.rank = pData.faction.rank - 1
            pData.faction.rank = tonumber(pData.faction.rank)
            for k, v in pairs(factions[pData.faction.name].ranks) do
                if v.id == pData.faction.rank then
                    pData.faction.rankName = v.rank
                    pData.faction.salary = v.salary
                    pData.faction.rankColor = v.color
                end
            end
            exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?",
                { json.encode(pData), identifier })
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:PromoteMember', function(source, cb, identifier)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", { identifier })
    if result[1] then
        local pData = json.decode(result[1].data)
        local fData = pData.faction

        if factions[fData.name].ranks[fData.rank + 1] then
            fData.rank = fData.rank + 1
            for k, v in pairs(factions[fData.name].ranks) do
                if v.id == fData.rank then
                    fData.rankName = v.rank
                    fData.salary = v.salary
                    fData.rankColor = v.color
                end
            end
            pData.faction = fData

            exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?",
                { json.encode(pData), identifier })
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)
