RegisterServerEvent('Traffic_Off')
AddEventHandler('Traffic_Off', function()
	ExecuteCommand("start traffic")
end)

RegisterServerEvent('Traffic_On')
AddEventHandler('Traffic_On', function()
	ExecuteCommand("stop traffic")
end)

RegisterServerEvent('Reset_Speedometer')
AddEventHandler('Reset_Speedometer', function()
	ExecuteCommand("restart SexySpeedometer-FiveM-master")
end)

RegisterServerEvent('Reset_NPCLife')
AddEventHandler('Reset_NPCLife', function()
	ExecuteCommand("restart NPCLife")
end)


--RegisterServerEvent('AkinaDownhillTrigger')
--AddEventHandler('AkinaDownhillTrigger', function()
--	print("Starting Server Race...")
--	TriggerClientEvent('AkinaDownhill', -1)
--end)
--
--RegisterServerEvent('AkinaUphillTrigger')
--AddEventHandler('AkinaUphillTrigger', function()
--	print("Starting Server Race...")
--	TriggerClientEvent('AkinaUphill', -1)
--end)
--
--RegisterServerEvent('NaboRevFullTrigger')
--AddEventHandler('NaboRevFullTrigger', function()
--	print("Starting Server Race...")
--	TriggerClientEvent('NaboRevFull', -1)
--end) -- these are obsolete

RegisterServerEvent('StartRaceTrigger')
AddEventHandler('StartRaceTrigger', function(trackid)
	print("Starting Server Race...")
	print(trackid)
	TriggerClientEvent('StartRaceClient', -1, trackid)
end)
