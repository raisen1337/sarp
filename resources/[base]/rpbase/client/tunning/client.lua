local myjob
local blips = {}
local nomidaberto
carroselected = nil
rodaatual = nil
rodaatual2 = nil
local cam = nil
local gameplaycam = nil
local focuson = false
local TunagensDefault = {}
local preco = 0
local multiplier = 1


function GetNeons()
	local r, g, b = GetVehicleNeonLightsColour(carroselected)
	local selecionado = 1
	local neonsligado = false
	for i = 0, 3 do
		if IsVehicleNeonLightEnabled(carroselected, i) then
			neonsligado = true
		end
	end
	if neonsligado then
		selecionado = 2
	end
	local neonstable = { r = r, g = g, b = b, ligado = neonsligado }
	local menu = {
		type = json.encode({ tipo = "neons" }),
		title = Config.Translations["vehneons"],
		src = "img/neons.png",
		subMenuTitle = Config.Translations["change"] .. " " .. Config.Translations["vehneons"],
		subMenuSelected = selecionado,
		subMenu = {
			{
				type = json.encode({ tipo = "defaultneon", index = { r = r, g = g, b = b }, ligado = neonsligado }),
				title = Config.Translations["def"],
				src = "img/Default.png",
			},
			{
				type = json.encode({ tipo = "neonsc", index = 0 }),
				title = Config.Translations["remneons"],
				src = "img/neons.png",
			},
			{
				type = json.encode({ tipo = "neonsc", index = 1 }),
				title = Config.Translations["instneons"],
				src = "img/neons.png",
			},
			{
				type = json.encode({ tipo = "change-neons" }),
				title = Config.Translations["change"] .. " " .. Config.Translations["vehneons"],
				src = "img/rgb.png",
				colorpicker = true,
				currentColor = { r = r, g = g, b = b },
			},
		},
	}
	return menu, neonstable
end

function GetSmoke()
	local r, g, b = GetVehicleTyreSmokeColor(carroselected)
	local menu = {
		type = json.encode({ tipo = "smoke" }),
		title = Config.Translations["smoketyres"],
		src = "img/TyreSmoke.png",
		subMenuTitle = Config.Translations["change"] .. " " .. Config.Translations["smoketyres"],
		subMenuSelected = selecionado,
		subMenu = {
			{
				type = json.encode({ tipo = "smokedefault", index = { r = r, g = g, b = b } }),
				title = Config.Translations["def"],
				src = "img/Default.png",
			},
			{
				type = json.encode({ tipo = "smoke" }),
				title = Config.Translations["change"] .. " " .. Config.Translations["smokeclr"],
				src = "img/rgb.png",
				colorpicker = true,
				currentColor = { r = r, g = g, b = b },
			},
		}
	}
	return menu, { r = r, g = g, b = b }
end

Config = {}

Config.WebHook = "" --your webhook here

Config.Currency = "$"

Config.Range = 3.5 -- The range that you can open the menu

