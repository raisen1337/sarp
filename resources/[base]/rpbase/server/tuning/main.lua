
Config = {}

Config.WebHook = ""--your webhook here

Config.Currency = "$"

Config.Range = 3.5 -- The range that you can open the menu

Config.TunningLocations = {
	{
		name = "LS - Mechanic", -- Name of the Location that will appear if blipmap == true
		coords = vector3(895.28576660156,3603.814453125,32.203659057617), --The coords to open menu
		job = "mechanic", --The job that have access to it (remove the line and everyone can access it)
		howmuchtopay = 100, -- The percentage to pay. In this blip, the player/society will pay the normal price (100%), you can change it, for example, if you change it to 190, the player will pay 1.9x the original price, if the tunning costs 1000, the player will pay 1900
		society = true, -- The money that the client pay goes to the society account? (will only work if job isn't nil.)
		societypercentage = 50, --50% of the money goes to society and the other 50% goes to the mechanic (will only work if society = true.)
		blipmap = true, --Show the blip in map?
		blipeveryone = false, --if false, the blip will be only visible to the job
		blipsprite = 72, -- The blip sprite, there's a list of all available: https://docs.fivem.net/docs/game-references/blips/
		used = false, -- Don't tuch
	},

}

Config.PricesByClass = false --true if you want the price to change by vehicle class

Config.ClassPrices = { -- Will only work if Config.PricesByClass == true
	-- Change the number that's after [k], for example 1.0 will pay the normal price, 1.2 will pay price * 1.2
	[0] = 1.0,-- Compacts  
	[1] = 1.0,--Sedans  
	[2] = 1.0,--SUVs  
	[3] = 1.0,--Coupes  
	[4] = 1.0,--Muscle  
	[5] = 1.0,--Sports Classics  
	[6] = 1.0,--Sports  
	[7] = 1.2,--Super  
	[8] = 1.0,--Motorcycles  
	[9] = 1.0,--Off-road  
	[10] = 1.0,--Industrial  
	[11] = 1.0,--Utility  
	[12] = 1.0,--Vans  
	[13] = 1.0,--Cycles  
	[14] = 1.0,--Boats  
	[15] = 1.0,--Helicopters  
	[16] = 1.0,--Planes  
	[17] = 1.0,--Service  
	[18] = 1.0,--Emergency  
	[19] = 1.0,--Military  
	[20] = 1.0,--Commercial  
	[21] = 1.0,--Trains 
}

Config.AllowVehicleExceptions = false

Config.VehicleExceptions = {
	["gtr"] = 1.5, -- In this case, the gtr will pay the price * 1.5. You can add more cars, it's up to you
}

Config.MysqlAsync = true -- Set true if you use Mysql-Async and false if you use ghmattimysql, if you don't know what is the difference, then you probably use Mysql-Async and you shouldn't change this.

Config.Translations = {
	["change"] = "Change",
	["windtint"] = "Window Tint",
	["plate"] = "Plate Style",
	["Spoiler"] = "Spoiler",
	["Front Bumper"] = "Front Bumper",
	["Rear Bumper"] = "Rear Bumper",
	["Side Skirt"] = "Side Skirt",
	["Exhaust"] = "Exhaust",
	["Roll Cage"] = "Roll Cage",
	["Grill"] = "Grill",
	["Hood"] = "Hood",
	["Left Fender"] = "Left Fender",
	["Right Fender"] = "Right Fender",
	["Roof"] = "Roof",
	["Engine"] = "Engine",
	["Brake"] = "Brake",
	["Transmission"] = "Transmission",
	["Horn"] = "Horn",
	["Suspension"] = "Suspension",
	["Armor"] = "Armor",
	["Headlights"] = "Headlights",
	["Tyres Front"] = "Tyres",
	["Tyres Back"] = "Tyres",
	["Plate Holder"] = "Plate Holder",
	["Vanity Plate"] = "Vanity Plate",
	["Trim A"] = "Trim A",
	["Ornaments"] = "Ornaments",
	["Dashboard"] = "Dashboard",
	["Dial"] = "Dial",
	["Doors"] = "Doors",
	["Seats"] = "Seats",
	["Steering Wheel"] = "Steering Wheel",
	["Shifter Leaver"] = "Shifter Leaver",
	["Plaque"] = "Plaque",
	["Speakers"] = "Speakers",
	["Trunk"] = "Trunk",
	["Hydraulic"] = "Hydraulic",
	["Engine Block"] = "Engine Block",
	["Air Filter"] = "Air Filter",
	["Strut"] = "Strut",
	["Arch Cover"] = "Arch Cover",
	["Aerial"] = "Aerial",
	["Trim B"] = "Trim B",
	["Fuel Tank"] = "Fuel Tank",
	["Window"] = "Window",
	["Livery"] = "Livery",
	["Livery2"] = "Livery",
	["stock"] = "stock", --Don't know what this is....
	["sport"] = "sport",
	["muscle"] = "muscle",
	["lowrider"] = "lowrider",
	["suv"] = "suv",
	["offroad"] = "offroad",
	["tuner"] = "tuner",
	["motorcycle"] = "motorcycle",
	["highend"] = "highend",
	["bennys"] = "bennys",
	["bespoke"] = "bespoke",
	["f1"] = "f1",
	["rua"] = "rua",
	["track"] = "track",
	-- The rest of menus:
	["def"] = "Default",
	["vehneons"] = "Vehicle Neons",
	["instneons"] = "Install Neons",
	["remneons"] = "Remove Neons",
	["smoketyres"] = "Tyre Smoke",
	["smokeclr"] = "Smoke Colors",
	["vehclr"] = "Vehicle Colors",
	["vehstyle"] = "Vehicle Style",
	["prima"] = "Primary",
	["primecolor"] = "Primary Color",
	["rgb"] = "RGB Color",
	["normal"] = "Normal",
	["metallic"] = "Metallic",
	["pearl"] = "Pearl",
	["matte"] = "Matte",
	["metal"] = "Metal",
	["chrome"] = "Chrome",
	["sec"] = "Secondary",
	["seccolor"] = "Secondary Color",
	["pearls"] = "Pearlescent",
	["whelclor"] = "Wheel Colour",
	["dashclr"] = "Dashboard Colour",
	["intclr"] = "Interior Colour",
	["bproof"] = "Bullet Proof",
	["toption"] = "Tyres Options",
	["vehtyres"] = "Vehicle Tyres",
	["turbo"] = "Turbo",
	["headlight"] = "Headlight",
	["xenon"] = "Xenon",
	["xenonclr"] = "Xenon Color",
	["extra"] = "Extra",
	["drift"] = "Drift Tyres",
}

--Credits to https://wiki.altv.mp/wiki/GTA:Vehicle_Mods for the amazing Vehicle Mods docs

Config.TunningPrices = {
	["Spoiler"] = {
		base = 1000, --base price
		bylevel = 50 --+ for each level, for example level 1: 1000$; level 2: 1050$
	},
	["Front Bumper"] = {
		base = 1000,
		bylevel = 50
	},
	["Rear Bumper"] = {
		base = 1000,
		bylevel = 50
	},
	["Side Skirt"] = {
		base = 1000,
		bylevel = 50
	},
	["Exhaust"] = {
		base = 1000,
		bylevel = 50
	},
	["Roll Cage"] = {
		base = 1000,
		bylevel = 50
	},
	["Grill"] = {
		base = 1000,
		bylevel = 50
	},
	["Hood"] = {
		base = 1000,
		bylevel = 50
	},
	["Left Fender"] = {
		base = 1000,
		bylevel = 50
	},
	["Right Fender"] = {
		base = 1000,
		bylevel = 50
	},
	["Roof"] = {
		base = 1000,
		bylevel = 50
	},
	["Engine"] = {
		base = 1000,
		bylevel = 50
	},
	["Brake"] = {
		base = 1000,
		bylevel = 50
	},
	["Transmission"] = {
		base = 1000,
		bylevel = 50
	},
	["Horn"] = {
		base = 1000,
		bylevel = 50
	},
	["Suspension"] = {
		base = 1000,
		bylevel = 50
	},
	["Armor"] = {
		base = 1000,
		bylevel = 50
	},
	["Headlights"] = {
		base = 1000,
		bylevel = 50
	},
	["Tyres Front"] = {
		base = 1000,
		bylevel = 50
	},
	["Tyres Back"] = {
		base = 1000,
		bylevel = 50
	},
	["Plate Holder"] = {
		base = 1000,
		bylevel = 50
	},
	["Vanity Plate"] = {
		base = 1000,
		bylevel = 50
	},
	["Trim A"] = {
		base = 1000,
		bylevel = 50
	},
	["Ornaments"] = {
		base = 1000,
		bylevel = 50
	},
	["Dashboard"] = {
		base = 1000,
		bylevel = 50
	},
	["Dial"] = {
		base = 1000,
		bylevel = 50
	},
	["Doors"] = {
		base = 1000,
		bylevel = 50
	},
	["Seats"] = {
		base = 1000,
		bylevel = 50
	},
	["Steering Wheel"] = {
		base = 1000,
		bylevel = 50
	},
	["Shifter Leaver"] = {
		base = 1000,
		bylevel = 50
	},
	["Plaque"] = {
		base = 1000,
		bylevel = 50
	},
	["Speakers"] = {
		base = 1000,
		bylevel = 50
	},
	["Trunk"] = {
		base = 1000,
		bylevel = 50
	},
	["Hydraulic"] = {
		base = 1000,
		bylevel = 50
	},
	["Engine Block"] = {
		base = 1000,
		bylevel = 50
	},
	["Air Filter"] = {
		base = 1000,
		bylevel = 50
	},
	["Strut"] = {
		base = 1000,
		bylevel = 50
	},
	["Arch Cover"] = {
		base = 1000,
		bylevel = 50
	},
	["Aerial"] = {
		base = 1000,
		bylevel = 50
	},
	["Trim B"] = {
		base = 1000,
		bylevel = 50
	},
	["Fuel Tank"] = {
		base = 1000,
		bylevel = 50
	},
	["Window"] = {
		base = 1000,
		bylevel = 50
	},
	["Livery"] = {
		base = 1000,
		bylevel = 50
	},
	["Livery2"] = { -- YHEAAAA, 2 LIVERY? WHY? BECAUSE THERE'S 2 DIFFERENT FUNCTIONS TO LIVERYS... I know... It's stupid, don't blame me xd
		base = 1000,
		bylevel = 50
	},
	["PrimaryRGBColor"] = {
		base = 500,
	},
	["SecondaryRGBColor"] = {
		base = 300,
	},
	["PrimaryColorType"] = {
		base = 200,
		bylevel = 0,
	},
	["SecondaryColorType"] = {
		base = 175,
		bylevel = 0,
	},
	["pearltab"] = { -- Pearlescent Tab
		base = 250,
		bylevel = 0,
	},
	["whlclrtab"] = { -- Wheel Colors Tab
		base = 150,
		bylevel = 0,
	},
	["dshclrtab"] = { -- Dashboard Tab
		base = 120,
		bylevel = 0,
	},
	["intclrtab"] = { -- Interior Tab
		base = 120,
		bylevel = 0,
	},
	["neons"] = { -- Install Neons (Not change color)
		base = 200,
		bylevel = 0,
	},
	["NeonsRGBColor"] = {
		base = 750,
	},
	["SmokeRGBColor"] = {
		base = 300,
	},
	["windtint"] = {
		base = 200,
		bylevel = -10,
	},
	["plate"] = {
		base = 55,
		bylevel = 10,
	},
	["turbo"] = {
		base = 250,
		bylevel = 0,
	},
	["xenon"] = {
		base = 150,
		bylevel = 0,
	},
	["xenoncolor"] = {
		base = 100,
		bylevel = 0,
	},
	---WHEELS TYPE---
	["suv"] = {
		base = 100,
		bylevel = 10,
	},
	["bennys"] = {
		base = 100,
		bylevel = 10,
	},
	["rua"] = {
		base = 100,
		bylevel = 10,
	},
	["track"] = {
		base = 100,
		bylevel = 10,
	},
	["f1"] = {
		base = 100,
		bylevel = 10,
	},
	["motorcycle"] = {
		base = 100,
		bylevel = 10,
	},
	["tuner"] = {
		base = 100,
		bylevel = 10,
	},
	["sport"] = {
		base = 100,
		bylevel = 10,
	},
	["bespoke"] = {
		base = 100,
		bylevel = 10,
	},
	["muscle"] = {
		base = 100,
		bylevel = 10,
	},
	["lowrider"] = {
		base = 100,
		bylevel = 10,
	},
	["offroad"] = {
		base = 100,
		bylevel = 10,
	},
	["highend"] = {
		base = 100,
		bylevel = 10,
	},
	----END
	["bulletproof"] = {
		base = 250,
		bylevel = 0,
	},
	["costum-wheel"] = {
		base = 50,
		bylevel = 0,
	},
	["extra"] = {
		base = 50,
		bylevel = 0,
	},
	["drift"] = {
		base = 500,
		bylevel = 0,
	},
}

Config.TunningMods = {
	["Spoiler"] = 0,
	["Front Bumper"] = 1,
	["Rear Bumper"] = 2,
	["Side Skirt"] = 3,
	["Exhaust"] = 4,
	["Roll Cage"] = 5,
	["Grill"] = 6,
	["Hood"] = 7,
	["Left Fender"] = 8,
	["Right Fender"] = 9,
	["Roof"] = 10,
	["Engine"] = 11,
	["Brake"] = 12,
	["Transmission"] = 13,
	["Horn"] = 14,
	["Suspension"] = 15,
	["Armor"] = 16,
	["Headlights"] = 22,
	["Tyres Front"] = 23,
	["Tyres Back"] = 24,
	["Plate Holder"] = 25,
	["Vanity Plate"] = 26,
	["Trim A"] = 27,
	["Ornaments"] = 28,
	["Dashboard"] = 29,
	["Dial"] = 30,
	["Doors"] = 31,
	["Seats"] = 32,
	["Steering Wheel"] = 33,
	["Shifter Leaver"] = 34,
	["Plaque"] = 35,
	["Speakers"] = 36,
	["Trunk"] = 37,
	["Hydraulic"] = 38,
	["Engine Block"] = 39,
	["Air Filter"] = 40,
	["Strut"] = 41,
	["Arch Cover"] = 42,
	["Aerial"] = 43,
	["Trim B"] = 44,
	["Fuel Tank"] = 45,
	["Window"] = 46,
	["Livery"] = 48,
}
Config.Wheels = {
	--["stock"] = -1, --Don't know what this is....
	["sport"] = 0,
	["muscle"] = 1,
	["lowrider"] = 2,
	["suv"] = 3,
	["offroad"] = 4,
	["tuner"] = 5,
	["motorcycle"] = 6,
	["highend"] = 7,
	["bennys"] = 8,
	["bespoke"] = 9,
	["f1"] = 10,
	["rua"] = 11,
	["track"] = 12
}

Config.ColoursExtra = {
	{name = "Black", id = 0},
	{name = "Carbon Black", id = 147},
	{name = "Graphite", id = 1},
	{name = "Black Steel", id = 11},
	{name = "Dark Steel", id = 3},
	{name = "Silver", id = 4},
	{name = "Bluish Silver", id = 5},
	{name = "Rolled Steel", id = 6},
	{name = "Shadow Silver", id = 7},
	{name = "Stone Silver", id = 8},
	{name = "Midnight Silver", id = 9},
	{name = "Cast Iron Silver", id = 10},
	{name = "Red", id = 27},
	{name = "Torino Red", id = 28},
	{name = "Formula Red", id = 29},
	{name = "Lava Red", id = 150},
	{name = "Blaze Red", id = 30},
	{name = "Grace Red", id = 31},
	{name = "Garnet Red", id = 32},
	{name = "Sunset Red", id = 33},
	{name = "Cabernet Red", id = 34},
	{name = "Wine Red", id = 143},
	{name = "Candy Red", id = 35},
	{name = "Hot Pink", id = 135},
	{name = "Pfsiter Pink", id = 137},
	{name = "Salmon Pink", id = 136},
	{name = "Sunrise Orange", id = 36},
	{name = "Orange", id = 38},
	{name = "Bright Orange", id = 138},
	{name = "Gold", id = 99},
	{name = "Bronze", id = 90},
	{name = "Yellow", id = 88},
	{name = "Race Yellow", id = 89},
	{name = "Dew Yellow", id = 91},
	{name = "Dark Green", id = 49},
	{name = "Racing Green", id = 50},
	{name = "Sea Green", id = 51},
	{name = "Olive Green", id = 52},
	{name = "Bright Green", id = 53},
	{name = "Gasoline Green", id = 54},
	{name = "Lime Green", id = 92},
	{name = "Midnight Blue", id = 141},
	{name = "Galaxy Blue", id = 61},
	{name = "Dark Blue", id = 62},
	{name = "Saxon Blue", id = 63},
	{name = "Blue", id = 64},
	{name = "Mariner Blue", id = 65},
	{name = "Harbor Blue", id = 66},
	{name = "Diamond Blue", id = 67},
	{name = "Surf Blue", id = 68},
	{name = "Nautical Blue", id = 69},
	{name = "Racing Blue", id = 73},
	{name = "Ultra Blue", id = 70},
	{name = "Light Blue", id = 74},
	{name = "Chocolate Brown", id = 96},
	{name = "Bison Brown", id = 101},
	{name = "Creeen Brown", id = 95},
	{name = "Feltzer Brown", id = 94},
	{name = "Maple Brown", id = 97},
	{name = "Beechwood Brown", id = 103},
	{name = "Sienna Brown", id = 104},
	{name = "Saddle Brown", id = 98},
	{name = "Moss Brown", id = 100},
	{name = "Woodbeech Brown", id = 102},
	{name = "Straw Brown", id = 99},
	{name = "Sandy Brown", id = 105},
	{name = "Bleached Brown", id = 106},
	{name = "Schafter Purple", id = 71},
	{name = "Spinnaker Purple", id = 72},
	{name = "Midnight Purple", id = 142},
	{name = "Bright Purple", id = 145},
	{name = "Cream", id = 107},
	{name = "Ice White", id = 111},
	{name = "Frost White", id = 112},
	{name = "Black", id = 12},
	{name = "Gray", id = 13},
	{name = "Light Gray", id = 14},
	{name = "Ice White", id = 131},
	{name = "Blue", id = 83},
	{name = "Dark Blue", id = 82},
	{name = "Midnight Blue", id = 84},
	{name = "Midnight Purple", id = 149},
	{name = "Schafter Purple", id = 148},
	{name = "Red", id = 39},
	{name = "Dark Red", id = 40},
	{name = "Orange", id = 41},
	{name = "Yellow", id = 42},
	{name = "Lime Green", id = 55},
	{name = "Green", id = 128},
	{name = "Forest Green", id = 151},
	{name = "Foliage Green", id = 155},
	{name = "Olive Darb", id = 152},
	{name = "Dark Earth", id = 153},
	{name = "Desert Tan", id = 154},
	{name = "Brushed Steel", id = 117},
	{name = "Brushed Black Steel", id = 118},
	{name = "Brushed Aluminium", id = 119},
	{name = "Pure Gold", id = 158},
	{name = "Brushed Gold", id = 159},
	{name = "Chrome", id = 120}
}

if Config.WebHook and Config.WebHook ~= "" then
	function sendToDiscord(name,message,color)
		local DiscordWebHook = Config.WebHook

		local embeds = {
			{
			  ["title"] = message,
			  ["type"] = "rich",
			  ["color"] = color,
			}
		}

	if message == nil or message == '' then return false end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers)end, 'POST', json.encode({ username = name,embeds = embeds}), {['Content-Type'] = 'application/json'})
	end
