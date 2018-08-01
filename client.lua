--Based on Pringus Simple Race Script 
--todo: Add the option for invisible checkpoints on tracks that don't need them
--TODO: Make an array of all the tracks

function LocalPed()
	return GetPlayerPed(-1)
end
 
local IsRacing = false 
local section = 0
local lap = 0
local cP = 1
local cP2 = 2
local checkpoint
local blip
local startTime
local sectionTime
local sectionTimeDummy
local veh
local trackName
local track = {}
local notification
local heading = 0

--[[

Add checkpoints using the formatting:
CheckPoints[1] =  	{ x = 0, y = 0, z = 0, type = 5}
Number in brackets is the number of the checkpoint (CheckPoints[1] would be the first 
checkpoint in the race)
Change the checkpoint type to determine whether or not it will be a checkpoint or
the finish line. type = 5 for regular checkpoints, type = 9 for the finish, type = 7 for new section, type = 8 for new lap, type = 40 for warp to next checkpoint
Note: Warp checkpoints need a heading or the resource will crash

]]


local AkinaDownhill = {} -- Akina Downhill
AkinaDownhill[1]= {x = -3144.58203125,			y = 5249.0029296875,	z = 411.16192626953,	type = 5}		 
AkinaDownhill[2]= {x = -3339.3596191406,		y = 5563.865234375,		z = 402.67791748047,	type = 5}		 
AkinaDownhill[3]= {x = -3258.1530761719,		y = 5669.6474609375,	z = 397.74169921875,	type = 5}		 
AkinaDownhill[4]= {x = -3222.1489257813,		y = 5431.287109375,		z = 394.41241455078,	type = 5}		 
AkinaDownhill[5]= {x = -3061.1193847656,		y = 5318.3588867188,	z = 390.41302490234,	type = 5}		 
AkinaDownhill[6]= {x = -3003.9370117188,		y = 5215.6909179688,	z = 389.00631713867,	type = 5}		 
AkinaDownhill[7]= {x = -3019.1823730469,		y = 5371.97265625,		z = 383.16265869141,	type = 5}		 
AkinaDownhill[8]= {x = -3051.484375,			y = 5511.0678710938,	z = 380.72857666016,	type = 7}		 
AkinaDownhill[9]= {x = -3045.7102050781,		y = 5657.0190429688,	z = 378.57800292969,	type = 5}		 
AkinaDownhill[10]= {x = -2852.3920898438,		y = 5872.3442382813,	z = 369.65914916992,	type = 5}		 
AkinaDownhill[11]= {x = -2892.0480957031,		y = 5696.4848632813,	z = 362.10498046875,	type = 5}		 
AkinaDownhill[12]= {x = -2590.1159667969,		y = 5918.7197265625,	z = 354.61041259766,	type = 5}		 
AkinaDownhill[13]= {x = -2220.666015625,		y = 6171.0971679688,	z = 345.07922363281,	type = 7}		 
AkinaDownhill[14]= {x = -2407.3139648438,		y = 6216.3803710938,	z = 339.00271606445,	type = 5}		 
AkinaDownhill[15]= {x = -2669.8703613281,		y = 6246.6088867188,	z = 333.13592529297,	type = 5}		 
AkinaDownhill[16]= {x = -2870.1770019531,		y = 6157.6372070313,	z = 327.8701171875,		type = 5}		 
AkinaDownhill[17]= {x = -2492.6696777344,		y = 6398.5419921875,	z = 312.94439697266,	type = 5}		 
AkinaDownhill[18]= {x = -1902.5889892578,		y = 6267.171875,		z = 274.00280761719,	type = 5}		 
AkinaDownhill[19]= {x = -2115.3884277344,		y = 6524.0659179688,	z = 232.92875671387,	type = 5}		 
AkinaDownhill[20]= {x = -2304.2109375,			y = 6760.8994140625,	z = 202.1353302002,		type = 7}		 
AkinaDownhill[21]= {x = -2288.310546875,		y = 6937.6850585938,	z = 186.95501708984,	type = 5}		 
AkinaDownhill[22]= {x = -2251.6623535156,		y = 6846.181640625,		z = 178.65161132813,	type = 5}		 
AkinaDownhill[23]= {x = -2239.9091796875,		y = 6970.1918945313,	z = 172.12568664551,	type = 5}		 
AkinaDownhill[24]= {x = -2191.6030273438,		y = 6885.9028320313,	z = 165.365234375,		type = 5}		 
AkinaDownhill[25]= {x = -2162.6247558594,		y = 7145.765625,		z = 150.9623260498,		type = 5}		 
AkinaDownhill[26]= {x = -2113.1364746094,		y = 7074.041015625,		z = 146.29879760742,	type = 5}		 
AkinaDownhill[27]= {x = -1922.7360839844,		y = 7298.6401367188,	z = 125.88941192627,	type = 5}		 
AkinaDownhill[28]= {x = -2165.8425292969,		y = 7383.3833007813,	z = 109.118019104,		type = 7}		 
AkinaDownhill[29]= {x = -1841.5793457031,		y = 7360.9829101563,	z = 99.856491088867,	type = 5}		 
AkinaDownhill[30]= {x = -1613.6248779297,		y = 7277.861328125,		z = 93.335914611816,	type = 5}		 
AkinaDownhill[31]= {x = -1536.8161621094,		y = 7018.78515625,		z = 74.29727935791,		type = 5}		 
AkinaDownhill[32]= {x = -1222.5400390625,		y = 7040.8041992188,	z = 50.544811248779,	type = 5}		 
AkinaDownhill[33]= {x = -1118.6409912109,		y = 6999.59375,			z = 40.618057250977,	type = 5}		 
AkinaDownhill[34]= {x = -1018.5989990234,		y = 6923.474609375,		z = 35.077766418457,	type = 9}		 
AkinaDownhill[35]= {x = -1018.5989990234,		y = 6923.474609375,		z = 35.077766418457,	type = 9}		 



local AkinaUphill = {} -- Akina Uphill
AkinaUphill[1] =  		{ x = -2113.9055175781, y = 6537.955078125, z = 231.12522888184, type = 5}
AkinaUphill[2] =	  	{ x = -2999.8425292969, y = 5348.9995117188, z = 383.87026977539, type = 5}
AkinaUphill[3] =  		{ x = -3276.6650390625, y = 5670.0283203125, z = 398.81118774414, type = 5}
AkinaUphill[4] =  		{ x = -3303.3737792969, y = 4840.3310546875, z = 414.9846496582, type = 9}
AkinaUphill[5] =  		{ x = -3303.3737792969, y = 4840.3310546875, z = 414.9846496582, type = 9}

local NaboRevFull = {} -- Nabo
NaboRevFull[1] = 		{ x = 234.30584716797,	y = 1362.2397460938,	z = 238.67668151855,	type = 7}
NaboRevFull[2] = 		{ x = -402.07513427734,	y = 1904.7188720703,	z = 206.61959838867,	type = 5}
NaboRevFull[3] = 		{ x = -799.19537353516,	y = 1665.6009521484,	z = 198.29002380371,	type = 7}
NaboRevFull[4] = 		{ x = -473.75964355469,	y = 2813.3510742188,	z = 37.270782470703,	type = 7}
NaboRevFull[5] = 		{ x = -2081.3818359375,	y = 2283.5346679688,	z = 38.943672180176,	type = 7}
NaboRevFull[6] = 		{ x = -1808.1064453125,	y = 1900.4084472656,	z = 147.13417053223,	type = 5}
NaboRevFull[7] = 		{ x = -2628.5380859375,	y = 1406.24609375,		z = 134.25791931152,	type = 7}
NaboRevFull[8] = 		{ x = -1631.8984375,	y = 989.05895996094,	z = 152.51168823242,	type = 7}
NaboRevFull[9] = 		{ x = -724.00225830078,	y = 1013.047668457,		z = 238.73815917969,	type = 7}
NaboRevFull[10] = 		{ x = -718.95043945313,	y = 1169.8741455078,	z = 263.39270019531,	type = 5}
NaboRevFull[11] = 		{ x = -460.93792724609,	y = 1343.0961914063,	z = 304.44055175781,	type = 5}
NaboRevFull[12] = 		{ x = -386.99127197266,	y = 1177.7064208984,	z = 325.11627197266,	type = 9}
NaboRevFull[13] = 		{ x = -386.99127197266,	y = 1177.7064208984,	z = 325.11627197266,	type = 9}

