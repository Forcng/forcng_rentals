ESX = exports['es_extended']:getSharedObject()

AddEventHandler("forcng:client:openMenu", function()
    for k, v in pairs(Config.Rents) do
        lib.registerContext({
            id = 'rent',
            title = v.title,
            options = v.vehicles
        })
        lib.showContext('rent')
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Rents) do
        if Config.Rent == "qtarget" then
            exports.qtarget:AddTargetModel({Config.PedModel}, {
                options = {
                    {
                        event = "forcng:client:openMenu",
                        icon = Strings.rentIcon,
                        label = Strings.targetRent
                    },
                },
                distance = 1.5
            })
        elseif Config.Rent == "ox_target" then
            exports.ox_target:addModel(Config.PedModel, {
                {
                    event = "forcng:client:openMenu",
                    icon = Strings.rentIcon,
                    label = Strings.targetRent,
                    distance = 1.5
                }
            })
        elseif Config.Rent == "ox_lib" then
            while true do 
                Wait(0)
                sleep = true
                if #(GetEntityCoords(PlayerPedId()) - v.coords) < 2.0 then 
                    sleep = false
                    lib.showTextUI(Strings.textuforcng, {
                        icon = Strings.rentIcon
                    })
                    if IsControlJustPressed(0, 38) then 
                        TriggerEvent('forcng:client:openMenu')
                    end
                else
                    lib.hideTextUI()
                end
                if sleep then 
                    Wait(1312)
                end
            end
        end
    end
end)


Citizen.CreateThread(function()
	for k, v in pairs(Config.Rents) do
        RequestModel(GetHashKey(Config.PedModel))
	    while not HasModelLoaded(GetHashKey(Config.PedModel)) do
	    Wait(1)
	end
	    Cockadoo = CreatePed(4, Config.PedModel, v.coords , v.heading, false, true)
	    FreezeEntityPosition(Cockadoo, true) 
	    SetEntityInvincible(Cockadoo, true)
	    SetBlockingOfNonTemporaryEvents(Cockadoo, true)
    end
end)


-- If you use a key system thats not here you can easily add it by going to your supported key system docs and adding it here.
function GiveCarKeys(vehicle)
    if Config.Keys == "mk_vehiclekeys" then
        exports["mk_vehiclekeys"]:AddKey(vehicle)
    elseif Config.Keys == "wasabi_carlock" then
        exports["wasabi_carlock"]:GiveKey(vehicle)
    end
end


AddEventHandler("forcng:client:spawnVehicle", function(data)
    if ESX.Game.IsSpawnPointClear(data.spawn, 5) then
        ESX.TriggerServerCallback("forcng:server:checkMoney", function(gotEnough)
            if gotEnough then

                ESX.Game.SpawnVehicle(data.vehicle, data.spawn, data.heading, function(vehicle)
                    local primaryColor = math.random(0, 255)
                    local secondaryColor = math.random(0, 255)

                    SetVehicleCustomPrimaryColour(vehicle, primaryColor, primaryColor, primaryColor)
                    SetVehicleCustomSecondaryColour(vehicle, secondaryColor, secondaryColor, secondaryColor)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    GiveCarKeys(vehicle)

                end)

                lib.notify({
                    title = 'Rentals',
                    description = 'You\'ve successfully rented a bumper car! Enjoy.',
                    position = 'center-right',
                    type = 'success',
                    duration = 5000,
                    icon = 'car'
                })
                lib.notify({
                    title = 'Rentals',
                    description = 'To return your bumper car use /returnrental',
                    position = 'center-right',
                    type = 'info',
                    duration = 5000,
                    icon = 'circle-info'
                })
            else
                lib.notify({
                    title = 'Rentals',
                    description = 'You don\'t have enough cash',
                    position = 'center-right',
                    type = 'error',
                    icon = 'money-bill'
                })
            end
        end, data.price)
    else
        lib.notify({
            title = 'Rentals',
            description = 'The spawn area is currently blocked, make sure it\'s clear before renting a vehicle.',
            position = 'center-right',
            type = 'error',
            icon = 'ban'
        })
    end
end)


RegisterCommand('returnrental', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        local model = GetEntityModel(vehicle)

        local isRentedVehicle = false

        for _, rent in pairs(Config.Rents) do
            for _, v in pairs(rent.vehicles) do
                local modelName = v.vehicle or (v.args and v.args.vehicle)
                if modelName and model == GetHashKey(modelName) then
                    isRentedVehicle = true
                    break
                end
            end
            if isRentedVehicle then break end
        end

        if isRentedVehicle then
            SetEntityAsMissionEntity(vehicle, true, true)
            DeleteVehicle(vehicle)

            lib.notify({
                title = 'Rentals',
                description = 'Vehicle returned.',
                position = 'center-right',
                type = 'success',
                icon = 'car',
            })
        else
            lib.notify({
                title = 'Rentals',
                description = 'This is not a rental vehicle.',
                position = 'center-right',
                type = 'error',
                icon = 'ban',
            })
        end
    else
        lib.notify({
            title = 'Rentals',
            description = 'You must be in a rental vehicle to return it.',
            position = 'center-right',
            type = 'error',
            icon = 'ban'
        })
    end
end)


TriggerEvent('chat:addSuggestion', '/returnrental', 'Returns your bumper car back to the rental.', {})