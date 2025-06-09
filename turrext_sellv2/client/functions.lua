
local nearPed = false
--[[
RegisterCommand("re", function()
    -- Loop through the blips table
    for i, blipEntry in ipairs(blips) do
        -- Check if blip1 is not nil
        if blipEntry.blip ~= nil then
            -- Remove blip1
            RemoveBlip(blipEntry.blip)
            -- Set blip1 to nil
            blipEntry.blip = nil
        end

        -- Check if blip2 is not nil
        if blipEntry.blip2 ~= nil then
            -- Remove blip2
            RemoveBlip(blipEntry.blip2)
            -- Set blip2 to nil
            blipEntry.blip2 = nil
        end
        table.remove(blips, i)
    end
end)]]
function ClSyncPeds(pedtable)
    -- Loop through pedtable
    --print("Syncing peds2")
    for i, ped in ipairs(pedtable) do
        -- If player's ped is not nil
        --[[if ped.Status == "spawning" then
            print("Spawning", i, ped.Ped)
            local spawnedPed = CreatePed(4, ped.PedInfo.model, ped.PedInfo.Pos.x, ped.PedInfo.Pos.y, ped.PedInfo.Pos.z, 0, true, true)
            if DoesEntityExist(spawnedPed) then
                -- Set ped as networked
                SetEntityAsMissionEntity(spawnedPed, true, true)
                -- Check if ped is networked
                if not NetworkGetEntityIsNetworked(spawnedPed) == 1 then
                    -- Set entity as networked
                    NetworkRegisterEntityAsNetworked(spawnedPed)
                end
                -- allow ped to wander and walk
                print(spawnedPed)
                SetEntityInvincible(spawnedPed, false)
                SetBlockingOfNonTemporaryEvents(spawnedPed, false)
                -- Get Ped Net ID
                local netid = PedToNet(spawnedPed)
                print(netid)
                print(NetworkDoesNetworkIdExist(netid))
                -- Add ped to table
                local myData = {
                    PedId = netid,
                    OldPedId = ped.Ped,
                    Status = "active"
                }
                SetEntityAsMissionEntity(spawnedPed, false, false)
                print("NetworkGetEntityOwner",NetworkGetEntityOwner(spawnedPed))
                TriggerServerEvent("turrext_sellv2:sync", "updatepedstatus", myData)
            end
        end]]--
        if ped.Status == "active" then
            --print(ped.Ped, ped.Status)
            -- check if peds is empty
            local empty = true
            for next in pairs(peds) do
                empty = false
            end
            if empty == false then
                local exists = false
                for i, lped in pairs(peds) do
                    if lped.NetPed == ped.Ped then
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        local dist = GetDistanceBetweenCoords(ped.PedInfo.Pos.x,ped.PedInfo.Pos.y,ped.PedInfo.Pos.z,playerCoords.x,playerCoords.y,playerCoords.z, true)
                        if dist <= Config.RenderDistance then
                            exists = true
                            --  Confirm PEDID CORRECT AFTER NEW PED IS SPAWNED
                            if DoesEntityExist(lped.Ped) == false then
                                local locID = NetworkGetEntityFromNetworkId(lped.NetPed)
                                print("locid", locID)
                                print(lped.NetPed)
                                if locID ~= nil or locID ~= 0 then
                                    if DoesEntityExist(locID) then
                                        lped.Ped = locID
                                        print("LOCID Updated x1")
                                    end
                                else
                                    if NetworkDoesEntityExistWithNetworkId(lped.NetPed) == 1 then
                                        local localpedid = 0
                                        local x=0
                                        while x < 5 do
                                            print("Waiting for ped to spawn 3")
                                            localpedid = NetworkGetEntityFromNetworkId(ped.Ped)
                                            if localpedid == 0 then
                                                Wait(100)
                                                x = x + 1
                                            else
                                                print("localpedid",localpedid)
                                                break
                                            end
                                         end
                                        if localpedid ~= 0 then
                                            lped.Ped = localpedid
                                            print("LOCID Updated x2")
                                        end
                                    end
                                    --print("DoesEntityExist", DoesEntityExist(NetworkGetEntityFromNetworkId(lped.NetPed)))
                                end
                            end
                            if ped.PedInfo.Actions.IgnoreEvents == true then
                                SetBlockingOfNonTemporaryEvents(lped.Ped, true)
                            end
                            if ped.PedInfo.Actions.FreezePed then
                                FreezeEntityPosition(lped.Ped,true)
                            end
                            if ped.PedInfo.Actions.Invincible == true then
                                SetEntityInvincible(lped.Ped, true)
                            end

                            if ped.PedInfo.Actions.Wandering == true then
                                local zonelm1 
                                for ee, zonecl1 in ipairs(Config.Zones) do
                                    for _, pedcl1 in ipairs(zonecl1.Peds.SpawnCoords) do
                                        if pedcl1.Pos.x == ped.PedInfo.Pos.x and pedcl1.Pos.y == ped.PedInfo.Pos.y and pedcl1.Pos.z == ped.PedInfo.Pos.z then
                                            --print("zonelm1 = i",i)
                                            zonelm1 = zonecl1
                                        end
                                    end

                                end
                                if zonelm1 ~= nil then
                                    --print(GetIsTaskActive(lped.Ped, 222))
                                    --print(lped.Ped, zonelm1.Pos.x,zonelm1.Pos.y,zonelm1.Pos.z, zonelm1.Radius)
                                    SetBlockingOfNonTemporaryEvents(lped.Ped, true)
                                    TaskWanderInArea(lped.Ped, zonelm1.Pos.x+0.0,zonelm1.Pos.y+0.0,zonelm1.Pos.z+0.0, zonelm1.Radius - 2.0, Config.GlobalWanderDist, 5000)
                                    --print(GetIsTaskActive(lped.Ped, 222))
                                end
                            end
                        end
                    end

                end
                if exists == false then
                    local localpedid = 0
                    local x=0
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local dist = GetDistanceBetweenCoords(ped.PedInfo.Pos.x,ped.PedInfo.Pos.y,ped.PedInfo.Pos.z,playerCoords.x,playerCoords.y,playerCoords.z, true)
                    if dist <= Config.RenderDistance then
                        while x < 5 do
                            print("Waiting for ped to spawn 1", ped.PedInfo.Pos.x,ped.PedInfo.Pos.y)
                            localpedid = NetworkGetEntityFromNetworkId(ped.Ped)
                            if localpedid == 0 then
                                Wait(100)
                                x = x + 1
                            else
                                print("localpedid",localpedid)
                                break
                            end
                         end
                        if localpedid ~= 0 then
                            local myPed = {
                                Ped = localpedid,
                                NetPed = ped.Ped,
                                Approach = ped.PedInfo.Actions.ApproachPlayer
                            }
                            table.insert(peds, myPed)
                            print("Inserting ",localpedid)
                        end
                    end
                end
            else
                print("Hr2")
                local localpedid = 0
                local x=0
                while x < 5 do
                    print("Waiting for ped to spawn 2")
                    localpedid = NetworkGetEntityFromNetworkId(ped.Ped)
                    if localpedid == 0 then
                        Wait(100)
                        x = x + 1
                    else
                        print("localpedid",localpedid)
                        break
                    end
                end
                if localpedid ~= 0 then
                    local myPed = {
                        Ped = localpedid,
                        NetPed = ped.Ped,
                        Approach = ped.PedInfo.Actions.ApproachPlayer
                    }
                    table.insert(peds, myPed)
                end
                print("Inserting ",localpedid)
            end

        end
    end
    --[[
    local myPeds = {}
    for _, ped in ipairs(pedtable) do
        table.insert(myPeds, NetToPed(ped))
    end
    peds = myPeds
    ]]--
