local CurrentActionData, CurrentAction, CurrentActionMsg, hasAlreadyEnteredMarker, lastZone = {}
ESX = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	RegisterNetEvent('esx:playerLoaded')
	AddEventHandler('esx:playerLoaded', function (xPlayer)
		while ESX == nil do
			Citizen.Wait(0)
		end
		ESX.PlayerData = xPlayer
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
	ESX.PlayerData.job = job
end)


--#########################################
--##################UTILS##################
--#########################################


AddEventHandler('esx_bankerjob:hasEnteredMarker', function (zone)
	if zone == 'BankActions' and ESX.PlayerData.job and ESX.PlayerData.job.name == 'pharmacist' then
		CurrentAction     = 'pharmacist_actions_menu'
		CurrentActionMsg  = _U('press_input_context_to_open_menu')
		CurrentActionData = {}
	elseif zone == 'BankStocks' and ESX.PlayerData.job and ESX.PlayerData.job.name == 'pharmacist' then
		CurrentAction     = 'pharmacist_stocks_menu'
		CurrentActionMsg  = _U('press_input_context_to_open_menu')
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		local vehicle   = GetVehiclePedIsIn(playerPed, false)
		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('press_input_context_to_park_car')
			CurrentActionData = { vehicle = vehicle }
		end
	elseif zone == 'VehicleSpawner' then
		CurrentAction     = 'vehicle_spawner'
		CurrentActionMsg  = _U('press_input_context_to_spawn_car')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_pharmacistjob:hasExitedMarker', function (zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.BankActions.Coords)
	SetBlipSprite(blip, 108)
	SetBlipColour(blip, 30)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('Pharmacy store'))
	EndTextCommandSetBlipName(blip)
end)

-- Draw marker & activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'pharmacist' then
			local playerCoords = GetEntityCoords(PlayerPedId())
			local isInMarker, letSleep, currentZone = false, true
			for k,v in pairs(Config.Zones) do
				local distance = #(playerCoords - v.Coords)
				if v.Type ~= -1 and distance < Config.DrawDistance then
					letSleep = false
					DrawMarker(v.Type, v.Coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, nil, nil, false)
				end
				if distance < v.Size.x then
					isInMarker, currentZone, letSleep = true, k, false
				end
			end
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker, lastZone = true, currentZone
				TriggerEvent('esx_bankerjob:hasEnteredMarker', currentZone)
			end
			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_bankerjob:hasExitedMarker', lastZone)
			end
			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'pharmacist' then
				if CurrentAction == 'pharmacist_actions_menu' then
					OpenBankActionsMenu()
				elseif CurrentAction == 'pharmacist_stocks_menu' then
					OpenStocksMenu()
				elseif CurrentAction == 'vehicle_spawner' then
					OpenVehicleSpawnerMenu()
				elseif CurrentAction == 'delete_vehicle' then
				DeleteJobVehicle()
				end
			CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function OpenVehicleSpawnerMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
	{
		css         = 'banker',
		title		= _U('garage'),
		align		= 'top-left',
		elements	= Config.AuthorizedVehicles
	}, function(data, menu)
		if not ESX.Game.IsSpawnPointClear(Config.Zones.VehicleSpawnPoint.Coords, 5.0) then
			ESX.ShowNotification(_U('blocked_spawn_point'))
			return
		end
		if ESX.PlayerData.job.grade_name ~= 'boss' and data.current.auth == 'boss' then
			menu.close()
			ESX.ShowNotification(_U('not_boss'))
		else
			menu.close()
			ESX.Game.SpawnVehicle(data.current.model, Config.Zones.VehicleSpawnPoint.Coords, Config.Zones.VehicleSpawnPoint.Heading, function(vehicle)
				local playerPed = PlayerPedId()
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				SetVehicleEnginePowerMultiplier(vehicle, 60)
				SetVehicleDirtLevel (vehicle, 0) 
				SetVehicleEngineTorqueMultiplier(vehicle, 1.5)
				SetVehicleColours(vehicle, 12 , 12)
				local plate = Config.CompanyPlate .. math.random(10, 99)
				SetVehicleNumberPlateText(vehicle, plate)
			end)
		end	
	end, function(data, menu)
		CurrentAction     = 'vehicle_spawner'
		CurrentActionData = {}
		menu.close()
	end)
end

function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))
	for i=1, #Config.AuthorizedVehicles, 1 do
		if vehModel == GetHashKey(Config.AuthorizedVehicles[i].model) then
			return true
		end
	end
	return false
end

function DeleteJobVehicle()
	local playerPed = PlayerPedId()
	if IsInAuthorizedVehicle() then
		ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
	else
		ESX.ShowNotification(_U('not_in_auth_car'))
	end
end

function Billing()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
		title = _U('amount')
	}, function(data, menu)
		local amount = tonumber(data.value)
		if amount == nil then
			ESX.ShowNotification(_U('invalid_amount'))
		else
			menu.close()
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestDistance > 5.0 then
				ESX.ShowNotification(_U('no_player'))
			else
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_pharmacist', 'Pharmacist', amount)
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end



function OpenStocksMenu()
	local elements = {
		{label = _U('get_weapon'),     	value = 'get_weapon'},
		{label = _U('put_weapon'),     	value = 'put_weapon'},
		{label = _U('take_inventory'),  value = 'get_stock'},
		{label = _U('put_inventory'), 	value = 'put_stock'}
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacist_stocks', {
		title    = _U('pharmacist_stocks_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'get_weapon' then
			OpenGetWeaponMenu()
		elseif data.current.value == 'put_weapon' then
			OpenPutWeaponMenu()
		elseif data.current.value == 'buy_weapons' then
			OpenBuyWeaponsMenu()
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		end
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'pharmacist_stocks_menu'
		CurrentActionMsg  = _U('press_input_context_to_open_menu')
		CurrentActionData = {}
	end)
end

function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('esx_pharmacistjob:getWeapons', function(weapons)
		local elements = {}
		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			css      = 'banker',
			title    = _U('take_weapon_action'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.TriggerServerCallback('esx_pharmacistjob:removeWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()
	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)
		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
		css      = 'banker',
		title    = _U('put_weapon_action'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		ESX.TriggerServerCallback('esx_pharmacistjob:addWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_pharmacistjob:getStockItems', function(items)
		local elements = {}
		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('pharmacist_stocks_title'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)
				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_pharmacistjob:getStockItem', itemName, count)
					Citizen.Wait(300)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_pharmacistjob:getPlayerInventory', function(inventory)
		local elements = {}
		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]
			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			css      = 'pharmacist',
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				css      = 'pharmacist',
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)
				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_pharmacistjob:putStockItems', itemName, count)
					Citizen.Wait(300)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end








