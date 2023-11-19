local playerMenu = MenuV:CreateMenu(false, "Meniu jucator", "centerright", 0, 0, 0, 'size-150', 'none', 'menuv', 'playermenu-main')
local playerOptions = MenuV:CreateMenu(false, "Optiuni jucator", "centerright", 0, 0, 0, 'size-150', 'none', 'menuv', 'playermenu-options')
local factions = {}
function BuildPlayerMenu()
    playerMenu:ClearItems()
    local pData = Core.GetPlayerData()
    local fData = pData.faction
    if not pData then
        return
    end
    --print
    if pData.adminLevel > 0 then
        playerMenu:AddButton({
            label = 'Admin',
            icon = '👑',
            value = 0,
            select = function()
                ExecuteCommand('admin')
            end
        })
        if pData.adminLevel >= 7 then
            playerMenu:AddButton({
                label = 'Ticket admin',
                icon = '🆘',
                value = 0,
                select = function()
                    ExecuteCommand('createticket')
                end
            })
        end
    else
        playerMenu:AddButton({
            label = 'Ticket admin',
            icon = '🆘',
            value = 0,
            select = function()
                ExecuteCommand('createticket')
            end
        })
    end
    
    

    playerMenu:AddButton({
        label = 'Masini detinute',
        icon = '🚗',
        value = 0,
        select = function()
            MenuV:CloseAll()
            ExecuteCommand('v')
        end
    })

    playerMenu:AddButton({
        label = 'Case detinute',
        icon = '🏠',
        value = 0,
        select = function()
            MenuV:CloseAll()
            ExecuteCommand('houses')
        end
    })
    
    local factionData = pData.faction

    playerMenu:AddButton({
        label = 'Optiuni jucator',
        icon = '🙍‍♂️', 
        value = 0,
    }):On('select', function()
        playerOptions:ClearItems()
        BuildPlayerOptions()
        MenuV:OpenMenu(playerOptions)
    end)

    if table.empty(factions) then
        Core.TriggerCallback('Factions:GetFactions', function(data)
            factions = data
        end)
        return
    end
    BuildPlayerOptions = function()
        playerOptions:AddButton({
            label = 'Optiuni factiune',
            icon = '',
            value = 0,
            disabled = true
        })
        if factions[fData.name].type == 'lege' or factions[fData.name].type == 'mafie' then
            playerOptions:AddButton({
                label = 'Incatuseaza jucator',
                icon = '👮‍♂️',
                value = 0,
            })
        end
        if factions[fData.name].type == 'lege' then
            playerOptions:AddButton({
                label = 'Lista wanted',
                icon = '⭐',
            })
            playerOptions:AddButton({
                label = 'Amendeaza',
                icon = '📃',
            })
            playerOptions:AddButton({
                label = 'Aresteaza',
                icon = '🚧',
            })
        end
        playerOptions:AddButton({
            label = 'Optiuni player',
            icon = '',
            value = 0,
            disabled = true
        })
        playerOptions:AddButton({
            label = 'Ofera bani',
            icon = '💸',
            value = 0,
            select = function()
                --write code to get the nearest player id and give money to him
            end
        })
    end

    


    if factionData.id ~= 0 then
        playerMenu:AddButton({
            label = 'Factiune',
            icon = '💼',
            value = 0,
            select = function ()
                ExecuteCommand('faction')
            end
        })
    end
    MenuV:OpenMenu(playerMenu)
end


Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 311) then
            BuildPlayerMenu()
        end
    end
end)