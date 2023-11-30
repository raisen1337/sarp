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

-- Citizen.CreateThread(function()
--     while true do
--         local scriptwait = 3005
--         Wait(scriptWait)
--         if inDialog then
--             scriptWait = 1
--             if IsControlJustPressed(0, 200) then
--                 SetNuiFocus(false, false)
--                 Wait(100)
--                 SendNUIMessage({
--                     action = 'closethisshit'
--                 })
                
--                 Wait(100)
--                 inDialog = false
--             end
--         end
--     end
-- end)


confirmIdentity:On("select", function()
    MenuV:CloseAll(true);
    ShowDialog("Seteaza identitatea", "Scrie mai jos ce nume de familie doresti sa aiba caracterul tau.", "Identity:SetName", false, false, "client")
end)

RegisterNetEvent("Identity:OpenSetup", function()
    Core.TriggerCallback("Identity:Check", function(hasIdentity)
        if not hasIdentity then
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
    if not PlayerData.registered then
        PlayerData.registered = true
    end
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityVisible(PlayerPedId(), true)
    Core.SavePlayer()
    TriggerEvent("MissionPassed:Show", "Ti-ai setat identitatea cu success! Distractie placuta!")
end)

-- Citizen.CreateThread(function ()
--     while true do
--         wait = 3005
--         if inDialog then
--             wait = 1
--             SetNuiFocus(true, true)
--         else
--             wait = 3005
--         end
--         Wait(wait)
--     end
-- end)



RegisterNUICallback("dialogCallback", function(response)

    TriggerEvent('dialogHandler', response.eventName, response.type, response.response)
    inDialog = false
    SetNuiFocus(false, false)
end)

function ShowDialog(title, subtitle, dialogEvent, hasCancel, canCloseEmpty, eventType, cb, onClose)
    Wait(500)
    inDialog = true
    MenuV:CloseAll()
    if not cb then
        SendNUIMessage({
            action = "openPrompt",
            dialogTitle = title,
            dialogSubtitle = subtitle,
            hasCancel = hasCancel,
            dialogEvent = dialogEvent,
            canCloseEmpty = canCloseEmpty,
            eventType = eventType
        })
    else
        SendNUIMessage({
            action = "openPrompt",
            dialogTitle = title,
            dialogSubtitle = subtitle,
            hasCancel = hasCancel,
            dialogEvent = "",
            canCloseEmpty = canCloseEmpty,
            eventType = ""
        })
        RegisterNUICallback("dialogCallback", function(response)
            SetNuiFocus(false, false)
            inDialog = false
            
            cb(response.response)
        end)
    end

    if onClose then
        RegisterNUICallback("dialogClose", function()
            SetNuiFocus(false, false)
            inDialog = false
            onClose()
            Core.ClearEvents()
        end)
    end
    
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

Core.ShowDialogBox = function(title, subtitle, hasCancel, canCloseEmpty, cb)
    inDialog = true
    local dialogResponse = nil
    SendNUIMessage({
        action = "openPrompt",
        dialogTitle = title,
        dialogSubtitle = subtitle,
        hasCancel = hasCancel,
        dialogEvent = "",
        canCloseEmpty = canCloseEmpty,
        eventType = ""
    })
    SetNuiFocus(true, true)
    RegisterNUICallback("dialogCallback", function(response)
        SetNuiFocus(false, false)
        inDialog = false
        dialogResponse = response.response
    end)
    while dialogResponse == nil do
        Wait(0)
    end
    cb(dialogResponse)
end

RegisterNetEvent('dialogHandler', function(event, type, response)
    if type == "server" then
        TriggerServerEvent(event, response)
    else
        TriggerEvent(event, response)
    end
end)

RegisterNUICallback('dialogClose', function()
    Core.ClearEvents()
end)