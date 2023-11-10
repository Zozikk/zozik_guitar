ESX = exports['es_extended']:getSharedObject()

Citizen.CreateThread(function()
    tableOfMusicacoustic = {}
    tableOfMusicelectric = {}
    for i=1, #Config.MusicListAcoustic do
        table.insert(tableOfMusicacoustic, {label = Config.MusicListAcoustic[i][1], value = i})
    end
    for i=1, #Config.MusicListElectric do
        table.insert(tableOfMusicelectric, {label = Config.MusicListElectric[i][1], value = i})
    end

end)

tableOfMusicelectric = {}
tableOfMusicacoustic = {}
xSound = exports.xsound
local musicId
local playing = false

function loadAnimDict( dict )
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

local function newCaseProp(pos, model)
    local x,y,z = table.unpack(pos)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Citizen.Wait(100)
    end
    return CreateObject(GetHashKey(model), x, y, z, true, false, false)
end

function DeleteProp(prop)
    if prop == nil then
        if CaseProp ~= 0 then
            NetworkRequestControlOfEntity(CaseProp)
            while (NetworkGetEntityOwner(CaseProp) ~= PlayerId()) and (NetworkGetEntityOwner(CaseProp) ~= -1) do
                Citizen.Wait(0)
            end
            DetachEntity(CaseProp, true, true)
            SetEntityCollision(CaseProp, false, true)
            if IsEntityAnObject(CaseProp) then
                DeleteObject(CaseProp)
            else
                DeleteEntity(CaseProp)
            end
            toggle = false
        end
    else
        NetworkRequestControlOfEntity(prop)
        while (NetworkGetEntityOwner(prop) ~= PlayerId()) and (NetworkGetEntityOwner(prop) ~= -1) do
            Citizen.Wait(0)
        end
        DetachEntity(prop, true, true)
        SetEntityCollision(prop, false, true)
        if IsEntityAnObject(prop) then
            DeleteObject(prop)
        else
            DeleteEntity(prop)
        end
        toggle = false
    end
end

function stopPlaying(musicId, prop)
    Citizen.CreateThread(function() 
        while playing do
            Wait(0)
            if IsControlJustPressed(0, 73) then
                TriggerServerEvent("zozik_gitara:soundsAll", "destroy", musicId)
                TriggerServerEvent("zozik_gitara:destroySound", musicId)
                TriggerEvent("zozik_gitara:addProp", prop, {-0.14, -0.18, 0.045, 130.0, 260.0, 190.0})
                playing = false
            end

        end

    end)

end



function OpenSoundList(prop, type)
	local pos = GetEntityCoords(PlayerPedId())

    if type == "MusicListAcoustic" then
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'guitarMenu',
            {
    			align    = 'center',
                title    = 'Akopmaniament',
                elements = tableOfMusicacoustic
            },
            function(data, menu)
                for i=1, #Config.MusicListAcoustic do
                    if data.current.value == i then
                        playing = true
                        TriggerServerEvent("zozik_gitara:soundsAll", "play", musicId, { position = pos, link =  Config.MusicListAcoustic[i][2]})
                        TriggerEvent("zozik_gitara:addProp", prop, {-0.14, -0.18, 0.045, 130.0, 260.0, 190.0})
                        stopPlaying(musicId, prop)
                        ESX.UI.Menu.CloseAll()
                    end

                end
            end,
            function(data, menu)
                ESX.UI.Menu.CloseAll()
            end
    	)
    else
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'guitarMenu',
            {
                align    = 'center',
                title    = 'Akopmaniament',
                elements = tableOfMusicelectric
            },
            function(data, menu)
                for i=1, #Config.MusicListElectric do
                    if data.current.value == i then
                        playing = true
                        TriggerServerEvent("zozik_gitara:soundsAll", "play", musicId, { position = pos, link =  Config.MusicListElectric[i][2]})
                        TriggerEvent("zozik_gitara:addProp", prop, {-0.14, -0.18, 0.045, 130.0, 260.0, 190.0})
                        stopPlaying(musicId, prop)
                        ESX.UI.Menu.CloseAll()
                    end

                end
            end,
            function(data, menu)
                ESX.UI.Menu.CloseAll()
            end
        )
    end
end


Citizen.CreateThread(function()
    Citizen.Wait(1000)
    musicId = "id" .. PlayerPedId()
    local posistion
    while true do
        Citizen.Wait(100)
        if xSound:soundExists(musicId) and playing then
            if xSound:isPlaying(musicId) then
                posistion = GetEntityCoords(PlayerPedId())
                TriggerServerEvent("zozik_gitara:soundsAll", "position", musicId, { position = posistion })
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)


RegisterNetEvent("zozik_gitara:startPlay")
AddEventHandler("zozik_gitara:startPlay", function(prop,type)
	OpenSoundList(prop,type)
end)

RegisterCommand('volume', function(source, args)
    local id = "id" .. PlayerPedId()
    xSound:setVolume(id, args[1])
    TriggerServerEvent("zozik_gitara:setVolume", id, args)
end)




RegisterNetEvent("zozik_gitara:sounds")
AddEventHandler("zozik_gitara:sounds", function(type, musicId, data)
    if type == "position" then
        if xSound:soundExists(musicId) then
            xSound:Position(musicId, data.position)
        end
    end

    if type == "play" then
        xSound:PlayUrlPos(musicId, data.link, 1, data.position)
        xSound:Distance(musicId, 20)
    end

    if type == "destroy" then
        xSound:Destroy(musicId)
    end


end)


RegisterNetEvent("zozik_gitara:addProp")
AddEventHandler("zozik_gitara:addProp", function(model, coords)

        if Prop ~= nil and DoesEntityExist(Prop)  then
            DeleteProp(Prop)
            SetEntityAsNoLongerNeeded(Prop)
            ClearPedTasksImmediately(GetPlayerPed(-1))
        else
            loadAnimDict("amb@world_human_musician@guitar@male@idle_a")
            TaskPlayAnim(PlayerPedId(), "amb@world_human_musician@guitar@male@idle_a","idle_b", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
            Prop = newCaseProp(GetEntityCoords(GetPlayerPed(-1)), model)
            local bone = GetPedBoneIndex(GetPlayerPed(-1), 18905)
            SetEntityCollision(Prop, 0, 0)
            AttachEntityToEntity(Prop, GetPlayerPed(-1), bone, coords[1], coords[2], coords[3], coords[4], coords[5], coords[6], true, true, false, true, 1, true)
            SetEntityAsMissionEntity(Prop, 1, 1)
        end

end)
