ESX = nil

local PlayerSellings = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ac-binsearch:server:giveItem')
AddEventHandler('ac-binsearch:server:giveItem', function()
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)

    local amount = xPlayer.getInventoryItem(Config.BinSearch["ItemNeeded"]).count

    if amount >= 25 then 
        TriggerClientEvent('esx:showNotification', src, _U('InventoryFull'))
    else
        local receive = Config.BinSearch["ReceiveBottle"]
        local item = Config.BinSearch["ItemNeeded"]
        xPlayer.addInventoryItem(item, receive)
        TriggerClientEvent('esx:showNotification', src, "Je hebt ~g~"..receive.."x~s~ flessen gevonden!")
    end
end)

sellBottles = function(source)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    SetTimeout(Config.BinSearch["SellWaitTime"], function()
        if PlayerSellings[source] == true then
            local src = source 
            local xPlayer = ESX.GetPlayerFromId(src)

            local amount = xPlayer.getInventoryItem(Config.BinSearch["ItemNeeded"]).count 
            local distance = #(playerCoords - Config.BinSearch["SellLocations"]) 
        
            if amount < 1 then 
                TriggerClientEvent('esx:showNotification', src, _U('NoMoreItems'))
                PlayerSellings[src] = false
            else
                local amount = 1
                local item = Config.BinSearch["ItemNeeded"]
                local reward = Config.BinSearch["RewardBottle"]
                Citizen.Wait(1500)
                xPlayer.removeInventoryItem(item, amount)
                xPlayer.addAccountMoney('bank', Config.BinSearch["RewardBottle"])
                TriggerClientEvent('esx:showNotification', src, _U('Sell-Earned', ESX.Math.GroupDigits(Config.BinSearch["RewardBottle"])))
                sellBottles(src)
            end
        end
    end)
end

RegisterServerEvent('ac-binsearch:server:startSell')
AddEventHandler('ac-binsearch:server:startSell', function()
    local src = source
    if PlayerSellings[src] == false then 
        TriggerClientEvent('esx:showNotification', src, _U('NoMoreItems'))
        PlayerSellings[src] = false
    else
        PlayerSellings[src] = true
        TriggerClientEvent('esx:showNotification', src, _U('StartedSelling'))
        sellBottles(src)
    end
end)

RegisterServerEvent('ac-binsearch:server:stopSell')
AddEventHandler('ac-binsearch:server:stopSell', function()
    local src = source 
    if PlayerSellings[src] == true then 
        PlayerSellings[src] = false
    else
        PlayerSellings[src] = true
    end
end)