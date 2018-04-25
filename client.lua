--Based on Pringus Simple Race Script 
--todo: Fix the bug causing crashes after the race
--todo: Allow players to rev their engines during the countdown for a proper launch
--todo: Add the option for invisible checkpoints on tracks that don't need them

function LocalPed()
	return GetPlayerPed(-1)
end
 
local IsRacing = false 
local cP = 1
local cP2 = 2
local checkpoint
local blip
local startTime
local trackName
local track = {}

--[[

Add checkpoints using the formatting:
CheckPoints[1] =  	{ x = 0, y = 0, z = 0, type = 5}
Number in brackets is the number of the checkpoint (CheckPoints[1] would be the first 
checkpoint in the race)
Change the checkpoint type to determine whether or not it will be a checkpoint or
the finish line. type = 5 for regular checkpoints, type = 9 for the finish.


]]
local AkinaDownhill = {} -- Akina Downhill
AkinaDownhill[1] =  	{ x = -3276.6650390625, y = 5670.0283203125, z = 398.81118774414, type = 5}
AkinaDownhill[2] =  	{ x = -2999.8425292969, y = 5348.9995117188, z = 383.87026977539, type = 5}
AkinaDownhill[3] =  	{ x = -2113.9055175781, y = 6537.955078125, z = 231.12522888184, type = 5}
AkinaDownhill[4] =  	{ x = -1045.4481201172, y = 6898.9038085938, z = 34.961235046387, type = 9}
AkinaDownhill[5] =  	{ x = -1045.4481201172, y = 6898.9038085938, z = 34.961235046387, type = 9} -- an extra checkpoint here finishes the race without crashing, courtesy of DarkComicHero


local AkinaUphill = {} -- Akina Uphill
AkinaUphill[1] =  		{ x = -2113.9055175781, y = 6537.955078125, z = 231.12522888184, type = 5}
AkinaUphill[2] =	  	{ x = -2999.8425292969, y = 5348.9995117188, z = 383.87026977539, type = 5}
AkinaUphill[3] =  		{ x = -3276.6650390625, y = 5670.0283203125, z = 398.81118774414, type = 5}
AkinaUphill[4] =  		{ x = -3303.3737792969, y = 4840.3310546875, z = 414.9846496582, type = 9}
AkinaUphill[5] =  		{ x = -3303.3737792969, y = 4840.3310546875, z = 414.9846496582, type = 9}

local blips = {}
	blips[1] = 	{title="Akina Downhill", colour=5, id=315, x= -3303.3737792969, y= 4840.3310546875, z= 414.9846496582}
    blips[2] =		{title="Akina Uphill", colour=5, id=315, x= -1045.4481201172, y= 6898.9038085938, z= 34.961235046387}



Citizen.CreateThread(function()
    preRace()
end)

