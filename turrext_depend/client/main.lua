RegisterNetEvent('ped:deletePed', function(ped)
    print("ped:deletePed")
    local networkId = ped
    local entity = NetworkGetEntityFromNetworkId(networkId)
    
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
        print('Entity with network id ' .. networkId .. ' deleted.')
        TriggerServerEvent("turrext_depend:sync", "delete", ped)
    else
        print('Entity with network id ' .. networkId .. ' not found.')
    end



end)
RegisterNetEvent('ped:cdeletePedv2.1', function(ped)
    print("ped:cdeletePedv2.1")
    local networkId = ped
    local entity = DoesEntityExist(ped)
    if entity then
        DeleteEntity(ped)
        print('Entity with network id ' .. ped .. ' deleted.')
    else
        print('Entity with network id ' .. ped .. ' not found.')
    end



end)

CreateThread(function()
    while true do
        Wait(5000)
        print("Turrextdepend sync")
        TriggerServerEvent("turrext_depend:sync")
    end



end)