Config.TunningLocations = {
	{
		name = "LS - Mechanic",           -- Name of the Location that will appear if blipmap == true
		coords = vector3(895.28576660156,3603.814453125,32.203659057617), --The coords to open menu
		job = "mechanic",                 --The job that have access to it (remove the line and everyone can access it)
		howmuchtopay = 100,               -- The percentage to pay. In this blip, the player/society will pay the normal price (100%), you can change it, for example, if you change it to 190, the player will pay 1.9x the original price, if the tunning costs 1000, the player will pay 1900
		society = true,                   -- The money that the client pay goes to the society account? (will only work if job isn't nil.)
		societypercentage = 50,           --50% of the money goes to society and the other 50% goes to the mechanic (will only work if society = true.)
		blipmap = true,                   --Show the blip in map?
		blipeveryone = false,             --if false, the blip will be only visible to the job
		blipsprite = 72,                  -- The blip sprite, there's a list of all available: https://docs.fivem.net/docs/game-references/blips/
		used = false,                     -- Don't tuch
	},
	
}

Config.PricesByClass = false --true if you want the price to change by vehicle class

Config.ClassPrices = {       -- Will only work if Config.PricesByClass == true
	-- Change the number that's after [k], for example 1.0 will pay the normal price, 1.2 will pay price * 1.2
	[0] = 1.0,               -- Compacts
	[1] = 1.0,               --Sedans
	[2] = 1.0,               --SUVs
	[3] = 1.0,               --Coupes
	[4] = 1.0,               --Muscle
	[5] = 1.0,               --Sports Classics
	[6] = 1.0,               --Sports
	[7] = 1.2,               --Super
	[8] = 1.0,               --Motorcycles
	[9] = 1.0,               --Off-road
	[10] = 1.0,              --Industrial
	[11] = 1.0,              --Utility
	[12] = 1.0,              --Vans
	[13] = 1.0,              --Cycles
	[14] = 1.0,              --Boats
	[15] = 1.0,              --Helicopters
	[16] = 1.0,              --Planes
	[17] = 1.0,              --Service
	[18] = 1.0,              --Emergency
	[19] = 1.0,              --Military
	[20] = 1.0,              --Commercial
	[21] = 1.0,              --Trains
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
	{ name = "Black",               id = 0 },
	{ name = "Carbon Black",        id = 147 },
	{ name = "Graphite",            id = 1 },
	{ name = "Black Steel",         id = 11 },
	{ name = "Dark Steel",          id = 3 },
	{ name = "Silver",              id = 4 },
	{ name = "Bluish Silver",       id = 5 },
	{ name = "Rolled Steel",        id = 6 },
	{ name = "Shadow Silver",       id = 7 },
	{ name = "Stone Silver",        id = 8 },
	{ name = "Midnight Silver",     id = 9 },
	{ name = "Cast Iron Silver",    id = 10 },
	{ name = "Red",                 id = 27 },
	{ name = "Torino Red",          id = 28 },
	{ name = "Formula Red",         id = 29 },
	{ name = "Lava Red",            id = 150 },
	{ name = "Blaze Red",           id = 30 },
	{ name = "Grace Red",           id = 31 },
	{ name = "Garnet Red",          id = 32 },
	{ name = "Sunset Red",          id = 33 },
	{ name = "Cabernet Red",        id = 34 },
	{ name = "Wine Red",            id = 143 },
	{ name = "Candy Red",           id = 35 },
	{ name = "Hot Pink",            id = 135 },
	{ name = "Pfsiter Pink",        id = 137 },
	{ name = "Salmon Pink",         id = 136 },
	{ name = "Sunrise Orange",      id = 36 },
	{ name = "Orange",              id = 38 },
	{ name = "Bright Orange",       id = 138 },
	{ name = "Gold",                id = 99 },
	{ name = "Bronze",              id = 90 },
	{ name = "Yellow",              id = 88 },
	{ name = "Race Yellow",         id = 89 },
	{ name = "Dew Yellow",          id = 91 },
	{ name = "Dark Green",          id = 49 },
	{ name = "Racing Green",        id = 50 },
	{ name = "Sea Green",           id = 51 },
	{ name = "Olive Green",         id = 52 },
	{ name = "Bright Green",        id = 53 },
	{ name = "Gasoline Green",      id = 54 },
	{ name = "Lime Green",          id = 92 },
	{ name = "Midnight Blue",       id = 141 },
	{ name = "Galaxy Blue",         id = 61 },
	{ name = "Dark Blue",           id = 62 },
	{ name = "Saxon Blue",          id = 63 },
	{ name = "Blue",                id = 64 },
	{ name = "Mariner Blue",        id = 65 },
	{ name = "Harbor Blue",         id = 66 },
	{ name = "Diamond Blue",        id = 67 },
	{ name = "Surf Blue",           id = 68 },
	{ name = "Nautical Blue",       id = 69 },
	{ name = "Racing Blue",         id = 73 },
	{ name = "Ultra Blue",          id = 70 },
	{ name = "Light Blue",          id = 74 },
	{ name = "Chocolate Brown",     id = 96 },
	{ name = "Bison Brown",         id = 101 },
	{ name = "Creeen Brown",        id = 95 },
	{ name = "Feltzer Brown",       id = 94 },
	{ name = "Maple Brown",         id = 97 },
	{ name = "Beechwood Brown",     id = 103 },
	{ name = "Sienna Brown",        id = 104 },
	{ name = "Saddle Brown",        id = 98 },
	{ name = "Moss Brown",          id = 100 },
	{ name = "Woodbeech Brown",     id = 102 },
	{ name = "Straw Brown",         id = 99 },
	{ name = "Sandy Brown",         id = 105 },
	{ name = "Bleached Brown",      id = 106 },
	{ name = "Schafter Purple",     id = 71 },
	{ name = "Spinnaker Purple",    id = 72 },
	{ name = "Midnight Purple",     id = 142 },
	{ name = "Bright Purple",       id = 145 },
	{ name = "Cream",               id = 107 },
	{ name = "Ice White",           id = 111 },
	{ name = "Frost White",         id = 112 },
	{ name = "Black",               id = 12 },
	{ name = "Gray",                id = 13 },
	{ name = "Light Gray",          id = 14 },
	{ name = "Ice White",           id = 131 },
	{ name = "Blue",                id = 83 },
	{ name = "Dark Blue",           id = 82 },
	{ name = "Midnight Blue",       id = 84 },
	{ name = "Midnight Purple",     id = 149 },
	{ name = "Schafter Purple",     id = 148 },
	{ name = "Red",                 id = 39 },
	{ name = "Dark Red",            id = 40 },
	{ name = "Orange",              id = 41 },
	{ name = "Yellow",              id = 42 },
	{ name = "Lime Green",          id = 55 },
	{ name = "Green",               id = 128 },
	{ name = "Forest Green",        id = 151 },
	{ name = "Foliage Green",       id = 155 },
	{ name = "Olive Darb",          id = 152 },
	{ name = "Dark Earth",          id = 153 },
	{ name = "Desert Tan",          id = 154 },
	{ name = "Brushed Steel",       id = 117 },
	{ name = "Brushed Black Steel", id = 118 },
	{ name = "Brushed Aluminium",   id = 119 },
	{ name = "Pure Gold",           id = 158 },
	{ name = "Brushed Gold",        id = 159 },
	{ name = "Chrome",              id = 120 }
}

function GetColors()
	local pr, pg, pb = GetVehicleCustomPrimaryColour(carroselected)
	local sr, sg, sb = GetVehicleCustomSecondaryColour(carroselected)
	local plrcolour, whcolour = GetVehicleExtraColours(carroselected)
	local dsh = GetVehicleDashboardColour(carroselected)
	local int = GetVehicleInteriorColour(carroselected)
	local colrcostump = {}
	local colrcostumw = {}
	local colrcostumd = {}
	local colrcostumi = {}
	local ptp, colorp, nnn = GetVehicleModColor_1(carroselected)
	local pts, colors = GetVehicleModColor_2(carroselected)
	local tabelapr = { r = pr, g = pg, b = pb, tipao = ptp, crl = colorp }
	local tabelasc = { r = sr, g = sg, b = sb, tipao = pts, clr = colors }
	local pearltab = plrcolour
	local whlclrtab = whcolour
	local dshclrtab = dsh
	local intclrtab = int
	table.insert(colrcostump,
		{ type = json.encode({ tipo = "corextra", index = plrcolour }), title = Config.Translations["def"] ..
		": " .. getnameclr(plrcolour), src = "img/Default.png", })
	table.insert(colrcostumw,
		{ type = json.encode({ tipo = "corextra", index = whcolour }), title = Config.Translations["def"] ..
		": " .. getnameclr(whcolour), src = "img/Default.png", })
	table.insert(colrcostumd,
		{ type = json.encode({ tipo = "corextra", index = dsh }), title = Config.Translations["def"] ..
		": " .. getnameclr(dsh), src = "img/Default.png", })
	table.insert(colrcostumi,
		{ type = json.encode({ tipo = "corextra", index = int }), title = Config.Translations["def"] ..
		": " .. getnameclr(int), src = "img/Default.png", })
	local selectedprl = 99
	local selectedw = 99
	local selectedd = 99
	local selectedi = 99
	for k in pairs(Config.ColoursExtra) do
		local clri = Config.ColoursExtra[k]
		if clri.id == plrcolour then
			selectedprl = k
		elseif clri.id == whcolour then
			selectedw = k
		elseif clri.id == dsh then
			selectedd = k
		elseif clri.id == int then
			selectedi = k
		end
		table.insert(colrcostump,
			{ type = json.encode({ tipo = "corextra", index = clri.id }), title = clri.name, src = "img/pearlescent.png", })
		table.insert(colrcostumw,
			{ type = json.encode({ tipo = "corextra", index = clri.id }), title = clri.name, src = "img/pearlescent.png", })
		table.insert(colrcostumd,
			{ type = json.encode({ tipo = "corextra", index = clri.id }), title = clri.name, src = "img/pearlescent.png", })
		table.insert(colrcostumi,
			{ type = json.encode({ tipo = "corextra", index = clri.id }), title = clri.name, src = "img/pearlescent.png", })
	end
	local menu = {
		type = json.encode({ tipo = "color" }),
		title = Config.Translations["vehclr"],
		src = "img/color.png",
		subMenuTitle = Config.Translations["change"] .. " " .. Config.Translations["vehstyle"],
		subMenuSelected = 99,
		subMenu = {
			{
				type = json.encode({ tipo = "prim-color" }),
				title = Config.Translations["prima"],
				src = "img/color.png",
				subSubMenuSelected = 99,
				subSubMenuTitle = Config.Translations["change"] .. " " .. Config.Translations["primecolor"],
				subSubMenu = {
					{
						type = json.encode({ tipo = "defaultprgb", index = tabelapr }),
						title = Config.Translations["def"],
						src = "img/Default.png",
					},
					{
						type = json.encode({ tipo = "corrgbp" }),
						title = Config.Translations["rgb"],
						src = "img/rgb.png",
						colorpicker = true,
						currentColor = { r = pr, g = pg, b = pb },
					},
					{
						type = json.encode({ tipo = "cortipop", index = 0 }),
						title = Config.Translations["normal"],
						src = "img/pearlescent.png",
					},
					{
						type = json.encode({ tipo = "cortipop", index = 1 }),
						title = Config.Translations["metallic"],
						src = "img/pearlescent.png",
					},
					--[[{
						type = json.encode({tipo = "cortipop",index = 2}),
						title = Config.Translations["pearl"],
						src = "img/pearlescent.png",
					},--]]
					{
						type = json.encode({ tipo = "cortipop", index = 3 }),
						title = Config.Translations["matte"],
						src = "img/pearlescent.png",
					},
					{
						type = json.encode({ tipo = "cortipop", index = 4 }),
						title = Config.Translations["metal"],
						src = "img/pearlescent.png",
					},
					{
						type = json.encode({ tipo = "cortipop", index = 5 }),
						title = Config.Translations["chrome"],
						src = "img/pearlescent.png",
					},
				},
			},
			{
				type = json.encode({ tipo = "sec-color" }),
				title = Config.Translations["sec"],
				src = "img/color.png",
				subSubMenuSelected = 99,
				subSubMenuTitle = Config.Translations["change"] .. " " .. Config.Translations["seccolor"],
				subSubMenu = {
					{
						type = json.encode({ tipo = "defaultsrgb", index = tabelasc }),
						title = Config.Translations["def"],
						src = "img/Default.png",
					},
					{
						type = json.encode({ tipo = "corrgbs" }),
						title = Config.Translations["rgb"],
						src = "img/rgb.png",
						colorpicker = true,
						currentColor = { r = sr, g = sg, b = sb },
					},
					{
						type = json.encode({ tipo = "cortipos", index = 0 }),
						title = Config.Translations["normal"],
						src = "img/pearlescent.png",
					},
					{
						type = json.encode({ tipo = "cortipos", index = 1 }),
						title = Config.Translations["metallic"],
						src = "img/pearlescent.png",
					},
					--[[{
						type = json.encode({tipo = "cortipos",index = 2}),
						title = Config.Translations["pearl"],
						src = "img/pearlescent.png",
					},--]]
					{
						type = json.encode({ tipo = "cortipos", index = 3 }),
						title = Config.Translations["matte"],
						src = "img/pearlescent.png",
					},
					{
						type = json.encode({ tipo = "cortipos", index = 4 }),
						title = Config.Translations["metal"],
						src = "img/pearlescent.png",
					},
					{
						type = json.encode({ tipo = "cortipos", index = 5 }),
						title = Config.Translations["chrome"],
						src = "img/pearlescent.png",
					},
				},
			},
			{
				type = json.encode({ tipo = "pearlescent" }),
				title = Config.Translations["pearls"],
				src = "img/pearlescent.png",
				subSubMenuSelected = selectedprl,
				subSubMenuTitle = Config.Translations["change"] .. " " .. Config.Translations["pearls"],
				subSubMenu = colrcostump
			},
			{
				type = json.encode({ tipo = "wheel-colour" }),
				title = Config.Translations["whelclor"],
				src = "img/TyresFront.png",
				subSubMenuSelected = selectedw,
				subSubMenuTitle = Config.Translations["change"] .. " " .. Config.Translations["whelclor"],
				subSubMenu = colrcostumw
			},
			{
				type = json.encode({ tipo = "dash-colour" }),
				title = Config.Translations["dashclr"],
				src = "img/Dashboard.png",
				subSubMenuSelected = selectedd,
				subSubMenuTitle = Config.Translations["change"] .. " " .. Config.Translations["dashclr"],
				subSubMenu = colrcostumd
			},
			{
				type = json.encode({ tipo = "int-colour" }),
				title = Config.Translations["intclr"],
				src = "img/Interior.png",
				subSubMenuSelected = selectedi,
				subSubMenuTitle = Config.Translations["change"] .. " " .. Config.Translations["intclr"],
				subSubMenu = colrcostumi
			}
		},
	}
	return menu, tabelapr, tabelasc, pearltab, whlclrtab, dshclrtab, intclrtab
end

function GetTyresOptions()
	local submenus = {}
	local costumselec = 999
	if GetVehicleModVariation(carroselected, 23) then
		costumselec = 0
	end
	local brpoofselec = 999
	if not GetVehicleTyresCanBurst(carroselected) then
		brpoofselec = 0
	end
	--[[table.insert(submenus, {type = json.encode({tipo = "costum",index = 0}),title = "Costum", src = "img/costum.png", subSubMenuSelected = costumselec, subSubMenu = {{
			type = json.encode({tipo = "costum", index = 0}),
			title = "Costum",
			src = "img/costum.png",
		}}
	})--]]
	    -- Who use this?
	table.insert(submenus,
		{
			type = json.encode({ tipo = "bproof", index = 0 }),
			title = Config.Translations["bproof"],
			src = "img/bproof.png",
			subSubMenuSelected = brpoofselec,
			subSubMenu = { {
				type = json.encode({ tipo = "bproof", index = 0 }),
				title = Config.Translations["bproof"],
				src = "img/bproof.png",
			} }
		})
	local drift = nil
	if GetGameBuildNumber() >= 2372 then
		drift = GetDriftTyresEnabled(carroselected)
		table.insert(submenus,
			{
				type = json.encode({ tipo = "drift", index = 0 }),
				title = Config.Translations["drift"],
				src = "img/drift.png",
				subSubMenuSelected = not drift,
				subSubMenu = { {
					type = json.encode({ tipo = "drift", index = 0 }),
					title = Config.Translations["drift"],
					src = "img/drift.png",
				} }
			})
	end
	local menu = {
		type = json.encode({ tipo = "tyresoptions" }),
		title = Config.Translations["toption"],
		src = "img/tyresoptions.png",
		subMenuTitle = Config.Translations["change"] .. " " .. Config.Translations["toption"],
		subMenuSelected = 999,
		subMenu = submenus
	}
	return menu,
		{ costum = GetVehicleModVariation(carroselected, 23), bproof = GetVehicleTyresCanBurst(carroselected), drift =
		drift }
end

function GetTyres(tipom)
	local numeromod = Config.TunningMods[tipom]
	local submenus = {}
	local transl = Config.Translations[tipom]
	if transl == nil then
		transl = tipom
	end
	SetVehicleMod(carroselected, 23, -1, GetVehicleModVariation(carroselected, 23))
	local tableza = {}
	for k in pairs(Config.Wheels) do
		local bool, wheel, num = isWheelType(k, numeromod)
		if bool then
			local transla = Config.Translations[k]
			if transla == nil then
				transla = k
			end
			tableza = { rodadefault = wheel, tipo = k }
			if tipom == "Tyres Front" then
				table.insert(submenus,
					{ type = json.encode({ tipo = "rodadefault", index = { tipo = k, roda = wheel, mota = 23 } }), title =
					Config.Translations["def"] .. ": " .. transla .. wheel + 1, src = "img/Default.png" })
			else
				table.insert(submenus,
					{ type = json.encode({ tipo = "rodadefault", index = { tipo = k, roda = wheel, mota = 24 } }), title =
					Config.Translations["def"] .. ": " .. transla .. wheel + 1, src = "img/Default.png" })
			end
		end
	end
	for k in pairs(Config.Wheels) do
		local podiri = false
		if tipom == "Tyres Front" then
			if k ~= "motorcycle" then
				podiri = true
			end
		else
			podiri = true
		end
		if podiri then
			local bool, wheel, num = isWheelType(k, numeromod)
			local transla = Config.Translations[k]
			if transla == nil then
				transla = k
			end
			local roda = 999
			if bool then
				roda = wheel + 1
			end
			if num >= 1 then
				table.insert(submenus,
					{ type = json.encode({ tipo = k, index = #submenus + 1 }), title = transla, src = "img/" .. k ..
					".png", subSubMenuSelected = roda - 1, subSubMenu = AddToSubMenu(k, num, numeromod) })
			end
		end
	end
	SetVehicleMod(carroselected, 23, rodaatual, GetVehicleModVariation(carroselected, 23))
	local menu = {
		type = json.encode({ tipo = tipom }),
		title = transl,
		src = "img/" .. tipom .. ".png",
		subMenuTitle = Config.Translations["change"] .. " " .. Config.Translations["vehtyres"],
		subMenuSelected = 999,
		subMenu = submenus
	}
	return menu, tableza
end

function TurboMenu()
	local turboon = IsToggleModOn(carroselected, 18)
	local numm = 999
	if turboon then
		numm = 0
	end
	local menu = {
		type = json.encode({ tipo = "turbo" }),
		title = Config.Translations["turbo"],
		src = "img/" .. "turbo.png",
		subMenuSelected = numm,
		subMenu = { { type = json.encode({ tipo = "turbo", index = 0 }), title = Config.Translations["turbo"], src = "img/turbo.png" } }
	}
	return menu
end

function HeadLight()
	local ssmenu = 99
	local xenonn = IsToggleModOn(carroselected, 22)
	local numm = 999
	if xenonn then
		xenonn = true
		numm = 0
		ssmenu = GetVehicleXenonLightsColour(carroselected) + 1
	else
		xenonn = false
	end
	local subSubMenu = {
		{
			type = json.encode({ tipo = "xcolor", index = -1 }),
			title = Config.Translations["def"],
			src = "img/Default.png",
		},
		{
			type = json.encode({ tipo = "xcolor", index = 0 }),
			title = "White",
			src = "img/pearlescent.png",
		},
		{
			type = json.encode({ tipo = "xcolor", index = 1 }),
			title = "Blue",
			src = "img/pearlescent.png",
		},
		{
			type = json.encode({ tipo = "xcolor", index = 2 }),
			title = "Electric Blue",
			src = "img/pearlescent.png",
		},
		{
			type = json.encode({ tipo = "xcolor", index = 3 }),
			title = "Mint Green",
			src = "img/pearlescent.png",
		},
		{
			type = json.encode({ tipo = "xcolor", index = 4 }),
			title = "Lime Green",
			src = "img/pearlescent.png",
		},
		{
			type = json.encode({ tipo = "xcolor", index = 5 }),
			title = "Yellow",
			src = "img/pearlescent.png",
		},
		{
			type = json.encode({ tipo = "xcolor", index = 6 }),
			title = "Golden Shower",
			src = "img/pearlescent.png",
		},
		{
			type = json.encode({ tipo = "xcolor", index = 7 }),
			title = "Orange",
			src = "img/pearlescent.png",
		},
		{
			type = json.encode({ tipo = "xcolor", index = 8 }),
			title = "Red",
			src = "img/pearlescent.png",
		},
		{
			type = json.encode({ tipo = "xcolor", index = 9 }),
			title = "Pony Pink",
			src = "img/pearlescent.png",
		},
		{
			type = json.encode({ tipo = "xcolor", index = 10 }),
			title = "Hot Pink",
			src = "img/pearlescent.png",
		},
		{
			type = json.encode({ tipo = "xcolor", index = 11 }),
			title = "Purple",
			src = "img/pearlescent.png",
		},
		{
			type = json.encode({ tipo = "xcolor", index = 12 }),
			title = "Blacklight",
			src = "img/pearlescent.png",
		},
	}
	local menu = {
		type = json.encode({ tipo = "HeadLight" }),
		title = Config.Translations["headlight"],
		src = "img/Headlights.png",
		subMenuTitle = Config.Translations["change"] .. " " .. Config.Translations["headlight"],
		subMenuSelected = numm + 1,
		subMenu = {
			{
				type = json.encode({ tipo = "xenonfault", index = ssmenu - 1, ligado = xenonn }),
				title = Config.Translations["def"],
				src = "img/Default.png",
			},
			{
				type = json.encode({ tipo = "xenon", index = -2 }),
				title = Config.Translations["xenon"],
				src = "img/Headlights.png",
			},
			{
				type = json.encode({ tipo = "xcolor" }),
				title = Config.Translations["xenonclr"],
				src = "img/pearlescent.png",
				subSubMenuSelected = ssmenu,
				subSubMenuTitle = Config.Translations["change"] .. " " .. Config.Translations["xenonclr"],
				subSubMenu = subSubMenu
			},
		},
	}
	return menu, { nmr = ssmenu - 1, ligado = xenonn }
end

function GetExtraOptions()
	local default = {}
	local submenu = { {
		type = json.encode({ tipo = "extrafault", index = "deftable" }),
		title = Config.Translations["def"],
		src = "img/Default.png",
	}, }
	for id = 0, 20, 1 do
		if DoesExtraExist(carroselected, id) then
			if IsVehicleExtraTurnedOn(carroselected, id) then
				default[id] = true
			end
			table.insert(submenu,
				{ type = json.encode({ tipo = "extra", index = id }), title = Config.Translations["extra"], src =
				"img/extra.png" })
		end
	end
	local menu = {
		type = json.encode({ tipo = "extra" }),
		title = Config.Translations["extra"],
		src = "img/" .. "extra.png",
		subMenuSelected = 99,
		subMenu = submenu
	}
	return menu, default
end

Citizen.CreateThread(function()
	Wait(1000)
	for i = 1, #Config.TunningLocations do
		local v = Config.TunningLocations[i]
		if v.blipmap then
			CreateBlip(v.coords, 'Tuning', 72, 0)
		end
	end
end)

RegisterNetEvent('TunningSystem3hu:Used')
AddEventHandler('TunningSystem3hu:Used', function(id, bool)
	Config.TunningLocations[id].used = bool
end)



function GetClosestVehicle(coords)
	local vehicles        = GetVehicles()
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end
	for _, vehicle in pairs(vehicles) do
		local vehicleCoords = GetEntityCoords(vehicle.localId)
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicle.localId
			closestDistance = distance
		end
	end
	return closestVehicle, closestDistance
end

Config.Range = 5.0

Wait(5000)

Citizen.CreateThread(function()
	SetNuiFocus(false, false)

	while true do
		local dormir = 2000
		local coords = GetEntityCoords(PlayerPedId())
		if nomidaberto == nil then
			for i = 1, #Config.TunningLocations do
				local v = Config.TunningLocations[i]
				if not v.used then
					local distance = #(coords - v.coords)
					if distance <= Config.Range + 2 then
						dormir = 500
						if distance <= Config.Range then
							dormir = 5
							DrawText3D(v.coords.x, v.coords.y, v.coords.z, "~r~E~w~ - Modify the Car")
							if IsControlJustReleased(0, 38) and IsPedInAnyVehicle(PlayerPedId(), false) then
								local veh, distance = GetClosestVehicle(v.coords)
								
								if DoesEntityExist(veh) and distance <= Config.Range then
									
									TunagensDefault = {}
									preco = 0
									while not NetworkHasControlOfEntity(veh) do
										Citizen.Wait(10)

										NetworkRequestControlOfEntity(veh)
									end
									Wait(10)
									carroselected = GetVehiclePedIsIn(PlayerPedId())
									SetVehicleEngineOn(carroselected, true, true, false)
									FreezeEntityPosition(carroselected, true)
									nomidaberto = i
									multiplier = (v.howmuchtopay) / 100
									local listado = false
									if Config.AllowVehicleExceptions then
										local vehname = GetName(carroselected)
										local mplus = Config.VehicleExceptions[vehname]
										if mplus then
											listado = true
											multiplier = multiplier + mplus
										end
									end
									if Config.PricesByClass and not listado then
										local vehclass = GetVehicleClass(carroselected)
										local mplus = Config.ClassPrices[vehclass]
										if mplus then
											multiplier = multiplier + mplus
										end
									end
									multiplier = math.floor(multiplier)
									SetVehicleModKit(veh, 0)
									local tabelainfo = ModsAvailable(veh)
									SetNuiFocus(true, true)
									focuson = true
									gameplaycam = GetRenderingCam()
									cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true, 2)
									SendNUIMessage({
										action = "updateTotal",
										text = "Total: " .. preco .. Config.Currency,
									})
									SendNUIMessage({
										action = "openMenu",
										menuTable = tabelainfo,
									})
									SendNUIMessage({
										action = "showFreeUpButton",
									})
									Citizen.CreateThread(function()
										while nomidaberto do
											Wait(2000)
											local popocords = GetEntityCoords(veh)
											local coords = GetEntityCoords(PlayerPedId())
											if not DoesEntityExist(veh) or #(popocords - v.coords) >= 10.0 or #(coords - v.coords) >= 10.0 then
												ModelCancel(veh)
												break
											end
										end
									end)
								end
							end
						end
					end
				end
			end
		end
		Wait(dormir)
	end
end)

function ModelCancel(veh)
	if DoesEntityExist(veh) then
		while not NetworkHasControlOfEntity(veh) do
			Citizen.Wait(0)

			NetworkRequestControlOfEntity(veh)
		end
		CancelEverything()
	end
	TunagensDefault = {}
	preco = 0
	FreezeEntityPosition(carroselected, false)
	SetNuiFocus(false, false)
	focuson = false
	camControl("close")
	--ResetCam()
	TriggerServerEvent("TunningSystem3hu:Used", nomidaberto)
	nomidaberto = nil
	menuatual = nil
	carroselected = nil
	SendNUIMessage({
		action = "close",
	})
end

function GetName(isveh)
	local model = GetEntityModel(isveh)
	local displaytext = GetDisplayNameFromVehicleModel(model)
	local name = displaytext
	return name
end

function AddToMenu(name, smenu, selected)
	local transla = Config.Translations[name]
	if transla == nil then
		transla = name
	end
	local addmen = {
		type = json.encode({ tipo = name }),
		title = transla,
		src = "img/" .. name .. ".png",
		subMenuTitle = Config.Translations["change"] .. " " .. transla,
		subMenuSelected = selected,
		subMenu = smenu
	}
	return addmen
end

function AddToSubMenu(name, maxn, moto, sel)
	local transla = Config.Translations[name]
	if transla == nil then
		transla = name
	end
	local submenu = {}
	local somar = 0
	if sel then
		somar = 1
		submenu[1] = {
			type = json.encode({ tipo = name, index = sel, moto = moto }),
			title = Config.Translations["def"] .. ": " .. sel,
			src = "img/Default.png",
		}
	end
	local lel = 0
	if moto then
		lel = 1
	end
	for i = 1, maxn do
		submenu[i + somar] = {
			type = json.encode({ tipo = name, index = i - lel, moto = moto }),
			title = transla .. " " .. i,
			src = "img/" .. name .. ".png",
		}
	end
	return submenu
end

function isWheelType(type, numeromod)
	local types = Config.Wheels[type]
	local bool = false
	local wheel = 0
	local num = 0
	local wtype = GetVehicleWheelType(carroselected)
	if wtype == types then
		bool = true
		if numeromod == 23 then
			wheel = rodaatual
		else
			wheel = rodaatual2
		end
	end
	SetVehicleWheelType(carroselected, types)
	num = GetNumVehicleMods(carroselected, numeromod)
	SetVehicleWheelType(carroselected, wtype)
	return bool, wheel, num
end

function ModsAvailable(carro)
	local mods = {}
	TunagensDefault = {}
	preco = 0
	rodaatual = GetVehicleMod(carro, 23)
	SetVehicleMod(carro, 23, rodaatual, GetVehicleModVariation(carro, 23))
	rodaatual2 = GetVehicleMod(carro, 24)
	SetVehicleMod(carro, 24, rodaatual2, GetVehicleModVariation(carro, 24))
	mods[#mods + 1], corprinc, corsec, pearltab, whlclrtab, dshclrtab, intclrtab = GetColors()
	TunagensDefault["corprinc"] = corprinc
	TunagensDefault["corsec"] = corsec
	TunagensDefault["pearltab"] = pearltab
	TunagensDefault["whlclrtab"] = whlclrtab
	TunagensDefault["dshclrtab"] = dshclrtab
	TunagensDefault["intclrtab"] = intclrtab
	mods[#mods + 1], neonstable = GetNeons()
	TunagensDefault["neons"] = neonstable
	mods[#mods + 1], smoketable = GetSmoke()
	TunagensDefault["smoke"] = smoketable
	local windssting = GetVehicleWindowTint(carro)
	mods[#mods + 1] = AddToMenu("windtint", AddToSubMenu("windtint", 6, false, windssting + 1), windssting + 1)
	TunagensDefault["windtint"] = windssting + 1
	mods[#mods + 1] = AddToMenu("plate", AddToSubMenu("plate", 6, false, GetVehicleNumberPlateTextIndex(carro) + 1),
		GetVehicleNumberPlateTextIndex(carro) + 1)
	TunagensDefault["plate"] = GetVehicleNumberPlateTextIndex(carro) + 1
	mods[#mods + 1] = TurboMenu()
	TunagensDefault["turbo"] = IsToggleModOn(carro, 18)
	mods[#mods + 1], headlighttable = HeadLight()
	TunagensDefault["headlight"] = headlighttable
	mods[#mods + 1], tyrestable = GetTyres("Tyres Front")
	TunagensDefault["tyres"] = tyrestable
	if GetVehicleClass(carroselected) == 8 then
		SetVehicleWheelType(carroselected, 6)
		--mods[#mods+1],tyrestable2 = GetTyres("Tyres Back")
		TunagensDefault["tyresb"] = tyrestable2
	end
	mods[#mods + 1], tyresotable = GetTyresOptions()
	TunagensDefault["tyreso"] = tyresotable
	local extrasss, extratable = GetExtraOptions()
	if next(extrasss.subMenu, 1) then
		mods[#mods + 1] = extrasss
		TunagensDefault["extra"] = extratable
	end
	local livery = true
	for i = 0, 52 do
		for k, v in pairs(Config.TunningMods) do
			if v == i then
				if GetNumVehicleMods(carro, Config.TunningMods[k]) >= 1 and k ~= "Tyres Front" and k ~= "Tyres Back" and k ~= "Turbo" then
					local merdaselected = 999
					local vehmod = GetVehicleMod(carro, Config.TunningMods[k]) + 1
					TunagensDefault[k] = vehmod - 1
					if vehmod >= 0 then
						merdaselected = vehmod
					end
					mods[#mods + 1] = AddToMenu(k,
						AddToSubMenu(k, GetNumVehicleMods(carro, Config.TunningMods[k]) + 1, false, merdaselected + 1),
						merdaselected + 1)
					if k == "Livery" then
						livery = false
					end
				end
			end
		end
	end
	if livery then
		livery = GetVehicleLiveryCount(carro)
		if livery > -1 then
			local merdaselected = 999
			local vehmod = GetVehicleLivery(carro)
			TunagensDefault["Livery2"] = vehmod
			if vehmod >= 0 then
				merdaselected = vehmod
			end
			mods[#mods + 1] = AddToMenu("Livery", AddToSubMenu("Livery2", livery, false, merdaselected + 1),
				merdaselected + 1)
		end
	end
	return mods
end

function getnameclr(id)
	local retornar = id
	for k in pairs(Config.ColoursExtra) do
		local clri = Config.ColoursExtra[k]
		if clri.id == id then
			retornar = clri.name
		end
	end
	return retornar
end

function AplicarMod(mod, index)
	local modindex = Config.TunningMods[mod]
	if modindex and mod ~= "Tyres Front" and mod ~= "Tyres Back" and mod ~= "Turbo" and mod ~= "Xenon" then
		local antigo = GetVehicleMod(carroselected, Config.TunningMods[mod])
		if modindex == 39 or modindex == 40 or modindex == 41 then
			SetVehicleDoorOpen(carroselected, 4, false, false)
		elseif modindex == 37 or modindex == 38 or modindex == 31 then
			SetVehicleDoorOpen(carroselected, 5, false, false)
			SetVehicleDoorOpen(carroselected, 0, false, false)
			SetVehicleDoorOpen(carroselected, 1, false, false)
		end
		SetVehicleMod(carroselected, modindex, index, false)
		if mod == "Horn" then
			StartVehicleHorn(carroselected, 5000, GetHashKey("HELDDDOWN"), false)
			Citizen.CreateThread(function()
				local tempo = 0
				while tempo <= 500 do
					tempo = tempo + 1
					SetControlNormal(0, 86, 1.0)
					Wait(0)
				end
			end)
		end
		AddMoneyDefault(mod, index, antigo)
	elseif mod == "neonsc" then
		index = index + 2
		local neonsligado = false
		for i = 0, 3 do
			if IsVehicleNeonLightEnabled(carroselected, i) then
				neonsligado = true
			end
		end
		local wht = false
		if index >= 1 then
			wht = true
		end
		AddMoneyNotDefault(TunagensDefault["neons"].ligado, Config.TunningPrices["neons"], wht, neonsligado)
		for i = 0, 3 do
			SetVehicleNeonLightEnabled(carroselected, i, index)
		end
		SendNUIMessage({
			action = "updateTotal",
			text = "Total: " .. preco .. Config.Currency,
		})
		if preco < 0 then
			ModelCancel(veh)
		end
		index = index - 2
	elseif mod == "turbo" then
		local costum = true
		if IsToggleModOn(carroselected, 18) then
			costum = false
		end
		AddMoneyNotDefault(TunagensDefault["turbo"], Config.TunningPrices["turbo"], costum,
			IsToggleModOn(carroselected, 18))
		ToggleVehicleMod(carroselected, 18, costum)
	elseif mod == "xenon" then
		local costum = true
		local wut = false
		if IsToggleModOn(carroselected, 22) then
			wut = true
			costum = false
		end
		AddMoneyNotDefault(TunagensDefault["headlight"].ligado, Config.TunningPrices["xenon"], costum, wut)
		ToggleVehicleMod(carroselected, 22, costum)
	elseif mod == "windtint" then
		local antigo = GetVehicleWindowTint(carroselected)
		AddMoneyNotDefault(TunagensDefault[mod] - 2, Config.TunningPrices[mod], index, antigo - 1)
		SetVehicleWindowTint(carroselected, index + 1)
	elseif mod == "plate" then
		local antigo = GetVehicleNumberPlateTextIndex(carroselected)
		AddMoneyNotDefault(TunagensDefault[mod] - 2, Config.TunningPrices[mod], index, antigo - 1)
		SetVehicleNumberPlateTextIndex(carroselected, index + 1)
	elseif mod == "extra" then
		index = index + 2
		local jatava = IsVehicleExtraTurnedOn(carroselected, index)
		local aplicar = 0
		local wht = true
		local wht2
		if jatava then
			aplicar = 1
			wht = nil
			wht2 = true
		end
		SetVehicleExtra(carroselected, index, aplicar)
		if jatava ~= IsVehicleExtraTurnedOn(carroselected, index) then
			AddMoneyNotDefault(TunagensDefault["extra"][index], Config.TunningPrices["extra"], wht, wht2)
		end
	elseif mod == "Livery2" then
		local antigo = GetVehicleLivery(carroselected)
		SetVehicleLivery(carroselected, index + 1)
		AddMoneyDefault("Livery2", index + 1, antigo)
	end
end

local menuatual

function AddMoneyDefault(mod, index, antigo)
	if index == TunagensDefault[mod] and index ~= antigo then
		preco = preco - (Config.TunningPrices[mod].base + (antigo + 1) * Config.TunningPrices[mod].bylevel) * multiplier
	elseif antigo ~= index then
		if antigo ~= TunagensDefault[mod] then
			preco = preco - (Config.TunningPrices[mod].base + (antigo + 1) * Config.TunningPrices[mod].bylevel) *
			multiplier
			preco = preco + (Config.TunningPrices[mod].base + (index + 1) * Config.TunningPrices[mod].bylevel) *
			multiplier
		else
			preco = preco + (Config.TunningPrices[mod].base + (index + 1) * Config.TunningPrices[mod].bylevel) *
			multiplier
		end
	end
	SendNUIMessage({
		action = "updateTotal",
		text = "Total: " .. preco .. Config.Currency,
	})
	if preco < 0 then
		ModelCancel(veh)
	end
end

function AddMoneyNotDefault(default, price, index, antigo, teste, teste2)
	local somar1 = 0
	local somar2 = 0
	if type(antigo) == "number" then
		somar1 = (antigo + 1)
	end
	if type(index) == "number" then
		somar2 = (index + 1)
	end
	if teste2 then
		somar1 = (teste2 + 1)
	end
	if teste then
		somar2 = (teste + 1)
	end
	if index == default and index ~= antigo then
		preco = preco - (price.base + (somar1) * price.bylevel) * multiplier
	elseif antigo ~= index then
		if antigo ~= default then
			preco = preco - (price.base + (somar1) * price.bylevel) * multiplier
			preco = preco + (price.base + (somar2) * price.bylevel) * multiplier
		else
			preco = preco + (price.base + (somar2) * price.bylevel) * multiplier
		end
	end
	SendNUIMessage({
		action = "updateTotal",
		text = "Total: " .. preco .. Config.Currency,
	})
	if preco < 0 then
		ModelCancel(veh)
	end
end

function AddMoneyCorRGB(cor, tipo)
	local rantigo, gantigo, bantigo
	local cenas
	if tipo == "PrimaryRGBColor" then
		cenas = TunagensDefault["corprinc"]
		rantigo, gantigo, bantigo = GetVehicleCustomPrimaryColour(carroselected)
	elseif tipo == "SecondaryRGBColor" then
		cenas = TunagensDefault["corsec"]
		rantigo, gantigo, bantigo = GetVehicleCustomSecondaryColour(carroselected)
	elseif tipo == "NeonsRGBColor" then
		cenas = TunagensDefault["neons"]
		rantigo, gantigo, bantigo = GetVehicleNeonLightsColour(carroselected)
	elseif tipo == "SmokeRGBColor" then
		cenas = TunagensDefault["smoke"]
		rantigo, gantigo, bantigo = GetVehicleTyreSmokeColor(carroselected)
	end
	local if1 = (cenas.r == cor.r and cenas.g == cor.g and cenas.b == cor.b)
	local if2 = (rantigo ~= cor.r or gantigo ~= cor.g or bantigo ~= cor.b)
	local if3 = (rantigo ~= cenas.r or gantigo ~= cenas.g or bantigo ~= cenas.b)
	if if1 and if2 then
		preco = preco - (Config.TunningPrices[tipo].base) * multiplier
	elseif if2 then
		if if3 then
			preco = preco - (Config.TunningPrices[tipo].base) * multiplier
			preco = preco + (Config.TunningPrices[tipo].base) * multiplier
		else
			preco = preco + (Config.TunningPrices[tipo].base) * multiplier
		end
	end

	SendNUIMessage({
		action = "updateTotal",
		text = "Total: " .. preco .. Config.Currency,
	})
	if preco < 0 then
		ModelCancel(veh)
	end
end

function AddMoneyTyres(mota, roda, tipo, antigonum)
	local default = TunagensDefault["tyres"]
	if mota == 24 then
		default = TunagensDefault["tyresb"]
	end
	local antigo
	for k in pairs(Config.Wheels) do
		local bool, wheel, num = isWheelType(k, mota)
		if bool then
			antigo = { tipo = k, rodadefault = antigonum + 1 }
		end
	end
	local def = (default.tipo .. " " .. default.rodadefault + 1)
	local index = tipo .. " " .. roda + 1
	local ant = antigo.tipo .. " " .. antigo.rodadefault
	if index == def and index ~= ant then
		local price = Config.TunningPrices[antigo.tipo]
		preco = preco - (price.base + (antigo.rodadefault - 1) * price.bylevel) * multiplier
	elseif index ~= ant then
		if ant ~= def then
			local price = Config.TunningPrices[antigo.tipo]
			preco = preco - (price.base + (antigo.rodadefault - 1) * price.bylevel) * multiplier
			price = Config.TunningPrices[tipo]
			preco = preco + (price.base + (roda) * price.bylevel) * multiplier
		else
			local price = Config.TunningPrices[tipo]
			preco = preco + (price.base + (roda) * price.bylevel) * multiplier
		end
	end
	SendNUIMessage({
		action = "updateTotal",
		text = "Total: " .. preco .. Config.Currency,
	})
	if preco < 0 then
		ModelCancel(veh)
	end
end

local chegoupago = false
RegisterNUICallback("action", function(data)
	SetVehicleDoorsShut(carroselected, false)
	if data.action == "openSubMenu" then -- aqui e quando o gajo clica para abrir
		local tab = json.decode(data.type)
		menuatual = tab.tipo
		if tab.tipo == "HeadLight" then
			SetVehicleLights(carroselected, 2)
		end
		camControl(tab.tipo)
		PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	elseif data.action == "subMenuAction" then -- aqui é quando o gajo clica para que nivel quer tunar
		local tab = json.decode(data.type)
		menuatual = tab.tipo
		if menuatual == "rodadefault" then
			AddMoneyTyres(tab.index.mota, tab.index.roda, tab.index.tipo, GetVehicleMod(carroselected, tab.index.mota))
			SetVehicleWheelType(carroselected, Config.Wheels[tab.index.tipo])
			SetVehicleMod(carroselected, tab.index.mota, tab.index.roda,
				GetVehicleModVariation(carroselected, tab.index.mota))
		elseif menuatual == "defaultneon" then
			AddMoneyCorRGB(tab.index, "NeonsRGBColor")
			local neonsligado = false
			for i = 0, 3 do
				if IsVehicleNeonLightEnabled(carroselected, i) then
					neonsligado = true
				end
			end
			AddMoneyNotDefault(tab.ligado, Config.TunningPrices["neons"], tab.ligado, neonsligado)
			for i = 0, 3 do
				SetVehicleNeonLightEnabled(carroselected, i, tab.ligado)
			end
			SetVehicleNeonLightsColour(carroselected, tab.index.r, tab.index.g, tab.index.b)
		elseif menuatual == "smokedefault" then
			ToggleVehicleMod(carroselected, 20, true)
			local aply = tab.index
			if tab.index.r == 0 and tab.index.g == 0 and tab.index.b == 0 then
				aply.b = 1
			end
			AddMoneyCorRGB(aply, "SmokeRGBColor")
			SetVehicleTyreSmokeColor(carroselected, aply.r, aply.g, aply.b)
		elseif menuatual == "xenonfault" then
			local wut = false
			if IsToggleModOn(carroselected, 22) then
				wut = true
			end
			AddMoneyNotDefault(TunagensDefault["headlight"].ligado, Config.TunningPrices["xenon"], tab.ligado, wut)
			ToggleVehicleMod(carroselected, 22, tab.ligado)
			if tab.index ~= 99 and tab.index ~= 98 then
				AddMoneyNotDefault(TunagensDefault["headlight"].nmr, Config.TunningPrices["xenoncolor"], tab.index,
					GetVehicleXenonLightsColour(carroselected))
				SetVehicleXenonLightsColour(carroselected, tab.index)
			end
		elseif menuatual == "extrafault" then
			local cenas = TunagensDefault["extra"]
			for id = 0, 20, 1 do
				if DoesExtraExist(carroselected, id) then
					if IsVehicleExtraTurnedOn(carroselected, id) then
						local jatava = IsVehicleExtraTurnedOn(carroselected, id)
						local wht = true
						local wht2
						if jatava then
							aplicar = 1
							wht = nil
							wht2 = true
						end
						SetVehicleExtra(carroselected, id, 1)
						if jatava ~= IsVehicleExtraTurnedOn(carroselected, id) then
							AddMoneyNotDefault(cenas[id], Config.TunningPrices["extra"], wht, wht2)
						end
					end
				end
			end
			for i = 1, #cenas do
				if DoesExtraExist(carroselected, i) then
					local aplicar = 1
					if cenas[i] then
						aplicar = 0
					end
					local jatava = IsVehicleExtraTurnedOn(carroselected, i)
					local wht = true
					local wht2
					if jatava then
						aplicar = 1
						wht = nil
						wht2 = true
					end
					SetVehicleExtra(carroselected, i, aplicar)
					if jatava ~= IsVehicleExtraTurnedOn(carroselected, i) then
						AddMoneyNotDefault(cenas[i], Config.TunningPrices["extra"], wht, wht2)
					end
				end
			end
		else
			AplicarMod(tab.tipo, tab.index - 2)
		end
		PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	elseif data.action == "opensubSubMenu" then -- aqui é quando o gajo clica para que nivel quer tunar
		local tab = json.decode(data.type)
		menuatual = tab.tipo
		camControl(tab.tipo)
		PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	elseif data.action == "subSubMenuAction" then -- aqui é quando o gajo clica para que nivel quer tunar
		local tab = json.decode(data.type)
		if tab.tipo == "cortipop" then
			local def = TunagensDefault["corprinc"].tipao
			local price = Config.TunningPrices["PrimaryColorType"]
			local ptp, colorp, nnn = GetVehicleModColor_1(carroselected)
			local rr, gg, bb = GetVehicleCustomPrimaryColour(carroselected)
			AddMoneyNotDefault(def, price, tab.index, ptp)
			SetVehicleModColor_1(carroselected, tab.index, 0, 0)
			SetVehicleCustomPrimaryColour(carroselected, rr, gg, bb)
		elseif tab.tipo == "cortipos" then
			local pts, colors = GetVehicleModColor_2(carroselected)
			local def = TunagensDefault["corsec"].tipao
			local price = Config.TunningPrices["SecondaryColorType"]
			local rr, gg, bb = GetVehicleCustomSecondaryColour(carroselected)
			AddMoneyNotDefault(def, price, tab.index, pts)
			SetVehicleModColor_2(carroselected, tab.index, 0, 0)
			SetVehicleCustomSecondaryColour(carroselected, rr, gg, bb)
		elseif tab.tipo == "defaultprgb" then
			AddMoneyCorRGB(tab.index, "PrimaryRGBColor")
			SetVehicleCustomPrimaryColour(carroselected, tab.index.r, tab.index.g, tab.index.b)
			local def = TunagensDefault["corprinc"].tipao
			local price = Config.TunningPrices["PrimaryColorType"]
			local ptp, colorp, nnn = GetVehicleModColor_1(carroselected)
			AddMoneyNotDefault(def, price, tab.index.tipao, ptp)
			SetVehicleModColor_1(carroselected, tab.index.tipao, tab.index.crl, 0)
		elseif tab.tipo == "defaultsrgb" then
			AddMoneyCorRGB(tab.index, "SecondaryRGBColor")
			SetVehicleCustomSecondaryColour(carroselected, tab.index.r, tab.index.g, tab.index.b)
			local def = TunagensDefault["corsec"].tipao
			local price = Config.TunningPrices["SecondaryColorType"]
			local pts, colors, nnn = GetVehicleModColor_2(carroselected)
			AddMoneyNotDefault(def, price, tab.index.tipao, pts)
			SetVehicleModColor_2(carroselected, tab.index.tipao, tab.index.crl, 0)
		elseif (tab.tipo == "sport" or tab.tipo == "muscle" or tab.tipo == "lowrider" or tab.tipo == "suv" or tab.tipo == "offroad" or tab.tipo == "tuner" or tab.tipo == "motorcycle" or tab.tipo == "highend" or tab.tipo == "bennys" or tab.tipo == "bespoke" or tab.tipo == "f1" or tab.tipo == "rua" or tab.tipo == "track") then
			AddMoneyTyres(tab.moto, tab.index, tab.tipo, GetVehicleMod(carroselected, tab.moto))
			SetVehicleWheelType(carroselected, Config.Wheels[tab.tipo])
			SetVehicleMod(carroselected, 23, tab.index, GetVehicleModVariation(carroselected, tab.moto))
			SetVehicleMod(carroselected, 24, tab.index, GetVehicleModVariation(carroselected, tab.moto))
		elseif tab.tipo == "costum" then
			local rodai = GetVehicleMod(carroselected, 23)
			local costum = not GetVehicleModVariation(carroselected, 23)
			local whut = GetVehicleModVariation(carroselected, 23)
			AddMoneyNotDefault(TunagensDefault["tyreso"].costum, Config.TunningPrices["costum-wheel"], costum, whut)
			SetVehicleMod(carroselected, 23, rodai, costum)
		elseif tab.tipo == "bproof" then
			local costum = 1
			if GetVehicleTyresCanBurst(carroselected) then
				costum = false
			end
			AddMoneyNotDefault(TunagensDefault["tyreso"].bproof, Config.TunningPrices["bulletproof"], costum,
				GetVehicleTyresCanBurst(carroselected))
			SetVehicleTyresCanBurst(carroselected, costum)
		elseif tab.tipo == "drift" then
			local costum = GetDriftTyresEnabled(carroselected)
			AddMoneyNotDefault(TunagensDefault["tyreso"].drift, Config.TunningPrices["drift"], not costum,
				GetDriftTyresEnabled(carroselected))
			SetDriftTyresEnabled(carroselected, not costum)
		elseif tab.tipo == "xcolor" then
			AddMoneyNotDefault(TunagensDefault["headlight"].nmr, Config.TunningPrices["xenoncolor"], tab.index,
				GetVehicleXenonLightsColour(carroselected))
			SetVehicleXenonLightsColour(carroselected, tab.index)
		elseif menuatual == "pearlescent" then
			local plrcolour, whcolour = GetVehicleExtraColours(carroselected)
			AddMoneyDefault("pearltab", tab.index, plrcolour)
			SetVehicleExtraColours(carroselected, tab.index, whcolour)
		elseif menuatual == "wheel-colour" then
			local plrcolour, whcolour = GetVehicleExtraColours(carroselected)
			AddMoneyDefault("whlclrtab", tab.index, whcolour)
			SetVehicleExtraColours(carroselected, plrcolour, tab.index)
		elseif menuatual == "dash-colour" then
			local antigito = GetVehicleDashboardColour(carroselected)
			AddMoneyDefault("dshclrtab", tab.index, antigito)
			SetVehicleDashboardColour(carroselected, tab.index)
		elseif menuatual == "int-colour" then
			local antigito = GetVehicleInteriorColour(carroselected)
			AddMoneyDefault("intclrtab", tab.index, antigito)
			SetVehicleInteriorColour(carroselected, tab.index)
		end
		PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	elseif data.action == "backToMainMenu" then -- quando clicar no butao para voltar
		PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		camControl("close")
		menuatual = nil
	elseif data.action == "changeColor" then
		local cor = data.rgb
		if menuatual == "corrgbp" then
			AddMoneyCorRGB(cor, "PrimaryRGBColor")
			SetVehicleCustomPrimaryColour(carroselected, cor.r, cor.g, cor.b)
		elseif menuatual == "corrgbs" then
			AddMoneyCorRGB(cor, "SecondaryRGBColor")
			SetVehicleCustomSecondaryColour(carroselected, cor.r, cor.g, cor.b)
		elseif menuatual == "change-neons" then
			AddMoneyCorRGB(cor, "NeonsRGBColor")
			SetVehicleNeonLightsColour(carroselected, cor.r, cor.g, cor.b)
		elseif menuatual == "smoke" then
			ToggleVehicleMod(carroselected, 20, true)
			local aply = cor
			if cor.r == 0 and cor.g == 0 and cor.b == 0 then
				aply.b = 1
			end
			AddMoneyCorRGB(aply, "SmokeRGBColor")
			SetVehicleTyreSmokeColor(carroselected, aply.r, aply.g, aply.b)
		end
	elseif data.action == "cancel" then -- quando acabar
		CancelEverything(data)
		TunagensDefault = {}
		preco = 0
		FreezeEntityPosition(carroselected, false)
		SetNuiFocus(false, false)
		focuson = false
		PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		camControl("close")
		--ResetCam()
		TriggerServerEvent("TunningSystem3hu:Used", nomidaberto)
		nomidaberto = nil
		multiplier = 1
		menuatual = nil
		carroselected = nil
	elseif data.action == "finish" then -- quando acabar
		if preco > 0 then
			TriggerServerEvent("TunningSystem3hu:PayModifications", preco, nomidaberto,
				Core.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId())))
		else
			TriggerServerEvent("TunningSystem3hu:Used", nomidaberto)
		end
		while not chegoupago and preco > 0 do
			Wait(10)
		end
		preco = 0
		chegoupago = false
		TunagensDefault = {}
		FreezeEntityPosition(carroselected, false)
		SetNuiFocus(false, false)
		focuson = false
		PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		camControl("close")
		--ResetCam()
		nomidaberto = nil
		multiplier = 1
		menuatual = nil
		carroselected = nil
	elseif data.action == "kinda" then -- quando acabar
		PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	elseif data.action == "camlivre" then -- quando acabar
		if focuson then
			camControl("close")
			SetNuiFocus(false, false)
			SendNUIMessage({
				action = "hideFreeUpButton",
			})
			focuson = false
			while nomidaberto and not focuson do
				Citizen.Wait(5)
				DisableControlAction(0, 85, true)
				if IsControlJustReleased(0, 44) and not focuson then
					focuson = true
					SendNUIMessage({
						action = "showFreeUpButton",
					})
					Wait(500)
					SetNuiFocus(true, true)
				end
			end
		end
	elseif data.action == "backTosubMainMenu" then -- quando clicar no butao para voltar
		PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	end
end)

function CancelEverything(data)
	for k, v in pairs(TunagensDefault) do
		local modindex = Config.TunningMods[k]
		local cenas = TunagensDefault[k]
		if modindex then
			SetVehicleMod(carroselected, modindex, v, false)
		elseif k == "corprinc" then
			SetVehicleCustomPrimaryColour(carroselected, cenas.r, cenas.g, cenas.b)
			SetVehicleModColor_1(carroselected, cenas.tipao, cenas.crl, 0)
		elseif k == "corsec" then
			SetVehicleCustomSecondaryColour(carroselected, cenas.r, cenas.g, cenas.b)
			SetVehicleModColor_2(carroselected, cenas.tipao, cenas.crl, 0)
		elseif k == "pearltab" then
			local plrcolour, whcolour = GetVehicleExtraColours(carroselected)
			SetVehicleExtraColours(carroselected, cenas, whcolour)
		elseif k == "whlclrtab" then
			local plrcolour, whcolour = GetVehicleExtraColours(carroselected)
			SetVehicleExtraColours(carroselected, plrcolour, cenas)
		elseif k == "dshclrtab" then
			SetVehicleDashboardColour(carroselected, cenas)
		elseif k == "intclrtab" then
			SetVehicleInteriorColour(carroselected, cenas)
		elseif k == "neons" then
			for i = 0, 3 do
				SetVehicleNeonLightEnabled(carroselected, i, cenas.ligado)
			end
			SetVehicleNeonLightsColour(carroselected, cenas.r, cenas.g, cenas.b)
		elseif k == "smoke" then
			ToggleVehicleMod(carroselected, 20, true)
			SetVehicleTyreSmokeColor(carroselected, cenas.r, cenas.g, cenas.b)
			if cenas.r == 0 and cenas.g == 0 and cenas.b == 0 then
				SetVehicleTyreSmokeColor(carroselected, 0, 0, 1)
			end
		elseif k == "windtint" then
			SetVehicleWindowTint(carroselected, cenas - 1)
		elseif k == "plate" then
			SetVehicleNumberPlateTextIndex(carroselected, cenas - 1)
		elseif k == "turbo" then
			ToggleVehicleMod(carroselected, 18, cenas)
		elseif k == "headlight" then
			ToggleVehicleMod(carroselected, 22, cenas.ligado)
			if cenas.nmr ~= 99 then
				SetVehicleXenonLightsColour(carroselected, cenas.nmr)
			end
		elseif k == "tyres" then
			SetVehicleWheelType(carroselected, Config.Wheels[cenas.tipo])
			SetVehicleMod(carroselected, 23, cenas.rodadefault, GetVehicleModVariation(carroselected, 23))
		elseif k == "tyreso" then
			local rodai = GetVehicleMod(carroselected, 23)
			SetVehicleMod(carroselected, 23, rodai, cenas.costum)
			SetVehicleTyresCanBurst(carroselected, cenas.bproof)
			if GetGameBuildNumber() >= 2372 then
				SetDriftTyresEnabled(carroselected, cenas.drift)
			end
		elseif k == "tyresb" then
			SetVehicleWheelType(carroselected, Config.Wheels[cenas.tipo])
			SetVehicleMod(carroselected, 24, cenas.rodadefault, GetVehicleModVariation(carroselected, 24))
		elseif k == "extra" then
			for id = 0, 20, 1 do
				if DoesExtraExist(carroselected, id) then
					if IsVehicleExtraTurnedOn(carroselected, id) then
						SetVehicleExtra(carroselected, id, 1)
					end
				end
			end
			for i = 1, #cenas do
				if DoesExtraExist(carroselected, i) then
					local aplicar = 1
					if cenas[i] then
						aplicar = 0
					end
					SetVehicleExtra(carroselected, i, aplicar)
				end
			end
		elseif k == "Livery2" then
			SetVehicleLivery(carroselected, v)
		end
	end
end

RegisterNetEvent('TunningSystem3hu:PayAfter')
AddEventHandler('TunningSystem3hu:PayAfter', function(pago)
	if not pago then
		CancelEverything()
	end
	chegoupago = true
	nomidaberto = nil
	SetNuiFocus(false, false)
end)

function DrawText3D(x, y, z, text, r, g, b, a)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	if r and g and b and a then
		SetTextColour(r, g, b, a)
	else
		SetTextColour(255, 255, 255, 215)
	end
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x, y, z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end

--CAM POS/STUFF, CREDITS TO OhTanoshi -- https://github.com/OhTanoshi/FLRP_Customs/

function f(n)
	return (n + 0.00001)
end

function ResetCam()
	SetCamCoord(cam, GetGameplayCamCoords())
	SetCamRot(cam, GetGameplayCamRot(2), 2)
	RenderScriptCams(0, 1, 1000, 0, 0)
	SetCamActive(gameplaycam, true)
	EnableGameplayCam(true)
	SetCamActive(cam, false)
end

function PointCamAtBone(bone, ox, oy, oz)
	SetCamActive(cam, true)
	local veh = carroselected
	local b = GetEntityBoneIndexByName(veh, bone)
	if b and b > -1 then
		local bx, by, bz = table.unpack(GetWorldPositionOfEntityBone(veh, b))
		local ox2, oy2, oz2 = table.unpack(GetOffsetFromEntityGivenWorldCoords(veh, bx, by, bz))
		local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(veh, ox2 + f(ox), oy2 + f(oy), oz2 + f(oz)))
		SetCamCoord(cam, x, y, z)
		PointCamAtCoord(cam, GetOffsetFromEntityInWorldCoords(veh, 0, oy2, oz2))
		RenderScriptCams(1, 1, 1000, 0, 0)
	end
end

function camControl(c)
	Wait(50)
	if c == "Front Bumper" or c == "Grill" or c == "Vanity Plate" or c == "Aerial" then
		MoveVehCam('front', -0.6, 1.5, 0.4)
	elseif c == "color" or c == "Livery" or c == "Livery2" then
		MoveVehCam('middle', -2.6, 2.5, 1.4)
	elseif c == "Rear Bumper" or c == "Exhaust" or c == "Fuel Tank" then
		MoveVehCam('back', -0.5, -1.5, 0.2)
	elseif c == "Hood" then
		MoveVehCam('front-top', -0.5, 1.3, 1.0)
	elseif c == "Roof" or c == "Trim B" then
		MoveVehCam('middle', -2.2, 2, 1.5)
	elseif c == "Window" or c == "windtint" then
		MoveVehCam('middle', -2.0, 2, 0.5)
	elseif c == "HeadLight" or c == "Arch Cover" then
		MoveVehCam('front', -0.6, 1.3, 0.6)
	elseif c == "Plate Holder" or c == "Plaque" or c == "Trunk" or c == "Hydraulic" or c == "plate" then
		MoveVehCam('back', 0, -1, 0.2)
	elseif c == "Engine Block" or c == "Air Filter" or c == "Strut" then
		MoveVehCam('front', 0.0, 1.0, 2.0)
	elseif c == "Skirt" then
		MoveVehCam('left', -1.8, -1.3, 0.7)
	elseif c == "Spoiler" or c == "Left Fender" or c == "Right Fender" then
		MoveVehCam('back', 1.5, -1.6, 1.3)
	elseif c == "Tyres Back" or c == "smoke" then
		PointCamAtBone("wheel_lr", -1.4, 0, 0.3)
	elseif c == "Tyres Front" or c == "tyresoptions" then
		PointCamAtBone("wheel_lf", -1.4, 0, 0.3)
	elseif c == "neons" or c == "Suspension" or c == "Side Skirt" then
		PointCamAtBone("neon_l", -2.0, 2.0, 0.4)
	elseif c == "Interior" or c == "Ornaments" or c == "Dashboard" or c == "Seats" or c == "Roll Cage" or c == "Trim A" then
		MoveVehCam('back-top', 0.0, 5.0, 0.7)
	elseif c == "Steering Wheel" or c == "Dial" or c == "Shifter Leaver" then
		MoveVehCam('back-top', 0.0, 4.0, 0.7)
	elseif c == "close" then
		SetCamCoord(cam, GetGameplayCamCoords())
		SetCamRot(cam, GetGameplayCamRot(2), 2)
		RenderScriptCams(0, 1, 1000, 0, 0)
		SetCamActive(gameplaycam, true)
		EnableGameplayCam(true)
	end
end

function MoveVehCam(pos, x, y, z)
	if carroselected then
		SetCamActive(cam, true)
		local veh = carroselected
		local vx, vy, vz = table.unpack(GetEntityCoords(veh))
		local d = GetModelDimensions(GetEntityModel(veh))
		local length, width, height = d.y * -2, d.x * -2, d.z * -2
		local ox, oy, oz
		if pos == 'front' then
			ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), (length / 2) + f(y), f(z)))
		elseif pos == "front-top" then
			ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), (length / 2) + f(y), (height) + f(z)))
		elseif pos == "back" then
			ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), -(length / 2) + f(y), f(z)))
		elseif pos == "back-top" then
			ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), -(length / 2) + f(y), (height / 2) +
			f(z)))
		elseif pos == "left" then
			ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(veh, -(width / 2) + f(x), f(y), f(z)))
		elseif pos == "right" then
			ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(veh, (width / 2) + f(x), f(y), f(z)))
		elseif pos == "middle" then
			ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), f(y), (height / 2) + f(z)))
		end
		SetCamCoord(cam, ox, oy, oz)
		PointCamAtCoord(cam, GetOffsetFromEntityInWorldCoords(veh, 0, 0, f(0)))
		RenderScriptCams(1, 1, 1000, 0, 0)
	end
end
