local attacks = {}

Core.CreateCallback('Turfs:GetTurfById', function(source, cb, id)
    local src = source
    local turf = Core.GetTurfById(id)

    if turf then
        cb(turf)
    else
        cb(nil)
    end
end)

Core.GetTurfById = function(id)
    local turf = exports.oxmysql:executeSync("SELECT * FROM turfs WHERE id = ?",{id})
    if turf then
        return turf
    end
    return false
end

Core.CreateCallback('Turfs:CreateTurf', function(source, cb, data)
    local src = source
    
    local turf = Core.CreateTurf(data)
    if turf then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'^1[TURFS]^0: Ai creat un turf pentru: '..data.mafia..'!'}
        })
        cb(true)
    else
        TriggerClientEvent('chat:addMessage', src, {
            args = {'^1[TURFS]^0: Nu s-a putut crea un turf pentru: '..data.mafia..'!'}
        })
        --print('[SERVER]: Nu s-a putut crea un turf pentru: '..data.mafia..'!')
        cb(false)
    end
    local turfs = Core.GetAllTurfs()
    if turfs then
        TriggerClientEvent("Turf:Reload", -1, turfs)
    end
end)

Core.CreateCallback('Turfs:DeleteTurf', function(source, cb, id)
    local src = source
    local turf = Core.DeleteTurf(id)
    if turf then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'^1[TURFS]^0: Ai sters un turf cu id-ul: '..id..'!'}
        })
        cb(true)
        return
    else
        TriggerClientEvent('chat:addMessage', src, {
            args = {'^1[TURFS]^0: Nu s-a putut sterge un turf cu id-ul: '..id..'!'}
        })
        --print('[SERVER]: Nu s-a putut sterge un turf cu id-ul: '..id..'!')
        cb(false)
    end
    local turfs = Core.GetAllTurfs()
    if turfs then
        TriggerClientEvent("Turf:Reload", -1, turfs)
    end
end)

Core.CreateCallback('Turfs:DeleteAllTurfs', function(source, cb)
    local src = source
    local turf = Core.DeleteAllTurfs()
    if turf then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'^1[TURFS]^0: Ai sters toate turf-urile!'}
        })
        cb(true)
        return
    else
        TriggerClientEvent('chat:addMessage', src, {
            args = {'^1[TURFS]^0: Nu s-au putut sterge toate turf-urile!'}
        })
        --print('[SERVER]: Nu s-au putut sterge toate turf-urile!')
        cb(false)
    end
    local turfs = Core.GetAllTurfs()
    if turfs then
        TriggerClientEvent("Turf:Reload", -1, turfs)
    end
end)

RegisterNetEvent("Turf:Reload", function()
    local src = source
    local turfs = Core.GetAllTurfs()
    if turfs then
        TriggerClientEvent("Turf:Reload", -1, turfs)
    end
end)

Core.CreateCallback('Turfs:IsAttacked', function(source, cb, id)
    local src = source
    local turf = Core.IsAttacked(id)
    if turf then
        cb(turf)
    else
        cb(nil)
    end
end)

Core.IsAttacked = function(id)
    if not table.empty(attacks) then
        for k,v in pairs(attacks) do
            if k == id then
                --print('Turf '..id..' is attacked')
                return v
            end
        end
    end
    return false
end

Core.CreateCallback('Turf:IsOwnedByTeam', function(source, cb, id, team)
    local src = source
    local turf = Core.IsOwnedByTeam(id, team)
    if turf then
        cb(turf)
    else
        cb(nil)
    end
end)

Core.IsOwnedByTeam = function(id, team)
    local turf = exports.oxmysql:executeSync("SELECT * FROM turfs WHERE id = ?",{id})
    if turf then
        local turf = turf[1]
        if turf.owned == team then
            return true
        end
    end
    return false
end

Core.CreateCallback('Turfs:GetAttackData', function(source, cb, id)
    local src = source
    local turf = Core.GetAttackData(id)
    if turf then
        cb(turf)
    else
        cb(nil)
    end
end)

