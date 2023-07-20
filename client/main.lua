ESX = exports["es_extended"]:getSharedObject()
UiActive = false

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
        print("ff")
        SendNUIMessage({
            type = "ui",
            status = "show"
        })
    end
    UiActive = true

    print("ldldff")
    SendNUIMessage({
        type = "ui",
        status = "add",
        time = Time
    })
end

RegisterNetEvent('sa_timeout:client:UpdateTimeOut')
AddEventHandler('sa_timeout:client:UpdateTimeOut', function(TimeSec)
    SetDisplay(TimeSec)

    print("Update", TimeSec)
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