function preRace()
    while not IsRacing do
        Citizen.Wait(0)
			-- This should be blips[1] instead of hardcoded coordinates. This entire thing should loop through the blips array when completed
            DrawMarker(1, -3303.3737792969, 4840.3310546875, 414.9846496582 - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0) -- Akina Downhill
        if GetDistanceBetweenCoords( -3303.3737792969, 4840.3310546875, 414.9846496582, GetEntityCoords(LocalPed())) < 50.0 then
            	Draw3DText( -3303.3737792969, 4840.3310546875, 414.9846496582, "Akina",7,0.3,0.2)
            	Draw3DText( -3303.3737792969, 4840.3310546875, 414.9846496582 - .5, "Downhill",7,0.3,0.2)
        end
        if GetDistanceBetweenCoords( -3303.3737792969, 4840.3310546875, 414.9846496582, GetEntityCoords(LocalPed())) < 2.0 then
            if (IsControlJustReleased(1, 27)) then -- Press UP while inside the marker
                if IsRacing == false then
                    IsRacing = true

					for k in pairs(track) do
						track[k] = nil
					end
					
					for k,v in pairs(AkinaDownhill) do
						track[k] = v
					end
					 SetEntityHeading(PlayerPedId(), 345.0)
					trackName = "Akina Downhill"
                    TriggerEvent("cRace:TPAll")
                else
                    return
                end
            end
		end	
			-- This should be blips[2] instead of hardcoded coordinates
			DrawMarker(1,  -1045.4481201172, 6898.9038085938, 34.961235046387 - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0) -- Akina Downhill
        if GetDistanceBetweenCoords( -1045.4481201172, 6898.9038085938, 34.961235046387, GetEntityCoords(LocalPed())) < 50.0 then
            	Draw3DText( -1045.4481201172, 6898.9038085938, 34.961235046387, "Akina",7,0.3,0.2)
            	Draw3DText( -1045.4481201172, 6898.9038085938, 34.961235046387 - .5, "Uphill",7,0.3,0.2)
        end
        if GetDistanceBetweenCoords(-1045.4481201172, 6898.9038085938, 34.961235046387, GetEntityCoords(LocalPed())) < 2.0 then
            if (IsControlJustReleased(1, 27)) then
                if IsRacing == false then
                    IsRacing = true
					
					for k in pairs(track) do
						track[k] = nil
					end
					
					for k,v in pairs(AkinaUphill) do
						track[k] = v
					end
					 SetEntityHeading(PlayerPedId(), 110.0)
					trackName = "Akina Downhill"
                    TriggerEvent("cRace:TPAll")
                else
                    return
                end
            end
        
			
			
        end
    end
end