local UltimateRace = {} -- Race covering Akina, Akagi, Myogi and Usui in one go (REQUIRES myogi2 and initiald resources)
UltimateRace[1] =  	{ x = -3276.6650390625, y = 5670.0283203125, z = 398.81118774414, type = 5}
UltimateRace[2] =  	{ x = -2999.8425292969, y = 5348.9995117188, z = 383.87026977539, type = 5}
UltimateRace[3] =  	{ x = -2113.9055175781, y = 6537.955078125, z = 231.12522888184, type = 5}
UltimateRace[4] =  	{ x = -1045.4481201172, y = 6898.9038085938, z = 34.961235046387, type = 5}
UltimateRace[5] =  	{ x = -318.04, y = 6364.71, z = 30.06, type = 40}

UltimateRace[6] =  	{ x = 6484.88, y = -184.04, z = 1267.23, type = 7, heading = 358.4} -- Myogi
UltimateRace[7] =  	{ x = 5335.12, y = -925.18, z = 1065.6, type = 40} -- Myogi

UltimateRace[8] =  	{ x = 2047.62, y = -1475.8, z = 655.85, type = 7, heading = 44.7} -- Usui
UltimateRace[9] =  	{ x = -2076.06, y = -1604.54, z = 20.8, type = 40} -- Usui

UltimateRace[10] = 	{ x = 1586.88, y = 1513.3, z = 233.92, type = 7, heading = 262.0} -- Akagi
UltimateRace[11] = 	{ x = 2861.73, y = 530.62, z = 4.12, type = 40} -- Akagi
UltimateRace[12] =	{ x = -3317.82, y = 4792.49, z = 414.36, type = 9, heading = 344.1}
UltimateRace[13] =	{ x = -3317.82, y = 4792.49, z = 414.36, type = 9,}

local Oroboros = {} -- X's track (loops)
Oroboros[1] = {x= -449.40936279297,	y=1385.5004882813,	z=297.24264526367,	type = 5} 
Oroboros[2] = {x= -136.83100891113,	y=1509.4833984375,	z=287.8606262207,	type = 5} 
Oroboros[3] = {x= 244.91180419922,	y=1308.6920166016,	z=236.2068939209,	type = 5} 
Oroboros[4] = {x= 304.31677246094,	y=1096.1336669922,	z=215.74168395996,	type = 5} 
Oroboros[5] = {x= 343.55282592773,	y=1001.4596557617,	z=210.24478149414,	type = 5} 
Oroboros[6] = {x= 487.74475097656,	y=867.34790039063,	z=197.78234863281,	type = 5} 
Oroboros[7] = {x= 914.49322509766,	y=986.09600830078,	z=233.69618225098,	type = 5} 
Oroboros[8] = {x= 1097.3973388672,	y=806.74145507813,	z=152.71017456055,	type = 5} 
Oroboros[9] = {x= 1149.0274658203,	y=1124.5834960938,	z=172.1139831543,	type = 5} 
Oroboros[10]= {x= 903.07415771484,	y=1719.23046875,	z=167.1983795166,	type = 5} 
Oroboros[11]= {x= 129.63325500488,	y=1666.8414306641,	z=228.36701965332,	type = 5} 
Oroboros[12]= {x= -194.23374938965,	y=1869.1695556641,	z=197.63871765137,	type = 5} 
Oroboros[13]= {x= -770.16729736328,	y=1643.908203125,	z=204.2751159668,	type = 5} 
Oroboros[14]= {x= -720.67895507813,	y=1136.1209716797,	z=261.84091186523,	type = 5} 
Oroboros[15]= {x= -696.70928955078,	y=992.80413818359,	z=237.8897857666,	type = 5} 
Oroboros[16]= {x= -278.18249511719,	y=1053.4552001953,	z=235.05192565918,	type = 5} 
Oroboros[17]= {x= 249.42546081543,	y=963.03009033203,	z=210.37020874023,	type = 5} 
Oroboros[18]= {x= 308.19451904297,	y=1050.9538574219,	z=211.71644592285,	type = 5} 
Oroboros[19]= {x= 203.0118560791,	y=1351.1102294922,	z=241.20336914063,	type = 5} 
Oroboros[20]= {x= -186.97485351563,	y=1480.7705078125,	z=288.62490844727,	type = 5} 
Oroboros[21]= {x= -427.58810424805,	y=1188.5217285156,	z=325.365234375,	type = 8}	
Oroboros[22]= {x= -427.58810424805,	y=1188.5217285156,	z=325.365234375,	type = 8}	

local AmbushCanyon = {}
AmbushCanyon[1]= { x = 5783.8291015625,		y = 4584.4599609375,	z = 5.1488037109375,	 	type = 5 }
AmbushCanyon[2]= { x = 5556.4194335938,		y = 4769.3256835938,	z = 11.266326904297,	 	type = 5 }
AmbushCanyon[3]= { x = 5388.8896484375,		y = 4875.0751953125,	z = 10.35995388031,	 		type = 5 }
AmbushCanyon[4]= { x = 5343.966796875,		y = 5241.4853515625,	z = 16.943252563477,		type = 5 } 
AmbushCanyon[5]= { x = 5282.7919921875,		y = 5370.6416015625,	z = 27.513643264771,	 	type = 5 }
AmbushCanyon[6]= { x = 5126.8764648438,		y = 5097.0341796875,	z = 26.144775390625,	 	type = 5 }
AmbushCanyon[7]= { x = 4918.4423828125,		y = 4865.4448242188,	z = 18.779026031494,	 	type = 5 }
AmbushCanyon[8]= { x = 4815.9838867188,		y = 4604.7954101563,	z = 24.268575668335,	 	type = 5 }
AmbushCanyon[9]= { x = 4849.2036132813,		y = 4344.1791992188,	z = 26.210180282593,	 	type = 5 }
AmbushCanyon[10]= { x = 5039.041015625,		y = 4370.53125,			z = 25.756135940552,		type = 5 }	 
AmbushCanyon[11]= { x = 5121.2431640625,	y = 4426.5107421875,	z = 20.176284790039,	 	type = 5 }
AmbushCanyon[12]= { x = 5366.6108398438,	y = 4409.1049804688,	z = 11.179671287537,		type = 8 } 
AmbushCanyon[13]= { x = 5366.6108398438,	y = 4409.1049804688,	z = 11.179671287537,		type = 8 } 

local AutumnRingFull = {}	 
AutumnRingFull[1]= {x = -3163.8017578125,	y = -6398.625,			z = 281.09106445313,	type = 5}	 
AutumnRingFull[2]= {x = -3154.4252929688,	y = -6261.9365234375,	z = 278.75296020508,	type = 5}	 
AutumnRingFull[3]= {x = -3284.1057128906,	y = -6081.134765625,	z = 276.99279785156,	type = 5}	 
AutumnRingFull[4]= {x = -3401.9948730469,	y = -5894.4892578125,	z = 287.4775390625,		type = 5}	 
AutumnRingFull[5]= {x = -3299.7431640625,	y = -5757.1796875,		z = 281.30484008789,	type = 5}	 
AutumnRingFull[6]= {x = -3248.0537109375,	y = -5961.0659179688,	z = 269.90948486328,	type = 5}	 
AutumnRingFull[7]= {x = -3109.8447265625,	y = -5842.7783203125,	z = 273.00268554688,	type = 5}	 
AutumnRingFull[8]= {x = -3251.6159667969,	y = -5618.2954101563,	z = 266.40676879883,	type = 5}	 
AutumnRingFull[9]= {x = -3119.1672363281,	y = -5665.568359375,	z = 283.62622070313,	type = 5}	 
AutumnRingFull[10]= {x = -2886.7351074219,	y = -5595.7060546875,	z = 289.83340454102,	type = 5}	 
AutumnRingFull[11]= {x = -2768.892578125,	y = -5731.2514648438,	z = 284.99032592773,	type = 5}	 
AutumnRingFull[12]= {x = -2975.2358398438,	y = -6109.0180664063,	z = 281.11199951172,	type = 8}
AutumnRingFull[13]= {x = -2975.2358398438,	y = -6109.0180664063,	z = 281.11199951172,	type = 8}

