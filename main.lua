QBCore = nil

local QBCore = exports['qb-core']:GetCoreObject()
local timeout = false

RegisterCommand('engineon', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped and not timeout then
        local plate = GetVehicleNumberPlateText(vehicle)
        
        timeout = true -- put time out for spamming you can it (remember removing timeout in ifs and lines 20 and 21)

        if exports['qb-vehiclekeys']:HasKeys(plate) and not GetIsVehicleEngineRunning(vehicle) and not IsPauseMenuActive() then
            SetVehicleEngineOn(vehicle, true, false, true)
            TriggerEvent('QBCore:Notify', 'Engine Started')
        end
        
        Wait(750)
        timeout = false
    end
end, false)

RegisterCommand('engineoff', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped and not timeout then
        local plate = GetVehicleNumberPlateText(vehicle)
        timeout = true -- put time out for spamming you can it (remember removing timeout in ifs and lines 39 and 40)
        if exports['qb-vehiclekeys']:HasKeys(plate) and GetIsVehicleEngineRunning(vehicle) and not IsPauseMenuActive() then
            SetVehicleEngineOn(vehicle, false, false, true)
            TriggerEvent('QBCore:Notify', 'Engine Halted')
        end
        
        disableForward()

        Wait(750)
        timeout = false
    end
end, false)

RegisterKeyMapping('engineon', 'Turn Vehicle Engine On', 'mouse_wheel', 'iom_wheel_up')
RegisterKeyMapping('engineoff', 'Turn Vehicle Engine Off', 'mouse_wheel', 'iom_wheel_down')

function disableForward()
    CreateThread(function()
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        while IsPedInAnyVehicle(ped, false) and GetEntitySpeed(veh) > 1.0 do -- i didn't find any native for fixing this issue (when you stop engine with pressing w player can turn vehicle on without key if the vehicle is not stopeed !)
            DisableControlAction(1, 136, true)
            DisableControlAction(1, 87, true)
            DisableControlAction(1, 77, true)
            DisableControlAction(1, 71, true)
            DisableControlAction(1, 32, true)
            SetVehicleEngineOn(veh, false, false, true)
            Wait(20)
        end
    end)
end

