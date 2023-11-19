local drawable_names = {"face", "masks", "hair", "torsos", "legs", "bags", "shoes", "neck", "undershirts", "vest", "decals", "jackets"}
local prop_names = {"hats", "glasses", "earrings", "mouth", "lhand", "rhand", "watches", "braclets"}
local head_overlays = {"Blemishes","FacialHair","Eyebrows","Ageing","Makeup","Blush","Complexion","SunDamage","Lipstick","MolesFreckles","ChestHair","BodyBlemishes","AddBodyBlemishes"}
local face_features = {"Nose_Width","Nose_Peak_Hight","Nose_Peak_Lenght","Nose_Bone_High","Nose_Peak_Lowering","Nose_Bone_Twist","EyeBrown_High","EyeBrown_Forward","Cheeks_Bone_High","Cheeks_Bone_Width","Cheeks_Width","Eyes_Openning","Lips_Thickness","Jaw_Bone_Width","Jaw_Bone_Back_Lenght","Chimp_Bone_Lowering","Chimp_Bone_Lenght","Chimp_Bone_Width","Chimp_Hole","Neck_Thikness"}

local player
local currentclothing
local newclothing
local currentCamPos

local cam = false
local customCam = false

function GetDrawables()
    drawables = {}
    local model = GetEntityModel(PlayerPedId())
    local mpPed = true
 
    for i = 0, #drawable_names-1 do
        if mpPed and drawable_names[i+1] == "undershirts" and GetPedDrawableVariation(player, i) == -1 then
            SetPedComponentVariation(player, i, 15, 0, 2)
        end
        drawables[i] = {drawable_names[i+1], GetPedDrawableVariation(player, i)}
    end
    return drawables
end

function GetProps()
    props = {}
    for i = 0, #prop_names-1 do
        props[i] = {prop_names[i+1], GetPedPropIndex(player, i)}
    end
    return props
end

function GetDrawTextures()
    textures = {}
    for i = 0, #drawable_names-1 do
        table.insert(textures, {drawable_names[i+1], GetPedTextureVariation(player, i)})
    end
    return textures
end

function GetPropTextures()
    textures = {}
    for i = 0, #prop_names-1 do
        table.insert(textures, {prop_names[i+1], GetPedPropTextureIndex(player, i)})
    end
    return textures
end

function GetDrawablesTotal()
    drawables = {}
    for i = 0, #drawable_names - 1 do
        drawables[i] = {drawable_names[i+1], GetNumberOfPedDrawableVariations(player, i)}
    end
    return drawables
end

function GetPropDrawablesTotal()
    props = {}
    for i = 0, #prop_names - 1 do
        props[i] = {prop_names[i+1], GetNumberOfPedPropDrawableVariations(player, i)}
    end
    return props
end

function GetTextureTotals()
    local values = {}
    local draw = GetDrawables()
    local props = GetProps()

    for idx = 0, #draw-1 do
        local name = draw[idx][1]
        local value = draw[idx][2]
        values[name] = GetNumberOfPedTextureVariations(player, idx, value)
    end

    for idx = 0, #props-1 do
        local name = props[idx][1]
        local value = props[idx][2]
        values[name] = GetNumberOfPedPropTextureVariations(player, idx, value)
    end
    return values
end
function GetPedHeadBlendData()
    local blob = string.rep("\0\0\0\0\0\0\0\0", 6 + 3 + 1) -- Generate sufficient struct memory.
    if not Citizen.InvokeNative(0x2746BD9D88C5C5D0, player, blob, true) then -- Attempt to write into memory blob.
        return nil
    end

    return {
        shapeFirst = string.unpack("<i4", blob, 1),
        shapeSecond = string.unpack("<i4", blob, 9),
        shapeThird = string.unpack("<i4", blob, 17),
        skinFirst = string.unpack("<i4", blob, 25),
        skinSecond = string.unpack("<i4", blob, 33),
        skinThird = string.unpack("<i4", blob, 41),
        shapeMix = string.unpack("<f", blob, 49),
        skinMix = string.unpack("<f", blob, 57),
        thirdMix = string.unpack("<f", blob, 65),
        hasParent = string.unpack("b", blob, 73) ~= 0,
    }
end

function SetPedHeadBlend(data)
    SetPedHeadBlendData(player,
        tonumber(data['shapeFirst']),
        tonumber(data['shapeSecond']),
        tonumber(data['shapeThird']),
        tonumber(data['skinFirst']),
        tonumber(data['skinSecond']),
        tonumber(data['skinThird']),
        tonumber(data['shapeMix']),
        tonumber(data['skinMix']),
        tonumber(data['thirdMix']),
        false)
end

