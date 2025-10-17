local ESX = exports['es_extended']:getSharedObject()
local currentScrapVehicle = nil
local scrapProgress = {}
local spawnedNPCs = {}
local activeBlips = {}

-- Inicializace
CreateThread(function()
    -- Načtení animací
    RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
    while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
        Wait(100)
    end
    
    -- Spawn NPC a blipů
    for i, scrapyard in ipairs(Config.Scrapyards) do
        -- Spawn NPC
        if scrapyard.npc.enabled then
            SpawnScrapyardNPC(scrapyard, i)
        end
        
        -- Vytvoření blipu
        if scrapyard.blip.enabled then
            CreateScrapyardBlip(scrapyard)
        end
        
        -- Debug zóny
        if scrapyard.scrapZone.debug then
            CreateThread(function()
                while true do
                    Wait(0)
                    DrawMarker(28, scrapyard.scrapZone.coords.x, scrapyard.scrapZone.coords.y, scrapyard.scrapZone.coords.z, 
                        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                        scrapyard.scrapZone.radius, scrapyard.scrapZone.radius, scrapyard.scrapZone.radius, 
                        255, 0, 0, 50, false, false, 2, false, nil, nil, false)
                end
            end)
        end
    end
end)

-- Spawn NPC
function SpawnScrapyardNPC(scrapyard, index)
    local model = GetHashKey(scrapyard.npc.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
    
    local npc = CreatePed(4, model, scrapyard.npc.coords.x, scrapyard.npc.coords.y, scrapyard.npc.coords.z - 1.0, scrapyard.npc.coords.w, false, true)
    SetEntityAsMissionEntity(npc, true, true)
    SetPedFleeAttributes(npc, 0, 0)
    SetPedDiesWhenInjured(npc, false)
    SetPedKeepTask(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    
    if scrapyard.npc.scenario then
        TaskStartScenarioInPlace(npc, scrapyard.npc.scenario, 0, true)
    end
    
    spawnedNPCs[index] = npc
    
    -- Ox_target pro NPC
    exports.ox_target:addLocalEntity(npc, {
        {
            name = 'scrapyard_dealer_' .. index,
            icon = 'fas fa-comments',
            label = _U('talk_to_dealer'),
            onSelect = function()
                OpenScrapyardMenu(scrapyard, index)
            end
        }
    })
end

-- Vytvoření blipu
function CreateScrapyardBlip(scrapyard)
    local blip = AddBlipForCoord(scrapyard.coords.x, scrapyard.coords.y, scrapyard.coords.z)
    SetBlipSprite(blip, scrapyard.blip.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scrapyard.blip.scale)
    SetBlipColour(blip, scrapyard.blip.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(scrapyard.blip.label)
    EndTextCommandSetBlipName(blip)
    table.insert(activeBlips, blip)
end

-- Otevření menu
function OpenScrapyardMenu(scrapyard, index)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then
        vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 71)
    end
    
    lib.registerContext({
        id = 'scrapyard_menu',
        title = scrapyard.name,
        options = {
            {
                title = _U('start_scrapping'),
                description = _U('dealer_greeting'),
                icon = 'car-burst',
                onSelect = function()
                    StartScrapping(scrapyard, vehicle)
                end
            },
            {
                title = _U('cancel'),
                icon = 'xmark',
                onSelect = function()
                    lib.hideContext()
                end
            }
        }
    })
    
    lib.showContext('scrapyard_menu')
end

-- Začátek rozebírání
function StartScrapping(scrapyard, vehicle)
    if vehicle == 0 or not DoesEntityExist(vehicle) then
        lib.notify({
            title = _U('scrapyard'),
            description = _U('no_vehicle_nearby'),
            type = 'error'
        })
        return
    end
    
    -- Kontrola vzdálenosti
    local vehicleCoords = GetEntityCoords(vehicle)
    local distance = #(vehicleCoords - scrapyard.scrapZone.coords)
    
    if distance > scrapyard.scrapZone.radius then
        lib.notify({
            title = _U('scrapyard'),
            description = _U('vehicle_too_far'),
            type = 'error'
        })
        return
    end
    
    -- Kontrola blacklistu
    local vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    for _, blacklisted in ipairs(Config.BlacklistedVehicles) do
        if string.lower(vehicleModel) == string.lower(blacklisted) then
            lib.notify({
                title = _U('scrapyard'),
                description = _U('vehicle_blacklisted'),
                type = 'error'
            })
            return
        end
    end
    
    -- Kontrola whitelistu
    if #Config.WhitelistedVehicles > 0 then
        local isWhitelisted = false
        for _, whitelisted in ipairs(Config.WhitelistedVehicles) do
            if string.lower(vehicleModel) == string.lower(whitelisted) then
                isWhitelisted = true
                break
            end
        end
        
        if not isWhitelisted then
            lib.notify({
                title = _U('scrapyard'),
                description = _U('vehicle_not_whitelisted'),
                type = 'error'
            })
            return
        end
    end
    
    -- Server-side kontrola
    ESX.TriggerServerCallback('esx_scrapyard:canScrapVehicle', function(canScrap, message)
        if not canScrap then
            lib.notify({
                title = _U('scrapyard'),
                description = message,
                type = 'error'
            })
            return
        end
        
        currentScrapVehicle = vehicle
        scrapProgress[vehicle] = {}
        
        lib.notify({
            title = _U('scrapyard'),
            description = _U('scrap_started'),
            type = 'success'
        })
        
        -- Přidání ox_target na části vozidla
        AddVehicleScrapTargets(vehicle)
    end, VehToNet(vehicle))
end

-- Přidání targetů na vozidlo
function AddVehicleScrapTargets(vehicle)
    local options = {}
    
    for _, part in ipairs(Config.VehicleParts) do
        table.insert(options, {
            name = 'scrap_' .. part.name,
            icon = part.icon,
            label = _U('scrap_part', part.label),
            bones = {part.bone},
            distance = 2.0,
            canInteract = function(entity)
                return entity == currentScrapVehicle and not scrapProgress[vehicle][part.name]
            end,
            onSelect = function()
                ScrapVehiclePart(vehicle, part)
            end
        })
    end
    
    exports.ox_target:addLocalEntity(vehicle, options)
end

-- Rozebírání části
function ScrapVehiclePart(vehicle, part)
    if not DoesEntityExist(vehicle) then
        return
    end
    
    if scrapProgress[vehicle][part.name] then
        lib.notify({
            title = _U('scrapyard'),
            description = _U('part_already_scrapped'),
            type = 'error'
        })
        return
    end
    
    -- Kontrola required itemu
    if part.requiredItem then
        ESX.TriggerServerCallback('esx_scrapyard:hasRequiredItem', function(hasItem)
            if not hasItem then
                lib.notify({
                    title = _U('scrapyard'),
                    description = _U('missing_required_item', part.requiredItem),
                    type = 'error'
                })
                return
            end
            
            PerformScrapAction(vehicle, part)
        end, part.requiredItem)
    else
        PerformScrapAction(vehicle, part)
    end
end

-- Provedení rozebírání
function PerformScrapAction(vehicle, part)
    local playerPed = PlayerPedId()
    
    -- Animace
    if part.animation then
        RequestAnimDict(part.animation.dict)
        while not HasAnimDictLoaded(part.animation.dict) do
            Wait(100)
        end
        TaskPlayAnim(playerPed, part.animation.dict, part.animation.anim, 8.0, -8.0, -1, part.animation.flag, 0, false, false, false)
    end
    
    -- Progressbar
    if lib.progressBar({
        duration = part.duration,
        label = _U('scrapping_part', part.label),
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        }
    }) then
        ClearPedTasks(playerPed)
        
        -- Označit část jako rozebranou
        scrapProgress[vehicle][part.name] = true
        
        -- Vizuální poškození
        DamageVehiclePart(vehicle, part)
        
        -- Server-side reward
        TriggerServerEvent('esx_scrapyard:scrapPart', VehToNet(vehicle), part.name, part.rewards, part.requiredItem, part.removeRequiredItem)
        
        -- Kontrola kompletního rozebírání
        CheckCompleteScrap(vehicle)
    else
        ClearPedTasks(playerPed)
        lib.notify({
            title = _U('scrapyard'),
            description = _U('scrap_cancelled'),
            type = 'error'
        })
    end
end

-- Poškození části vozidla
function DamageVehiclePart(vehicle, part)
    if part.name:find("door") then
        local doorIndex = 0
        if part.name == "door_front_left" then doorIndex = 0
        elseif part.name == "door_front_right" then doorIndex = 1
        elseif part.name == "door_rear_left" then doorIndex = 2
        elseif part.name == "door_rear_right" then doorIndex = 3
        end
        SetVehicleDoorBroken(vehicle, doorIndex, true)
    elseif part.name == "hood" then
        SetVehicleDoorBroken(vehicle, 4, true)
    elseif part.name == "trunk" then
        SetVehicleDoorBroken(vehicle, 5, true)
    elseif part.name:find("wheel") then
        local wheelIndex = 0
        if part.name == "wheel_front_left" then wheelIndex = 0
        elseif part.name == "wheel_front_right" then wheelIndex = 1
        elseif part.name == "wheel_rear_left" then wheelIndex = 4
        elseif part.name == "wheel_rear_right" then wheelIndex = 5
        end
        SetVehicleTyreBurst(vehicle, wheelIndex, true, 1000.0)
    elseif part.name == "engine" then
        SetVehicleEngineHealth(vehicle, 0.0)
    end
end

-- Kontrola kompletního rozebírání
function CheckCompleteScrap(vehicle)
    local allPartsScraped = true
    
    for _, part in ipairs(Config.VehicleParts) do
        if not scrapProgress[vehicle][part.name] then
            allPartsScraped = false
            break
        end
    end
    
    if allPartsScraped then
        TriggerServerEvent('esx_scrapyard:completeScrap', VehToNet(vehicle))
        
        if Config.RemoveVehicleAfterScrap then
            Wait(2000)
            ESX.Game.DeleteVehicle(vehicle)
        end
        
        currentScrapVehicle = nil
        scrapProgress[vehicle] = nil
    end
end

-- Cleanup při odpojení
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    for _, npc in pairs(spawnedNPCs) do
        if DoesEntityExist(npc) then
            DeleteEntity(npc)
        end
    end
    
    for _, blip in pairs(activeBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
end)

-- Utility funkce pro překlad
function _U(str, ...)
    if Locales[Config.Locale] and Locales[Config.Locale][str] then
        return string.format(Locales[Config.Locale][str], ...)
    else
        return 'Translation [' .. str .. '] not found'
    end
end
