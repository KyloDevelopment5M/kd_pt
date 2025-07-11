RegisterNetEvent('removeCrutch:payAndRemove', function(cost, method)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        print("[ERROR] Player not found for source:", src)
        return
    end

    print('[DEBUG] Method:', method)
    print('[DEBUG] Cost:', cost)

    if method == 'money' then
        local cash = xPlayer.getMoney()
        print('[DEBUG] Player Cash:', cash)

        if cash >= cost then
            xPlayer.removeMoney(cost)
            TriggerClientEvent('removeCrutch:success', src)
        else
            print('[DEBUG] Not enough cash')
            TriggerClientEvent('removeCrutch:notEnoughMoney', src)
        end

    elseif method == 'bank' then
        local bankAccount = xPlayer.getAccount('bank')
        local bank = bankAccount and bankAccount.money or 0
        print('[DEBUG] Player Bank:', bank)

        if bank >= cost then
            xPlayer.removeAccountMoney('bank', cost)
            TriggerClientEvent('removeCrutch:success', src)
        else
            print('[DEBUG] Not enough bank')
            TriggerClientEvent('removeCrutch:notEnoughMoney', src)
        end
    else
        print("[ERROR] Invalid payment method:", method)
    end
end)
