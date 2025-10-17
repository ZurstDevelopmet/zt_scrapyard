local ESX = exports['es_extended']:getSharedObject()
local activeScrapVehicles = {}

-- Kontrola, zda může hráč rozebrat vozidlo
ESX.RegisterServerCallback('esx_scrapyard:canScrapVehicle', function(source, cb, vehicleNetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        cb(false, _U('error_occurred'))
        return
    end
    
    -- Kontrola minimálního počtu policistů
    if Config.MinimumPolice > 0 then
        local policeCount = GetPoliceCount()
        if policeCount < Config.MinimumPolice then
            cb(false, _U('not_enough_police', Config.MinimumPolice))
            return
        end
    end
    
    -- Kontrola, zda vozidlo již není rozebíráno
    if activeScrapVehicles[vehicleNetId] then
        cb(false, _U('vehicle_already_scrapping'))
        return
    end
    
    activeScrapVehicles[vehicleNetId] = source
    cb(true)
end)

-- Kontrola required itemu
ESX.RegisterServerCallback('esx_scrapyard:hasRequiredItem', function(source, cb, itemName)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        cb(false)
        return
    end
    
    if Config.UseOxInventory then
        local item = exports.ox_inventory:GetItem(source, itemName, nil, true)
        cb(item and item > 0)
    else
        local item = xPlayer.getInventoryItem(itemName)
        cb(item and item.count > 0)
    end
end)

-- Rozebírání části
RegisterNetEvent('esx_scrapyard:scrapPart', function(vehicleNetId, partName, rewards, requiredItem, removeRequiredItem)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Odebrání required itemu
    if requiredItem and removeRequiredItem then
        if Config.UseOxInventory then
            exports.ox_inventory:RemoveItem(source, requiredItem, 1)
        else
            xPlayer.removeInventoryItem(requiredItem, 1)
        end
    end
    
    -- Přidání odměn
    local receivedItems = {}
    for _, reward in ipairs(rewards) do
        local amount = math.random(reward.min, reward.max)
        
        if reward.item == "money" then
            xPlayer.addMoney(amount)
            table.insert(receivedItems, amount .. "$ (hotovost)")
        elseif reward.item == "black_money" then
            xPlayer.addAccountMoney('black_money', amount)
            table.insert(receivedItems, amount .. "$ (černé peníze)")
        else
            if Config.UseOxInventory then
                local success = exports.ox_inventory:CanCarryItem(source, reward.item, amount)
                if success then
                    exports.ox_inventory:AddItem(source, reward.item, amount)
                    table.insert(receivedItems, amount .. "x " .. reward.item)
                else
                    TriggerClientEvent('ox_lib:notify', source, {
                        title = _U('scrapyard'),
                        description = _U('cannot_carry'),
                        type = 'error'
                    })
                    return
                end
            else
                xPlayer.addInventoryItem(reward.item, amount)
                table.insert(receivedItems, amount .. "x " .. reward.item)
            end
        end
    end
    
    -- Notifikace
    TriggerClientEvent('ox_lib:notify', source, {
        title = _U('scrapyard'),
        description = _U('received_items', table.concat(receivedItems, ", ")),
        type = 'success'
    })
    
    -- Log (můžeš přidat discord webhook)
    print(string.format('[SCRAPYARD] %s (%s) rozebral část %s z vozidla %s', 
        xPlayer.getName(), xPlayer.identifier, partName, vehicleNetId))
end)

-- Kompletní rozebírání
RegisterNetEvent('esx_scrapyard:completeScrap', function(vehicleNetId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    if not Config.CompleteScrapBonus.enabled then
        activeScrapVehicles[vehicleNetId] = nil
        return
    end
    
    -- Bonus odměny
    local bonusItems = {}
    for _, reward in ipairs(Config.CompleteScrapBonus.rewards) do
        local amount = math.random(reward.min, reward.max)
        
        if reward.item == "money" then
            xPlayer.addMoney(amount)
            table.insert(bonusItems, amount .. "$ (hotovost)")
        elseif reward.item == "black_money" then
            xPlayer.addAccountMoney('black_money', amount)
            table.insert(bonusItems, amount .. "$ (černé peníze)")
        else
            if Config.UseOxInventory then
                exports.ox_inventory:AddItem(source, reward.item, amount)
            else
                xPlayer.addInventoryItem(reward.item, amount)
            end
            table.insert(bonusItems, amount .. "x " .. reward.item)
        end
    end
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = _U('scrapyard'),
        description = _U('vehicle_scrapped_complete', table.concat(bonusItems, ", ")),
        type = 'success',
        duration = 7000
    })
    
    activeScrapVehicles[vehicleNetId] = nil
    
    -- Log
    print(string.format('[SCRAPYARD] %s (%s) kompletně rozebral vozidlo %s', 
        xPlayer.getName(), xPlayer.identifier, vehicleNetId))
end)

-- Pomocná funkce pro počet policistů
function GetPoliceCount()
    local count = 0
    local xPlayers = ESX.GetExtendedPlayers()
    
    for _, xPlayer in pairs(xPlayers) do
        if xPlayer.job.name == 'police' then
            count = count + 1
        end
    end
    
    return count
end

-- Utility funkce pro překlad
function _U(str, ...)
    if Locales[Config.Locale] and Locales[Config.Locale][str] then
        return string.format(Locales[Config.Locale][str], ...)
    else
        return 'Translation [' .. str .. '] not found'
    end
end
