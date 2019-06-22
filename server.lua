ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Chasse:depece')
AddEventHandler('Chasse:depece', function(legal)
    local xPlayer = ESX.GetPlayerFromId(source)
    if legal then 
        xPlayer.addInventoryItem('viande', math.random(Config.Legal.nbParAnimalMin , Config.Legal.nbParAnimalMax))
    else
        xPlayer.addInventoryItem('viande2', math.random(Config.Legal.nbParAnimalMin , Config.Legal.nbParAnimalMax))
    end
end)

RegisterServerEvent('Chasse:revente')
AddEventHandler('Chasse:revente', function(legal)
  local xPlayer = ESX.GetPlayerFromId(source)
    if legal then 
        local nbViande = xPlayer.getInventoryItem('viande').count
        if nbViande <= 0 then
            TriggerClientEvent('esx:showNotification', source, 'Je n\'ai plus de viande')            
        else   
            xPlayer.removeInventoryItem("viande", 1)
            xPlayer.addMoney(math.random(Config.Legal.PrixMin, Config.Legal.PrixMax))    
        end
    else
        local nbViande = xPlayer.getInventoryItem('viande2').count
        if nbViande <= 0 then
            TriggerClientEvent('esx:showNotification', source, 'Je n\'ai plus de viande')            
        else   
            xPlayer.removeInventoryItem("viande2", 1)
            if Config.Illegal.ArgentSale then
                xPlayer.addAccountMoney('black_money', math.random(Config.Illegal.PrixMin, Config.Illegal.PrixMax))
            else
                xPlayer.addMoney(math.random(Config.Illegal.PrixMin, Config.Illegal.PrixMax))
            end
        end
    end
end)