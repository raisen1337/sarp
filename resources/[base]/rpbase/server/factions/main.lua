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
        for k,v in pairs(result) do
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

Core.CreateCallback('Factions:KickMember', function(source, cb, id, identifier)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {identifier})
    if result[1] then
        local pData = json.decode(result[1].data)
        local fData = pData.faction
        if fData and fData.id == id then

            fData.id = 0
            fData.name = 'None'
            fData.rank = 0
            fData.rankName = 'None'
            fData.rankColor = 0
            pData.faction = fData
            
            exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), identifier})
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:AddMember', function(source, cb, fName, identifier)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {identifier})
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

        exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), identifier})
        cb(true)
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:AddMemberWithRank', function(source, cb, fName, rank, identifier)
    print('AddMemberWithRank', fName, rank, identifier)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {identifier})
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

        exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), identifier})
        cb(true)
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:RemoveMember', function(source, cb, identifier)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {identifier})
    if result[1] then
        local pData = json.decode(result[1].data)
        local fData = pData.faction

        fData.name = 'None'
        fData.id = 0
        fData.rank = 0
        fData.rankName = 'None'

        pData.faction = fData

        exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), identifier})
        cb(true)
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:DemoteMember', function(source, cb, identifier)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {identifier})
    if result[1] then
        local pData = json.decode(result[1].data)
        local fData = pData.faction
        if factions[fData.name].ranks[fData.rank - 1] then
            fData.rank = fData.rank - 1
            fData.rankName = factions[fData.name].ranks[fData.rank].name
            fData.salary = factions[fData.name].ranks[fData.rank].salary
            fData.rankColor = factions[fData.name].ranks[fData.rank].color
            pData.faction = fData

            exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), identifier})
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

Core.CreateCallback('Factions:PromoteMember', function(source, cb, identifier)
    local result = exports.oxmysql:executeSync("SELECT * FROM players WHERE identifier = ?", {identifier})
    if result[1] then
        local pData = json.decode(result[1].data)
        local fData = pData.faction

        if factions[fData.name].ranks[fData.rank + 1] then
            fData.rank = fData.rank + 1
            fData.rankName = factions[fData.name].ranks[fData.rank].name
            fData.salary = factions[fData.name].ranks[fData.rank].salary
            fData.rankColor = factions[fData.name].ranks[fData.rank].color
            pData.faction = fData
    
            exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), identifier})
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