function SetPedHeadBlend(data)
    if not data then
        data = GetCurrentPed()
    end
    
    SetPedHeadBlendData(player,
    tonumber(data['shapeFirst']),
    tonumber(data['shapeSecond']),
    tonumber(data['shapeThird']),
    tonumber(data['skinFirst']),
    tonumber(data['skinSecond']),
    tonumber(data['skinThird']),
    tonumber(data['shapeMix']),
    tonumber(data['skinMix']),
    tonumber(data['thirdMix']),
    false)
 
end

function GetHeadOverlayData()
    local headData = {}
    for i = 1, #head_overlays do
        local retval, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(player, i-1)
        if retval then
            headData[i] = {}
            headData[i].name = head_overlays[i]
            headData[i].overlayValue = overlayValue
            headData[i].colourType = colourType
            headData[i].firstColour = firstColour
            headData[i].secondColour = secondColour
            headData[i].overlayOpacity = overlayOpacity
        end
    end
    return headData
end

function SetHeadOverlayData(data)
    if json.encode(data) ~= "[]" then
        for i = 1, #head_overlays do
            SetPedHeadOverlay(player,  i-1, tonumber(data[i].overlayValue),  tonumber(data[i].overlayOpacity))
        end

        SetPedHeadOverlayColor(player, 0, 0, tonumber(data[1].firstColour), tonumber(data[1].secondColour))
        SetPedHeadOverlayColor(player, 1, 1, tonumber(data[2].firstColour), tonumber(data[2].secondColour))
        SetPedHeadOverlayColor(player, 2, 1, tonumber(data[3].firstColour), tonumber(data[3].secondColour))
        SetPedHeadOverlayColor(player, 3, 0, tonumber(data[4].firstColour), tonumber(data[4].secondColour))
        SetPedHeadOverlayColor(player, 4, 2, tonumber(data[5].firstColour), tonumber(data[5].secondColour))
        SetPedHeadOverlayColor(player, 5, 2, tonumber(data[6].firstColour), tonumber(data[6].secondColour))
        SetPedHeadOverlayColor(player, 6, 0, tonumber(data[7].firstColour), tonumber(data[7].secondColour))
        SetPedHeadOverlayColor(player, 7, 0, tonumber(data[8].firstColour), tonumber(data[8].secondColour))
        SetPedHeadOverlayColor(player, 8, 2, tonumber(data[9].firstColour), tonumber(data[9].secondColour))
        SetPedHeadOverlayColor(player, 9, 0, tonumber(data[10].firstColour), tonumber(data[10].secondColour))
        SetPedHeadOverlayColor(player, 10, 1, tonumber(data[11].firstColour), tonumber(data[11].secondColour))
        SetPedHeadOverlayColor(player, 11, 0, tonumber(data[12].firstColour), tonumber(data[12].secondColour))
    end
end

function GetHeadOverlayTotals()
    local totals = {}
    for i = 1, #head_overlays do
        totals[head_overlays[i]] = GetNumHeadOverlayValues(i-1)
    end
    return totals
end

function GetPedHair()
    local hairColor = {}
    hairColor[1] = GetPedHairColor(player)
    hairColor[2] = GetPedHairHighlightColor(player)
    return hairColor
end

function GetHeadStructureData()
    local structure = {}
    for i = 1, #face_features do
        structure[face_features[i]] = GetPedFaceFeature(player, i-1)
    end
    return structure
end

function GetHeadStructure(data)
    local structure = {}
    for i = 1, #face_features do
        structure[i] = GetPedFaceFeature(player, i-1)
    end
    return structure
end

function SetHeadStructure(data)
    for i = 1, #face_features do
        SetPedFaceFeature(player, i-1, data[i])
    end
end
function SetSkin(model, setDefault)
    SetEntityInvincible(player, true)
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while (not HasModelLoaded(model)) do
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
        player = PlayerPedId()
        FreezePedCameraRotation(player, true)
           
        SetPedHeadBlendData(player, 0, 0, 0, 15, 0, 0, 0, 1.0, 0, false)
        SetPedComponentVariation(player, 11, 0, 11, 0)
        SetPedComponentVariation(player, 8, 0, 1, 0)
        SetPedComponentVariation(player, 6, 1, 2, 0)
        SetPedHeadOverlayColor(player, 1, 1, 0, 0)
        SetPedHeadOverlayColor(player, 2, 1, 0, 0)
        SetPedHeadOverlayColor(player, 4, 2, 0, 0)
        SetPedHeadOverlayColor(player, 5, 2, 0, 0)
        SetPedHeadOverlayColor(player, 8, 2, 0, 0)
        SetPedHeadOverlayColor(player, 10, 1, 0, 0)
        SetPedHeadOverlay(player, 1, 0, 0.0)
    
       
    end
    SetEntityInvincible(player,false)
end
function SetHeadStructure(data)
    for i = 1, #face_features do
        SetPedFaceFeature(player, i-1, data[i])
    end
end

