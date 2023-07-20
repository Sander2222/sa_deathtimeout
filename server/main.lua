PlayerTimeOuts = {}

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local DataTable = {}
    local xPlayer =  ESX.GetPlayerFromId(data.victim)

    DataTable.Identifier = xPlayer.getIdentifier()
    DataTable.Time = Config.Timeout

    table.insert(PlayerTimeOuts, DataTable)
end)

CreateThread(function()
    while true do
        for k, v in ipairs(PlayerTimeOuts) do
            if v.Time <= 1 then
                TriggerClientEvent('sa_timeout:client:RemoveTimeout', source, v.Time)
            else 
                TriggerClientEvent('sa_timeout:client:UpdateTimeOut', source, v.Time)
            end
        end
        Wait(1000)
    end
end)