end
function ClCoordsFunc()
    --#Get player coords then check if player distance from any values in blips table is less than radius
        local playerCoords = GetEntityCoords(PlayerPedId())

    -- Iterate through the blips table
    for _, blipEntry in ipairs(blips) do
        local blip = blipEntry.zone
        local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, blip.Pos.x, blip.Pos.y, blip.Pos.z, false)

        if distance < Config.RenderDistance then
            -- The player is within the radius of the blip turrext_sellv2:sync
            print("In RD")
            TriggerServerEvent("turrext_sellv2:sync")
        end
            
        if blipEntry.inZone == false then

            -- Calculate the distance between the player and the blip
  

            -- Check if the distance is less than the radius
            if distance < blip.Radius then
                print("in zone", blipEntry.blipId)
                local data = {
                    blipId = blipEntry.blipId
                }
                TriggerServerEvent("turrext_sellv2:sync", "enteredzone", data)
                -- The player is within the radius of the blip
                -- Do something here
            end
        else
            -- The player is not within the radius of the blip
            -- Do something else here
            -- Calculate the distance between the player and the blip
            

            -- Check if the distance is less than the radius
            if distance > blip.Radius then
                print("out zone", blipEntry.blipId)
                local data = {
                    blipId = blipEntry.blipId
                }
                TriggerServerEvent("turrext_sellv2:sync", "exitedzone", data)
                -- The player is within the radius of the blip
                -- Do something here
            end

        end
    end
    for _, ped in ipairs(peds) do
        --print(NetworkGetNetworkIdFromEntity(ped))
            if DoesEntityExist(ped.Ped) then
                local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped.Ped), true)
                --print(dist)
                if dist < 10.0 then
                    if nearPed == false then
                        nearPed = true
                        PedThread(ped, ped.Approach)
                    end

                end
        end
    end

