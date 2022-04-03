ESX = nil

local cachedBins = {}
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(2)
        local playerPed = PlayerPedId()
        local ped_coords = GetEntityCoords(playerPed)
        local inRange = false
        local distance = GetDistanceBetweenCoords(pedCoords, Config.BinSearch["SellLocations"], true)
        if GetDistanceBetweenCoords(ped_coords, Config.BinSearch["SellLocations"], true) < 1.5 then 
            inRange = true
            DrawMarker(20, Config.BinSearch["SellLocations"], 0.3, 0.3, 0.2, 134, 156, 100, false, false, false, true, false, false, false)
            DrawScriptText(Config.BinSearch["SellLocations"], _U('SellText-1'))
            if IsControlJustPressed(0, 38) then 
                TriggerServerEvent('ac-binsearch:server:startSell')
                TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, 1)
                DisableControlAction(0, 105, true)
            end
        elseif GetDistanceBetweenCoords(ped_coords, Config.BinSearch["SellLocations"], true) < 3.0 then 
            inRange = true
            DrawMarker(20, Config.BinSearch["SellLocations"], 0.3, 0.3, 0.2, 134, 156, 100, false, false, false, true, false, false, false)
            DrawScriptText(Config.BinSearch["SellLocations"], _U('SellText-2'))
        elseif GetDistanceBetweenCoords(ped_coords, Config.BinSearch["SellLocations"], true) < 15.0 then 
            inRange = true
            DrawMarker(20, Config.BinSearch["SellLocations"], 0.3, 0.3, 0.2, 134, 156, 100, false, false, false, true, false, false, false)
        end
        if not inRange then 
            Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Wait(2)
        local inRange = false
        local entity, entityDist = ESX.Game.GetClosestObject(Config.BinSearch["AvailableBins"])
        if DoesEntityExist(entity) and entityDist <= 1.5 then 
            inRange = true
            local binCoords = GetEntityCoords(entity)
            DrawScriptText(binCoords + vector3(0.0, 0.0, 0.5), "~b~E~s~ - Doorzoek prullenbak")
            if IsControlJustReleased(0, 38) then 
                if not cachedBins[entity] then 
                    cachedBins[entity] = true
                    receiveItem()
                else
                    ESX.ShowNotification(_U("AlreadySearched"))
                end
            end
        end
        if not inRange then 
            Wait(1500)
        end
    end
end)

receiveItem = function()
    Progressbar('receive_item', _U("Searching"), 7500, false, true, {
        disableMovement = true,
        disableControls = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@heists@narcotics@trash",
        anim = "pickup",
        flags = 16,
    }, {}, {}, function(onDone)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('ac-binsearch:server:giveItem')
    end)
end