ESX = exports['es_extended']:getSharedObject()
function OpenAdminMenu()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'admin_menu', {
        title    = 'Admin Menu',
        align    = 'top-right',
        elements = {
            {label = 'Player Management', value = 'player_management'},
            {label = 'Vehicle Modifications', value = 'vehicle_modifications'},
        }
    }, function(data, menu)
        if data.current.value == 'player_management' then
            OpenPlayerManagementMenu()
        elseif data.current.value == 'vehicle_modifications' then
            OpenVehicleModificationsMenu()
        end
    end, function(data, menu)
        menu.close()
    end)
end

-- Open player management submenu
function OpenPlayerManagementMenu()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_management_menu', {
        title    = 'Player Management',
        align    = 'top-right',
        elements = {
            {label = 'Kick Player', value = 'kick_player'},
            {label = 'Teleport to Player', value = 'teleport_to_player'},
        }
    }, function(data, menu)
        if data.current.value == 'kick_player' then
            KickPlayer()
        elseif data.current.value == 'teleport_to_player' then
            TeleportToPlayer()
        end
    end, function(data, menu)
        menu.close()
        OpenAdminMenu() -- Reopen admin menu after closing submenu
    end)
end

-- Open vehicle modifications submenu
function OpenVehicleModificationsMenu()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_modifications_menu', {
        title    = 'Vehicle Modifications',
        align    = 'top-right',
        elements = {
            {label = 'Repair Vehicle', value = 'repair_vehicle'},
            {label = 'Change License Plate', value = 'change_license_plate'},
        }
    }, function(data, menu)
        if data.current.value == 'repair_vehicle' then
            RepairVehicle()
        elseif data.current.value == 'change_license_plate' then
            ChangeLicensePlate()
        end
    end, function(data, menu)
        menu.close()
        OpenAdminMenu() -- Reopen admin menu after closing submenu
    end)
end

-- Function to kick player
function KickPlayer()
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
    if distance ~= -1 and distance <= 3 then
        ESX.ShowNotification('Kicked player: ' .. GetPlayerName(closestPlayer))
        TriggerServerEvent('esx:admin:kick', GetPlayerServerId(closestPlayer), 'You have been kicked from the server.')
    else
        ESX.ShowNotification('No player nearby.')
    end
end

-- Function to teleport to player
function TeleportToPlayer()
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
    if distance ~= -1 and distance <= 3 then
        local coords = GetEntityCoords(GetPlayerPed(closestPlayer))
        SetEntityCoords(PlayerPedId(), coords)
        ESX.ShowNotification('Teleported to player: ' .. GetPlayerName(closestPlayer))
    else
        ESX.ShowNotification('No player nearby.')
    end
end

-- Function to repair vehicle
function RepairVehicle()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if DoesEntityExist(vehicle) then
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            SetVehicleEngineOn(vehicle, true, true)
            SetVehicleFuelLevel(vehicle, 100.0)
            ESX.ShowNotification('Vehicle repaired.')
        else
            ESX.ShowNotification('No vehicle nearby.')
        end
    end
    
    -- Function to change license plate of vehicle
    function ChangeLicensePlate()
        local vehicle = ESX.Game.GetVehicleInDirection()
        if DoesEntityExist(vehicle) then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'change_license_plate_dialog', {
                title = 'Enter New License Plate'
            }, function(data, menu)
                local newPlate = tostring(data.value)
                if newPlate ~= nil and newPlate ~= '' then
                    SetVehicleNumberPlateText(vehicle, newPlate)
                    ESX.ShowNotification('License plate changed to: ' .. newPlate)
                else
                    ESX.ShowNotification('Invalid license plate.')
                end
                menu.close()
            end, function(data, menu)
                menu.close()
            end)
        else
            ESX.ShowNotification('No vehicle nearby.')
        end
    end
    
    -- Register command to open admin menu
    RegisterCommand('adminmenu', function()
        OpenAdminMenu()
    end)
    
    -- Display help text for the command
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if IsControlJustReleased(0, 344) then -- Key: F11
                OpenAdminMenu()
            end
        end
    end)

    -- Function to repair vehicle
function RepairVehicle()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if DoesEntityExist(vehicle) then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true)
        SetVehicleFuelLevel(vehicle, 100.0)
        ESX.ShowNotification('Vehicle repaired.')
    else
        ESX.ShowNotification('No vehicle nearby.')
    end
end

-- Function to change license plate of vehicle
function ChangeLicensePlate()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if DoesEntityExist(vehicle) then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'change_license_plate_dialog', {
            title = 'Enter New License Plate'
        }, function(data, menu)
            local newPlate = tostring(data.value)
            if newPlate ~= nil and newPlate ~= '' then
                SetVehicleNumberPlateText(vehicle, newPlate)
                ESX.ShowNotification('License plate changed to: ' .. newPlate)
            else
                ESX.ShowNotification('Invalid license plate.')
            end
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    else
        ESX.ShowNotification('No vehicle nearby.')
    end
