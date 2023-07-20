ESX = nil
local display = false
local IsClose = false
local IsAt = false

--ad ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

--
-- Disable keys
--
Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 322, display)
        DisableControlAction(0, 106, display)
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(350)

		IsClose = false
		IsAt = false

        for key, value in ipairs(Config.banks) do
            local dist = #(GetEntityCoords(PlayerPedId() - vector3(value.x, value.y, value.z)))

            if dist <= 2.0 then
					IsClose = true
					IsAt = true
			elseif dist <= 3.0 then
				 IsClose = true
			end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
		if not IsClose then
			Wait(350)
		end
		if IsAt then
			ESX.ShowHelpNotification(Language['PressE'])

			if IsControlJustReleased(0, 38) then
				TriggerServerEvent('sa_banking:GetBalance')
			end
		end
    end
end)

--
-- Map Marker
--


Citizen.CreateThread(function()

	if Config.Blips then
		for k,v in ipairs(Config.banks) do
			local blip = AddBlipForCoord(v.x, v.y, v.z)

			SetBlipSprite(blip, 500)
			SetBlipScale(blip, Config.BlipSize)
			SetBlipColour(blip, 69)
			SetBlipDisplay(blip, 4)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Bank')
			EndTextCommandSetBlipName(blip)
		end
	end
end)

--
-- Map Marker
--

function SetDisplay(bool, balance, name)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
        money = balance,
        UserName = name,
        UserID = GetPlayerServerId(PlayerId())
    })
end

--===============================================
--==           RegisterEvents                  ==
--===============================================


--Sended alle Daten zum UI
RegisterNetEvent('sa_banking:SendNUI')
AddEventHandler('sa_banking:SendNUI', function(balance, name, bool)
	local id = PlayerId()
	local playerName = GetPlayerName(id)

    SetDisplay(true, balance, name)
end)

RegisterNUICallback("Withdraw", function(data, cb)
    SetDisplay(false)
    local amount = data.WithdrawAmount
    
	TriggerServerEvent('sa_banking:Withdraw', amount)
end)

RegisterNUICallback("Deposit", function(data, cb)
    SetDisplay(false)
    local amount = data.WithdrawAmount
    
	TriggerServerEvent('sa_banking:Deposit', amount)
end)

RegisterNUICallback("transfer", function(data, cb)
    SetDisplay(false)
    local amount = data.transferAmount
	local Target = data.PayerID
	TriggerServerEvent('sa_banking:Transfer', amount, Target)
end)