local adventGifts = {
    [1] = {
        type = 'economy',
        content = {
            ['cash'] = 20000,
            ['premiumPoints'] = 100,
        }
    },
    [2] = {
        type = 'economy',
        content = {
            ['cash'] = 50000,
            ['premiumPoints'] = 200,
        }
    },
    [3] = {
        type = 'economy',
        content = {
            ['cash'] = 23000,
            ['premiumPoints'] = 300,
        }
    },
    [4] = {
        type = 'economy',
        content = {
            ['cash'] = 10000,
            ['premiumPoints'] = 50,
        }
    },
    [5] = {
        type = 'economy',
        content = {
            ['cash'] = 30000,
           
        }
    },
    [6] = {
        type = 'economy',
        content = {
            ['cash'] = 15000,
            
        }
    },
    [7] = {
        type = 'economy',
        content = {
            ['cash'] = 15000,
            
        }
    },
    [8] = {
        type = 'economy',
        content = {
            ['cash'] = 40000,
           
        }
    },
    [9] = {
        type = 'economy',
        content = {
            ['cash'] = 15000,
            
        }
    },
    [10] = {
        type = 'economy',
        content = {
            ['cash'] = 25000,
            ['premiumPoints'] = 125,
        }
    },
    [11] = {
        type = 'economy',
        content = {
            ['cash'] = 60000,
            ['premiumPoints'] = 300,
        }
    },
    [12] = {
        type = 'economy',
        content = {
            ['cash'] = 60000,
            ['premiumPoints'] = 300,
        }
    },
    [13] = {
        type = 'economy',
        content = {
            ['cash'] = 20000,
            ['premiumPoints'] = 100,
        }
    },
    [14] = {
        type = 'economy',
        content = {
            ['cash'] = 50000,
            ['premiumPoints'] = 200,
        }
    },
    [15] = {
        type = 'economy',
        content = {
            ['cash'] = 10000,
            ['premiumPoints'] = 300,
        }
    },
    [16] = {
        type = 'economy',
        content = {
            ['cash'] = 10000,
            ['premiumPoints'] = 50,
        }
    },
    [17] = {
        type = 'economy',
        content = {
            ['cash'] = 30000,
            ['premiumPoints'] = 150,
        }
    },
    [18] = {
        type = 'economy',
        content = {
            ['cash'] = 70000,
            ['premiumPoints'] = 300,
        }
    },
    [19] = {
        type = 'economy',
        content = {
            ['cash'] = 15000,
            ['premiumPoints'] = 75,
        }
    },
    [20] = {
        type = 'economy',
        content = {
            ['cash'] = 40000,
            ['premiumPoints'] = 250,
        }
    },
    [21] = {
        type = 'economy',
        content = {
            ['cash'] = 30000,
            ['premiumPoints'] = 100,
        }
    },
    [22] = {
        type = 'economy',
        content = {
            ['cash'] = 25000,
            ['premiumPoints'] = 125,
        }
    },
    [23] = {
        type = 'economy',
        content = {
            ['cash'] = 60000,
            ['premiumPoints'] = 300,
        }
    },
    [24] = {
        type = 'vehicle',
        content = {
            spawncode = "sultanrs",
            model = "Sultan RS[Advent]",
        }
    }
}

Core.CreateCallback('Advent:GetGifts', function(source, cb)
    local currentDay = 1
    if tonumber(currentDay) < 1 or tonumber(currentDay) > 24 then
        TriggerClientEvent('Notify:Send', source, 'Advent Calendar', 'Advent calendarul poate fi deschis doar in intervalul 1-24 in fiecare luna.','error')
        cb(false)
        return
    end
    local gifts = {}
    local pData = Core.GetPlayerData(source)
    local pGifts
    if not pData.adventGifts then
        pData.adventGifts = {}
        pGifts = pData.adventGifts
    else
        pGifts = pData.adventGifts
    end
    
 
    for k,v in pairs(adventGifts) do
        v.id = k
        if tonumber(k) == tonumber(currentDay) then
            local hasGift = false
            for _, gift in pairs(pGifts) do
                if gift.id == k then
                    hasGift = true
                    break
                end
            end
            local giftContent = v.content
            v.content = false
            v.unlocked = not hasGift
            v.claimed = hasGift -- Add v.claimed to indicate if the gift has been claimed
            table.insert(gifts, v)
            v.content = giftContent
        else
            local giftContent = v.content
            v.content = false
            v.unlocked = false
            v.claimed = false -- Add v.claimed to indicate the gift has not been claimed
            table.insert(gifts, v)
            v.content = giftContent
        end
    end
    cb(gifts)
end)

Core.CreateCallback('Advent:OpenGift', function(source, cb, gift)
    local pData = Core.GetPlayerData(source)
    if not pData.adventGifts then
        pData.adventGifts = {}
    end
    local pGifts = pData.adventGifts
    local hasGift = false

    for _, gift in pairs(pGifts) do
        if gift.id == gift then
            hasGift = true
            break
        end
    end
   
    if not hasGift then
        if adventGifts[gift].type == 'economy' then
         
            local content = adventGifts[gift].content
      
            if content.cash then
                pData.cash = pData.cash + content.cash
            end
            if content.premiumPoints then
                pData.premiumPoints = pData.premiumPoints + content.premiumPoints
            end
            table.insert(pGifts, adventGifts[gift])

            exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), pData.identifier})
            TriggerClientEvent('Player:UpdateData', source, pData)
            cb({
                cash = content.cash,
                premiumPoints = content.premiumPoints
            })
        elseif adventGifts[gift].type == 'vehicle' then
            table.insert(pGifts, adventGifts[gift])
            exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(pData), pData.identifier})
            TriggerClientEvent('Player:UpdateData', source, pData)
            
            cb(adventGifts[gift].content)
        end
    end
end)