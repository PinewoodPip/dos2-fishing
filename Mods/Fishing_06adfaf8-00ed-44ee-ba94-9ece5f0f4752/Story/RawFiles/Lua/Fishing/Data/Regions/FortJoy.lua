
local V = Vector.Create

local Fishing = Epip.GetFeature("Features.Fishing")

---@type Features.Fishing.Region[]
local regions = {
    {
        ID = "FJ.StartingBeach",
        LevelID = "FJ_FortJoy_Main",
        Bounds = Vector.Create(128, 410, 216, 189),
        Fish = {
            -- TODO add more
            {
                ID = "NormieShell",
                Weight = 1,
            },
            {
                ID = "BlueShell",
                Weight = 1,
            },
        },
    },
    {
        ID = "FJ.PrisonerArea",
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(83, 257, 291, 52),
        Fish = {
            -- TODO add more
            {
                ID = "Scarf",
                Weight = 1,
            },
            {
                ID = "Seaweed",
                Weight = 1,
            },
            {
                ID = "SeabedRoll",
                Weight = 0.8,
            },
        },
    },
    {
        ID = "FJ.TurtleBeach",
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(218, 416, 324, 341),
        Fish = {
            -- TODO add more
            {
                ID = "BlueShell",
                Weight = 1,
            },
            {
                ID = "BranchingCoral",
                Weight = 0.8,
            },
            {
                ID = "PearlClam",
                Weight = 0.5,
            },
            {
                ID = "Seaweed",
                Weight = 1,
            },
        },
    },
    {
        ID = "FJ.NorthCoast",
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(299, 341, 664, 220),
        Fish = {
            -- TODO add more
            {
                ID = "Scarf",
                Weight = 1,
            },
            {
                ID = "Starfish",
                Weight = 0.6,
            },
            {
                ID = "NormieShell",
                Weight = 1,
            },
            {
                ID = "SpikyConch",
                Weight = 0.8,
            },
        },
    },
    {
        ID = "FJ.SouthCoast",
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(303, 120, 591, 5),
        Fish = {
            -- TODO add more
            {
                ID = "Corncomber",
                Weight = 0.7,
            },
            {
                ID = "SeaPickle",
                Weight = 1,
            },
            {
                ID = "Seaweed",
                Weight = 1,
            },
        },
    },
    {
        ID = "FJ.AmadiaSanctuary",
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(419, 41, 434, 12),
        RequiresWater = false,
        Priority = 99,
        Fish = {
            {
                ID = "Pearl",
                Weight = 0.5,
            },
            {
                ID = "WashedPanties",
                Weight = 0.3,
            },
            {
                ID = "NonFineChina",
                Weight = 1,
            },
            {
                ID = "GoldenShell",
                Weight = 0.8,
            },
        },
    },
    {
        ID = "FJ.DragonBeach",
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(533, 209, 608, 86),
        Fish = {
            {
                ID = "CrystalCoral",
                Weight = 0.7,
            },
            {
                ID = "MoonJelly",
                Weight = 0.8,
            },
            {
                ID = "Gooseberry",
                Weight = 1,
            },
        },
    },
    {
        ID = "FJ.FortDungeons",
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(308, 597, 327, 567),
        RequiresWater = false,
        Fish = {
            {
                ID = "FishBone",
                Weight = 0.5,
            },
            {
                ID = "SpikyConch",
                Weight = 0.8,
            },
            {
                ID = "FishBone",
                Weight = 1,
            },
            {
                ID = "Socks",
                Weight = 0.6,
            },
            {
                ID = "DescentKey",
                Weight = 0.2,
            },
            {
                ID = "TorrentedSoul",
                Weight = 0.8,
            },
        },
    },
    {
        ID = "FJ.RadekaCave",
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(672, 668, 720, 581),
        RequiresWater = false,
        FishingAreas = {
            V(703, 601, 710, 634), -- River to the left when entering Radeka's area (the other side of the river is unreachable)
        },
        Fish = {
            {
                ID = "FloodRose",
                Weight = 1,
            },
            {
                ID = "Aldrovanda",
                Weight = 1,
            },
            {
                ID = "Mine",
                Weight = 0.8,
            },
            {
                ID = "TorrentedSoul",
                Weight = 0.7,
            },
            {
                ID = "Head",
                Weight = 0.6,
            },
        },
    },
    {
        ID = "FJ.FrogCave",
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(474, 580, 550, 471),
        RequiresWater = false,
        FishingAreas = {
            V(479, 522, 495, 540), -- Near large pillar towards the NPCs
            V(500, 512, 531, 518), -- North shipwreck
            V(509, 510, 539, 512), -- Also north shipwreck
            V(535, 476, 551, 501), -- East of frogs
            V(496, 469, 532, 479), -- South of frogs
            V(488, 479, 511, 483), -- South of frogs, west part of the pier
            V(489, 472, 502, 488), -- West of frogs
            V(487, 485, 494, 499), -- Northwest of frogs (north of the large walkable rock)
            V(476, 509, 484, 527), -- Near the "secret" area you have to teleport to
        },
        Fish = {
            {
                ID = "Seaweed",
                Weight = 1,
            },
            {
                ID = "Moss",
                Weight = 1,
            },
            {
                ID = "Handkerchief",
                Weight = 0.8,
            },
            {
                ID = "SharkTooth",
                Weight = 0.4,
            },
        },
    },
    {
        ID = "FJ.WithermoreCave",
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(489, 670, 499, 630),
        RequiresWater = false,
        FishingAreas = {
            V(487, 657, 491, 662), -- Waterfall
            V(497, 656, 503, 661), -- East from the bridge
            V(499, 637, 507, 654), -- East of chest
            V(490, 627, 506, 637), -- South
        },
        Fish = {
            {
                ID = "Seaweed",
                Weight = 1,
            },
            {
                ID = "SeabedRoll",
                Weight = 0.5,
            },
            {
                ID = "Socks",
                Weight = 0.4,
            },
            {
                ID = "TorrentedSoul",
                Weight = 0.1,
            },
            {
                ID = "Pearl",
                Weight = 0.1,
            },
        },
    },
    {
        ID = "FJ.Swamp",
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(312, 237, 511, 130),
        RequiresWater = false,
        FishingAreas = {
            V(332, 141, 340, 155), -- South shipwreck

            -- Stone bridge near Fort Joy
            V(381, 164, 392, 186),
            V(376, 183, 384, 192),

            -- Near south skeleton ambush
            V(392, 144, 414, 155),
            V(368, 148, 374, 152),
            V(368, 132, 383, 138),

            V(411, 175, 427, 183), -- Puddle near frogs
            V(436, 181, 442, 187), -- Near frogs, east of north bridge
            V(410, 157, 418, 163), -- South of west bridge leading to pigs

            -- Skeleton treasure north of pigs
            V(442, 195, 450, 201),
            V(452, 193, 462, 196),

            -- Bridge to the voidwoken fight
            V(462, 173, 475, 176),
            V(464, 164, 472, 169),
            V(473, 152, 477, 156), -- Puddle south

            -- Bridge south of pigs area
            V(410, 147, 419, 153),
            V(426, 141, 439, 154),
        },
        Fish = {
            {
                ID = "Moss",
                Weight = 1,
            },
            {
                ID = "LilyPad",
                Weight = 0.5,
            },
            {
                ID = "Aldrovanda",
                Weight = 0.2,
            },
            {
                ID = "Mine",
                Weight = 0.1,
            },
            {
                ID = "WaspNest",
                Weight = 0.6,
            },
        },
    },
    {
        ID = "FJ.FortBridge", -- The drawbridge, specifically.
        Priority = 99, -- Needs to be higher priority than swamp.
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(320, 216, 340, 169),
        RequiresWater = false,
        FishingAreas = {
            V(322, 170, 337, 201), -- Drawbridge area
            V(328, 201, 338, 207), -- North of drawbridge, near the workshop
        },
        Fish = {
            {
                ID = "Seaweed",
                Weight = 1,
            },
            {
                ID = "Moss",
                Weight = 1,
            },
            {
                ID = "Scarf",
                Weight = 0.7,
            },
            {
                ID = "FishBone",
                Weight = 0.3,
            },
        },
    },
    {
        ID = "FJ.BrahmosDesert", -- No idea if this area is actually playable lmao, so don't put unique fish there
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(156, 505, 195, 486),
        RequiresWater = true,
        Fish = {
            {
                ID = "GoldenShell",
                Weight = 1,
            },
            {
                ID = "NonFineChina",
                Weight = 0.6,
            },
        },
    },
    {
        ID = "FJ.BraccusTower",
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(578, 689, 638, 595),
        RequiresWater = false,
        FishingAreas = {
            V(617, 596, 635, 611), -- Near skeleton encounter
            V(557, 635, 560, 641), -- Canal
            V(566, 654, 582, 672), -- West Punisher area
            V(560, 667, 577, 689), -- Northwest Punisher area
            V(595, 654, 618, 668), -- East Punisher area
            V(599, 670, 615, 687), -- Northeast Punisher area
        },
        Fish = {
            {
                ID = "Salt",
                Weight = 1,
            },
            {
                ID = "TorrentedSoul",
                Weight = 0.7,
            },
            {
                ID = "Blobfish",
                Weight = 0.5,
            },
            {
                ID = "Painting",
                Weight = 0.1,
            },
            {
                ID = "DescentKey",
                Weight = 0.05,
            },
        },
    },
    {
        ID = "FJ.BraccusTower.Well",
        LevelID = "FJ_FortJoy_Main",
        Priority = 99,
        Bounds = V(634, 650, 639, 645),
        RequiresWater = false,
        FishingAreas = {
            V(634, 645, 639, 650),
        },
        Fish = {
            {
                ID = "Bucket",
                Weight = 1,
            },
            {
                ID = "Salt",
                Weight = 0.9,
            },
            {
                ID = "MessagelessBottle",
                Weight = 0.8,
            },
            {
                ID = "AxeHead",
                Weight = 0.2,
            },
            {
                ID = "Pearl",
                Weight = 0.05,
            },
        },
    },
    {
        ID = "FJ.TrompdoyCave",
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(550, 564, 696, 462),
        RequiresWater = false,
        FishingAreas = {
            V(652, 458, 658, 504), -- Entrance
            V(686, 456, 703, 468), -- Pond to the right of entrance
            V(582, 533, 590, 553), -- Crystal area

            -- Trompdoy fight arena
            V(653, 530, 665, 548), -- Entrance
            V(655, 542, 687, 546), -- Middle part
            V(667, 546, 676, 550), -- Middle-er part
            V(665, 553, 697, 562), -- Corner near waterfall
            V(685, 539, 697, 556), -- South of waterfall
            V(676, 533, 680, 545), -- South, near exit
        },
        Fish = {
            {
                ID = "Handkerchief",
                Weight = 1,
            },
            {
                ID = "Socks",
                Weight = 1,
            },
            {
                ID = "TorrentedSoul",
                Weight = 0.7,
            },
            {
                ID = "BlueShell",
                Weight = 0.6,
            },
            {
                ID = "SoulJar",
                Weight = 0.5,
            },
            {
                ID = "BranchingCoral",
                Weight = 0.5,
            },
            {
                ID = "Pearl",
                Weight = 0.1,
            },
        },
    },
    {
        ID = "FJ.LavaPortal", -- From the Braccus maze area
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(405, 506, 446, 454),
        RequiresWater = false,
        FishingAreas = {
            V(417, 454, 430, 490), -- Middle

            -- Northeast
            V(437, 480, 444, 498),
            V(427, 487, 443, 498),

            V(428, 458, 449, 473), -- Southeast
            V(437, 475, 448, 497), -- Northeast
        },
        Fish = {
            {
                ID = "Salt",
                Weight = 1,
            },
            {
                ID = "FishBone",
                Weight = 1,
            },
            {
                ID = "Mine",
                Weight = 0.4,
            },
            {
                ID = "Fetish",
                Weight = 0.4,
            },
        },
    },
    {
        ID = "FJ.SourceFountain", -- Fountain underneath Gareth's fort
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(328, 482, 338, 476),
        RequiresWater = false,
        FishingAreas = {
            V(331, 478, 335, 482),
        },
        Fish = {
            {
                ID = "Salt",
                Weight = 1,
            },
            {
                ID = "SourceStarFish",
                Weight = 0.5,
            },
            {
                ID = "Starstone",
                Weight = 0.2,
            },
            {
                ID = "TemporalGear",
                Weight = 0.2,
            },
        },
    },
}
for _,region in ipairs(regions) do
    local bounds = region.Bounds

    -- Set the bounds to use width/height for 3rd and 4th element, instead of coords.
    bounds[3] = bounds[3] - bounds[1]
    bounds[4] = bounds[2] - bounds[4]
    if region.FishingAreas then
        for _,area in ipairs(region.FishingAreas) do
            area[3] = area[3] - area[1]
            area[4] = area[4] - area[2]
        end
    end

    Fishing.RegisterRegion(region)
end