local ChicagoTrack = {} 
ChicagoTrack[1]= {x = -219.79403686523,		y = -4471.5864257813,	z = 24.343915939331, type = 5}	 
ChicagoTrack[2]= {x = 148.84771728516,		y = -4589.2084960938,	z = 17.6734790802,	 type = 5}	 
ChicagoTrack[3]= {x = 219.21827697754,		y = -4596.8256835938,	z = 17.648366928101, type = 5}	 
ChicagoTrack[4]= {x = 168.59872436523,		y = -4659.8383789063,	z = 17.603881835938, type = 5}	 
ChicagoTrack[5]= {x = 4.7123394012451,		y = -4728.17578125,		z = 17.370634078979, type = 5}	 
ChicagoTrack[6]= {x = -10.443976402283,		y = -4884.3413085938,	z = 17.043804168701, type = 5}	 
ChicagoTrack[7]= {x = -378.9635925293,		y = -5037.556640625,	z = 14.639210700989, type = 5}	 
ChicagoTrack[8]= {x = -420.09661865234,		y = -4938.5942382813,	z = 17.439548492432, type = 5}	 
ChicagoTrack[9]= {x = -220.15434265137,		y = -4869.916015625,	z = 17.583766937256, type = 5}	 
ChicagoTrack[10]= {x = -223.50985717773,	y = -4552.0654296875,	z = 17.758068084717, type = 5}	 
ChicagoTrack[11]= {x = -387.32376098633,	y = -4379.7470703125,	z = 13.620394706726, type = 5}	 
ChicagoTrack[12]= {x = -782.00555419922,	y = -4507.3452148438,	z = 5.7928051948547, type = 5}	 
ChicagoTrack[13]= {x = -787.544921875,		y = -4740.1181640625,	z = 4.9740419387817, type = 5}	 
ChicagoTrack[14]= {x = -383.71276855469,	y = -4721.546875,		z = 17.754043579102, type = 5}	 
ChicagoTrack[15]= {x = -383.9674987793,		y = -4564.3579101563,	z = 21.544826507568, type = 5}	 
ChicagoTrack[16]= {x = -489.20745849609,	y = -4141.2563476563,	z = 19.722555160522, type = 5}
ChicagoTrack[17]= {x = -400.61346435547,	y = -4388.080078125,	z = 20.732973098755, type = 8}		 
ChicagoTrack[18]= {x = -400.61346435547,	y = -4388.080078125,	z = 20.732973098755, type = 8}		 

local MonumentUphill = {}
MonumentUphill[1]= {x = -3058.2729492188,	y = 2318.3454589844,	z = 5.4706597328186,	type = 5}	 
MonumentUphill[2]= {x = -3097.6372070313,	y = 2417.0043945313,	z = 10.264200210571,	type = 5}	 
MonumentUphill[3]= {x = -2852.3974609375,	y = 2403.1420898438,	z = 22.222873687744,	type = 5}	 
MonumentUphill[4]= {x = -2886.9108886719,	y = 2480.6059570313,	z = 25.996515274048,	type = 5}	 
MonumentUphill[5]= {x = -2964.1164550781,	y = 2364.7270507813,	z = 35.253353118896,	type = 5}	 
MonumentUphill[6]= {x = -2942.3239746094,	y = 2539.9157714844,	z = 49.16926574707,		type = 5}	 
MonumentUphill[7]= {x = -3026.0278320313,	y = 2399.6430664063,	z = 41.891204833984,	type = 5}	 
MonumentUphill[8]= {x = -3169.1364746094,	y = 2627.7255859375,	z = 39.651344299316,	type = 5}	 
MonumentUphill[9]= {x = -3453.7878417969,	y = 2710.1057128906,	z = 28.825651168823,	type = 5}	 
MonumentUphill[10]= {x = -3716.8471679688,	y = 2766.7189941406,	z = 21.743909835815,	type = 5}	 
MonumentUphill[11]= {x = -3674.1271972656,	y = 2517.3200683594,	z = 31.773136138916,	type = 5}	 
MonumentUphill[12]= {x = -3563.9143066406,	y = 2574.4741210938,	z = 26.731048583984,	type = 5}	 
MonumentUphill[13]= {x = -3703.6870117188,	y = 2689.86328125,		z = 11.109732627869,	type = 5}	 
MonumentUphill[14]= {x = -3461.4768066406,	y = 2649.6613769531,	z = 33.097900390625,	type = 5}	 
MonumentUphill[15]= {x = -3186.9794921875,	y = 2456.3239746094,	z = 61.126644134521,	type = 5}	 
MonumentUphill[16]= {x = -3451.1015625,		y = 2479.0805664063,	z = 55.784591674805,	type = 5}	 
MonumentUphill[17]= {x = -3247.2775878906,	y = 2448.6740722656,	z = 69.363128662109,	type = 5}	 
MonumentUphill[18]= {x = -3685.1235351563,	y = 2679.9135742188,	z = 60.87162399292,		type = 5}	 
MonumentUphill[19]= {x = -3975.5380859375,	y = 2882.1713867188,	z = 33.249912261963,	type = 5}	 
MonumentUphill[20]= {x = -4061.7199707031,	y = 2666.5844726563,	z = 34.197128295898,	type = 5}	 
MonumentUphill[21]= {x = -3941.2873535156,	y = 2811.7856445313,	z = 48.79487991333,		type = 5}	 
MonumentUphill[22]= {x = -3894.3049316406,	y = 2582.1186523438,	z = 65.148475646973,	type = 5}	 
MonumentUphill[23]= {x = -3973.3586425781,	y = 2769.8771972656,	z = 64.300415039063,	type = 5}	 
MonumentUphill[24]= {x = -3891.7744140625,	y = 2718.6887207031,	z = 70.441223144531,	type = 9}	 
MonumentUphill[25]= {x = -3891.7744140625,	y = 2718.6887207031,	z = 70.441223144531,	type = 9}	 

local Okutama = {}
Okutama[1]= {x = -2724.2709960938,	y = 4020.3322753906,	z = 5.4736623764038,	type = 5}	 
Okutama[2]= {x = -2739.4055175781,	y = 4074.9162597656,	z = 9.0566930770874,	type = 5}	 
Okutama[3]= {x = -2756.3742675781,	y = 3962.439453125,		z = 16.540628433228,	type = 5}	 
Okutama[4]= {x = -2919.3498535156,	y = 3945.3493652344,	z = 25.65930557251,		type = 5}	 
Okutama[5]= {x = -2834.4128417969,	y = 4036.3256835938,	z = 29.301443099976,	type = 5}	 
Okutama[6]= {x = -2957.3471679688,	y = 3919.4714355469,	z = 39.191478729248,	type = 5}	 
Okutama[7]= {x = -2824.6381835938,	y = 4105.3779296875,	z = 53.902530670166,	type = 5}	 
Okutama[8]= {x = -2852.1281738281,	y = 4241.8671875,		z = 62.294868469238,	type = 5}	 
Okutama[9]= {x = -2757.88671875,	y = 4228.8598632813,	z = 78.950134277344,	type = 5}	 
Okutama[10]= {x = -2698.3227539063,	y = 4285.2587890625,	z = 89.456665039063,	type = 5}	 
Okutama[11]= {x = -2642.8666992188,	y = 4383.7270507813,	z = 101.31971740723,	type = 5}	 
Okutama[12]= {x = -2534.64453125,	y = 4231.3969726563,	z = 97.878982543945,	type = 5}	 
Okutama[13]= {x = -2712.0627441406,	y = 4424.8720703125,	z = 82.715438842773,	type = 5}	 
Okutama[14]= {x = -2475.5493164063,	y = 4391.1762695313,	z = 66.483688354492,	type = 5}	 
Okutama[15]= {x = -2496.3078613281,	y = 4500.0307617188,	z = 60.543270111084,	type = 5}	 
Okutama[16]= {x = -2415.0556640625,	y = 4447.59375,			z = 50.77311706543,		type = 5}	 
Okutama[17]= {x = -2446.8500976563,	y = 4531.9819335938,	z = 41.5657081604,		type = 5}
Okutama[18]= {x = -2416.7312011719,	y = 4259.87109375,		z = 16.913724899292,	type = 8}	 
Okutama[19]= {x = -2416.7312011719,	y = 4259.87109375,		z = 16.913724899292,	type = 8}	 