function Core.GetAttackData(id)
    if not table.empty(attacks) then
        for k,v in pairs(attacks) do
            if k == id then
                return v
            end
        end
    end
    return false
end

Core.CreateCallback('Turf:GetAllKills', function(source, cb, teamA, teamB)
    local kills = {
        attackers = 0,
        defenders = 0
    }
    if not table.empty(attacks) then
       local attackersKills = 0
       local defendersKills = 0
        for k,v in pairs(attacks) do
            if v.attacker == teamA then
                for k,v in pairs(v.attackers) do
                    attackersKills = attackersKills + v.kills
                end
            elseif v.defender == teamA then
                for k,v in pairs(v.defenders) do
                    attackersKills = attackersKills + v.kills
                end
            end
            if v.attacker == teamB then
                for k,v in pairs(v.attackers) do
                    defendersKills = defendersKills + v.kills
                end
            elseif v.defender == teamB then
                for k,v in pairs(v.defenders) do
                    defendersKills = defendersKills + v.kills
                end
            end
        end
        kills.attackers = attackersKills
        kills.defenders = defendersKills
    end
    print(je(kills))
    cb(kills)
end)

Core.CreateCallback('Turfs:GetAttacks', function(source, cb)
    cb(attacks)
end)

Core.CreateCallback('Turfs:PlayerKilled', function(source, cb, killerId)
    local src = source
    local pData = Core.GetPlayerData(src)

    local fData = pData.faction
    local fCoords = factions[fData.name].coords

    SetEntityCoords(GetPlayerPed(src), fCoords.main.x, fCoords.main.y, fCoords.main.z)
    pData.dead = false
    if killerId == -1 then
        TriggerClientEvent('Turfs:AddKill', -1, GetPlayerName(src), GetPlayerName(src))
    else
        TriggerClientEvent('Turfs:AddKill', -1, GetPlayerName(src), GetPlayerName(killerId))
    end
    exports.oxmysql:execute('UPDATE players SET data = ? WHERE identifier = ?', {je(pData), pData.identifier})
    if attacks and not table.empty(attacks) then
        for _, v in pairs(attacks) do
            if v.attacked then
                if killerId == -1 then
                    if Core.GetPlayerData(src).faction.name == v.attacker then
                        for _, defender in pairs(v.defenders) do
                            defender.kills = defender.kills + 1
                            --print('DKills: '..defender.kills)
                            cb(true)
                            return
                        end
                    else
                        for _, attacker in pairs(v.attackers) do
                            attacker.kills = attacker.kills + 1
                            --print('AKills: '..attacker.kills)
                            cb(true)
                            return
                        end
                    end
                else
                    for _, attacker in pairs(v.attackers) do
                        if attacker.src == killerId then
                            attacker.kills = attacker.kills + 1
                            --print('AKills: '..attacker.kills)
                            cb(true)
                            return
                        end
                    end
                    for _, defender in pairs(v.defenders) do
                        if defender.src == killerId then
                            defender.kills = defender.kills + 1
                            --print('DKills: '..defender.kills)
                            cb(true)
                            return
                        end
                    end
                end
            end
        end
    end
end)

