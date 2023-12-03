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
    local ped = PlayerPedId()
    local drawables = GetDrawables()
    local props = GetProps()
    local drawtextures = GetDrawTextures()
    local proptextures = GetPropTextures()
    
    local skinData = {}
    skinData.drawables = drawables
    skinData.props = props
    skinData.drawtextures = drawtextures
    skinData.proptextures = proptextures
    skinData.hairColor = GetPedHairColor(ped)
    skinData.hairHighlightColor = GetPedHairHighlightColor(ped)
    skinData.headBlend = GetPedHeadBlendData(ped)
    skinData.headStructure = GetHeadStructureData(ped)
    skinData.headOverlay = GetHeadOverlayData(ped)
    return skinData
end


function rotation(dir)
    local pedRot = GetEntityHeading(PlayerPedId())+dir
    SetEntityHeading(player, pedRot % 360)
end

RegisterNUICallback('closeClothing', function()
    TriggerEvent('Player:LoadSkin')
  
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
        local drawables = GetDrawables()
        local props = GetProps()
        local drawtextures = GetDrawTextures()
        local proptextures = GetPropTextures()
        local ped = PlayerPedId()
        local skinData = {}
        skinData.drawables = drawables
        skinData.props = props
        skinData.drawtextures = drawtextures
        skinData.proptextures = proptextures
        skinData.hairColor = GetPedHairColor(ped)
        skinData.hairHighlightColor = GetPedHairHighlightColor(ped)
        skinData.headBlend = GetPedHeadBlendData(ped)
        skinData.headStructure = GetHeadStructureData(ped)
        skinData.headOverlay = GetHeadOverlayData(ped)

        Core.TriggerCallback('Clothing:UpdateClothes', function(cb)
           
        end, skinData)
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



RegisterCommand('skintest', function()
    local ped = PlayerPedId()
    local drawables = GetDrawables()
    local props = GetProps()
    local drawtextures = GetDrawTextures()
    local proptextures = GetPropTextures()
    
    local skinData = {}
    skinData.drawables = drawables
    skinData.props = props
    skinData.drawtextures = drawtextures
    skinData.proptextures = proptextures
    skinData.hairColor = GetPedHairColor(ped)
    skinData.hairHighlightColor = GetPedHairHighlightColor(ped)
    skinData.headBlend = GetPedHeadBlendData(ped)
    skinData.headStructure = GetHeadStructureData(ped)
    skinData.headOverlay = GetHeadOverlayData(ped)
    Save(skinData)

    Wait(3000)
    SetPedClothes()
end)

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
    GetMaxValues()
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
local clothingCategorys = {
    ["arms"]        = {type = "variation",  id = 3},
    ["t-shirt"]     = {type = "variation",  id = 8},
    ["torso2"]      = {type = "variation",  id = 11},
    ["pants"]       = {type = "variation",  id = 4},
    ["vest"]        = {type = "variation",  id = 9},
    ["shoes"]       = {type = "variation",  id = 6},
    ["bag"]         = {type = "variation",  id = 5},
    ["hair"]        = {type = "hair",       id = 2},
    ["face"]        = {type = "face",       id = 0},
    ["mask"]        = {type = "variation",       id = 1},
    ["hat"]         = {type = "prop",       id = 0},
    ["glass"]       = {type = "prop",       id = 1},
    ["ear"]         = {type = "prop",       id = 2},
    ["watch"]       = {type = "prop",       id = 6},
    ["bracelet"]    = {type = "prop",       id = 7},
    ["accessory"]   = {type = "variation",  id = 7},
    ["decals"]      = {type = "variation",  id = 10},
}

function GetDrawables()
    drawables = {}
    local model = GetEntityModel(PlayerPedId())
    local mpPed = true
 
    for k,v in pairs(clothingCategorys) do
        
        if v.type == "variation"  then
            drawables[v.id] = {v.id, GetPedDrawableVariation(player, v.id), type = v.type}
        end

        if v.type == 'hair' then
            drawables[v.id] = {v.id, GetPedDrawableVariation(player, v.id), type = v.type}
        end

        if v.type == 'face' then
            drawables[v.id] = {v.id, GetPedDrawableVariation(player, v.id), type = v.type}
        end

        if v.type == "ageing" then
            drawables[v.id] = {v.id, GetPedHeadOverlayValue(player, v.id), type = v.type}
        end

        if v.type == "overlay" then
            drawables[v.id] = {v.id, GetPedHeadOverlayValue(player, v.id), type = v.type}
        end

        if v.type == "eye_color" then
            drawables[v.id] = {v.id, GetPedEyeColor(player), type = v.type}
        end

        if v.type == "moles" then
            drawables[v.id] = {v.id, GetPedHeadOverlayValue(player, v.id), type = v.type}
        end

        if v.type == "nose" then
            drawables[v.id] = {v.id, GetPedFaceFeature(player, v.id), type = v.type}
        end

        if v.type == "cheek" then
            drawables[v.id] = {v.id, GetPedFaceFeature(player, v.id), type = v.type}
        end

        if v.type == "chin" then
            drawables[v.id] = {v.id, GetPedFaceFeature(player, v.id), type = v.type}
        end

    end


    return drawables
end

function GetProps()
    props = {}
    for k,v in pairs(clothingCategorys) do
        if v.type == "prop" then
            props[v.id] = {v.id, GetPedPropIndex(player, v.id), type = 'prop'}
        end
    end
    return props
end

function GetDrawTextures()
    textures = {}
    for k,v in pairs(clothingCategorys) do
        if v.type == "variation" then
            if v.type == 'arms' then
                
            end
            textures[v.id] = {v.id, GetPedTextureVariation(player, v.id), type = v.type}
        end

        if v.type == 'hair' then
            textures[v.id] = {v.id, GetPedTextureVariation(player, v.id), type = v.type}
        end

        if v.type == 'face' then
            textures[v.id] = {v.id, GetPedTextureVariation(player, v.id), type = v.type}
        end

        if v.type == "ageing" then
            textures[v.id] = {v.id, GetPedHeadOverlayData(player, v.id), type = v.type}
        end

        if v.type == "overlay" then
            textures[v.id] = {v.id, GetPedHeadOverlayData(player, v.id), type = v.type}
        end

        if v.type == "eye_color" then
            textures[v.id] = {v.id, GetPedEyeColor(player), type = v.type}
        end

        if v.type == "moles" then
            textures[v.id] = {v.id, GetPedHeadOverlayData(player, v.id), type = v.type}
        end

        if v.type == "nose" then
            textures[v.id] = {v.id, GetPedFaceFeature(player, v.id), type = v.type}
        end

        if v.type == "cheek" then
            textures[v.id] = {v.id, GetPedFaceFeature(player, v.id), type = v.type}
        end

        if v.type == "chin" then
            textures[v.id] = {v.id, GetPedFaceFeature(player, v.id), type = v.type}
        end

    end
    return textures
end

function GetPropTextures()
    textures = {}
    for k,v in pairs(clothingCategorys) do
        if v.type == "prop" then
            textures[v.id] = {v.id, GetPedPropTextureIndex(player, v.id), type = 'prop'}
        end
    end
    return textures
end

function GetMaxValues()
    maxModelValues = {
        ["arms"]        = {type = "character", item = 0, texture = 0},
        ["eye_color"]   = {type = "hair", item = 0, texture = 0},
        ["t-shirt"]     = {type = "character", item = 0, texture = 0},
        ["torso2"]      = {type = "character", item = 0, texture = 0},
        ["pants"]       = {type = "character", item = 0, texture = 0},
        ["shoes"]       = {type = "character", item = 0, texture = 0},
        ["face"]        = {type = "hair", item = 0, texture = 0},
        ["vest"]        = {type = "character", item = 0, texture = 0},
        ["accessory"]   = {type = "character", item = 0, texture = 0},
        ["decals"]      = {type = "character", item = 0, texture = 0},
        ["bag"]         = {type = "character", item = 0, texture = 0},
        ["moles"]       = {type = "hair", item = 0, texture = 0},
        ["hair"]        = {type = "barber", item = 0, texture = 0},
        ["eyebrows"]    = {type = "barber", item = 0, texture = 0},
        ["beard"]       = {type = "barber", item = 0, texture = 0},
        ["eye_opening"]   = {type = "hair",  id = 1},
        ["jaw_bone_width"]       = {type = "hair", item = 0, texture = 0},
        ["jaw_bone_back_lenght"]       = {type = "hair", item = 0, texture = 0},
        ["lips_thickness"]       = {type = "hair", item = 0, texture = 0},
        ["cheek_1"]       = {type = "hair", item = 0, texture = 0},
        ["cheek_2"]       = {type = "hair", item = 0, texture = 0},
        ["cheek_3"]       = {type = "hair", item = 0, texture = 0},
        ["eyebrown_high"]       = {type = "hair", item = 0, texture = 0},
        ["eyebrown_forward"]       = {type = "hair", item = 0, texture = 0},
        ["nose_0"]       = {type = "hair", item = 0, texture = 0},
        ["nose_1"]       = {type = "hair", item = 0, texture = 0},
        ["nose_2"]       = {type = "hair", item = 0, texture = 0},
        ["nose_3"]       = {type = "hair", item = 0, texture = 0},
        ["nose_4"]       = {type = "hair", item = 0, texture = 0},
        ["nose_5"]       = {type = "hair", item = 0, texture = 0},
        ["chimp_bone_lowering"]       = {type = "hair", item = 0, texture = 0},
        ["chimp_bone_lenght"]       = {type = "hair", item = 0, texture = 0},
        ["chimp_bone_width"]       = {type = "hair", item = 0, texture = 0},
        ["chimp_hole"]       = {type = "hair", item = 0, texture = 0},
        ["neck_thikness"]       = {type = "hair", item = 0, texture = 0},
        ["blush"]       = {type = "barber", item = 0, texture = 0},
        ["lipstick"]    = {type = "barber", item = 0, texture = 0},
        ["makeup"]      = {type = "barber", item = 0, texture = 0},
        ["ageing"]      = {type = "hair", item = 0, texture = 0},
        ["mask"]        = {type = "accessoires", item = 0, texture = 0},
        ["hat"]         = {type = "accessoires", item = 0, texture = 0},
        ["glass"]       = {type = "accessoires", item = 0, texture = 0},
        ["ear"]         = {type = "accessoires", item = 0, texture = 0},
        ["watch"]       = {type = "accessoires", item = 0, texture = 0},
        ["bracelet"]    = {type = "accessoires", item = 0, texture = 0},
        
    }
    local ped = PlayerPedId()
    for k, v in pairs(clothingCategorys) do
        if v.type == "variation" then
            maxModelValues[k].item = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues[k].texture = GetNumberOfPedTextureVariations(ped, v.id, GetPedDrawableVariation(ped, v.id)) -1
        end

        if v.type == "hair" then
            maxModelValues[k].item = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues[k].texture = 45
        end

        if v.type == "face" then
            maxModelValues[k].item = 44
            maxModelValues[k].texture = 15
        end

        if v.type == "ageing" then
            maxModelValues[k].item = GetNumHeadOverlayValues(v.id)
            maxModelValues[k].texture = 0
        end

        if v.type == "overlay" then
            maxModelValues[k].item = GetNumHeadOverlayValues(v.id)
            maxModelValues[k].texture = 45
        end

        if v.type == "prop" then
            maxModelValues[k].item = GetNumberOfPedPropDrawableVariations(ped, v.id)
            maxModelValues[k].texture = GetNumberOfPedPropTextureVariations(ped, v.id, GetPedPropIndex(ped, v.id))
        end

        if v.type == "eye_color" then
            maxModelValues[k].item = 31
            maxModelValues[k].texture = 0
        end

        if v.type == "moles" then
            maxModelValues[k].item = GetNumHeadOverlayValues(9) -1
            maxModelValues[k].texture = 10
        end

        if v.type == "nose" then
            maxModelValues[k].item = 30
            maxModelValues[k].texture = 0
        end

        if v.type == "cheek" then
            maxModelValues[k].item = 30
            maxModelValues[k].texture = 0
        end

        if v.type == "chin" then
            maxModelValues[k].item = 30
            maxModelValues[k].texture = 0
        end

    end
    SendNUIMessage({
        action = "getData",
        data = clothingCategorys
    })
    SendNUIMessage({
        action = "updateMax",
        maxValues = maxModelValues
    })
end

Citizen.CreateThread(function ()
    Wait(5000)
    GetMaxValues()
end)




RegisterCommand('fixskin', function()
    Core.FixSkin()
 
end)

Citizen.CreateThread(function()
   
    DisableIdleCamera(true)
  
end)

RegisterNUICallback('updateProps', function(data)
    
    for k,v in pairs(clothingCategorys) do
        if v.type == 'prop' then
            if v.id == data.component then
                SetPedPropIndex(PlayerPedId(), data.component, data.texture, data.variation, 0)
            end
        end
    end
end)

RegisterNetEvent('Player:LoadSkin', function()
    SetPedClothes()
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityVisible(PlayerPedId(), true)
end)

function SetPedClothes()
    Core.TriggerCallback('Clothing:GetClothing', function(cb)
        if not table.empty(cb) then
            LoadPed(cb)
        else
        end
    end)
end



function LoadPed(data)
    LoadPlayerWeapons()
    local player = PlayerPedId()
    local drawables = data.drawables
    local props = data.props
    local drawtextures = data.drawtextures
    local proptextures = data.proptextures
    local hairColor = data.hairColor
    local headBlend = data.headBlend
    local headOverlay = data.headOverlay
    local headStructure = data.headStructure
    local model = GetEntityModel(PlayerPedId())
    
    TriggerEvent('Skin:fix')
    for k,v in pairs(drawables) do
        local tn = tostring(k)
     
        if v.type == "variation" then
            SetPedComponentVariation(player, v["1"], v["2"], drawtextures[k]["2"], 3)
        end
        
        if v.type == "ageing" then
            SetPedHeadOverlay(player, v["1"], v["2"], v["2"])
        end
        if v.type == "overlay" then
            SetPedHeadOverlay(player, v["1"], v["2"], v["2"])
        end
        if v.type == "eye_color" then
            SetPedEyeColor(player, v["1"])
        end
        if v.type == "moles" then
            SetPedHeadOverlay(player, v["1"], v["2"], v["2"])
        end
        if v.type == "nose" then
            SetPedFaceFeature(player, v["1"], v["2"])
        end
        if v.type == "cheek" then
            SetPedFaceFeature(player, v["1"], v["2"])
        end
        if v.type == "chin" then
            SetPedFaceFeature(player, v["1"], v["2"])
        end

        for a,b in pairs(drawtextures) do
            if a == k then
                
                if tonumber(k) == 0 then
                    
                    SetPedComponentVariation(player, v["1"], v["2"], b["2"], 3)
                    SetPedHeadBlendData(player, v["2"],  v["2"], b["2"], b["2"], b["2"], b["2"], 1.0, 1.0, 1.0, true)
                elseif tonumber(k) == 2 then
                    SetPedComponentVariation(player, v["1"], v["2"], b["2"], 3)
                end
            end
        end
       
        -- if v.type == 'face' then
        --     SetPedComponentVariation(player, v["1"], v["2"], drawtextures[k]["2"], 3)
        --     SetPedHeadBlendData(player, v["2"],  v["2"], drawtextures[k]["2"], drawtextures[k]["2"], drawtextures[k]["2"], drawtextures[k]["2"], 1.0, 1.0, 1.0, true)
        -- end

        -- if v.type == 'hair' then
        --     print(je(drawtextures))
        --     SetPedComponentVariation(player, k, v["2"], drawtextures[k]["2"], 3)
        -- end
       
    end

    for k,v in pairs(props) do
        
        local tn = tostring(k)
        if v.type == "prop" then
            for a,b in pairs(proptextures) do
                if a == k then
                    if tonumber(k) == 0 then
                        SetPedPropIndex(player, v["1"], v["2"], b["2"], 0)
                    else
                        SetPedPropIndex(player, v["1"], v["2"], b["2"], 0)
                    end
                end
            end
        end
    end

    
end


RegisterNUICallback('updateClothing', function(data)
    for k,v in pairs(clothingCategorys) do
        if v.id == data.component then
            

            if v.type == "variation" then
                SetPedComponentVariation(player, data.component, data.texture, data.variation, 3)
            end

            if v.type == 'face' then
                SetPedComponentVariation(player, data.component, data.texture, data.variation, 3)
                SetPedHeadBlendData(player, data.texture,  data.texture, data.variation, data.variation, data.variation, data.variation, 1.0, 1.0, 1.0, true)
            end

            if v.type == 'hair' then
                SetPedComponentVariation(player, data.component, data.texture, data.variation, 3)
            end

            if v.type == "ageing" then
                SetPedHeadOverlay(player, data.component, data.texture, data.variation)
            end

            if v.type == "overlay" then
                SetPedHeadOverlay(player, data.component, data.texture, data.variation)
            end

            

            if v.type == "eye_color" then
                SetPedEyeColor(player, data.component)
            end

            if v.type == "moles" then
                SetPedHeadOverlay(player, data.component, data.texture, data.variation)
            end

            if v.type == "nose" then
                SetPedFaceFeature(player, data.component, data.texture)
            end

            if v.type == "cheek" then
                SetPedFaceFeature(player, data.component, data.texture)
            end

            if v.type == "chin" then
                SetPedFaceFeature(player, data.component, data.texture)
            end
        end
    end
    
end)