local Tokyoway = {}
Tokyoway[1]= {x = 1146.6525878906,	y = -4570.99609375,		z = 26.232723236084, type = 5}	 
Tokyoway[2]= {x = 975.8544921875,	y = -4171.2768554688,	z = 42.896499633789, type = 5}	 
Tokyoway[3]= {x = 944.27233886719,	y = -3921.7365722656,	z = 33.510837554932, type = 5}	 
Tokyoway[4]= {x = 722.06182861328,	y = -3929.9208984375,	z = 26.366979598999, type = 5}	 
Tokyoway[5]= {x = 824.99114990234,	y = -4326.4770507813,	z = 25.313310623169, type = 5}	 
Tokyoway[6]= {x = 670.80401611328,	y = -4596.345703125,	z = 17.935117721558, type = 5}	 
Tokyoway[7]= {x = 521.09094238281,	y = -4433.8745117188,	z = 17.806030273438, type = 5}	 
Tokyoway[8]= {x = 640.54858398438,	y = -4408.8715820313,	z = 20.728603363037, type = 5}	 
Tokyoway[9]= {x = 1051.6193847656,	y = -4358.9086914063,	z = 33.825855255127, type = 5}	  
Tokyoway[10]= {x = 1213.2807617188,	y = -4536.6762695313,	z = 26.770175933838, type = 8}	 
Tokyoway[11]= {x = 1213.2807617188,	y = -4536.6762695313,	z = 26.770175933838, type = 8}	 

local Nurburgring = {}
Nurburgring[1]= {x = 3416.8198242188,	y = -2735.5183105469,	z = 51.352848052979,	type = 5} 
Nurburgring[2]= {x = 3413.6157226563,	y = -2620.8181152344,	z = 54.486354827881,	type = 5} 
Nurburgring[3]= {x = 3263.1103515625,	y = -2597.6975097656,	z = 51.458053588867,	type = 5} 
Nurburgring[4]= {x = 3219.0966796875,	y = -2693.5473632813,	z = 48.304180145264,	type = 5} 
Nurburgring[5]= {x = 3312.4111328125,	y = -2685.13671875,		z = 49.810169219971,	type = 5} 
Nurburgring[6]= {x = 3386.40234375,		y = -2972.6481933594,	z = 49.099277496338,	type = 5} 
Nurburgring[7]= {x = 3436.3054199219,	y = -3167.7922363281,	z = 43.837387084961,	type = 5} 
Nurburgring[8]= {x = 3575.4685058594,	y = -3211.7236328125,	z = 36.160961151123,	type = 5} 
Nurburgring[9]= {x = 3367.5227050781,	y = -3672.65234375,		z = 10.129432678223,	type = 5} 
Nurburgring[10]= {x = 3303.2856445313,	y = -3713.1535644531,	z = 9.2182302474976,	type = 5} 
Nurburgring[11]= {x = 3308.8154296875,	y = -3616.3518066406,	z = 11.068603515625,	type = 5} 
Nurburgring[12]= {x = 3396.2175292969,	y = -3395.8044433594,	z = 24.599529266357,	type = 5} 
Nurburgring[13]= {x = 3337.6530761719,	y = -3267.5268554688,	z = 35.91707611084,		type = 5}	 
Nurburgring[14]= {x = 3289.4162597656,	y = -2839.8513183594,	z = 50.844856262207,	type = 5} 
Nurburgring[15]= {x = 3118.0554199219,	y = -2817.1311035156,	z = 49.171154022217,	type = 5} 
Nurburgring[16]= {x = 3078.0205078125,	y = -2726.2624511719,	z = 43.987613677979,	type = 5} 
Nurburgring[17]= {x = 3181.8684082031,	y = -2389.1767578125,	z = 32.576404571533,	type = 5} 
Nurburgring[18]= {x = 3538.9084472656,	y = -2098.61328125,		z = 51.91385269165,		type = 5}	 
Nurburgring[19]= {x = 3605.751953125,	y = -1976.8581542969,	z = 59.796203613281,	type = 5} 
Nurburgring[20]= {x = 3693.40234375,	y = -1912.6604003906,	z = 63.447845458984,	type = 5} 
Nurburgring[21]= {x = 3776.3671875,		y = -1968.4753417969,	z = 65.17064666748,		type = 5}	 
Nurburgring[22]= {x = 3675.4191894531,	y = -2220.1950683594,	z = 63.73853302002, 	type = 8} 
Nurburgring[23]= {x = 3675.4191894531,	y = -2220.1950683594,	z = 63.73853302002, 	type = 8} 

local StabCircuit = {}
StabCircuit[1]= {x = -269.96591186523,	y = 3943.2082519531,	z = 42.229663848877,	type = 5}	 
StabCircuit[2]= {x = -1446.4571533203,	y = 4221.55859375,		z = 50.167953491211,	type = 5}	 
StabCircuit[3]= {x = -1920.9973144531,	y = 4474.3647460938,	z = 30.415536880493,	type = 5}	 
StabCircuit[4]= {x = -869.74530029297,	y = 4398.3071289063,	z = 20.417324066162,	type = 5}	 
StabCircuit[5]= {x = -893.91058349609,	y = 4425.984375,		z = 20.540777206421,	type = 5}	 
StabCircuit[6]= {x = -1519.5125732422,	y = 4683.7954101563,	z = 38.348438262939,	type = 5}	 
StabCircuit[7]= {x = -1421.3352050781,	y = 4723.3740234375,	z = 42.511215209961,	type = 5}	 
StabCircuit[8]= {x = -709.7080078125,	y = 4557.9165039063,	z = 83.68335723877,		type = 5}	 
StabCircuit[9]= {x = -492.9924621582,	y = 4523.3969726563,	z = 87.132385253906,	type = 5}	 
StabCircuit[10]= {x = -116.10751342773,	y = 4286.2924804688,	z = 45.218502044678,	type = 5}	 
StabCircuit[11]= {x = -210.33193969727,	y = 3812.0615234375,	z = 38.601608276367,	type = 5}	 
StabCircuit[12]= {x = 78.76000213623,	y = 3604.0104980469,	z = 39.42147064209,		type = 5}	 
StabCircuit[13]= {x = 86.558639526367,	y = 3738.3942871094,	z = 39.416732788086,	type = 5}	 
StabCircuit[14]= {x = 56.396797180176,	y = 3619.2453613281,	z = 39.446636199951,	type = 5}	 
StabCircuit[15]= {x = -9.0001230239868,	y = 3605.025390625,		z = 41.633506774902,	type = 8}	 	 
StabCircuit[16]= {x = -9.0001230239868,	y = 3605.025390625,		z = 41.633506774902,	type = 8}	 	 