Core.AttackTurf = function(id, team)
    
    local turf = Core.GetTurfById(id)
    turf = json.decode(turf[1].data)
    
    local returnInfo = "Turf attacked"
    local returnType = 'success'
    if turf.mafia == team then
       returnInfo = "Turf already owned."
       returnType = 'error'
       return returnInfo, returnType
    end

    if turf.attack then
        returnInfo = "Turf already attacked."
        returnType = 'error'
        return returnInfo, returnType
    end

    local players = GetPlayers()
    local defenders = 0
    for k,v in pairs(players) do
        local src = v
        if Core.IsPlayerInTurfGang(src, turf.mafia) then
            defenders = defenders + 1
        end
    end

   
    attacks[id] = {
        id = id,
        attacker = team,
        turf = turf,
        attacked = true,
        time = 15,
        defender = turf.mafia,
        defenders = {},
        attackers = {}
    }

    for k,v in pairs(players) do
        local src = v
       
        if Core.IsPlayerInTurfGang(src, team) then
            table.insert(attacks[id].attackers, {
                src = src,
                team = team,
                kills = 0,
            })
            --print('Inserted '..GetPlayerName(src)..' in attackers')
            TriggerClientEvent("Turfs:AttackTurf", src, id, team, attacks[id])
        end
    end

    for k,v in pairs(players) do
        local src = v
        if Core.IsPlayerInTurfGang(src, turf.mafia) then
            table.insert(attacks[id].defenders, {
                src = src,
                team = turf.mafia,
                kills = 0,
            })
            --print('Inserted '..GetPlayerName(src)..' in defenders')
            TriggerClientEvent("Turfs:AttackTurf", src, id, team, attacks[id])
        end
    end

    turf.attack = true

    Core.UpdateTurf(id, turf)


    local turfs = Core.GetAllTurfs()
    if turfs then
        TriggerClientEvent("Turf:Reload", -1, turfs)
    end
    return returnInfo, returnType
end

-- Citizen.CreateThread(function ()
--     while true do
--         Wait(2000)
--         for k,v in pairs(attacks) do
--             if v.attacked then
--                 print(je(v))
--             end
--         end
--     end
-- end)

Core.GetTurfTime = function(id)
    if not table.empty(attacks) then
        for k,v in pairs(attacks) do
            if k == id then
                return v.time
            end
        end
    end
    return false
end

Core.GetTurfKills = function(id, team)
    if not table.empty(attacks) then
        for k,v in pairs(attacks) do
            if k == id then
                if v.attacker == team then
                    return v.attackers
                elseif v.defender == team then
                    return v.defenders
                end
            end
        end
    end
    return false
end

Core.GetTurfAttacker = function(id)
    if not table.empty(attacks) then
        for k,v in pairs(attacks) do
            if k == id then
                return v.attacker
            end
        end
    end
    return false
end

Core.GetTurfDefender = function(id)
    if not table.empty(attacks) then
        for k,v in pairs(attacks) do
            if k == id then
                return v.defender
            end
        end
    end
    return false
end

Core.IsPlayerInTurfGang = function(src, team)
    local pData = Core.GetPlayerData(src)
    local fData = pData.faction

    if fData ~= nil then
        if fData.name == team then
            return true
        end
    end
    return false
end

Core.CreateCallback('Turfs:GetTurfTime', function(source, cb, id)
    local src = source
    local time = Core.GetTurfTime(id)
    cb(time)
end)

Core.CreateCallback('Turfs:GetTurfKills', function(source, cb, id, team)
    local src = source
    local kills = Core.GetTurfKills(id, team)
    cb(kills)
end)

Core.CreateCallback('Turfs:GetTurfAttacker', function(source, cb, id)
    local src = source
    local attacker = Core.GetTurfAttacker(id)
    cb(attacker)
end)

Core.CreateCallback('Turfs:GetTurfDefender', function(source, cb, id)
    local src = source
    local defender = Core.GetTurfDefender(id)
    cb(defender)
end)

Core.CreateCallback('Turfs:IsPlayerInTurfGang', function(source, cb, src, team)
    local isInGang = Core.IsPlayerInTurfGang(src, team)
    cb(isInGang)
end)

