function SvBlipFunc()
    -- populate blips with blips from config
    for _, zone in ipairs(Config.Zones) do
        local myBlip = {
            blipId = zone.Id,
            zone = zone,
            players = {},
            peds = {}
        }
        --print("isnerting in to blips")
        table.insert(blips, myBlip)
    end


end

function SvUpdatePed(action, data, src)
    -- if action is change status
    if action == "updatepedstatus" then
        --print("In UPdate PED STATUS")
        -- loop through blips
        for _, blipEntry in ipairs(blips) do
            -- check if peds table is empty
            local empty = true
            for next in pairs(blipEntry.peds) do
                empty = false
            end
            if empty == false then
                --print("EMPTY FALSE")
                -- if peds table is not empty
                -- loop through peds
                for _, ped in ipairs(blipEntry.peds) do
                    -- check if data.OldPedId == ped.Ped
                    --print(data.OldPedId, ped.Ped)
                    if data.OldPedId == ped.Ped then
                        -- Change ped.Ped to data.PedId and ped.Status to data.Status
                        --print(data.PedId, data.Status)
                        ped.Ped = data.PedId
                        ped.Status = data.Status
                    end
                end
            end
        end
    end




end
function SvCheckPedSync(src)
    --print("SvCheckPedSync")
    -- loop through blips
    local srcx = src
    for l, blipEntry in ipairs(blips) do
        if blipEntry.zone.Peds.Enabled == true then
            -- check if peds table is empty
            local empty = true
            for next in pairs(blipEntry.peds) do
                empty = false
            end
            if empty == false then
                --if ped table is not empty

                if #blipEntry.peds < blipEntry.zone.Peds.MaxPedAmount then
                    --- Try to Spawn Peds if they are less than Max
                    ---

                    -- Get rand int in lenght of peds table
                    local pedIndex = math.random(1, #blipEntry.zone.Peds.SpawnCoords)
                    -- spawncoords 1-3 check if one already has ped then skip if is dosent have then break and set as index otherwise set original index as index
                    local QPedExists = false
                    for i, querypeds in pairs(blipEntry.peds) do
                        print("querypeds.PedInfo", querypeds.PedInfo == blipEntry.zone.Peds.SpawnCoords[pedIndex])
                        if querypeds.PedInfo == blipEntry.zone.Peds.SpawnCoords[pedIndex] then
                            QPedExists = true
                        end


                    end
                    if #blipEntry.peds == #blipEntry.zone.Peds.SpawnCoords then
                        QPedExists = false
                    end
                    if QPedExists == false then


                        local pedCoords = blipEntry.zone.Peds.SpawnCoords[pedIndex].Pos
                        local pedModel = blipEntry.zone.Peds.SpawnCoords[pedIndex].Model
                        local lpPed = GenerateRandomString(32)
                        local myPed = {
                            Ped = lpPed,
                            Status = "spawning",
                            PedInfo = blipEntry.zone.Peds.SpawnCoords[pedIndex],
                            SpecificItem = blipEntry.zone.Peds.SpawnCoords[pedIndex].Actions.RequestSpecificItem,
                            ItemGroup = blipEntry.zone.Peds.SpawnCoords[pedIndex].Actions.ItemGroup,
                            Shop = false,
                            ShopItems = {},
                            TaskComplete = false,
                            ExpireTimer = GetGameTimer(),
                            Expired = false
                        }
                        table.insert(blipEntry.peds, myPed)
                        TriggerClientEvent("turrext_sellv2:syncPeds", src, blipEntry.peds)



                        AttemptSpawn1x1(blipEntry.peds, lpPed, src)




                    end

                else
                    --- Check Ped Status When Max are Already Spawned
                    ---
                    TriggerClientEvent("turrext_sellv2:syncPeds", src, blipEntry.peds)
                    -- If peds are at max; check status


                    PedSyncStatusAtMaxPeds(blipEntry, srcx)
                            
                end


            else
                local pedIndex = math.random(1, #blipEntry.zone.Peds.SpawnCoords)
                local pedCoords = blipEntry.zone.Peds.SpawnCoords[pedIndex].Pos
                local pedModel = blipEntry.zone.Peds.SpawnCoords[pedIndex].Model

                -- spawn ped
                --local ped = CreatePed(4, GetHashKey(pedModel), pedCoords.x, pedCoords.y, pedCoords.z, 0, true, true)
                local lpPed = GenerateRandomString(32)
                local myPed = {
                    Ped = lpPed,
                    Status = "spawning",
                    PedInfo = blipEntry.zone.Peds.SpawnCoords[pedIndex],
                    SpecificItem = blipEntry.zone.Peds.SpawnCoords[pedIndex].Actions.RequestSpecificItem,
                    ItemGroup = blipEntry.zone.Peds.SpawnCoords[pedIndex].Actions.ItemGroup,
                    Shop = false,
                    ShopItems = {},
                    TaskComplete = false,
                    ExpireTimer = GetGameTimer(),
                    Expired = false
                }
                table.insert(blipEntry.peds, myPed)
                
                TriggerClientEvent("turrext_sellv2:syncPeds", src, blipEntry.peds)
                AttemptSpawn1x1(blipEntry.peds, lpPed, srcx)
                -- spawn ped
            end
        end
        
    end

end
function GenerateRandomString(length)
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local randomString = ''
    local charsLength = string.len(chars)
    
    for i = 1, length do
        local randomIndex = math.random(1, charsLength)
        randomString = randomString .. string.sub(chars, randomIndex, randomIndex)
    end
    
    return randomString
end


function GetDistanceBetweenCoords1(coord1, coord2)
    local dx = coord2.x - coord1.x
    local dy = coord2.y - coord1.y
    local dz = coord2.z - coord1.z

    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

function SvUpdateZone(action, data, src) 
    if action == "enteredzone" then
        --print("enteredzone", data.blipId)
        for _, blipEntry in ipairs(blips) do
            --print("blipEntry", blipEntry.blipId, data.blipId)
            if blipEntry.blipId == data.blipId then
                --print("in zone =", blipEntry.blipId)
                local empty = true
                local empty1 = true
                for next in pairs(blipEntry.players) do
                    empty = false
                end
                if empty == false then
                    for _, player in ipairs(blipEntry.players) do
                        if player == src then
                            empty1 = false
                        end
                    end
                end
                if empty1 then
                    --print("inseritnhg to table")
                        table.insert(blipEntry.players, src)
                        TriggerClientEvent("turrext_sellv2:updateZone", src, action, data)
                end
            end
        end
    end
    if action == "exitedzone" then
        for _, blipEntry in ipairs(blips) do
            --print("exitedzone", data.blipId)
            if blipEntry.blipId == data.blipId then
                local empty = true
                for next in pairs(blipEntry.players) do
                    empty = false
                end
                if empty == false then
                    for i, player in ipairs(blipEntry.players) do
                        if player == src then
                            table.remove(blipEntry.players, i)
                            TriggerClientEvent("turrext_sellv2:updateZone", src, action, data)
                        end
                    end
                end
            end
        end
    end
end

function AttemptSpawn1x1(bpPeds, lPPeds, src)
    for i, ped21 in pairs(bpPeds) do
        if ped21.Status == "spawning" and ped21.Ped == lPPeds then
            --print("ped2.Status == 'spawning' and ped2.Ped == lpPed", ped2.Status == "spawning" and ped2.Ped == lpPed)
            ped21.Status = "spawning1"
        end
        if ped21.Status == "spawning1" then
            ped21.Status = "inspawning"
            --spawn ped
            --print("Creating Ped", l)
            local spPed 
            local spPed1
            local pla = GetPlayerPed(src)
            local plc = GetEntityCoords(pla)
            local disti = GetDistanceBetweenCoords1(plc, plc)
            if disti <= 400 then
                ESX.OneSync.SpawnPed(ped21.PedInfo.Model,ped21.PedInfo.Pos, 0, function(NetId)
                    Wait(250) -- While not needed, it is best to wait a few milliseconds to ensure the ped is available
                    local Ped = NetworkGetEntityFromNetworkId(NetId) -- Grab Entity Handle From Network Id
                    local Exists = DoesEntityExist(Ped) -- returns true/false depending on if the ped exists.
                    if Exists then
                        print("Ped",Ped,"NETID",NetId,"zone",l)
                    else
                        if Ped ~= nil or Ped ~= 0 then
                            DeleteEntity(Ped)
                            ped21.Status = "spawning1"
                        end
                    end
                    spPed = Ped
                    spPed1 = NetId
                    print(Exists and 'Successfully Spawned Ped!'..spPed or 'Failed to Spawn Ped!')
                    print("DoesEntityExist(spPed)",spPed,DoesEntityExist(spPed))
                    if DoesEntityExist(spPed) then
                        print("Entity ADded to ACtiove")
                        ped21.Status = "active"
                        ped21.Ped = spPed1
                        SetEntityHeading(spPed, ped21.PedInfo.Heading)
                    else
                        ped21.Status = "spawning1"
                    end
                  end)
                --local spPed = CreatePed(4, blipEntry.peds[i].PedInfo.Model, blipEntry.peds[i].PedInfo.Pos.x, blipEntry.peds[i].PedInfo.Pos.y, blipEntry.peds[i].PedInfo.Pos.z, 0, true, true)
                --local spPed1 = NetworkGetNetworkIdFromEntity(spPed)
              
                -- --print SPped and SPPed1 with labels in quotes
              
            else
                ped21.Status = "spawning1"
            end
        end
    end


end


function PedSyncStatusAtMaxPeds(blipEntry, srcx)

    local src = srcx

    for i, peds in ipairs(blipEntry.peds) do
        ----print i and blipenty.peds[i].Ped
        ----print(i)
        ----print(#blipEntry.peds)
        ----print("Status:".. blipEntry.peds[i].Status)
        local pedid = NetworkGetEntityFromNetworkId(peds.Ped)
        --print(peds.Status)
        --print(peds.Ped)
        if peds.Status == "spawning1" then
            peds.Status = "inspawning"
            --spawn ped
            --print("Creating Ped", l)
            local spPed 
            local spPed1
            local pla = GetPlayerPed(src)
            local plc =GetEntityCoords(pla)
            local disti =GetDistanceBetweenCoords1(plc, peds.PedInfo.Pos)
            if disti <= 400 then
                ESX.OneSync.SpawnPed(peds.PedInfo.Model,peds.PedInfo.Pos, 0, function(NetId)
                    Wait(250) -- While not needed, it is best to wait a few milliseconds to ensure the ped is available
                    local Ped = NetworkGetEntityFromNetworkId(NetId) -- Grab Entity Handle From Network Id
                    local Exists = DoesEntityExist(Ped) -- returns true/false depending on if the ped exists.
                    if Exists then
                        print("Ped",Ped,"NETID",NetId,"zone",l)
                    else
                        if Ped ~= nil or Ped ~= 0 then
                            DeleteEntity(Ped)
                            peds.Status = "spawning1"
                        end
                    end
                    spPed = Ped
                    spPed1 = NetId
                    print(Exists and 'Successfully Spawned Ped!'..spPed or 'Failed to Spawn Ped!')
                    print("DoesEntityExist(spPed)",spPed,DoesEntityExist(spPed))
                    if DoesEntityExist(spPed) then
                        print("Entity ADded to ACtiove")
                        peds.Status = "active"
                        peds.Ped = spPed1
                        SetEntityHeading(spPed, peds.PedInfo.Heading)
                    else
                        peds.Status = "spawning1"
                    end
                  end)
                  
                  
                --local spPed = CreatePed(4, peds.PedInfo.Model, peds.PedInfo.Pos.x, peds.PedInfo.Pos.y, peds.PedInfo.Pos.z, 0, true, true)
                --local spPed1 = NetworkGetNetworkIdFromEntity(spPed)
                
                -- --print SPped and SPPed1 with labels in quotes
                
            else
                peds.Status = "spawning1"
            end

        end
        if peds.Status == "active" then
            if not DoesEntityExist(pedid) then
                -- if ped is dead
                --print("REmoved 1")
                table.remove(blipEntry.peds, i)
                break
            else
                --print("GetEntityHealth(pedid)",GetEntityHealth(pedid))
                if Config.InstantRespawnAfterPedDeath then
                    if GetEntityHealth(pedid) <= 0 then
                        --print("REmoved 2")
                        -- if ped is dead
                        --DeleteEntity(pedid)
                        --table.remove(blipEntry.peds, i)
                        TriggerClientEvent("turrext_sellv2:confirmDeath", src, peds.Ped)
                        break
                    end
                end
                local pedcoords = GetEntityCoords(pedid)
                if GetDistanceBetweenCoords1(pedcoords, blipEntry.zone.Pos) > blipEntry.zone.Radius then
                    --print("REmoved 3")
                    DeleteEntity(pedid)
                    table.remove(blipEntry.peds, i)
                    break
                end
                if peds.Expired == true then

                            local empty = true
                            local empty1 = true
                            for next in pairs(blipEntry.players) do
                                empty = false
                            end
                            if empty == false then
                                -- Someone in zone but ped expired
                            else
                                print("Zone empty and ped expired")
                                DeleteEntity(pedid)
                                table.remove(blipEntry.peds, i)
                            end
                            if GetEntityHealth(pedid) <= 0 then
                                --print("REmoved 2")
                                -- if ped is dead
                                --DeleteEntity(pedid)
                                --table.remove(blipEntry.peds, i)
                                TriggerClientEvent("turrext_sellv2:confirmDeath", src, peds.Ped)
                                break
                            end

                end
            end
        end
        if peds.Expired == false then
            print("Ped not Expired")
            local current_time = GetGameTimer()
            local time_since = current_time - peds.ExpireTimer
            if time_since >= peds.PedInfo.Actions.ExpireTimer*1000 then
                print("Expired Ped")
                peds.Expired = true
            end
        end

        --print(#blipEntry.peds)
        ShopSync(peds, src)

    end

end
--[[
    local myPed = {
                           Ped = lpPed,
                            Status = "spawning",
                            PedInfo = blipEntry.zone.Peds.SpawnCoords[pedIndex],
                            SpecificItem = blipEntry.zone.Peds.SpawnCoords[pedIndex].Actions.RequestSpecificItem,
                            ItemGroup = blipEntry.zone.Peds.SpawnCoords[pedIndex].Actions.ItemGroup,
                            Shop = false,
                            ShopItems = {},
                            TaskComplete = false
                        }
]]
--[[
    NPCPermenentShop = false,
		Jobonly = false,
		Job = "none",
		Items = { -- Name, -- Label, -- Price, -- Account, -- Min Amount sold per Ped, -- Max Amount sold per Ped
			[1] = {
				Name = "water",
				Label = "Bottle of Water",
				Price = 10,
				Account = "money",
				MinItem = 1,
				MaxItem = 4,

			},
			[2] = {
				Name = "bread",
				Label = "Loaf of Bread",
				Price = 10,
				Account = "bank",
				MinItem = 1,
				MaxItem = 1,
			}
		}


        For ItemSpecific False
            - Max
            - Min
            If Any Sold upto max, Ped.TaskComplete = true,
            Schedule Delete
]]
function CreateSvShopPerm(ped, src,localped)
    --print("IN SV SHOP PERM")
    local plItems = {}
    local ittm
    for i, item in pairs(ped.ShopItems) do
        if Config.Inventory == "ESX" then
            local xPlayer = ESX.GetPlayerFromId(src)
            ittm = xPlayer.hasItem(item.Name)
        elseif Config.Inventory == "OX" then
            ittm = exports.ox_inventory:GetItem(src, item.Name, nil, false)
        end
        if ittm then
            local myIttm = {
                Name = item.Name,
                Label = item.Label,
                Price = item.Price,
                Account = item.Account,
                Count = ittm.count,
            }
            table.insert(plItems, myIttm)
        else
            local myIttm = {
                Name = item.Name,
                Label = item.Label,
                Count = 0,
            }
            table.insert(plItems, myIttm)
        end

    end
    --[[local Table = {
    }
    for i, items in pairs(ped.ShopItems) do
        local litem = xPlayer.hasItem(items.Name)
        if litem then
            local ltable = {
                title = items.Label,
                description = 'Sell '..litem.count..'x '..items.Name..' for $'..litem.count*items.Price,
                icon = 'circle',
                serverEvent = 'turrext_sellv2:serversell',
                args = {
                    items = items,
                    count = litem.count,
                    ped = ped,
                    localped = localped
                },
                onSelect = function()
                    --TriggerEvent("GiveAnims", localpedid)
                    --TriggerServerEvent("turrext_sellv2:serversell", items, litem.count, ped, localped)
                    print("Pressed the button!")
                end,
              }
        table.insert(Table, ltable)
            

        else
            print("Adedd ",items.Label)
            local ltable = {
                
                    
                        title = items.Label,
                        description = 'You dont have any '..items.Label,
                        icon = 'hand',
                        disabled = true
                    
            
                
            }
            table.insert(Table, ltable)

        end


    end]]--
    
    TriggerClientEvent("turrext_sellv2:showContext2", src, localped, plItems, ped)



end
function CreateSvShop(ped, src,localped)
    local xPlayer = ESX.GetPlayerFromId(src)
        if ped.SpecificItem == false then
            local itemtable = nil
            local founditem = false
            local amt = 0
            local item
            for i, items in pairs(ped.ShopItems) do
                print(items.Name)
                if Config.Inventory == "ESX" then
                    local xPlayer = ESX.GetPlayerFromId(src)
                    item = xPlayer.hasItem(item.Name)
                elseif Config.Inventory == "OX" then
                    item = exports.ox_inventory:GetItem(src, items.Name, nil, false)
                end
                if item then
                    print('you have '.. item.count .. ' ' .. item.label)
                    if item.count >= items.MinAmount then

                        founditem = true
                        itemtable = items
                        if item.count > items.MaxAmount then
                            print("amt set as items.MaxAmount")
                          amt = items.MaxAmount
                        else
                            print("amt set as itemcount")
                            amt = item.count
                        end
                        break
                    end
                else
                  print('you do not have any '..items.Name..'!')
                end
            end
            if founditem then
                TriggerClientEvent("turrext_sellv2:showContext", src, localped, itemtable, amt, ped)
            else
                lib.notify(src, {
                    title = 'Error',
                    description = 'You do not have any items I want!',
                    type = 'error'
                })
            end
        else

            local itemtable = nil
            local founditem = false
            local amt = 0
            local item
            for i, items in pairs(ped.ShopItems) do
                print(items.Name)
                if Config.Inventory == "ESX" then
                    local xPlayer = ESX.GetPlayerFromId(src)
                    item = xPlayer.hasItem(items.Name)
                elseif Config.Inventory == "OX" then
                    item = exports.ox_inventory:GetItem(src, items.Name, nil, false)
                end
                if item then
                    print('you have '.. item.count .. ' ' .. item.label)
                    if item.count >= items.MinAmount then

                        founditem = true
                        itemtable = items
                        if item.count > items.MaxAmount then
                            print("amt set as items.MaxAmount")
                          amt = items.MaxAmount
                        else
                            print("amt set as itemcount")
                            amt = item.count
                        end
                        break
                    else
                        lib.notify(src, {
                            title = 'Error',
                            description = 'You do not have enough '..item.label,
                            type = 'error'
                        })

                    end
                else
                  print('you do not have any '..items.Label..'!')
                end
            end
            if founditem then
                TriggerClientEvent("turrext_sellv2:showContext", src, localped, itemtable, amt, ped)
            else
                if #ped.ShopItems == 1 then
                    lib.notify(src, {
                        title = 'Error',
                        description = 'I want '.. ped.ShopItems[1].MinAmount..'x '.. ped.ShopItems[1].Label,
                        type = 'error'
                    })
                end
            end

        end


end
function ShopSync(ped, src) 

    if ped.Shop == false then
        --print("Empty Shop")
        print(ped.Ped, ped.SpecificItem)
        if ped.SpecificItem == true then
            local itemindex = math.random(1,#Config.Selling[ped.ItemGroup].Items)
            local items = Config.Selling[ped.ItemGroup].Items[itemindex]
            local maxItem = math.random(items.MinItem, items.MaxItem)
            local minItem = maxItem
            local name = items.Name
            local label = items.Label
            local price = items.Price
            local account = items.Account

            local item1 = {
                Name = name,
                Label = label,
                Price = price,
                Account = account,
                MinAmount = minItem,
                MaxAmount = maxItem,
                Sold = 0
            }
            table.insert(ped.ShopItems, item1)
            ped.Shop = true


        else
            print("Config.Selling[ped.ItemGroup].NPCPermenentShop", Config.Selling[ped.ItemGroup].NPCPermenentShop)

            if Config.Selling[ped.ItemGroup].NPCPermenentShop == false then

                  
                    for i, items in ipairs(Config.Selling[ped.ItemGroup].Items) do
                        local maxItem = math.random(items.MinItem, items.MaxItem)
                        local minItem = items.MinItem
                        local name = items.Name
                        local label = items.Label
                        local price = items.Price
                        local account = items.Account

                        local item1 = {
                            Name = name,
                            Label = label,
                            Price = price,
                            Account = account,
                            MinAmount = minItem,
                            MaxAmount = maxItem,
                            Sold = 0
                        }
                        table.insert(ped.ShopItems, item1)
                    end
                    ped.Shop = true







            else
                for i, items in ipairs(Config.Selling[ped.ItemGroup].Items) do
                    local name = items.Name
                    local label = items.Label
                    local price = items.Price
                    local account = items.Account

                    local item1 = {
                        Name = name,
                        Label = label,
                        Price = price,
                        Account = account,
                        Sold = 0
                    }
                    table.insert(ped.ShopItems, item1)
                end
                ped.Shop = true



            end
        end
    end



end

function ShopSellingFunc(ped, itemtable, amt, localped, src)
    local err = true
    local step = 0
    local xPlayer = ESX.GetPlayerFromId(src)
    if Config.Selling[ped.ItemGroup].NPCPermenentShop == true then
        for y, item in pairs(ped.ShopItems) do
            step = 7
            print("upto here 1")
            if item.Label == itemtable.Label then
                step = 8
                print("upto here 2")
                    print("up to here3")
                    step = 9
                    local item1
                    if Config.Inventory == "ESX" then
                        local xPlayer = ESX.GetPlayerFromId(src)
                        item1 = xPlayer.hasItem(item.Name)
                    elseif Config.Inventory == "OX" then
                        item1 = exports.ox_inventory:GetItem(src, item.Name, nil, false)
                    end
                    if item1 then
                        print("up to here4")
                        step = 10
                        if item1.count >= amt then

                            err = false
                            item.Sold = item.Sold + amt
                            xPlayer.removeInventoryItem(item.Name, amt)
                            xPlayer.addAccountMoney(item.Account, item.Price*amt)
                            TriggerClientEvent("turrext_sellv2:soldVerified", src, localped, amt, itemtable)
                            print(ped.PedInfo.Actions.PoliceNotifyChance)
                            if math.random(1,100) <= ped.PedInfo.Actions.PoliceNotifyChance then
                                --TriggerServerEvent('esx_policeshops:notify', GetEntityCoords(localped))
                                print("Police Notified")
                                local playercoords = GetEntityCoords(GetPlayerPed(src))
                                if Config.Dispatch == "integrated" then
                                    TriggerEvent("turrext_sellv2:dispatchPolBlip", playercoords.x,playercoords.y,playercoords.z,Config.DispatchBlipTimer)
                                end
                                if Config.Dispatch == "qs-dispatch" then
                                    TriggerEvent('qs-dispatch:server:CreateDispatchCall', {
                                        job = { 'police'},
                                        callLocation = vector3(playercoords.x,playercoords.y,playercoords.z),
                                        callCode = { code = '<CALL CODE>', snippet = '<CALL SNIPPED EX: 10-10>' },
                                        message = "Illegal Transaction",
                                        flashes = false, -- you can set to true if you need call flashing sirens...
                                        --image = "URL", -- Url for image to attach to the call 
                                        --you can use the getSSURL export to get this url
                                        image = nil,
                                        blip = {
                                            sprite = 514, --blip sprite
                                            scale = 1.5, -- blip scale
                                            colour = 1, -- blio colour
                                            flashes = true, -- blip flashes
                                            text = 'Illegal Goods Transaction', -- blip text
                                            time = Config.DispatchBlipTimer, --blip fadeout time (1 * 60000) = 1 minute
                                        }
                                    })
                                end
                                if Config.NotifyPlayerOnPoliceDispatch then
                                    print("Player Police Notified")
                                    --if Config.Dispatch == "integrated" then
                                        lib.notify(src, {
                                            title = 'Reported',
                                            description = 'You have been reported to the police!',
                                            type = 'info'
                                        })
                                    --end
                                    
                                end
                            end
                        end
                    else
                    
                    end

            end
        end


    else 


        for y, item in pairs(ped.ShopItems) do
            step = 7
            print("upto here 1")
            if item.Label == itemtable.Label then
                step = 8
                print("upto here 2")
                if amt <= item.MaxAmount then
                    print("up to here3")
                    step = 9
                    local item1
                    if Config.Inventory == "ESX" then
                        local xPlayer = ESX.GetPlayerFromId(src)
                        item1 = xPlayer.hasItem(item.Name)
                    elseif Config.Inventory == "OX" then
                        item1 = exports.ox_inventory:GetItem(src, item.Name, nil, false)
                    end
                    if item1 then
                        print("up to here4")
                        step = 10
                        if item1.count >= amt then

                            err = false
                            item.Sold = item.Sold + amt
                            ped.TaskComplete = true
                            xPlayer.removeInventoryItem(item.Name, amt)
                            xPlayer.addAccountMoney(item.Account, item.Price*amt)
                            TriggerClientEvent("turrext_sellv2:soldVerified", src, localped, amt, itemtable)
                            if math.random(1,100) <= ped.PedInfo.Actions.PoliceNotifyChance then
                                print("Police Notified")
                                local playercoords = GetEntityCoords(GetPlayerPed(src))
                                if Config.Dispatch == "integrated" then
                                    TriggerEvent("turrext_sellv2:dispatchPolBlip", playercoords.x,playercoords.y,playercoords.z,Config.DispatchBlipTimer)
                                end
                                if Config.Dispatch == "qs-dispatch" then

                                    TriggerEvent('qs-dispatch:server:CreateDispatchCall', {
                                        job = { 'police'},
                                        callLocation = vector3(playercoords.x,playercoords.y,playercoords.z),
                                        callCode = { code = '<CALL CODE>', snippet = '<CALL SNIPPED EX: 10-10>' },
                                        message = "Illegal Transaction",
                                        flashes = false, -- you can set to true if you need call flashing sirens...
                                        --image = "URL", -- Url for image to attach to the call 
                                        --you can use the getSSURL export to get this url
                                        image = nil,
                                        blip = {
                                            sprite = 514, --blip sprite
                                            scale = 1.5, -- blip scale
                                            colour = 1, -- blio colour
                                            flashes = true, -- blip flashes
                                            text = 'Illegal Goods Transaction', -- blip text
                                            time = Config.DispatchBlipTimer, --blip fadeout time (1 * 60000) = 1 minute
                                        }
                                    })

                                end
                                if Config.NotifyPlayerOnPoliceDispatch then
                                    print("Player Police Notified")
                                    --if Config.Dispatch == "integrated" then
                                        lib.notify(src, {
                                            title = 'Reported',
                                            description = 'You have been reported to the police!',
                                            type = 'info'
                                        })
                                    --end
                                end
                            end
                        end
                    else
                    
                    end

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

end