function GetCurrentPed()
    return {
        model = GetEntityModel(PlayerPedId()),
        hairColor = GetPedHair(),
        headBlend = GetPedHeadBlendData(),
        headOverlay = GetHeadOverlayData(),
        headStructure = GetHeadStructure(),
        drawables = GetDrawables(),
        props = GetProps(),
        drawtextures = GetDrawTextures(),
        proptextures = GetPropTextures(),
    }
end


function rotation(dir)
    local pedRot = GetEntityHeading(PlayerPedId())+dir
    SetEntityHeading(player, pedRot % 360)
end

RegisterNUICallback('closeClothing', function()
    LoadPed(currentclothing)
    Save(currentclothing)
    SetEntityInvincible(PlayerPedId(), false)
    FreezePedCameraRotation(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
    customCam = false
    SetCamActive(cam, false)
    RenderScriptCams(false,  false,  0,  true,  true)
    if (DoesCamExist(cam)) then
        DestroyCam(cam, false)
    end
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'showHud'
    })
    local PlayerData = Core.GetPlayerData()
    SendNUIMessage({
        action = "fixShow",
    })
    SendNUIMessage({
        action = "showHud",
        cash = PlayerData.cash or 0,
        bank = PlayerData.bank or 0,
        wantedLevel = PlayerData.wantedLevel or 0,
        playerJob = PlayerData.job.name or "Unemployed",
        playerLevel = PlayerData.level or 1,
    })
    DisplayRadar(true)
end)

AddEventHandler('Clothes:LoadSkin', function()
    SetPedClothes()
end)

RegisterNUICallback('buyClothing', function(data)
    customCam = false
    SetEntityInvincible(PlayerPedId(), false)
    FreezePedCameraRotation(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
    SetCamActive(cam, false)
    RenderScriptCams(false,  false,  0,  true,  true)
    if (DoesCamExist(cam)) then
        DestroyCam(cam, false)
    end
    SendNUIMessage({
        action = 'showHud'
    })
    SendNUIMessage({
        action = "fixShow",
    })
    local price = data.price
    DisplayRadar(true)
    local pData = Core.GetPlayerData()
    if pData.cash >= price then
        pData.cash = pData.cash - price
        Core.TriggerCallback('Clothing:UpdateClothes', function(cb)
           
        end, GetCurrentPed())
        sendNotification('Haine', 'Ti-ai schimbat imbracamintea si ai platit $500')
        Core.SavePlayer()
    else
        Save(currentclothing)
        Wait(100)
        LoadPed(currentclothing)
        sendNotification('Haine', 'Nu ai $500', 'error')
    end
    SetNuiFocus(false, false)

end)

function Save(data)
    Core.TriggerCallback('Clothing:UpdateClothes', function(cb)
    end, data)
end

function CustomCamera()
    if customCam or position == "torso" then
        FreezePedCameraRotation(player, false)
        SetCamActive(cam, false)
        RenderScriptCams(false,  false,  0,  true,  true)
        if (DoesCamExist(cam)) then
            DestroyCam(cam, false)
        end
        customCam = false
    else
        if (DoesCamExist(cam)) then
            DestroyCam(cam, false)
        end

        local pos = GetEntityCoords(player, true)
        SetEntityRotation(player, 0.0, 0.0, 0.0, 1, true)
        FreezePedCameraRotation(player, true)

        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamCoord(cam, player)
        SetCamRot(cam, 0.0, 0.0, 0.0)

        SetCamActive(cam, true)
        RenderScriptCams(true,  false,  0,  true,  true)

        SwitchCam(position)
        customCam = true
    end
end


function SwitchCam(name)
    if currentCamPos == name then
        return
    end
    currentCamPos = name
    local pos = GetEntityCoords(player, true)
    local bonepos = false
    if (name == "head") then
        bonepos = GetPedBoneCoords(player, 31086)
        bonepos = vector3(bonepos.x - 0.1, bonepos.y + 0.4, bonepos.z + 0.05)
    end
    if (name == "torso") then
        bonepos = GetPedBoneCoords(player, 11816)
        bonepos = vector3(bonepos.x - 0.4, bonepos.y + 2.2, bonepos.z + 0.2)
    end
    if (name == "leg") then
        bonepos = GetPedBoneCoords(player, 46078)
        bonepos = vector3(bonepos.x - 0.1, bonepos.y + 1, bonepos.z)
    end

    SetCamCoord(cam, bonepos.x, bonepos.y, bonepos.z)
    SetCamRot(cam, 0.0, 0.0, 180.0)
end

RegisterNUICallback('switchCam', function(event)
    SwitchCam(event.pos)
end)

local rotated = false

RegisterNetEvent('Clothing:SavePed', function()
    Save(GetCurrentPed())
end)

RegisterNUICallback('rotate', function(event)
    if event.rotateFor == 'bag' then
        rotation(180)
        rotated = true
    else
        if not rotated then
            
        else
            rotation(-180)
            rotated = false
        end
    end
end)

local canOpenClothing = false

RegisterCommand('clothes', function()
    if canOpenClothing then
        OpenClothing()
    end
end)

AddEventHandler('Business:NearBiz', function(biz)
    if biz == false then
        canOpenClothing = biz
    else
        if not canOpenClothing then
            local bizData = jd(biz.data)
            if bizData.type == 2 then
                canOpenClothing = true
                showSubtitle('^3Hint:^0 Te poti schimba folosind comanda ^3/clothes', 9000)
            end
        end
    end
end)



RegisterNetEvent("Clothing:FixSkin", function()
    SetPedClothes()
end)

RegisterNetEvent("Clothing:Open", function()
    OpenClothing()
    CustomCamera()
end)

function OpenClothing()
    player = PlayerPedId()
    SetEntityInvincible(PlayerPedId(), true)
    FreezePedCameraRotation(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), true)
    customCam = false
    position = 'head'
    CustomCamera()
    currentclothing = GetCurrentPed()
    
    SendNUIMessage({
        action = 'openClothing',
        data = {
            drawables = GetDrawables(),
            props = GetProps(),
            drawableTex = GetDrawTextures(),
            propTex = GetPropTextures()
        }
    })
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'hideHud'
    })
    DisplayRadar(false)
    Wait(1000)
    SendNUIMessage({
        action = 'setData',
        data = {
            drawablesTotal = GetDrawablesTotal(),
            propDrawablesTotal = GetPropDrawablesTotal(),
            textureTotal = GetTextureTotals()
        }
    })
