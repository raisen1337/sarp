factions = {
    ['Politia Romana'] = {
        name = 'Politia Romana',
        id = 1,
        coords = {
            main = vec4(1833.3096923828,3673.0703125,34.32608795166,320.47509765625),
            vehicleArea = vec4(1818.7408447266,3672.5854492188,34.211933135986,26.925901412964),
            armory = vec4(1837.8044433594,3681.2270507813,38.929302215576, 0),
            helicopter = vec4(1833.5469970703,3668.9338378906,38.930561065674,205.06147766113),
        },
        blipName = 'Police HQ',
        blip = 60,
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
                ammoCost = 50,
                rank = 3,
            },
            [2] = {
                model = "weapon_stungun_mp",
                name = "Taser",
                ammoCost = 0,
                rank = 1,
            },
            [3] = {
                model = "weapon_pistol",
                name = "Pistol",
                ammoCost = 15,
                rank = 1,
            },
            [4] = {
                model = "weapon_combatpistol",
                name = "Combat Pistol",
                ammoCost = 15,
                rank = 2,
            },
            [5] = {
                model = "weapon_pumpshotgun",
                name = "Pump Shotgun",
                ammoCost = 60,
                rank = 3,
            },
            [6] = {
                model = "weapon_sniperrifle",
                name = "Sniper",
                ammoCost = 100,
                rank = 3,
            },
            [7] = {
                model = "weapon_heavypistol",
                name = "Heavy Pistol",
                ammoCost = 15,
                rank = 3,
            },
            [8] = {
                model = "weapon_smg",
                name = "SMG",
                ammoCost = 30,
                rank = 2,
            },
            [9] = {
                model = "weapon_nightstick",
                name = "Nighstick",
                ammoCost = 0,
                rank = 1,
            },
            [10] = {
                model = 'armour',
                name = "Armour",
                ammoCost = 500,
                rank = 2,
            },
            [11] = {
                model = 'medkit',
                name = "Medkit",
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
    }
}

