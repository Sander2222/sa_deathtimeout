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
  local xPlayer =  ESX.GetPlayerFromId(TargetID)

  PlayerTimeOuts[xPlayer.getIdentifier()] = {
    Source = TargetID,
    Time = Config.Timeout
  }
end

function RemoveTimeOutFromPlayer(TargetID, PlayerID)
  local xTarget = ESX.GetPlayerFromId(TargetID)

  if xTarget ~= nil then
    if PlayerTimeOuts[xTarget.getIdentifier()] ~= nil then
      TriggerClientEvent('sa_deathtimeout:client:RemoveTimeout', PlayerTimeOuts[xTarget.getIdentifier()].Source)
      PlayerTimeOuts[xTarget.getIdentifier()] = nil

      xTarget.showNotification(Config.Locals['TargetRemoveTimeout'])
    end
  else
    if PlayerID ~= nil then
      local xPlayer = ESX.GetPlayerFromId(PlayerID)
      xPlayer.showNotification(Config.Locals['NoPlayerWithTimeOut'])
    end
  end
end

CreateThread(function()
    while true do
        for k, v in pairs(PlayerTimeOuts) do
          if v.Source ~= nil then
              if v.Time > 0 then
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

-- RegisterNetEvent('esx:onPlayerSpawn')
-- AddEventHandler('esx:onPlayerSpawn', function()
--   local source = source
--   local xPlayer =  ESX.GetPlayerFromId(source)

--   if PlayerTimeOuts[xPlayer.getIdentifier()] ~= nil then
--     PlayerTimeOuts[xPlayer.getIdentifier()] = source
--   end
-- end)

RegisterNetEvent('sa_deathtimeout:server:RemoveTimeoutFromPlayers')
AddEventHandler('sa_deathtimeout:server:RemoveTimeoutFromPlayers', function(PlayerList)
  local xPlayer =  ESX.GetPlayerFromId(source)

  if CheckGroup(xPlayer.getGroup()) then
    for k, v in pairs(PlayerList) do
      RemoveTimeOutFromPlayer(v)
    end
  else 
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