local Spa = {}
Spa[1]= {x = 5121.724609375,	y = 8562.263671875,		z = 104.38584899902, type = 5}		 
Spa[2]= {x = 5740.337890625,	y = 8006.1962890625,	z = 142.36665344238, type = 5}		 
Spa[3]= {x = 5795.9931640625,	y = 7850.1499023438,	z = 149.75648498535, type = 5}		 
Spa[4]= {x = 5868.2006835938,	y = 7755.8876953125,	z = 151.36102294922, type = 5}		 
Spa[5]= {x = 5571.3247070313,	y = 7746.099609375,		z = 98.629089355469, type = 5}		 
Spa[6]= {x = 5265.9086914063,	y = 7986.876953125,		z = 69.690200805664, type = 5}		 
Spa[7]= {x = 5121.1635742188,	y = 7794.5434570313,	z = 54.382350921631, type = 5}		 
Spa[8]= {x = 5059.404296875,	y = 7372.2880859375,	z = 53.511077880859, type = 5}		 
Spa[9]= {x = 4738.7192382813,	y = 8220.1259765625,	z = 72.857704162598, type = 5}		 
Spa[10]= {x = 4488.7504882813,	y = 8497.24609375,		z = 85.280624389648, type = 5}		 
Spa[11]= {x = 4512.8266601563,	y = 8581.063359375,		z = 88.508415222168, type = 5}		 
Spa[12]= {x = 3989.0803222656,	y = 8882.5751953125,	z = 102.36639404297, type = 5}		 
Spa[13]= {x = 4029.9436035156,	y = 8906.9580078125,	z = 100.01728057861, type = 5}		 
Spa[14]= {x = 4450.3139648438,	y = 8867.056640625,		z = 75.946334838867, type = 8}		 
Spa[15]= {x = 4450.3139648438,	y = 8867.056640625,		z = 75.946334838867, type = 8}		 

local Fujimi = {}
Fujimi[1]= {x = 3899.8012695313,		y = -90.608070373535,		z = 5.5218720436096, 	type = 5}		 
Fujimi[2]= {x = 4049.3852539063,		y = -5.4739346504211,		z = 22.587373733521, 	type = 5}		 
Fujimi[3]= {x = 4185.8408203125,		y = -7.8639125823975,		z = 25.761138916016, 	type = 5}		 
Fujimi[4]= {x = 4164.9560546875,		y = -233.31541442871,		z = 49.344657897949, 	type = 5}		 
Fujimi[5]= {x = 4380.8569335938,		y = -137.2395324707,		z = 116.97289276123, 	type = 5}		 
Fujimi[6]= {x = 4324.6904296875,		y = 22.773597717285,		z = 143.3702545166,	 	type = 5}	 
Fujimi[7]= {x = 4515.873046875,			y = 151.77565002441,		z = 156.83535766602, 	type = 5}		 
Fujimi[8]= {x = 4729.0454101563,		y = 59.913021087646,		z = 187.98551940918, 	type = 5}		 
Fujimi[9]= {x = 4743.1450195313,		y = -169.16166687012,		z = 253.83329772949, 	type = 5}		 
Fujimi[10]= {x = 4906.0776367188,		y = -187.75143432617,		z = 284.36422729492, 	type = 5}		 
Fujimi[11]= {x = 5054.05078125,			y = -243.18934631348,		z = 311.22897338867, 	type = 5}		 
Fujimi[12]= {x = 5020.7705078125,		y = -90.378890991211,		z = 332.27053833008, 	type = 5}		 
Fujimi[13]= {x = 5045.1225585938,		y = 32.693099975586,		z = 342.13433837891, 	type = 5}		 
Fujimi[14]= {x = 5076.158203125,			y = 205.45953369141,		z = 363.14840698242, 	type = 5}		 
Fujimi[15]= {x = 5041.525390625,			y = 432.91711425781,		z = 391.23806762695, 	type = 5}		 
Fujimi[16]= {x = 4932.5239257813,		y = 556.87048339844,		z = 410.82379150391, 	type = 5}		 
Fujimi[17]= {x = 5114.4282226563,		y = 437.06625366211,		z = 428.66439819336, 	type = 5}		 
Fujimi[18]= {x = 5019.322265625,			y = 577.73492431641,		z = 432.28070068359, 	type = 5}		 
Fujimi[19]= {x = 5052.2963867188,		y = 676.22668457031,		z = 447.65838623047, 	type = 5}		 
Fujimi[20]= {x = 5064.6728515625,		y = 712.68865966797,		z = 450.81842041016, 	type = 5}		 
Fujimi[21]= {x = 5209.5463867188,		y = 583.65411376953,		z = 461.38531494141, 	type = 5}		 
Fujimi[22]= {x = 5198.787109375,			y = 762.23663330078,		z = 480.61575317383, 	type = 5}		 
Fujimi[23]= {x = 5213.1254882813,		y = 918.75653076172,		z = 499.59295654297, 	type = 5}		 
Fujimi[24]= {x = 5177.9018554688,		y = 1143.8828125,			z = 517.80035400391, 	type = 5}		 
Fujimi[25]= {x = 5290.7880859375,		y = 1289.1845703125,		z = 553.20245361328, 	type = 5}		 
Fujimi[26]= {x = 5241.037109375,			y = 1118.8822021484,		z = 581.27282714844, 	type = 5}		 
Fujimi[27]= {x = 5248.1943359375,		y = 974.82800292969,		z = 610.58819580078, 	type = 5}		 
Fujimi[28]= {x = 5383.2426757813,		y = 754.92761230469,		z = 682.66839599609, 	type = 5}		 
Fujimi[29]= {x = 5336.443359375,			y = 823.46978759766,		z = 699.92279052734, 	type = 5}		 
Fujimi[30]= {x = 5310.5771484375,		y = 906.55145263672,		z = 707.64282226563, 	type = 5}		 
Fujimi[31]= {x = 5385.2216796875,		y = 901.98663330078,		z = 725.6298828125,	 	type = 5}	 
Fujimi[32]= {x = 5476.7875976563,		y = 1024.98046875,			z = 750.30297851563, 	type = 5}		 
Fujimi[33]= {x = 5680.015625,			y = 1100.7458496094,		z = 721.83984375,	 	type = 5}	 
Fujimi[34]= {x = 5525.9184570313,		y = 1183.9874267578,		z = 739.84918212891, 	type = 5}		 
Fujimi[35]= {x = 5628.3432617188,		y = 1535.5579833984,		z = 712.090820312,	 	type = 5}	 
Fujimi[36]= {x = 5589.365234375,			y = 1612.5881347656,		z = 706.07775878906, 	type = 5}		 
Fujimi[37]= {x = 5673.3837890625,		y = 1635.0170898438,		z = 691.37145996094, 	type = 5}		 
Fujimi[38]= {x = 5606.3564453125,		y = 1694.2645263672,		z = 680.17211914063, 	type = 5}		 
Fujimi[39]= {x = 5547.5771484375,		y = 1819.4490966797,		z = 659.45288085938, 	type = 5}		 
Fujimi[40]= {x = 5589.552734375,			y = 1931.7550048828,		z = 646.2001953125,	 	type = 5}	 
Fujimi[41]= {x = 5685.0356445313,		y = 1910.9609375,			z = 643.90222167969, 	type = 5}		 
Fujimi[41]= {x = 5722.107421875,			y = 2190.9353027344,		z = 617.07843017578, 	type = 5}		 
Fujimi[42]= {x = 5780.7016601563,		y = 2525.1721191406,		z = 568.85394287109, 	type = 5}		 
Fujimi[43]= {x = 5642.216796875,			y = 2386.9768066406,		z = 545.95574951172, 	type = 5}		 
Fujimi[44]= {x = 5491.1298828125,		y = 2345.2055664063,		z = 526.28558349609, 	type = 5}		 
Fujimi[45]= {x = 5373.6284179688,		y = 2341.0688476563,		z = 505.982421875,	 	type = 5} 
Fujimi[46]= {x = 5324.4301757813,		y = 2389.4221191406,		z = 501.01614379883, 	type = 5}		 
Fujimi[47]= {x = 5329.744140625,			y = 2314.6979980469,		z = 486.93899536133, 	type = 5}		 
Fujimi[48]= {x = 5371.103515625,			y = 2244.73046875,			z = 474.73324584961, 	type = 5}		 
Fujimi[49]= {x = 5234.138671875,			y = 2231.9270019531,		z = 463.73941040039, 	type = 5}		 
Fujimi[50]= {x = 5281.2529296875,		y = 2188.0476074219,		z = 456.03784179688, 	type = 5}		 
Fujimi[51]= {x = 5336.2358398438,		y = 2103.0478515625,		z = 445.08172607422, 	type = 5}		 
Fujimi[52]= {x = 5272.1411132813,		y = 2079.7666015625,		z = 426.21441650391, 	type = 5}		 
Fujimi[53]= {x = 5226.072265625,			y = 2094.5610351563,		z = 418.47280883789, 	type = 5}		 
Fujimi[54]= {x = 5228.0986328125,		y = 1916.2950439453,		z = 393.13989257813, 	type = 5}		 
Fujimi[55]= {x = 5080.4487304688,		y = 1863.7147216797,		z = 387.08862304688, 	type = 5}		 
Fujimi[56]= {x = 5142.96875,				y = 1833.3411865234,		z = 382.82626342773, 	type = 5}		 
Fujimi[57]= {x = 5193.8549804688,		y = 1730.3697509766,		z = 364.09704589844, 	type = 5}		 
Fujimi[58]= {x = 5044.3842773438,		y = 1629.1160888672,		z = 345.35357666016, 	type = 5}		 
Fujimi[59]= {x = 4963.953125,			y = 1546.7557373047,		z = 330.06353759766, 	type = 5}		 
Fujimi[60]= {x = 4927.5014648438,		y = 1403.375,				z = 307.43206787109, 	type = 5}		 
Fujimi[61]= {x = 4889.900390625,			y = 1492.3021240234,		z = 299.96426391602, 	type = 5}		 
Fujimi[62]= {x = 4758.6801757813,		y = 1467.8883056641,		z = 286.86468505859, 	type = 5}		 
Fujimi[63]= {x = 4755.6284179688,		y = 1164.5579833984,		z = 263.373046875,	 	type = 5} 
Fujimi[64]= {x = 4739.4545898438,		y = 946.17498779297,		z = 254.61450195313, 	type = 5}		 
Fujimi[65]= {x = 4590.5864257813,		y = 837.71484375,			z = 244.69917297363, 	type = 5}		 
Fujimi[66]= {x = 4629.8627929688,		y = 908.47045898438,		z = 238.12265014648, 	type = 5}		 
Fujimi[67]= {x = 4547.8134765625,		y = 854.00726318359,		z = 228.69761657715, 	type = 5}		 
Fujimi[68]= {x = 4578.4033203125,		y = 929.49255371094,		z = 218.17134094238, 	type = 5}		 
Fujimi[69]= {x = 4513.9794921875,		y = 873.85186767578,		z = 210.19677734375, 	type = 5}		 
Fujimi[70]= {x = 4287.5205078125,		y = 924.1396484375,			z = 195.40873718262, 	type = 5}		 
Fujimi[71]= {x = 4266.1000976563,		y = 865.06945800781,		z = 187.79306030273, 	type = 5}		 
Fujimi[72]= {x = 4308.8120117188,		y = 748.45397949219,		z = 177.3424987793,	 	type = 5} 
Fujimi[73]= {x = 4234.7138671875,		y = 752.20172119141,		z = 175.0941619873,	 	type = 5}	 
Fujimi[74]= {x = 4071.3107910156,		y = 794.28546142578,		z = 167.03091430664, 	type = 5}		 
Fujimi[75]= {x = 3907.9926757813,		y = 924.25988769531,		z = 138.9602355957,	 	type = 5}	 
Fujimi[76]= {x = 3867.8051757813,		y = 864.45251464844,		z = 130.73960876465, 	type = 5}		 
Fujimi[77]= {x = 3887.6164550781,		y = 729.86029052734,		z = 117.482421875,	 	type = 5} 
Fujimi[78]= {x = 3945.9582519531,		y = 667.52673339844,		z = 109.73089599609, 	type = 5}		 
Fujimi[79]= {x = 3971.7731933594,		y = 509.69219970703,		z = 96.306297302246, 	type = 5}		 
Fujimi[80]= {x = 3882.3576660156,		y = 447.47891235352,		z = 85.020233154297, 	type = 5}		 
Fujimi[81]= {x = 3809.3706054688,		y = 589.55090332031,		z = 80.036445617676, 	type = 5}		 
Fujimi[82]= {x = 3740.5622558594,		y = 669.4091796875,			z = 77.36937713623,	 	type = 5}	 
Fujimi[83]= {x = 3710.8061523438,		y = 556.77655029297,		z = 68.338897705078, 	type = 5}		 
Fujimi[84]= {x = 3769.1486816406,		y = 398.42059326172,		z = 48.819023132324, 	type = 5}		 
Fujimi[85]= {x = 3800.6909179688,		y = 180.54866027832,		z = 22.197523117065, 	type = 5}		 
Fujimi[86]= {x = 3750.1293945313,		y = 87.236351013184,		z = 6.8795108795166, 	type = 5}		 
Fujimi[87]= {x = 3792.8669433594,		y = 20.928800582886,		z = 5.2307605743408, 	type = 5}		 
Fujimi[88]= {x = 3829.3020019531,		y = -16.862668991089,		z = 5.2455463409424, 	type = 9}		 
Fujimi[89]= {x = 3829.3020019531,		y = -16.862668991089,		z = 5.2455463409424, 	type = 9}		 