end

-- Function to clean vehicle
function CleanVehicle()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if DoesEntityExist(vehicle) then
        SetVehicleDirtLevel(vehicle, 0.0)
        ESX.ShowNotification('Vehicle cleaned.')
    else
        ESX.ShowNotification('No vehicle nearby.')
    end
end

-- Function to refill vehicle's fuel
function RefillFuel()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if DoesEntityExist(vehicle) then
        SetVehicleFuelLevel(vehicle, 100.0)
        ESX.ShowNotification('Vehicle refueled.')
    else
        ESX.ShowNotification('No vehicle nearby.')
    end
end

-- Function to change vehicle color
function ChangeVehicleColor()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if DoesEntityExist(vehicle) then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'change_vehicle_color_dialog', {
            title = 'Enter New Vehicle Color (RGB)'
        }, function(data, menu)
            local color = tostring(data.value)
            local r, g, b = color:match("(%d+), (%d+), (%d+)")
            if r ~= nil and g ~= nil and b ~= nil then
                SetVehicleCustomPrimaryColour(vehicle, tonumber(r), tonumber(g), tonumber(b))
                SetVehicleCustomSecondaryColour(vehicle, tonumber(r), tonumber(g), tonumber(b))
                ESX.ShowNotification('Vehicle color changed to: RGB(' .. r .. ', ' .. g .. ', ' .. b .. ')')
            else
                ESX.ShowNotification('Invalid color format. Expected format: R, G, B')
            end
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    else
        ESX.ShowNotification('No vehicle nearby.')
    end
end

-- Open vehicle modifications submenu
function OpenVehicleModificationsMenu()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_modifications_menu', {
        title    = 'Vehicle Modifications',
        align    = 'top-right',
        elements = {
            {label = 'Repair Vehicle', value = 'repair_vehicle'},
            {label = 'Change License Plate', value = 'change_license_plate'},
            {label = 'Clean Vehicle', value = 'clean_vehicle'},
            {label = 'Refill Fuel', value = 'refill_fuel'},
            {label = 'Change Vehicle Color', value = 'change_vehicle_color'},
            {label = 'Upgrade Engine', value = 'upgrade_engine'},
            {label = 'Add Turbo', value = 'add_turbo'},
            {label = 'AutoMaxModifications', value = 'AutoMaxModifications'},
        }
    }, function(data, menu)
        if data.current.value == 'repair_vehicle' then
            RepairVehicle()
        elseif data.current.value == 'change_license_plate' then
            ChangeLicensePlate()
        elseif data.current.value == 'clean_vehicle' then
            CleanVehicle()
        elseif data.current.value == 'refill_fuel' then
            RefillFuel()
        elseif data.current.value == 'change_vehicle_color' then
            ChangeVehicleColor()
        elseif data.current.value == 'upgrade_engine' then
            UpgradeEngine()
        elseif data.current.value == 'add_turbo' then
            AddTurbo()
        elseif data.current.value == 'AutoMaxModifications' then
            AutoMaxModifications()

        end
    end, function(data, menu)
        menu.close()
        OpenAdminMenu() -- Reopen admin menu after closing submenu
    end)
end

-- Register command to open admin menu
RegisterCommand('adminmenu', function()
    OpenAdminMenu()
end)

-- Display help text for the command
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 344) then -- Key: F11
            OpenAdminMenu()
        end
    end
end)
function UpgradeEngine()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if DoesEntityExist(vehicle) then
        SetVehicleModKit(vehicle, 0)
        ToggleVehicleMod(vehicle, 11, true)
        SetVehicleEnginePowerMultiplier(vehicle, 25.0)
        ESX.ShowNotification('Vehicle engine upgraded.')
    else
        ESX.ShowNotification('No vehicle nearby.')
    end
end

-- Function to add turbo to vehicle
function AddTurbo()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if DoesEntityExist(vehicle) then
        SetVehicleModKit(vehicle, 0)
        ToggleVehicleMod(vehicle, 18, true)
        ESX.ShowNotification('Turbo added to vehicle.')
    else
        ESX.ShowNotification('No vehicle nearby.')
    end
end

-- Function to automatically maximize vehicle modifications
function AutoMaxModifications()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if DoesEntityExist(vehicle) then
        SetVehicleModKit(vehicle, 0)
        for i = 0, GetNumVehicleMods(vehicle, 0) - 1 do
            local modType = GetVehicleMod(vehicle, 0)
            if IsToggleMod(modType) then
                ToggleVehicleMod(vehicle, 0, true)
            else
                SetVehicleMod(vehicle, 0, GetNumVehicleMods(vehicle, 0) - 1)
            end
        end
        ESX.ShowNotification('All vehicle modifications maximized.')
    else
        ESX.ShowNotification('No vehicle nearby.')
    end
end
