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
    for i, ped in ipairs(pedtable) do
        -- If player's ped is not nil
        if ped.Status == "spawning" then
            print("Spawning", i, ped.Ped)
            local spawnedPed = CreatePed(4, ped.PedInfo.model, ped.PedInfo.Pos.x, ped.PedInfo.Pos.y, ped.PedInfo.Pos.z, 0, true, false)
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
                TriggerServerEvent("turrext_sellv2:sync", "updatepedstatus", myData)
            end
        end
        if ped.Status == "active" then
            table.insert(peds, NetToPed(ped.Ped))
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
        if blipEntry.inZone == false then
            local blip = blipEntry.zone

            -- Calculate the distance between the player and the blip
            local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, blip.Pos.x, blip.Pos.y, blip.Pos.z, true)

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
            local blip = blipEntry.zone

            -- Calculate the distance between the player and the blip
            local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, blip.Pos.x, blip.Pos.y, blip.Pos.z, true)

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
            if DoesEntityExist(ped) then
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped), true) < 10.0 then
                    if nearPed == false then
                        nearPed = true
                        PedThread(ped)
                    end

                end
        end
    end

end

function PedThread(pedid)
    while nearPed == true do
        Wait(1)
        if DoesEntityExist(pedid) then
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(pedid), true) < 10.0 then
                print("near ped")
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
RegisterCommand('deletepeds1', function(source, args, rawCommand)
    -- Get all the peds in the world
    local peds = GetGamePool('CPed')
    TriggerServerEvent("turrext_depend:print", "Dletepeeds")
    -- Loop through each ped and delete it
    for _, ped in ipairs(peds) do
        DeleteEntity(ped)
    end

    -- Output a message indicating that all peds have been deleted
end, false)