end

Core.CreateCallback('TunningSystem3hu:Used', function(source,cb,id,netid)
	local enviar = false
	
    cb(enviar)

end)

RegisterServerEvent('TunningSystem3hu:PayModifications')
AddEventHandler('TunningSystem3hu:PayModifications', function(preco,id,vehprops)

    local _source = source
    local pago = false
    local Player = Core.GetPlayerData(_source)
    local whyisitasync = false
    
	if Player.cash >= preco then
		pago = true
		Player.cash = Player.cash - preco
		exports.oxmysql:executeSync("UPDATE players SET data = ? WHERE identifier = ?", {json.encode(Player), Player.identifier})
	else
		TriggerClientEvent('Notify:Send', _source, "Tuning", "Nu ai destui bani!", 'error')
	end
    
    if pago then
        SaveVehicle(vehprops)
    end
    TriggerClientEvent("TunningSystem3hu:PayAfter",_source,pago)
end)

function SaveVehicle(vehprops)	
	
	local vehicle = exports.oxmysql:executeSync('SELECT * FROM vehicles WHERE plate = ?', {vehprops.plate})

	if vehicle[1] then
		
		local vehData = jd(vehicle[1].data)
		
		if not vehData.mods then
			vehData.mods = vehprops
		else
			vehData.mods = vehprops
		end
		exports.oxmysql:executeSync("UPDATE vehicles SET data = ? WHERE plate = ?", {json.encode(vehData), vehprops.plate})

	end

end


function SendUsed(id,type)
	Config.TunningLocations[id].used = type
	TriggerClientEvent("TunningSystem3hu:Used",-1,id, type)
end