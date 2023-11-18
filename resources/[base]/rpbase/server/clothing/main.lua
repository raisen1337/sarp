Core.CreateCallback('Clothing:UpdateClothes', function(source, cb, data)
    local pData = Core.GetPlayerData(source)

    pData.clothing = data

    exports.oxmysql:executeSync('UPDATE players SET data = ? WHERE identifier = ?', {je(pData), pData.identifier})
    cb(true)
end)

Core.CreateCallback('Clothing:GetClothing', function(source, cb)
    local pData = Core.GetPlayerData(source)
    cb(pData.clothing)
end)