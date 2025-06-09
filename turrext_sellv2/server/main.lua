local ESX = exports['es_extended']:getSharedObject()
blips = {}

RegisterServerEvent("turrext_sellv2:sync", function(action, data)
    local src = source
    --check if blips empty
    if next(blips) == nil then
        SvBlipFunc()
    end
    if action == "enteredzone" or "exitedzone" then

        SvUpdateZone(action, data, src)

    end
    if action == "updatepedstatus" then
        SvUpdatePed(action, data, src)
    end
    for _, blipEntry in ipairs(blips) do
        --print("blipEntry", blipEntry.blipId, data.blipId)
            --print("in zone =", blipEntry.blipId)
            local empty = true
            local empty1 = true
            for next in pairs(blipEntry.players) do
                empty = false
            end
            if empty == false then
                for _, player in ipairs(blipEntry.players) do
                end
            end
    end
    SvCheckPedSync(src)
end)
RegisterServerEvent("turrext_sellv2:confirmedDeath", function(pedsrvid, localid12)
    local src = source
    for i, zone in pairs(blips) do
        for e, ped in pairs(zone.peds) do
            if ped.Ped == pedsrvid then
                

                print(pedsrvid)
                local localid1 = NetworkGetEntityFromNetworkId(pedsrvid)
                if localid1 ~= 0 or localid1 ~= nil then
                    DeleteEntity(localid1)
                end
                if localid12 ~= 0 or localid12 ~= nil then
                    TriggerClientEvent("turrext_sellv2:deletePedv2", src, localid12)
                end
                table.remove(zone.peds, i)
            end

        end


    end


end)

RegisterServerEvent('turrext_sellv2:dispatchPolBlip')
AddEventHandler('turrext_sellv2:dispatchPolBlip', function(x, y, z, duration)
    local players = GetPlayers()
    
    for _, player in ipairs(players) do
        local xPlayer = ESX.GetPlayerFromId(player)
        local job = xPlayer.getJob().name
        if job == "police" then
            lib.notify(player, {
                title = 'Illegal Goods Report',
                description = 'Someone has reported illegal goods being sold!',
                type = 'info'
            })
            TriggerClientEvent('turrext_sellv2:createDispatchBlip', player, x, y, z, duration)
        end
    end
end)



local function deletePeds()
    for _, blip in pairs(blips) do
        -- check if blips.peds empty
        local empty = true
        for next in pairs(blip.peds) do
            empty = false
        end
        if not empty then
            print("Peds1")
            for _, ped in ipairs(blip.peds) do
                print("Peds", ped.Status,ped.Ped)
                if ped.Status == "active" then
                        print(DoesEntityExist(ped.Ped))
                        TriggerEvent("turrext_depend:queuedel", ped.Ped, ped.PedInfo.Pos)
                end
            end
        end
    end
end


AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        deletePeds()
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerEvent("turrext_depend:print", "----------o Resource Started: Turrext_sellv2 o----------")
    end
end)


RegisterCommand('checkEntity', function(source, args)
    local netid = tonumber(args[1])

    if netid then
        if NetworkGetEntityOwner(netid) then
            print('The entity with netid ' .. NetworkGetEntityOwner(netid) .. ' exists!')
        else
            print('The entity with netid ' .. netid .. ' does not exist!')
        end
    else
        print('Invalid netid!')
    end
end)

RegisterServerEvent("turrext_sellv2:InteractShop", function(netped,localped)
    local src = source
    local pedfound = false
    local pedtable = nil
    local pedbliptable = nil
    print(netped)
    for i, BlipEntries in ipairs(blips) do
        local empty = true
       
        for next in pairs(BlipEntries.peds) do
            empty = false
        end
        if empty == false then
            for x, ped in ipairs(BlipEntries.peds) do
                if ped.Ped == netped then
                    pedfound = true
                    pedtable = ped
                    pedbliptable = BlipEntries
                end
            end
        end
        
    end
    if pedfound == true then
        if pedtable.Shop == true then
            print("Theres a SHop!")
            if pedtable.TaskComplete == false then
                print("Config.Selling[pedtable.ItemGroup].NPCPermenentShop",Config.Selling[pedtable.ItemGroup].NPCPermenentShop)
                if Config.Selling[pedtable.ItemGroup].JobOnly == true then
                    local xPlayer = ESX.GetPlayerFromId(src)
                    local job = xPlayer.getJob()
                    if job.name == Config.Selling[pedtable.ItemGroup].Job then
                        if Config.Selling[pedtable.ItemGroup].NPCPermenentShop then
                            print()
                            CreateSvShopPerm(pedtable, src,localped)
                        else
                            CreateSvShop(pedtable, src,localped)
                        end
                    else
                        lib.notify(src, {
                            title = 'Error',
                            description = 'Will only talk to '..Config.Selling[pedtable.ItemGroup].JobLabel..'!',
                            type = 'error'
                        })
                    end
                else
                    if Config.Selling[pedtable.ItemGroup].NPCPermenentShop then
                        print()
                        CreateSvShopPerm(pedtable, src,localped)
                    else
                        CreateSvShop(pedtable, src,localped)
                    end
                end
            else
                lib.notify(src, {
                    title = 'Error',
                    description = 'Does not want to talk to you!',
                    type = 'error'
                })
            end
        end
    else
        print("Didnt Find ped")
    end

end)


RegisterServerEvent("turrext_sellv2:serversell", function(itemtable, amt, pedtable, localped)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local step = 0
    local err = true


    -- Add CHeck Job
    for i, BlipEntries in ipairs(blips) do
        step = 1
        local empty = true
       
        for next in pairs(BlipEntries.peds) do
            empty = false
        end
        if empty == false then
            step = 2
            for x, ped in ipairs(BlipEntries.peds) do
                step = 3
                local empty1 = true
                if pedtable ~= nil then

                    for next1 in pairs(pedtable) do
                        empty1 = false
                    end
                    if ped.Ped == pedtable.Ped and empty1 == false then
                        step = 4
                        if ped.Shop == true and ped.TaskComplete == false then
                            if Config.Selling[ped.ItemGroup].JobOnly == true then
                                local job = xPlayer.getJob()
                                local jobname = job.name
                                if jobname == Config.Selling[ped.ItemGroup].Job then
                                    
                                    step = 6
                                    ShopSellingFunc(ped, itemtable, amt, localped, src)
                                    err = false
                                else
    
                                    lib.notify(src, {
                                        title = 'Error',
                                        description = 'Only wants to talk to '..Config.Selling[pedtable.ItemGroup].JobLabel,
                                        type = 'error'
                                    })
    
                                end
                            else
                                ShopSellingFunc(ped, itemtable, amt, localped, src)
                                err = false
    
                            end
                        end
                    end
                else
                    print("Error: pedtable Empty")
                    err = false
                end
            end
        end
        
    end
    if err == true then
        lib.notify(src, {
            title = 'Error',
            description = 'Unkown Error. Please Contact Developer with Error Code:34892u; Step:'..step,
            type = 'error'
        })
    end

end)