Citizen.CreateThread(function ()
    while true do
        local wait = 1000
        Wait(wait)

        if not table.empty(attacks) then
            for k,v in pairs(attacks) do
                if v.time > 0 then
                    if v.time - 1 > 0 then
                        v.time = v.time - 1
                        for _, attacker in pairs(v.attackers) do
                            for _, src in pairs(GetPlayers()) do
                                if src == attacker.src then
                                    TriggerClientEvent('Turf:UpdateTime', src, k, v.time)
                                end
                            end
                        end
                        for _, defender in pairs(v.defenders) do
                            for _, src in pairs(GetPlayers()) do
                                if src == defender.src then
                                    TriggerClientEvent('Turf:UpdateTime', src, k, v.time)
                                end
                            end
                        end
                    elseif v.time - 1 <= 0 then
                        v.time = 0
                        local kills = {
                            attackers = 0,
                            defenders = 0
                        }
                        for _, attacker in pairs(v.attackers) do
                            for _, src in pairs(GetPlayers()) do
                                kills.attackers = kills.attackers + attacker.kills
                                if src == attacker.src then
                                    TriggerClientEvent('Turf:UpdateTime', src, k, v.time)
                                end
                            end
                        end
                        for _, defender in pairs(v.defenders) do
                            for _, src in pairs(GetPlayers()) do
                                kills.defenders = kills.defenders + defender.kills
                                if src == defender.src then
                                    TriggerClientEvent('Turf:UpdateTime', src, k, v.time)
                                end
                            end
                        end
                        if kills.defenders > kills.attackers then
                            --defenders win
                            local turf = Core.GetTurfById(k)
                            turf = json.decode(turf[1].data)
                            turf.mafia = v.defender
                            turf.attack = false
                            turf.time = 0
                            turf.kills = kills
                            turf = je(turf)
                            Core.UpdateTurf(k, turf)
                            TriggerClientEvent('Turf:AttackEnded', -1, turf.id)
                            TriggerClientEvent('chat:addMessage', -1, {
                                args = {'^1[TURFS]^0: Turful '..k..' a fost castigat de '..v.defender..'!'}
                            })
                            print('[SERVER]: Turful '..k..' a fost castigat de '..v.defender..'!')
                            attacks[k] = nil
                        elseif kills.defenders < kills.attackers then
                            --attackers win
                            local turf = Core.GetTurfById(k)
                            turf = json.decode(turf[1].data)
                            turf.mafia = v.attacker
                            turf.attack = false
                            Core.UpdateTurf(k, turf)
                            TriggerClientEvent('Turf:AttackEnded', -1, turf.id)
                            TriggerClientEvent('chat:addMessage', -1, {
                                args = {'^1[TURFS]^0: Turful '..k..' a fost castigat de '..v.attacker..'!'}
                            })
                            print('[SERVER]: Turful '..k..' a fost castigat de '..v.attacker..'!')
                            attacks[k] = nil
                        elseif kills.defenders == kills.attackers then
                            --draw
                            local turf = Core.GetTurfById(k)
                            turf = json.decode(turf[1].data)
                            turf.attack = false
                            Core.UpdateTurf(k, turf)
                            TriggerClientEvent('Turf:AttackEnded', -1, turf.id)
                            TriggerClientEvent('chat:addMessage', -1, {
                                args = {'^1[TURFS]^0: Turful '..k..' a fost egal!'}
                            })
                            print('[SERVER]: Turful '..k..' a fost egal!')
                            attacks[k] = nil
                        end
                    end
                end
            end
        end
    end
end)

Core.CreateCallback('Turfs:AttackTurf', function(source, cb, id, team)
    local src = source
    local a = false
    local turf, error = Core.AttackTurf(id, team)
    
    if not error == 'error' then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'^1[TURFS]^0: '..turf..' ['..id..']!'}
        })
        a = true
        cb(true)
        return
    else
        TriggerClientEvent('chat:addMessage', src, {
            args = {'^1[TURFS]^0: '..turf..' ['..id..']!'}
        })
        a = false
        cb(false)
        return
    end
end)



Core.DeleteAllTurfs = function()
    local turf = exports.oxmysql:executeSync("DELETE FROM turfs")
    if turf then
        return turf
    end
    return false
end

Core.DeleteTurf = function(id)
    local turf = exports.oxmysql:executeSync("DELETE FROM turfs WHERE id = ?",{id})
    if turf then
        return turf
    end
    return false
end

Core.CreateCallback('Turfs:GetAllTurfs', function(source, cb)
    local src = source
    local turfs = Core.GetAllTurfs()
    if turfs then
        cb(turfs)
    else
        cb(nil)
    end
end)

