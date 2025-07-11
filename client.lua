local function spawnDoctorPeds()
    local model = Config.PedModel
    lib.requestModel(model)

    for i, loc in pairs(Config.Locations) do
        local ped = CreatePed(0, model, loc.coords.x, loc.coords.y, loc.coords.z - 1.0, loc.coords.w, false, false)
        SetEntityAsMissionEntity(ped, true, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        local blip = AddBlipForCoord(loc.coords.x, loc.coords.y, loc.coords.z)
        SetBlipSprite(blip, 458)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 2)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Physical Therapy")
        EndTextCommandSetBlipName(blip)

        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'remove_crutch_' .. i,
                icon = 'fas fa-wheelchair',
                label = 'Talk To Physical Therapist ',
        onSelect = function()
    local cost = tonumber(loc.cost)
        lib.registerContext({
        id = 'crutch_payment_menu_' .. i,
        title = 'Pay for Physical Therapy',
        options = {
            {
                title = 'Pay with Cash',
                description = 'Use physical cash from your wallet.',
                icon = 'dollar-sign',
                onSelect = function()
                    TriggerServerEvent('removeCrutch:payAndRemove', cost, 'money')
                end
            },
            {
                title = 'Pay with Bank',
                description = 'Use funds from your bank account.',
                icon = 'university',
                onSelect = function()
                    TriggerServerEvent('removeCrutch:payAndRemove', cost, 'bank')
                end
            }
        }
    })

    lib.showContext('crutch_payment_menu_' .. i)
end

            }
        })
    end
end

CreateThread(spawnDoctorPeds)

RegisterNetEvent('removeCrutch:success', function()
    local ped = PlayerPedId()

    local done = lib.progressCircle({
        duration = 5000,
        position = 'bottom',
        label = 'Removing crutch',
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = false,
            car = true,
            mouse = false,
            combat = true
        }
    })

    ClearPedTasks(ped)

    if done then
        TriggerEvent('wasabi_crutch:breakLoop')
        lib.notify({
            title = 'Physical Therapy',
            description = 'Physical Therapy Done. Crutch removed! Walk safe.',
            type = 'success'
        })
    end
end)

RegisterNetEvent('removeCrutch:notEnoughMoney', function()
    lib.notify({
        title = 'Doctor',
        description = 'You don’t have enough money!',
        type = 'error'
    })
end)