RegisterNetEvent("cRace:TPAll")
AddEventHandler("cRace:TPAll", function()
    -- SetPedCoordsKeepVehicle(PlayerPedId(), 3103.01, -4826.48, 111.81) -- Old Teleportation 
    -- SetEntityHeading(PlayerPedId(), 345.0)
    Citizen.CreateThread(function()
        local time = 0
        function setcountdown(x)
          time = GetGameTimer() + x*1000
        end
        function getcountdown()
          return math.floor((time-GetGameTimer())/1000)
        end
        setcountdown(4)
		PlaySoundFrontend(-1, "Goal", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
        while getcountdown() > 0 do
            Citizen.Wait(1)
            
            -- Controls are now disabled
			SetPlayerControl(PlayerId(),false,256)
            DrawHudText(getcountdown(), {255,191,0,255},0.5,0.4,4.0,4.0)
        end
			PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
			SetPlayerControl(PlayerId(),true)
            TriggerEvent("fs_race:BeginRace")
    end)
end)

RegisterNetEvent("fs_race:BeginRace") --main loop
AddEventHandler("fs_race:BeginRace", function()
    startTime = GetGameTimer()
    Citizen.CreateThread(function()
        checkpoint = CreateCheckpoint(track[cP].type, track[cP].x,  track[cP].y,  track[cP].z + 2, track[cP2].x, track[cP2].y, track[cP2].z, 8.0, 204, 204, 1, 100, 0)
        blip = AddBlipForCoord(track[cP].x, track[cP].y, track[cP].z)          
        while IsRacing do 
            Citizen.Wait(5)
            -- SetVehicleDensityMultiplierThisFrame(0.0) -- Disable ambient traffic temporarily
            -- SetPedDensityMultiplierThisFrame(0.0)
            -- SetRandomVehicleDensityMultiplierThisFrame(0.0)
            -- SetParkedVehicleDensityMultiplierThisFrame(0.0)
            -- SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)

			if (IsControlJustReleased(1, 27)) then -- Press UP again to cancel the race
			    PlaySoundFrontend(-1, "Crash", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
                DeleteCheckpoint(checkpoint)
                RemoveBlip(blip)
                IsRacing = false
                cP = 1
                cP2 = 2
                TriggerEvent("chatMessage", "Server", {0,0,0}, string.format("You abandoned the race... " ))
                preRace()
			end
			
			
            --Comment these out if you don't want HUD text
            -- DrawHudText(math.floor(GetDistanceBetweenCoords(track[cP].x,  track[cP].y,  track[cP].z, GetEntityCoords(GetPlayerPed(-1)))) .. " meters", {249, 249, 249,255},0.0,0.75,1.0,1.0)
            DrawHudText(string.format("%i / %i", cP, tablelength(track)), {249, 249, 249, 255},0.7,0.0,1.5,1.5)
            DrawHudText(formatTimer(startTime, GetGameTimer()), {249, 249, 249,255},0.0,0.0,1.5,1.5)
                if GetDistanceBetweenCoords(track[cP].x,  track[cP].y,  track[cP].z, GetEntityCoords(GetPlayerPed(-1))) < 10.0 then
                    if track[cP].type == 5 then
                        DeleteCheckpoint(checkpoint)
                        RemoveBlip(blip)
                        PlaySoundFrontend(-1, "Turn", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
                        cP = math.ceil(cP+1)
                        cP2 = math.ceil(cP2+1)
                        checkpoint = CreateCheckpoint(track[cP].type, track[cP].x,  track[cP].y,  track[cP].z + 2, track[cP2].x, track[cP2].y, track[cP2].z, 8.0, 204, 204, 1, 100, 0)
                        blip = AddBlipForCoord(track[cP].x, track[cP].y, track[cP].z)
                    else
                        PlaySoundFrontend(-1, "ScreenFlash", "WastedSounds")
                        DeleteCheckpoint(checkpoint)
                        RemoveBlip(blip)
                        IsRacing = false
                        cP = 1
                        cP2 = 2
                        TriggerEvent("chatMessage", "Server", {0,0,0}, string.format("Finished " .. trackName .. " with a time of " .. formatTimer(startTime, GetGameTimer())))
                        preRace()
                    end
                    else
                end
            end
        end)
end)


--utility funcs

function tablelength(T)
    local count = 0
    for _ in pairs(T) do 
    count = count + 1 end
    return count
end

function formatTimer(startTime, currTime)
    local newString = (currTime - startTime) % 60000
    local min = math.floor((currTime - startTime) / 60000) -- Count minutes instead of just seconds
        local ms = string.sub(newString, -3, -2)
        local sec = string.sub(newString, -5, -4)
        --local min = string.sub(newString, -7, -6)
        newString = string.format("%s:%02s.%s", minutes, sec, ms)
    return newString
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY) -- Race names appear above the blips
         local px,py,pz=table.unpack(GetGameplayCamCoords())
         local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    
         local scale = (1/dist)*20
         local fov = (1/GetGameplayCamFov())*100
         local scale = scale*fov    
         SetTextScale(scaleX*scale, scaleY*scale)
         SetTextFont(fontId)
         SetTextProportional(1)
         SetTextColour(255, 255, 255, 250)
         SetTextDropshadow(1, 1, 1, 1, 255)
         SetTextEdge(2, 0, 0, 0, 150)
         SetTextDropShadow()
         SetTextOutline()
         SetTextEntry("STRING")
         SetTextCentre(1)
         AddTextComponentString(textInput)
         SetDrawOrigin(x,y,z+2, 0)
         DrawText(0.0, 0.0)
         ClearDrawOrigin()
        end

function DrawHudText(text,colour,coordsx,coordsy,scalex,scaley) --courtesy of driftcounter
    SetTextFont(7)
    SetTextProportional(7)
    SetTextScale(scalex, scaley)
    local colourr,colourg,colourb,coloura = table.unpack(colour)
    SetTextColour(colourr,colourg,colourb, coloura)
    SetTextDropshadow(0, 0, 0, 0, coloura)
    SetTextEdge(1, 0, 0, 0, coloura)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(coordsx,coordsy)
end

--create blip
Citizen.CreateThread(function()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 1.0)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)