local MyogiDownhill = {}
--Myogi[1]= {x = 6460.08, y = -114.11, z = 1267.95, type = 5}
MyogiDownhill[1]= {x = 5199.39, y = -749.96, z = 1079.78, type = 9}
MyogiDownhill[2]= {x = 5199.39, y = -749.96, z = 1079.78, type = 9}

local MyogiUphill = {}
--Myogi[1]= {x = 5199.39, y = -749.96, z = 1079.78, type = 5}
MyogiUphill[1]= {x = 6460.08, y = -114.11, z = 1267.95, type = 9}
MyogiUphill[2]= {x = 6460.08, y = -114.11, z = 1267.95, type = 9}

local blips = {}
	blips[1] = 	{id = 1, title="Akina Downhill", subtitle = "Requires initialzero resource", colour=5, id=315, x= -3303.3737792969, y= 4840.3310546875, z= 414.9846496582}
    blips[2] =	{id = 2, title="Akina Uphill", subtitle = "Requires initialzero resource", colour=5, id=315, x= -1045.4481201172, y= 6898.9038085938, z= 34.961235046387}
    blips[3] =	{id = 3, title="Nobopotax Reverse", subtitle = "(Full Circuit)", colour=5, id=315, x=-389.02478027344, y = 1179.1552734375, z = 325.10546875,}
    blips[4] =	{id = 4, title="Initial D - The Ultimate Race", subtitle = "(REQUIRES myogi2 and initiald resources)", colour=49, id=315, x=-3273.31, y = 4832.66, z = 416.95,}
    blips[5] =	{id = 5, title="Oroboros (BETA)", subtitle = "Created by Trace X", colour=5, id=315, x=-427.58810424805, y = 1188.5217285156, z = 325.365234375,}
    blips[6] =	{id = 6, title="Ambush Canyon (Nevada)", subtitle = "Requires race_map_pack resource", colour=25, id=315, x= 5357.44, y= 4410.94, z= 11.179671287537,}
    blips[7] =	{id = 7, title="Autumn Ring Full", subtitle = "Requires race_map_pack resource", colour=25, id=315, x= -2975.2358398438, y= -6109.0180664063, z= 281.11199951172,}
    blips[8] =	{id = 8, title="Chicago", subtitle = "Requires race_map_pack resource", colour=25, id=315, x= -400.61346435547, y= -4388.080078125, z= 20.732973098755,}
    blips[9] =	{id = 9, title="Monument Hill Uphill", subtitle = "Requires race_map_pack resource", colour=25, id=315,  x = -2810.3972167969,	y = 2383.5300292969,	z = 3.7235832214355,}
    blips[10] =	{id = 10, title="Okutama", subtitle = "Requires race_map_pack resource", colour=25, id=315,  x = -2416.7312011719,	y = 4259.87109375,		z = 16.913724899292,}
    blips[11] =	{id = 11, title="Wangan (BETA)", subtitle = "Requires race_map_pack resource", colour=25, id=315,  x = 1213.2807617188,	y = -4536.6762695313,	z = 26.770175933838,}
    blips[12] =	{id = 12, title="Nurburgring GP (Germany)", subtitle = "Requires nurburgring resource", colour=5, id=315,  x = 3678.49,	y = -2212.87,	z = 63.73853302002,}
    blips[13] =	{id = 13, title="Stab City Rally", subtitle = "", colour=5, id=315, x = 21.708604812622, y = 3602.46484375, z = 39.568969726563,}
    blips[14] =	{id = 14, title="Circuit de la Spa Francorchamps (Belgium)", subtitle = "Requires race_map_pack resource", colour=25, id=315,x = 4450.3139648438,	y = 8867.056640625,	z = 75.946334838867,}
    blips[15] =	{id = 15, title="Fujimi Kaido", subtitle = "Requires race_map_pack resource", colour=25, id=315,x = 3829.3020019531,		y = -16.862668991089,		z = 5.2455463409424,}
    blips[16] =	{id = 16, title="???", subtitle = "Requires myogi2 resource", colour=79, id=315,x = 6460.08, y = -114.11, z = 1267.95, }
    blips[17] =	{id = 17, title="???", subtitle = "Requires myogi2 resource", colour=79, id=315,x = 5199.39, y = -749.96, z = 1079.78, }



