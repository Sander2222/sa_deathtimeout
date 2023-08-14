ESX = exports["es_extended"]:getSharedObject()
PlayerTimeOuts = {}

RegisterCommand(Config.RemoveTimeout, function(source, args, rawCommand)
  local xPlayer = ESX.GetPlayerFromId(source)

  if not next(args) then return end

  if CheckGroup(xPlayer.getGroup()) then
    RemoveTimeOutFromPlayer(tonumber(args[1]), source)
  else 
    xPlayer.showNotification(Config.Locals['NoRights'])
  end
end)

RegisterNetEvent('sa_deathtimeout:server:AddPlayerTimeout')
AddEventHandler('sa_deathtimeout:server:AddPlayerTimeout', function()
  AddTimeoutToPlayer(source)
end)

function AddTimeoutToPlayer(TargetID)
  local DataTable = {}
  local xPlayer =  ESX.GetPlayerFromId(TargetID)

  DataTable.Source = TargetID
  DataTable.Identifier = xPlayer.getIdentifier()
  DataTable.Time = Config.Timeout

  table.insert(PlayerTimeOuts, DataTable)
end

function RemoveTimeOutFromPlayer(TargetID, PlayerID)
  for i, v in ipairs(PlayerTimeOuts) do
    if v.Source == TargetID then
      v.Time = 0
      
      if not PlayerID == TargetID then
        -- Notify target
        local xTarget = ESX.GetPlayerFromId(TargetID)
        xTarget.showNotification(Config.Locals['TargetRemoveTimeout'])

        if PlayerID ~= nil then
          -- Notify Player
          local xPlayer = ESX.GetPlayerFromId(PlayerID)
          xPlayer.showNotification((Config.Locals['PlayerRemovedTimeout']):format(TargetID))
        end
      else 
        local xPlayer = ESX.GetPlayerFromId(PlayerID)
        xPlayer.showNotification(Config.Locals['RemovedSelfTimeout'])
      end

      return
    end
  end

  local xPlayer = ESX.GetPlayerFromId(PlayerID)
  xPlayer.showNotification(Config.Locals['NoPlayerWithTimeOut'])
end

CreateThread(function()
    while true do
        for k, v in ipairs(PlayerTimeOuts) do
          if v.Source ~= nil then
              if v.Time <= 0 then
                  TriggerClientEvent('sa_deathtimeout:client:RemoveTimeout', v.Source)
                  table.remove(PlayerTimeOuts, k)
              else 
                  TriggerClientEvent('sa_deathtimeout:client:UpdateTimeOut', v.Source, v.Time)
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

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
  local source = source
  local xPlayer =  ESX.GetPlayerFromId(source)

  for k, v in ipairs(PlayerTimeOuts) do
    if v.Identifier == xPlayer.getIdentifier() then
      v.Source = source
    end
  end
end)

RegisterNetEvent('sa_deathtimeout:server:RemoveTimeoutFromPlayers')
AddEventHandler('sa_deathtimeout:server:RemoveTimeoutFromPlayers', function(PlayerList)
  local xPlayer =  ESX.GetPlayerFromId(source)

  if CheckGroup(xPlayer.getGroup()) then
    for k, v in pairs(PlayerList) do
      RemoveTimeOutFromPlayer(v)
    end
  else 
    print((Config.Locals['ProbablyModder']):format(source, xPlayer.getIdentifier()))
    xPlayer.kick(Config.Locals['ContactSupport'])
  end
end)

ESX.RegisterServerCallback('sa_deathtimeout:callback:CheckGroup', function(src, cb)
  local xPlayer = ESX.GetPlayerFromId(src)
  cb(CheckGroup(xPlayer.getGroup()))
end)

function CheckGroup(Group)
  for k, v in pairs(Config.Groups) do
    if v == Group then
      return true
    end
  end

  return false
end