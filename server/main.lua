PlayerTimeOuts = {}

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local DataTable = {}
    local xPlayer =  ESX.GetPlayerFromId(data.victim)

    DataTable.Source = data.victim 
    DataTable.Identifier = xPlayer.getIdentifier()
    DataTable.Time = Config.Timeout

    table.insert(PlayerTimeOuts, DataTable)
end)

CreateThread(function()
    while true do
        for k, v in ipairs(PlayerTimeOuts) do
          if v.Source ~= nil then
              if v.Time <= 1 then
                  TriggerClientEvent('sa_timeout:client:RemoveTimeout', v.Source, v.Time)
                  table.remove(PlayerTimeOuts, k)
              else 
                  TriggerClientEvent('sa_timeout:client:UpdateTimeOut', v.Source, v.Time)
                  v.Time = v.Time - 1 
              end
            end
        end
        Wait(1000)
    end
end)

AddEventHandler('playerDropped', function(reason)
  for i, v in ipairs(PlayerTimeOuts) do
    if v.Source == source then
      v.Source = nil
    end
  end
end)


AddEventHandler("playerConnecting", function()
  local Player = source
  local xPlayer
  while xPlayer == nil do
      xPlayer =  ESX.GetPlayerFromId(Player)
      Wait(1)
  end 
  for i, v in ipairs(PlayerTimeOuts) do
    if v.Identifier == xPlayer.getIdentifier() then
      v.Source = Player
    end
  end
end)