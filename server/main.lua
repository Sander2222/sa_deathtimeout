--made by Sander#2211

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--Sendet alle Daten zu Client
RegisterServerEvent('sa_banking:GetBalance')
AddEventHandler('sa_banking:GetBalance', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    balance = xPlayer.getAccount('bank').money
    name = xPlayer.getName()
    TriggerClientEvent('sa_banking:SendNUI', _source, balance, name, true)

end)

--Auszahlen
RegisterServerEvent('sa_banking:Withdraw')
AddEventHandler('sa_banking:Withdraw', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local balance = xPlayer.getAccount('bank').money 
    local amount = tonumber(amount)

    if amount == nil or amount <= 0 then
      TriggerClientEvent('esx:showAdvancedNotification', _source, Language['Bank'], Language['Withdraw'], Language['NotValid'], Language['NotifyIcon'], 3)
    else 
        if amount <= balance then
            xPlayer.removeAccountMoney('bank', amount)
            xPlayer.addMoney(amount)
            TriggerClientEvent('esx:showAdvancedNotification', _source, Language['Bank'], Language['Withdraw'], Language['WithdrawMoney'] ..amount.. Language['Money'], Language['NotifyIcon'], 3)
        else
          TriggerClientEvent('esx:showAdvancedNotification', _source, Language['Bank'], Language['Withdraw'], Language['NotEnoughMoney'], Language['NotifyIcon'], 3)
        end
    end
end)


--Einzahlen
RegisterServerEvent('sa_banking:Deposit')
AddEventHandler('sa_banking:Deposit', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local amount = tonumber(amount)
    local HandMoney = xPlayer.getMoney()

    if amount == nil or amount <= 0 then
      TriggerClientEvent('esx:showAdvancedNotification', _source, Language['Bank'], Language['Deposit'], Language['NotValid'], Language['NotifyIcon'], 3)
    else
        if amount <= HandMoney then
            xPlayer.removeMoney(amount)
            xPlayer.addAccountMoney('bank', tonumber(amount))
            TriggerClientEvent('esx:showAdvancedNotification', _source, Language['Bank'], Language['Deposit'], Language['DepositMoney'] ..amount.. Language['Money'], Language['NotifyIcon'], 3)
        else
          TriggerClientEvent('esx:showAdvancedNotification', _source, Language['Bank'], Language['Deposit'], Language['NotEnoughMoney'], Language['NotifyIcon'], 3)
        end
    end
end)


--Übwerweisen
RegisterServerEvent('sa_banking:Transfer')
AddEventHandler('sa_banking:Transfer', function(amount, Target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(Target)
    local xPlayerBank = xPlayer.getAccount('bank').money
    amount = tonumber(amount)

     if xTarget ~= nil and GetPlayerEndpoint(Target) ~= nil then
        --idk why this is working, but it works lol
        if tonumber(_source) ~= tonumber(Target) then
            if balance <= 0 or balance < amount or amount <= 0 then
              TriggerClientEvent('esx:showAdvancedNotification', _source, Language['Bank'], Language['Transfer'], Language['NotEnoughMoney'], Language['NotifyIcon'], 3)
            else 
                xPlayer.removeAccountMoney('bank', amount)
                xTarget.addAccountMoney('bank', amount)
                TriggerClientEvent('esx:showAdvancedNotification', _source, Language['Bank'], Language['Transfer'], Language['TransferSource'] ..amount.. Language['Money'], Language['NotifyIcon'], 3)
                TriggerClientEvent('esx:showAdvancedNotification', Target, Language['Bank'], Language['Transfer'], Language['TransferTarget'] ..amount.. Language['Money'], Language['NotifyIcon'], 3)
            end
        else 
          TriggerClientEvent('esx:showAdvancedNotification', _source, Language['Bank'], Language['Transfer'], Language['TransferToSelf'], Language['NotifyIcon'], 3)
        end
     else
      TriggerClientEvent('esx:showAdvancedNotification', _source, Language['Bank'], Language['Transfer'], Language['PlayerNotExists'], Language['NotifyIcon'], 3)
     end
end)



