factions = {
    ['Politia Romana'] = {
        name = 'Politia Romana',
        id = 1,
        type = 'lege',
        coords = {
            main = vec4(1833.3096923828, 3673.0703125, 34.32608795166, 320.47509765625),
            vehicleArea = vec4(1818.7408447266, 3672.5854492188, 34.211933135986, 26.925901412964),
            armory = vec4(1837.8044433594, 3681.2270507813, 38.929302215576, 0),
            helicopter = vec4(1833.5469970703, 3668.9338378906, 38.930561065674, 205.06147766113),
        },
        blipName = 'Police HQ',
        blip = 60,
        color = "^4",
        blipColor = 3,
        ranks = {
            [1] = {
                id = 1,
                rank = 'Cadet',
                salary = 5000,
                color = '^4'
            },
            [2] = {
                id = 2,
                rank = 'Agent',
                salary = 10000,
                color = '^4'
            },
            [3] = {
                id = 3,
                rank = 'Capitan',
                salary = 20000,
                color = '^4'
            }
        },
        armory = {
            [1] = {
                model = "weapon_carbinerifle",
                name = "Carbine",
                ammoName = 'rifle_ammo',
                ammoCost = 50,
                weaponCost = 0,
                rank = 3,
            },
            [2] = {
                model = "weapon_stungun_mp",
                name = "Taser",
                ammoName = 'taser_ammo',
                weaponCost = 0,
                ammoCost = 0,
                rank = 1,
            },
            [3] = {
                model = "weapon_pistol",
                name = "Pistol",
                ammoName = 'pistol_ammo',
                weaponCost = 0,
                ammoCost = 15,
                rank = 1,
            },
            [4] = {
                model = "weapon_combatpistol",
                name = "Combat Pistol",
                ammoName = 'pistol_ammo',
                weaponCost = 0,
                ammoCost = 15,
                rank = 2,
            },
            [5] = {
                model = "weapon_pumpshotgun",
                name = "Pump Shotgun",
                ammoName = 'shotgun_ammo',
                weaponCost = 0,
                ammoCost = 60,
                rank = 3,
            },
            [6] = {
                model = "weapon_sniperrifle",
                name = "Sniper",
                weaponCost = 0,
                ammoName = 'rifle_ammo',
                ammoCost = 100,
                rank = 3,
            },
            [7] = {
                model = "weapon_heavypistol",
                name = "Heavy Pistol",
                ammoName = 'pistol_ammo',
                weaponCost = 0,
                ammoCost = 15,
                rank = 3,
            },
            [8] = {
                model = "weapon_smg",
                name = "SMG",
                ammoName = 'smg_ammo',
                weaponCost = 0,
                ammoCost = 30,
                rank = 2,
            },
            [9] = {
                model = "weapon_nightstick",
                name = "Nighstick",
                ammoName = 'nightstick',
                weaponCost = 0,
                ammoCost = 0,
                rank = 1,
            },
            [10] = {
                model = 'armour',
                name = "Armour",
                weaponCost = 500,
                ammoName = 'armour',
                ammoCost = 500,
                rank = 2,
            },
            [11] = {
                model = 'medkit',
                name = "Medkit",
                weaponCost = 300,
                ammoName = 'medkit',
                ammoCost = 300,
                rank = 1,
            },
        },
        vehicles = {
            [1] = {
                name = 'Ford Crown',
                model = 'police',
                rank = 1,
                type = 'car',
            },
            [2] = {
                name = 'Dodge Charger',
                model = 'police2',
                rank = 1,
                type = 'car',
            },

            [3] = {
                name = 'Police Bike',
                model = 'policeb',
                rank = 2,
                type = 'car',
            },
            [4] = {
                name = 'Ford Crown Unmarked',
                model = 'police',
                rank = 3,
                type = 'car',
            },
            [5] = {
                name = 'Ford Crown Sheriff',
                model = 'sheriff',
                rank = 1,
                type = 'car',
            },
            [6] = {
                name = 'GMC Sierra',
                model = 'sheriff2',
                rank = 3,
                type = 'car',
            },
            [7] = {
                name = 'Transporter',
                model = 'policet',
                rank = 1,
                type = 'car',
            },
            [8] = {
                name = 'Armored Truck',
                model = 'riot',
                rank = 2,
                type = 'car',
            },
            [9] = {
                name = 'Dodge Charger Unmarked',
                model = 'fbi',
                rank = 3,
                type = 'car',
            },
            [10] = {
                name = 'GMC Sierra Unmarked',
                model = 'fbi2',
                rank = 3,
                type = 'car',
            },
            [11] = {
                name = 'Police Maverick',
                model = 'polmav',
                rank = 3,
                type = 'heli',
            },
        }
    },
    ['SMURD'] = {
        name = 'SMURD',
        id = 2,
        type = 'ems',
        coords = {
            main = vec4(1765.5462646484, 3639.3991699219, 34.857925415039, 50.552772521973),
            vehicleArea = vec4(1763.9921875, 3623.4985351563, 34.694450378418, 154.63455200195),
            armory = vec4(1784.9593505859, 3652.8095703125, 34.852588653564, 0),
            helicopter = vec4(1713.1351318359, 3596.31640625, 35.372833251953, 201.89512634277),
        },
        blipName = 'Smurd HQ',
        blip = 61,
        color = "^1",
        blipColor = 49,
        ranks = {
            [1] = {
                id = 1,
                rank = 'Medic',
                salary = 5000,
                color = '^4'
            },
            [2] = {
                id = 2,
                rank = 'Medic Legist',
                salary = 10000,
                color = '^4'
            },
            [3] = {
                id = 3,
                rank = 'Medic Sef',
                salary = 20000,
                color = '^4'
            }
        },
        armory = {
            [1] = {
                model = "weapon_stungun_mp",
                name = "Taser",
                ammoName = 'taser_ammo',
                weaponCost = 0,
                ammoCost = 0,
                rank = 1,
            },
            [2] = {
                model = 'medkit',
                name = "Medkit",
                weaponCost = 300,
                ammoName = 'medkit',
                ammoCost = 300,
                rank = 1,
            },
        },
        vehicles = {
            [1] = {
                name = 'Ambulance',
                model = 'ambulance',
                rank = 1,
                type = 'car',
            },
            [2] = {
                name = 'Helicopter',
                model = 'polmav',
                rank = 1,
                type = 'heli',
            }
        }
    },
    ['Crips'] = {
        name = 'Crips',
        id = 3,
        type = 'mafie',
        coords = {
            main = vec4(1986.4907226563, 3053.5698242188, 47.215183258057, 278.58020019531),
            vehicleArea = vec4(1991.3510742188, 3069.7160644531, 47.035015106201, 333.08901977539),
            armory = vec4(1994.6314697266, 3046.955078125, 50.425514221191, 244.1064453125),
            helicopter = false,
        },
        blipName = 'Crips HQ',
        blip = 429,
        color = "^b",
        vehColors = {
            [1] = 80,
            [2] = 80,
        },
        blipColor = 3,
        ranks = {
            [1] = {
                id = 1,
                rank = 'Mafiot',
                salary = 0,
                color = '^b'
            },
            [2] = {
                id = 2,
                rank = 'Mafiot Sef',
                salary = 0,
                color = '^b'
            },
            [3] = {
                id = 3,
                rank = 'Mafiot Boss',
                salary = 0,
                color = '^b'
            }
        },
        armory = {
            [1] = {
                model = "weapon_pistol",
                name = "Pistol",
                ammoName = 'pistol_ammo',
                weaponCost = 5000,
                ammoCost = 15,
                rank = 1,
            },
            [2] = {
                model = 'weapon_assaultrifle',
                name = "AK47",
                weaponCost = 10000,
                ammoName = 'rifle_ammo',
                ammoCost = 10,
                rank = 1,
            },
            [3] = {
                model = 'weapon_bat',
                name = "Bata",
                weaponCost = 1000,
                ammoName = 'bat',
                ammoCost = 0,
                rank = 1,
            },
        },
        vehicles = {
            [1] = {
                name = 'Tulip M100',
                model = 'tulip2',
                rank = 1,
                type = 'car',
            },
            [2] = {
                name = 'Gargoyle',
                model = 'gargoyle',
                rank = 1,
                type = 'car',
            },
            [3] = {
                name = 'Bodhi',
                model = 'bodhi2',
                rank = 1,
                type = 'car',
            }
        }
    },
    ['Yakuza'] = {
        name = 'Yakuza',
        id = 4,
        type = 'mafie',
        coords = {
            main = vec4(2444.4877929688, 4973.1337890625, 46.810600280762, 219.97872924805),
            vehicleArea = vec4(2464.6875, 4956.3940429688, 45.09693145752, 278.94281005859),
            armory = vec4(2435.5219726563, 4965.5092773438, 42.347606658936, 243.3547668457),
            helicopter = false,
        },
        blipName = 'Yakuza HQ',
        blip = 429,
        color = "^w",
        vehColors = {
            [1] = 111,
            [2] = 111,
        },
        blipColor = 62,
        ranks = {
            [1] = {
                id = 1,
                rank = 'Mafiot',
                salary = 0,
                color = '^w'
            },
            [2] = {
                id = 2,
                rank = 'Mafiot Sef',
                salary = 0,
                color = '^w'
            },
            [3] = {
                id = 3,
                rank = 'Mafiot Boss',
                salary = 0,
                color = '^w'
            }
        },
        armory = {
            [1] = {
                model = "weapon_pistol",
                name = "Pistol",
                ammoName = 'pistol_ammo',
                weaponCost = 5000,
                ammoCost = 15,
                rank = 1,
            },
            [2] = {
                model = 'weapon_assaultrifle',
                name = "AK47",
                weaponCost = 10000,
                ammoName = 'rifle_ammo',
                ammoCost = 10,
                rank = 1,
            },
            [3] = {
                model = 'weapon_bat',
                name = "Bata",
                weaponCost = 1000,
                ammoName = 'bat',
                ammoCost = 0,
                rank = 1,
            },
        },
        vehicles = {
            [1] = {
                name = 'Tulip M100',
                model = 'tulip2',
                rank = 1,
                type = 'car',
            },
            [2] = {
                name = 'Gargoyle',
                model = 'gargoyle',
                rank = 1,
                type = 'car',
            },
            [3] = {
                name = 'Bodhi',
                model = 'bodhi2',
                rank = 1,
                type = 'car',
            }
        }
    },
    ['Bloods'] = {
        name = 'Bloods',
        id = 5,
        type = 'mafie',
        coords = {
            main = vec4(1392.7740478516, 3604.3002929688, 34.980926513672, 25.342931747437),
            vehicleArea = vec4(1382.8488769531, 3595.0600585938, 34.868877410889, 78.414421081543),
            armory = vec4(1391.9489746094, 3606.734375, 38.941921234131, 113.41767883301),
            helicopter = false,
        },
        blipName = 'Bloods HQ',
        blip = 429,
        color = "^8",
        vehColors = {
            [1] = 28,
            [2] = 28,
        },
        blipColor = 49,
        ranks = {
            [1] = {
                id = 1,
                rank = 'Mafiot',
                salary = 0,
                color = '^8'
            },
            [2] = {
                id = 2,
                rank = 'Mafiot Sef',
                salary = 0,
                color = '^8'
            },
            [3] = {
                id = 3,
                rank = 'Mafiot Boss',
                salary = 0,
                color = '^8'
            }
        },
        armory = {
            [1] = {
                model = "weapon_pistol",
                name = "Pistol",
                ammoName = 'pistol_ammo',
                weaponCost = 5000,
                ammoCost = 15,
                rank = 1,
            },
            [2] = {
                model = 'weapon_assaultrifle',
                name = "AK47",
                weaponCost = 10000,
                ammoName = 'rifle_ammo',
                ammoCost = 10,
                rank = 1,
            },
            [3] = {
                model = 'weapon_bat',
                name = "Bata",
                weaponCost = 1000,
                ammoName = 'bat',
                ammoCost = 0,
                rank = 1,
            },
        },
        vehicles = {
            [1] = {
                name = 'Tulip M100',
                model = 'tulip2',
                rank = 1,
                type = 'car',
            },
            [2] = {
                name = 'Gargoyle',
                model = 'gargoyle',
                rank = 1,
                type = 'car',
            },
            [3] = {
                name = 'Bodhi',
                model = 'bodhi2',
                rank = 1,
                type = 'car',
            }
        }
    },
}
