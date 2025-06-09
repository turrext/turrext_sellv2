AttempingDeleting = {}

RegisterServerEvent("turrext_depend:print", function (print1)
    print("------")
    print(print1)
    print("------")

end)
RegisterServerEvent("turrext_depend:sync", function(a,b)
    local src = source
    print("a",a)
    if a == "delete" then
            for i,ped in pairs(AttempingDeleting) do
                if ped.Ped == b then
                    print("removing from table",b)
                    table.remove(AttempingDeleting,i)
                end
            end
    else
        local empty = true
        -- loop attempingDeleting to check if its empty
        for next in pairs(AttempingDeleting) do
            empty = false
        end
        if empty == false then
            local pls =  GetPlayerPed(src)
            for _, ped in ipairs(AttempingDeleting) do
                local plc = GetEntityCoords(pls)
                local dist = GetDistanceBetweenCoords1(plc, ped.Pos)
                if dist < 400 then
                    print("Dist less 400")
                    TriggerClientEvent("ped:deletePed", -1, ped.Ped)
                end
            end
        end
    end


end)
function GetDistanceBetweenCoords1(coord1, coord2)
    local dx = coord2.x - coord1.x
    local dy = coord2.y - coord1.y
    local dz = coord2.z - coord1.z

    return math.sqrt(dx * dx + dy * dy + dz * dz)
end
RegisterServerEvent("turrext_depend:queuedel", function(endid, pos)
    print("turrext_depend:queuedel 243423")
    local exists = false
    local empty = true
        -- loop attempingDeleting to check if its empty
        for next in pairs(AttempingDeleting) do
            empty = false
        end
        if empty == false then
            -- loop attempingDeleting with i, ped
            for i, ped in ipairs(AttempingDeleting) do
                -- check if the ped already exists with endid
                if ped == endid then
                    exists = true
                end
            end
        end
        if exists == false then
            print("adding to table ",endid)
            local myPed = {
                Ped = endid,
                Pos = pos
            }
            table.insert(AttempingDeleting, myPed)
        end
        print("turrext_depend:queuedel 13422")


end)