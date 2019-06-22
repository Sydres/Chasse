ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    Blips()
    NPCs()
end)

function Blips()
    local blip = AddBlipForCoord(Config.Boucherie.Pos.x, Config.Boucherie.Pos.y, Config.Boucherie.Pos.z)
    SetBlipSprite(blip, 141)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Boucherie.BlipName)
    EndTextCommandSetBlipName(blip)
    if Config.Chinois.Blip then
        local blip = AddBlipForCoord(Config.Chinois.Pos.x, Config.Chinois.Pos.y, Config.Chinois.Pos.z)
        SetBlipSprite(blip, 141)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Chinois.BlipName)
        EndTextCommandSetBlipName(blip)
    end
end

function NPCs()
    RequestModel(GetHashKey(Config.Boucherie.NPCmodel))
    while not HasModelLoaded(GetHashKey(Config.Boucherie.NPCmodel)) do
        Citizen.Wait(10)
    end
    npc = CreatePed(5, Config.Boucherie.NPCmodel, Config.Boucherie.Pos.x, Config.Boucherie.Pos.y, Config.Boucherie.Pos.z, Config.Boucherie.Pos.h, false, false)
    SetPedFleeAttributes(npc, 0, 0)
    SetPedComponentVariation(npc, 11, 1, 1, 2)
    SetPedDropsWeaponsWhenDead(npc, false)
    SetPedDiesWhenInjured(npc, false)
    SetEntityInvincible(npc , true)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    
    RequestModel(GetHashKey(Config.Chinois.NPCmodel))
    while not HasModelLoaded(GetHashKey(Config.Chinois.NPCmodel)) do
        Citizen.Wait(10)
    end
    npc = CreatePed(5, Config.Chinois.NPCmodel, Config.Chinois.Pos.x, Config.Chinois.Pos.y, Config.Chinois.Pos.z, Config.Chinois.Pos.h, false, false)
    SetPedFleeAttributes(npc, 0, 0)
    SetPedComponentVariation(npc, 11, 1, 1, 2)
    SetPedDropsWeaponsWhenDead(npc, false)
    SetPedDiesWhenInjured(npc, false)
    SetEntityInvincible(npc , true)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
end

Citizen.CreateThread(function()
    
    while true do
        Wait(1)
        local player = GetPlayerPed(-1)
        local pid = PlayerPedId()
        local playerloc = GetEntityCoords(player, 0)
        local handle, ped = FindFirstPed()
        local success
      
            local distance = GetDistanceBetweenCoords(Config.Boucherie.Pos.x, Config.Boucherie.Pos.y, Config.Boucherie.Pos.z , playerloc['x'], playerloc['y'], playerloc['z'], true)
                if distance <= 2.5 then
                    TriggerServerEvent('Chasse:revente', true)
                    Wait(2000)
                end
            local distance = GetDistanceBetweenCoords(Config.Chinois.Pos.x, Config.Chinois.Pos.y, Config.Chinois.Pos.z , playerloc['x'], playerloc['y'], playerloc['z'], true)
                if distance <= 2.5 then
                    TriggerServerEvent('Chasse:revente', false)
                    Wait(2000)
                end
                
------------------------------------------------------                
        repeat
            success, ped = FindNextPed(handle)
            local pos = GetEntityCoords(ped)
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
            if IsPedInAnyVehicle(GetPlayerPed(-1)) == false then
                if DoesEntityExist(ped) and GetEntityHealth(ped) < 1 and IsPedInAnyVehicle(ped) == false then
                    local pedType = GetPedType(ped)
                    if  pedType == 28 and IsPedAPlayer(ped) == false then
                        if distance <= 1.5 and ped  ~= GetPlayerPed(-1) and ped ~= oldped and ped ~= oldped2 then
                            local valid, legal = IsAnimalLegal(ped)
                            if valid and legal then
                                ESX.ShowHelpNotification("~INPUT_CONTEXT~ pour dépecer l'animal")
                                if IsControlJustPressed(1, 38) then --E
                                    if GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey("WEAPON_KNIFE") then
                                        oldped2 = oldped
                                        oldped = ped
                                        TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_MEDIC_KNEEL", 0, 1)
                                        Citizen.Wait(8000)
                                        ClearPedTasksImmediately(GetPlayerPed(-1))    
                                        TriggerServerEvent('Chasse:depece', legal)
                                    else
                                        ESX.ShowNotification("Il me faut un couteau pour récupérer la viande")
                                    end
                                end
                            end
                            if valid and not legal then
                                ESX.ShowHelpNotification("~INPUT_CONTEXT~ pour dépecer l'animal")
                                if IsControlJustPressed(1, 38) then --E
                                    if GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey("WEAPON_KNIFE") then
                                        oldped2 = oldped
                                        oldped = ped
                                        TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_MEDIC_KNEEL", 0, 1)
                                        Citizen.Wait(8000)
                                        ClearPedTasksImmediately(GetPlayerPed(-1))    
                                        TriggerServerEvent('Chasse:depece')
                                    else
                                        ESX.ShowNotification("Il me faut un couteau pour récupérer la viande")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        until not success
      

        EndFindPed(handle)
    end    
end)

function IsAnimalLegal(ped)
    if GetHashKey("a_c_cat_01") == GetEntityModel(ped) 
    or GetHashKey("a_c_chop") == GetEntityModel(ped) 
    or GetHashKey("a_c_westy") == GetEntityModel(ped) 
    or GetHashKey("a_c_poodle") == GetEntityModel(ped) 
    or GetHashKey("a_c_retriever") == GetEntityModel(ped) 
    or GetHashKey("a_c_rottweiler") == GetEntityModel(ped) 
    or GetHashKey("a_c_shepherd") == GetEntityModel(ped)
    or GetHashKey("a_c_husky") == GetEntityModel(ped) 
    or GetHashKey("a_c_pug") == GetEntityModel(ped) then
        return true, false
    elseif GetHashKey("a_c_boar") == GetEntityModel(ped)
    or GetHashKey("a_c_pig") == GetEntityModel(ped)
    or GetHashKey("a_c_cow") == GetEntityModel(ped)
    or GetHashKey("a_c_rabbit_01") == GetEntityModel(ped)
    or GetHashKey("a_c_mtlion") == GetEntityModel(ped) 
    or GetHashKey("a_c_hen") == GetEntityModel(ped) 
    or GetHashKey("a_c_deer") == GetEntityModel(ped) then
        return true, true
    else 
        return false
    end
end
