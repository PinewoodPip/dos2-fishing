
local V = Vector.Create

local Fishing = GetFeature("Fishing")
local Regions = GetFeature("Fishing.Regions")
local CAPACITY = Regions.REGION_CAPACITIES

---Utility method to register translated strings for a region.
local T = function(tsk)
    local tskEntry = Fishing:RegisterTranslatedString(tsk)
    tskEntry.ContextDescription = "Fishing region name"
    return tskEntry.Handle
end

---@type Fishing.Region[]
local regions = {
    {
        ID = "RC.StartingBeach",
        NameHandle = T{
            Handle = "hc494529bg98feg4b23g9846g56b96a1a12cd",
            Text = "Driftwood Dunes",
        },
        LevelID = "RC_Main",
        Bounds = V(387, 190, 516, -83),
        FishingAreas = {
            V(446, 37, 463, 56), -- River end near caravan

            -- River going north
            V(455, 51, 474, 131),
            V(462, 131, 474, 150),
            V(466, 139, 474, 152),
            V(471, 151, 474, 172),
            V(471, 174, 474, 188),

            -- South of drawbridge
            V(479, 22, 499, 38),
            V(494, 17, 512, 24),
        },
        Capacity = CAPACITY.HIGH,
        Fish = {
            {
                ID = "Pomfret",
                Weight = 1,
            },
            {
                ID = "Eel",
                Weight = 0.8,
            },
            {
                ID = "Stringfish",
                Weight = 0.8,
            },
            {
                ID = "SharkTooth",
                Weight = 0.7,
            },
            {
                ID = "Anglerfish",
                Weight = 0.6,
            },
        },
    },
    {
        ID = "RC.RykerMansion.Underground",
        NameHandle = T{
            Handle = "h44e46be5g46d0g4537gabc7gc837406aafc8",
            Text = "Ryker's Mansion Underground",
        },
        LevelID = "RC_Main",
        Bounds = V(86, 655, 139, 593),
        FishingAreas = {
            V(123, 647, 128, 652), -- Middle of the water running from the waterfall; not flagged as Deepwater for some reason
        },
        Capacity = CAPACITY.LOW,
        Fish = {
            {
                ID = "Porgy",
                Weight = 1,
            },
            {
                ID = "CrabClaw",
                Weight = 0.9,
            },
            {
                ID = "Riftling",
                Weight = 0.7,
            },
            {
                ID = "FidgetSpinner",
                Weight = 0.5,
            },
            {
                ID = "MessagelessBottle",
                Weight = 0.1,
            },
            {
                ID = "DescentKey",
                Weight = 0.05,
            },
        },
    },
    {
        ID = "RC.Driftwood",
        NameHandle = "h8df27bc1g92d0g491fg9314g1e8d8ada8042", -- "Driftwood"
        LevelID = "RC_Main",
        Priority = 99, -- Needs to be higher than starting beach.
        Bounds = V(238, 194, 410, 29),
        FishingAreas = {
            -- North river
            V(284, 179, 334, 186),
            V(332, 176, 350, 179),
        },
        Capacity = CAPACITY.HIGH,
        Fish = {
            {
                ID = "Pomfret",
                Weight = 1,
            },
            {
                ID = "SeaPickle",
                Weight = 1,
            },
            {
                ID = "PolyamorousTrout",
                Weight = 0.7,
            },
            {
                ID = "PremoldedCheese",
                Weight = 0.6,
            },
            {
                ID = "Swordine",
                Weight = 0.4,
            },
            {
                ID = "Bucket",
                Weight = 0.3,
            },
            {
                ID = "Soap",
                Weight = 0.3,
            },
            {
                ID = "Jackpot",
                Weight = 0.2,
            },
            {
                ID = "ModSettingsMenu",
                Weight = 0.05,
            },
        },
    },
    {
        ID = "RC.Driftwood.FishFactory",
        NameHandle = T{
            Handle = "hef3823eeg0142g4678gb932g992e4ae1ecf3",
            Text = "Diftwood Fish Factory",
        },
        LevelID = "RC_Main",
        Priority = 99, -- Needs to be higher than starting beach.
        Bounds = V(196, 582, 222, 556),
        FishingAreas = {},
        Capacity = CAPACITY.LOW,
        Fish = {
            {
                ID = "PremoldedCheese",
                Weight = 0.8,
            },
            {
                ID = "Riftling",
                Weight = 0.7,
            },
            {
                ID = "SeabedRoll",
                Weight = 0.5,
            },
            {
                ID = "Jackpot",
                Weight = 0.4,
            },
        },
    },
    {
        ID = "RC.Driftwood.Arena",
        NameHandle = "h933be1fag13f4g4017g9739gffd2a4c4c80d", -- "Driftwood Arena"
        LevelID = "RC_Main",
        Bounds = V(390, 881, 448, 717), -- Most of the usable area is the water near the drudanae farm.
        FishingAreas = {
            -- Drudanae farm
            V(390, 738, 396, 742),
            V(399, 723, 403, 726),
            V(401, 730, 409, 740),

            -- Waterfall near entrance (puddle to the east of it is deepwater)
            V(413, 746, 420, 753),
        },
        Capacity = CAPACITY.LOW,
        Fish = {
            {
                ID = "GilledMushroom",
                Weight = 1,
            },
            {
                ID = "Moss",
                Weight = 0.8,
            },
            {
                ID = "PotLid",
                Weight = 0.6,
            },
            {
                ID = "Handkerchief",
                Weight = 0.4,
            },
        },
    },
    {
        ID = "RC.Peacemaker",
        NameHandle = T{
            Handle = "hdfec195bg1791g4508ga82cg5d76747c934c",
            Text = "Wreck of The Peacemaker",
        },
        LevelID = "RC_Main",
        Bounds = V(216, 548, 247, 527),
        Capacity = CAPACITY.LOW,
        Fish = {
            {
                ID = "Moss",
                Weight = 1,
            },
            {
                ID = "DarkConch",
                Weight = 0.8,
            },
            {
                ID = "Nightfarer",
                Weight = 0.6,
            },
            {
                ID = "LetterOfWill",
                Weight = 0.1,
            },
        },
    },
    {
        ID = "RC.SouthWest",
        NameHandle = T{
            Handle = "h28abfc31g3773g4a4cga0b4g9fa1f5e76e41",
            Text = "Reaper's Bluffs",
        },
        LevelID = "RC_Main",
        Bounds = V(42, 210, 241, 29),
        FishingAreas = {},
        Capacity = CAPACITY.HIGH,
        Fish = {
            {
                ID = "Bream",
                Weight = 1,
            },
            {
                ID = "Starfish",
                Weight = 0.7,
            },
            {
                ID = "SardineSchool",
                Weight = 0.6,
            },
            {
                ID = "GoldenShell",
                Weight = 0.4,
            },
            {
                ID = "SeaPork",
                Weight = 0.3,
            },
            {
                ID = "PearlClam",
                Weight = 0.2,
            },
            {
                ID = "LetterOfWill",
                Weight = 0.1,
            },
            {
                ID = "ProperSeafarer",
                Weight = 0.1,
            },
            {
                ID = "SpareLamp",
                Weight = 0.05,
            },
        },
    },
    {
        ID = "RC.WreckersCave",
        NameHandle = "he7b23cc3geeebg4713gb40bgdb26cb686b96", -- "Wrecker's Cave"
        LevelID = "RC_Main",
        Bounds = V(529, 701, 761, 521),
        FishingAreas = {
            V(703, 662, 709, 666), -- Puddle near waypoint
            V(697, 692, 713, 697), -- North river

            -- North voidwoken area
            V(744, 649, 752, 654),
            V(726, 651, 734, 654),

            -- Lake the west of waypoint
            V(679, 648, 685, 662),
            V(673, 657, 681, 662),
            V(666, 662, 676, 665),

            -- Northwest
            V(635, 684, 643, 690),
            V(620, 647, 630, 662),

            V(665, 637, 670, 642), -- Small puddle to the south of the north gate

            -- Center of the map
            V(671, 605, 681, 622),
            V(681, 615, 683, 618), -- Small extra bit of the puddle to the east
            V(679, 587, 686, 615),
            V(683, 588, 690, 595),
            V(696, 588, 700, 591),

            -- Puddle south of the center
            V(673, 569, 678, 581),
            V(675, 581, 680, 588),

            -- South of waypoint
            V(712, 626, 718, 633),
            V(716, 629, 726, 635),

            -- Near shipwreck trapdoor
            V(648, 609, 654, 612),
            V(639, 585, 644, 598),
            V(660, 609, 665, 614),
            V(664, 606, 674, 614),

            -- Center waterfall
            V(724, 606, 733, 615),
            V(732, 592, 739, 597),

            -- Waterfall south of the large shipwreck
            V(700, 539, 721, 556),
            V(682, 532, 692, 539),
            V(686, 537, 700, 554),

            V(630, 552, 647, 572), -- Lake by south chest
            V(624, 521, 631, 529), -- Random hole south of the map

            -- West area waterfall
            V(569, 652, 579, 657),
            V(556, 668, 561, 675),
            V(552, 678, 558, 692),
            V(532, 596, 564, 614), -- South waterfall abyss

            -- Southwest area (entrance from the dwarf fort)
            V(539, 543, 550, 556),
            V(545, 562, 561, 569),
            V(543, 566, 549, 582),
        },
        Fish = {
            {
                ID = "Anglerfish",
                Weight = 1,
            },
            {
                ID = "Frog",
                Weight = 1,
            },
            {
                ID = "BladeFish",
                Weight = 0.7,
            },
            {
                ID = "Hurchin",
                Weight = 0.6,
            },
            {
                ID = "TorrentedSoul",
                Weight = 0.4,
            },
            {
                ID = "Mine",
                Weight = 0.3,
            },
            {
                ID = "NonFineChina",
                Weight = 0.3,
            },
            {
                ID = "Salt",
                Weight = 0.3,
            },
            {
                ID = "Painting",
                Weight = 0.2,
            },
        },
    },
    {
        ID = "RC.Cloisterwood",
        NameHandle = "h95a18a2bgfa1ag412fgbd74g5342459c92a2", -- "Cloisterwood"
        LevelID = "RC_Main",
        Bounds = V(105, 350, 336, 180),
        FishingAreas = {
            -- South bridge & river upstream
            V(288, 199, 301, 211),
            V(294, 220, 309, 233),
            V(298, 229, 313, 242),
            V(302, 245, 315, 260),
            V(305, 258, 318, 266),
            V(310, 265, 322, 272),
            V(316, 272, 328, 280),
            V(319, 282, 333, 299),
        },
        Fish = {
            {
                ID = "Aldrovanda",
                Weight = 1,
            },
            {
                ID = "Moss",
                Weight = 1,
            },
            {
                ID = "LilyPad",
                Weight = 0.8,
            },
            {
                ID = "WaspNest",
                Weight = 0.6,
            },
            {
                ID = "MoonJelly",
                Weight = 0.5,
            },
            {
                ID = "Quiver",
                Weight = 0.6,
            },
            {
                ID = "Fetish",
                Weight = 0.2,
            },
            {
                ID = "Epipe",
                Weight = 0.05,
            },
        },
    },
    {
        ID = "RC.Cloisterwood.ChurchPool",
        NameHandle = T{
            Handle = "hb1073514ge681g45e9ga312g67adb433cea0",
            Text = "Cloisterwood Church",
        },
        LevelID = "RC_Main",
        Priority = 99, -- Needs to be higher than the main cloisterwood region.
        Bounds = V(194, 262, 203, 253),
        FishingAreas = {},
        Capacity = CAPACITY.LOW,
        Fish = {
            {
                ID = "Moss",
                Weight = 1,
            },
            {
                ID = "LilyPad",
                Weight = 1,
            },
            {
                ID = "Riftling",
                Weight = 0.7,
            },
            {
                ID = "SmallShip",
                Weight = 0.1,
            },
            {
                ID = "ReptileEgg",
                Weight = 0.1,
            },
            {
                ID = "Epipe",
                Weight = 0.1,
            },
        },
    },
    {
        ID = "RC.BloodmoonIsland",
        NameHandle = "hdfbbb1bfg7ec9g4c90g8457gd88a12aee82d", -- "Bloodmoon Island"
        LevelID = "RC_Main",
        Bounds = V(147, 489, 440, 340),
        FishingAreas = {
            V(334, 429, 344, 439), -- Puddle north of waypoint
        },
        Fish = {
            {
                ID = "FishBone",
                Weight = 1,
            },
            {
                ID = "Piranha",
                Weight = 1,
            },
            {
                ID = "Head",
                Weight = 0.8,
            },
            {
                ID = "Mindflayer",
                Weight = 0.7,
            },
            {
                ID = "Hurchin",
                Weight = 0.8,
            },
            {
                ID = "FloodRose",
                Weight = 0.7,
            },
            {
                ID = "SourceTouchedSchool",
                Weight = 0.5,
            },
            {
                ID = "Fetish",
                Weight = 0.5,
            },
            {
                ID = "LavoodooDoll",
                Weight = 0.5,
            },
            {
                ID = "Aldrovanda",
                Weight = 0.7,
            },
            {
                ID = "Mine",
                Weight = 0.3,
            },
        },
    },
    {
        ID = "RC.DriftwoodFields",
        NameHandle = T{
            Handle = "he70d8080g3585g41c3g940dg6f127377afce",
            Text = "Driftwood Fields",
        },
        LevelID = "RC_Main",
        Priority = 98, -- Needs to be higher than Bloodmoon Island
        Bounds = V(362, 360, 532, 192),
        FishingAreas = {},
        Fish = {
            {
                ID = "Porgy",
                Weight = 1,
            },
            {
                ID = "Corncomber",
                Weight = 1,
            },
            {
                ID = "PolyamorousTrout",
                Weight = 0.7,
            },
            {
                ID = "Frog",
                Weight = 0.7,
            },
            {
                ID = "Dandelion",
                Weight = 0.7,
            },
            {
                ID = "Pitcher",
                Weight = 0.3,
            },
            {
                ID = "PotLid",
                Weight = 0.2,
            },
            {
                ID = "WashedPanties",
                Weight = 0.2,
            },
            {
                ID = "Scarf",
                Weight = 0.2,
            },
            {
                ID = "ModSettingsMenu",
                Weight = 0.05,
            },
        },
    },
    {
        ID = "RC.Sawmill",
        NameHandle = "h247d6aa0g1798g4d5eg9289g395cc2907803", -- "Abandoned Livewood Sawmill"
        LevelID = "RC_Main",
        Bounds = V(431, 500, 569, 384),
        FishingAreas = {
            -- River by entrance
            V(473, 398, 505, 406),
            V(519, 398, 548, 406),

            -- North river
            V(534, 406, 558, 457),
            V(546, 454, 559, 473),
            V(546, 468, 556, 485),
            V(550, 482, 555, 488),
            V(547, 487, 553, 492),
        },
        Capacity = CAPACITY.MIDDLING,
        Fish = {
            {
                ID = "Porgy",
                Weight = 1,
            },
            {
                ID = "BladeFish",
                Weight = 0.7,
            },
            {
                ID = "Stringfish",
                Weight = 0.7,
            },
            {
                ID = "AxeHead",
                Weight = 0.3,
            },
            {
                ID = "SmallShip",
                Weight = 0.2,
            },
            {
                ID = "Quiver",
                Weight = 0.1,
            },
            {
                ID = "WashedPanties",
                Weight = 0.1,
            },
            {
                ID = "BuffaloAmulet",
                Weight = 0.05,
            },
            {
                ID = "TemporalGear",
                Weight = 0.05,
            },
        },
    },
    {
        ID = "RC.ParadiseDowns",
        NameHandle = "h3138fa95gde9fg4d33g9233gdaa5a9a594fe", -- "Paradise Downs"
        LevelID = "RC_Main",
        Bounds = V(561, 461, 750, 214),
        FishingAreas = {
            -- West waterfall and river downstream
            V(567, 376, 592, 404),
            V(576, 364, 584, 379),
            V(579, 353, 586, 367),
            V(583, 347, 588, 353),
            V(589, 338, 592, 347),
            V(587, 319, 599, 342),
            V(581, 305, 601, 320),
            V(583, 290, 595, 311),
            V(585, 283, 596, 295),
            V(592, 275, 609, 280),
            V(593, 280, 618, 278),
            V(607, 272, 624, 277),

            -- Southern part of the river
            V(625, 284, 653, 304),
            V(634, 301, 669, 316),
            V(645, 310, 676, 320),
            V(658, 319, 666, 324),
            V(650, 319, 690, 320),
            V(680, 319, 695, 327),

            -- Far east (near edge of the map)
            V(712, 333, 731, 349),
            V(733, 320, 742, 330),

            V(688, 441, 712, 464), -- Behind Harbinger

            -- Burning house near center
            V(615, 386, 629, 408),
            V(599, 404, 623, 414),
            V(621, 375, 650, 383),
        },
        Capacity = CAPACITY.LOW,
        Fish = {
            {
                ID = "FishBone",
                Weight = 1,
            },
            {
                ID = "DarkConch",
                Weight = 1,
            },
            {
                ID = "Sludge",
                Weight = 1,
            },
            {
                ID = "Head",
                Weight = 0.7,
            },
            {
                ID = "Blobfish",
                Weight = 0.7,
            },
            {
                ID = "NonFineChina",
                Weight = 0.7,
            },
            {
                ID = "Mindflayer",
                Weight = 0.5,
            },
        },
    },
    {
        ID = "RC.Blackpits",
        NameHandle = T{
            Handle = "h2d2c6579gdfcfg4c47gb506gc063aa691808",
            Text = "Blackpits Coast",
        },
        LevelID = "RC_Main",
        Bounds = V(589, 197, 741, 27),
        FishingAreas = {},
        Fish = {
            {
                ID = "Rockfish",
                Weight = 1,
            },
            {
                ID = "Seaweed",
                Weight = 1,
            },
            {
                ID = "Pufferfish",
                Weight = 1,
            },
            {
                ID = "HotShell",
                Weight = 0.8,
            },
            {
                ID = "NonFineChina",
                Weight = 0.7,
            },
            {
                ID = "ReptileEgg",
                Weight = 0.3,
            },
            {
                ID = "ProperSeafarer",
                Weight = 0.2,
            },
        },
    },
    {
        ID = "RC.Blackpits.Underground",
        NameHandle = T{
            Handle = "hd07b3191g6013g4c52g8066ge4b8164da730",
            Text = "Blackpits Underground",
        },
        LevelID = "RC_Main",
        Bounds = V(278, 680, 491, 541),
        Capacity = CAPACITY.MIDDLING,
        FishingAreas = {
            -- Minecart area
            V(338, 562, 365, 609),
            V(351, 616, 360, 625),
            V(336, 613, 343, 622),
            V(347, 629, 354, 636),
            V(339, 631, 346, 654),
            V(370, 597, 391, 610),
            V(398, 601, 405, 616),

            -- South waterfall
            V(347, 534, 352, 542),

            -- Holes near Aethera
            -- Quite literally fishing holes
            V(470, 663, 474, 667),
            V(470, 671, 474, 675),
            V(478, 671, 482, 675),
            V(478, 663, 482, 666),
        },
        Fish = {
            {
                ID = "Rockfish",
                Weight = 1,
            },
            {
                ID = "Sludge",
                Weight = 1,
            },
            {
                ID = "SourceStarFish",
                Weight = 0.7,
            },
            {
                ID = "Pitcher",
                Weight = 0.5,
            },
            {
                ID = "LightAtTheEnd",
                Weight = 0.2,
            },
            {
                ID = "Starstone",
                Weight = 0.05,
            },
        },
    },
    {
        ID = "RC.WreckersCave.MordusHideout",
        NameHandle = T{
            Handle = "hf52d37cbgb834g450cgbc15gd8e0ad1ceaf6",
            Text = "Mordus's Hideout",
        },
        LevelID = "RC_Main",
        Bounds = V(81, 745, 125, 702),
        FishingAreas = {},
        Capacity = CAPACITY.MIDDLING,
        Fish = {
            {
                ID = "Hurchin",
                Weight = 1,
            },
            {
                ID = "GilledMushroom",
                Weight = 1,
            },
            {
                ID = "Piranha",
                Weight = 1,
            },
            {
                ID = "SharkTooth",
                Weight = 0.8,
            },
            {
                ID = "LavoodooDoll",
                Weight = 0.4,
            },
            {
                ID = "SmallShip",
                Weight = 0.1,
            },
        },
    },
    {
        ID = "RC.MeistrBasement",
        NameHandle = T{
            Handle = "hbe8aeadfg590cg4c9dg8849g33aae2dd688d",
            Text = "Meistr's Basement",
        },
        LevelID = "RC_Main",
        Bounds = V(143, 700, 149, 693),
        FishingAreas = {
            V(145, 693, 147, 697),
        },
        Capacity = CAPACITY.LOW,
        Fish = {
            {
                ID = "SourceStarFish",
                Weight = 1,
            },
            {
                ID = "LightAtTheEnd",
                Weight = 0.1,
            },
            {
                ID = "TemporalGear",
                Weight = 0.05,
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