Citizen.CreateThread(function()
    preRace()
end)

function preRace()
    while not IsRacing do
        Citizen.Wait(0)		
			for i, info in pairs(blips) do
				DrawMarker(1, info.x, info.y, info.z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0) 
				if GetDistanceBetweenCoords( info.x, info.y, info.z, GetEntityCoords(LocalPed())) < 25.0 then
					Draw3DText( info.x, info.y, info.z, info.title, 7, 0.3, 0.2)        
					Draw3DText( info.x, info.y, info.z -0.5, info.subtitle, 7, 0.3, 0.2)        
				end
				if GetDistanceBetweenCoords(info.x, info.y, info.z, GetEntityCoords(LocalPed())) < 2.0 then
					if (IsControlJustReleased(1, 27)) then -- Press UP while inside the marker for solo race
						TriggerEvent('StartRaceClient', i) 
					end --end of first control if
				if (IsControlJustReleased(1, 173)) then 
					drawNotification("Starting network race...")
					TriggerServerEvent('StartRaceTrigger', i) -- Press DOWN to send to all players
				end
			end	
		end
	end 
end

RegisterNetEvent("cRace:TPAll")
AddEventHandler("cRace:TPAll", function()
    Citizen.CreateThread(function()
        local time = 0
		car = GetVehiclePedIsUsing(GetPlayerPed(-1))
        function setcountdown(x)
          time = GetGameTimer() + x*1000
        end
        function getcountdown()
          return math.floor((time-GetGameTimer())/1000)
        end
        setcountdown(6)
		PlaySoundFrontend(-1, "Goal", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
		PlaySoundFrontend(-1, "5s", "MP_MISSION_COUNTDOWN_SOUNDSET")
		
        while getcountdown() > 0 do
            Citizen.Wait(1)
            
            -- Controls are now disabled
			SetVehicleForwardSpeed(car, 0.0)
			SetVehicleHandbrake(car, true) -- New code only uses the brakes to keep the car in place
			--SetPlayerControl(PlayerId(),false,256) -- Disables controls and stops player vehicles
            DrawHudText(getcountdown(), {255,191,0,255},0.5,0.4,4.0,4.0)
        end
			PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
			--SetPlayerControl(PlayerId(),true)
			SetVehicleHandbrake(car, false)
			-- TriggerServerEvent('Traffic_Off')
            TriggerEvent("fs_race:BeginRace")
    end)
end)

RegisterNetEvent("fs_race:BeginRace") --main loop
AddEventHandler("fs_race:BeginRace", function()
    startTime = GetGameTimer()
    sectionTime = GetGameTimer()
	sectionTimeDummy = ""
    Citizen.CreateThread(function()
        checkpoint = CreateCheckpoint(track[cP].type, track[cP].x,  track[cP].y,  track[cP].z + 2, track[cP2].x, track[cP2].y, track[cP2].z, 8.0, 1, 204, 204, 50, 0)
        blip = AddBlipForCoord(track[cP].x, track[cP].y, track[cP].z)          
        while IsRacing do 
            Citizen.Wait(5)
            -- SetVehicleDensityMultiplierThisFrame(0.0) -- Disable ambient traffic temporarily (moved to a new resouce)
            -- SetPedDensityMultiplierThisFrame(0.0)
            -- SetRandomVehicleDensityMultiplierThisFrame(0.0)
            -- SetParkedVehicleDensityMultiplierThisFrame(0.0)
            -- SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)

			if (IsControlJustReleased(1, 27) and IsControlPressed(1, 99)) then -- Press X and UP to cancel the race
			    PlaySoundFrontend(-1, "Crash", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
                DeleteCheckpoint(checkpoint)
                RemoveBlip(blip)
                IsRacing = false
				section = 0
				lap = 0
                cP = 1
                cP2 = 2
                --TriggerEvent("chatMessage", "", {255,255,0}, string.format("You abandoned the race... " )) -- TODO: TriggerServerEvent maybe? Some way for all players to see messages like this
				drawNotification("~r~You abandoned the race.")
                preRace()
				break
			end
			
			if (IsControlJustPressed(1, 86) and IsControlJustPressed(1,29)) then -- Press both sticks to teleport to the last valid checkpoint passed
				if (cP > 1) then -- TODO add elseif to teleport back to blips[trackid]
				TriggerEvent("initiald:Sound:PlayOnOne","warp",0.3,false)
				StartScreenEffect("ExplosionJosh3", 0, 0)
				SetPedCoordsKeepVehicle(PlayerPedId(), track[cP-1].x,  track[cP-1].y,  track[cP-1].z+5.0) -- TODO: Add fade to this?
				SetEntityHeading(GetVehiclePedIsUsing(GetPlayerPed(-1)), heading) --TODO: Reset camera bounds
				
				end
			end
			
				
            --Comment these out if you don't want HUD text
            -- DrawHudText(math.floor(GetDistanceBetweenCoords(track[cP].x,  track[cP].y,  track[cP].z, GetEntityCoords(GetPlayerPed(-1)))) .. " meters", {249, 249, 249,255},0.0,0.75,1.0,1.0)
            --DrawHudText(string.format("%i / %i", cP, tablelength(track)), {249, 249, 249, 255},0.20,0.83,0.5,0.5)
            DrawHudText(trackName, {222, 222, 222, 255},0.216,0.96,0.4,0.4)
			--DrawHudText("section time:", {249, 249, 249, 255},0.20,0.83,0.5,0.5)
            if (section > 0) then 	
				--DrawHudText(string.format("Section %i time: %s" , section, sectionTimeDummy), {249, 249, 249, 255},0.21,0.79,0.5,0.5)
				DrawHudText(string.format("Section %i time: %s" , section+1, formatTimer(sectionTime, GetGameTimer())),  {249, 249, 249,255},0.20,0.82,0.75,0.75)
			elseif (lap > 0) then 	
				--DrawHudText(string.format("Section %i time: %s" , section, sectionTimeDummy), {249, 249, 249, 255},0.21,0.79,0.5,0.5)
				DrawHudText(string.format("Lap %i time: %s" , lap, sectionTimeDummy),  {249, 249, 249,255},0.20,0.78,0.75,0.75)
				DrawHudText(string.format("Lap %i time: %s" , lap+1, formatTimer(sectionTime, GetGameTimer())),  {249, 249, 249,255},0.20,0.82,0.75,0.75)
			end
            --DrawHudText(formatTimer(startTime, GetGameTimer()), {249, 249, 249,255},0.20,0.83,0.75,0.75)
            --DrawHudText(string.format("Section %i time: %s" , section+1, formatTimer(sectionTime, GetGameTimer())),  {249, 249, 249,255},0.20,0.82,0.75,0.75)
            DrawHudText(string.format("Total time: %s" , formatTimer(startTime, GetGameTimer())),  {249, 249, 249,255},0.20,0.86,0.75,0.75)
            --DrawHudText(formatTimer(sectionTime, GetGameTimer()), {249, 249, 249,255},0.20,0.86,0.75,0.75)
            --DrawHudText(sectionTimeDummy, {249, 249, 249, 255},0.30,0.83,0.5,0.5)
                if GetDistanceBetweenCoords(track[cP].x,  track[cP].y,  track[cP].z, GetEntityCoords(GetPlayerPed(-1))) < 15.0 then
                    if track[cP].type == 7 then -- Type 7 divides the track into sections
                        DeleteCheckpoint(checkpoint)
                        RemoveBlip(blip)
						sectionTimeDummy = formatTimer(sectionTime, GetGameTimer())
						notification = string.format("Section %i time: %s" , section+1, sectionTimeDummy)
						drawNotification(notification)
						sectionTime = GetGameTimer()
                        PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset")
						section = math.ceil(section+1)
                        cP = math.ceil(cP+1)
                        cP2 = math.ceil(cP2+1)
                        checkpoint = CreateCheckpoint(track[cP].type, track[cP].x,  track[cP].y,  track[cP].z + 2, track[cP2].x, track[cP2].y, track[cP2].z, 8.0, 1, 204, 204, 50, 0)
                        blip = AddBlipForCoord(track[cP].x, track[cP].y, track[cP].z)
						heading = GetEntityHeading(GetVehiclePedIsUsing(GetPlayerPed(-1)))
					
					elseif track[cP].type == 5 then -- Regular checkpoint
                        DeleteCheckpoint(checkpoint)
                        RemoveBlip(blip)
                        PlaySoundFrontend(-1, "Turn", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
                        cP = math.ceil(cP+1)
                        cP2 = math.ceil(cP2+1)
                        checkpoint = CreateCheckpoint(track[cP].type, track[cP].x,  track[cP].y,  track[cP].z + 2, track[cP2].x, track[cP2].y, track[cP2].z, 8.0, 1, 204, 204, 50, 0)
                        blip = AddBlipForCoord(track[cP].x, track[cP].y, track[cP].z)
						heading = GetEntityHeading(GetVehiclePedIsUsing(GetPlayerPed(-1)))
						
					elseif track[cP].type == 8 then -- Type 8 restart the timer (for lap races)
						DeleteCheckpoint(checkpoint)
                        RemoveBlip(blip)
						sectionTimeDummy = formatTimer(sectionTime, GetGameTimer())
						notification = string.format("Lap %i time: %s" , lap+1, sectionTimeDummy)
						drawNotification(notification)
						sectionTime = GetGameTimer()
						--startTime = GetGameTimer()
                        PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset")
						lap = math.ceil(lap+1)
						--section = math.ceil(section+1)
                        cP = 1
                        cP2 = 2
                        checkpoint = CreateCheckpoint(track[cP].type, track[cP].x,  track[cP].y,  track[cP].z + 2, track[cP2].x, track[cP2].y, track[cP2].z, 8.0, 1, 204, 204, 50, 0)
                        blip = AddBlipForCoord(track[cP].x, track[cP].y, track[cP].z)
						heading = GetEntityHeading(GetVehiclePedIsUsing(GetPlayerPed(-1)))						
						
					elseif track[cP].type == 40 then -- Warps to the next checkpoint and triggers its effects
						veh = GetVehiclePedIsUsing(GetPlayerPed(-1))
						rpm = GetVehicleCurrentRpm(veh)
						speed = GetEntitySpeed(veh)
						
                        DeleteCheckpoint(checkpoint)
                        RemoveBlip(blip)
						
						TriggerEvent("initiald:Sound:PlayOnOne","warp",0.4,false)
						StartScreenEffect("ExplosionJosh3", 0, 0)
						SetPedCoordsKeepVehicle(PlayerPedId(), track[cP+1].x,  track[cP+1].y,  track[cP+1].z+5.0)
						
						SetEntityHeading(veh, track[cP+1].heading)
						SetVehicleCurrentRpm(veh, rpm)
						SetVehicleForwardSpeed(veh, speed)
						
                        cP = math.ceil(cP+1)
                        cP2 = math.ceil(cP2+1)
                        checkpoint = CreateCheckpoint(track[cP].type, track[cP].x,  track[cP].y,  track[cP].z + 2, track[cP2].x, track[cP2].y, track[cP2].z, 8.0, 1, 204, 204, 50, 0)
                        blip = AddBlipForCoord(track[cP].x, track[cP].y, track[cP].z)
                    else
                        PlaySoundFrontend(-1, "ScreenFlash", "WastedSounds")
                        DeleteCheckpoint(checkpoint)
                        RemoveBlip(blip)
						sectionTimeDummy = formatTimer(sectionTime, GetGameTimer())
						notification = string.format("Section %i time: %s" , section+1, sectionTimeDummy)
                        IsRacing = false
						section = 0
                        cP = 1
                        cP2 = 2
						veh = GetVehiclePedIsUsing(GetPlayerPed(-1))						
                        TriggerEvent("chatMessage", "", {255,255,255}, string.format("Finished " .. trackName .. "\n Vehicle: " .. GetDisplayNameFromVehicleModel(GetEntityModel(veh)) .. " \nTotal time: " .. formatTimer(startTime, GetGameTimer())))
                        preRace()
						break
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
        newString = string.format("%s:%02s.%s", min, sec, ms)
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
    SetTextFont(4)
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
Citizen.CreateThread(function() -- Places race start locations on the minimap
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

RegisterNetEvent("StartRaceClient")
AddEventHandler("StartRaceClient", function(trackid)
    Citizen.CreateThread(function()
        if IsRacing == false then
            IsRacing = true
			-- erase the existing track just in case
			for k in pairs(track) do
				track[k] = nil
			end
				
			if (trackid == 5) then		 -- TODO: Make an array for all the tracks so this can be done dynamically		
				for k,v in pairs(Oroboros) do				
					track[k] = v
				end			
			elseif (trackid == 4) then
				for k,v in pairs(UltimateRace) do				
					track[k] = v
				end
			elseif (trackid == 3) then			
				for k,v in pairs(NaboRevFull) do				
					track[k] = v
				end
			elseif (trackid == 2) then
				for k,v in pairs(AkinaUphill) do
					track[k] = v
				end
			elseif (trackid == 1) then
				for k,v in pairs(AkinaDownhill) do
					track[k] = v
				end			
			elseif (trackid == 6) then
				for k,v in pairs(AmbushCanyon) do
					track[k] = v
				end			
			elseif (trackid == 7) then
				for k,v in pairs(AutumnRingFull) do
					track[k] = v
				end
			elseif (trackid == 8) then
				for k,v in pairs(ChicagoTrack) do
					track[k] = v
				end			
			elseif (trackid == 9) then
				for k,v in pairs(MonumentUphill) do
					track[k] = v
				end
			elseif (trackid == 10) then
				for k,v in pairs(Okutama) do
					track[k] = v
				end
			elseif (trackid == 11) then
				for k,v in pairs(Tokyoway) do
					track[k] = v
				end
			elseif (trackid == 12) then
				for k,v in pairs(Nurburgring) do
					track[k] = v
				end	
			elseif (trackid == 13) then
				for k,v in pairs(StabCircuit) do
					track[k] = v
				end			
			elseif (trackid == 14) then
				for k,v in pairs(Spa) do
					track[k] = v
				end			
			elseif (trackid == 15) then
				for k,v in pairs(Fujimi) do
					track[k] = v
				end			
				elseif (trackid == 16) then
				for k,v in pairs(MyogiDownhill) do
					track[k] = v
				end
				elseif (trackid == 17) then
				for k,v in pairs(MyogiUphill) do
					track[k] = v
				end
			end
			
			trackName = blips[trackid].title
			drawNotification(trackName)
            TriggerEvent("cRace:TPAll")
        else
            return
        end
	end)
end)



function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end
