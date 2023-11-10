ESX = exports['es_extended']:getSharedObject()
xSound = exports.xsound



ESX.RegisterUsableItem('guitar', function(source)
    TriggerClientEvent('zozik_gitara:startPlay', source ,'prop_acc_guitar_01', 'MusicListAcoustic')
end)

ESX.RegisterUsableItem('electricguitar', function(source)
    TriggerClientEvent('zozik_gitara:startPlay', source ,"prop_el_guitar_02",'MusicListElectric')
end)


RegisterNetEvent("zozik_gitara:destroySound")
AddEventHandler("zozik_gitara:destroySound", function(source, musicId)
    xSound:Destroy(-1, musicId)
end)

RegisterNetEvent("zozik_gitara:setVolume")
AddEventHandler("zozik_gitara:setVolume", function(musicId, volume)
    xSound:setVolume(musicId, volume[1])
end)


RegisterNetEvent("zozik_gitara:soundsAll")
AddEventHandler("zozik_gitara:soundsAll", function(type, musicId, data)
    TriggerClientEvent("zozik_gitara:sounds", -1, type, musicId, data)
end)