Core.GetAllTurfs = function()
    local result = exports.oxmysql:executeSync("SELECT * FROM turfs")
    
    if result then
        return result
    else
        return nil
    end
    return false
end

--onResourceStop

Core.CreateCallback('Turfs:StopAttacks', function(source, cb)
    local src = source
    local turf = Core.StopAttacks()
    if turf then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'^1[TURFS]^0: Ai oprit toate atacurile!'}
        })
        cb(true)
        return
    else
        TriggerClientEvent('chat:addMessage', src, {
            args = {'^1[TURFS]^0: Nu s-au putut opri toate atacurile!'}
        })
        --print('[SERVER]: Nu s-au putut opri toate atacurile!')
        cb(false)
    end
end)

Core.StopAttacks = function()
    attacks = {}
 
    local turfs = Core.GetAllTurfs()
    for k,v in pairs(turfs) do
        local turf = json.decode(v.data)
        turf.attack = false
        Core.UpdateTurf(v.id, turf)
    end
    return true
end

Core.CreateCallback('Turfs:IsKillerInAttack', function(source, cb, id)
    local src = source
    local turf = Core.IsKillerInAttack(id)
    
    if turf then
        cb(turf)
    else
        cb(nil)
    end
end)

Core.CreateCallback('Turf:AddScore', function(source, cb, faction, turf, score)
    local src = source
    local turf = Core.TurfAddScore(faction, turf, score)
    if turf then
        cb(turf)
    else
        cb(nil)
    end
end)

Core.CreateCallback('Turf:GetMafiaKills', function(source, cb, faction)
    local src = source
    local turf = Core.GetMafiaKills(faction)
    if turf then
        cb(turf)
    else
        cb(nil)
    end
end)

Core.GetMafiaKills = function(faction)
    print(faction)
    local kills = 0
    if not table.empty(attacks) then
        for _, attack in pairs(attacks) do
            if attack.defender == faction then
                for k,v in pairs(attack.defenders) do
                    kills = kills + v.kills
                end
            else
                for k,v in pairs(attack.attackers) do
                    kills = kills + v.kills
                end
            end
        end
    end
    print(kills)
    return kills
end

Core.TurfAddScore = function(faction, turf, score)
    if attacks[turf] then
        if attacks[turf].attacker == faction then
            for k,v in pairs(attacks[turf].attackers) do
                if v.team == faction then
                    v.kills = v.kills + score
                end
            end
        elseif attacks[turf].defender == faction then
            for k,v in pairs(attacks[turf].defenders) do
                if v.team == faction then
                    v.kills = v.kills + score
                end
            end
        end
    end
end

Core.IsKillerInAttack = function(id)
    if not table.empty(attacks) then
        for k,v in pairs(attacks) do
            
            for k,v in pairs(v.attackers) do
                if v.src == id then
                    return Core.GetPlayerData(v.src)
                end
            end
        end
    end
    return false
end

Core.CreateCallback('Turfs:UpdateTurf', function(source, cb, id, data)
    local src = source
    local turf = Core.UpdateTurf(id, data)
    if turf then
        cb(true)
    else
        cb(false)
    end
end)

Core.UpdateTurf = function(id, data)
    local turf = exports.oxmysql:executeSync("UPDATE turfs SET data = ? WHERE id = ?", {je(data), id})
    --reload turfs
    local turfs = Core.GetAllTurfs()
    if turfs then
        TriggerClientEvent("Turf:Reload", -1, turfs)
    end
    return true
end

Core.CreateTurf = function(data)
    local result = exports.oxmysql:executeSync('SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = "turfs"')

    if result[1] then
        local nextAutoIncrement = result[1]['AUTO_INCREMENT']
        data.id = nextAutoIncrement
    else
        data.id = 1
    end

    exports.oxmysql:executeSync("INSERT INTO turfs(owned, data) VALUES(?, ?)", {data.mafia, json.encode(data)})
    return true
end