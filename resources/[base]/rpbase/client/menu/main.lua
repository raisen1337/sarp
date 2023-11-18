local menu1 = MenuV:CreateMenu(false, "Seteaza identitate", "center", 0, 0, 0, 'size-150', 'none', 'menuv', 'identity-set')

local inDialog = false

menu1:AddButton({
    label = "Pentru a continua, te rugam sa setezi numele si prenumele tau.",
    disabled = true
})


local confirmIdentity = menu1:AddButton({
    icon = '⏭',
    label = "Next",
    value = "",
    description = "Test description"
})

Citizen.CreateThread(function()
    while true do
        local scriptWait = 1000
        Wait(scriptWait)
        if inDialog then
            scriptWait = 1
            if IsControlJustPressed(0, 200) then
                SetNuiFocus(false, false)
                Wait(100)
                SendNUIMessage({
                    action = 'closethisshit'
                })
                
                Wait(100)
                inDialog = false
            end
        end
    end
end)

confirmIdentity:On("select", function()
    MenuV:CloseAll(true);
    ShowDialog("Seteaza identitatea", "Scrie mai jos ce nume de familie doresti sa aiba caracterul tau.", "Identity:SetName", false, false, "client")
end)

RegisterNetEvent("Identity:OpenSetup", function()
    Core.TriggerCallback("Identity:Check", function(hasIdentity)
        if not hasIdentity then
            FreezeEntityPosition(PlayerPedId(), true)
            MenuV:OpenMenu(menu1)
        else
            sendNotification("Identitate", "Ai deja identitatea facuta.", 'error')
        end 
    end)
end)


RegisterNetEvent("Identity:SetName", function(name)
    if not name then return end
    PlayerData = Core.GetPlayerData()
    PlayerData.character.name = name

    Core.SavePlayer()

    ShowDialog("Seteaza identitatea", "Scrie mai jos ce prenume doresti sa aiba caracterul tau.", "Identity:SetSurname", false, false, "client")
end)

RegisterNetEvent("Identity:SetSurname", function(name)
    if not name then return end
    PlayerData = Core.GetPlayerData()
    PlayerData.character.surname = name
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityVisible(PlayerPedId(), true)
    Core.SavePlayer()
    TriggerEvent("MissionPassed:Show", "Ti-ai setat identitatea cu success! Distractie placuta!")
end)

RegisterNUICallback("dialogCallback", function(response)
    TriggerEvent('dialogHandler', response.eventName, response.type, response.response)
    SetNuiFocus(false, false)
end)

function ShowDialog(title, subtitle, dialogEvent, hasCancel, canCloseEmpty, eventType)
    inDialog = true
    Wait(300)
    MenuV:CloseAll()
    SendNUIMessage({
        action = "openPrompt",
        dialogTitle = title,
        dialogSubtitle = subtitle,
        hasCancel = hasCancel,
        dialogEvent = dialogEvent,
        canCloseEmpty = canCloseEmpty,
        eventType = eventType
    })
    SetNuiFocus(true, true)
end

RegisterNetEvent('Dialog:Open', function(title, subtitle, dialogEvent, hasCancel, canCloseEmpty, eventType)
    inDialog = true
    MenuV:CloseAll()
    SendNUIMessage({
        action = "openPrompt",
        dialogTitle = title,
        dialogSubtitle = subtitle,
        hasCancel = hasCancel,
        dialogEvent = dialogEvent,
        canCloseEmpty = canCloseEmpty,
        eventType = eventType
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('dialogHandler', function(event, type, response)
    if type == "server" then
        TriggerServerEvent(event, response)
    else
        TriggerEvent(event, response)
    end
   
    SetNuiFocus(false, false)
end)

RegisterNUICallback('dialogClose', function()
  
    SetNuiFocus(false, false)
end)