end

RegisterCommand('fixskin', function()
    SetPedClothes()
 
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(100)
        DisableIdleCamera(true)
    end
end)

RegisterNUICallback('updateProps', function(data)
    SendNUIMessage({
        action = 'setData',
        data = {
            drawablesTotal = GetDrawablesTotal(),
            propDrawablesTotal = GetPropDrawablesTotal(),
            textureTotal = GetTextureTotals()
        }
    })
    SetPedPropIndex(player, data.component, data.texture, data.variation, 1)
end)

function SetPedClothes()
    Core.TriggerCallback('Clothing:GetClothing', function(cb)
        LoadPed(cb)
    end)
end
function SetClothing(drawables, props, drawTextures, propTextures)
    for i = 1, #drawable_names do
        if drawables[0] == nil then
            if drawable_names[i] == "undershirts" and drawables[tostring(i-1)][2] == -1 then
                SetPedComponentVariation(player, i-1, 15, 0, 2)
            else
                if drawTextures[i] and drawables[tostring(i-1)] then
                    SetPedComponentVariation(player, i-1, drawables[tostring(i-1)][2], drawTextures[i][2], 2)
                end
            end
        else
            if drawable_names[i] == "undershirts" and drawables[i-1][2] == -1 then
                SetPedComponentVariation(player, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(player, i-1, drawables[i-1][2], drawTextures[i][2], 2)
            end
        end
    end

    for i = 1, #prop_names do
        local propZ = (drawables[0] == nil and props[tostring(i-1)][2] or props[i-1][2])
        ClearPedProp(player, i-1)
        SetPedPropIndex(
            player,
            i-1,
            propZ,
            propTextures[i][2], true)
    end
end
function LoadPed(data)
    if data then
        UserLocation = GetEntityCoords(PlayerPedId())
        if data.model == '1885233650' or tonumber(data.model) == 1885233650 then
            SetSkin('mp_m_freemode_01', true)
        elseif data.model == '-1667301416' or tonumber(data.model) == -1667301416 then
            SetSkin('mp_f_freemode_01', true)
        end
        SetClothing(data.drawables, data.props, data.drawtextures, data.proptextures)
        Citizen.Wait(500)
        SetPedHairColor(player, tonumber(data.hairColor[1]), tonumber(data.hairColor[2]))
        SetPedHeadBlend(data.headBlend)
        SetHeadStructure(data.headStructure)
        SetHeadOverlayData(data.headOverlay)
    end
    return
end


RegisterNUICallback('updateClothing', function(data)
    SendNUIMessage({
        action = 'setData',
        data = {
            drawablesTotal = GetDrawablesTotal(),
            propDrawablesTotal = GetPropDrawablesTotal(),
            textureTotal = GetTextureTotals()
        }
    })
    if data.component == 2 then 
        local peddata = GetCurrentPed()
        peddata.hairColor[1] = math.random(0, 255)
        peddata.hairColor[2] = math.random(0, 255)
        SetPedHairColor(PlayerPedId(), peddata.hairColor[1], peddata.hairColor[2])
    end
    SetPedComponentVariation(player, data.component, data.texture, data.variation, 3)
end)