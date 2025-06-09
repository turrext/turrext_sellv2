ESX = exports['es_extended']:getSharedObject()
local Citizen = Citizen
blips = {}
peds = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local empty = true
        for next in pairs(blips) do
            empty = false
        end
        if empty == true then
            print("Empty")
            ClBlipFunc()
        end

        ClCoordsFunc()
        
    end
end)
RegisterNetEvent("turrext_sellv2:updateZone", function(action, zone)

    ClUpdateZone(action, zone)

end)
RegisterNetEvent("turrext_sellv2:deletePedv2", function(pedid)

    --DeleteEntity(pedid)


end)
RegisterNetEvent("turrext_sellv2:confirmDeath", function(pedid)
    --local exists = false
    if NetworkDoesEntityExistWithNetworkId(pedid) == 1 then
        local localpedid = 0
        local x=0
        while x < 5 do
            print("Waiting for ped to spawn 3")
            localpedid = NetworkGetEntityFromNetworkId(pedid)
            if localpedid == 0 then
                Wait(100)
                x = x + 1
            else
                break
            end
         end
        if localpedid ~= 0 then
            print("Not Dead", pedid, GetEntityHealth(localpedid))
            if GetEntityHealth(localpedid) <= 0 then
                TriggerServerEvent("turrext_sellv2:confirmedDeath", pedid, localpedid)
            end
        else
            TriggerServerEvent("turrext_sellv2:confirmedDeath", pedid)
        end
    end
    

end)

RegisterNetEvent("turrext_sellv2:showContext2", function(localpedid, plitemstable, svped)
    local Table1 = {
    }
    for i, items in pairs(plitemstable) do
        if items.Count > 0 then
            local ltable = {
                title = items.Label,
                description = 'Sell '..items.Count..'x '..items.Name..' for $'..items.Count*items.Price,
                icon = 'circle',
                serverEvent = 'turrext_sellv2:serversell',
                --args = {
                --    items = items,
                --    count = litem.count,
                --    ped = ped,
                --    localped = localped
                --},
                onSelect = function()
                    --TriggerEvent("GiveAnims", localpedid)
                    TriggerServerEvent("turrext_sellv2:serversell", items, items.Count, svped, localpedid)
                    print("Pressed the button!")
                end,
              }
        table.insert(Table1, ltable)
            

        else
            print("Adedd ",items.Label)
            local ltable = {
                
                    
                        title = items.Label,
                        description = 'You dont have any '..items.Label,
                        icon = 'hand',
                        disabled = true
                    
            
                
            }
            table.insert(Table1, ltable)

        end


    end
    lib.registerContext({
        id = 'sell_ped2',
        title = 'Sell to Person',
        options = Table1
    })
    lib.showContext("sell_ped2")

end)
RegisterNetEvent("turrext_sellv2:showContext", function(localpedid, item,amt, svped)
    lib.registerContext({
        id = 'sell_ped',
        title = 'Talk to Person',
        options = {
          --[[{
            title = 'Disabled button',
            description = 'This button is disabled',
            icon = 'hand',
            disabled = true
          },]]--
          {
            title = 'Sell to Customer',
            description = 'Wants to buy '..amt..' '..item.Label,
            icon = 'circle',
            onSelect = function()
                --TriggerEvent("GiveAnims", localpedid)
                TriggerServerEvent("turrext_sellv2:serversell", item, amt, svped, localpedid)
                print("Pressed the button!")
            end,
            metadata = {
            },
          },
        }
      })
    lib.showContext("sell_ped")

end)
RegisterNetEvent("turrext_sellv2:syncPeds", function(pedtable)
    print("Syncing peds")
    ClSyncPeds(pedtable)

end)
-- Import ESX library
RegisterNetEvent('ped:spawnPed')
AddEventHandler('ped:spawnPed', function(ped, model, x, y, z, heading)
    -- Customize the ped properties if needed
end)

-- Create admin menu UI using ESX default menu

RegisterNetEvent("GiveAnims") --> this event is for play anim when the player accept.
AddEventHandler("GiveAnims", function(pedids1)
    local ped = PlayerPedId()
    local giveAnim = "mp_common" --> Here is your animLib that u want use.
    RequestAnimDict(giveAnim)
    while not HasAnimDictLoaded(giveAnim) do
        Citizen.Wait(100)
    end
    TaskPlayAnim(ped, giveAnim, "givetake1_a", 8.0, 8.0, -1, 50, 0, false, false, false)
    if pedids1 ~= nil then
        TaskPlayAnim(pedids1, giveAnim, "givetake1_a", 8.0, 8.0, -1, 50, 0, false, false, false)
    end
    Citizen.Wait(1200)
    ClearPedTasksImmediately(pedids1)
    ClearPedTasks(ped)
end)

RegisterNetEvent("turrext_sellv2:soldVerified", function(localped, amt, itemtable)

    lib.hideContext(false)
    TriggerEvent("GiveAnims", localped)
    lib.notify({
        title = 'Sold',
                    description = 'You have sold '..amt..'x '..itemtable.Name..' for $'..itemtable.Price*amt..' Method:'..itemtable.Account,
                    type = 'success'
    })
end)

RegisterNetEvent('turrext_sellv2:createDispatchBlip')
AddEventHandler('turrext_sellv2:createDispatchBlip', function(x, y, z, duration)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, 1) -- Blip sprite (1 is a standard blip, you can change it as needed)
    SetBlipColour(blip, 3) -- Blip color (3 is red, you can change it as needed)
    SetBlipScale(blip, 1.0) -- Blip scale
    SetBlipAsShortRange(blip, false) -- Show the blip on the minimap at all ranges
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Illegal Goods Report")
    EndTextCommandSetBlipName(blip)

    Citizen.Wait(duration) -- Convert seconds to milliseconds
    RemoveBlip(blip) -- Remove the blip after the specified duration
end)