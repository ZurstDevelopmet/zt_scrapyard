Config = {}

Config.Locale = 'cs'
Config.UseOxInventory = true
Config.RemoveVehicleAfterScrap = true
Config.MinimumPolice = 0

Config.Scrapyards = {
    {
        name = "Scrapyard Sandy Shores",
        coords = vector3(2352.18, 3133.5, 48.21),
        blip = {
            enabled = true,
            sprite = 380,
            color = 14,
            scale = 0.8,
            label = "<font face='Oswald'>Šrotovací dvůr</font>"
        },
        npc = {
            enabled = true,
            model = "s_m_y_construct_01",
            coords = vector4(2352.18, 3133.5, 48.21, 240.0),
            scenario = "WORLD_HUMAN_CLIPBOARD"
        },
        scrapZone = {
            coords = vector3(2358.5, 3130.2, 48.21),
            radius = 15.0,
            debug = false
        }
    },
    {
        name = "Scrapyard La Mesa",
        coords = vector3(1147.92, -1641.1, 37.07),
        blip = {
            enabled = true,
            sprite = 380,
            color = 14,
            scale = 0.8,
            label = "<font face='Oswald'>Šrotovací dvůr</font>"
        },
        npc = {
            enabled = true,
            model = "s_m_y_construct_02",
            coords = vector4(1147.92, -1641.1, 37.07, 180.0),
            scenario = "WORLD_HUMAN_SMOKING"
        },
        scrapZone = {
            coords = vector3(1152.5, -1645.8, 37.07),
            radius = 12.0,
            debug = false
        }
    }
}

Config.VehicleParts = {
    {
        name = "door_front_left",
        label = "Levé přední dveře",
        bone = "door_dside_f",
        offset = vector3(0.0, 0.0, 0.0),
        icon = "fas fa-door-open",
        duration = 8000, -- ms
        animation = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flag = 16
        },
        rewards = {
            {item = "scrap_metal", min = 2, max = 5},
            {item = "scrap_plastic", min = 1, max = 3}
        },
        requiredItem = "weapon_wrench",
        removeRequiredItem = false
    },
    {
        name = "door_front_right",
        label = "Pravé přední dveře",
        bone = "door_pside_f",
        offset = vector3(0.0, 0.0, 0.0),
        icon = "fas fa-door-open",
        duration = 8000,
        animation = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flag = 16
        },
        rewards = {
            {item = "scrap_metal", min = 2, max = 5},
            {item = "scrap_plastic", min = 1, max = 3}
        },
        requiredItem = "weapon_wrench",
        removeRequiredItem = false
    },
    {
        name = "door_rear_left",
        label = "Levé zadní dveře",
        bone = "door_dside_r",
        offset = vector3(0.0, 0.0, 0.0),
        icon = "fas fa-door-open",
        duration = 8000,
        animation = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flag = 16
        },
        rewards = {
            {item = "scrap_metal", min = 2, max = 5},
            {item = "scrap_plastic", min = 1, max = 3}
        },
        requiredItem = "weapon_wrench",
        removeRequiredItem = false
    },
    {
        name = "door_rear_right",
        label = "Pravé zadní dveře",
        bone = "door_pside_r",
        offset = vector3(0.0, 0.0, 0.0),
        icon = "fas fa-door-open",
        duration = 8000,
        animation = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flag = 16
        },
        rewards = {
            {item = "scrap_metal", min = 2, max = 5},
            {item = "scrap_plastic", min = 1, max = 3}
        },
        requiredItem = "weapon_wrench",
        removeRequiredItem = false
    },
    {
        name = "hood",
        label = "Kapota",
        bone = "bonnet",
        offset = vector3(0.0, 0.0, 0.0),
        icon = "fas fa-car",
        duration = 10000,
        animation = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flag = 16
        },
        rewards = {
            {item = "scrap_metal", min = 3, max = 7},
            {item = "scrap_aluminum", min = 2, max = 4}
        },
        requiredItem = "weapon_wrench",
        removeRequiredItem = false
    },
    {
        name = "trunk",
        label = "Kufr",
        bone = "boot",
        offset = vector3(0.0, 0.0, 0.0),
        icon = "fas fa-box-open",
        duration = 10000,
        animation = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flag = 16
        },
        rewards = {
            {item = "scrap_metal", min = 3, max = 7},
            {item = "scrap_plastic", min = 2, max = 4}
        },
        requiredItem = "weapon_wrench",
        removeRequiredItem = false
    },
    {
        name = "wheel_front_left",
        label = "Levé přední kolo",
        bone = "wheel_lf",
        offset = vector3(0.0, 0.0, 0.0),
        icon = "fas fa-circle",
        duration = 6000,
        animation = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flag = 16
        },
        rewards = {
            {item = "scrap_rubber", min = 2, max = 4},
            {item = "scrap_metal", min = 1, max = 2}
        },
        requiredItem = "weapon_wrench",
        removeRequiredItem = false
    },
    {
        name = "wheel_front_right",
        label = "Pravé přední kolo",
        bone = "wheel_rf",
        offset = vector3(0.0, 0.0, 0.0),
        icon = "fas fa-circle",
        duration = 6000,
        animation = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flag = 16
        },
        rewards = {
            {item = "scrap_rubber", min = 2, max = 4},
            {item = "scrap_metal", min = 1, max = 2}
        },
        requiredItem = "weapon_wrench",
        removeRequiredItem = false
    },
    {
        name = "wheel_rear_left",
        label = "Levé zadní kolo",
        bone = "wheel_lr",
        offset = vector3(0.0, 0.0, 0.0),
        icon = "fas fa-circle",
        duration = 6000,
        animation = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flag = 16
        },
        rewards = {
            {item = "scrap_rubber", min = 2, max = 4},
            {item = "scrap_metal", min = 1, max = 2}
        },
        requiredItem = "weapon_wrench",
        removeRequiredItem = false
    },
    {
        name = "wheel_rear_right",
        label = "Pravé zadní kolo",
        bone = "wheel_rr",
        offset = vector3(0.0, 0.0, 0.0),
        icon = "fas fa-circle",
        duration = 6000,
        animation = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flag = 16
        },
        rewards = {
            {item = "scrap_rubber", min = 2, max = 4},
            {item = "scrap_metal", min = 1, max = 2}
        },
        requiredItem = "weapon_wrench",
        removeRequiredItem = false
    },
    {
        name = "engine",
        label = "Motor",
        bone = "engine",
        offset = vector3(0.0, 0.0, 0.0),
        icon = "fas fa-cog",
        duration = 15000,
        animation = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flag = 16
        },
        rewards = {
            {item = "scrap_metal", min = 5, max = 10},
            {item = "scrap_copper", min = 3, max = 6},
            {item = "scrap_aluminum", min = 2, max = 5}
        },
        requiredItem = "advanced_toolkit",
        removeRequiredItem = false
    }
}

Config.BlacklistedVehicles = {
    "police",
    "police2",
    "police3",
    "police4",
    "policeb",
    "policet",
    "sheriff",
    "sheriff2",
    "ambulance",
    "firetruk"
}

Config.WhitelistedVehicles = {
    -- "adder",
    -- "zentorno"
}

Config.CompleteScrapBonus = {
    enabled = true,
    rewards = {
        {item = "scrap_metal", min = 10, max = 20},
        {item = "money", min = 500, max = 1500}
    }
}
