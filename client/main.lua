ESX = exports["es_extended"]:getSharedObject()
UiActive = false
TimeSendServer = 0

-- RegisterNUICallback("exit", function(data)
--     SetDisplay(false)
-- end)

-- --
-- -- Disable keys
-- --
-- Citizen.CreateThread(function()
--     while display do
--         Citizen.Wait(0)
--         DisableControlAction(0, 1, display)
--         DisableControlAction(0, 2, display)
--         DisableControlAction(0, 142, display)
--         DisableControlAction(0, 18, display)
--         DisableControlAction(0, 322, display)
--         DisableControlAction(0, 106, display)
--     end
-- end)


function SetDisplay(Time)
    if not UiActive then
        SendNUIMessage({
            type = "ui",
            status = "show"
        })
    end
    UiActive = true

    SendNUIMessage({
        type = "ui",
        status = "add",
        time = Time
    })
end

RegisterNetEvent('sa_timeout:client:UpdateTimeOut')
AddEventHandler('sa_timeout:client:UpdateTimeOut', function(TimeSec)
    SetDisplay(TimeSec)
    local Time = 0

    TimeSendServer = 1000 
end)

RegisterNetEvent('sa_timeout:client:RemoveTimeout')
AddEventHandler('sa_timeout:client:RemoveTimeout', function()
    -- Disable UI
    SendNUIMessage({
        type = "ui",
        status = "close"
    })
    UiActive = false
end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()
    TriggerServerEvent('sa_timeout:server:AddPlayerTimeout')
end)

Weapon = false

CreateThread(function ()
	while true do
        if TimeSendServer > 0 or UiActive then
            if not UiActive then
                TimeSendServer = 0
            end
            DisableControlAction(1, 37) -- TAB
            DisableControlAction(1, 24) -- Left Mouse
            DisableControlAction(1, 140) -- R
			SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true) -- Set weapon on hands
            TimeSendServer = TimeSendServer - 1
        else 
            Wait(500)
        end
        Wait(1)
	end
end)

RegisterCommand(Config.RemoveTimeoutRadius, function(source, args, rawCommand)
    ESX.TriggerServerCallback('sa_timeout:callback:CheckGroup', function(CanUseCommand)
        if CanUseCommand then
            if not next(args) then
                local TmpPlayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), tonumber(args[1]))
                local Players = {}

                for k,v in ipairs(TmpPlayers) do
                    table.insert(Players, GetPlayerServerId(v))
                end

                if next(Players) then
                     ESX.ShowNotification('Es sind keine Spieler in der nähe')
                    return
                end
                
                TriggerServerEvent('sa_timeout:server:RemoveTimeoutFromPlayers', Players)
            else
                ESX.ShowNotification(Config.Locals['EnterNumber'])
            end
        else
            ESX.ShowNotification(Config.Locals['NoRights'])
        end
    end)
end)