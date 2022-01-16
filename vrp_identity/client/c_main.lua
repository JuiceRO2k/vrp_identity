vRP = Proxy.getInterface('vRP')
vRPSIden = Tunnel.getInterface('vrp_identity', 'vrp_identity')

local vRPCIden = {}
Tunnel.bindInterface("vrp_identity", vRPCIden)
Proxy.addInterface("vrp_identity", vRPCIden)

local spawn, introcam, timeouts, camCoord, spawnCoord, skin = false, nil, {}, cfg.camCoord, cfg.spawnCoord, cfg.skin
local Notify = function(msg)   AddTextEntry("MESSAGE_VRP", msg); SetNotificationTextEntry("MESSAGE_VRP"); DrawNotification(true, false) end
vRPCIden.createIdentityUI = function() 
    FreezeEntityPosition(PlayerPedId(), true); spawn = true; 
    SetNuiFocus(true, true); SendNUIMessage({ action = "Open" }); 
    Citizen.Wait(100); spawnCam() 
end

RegisterNUICallback("receiveExt",function(data,cb)
    if data then
        if data.type == 2 then
            Notify("~r~Completeaza campurile")
        else
            local defaulModel = GetHashKey(skin[data.sexul])
            RequestModel(defaulModel)
            while not HasModelLoaded(defaulModel) do
                Citizen.Wait(1)
            end
            SetPlayerModel(PlayerId(), defaulModel)
            SetPedDefaultComponentVariation(PlayerPedId())
            
            SetModelAsNoLongerNeeded(defaulModel)
            SendNUIMessage({ action = "Close" })
            SetNuiFocus(false, false)        
            DestroyCam(introcam, 0)
            ClearTimecycleModifier("scanline_cam_cheap")
            FreezeEntityPosition(PlayerPedId(), false)
            RenderScriptCams(0, 0, 1, 1, 1)
            SetFocusEntity(PlayerPedId())
            DisplayRadar(true)
            TransitionFromBlurred(1000)
            spawn = false
            DoScreenFadeOut(150)
            TransitionToBlurred(500)
            Citizen.Wait(5000)
            SetEntityCoords(PlayerPedId(), spawnCoord.x, spawnCoord.y, spawnCoord.z, 1, 0, 0, 1)
            Citizen.Wait(2000)
            TransitionFromBlurred(10)
            DoScreenFadeIn(3000)
            Notify("~g~Ai creat cu succes buletinul")

            vRPSIden.updateUI({data.nume, data.prenume, data.varsta})
        end
    end
end)

-- Credits Andrew T.#6900
local setSmartTimeout = function(name,towait,func) if not timeouts[name] then timeouts[name] = true; SetTimeout(towait, function() func(); timeouts[name] = nil end) end end
-- Credits Andrew T.#6900

spawnCam = function()
    repeat 
        local digit = 0
        for k,v in pairs(camCoord) do
            if spawn then
                digit = digit + 1
                Citizen.Wait(100)
                setSmartTimeout("camIntro", 300, function()
                    introcam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
                    SetEntityVisible(playerPed, false, 0)
                    FreezeEntityPosition(playerPed, true) 
                    SetFocusEntity(playerPed)
                    FreezeEntityPosition(PlayerPedId(), true)
                    SetEntityVisible(PlayerPedId(), true, 0)
                    FreezeEntityPosition(PlayerPedId(), false)
                    SetCamActive(introcam, true)
                    SetFocusArea(v.from.x, v.from.y, v.from.z, 0.0, 0.0, 0.0)
                    SetCamParams(introcam, v.from.x, v.from.y, v.from.z, -9.6114, 0.0, v.heading, 44.8314, 7200, 0, 0, 2)
                    SetCamParams(introcam, v.to.x, v.to.y, v.to.z, -9.6114, 0.0, v.heading, 44.8314, 7200, 0, 0, 2)
                    SetCamParams(cam, posX, posY, posZ, rotX, rotY, rotZ, fieldOfView, p8, p9, p10, p11)
                    ShakeCam(introcam, "HAND_SHAKE", 0.15)
                    RenderScriptCams(true, false, 5000, 1, 1)
                    SetTimeout(5000, function()
                        DestroyCam(introcam, 0)
                        ClearTimecycleModifier("scanline_cam_cheap")
                        if digit == #camCoord + 1 and spawn then
                            FreezeEntityPosition(PlayerPedId(), false)
                            RenderScriptCams(0, 0, 1, 1, 1)
                            SetFocusEntity(PlayerPedId())
                            DisplayRadar(true)

                            
                        end
                    end)
                end)
                Citizen.Wait(10000)
            else
                FreezeEntityPosition(PlayerPedId(), false)
                RenderScriptCams(0, 0, 1, 1, 1)
                SetFocusEntity(PlayerPedId())
                DisplayRadar(true)
            end
        end
    until (not spawn) 
end