end
function makeEntityFaceEntity( entity2, entity1 )
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading( entity1, heading )
end

function PedThread(ped, approach)
    local pedid = ped.Ped
    while nearPed == true do
        Wait(1)
        print("PEDID:",pedid)
        local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(pedid), true)
        if DoesEntityExist(pedid) then
            local expy = false
            if dist < 15.0 then
                --ClearPedTasksImmediately(pedid)
                --print("near ped")
                while dist < 10 do
                    local interface = false
                    local plcoords = GetEntityCoords(PlayerPedId())
                    dist = GetDistanceBetweenCoords(plcoords, GetEntityCoords(pedid), true)
                    if approach then
                        TaskTurnPedToFaceEntity(pedid, PlayerPedId(), 2000)
                    end
                    while dist < 7 and dist > 2 do
                        dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(pedid), true)

                        interface = true
                        if expy == false then
                            exports.ox_target:addLocalEntity(pedid, {
                                name = 'Talk',
                                icon = 'fas fa-handcuffs',
                                label = 'Talk to Person',
                                distance = 3,
                                canInteract = function(entity)
                                    return entity
                                end,
                                onSelect = function(data)
                                    lib.notify({
                                        title = 'Talking',
                                        description = 'Talking to Person',
                                        type = 'success'
                                    })
                                    
                                    --exports.ox_target:removeLocalEntity(pedid)
                                    exports.ox_target:disableTargeting(true)
                                    TaskTurnPedToFaceEntity(pedid, PlayerPedId(), 2000)
                                    TaskTurnPedToFaceEntity(PlayerPedId(), pedid, 2000)
                                    Wait(10)
                                    dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(pedid), true)
                                    local x = 1
                                    if dist <= 2 then
                                        x = 5
                                    end
                                    while x < 5 do
                                        x = x + 1
                                        if dist > 2.0 then
                                            print("In While")
                                            local plcoords1 = GetEntityCoords(PlayerPedId())
                                            local pedcoords1 = GetEntityCoords(pedid)
                                            dist = GetDistanceBetweenCoords(plcoords1, pedcoords1, true)
                                            if approach then
                                               TaskGoToCoordAnyMeans(pedid, plcoords1.x, plcoords1.y, plcoords1.z, 0.5, 0,false,786603,0xbf800000)
                                            else
                                                TaskGoToEntity(PlayerPedId(), pedid,1000, 1.8, 1.0,0,0)
                                                --TaskGoStraightToCoord(PlayerPedId(), pedcoords1.x, pedcoords1.y, pedcoords1.z, 0.7, 0,false,786603,0xbf800000)
                                            end
                                            dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(pedid), true)
                                        
                                        end
                                        Wait(10)
                                    end
                                    TriggerServerEvent("turrext_sellv2:InteractShop", ped.NetPed, ped.Ped)
                                    Wait(300)
                                    exports.ox_target:disableTargeting(false)
                                    --exports.ox_target:addLocalEntity(pedid)
                                    return
                                end
    
                            })
                            expy = true
                        end
                        if approach then
                            TaskGoToCoordAnyMeans(pedid, plcoords.x, plcoords.y, plcoords.z, 1.0, 0,false,786603,0xbf800000)
                        end
                        Wait(100)
                        ClearPedTasks(pedid)
                    end
                    while interface == true do
                        dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(pedid), true)
                        if dist > 3 then
                            exports.ox_target:removeLocalEntity(pedid)
                            interface = false
                            expy = false
                            Wait(2000)
                            break
                        end
                        if approach then
                            TaskTurnPedToFaceEntity(pedid, PlayerPedId(), 2000)
                        end
                        Wait(100)
                    end
                    Wait(1000)
                end


            else
                nearPed = false
                break
            end
        else
            nearPed = false
        end
        
    end


