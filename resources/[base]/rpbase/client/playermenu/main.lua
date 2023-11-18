local playerMenu = MenuV:CreateMenu(false, "Meniu jucator", "centerright", 0, 0, 0, 'size-150', 'none', 'menuv', 'playermenu-main')

function BuildPlayerMenu()
    playerMenu:ClearItems()

    Core.TriggerCallback('Player:GetData', function(pData)
        if not pData then
            return
        end
        print(pData.adminLevel)
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
           label = 'Ofera bani',
           icon = '💸',
           value = 0,
           select = function()
               --write code to get the nearest player id and give money to him
           end
       })

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
    end)
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