end

function ClUpdateZone(action, data)
    if action == "enteredzone" then
        for _, blipEntry in ipairs(blips) do
            if blipEntry.blipId == data.blipId then
                blipEntry.inZone = true
            end
        end
    end
    if action == "exitedzone" then
        for _, blipEntry in ipairs(blips) do
            if blipEntry.blipId == data.blipId then
                blipEntry.inZone = false
            end
        end
    end



end
function ClBlipFunc()
    print("The table is empty")
            
            for _, Zone in ipairs(Config.Zones) do
                local exists = false

                for _, blipEntry in ipairs(blips) do
                    if blipEntry.blipId == Zone.Id then
                        exists = true
                        break
                    end
                end

                if exists then
                    -- The blip with blipId matching Zone.Id exists
                    print("Blip with blipId " .. Zone.Id .. " exists")
                else
                    -- The blip with blipId matching Zone.Id does not exist
                    if Zone.Showblip then
                        AddBlipWithRadius(Zone)
                        print("Added blip with blipId " .. Zone.Id .. " and displayed radius")
                    else
                        local myBlip = {
                            blipId = Zone.Id,
                            zone = Zone,
                            blip = nil,
                            blip2 = nil,
                            inZone = false
                        }
                        table.insert(blips, myBlip)
                        print("Added blip with blipId " .. Zone.Id .. " without radius")
                    end
                end
            end




end
function AddBlipWithRadius(zone)
    Citizen.CreateThread(function()
        if zone.Drawradius then
            print("Drawing radius around blip with blipId " .. zone.Id,zone.Radius)
            local blip = AddBlipForRadius(zone.Pos.x, zone.Pos.y,zone.Pos.z,zone.Radius) 
            SetBlipColour(blip,zone.Color)
            SetBlipAlpha(blip,80)
           
            local blip2 = AddBlipForCoord(zone.Pos.x, zone.Pos.y, zone.Pos.z)
            SetBlipSprite(blip2, zone.Type)
            SetBlipDisplay(blip2, 4)
            SetBlipScale(blip2, 1.0)
            SetBlipColour(blip2, zone.Color)
            print("Setting blip color with RGB values:", zone.Color)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(zone.Blipname)
            EndTextCommandSetBlipName(blip2)
            -- Draw a radius around the blip if drawRadius is true
            
            -- Rotate the blip if Rotate is true

            

    
              local myBlip = {
                blipId = zone.Id,
                zone = zone,
                blip = blip2,
                blip2 = blip,
                inZone = false
            }
            table.insert(blips, myBlip)
        
        else
            local blip = AddBlipForCoord(zone.Pos.x, zone.Pos.y, zone.Pos.z)
            SetBlipSprite(blip, zone.Type)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 1.0)
            SetBlipColour(blip, zone.Color)
            print("Setting blip color with RGB values:", zone.Color)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(zone.Blipname)
            EndTextCommandSetBlipName(blip)
            
            -- Draw a radius around the blip if drawRadius is true
            
            -- Rotate the blip if Rotate is true
            if zone.Rotate then
                SetBlipRotation(blip, GetGameTimer() * 0.005)
            end
            local myBlip = {
                blipId = zone.Id,
                zone = zone,
                blip = blip,
                blip2 = nil,
                inZone = false
            }
            table.insert(blips, myBlip)
        end
    end)
end


-- Register the command
RegisterCommand('deletepeds', function(source, args, rawCommand)
    -- Get all the peds in the world
    local peds = GetGamePool('CPed')
    TriggerServerEvent("turrext_depend:print", "Dletepeeds")
    -- Loop through each ped and delete it
    for _, ped in ipairs(peds) do
        DeleteEntity(ped)
    end

    -- Output a message indicating that all peds have been deleted
end, false)