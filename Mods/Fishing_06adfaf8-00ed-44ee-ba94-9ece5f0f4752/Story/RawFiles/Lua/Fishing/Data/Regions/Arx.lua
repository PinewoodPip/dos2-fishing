
local V = Vector.Create

local Fishing = GetFeature("Fishing")
local CAPACITY = Fishing.REGION_CAPACITIES

---Utility method to register translated strings for a region.
local T = function(tsk)
    local tskEntry = Fishing:RegisterTranslatedString(tsk)
    tskEntry.ContextDescription = "Fishing region name"
    return tskEntry.Handle
end

---@type Fishing.Region.FishEntry[]
local SEWER_FISHES = {
    {
        ID = "Piranha",
        Weight = 1,
    },
    {
        ID = "Petri",
        Weight = 1,
    },
    {
        ID = "Sludge",
        Weight = 1,
    },
    {
        ID = "GripSlipper",
        Weight = 0.7,
    },
    {
        ID = "GilledMushroom",
        Weight = 0.5,
    },
}

---@type Fishing.Region[]
local regions = {
    {
        ID = "Arx.SouthDeathfogRivers",
        NameHandle = T{
            Handle = "h3a627f33g59bag4f0fg9169gbaf8f2c0be2d",
            Text = "South Outskirts",
        },
        LevelID = "ARX_Main",
        Bounds = V(339, 67, 430, -34),
        FishableSurfaceType = "Deathfog",
        FishingAreas = {
            -- East river
            V(400, 26, 408, 36),
            V(400, 42, 412, 59),
            V(411, 53, 434, 60),
            V(398, 62, 407, 71), -- North part

            -- South river
            V(344, -30, 365, -12),
        },
        Fish = {
            {
                ID = "FishBone",
                Weight = 1,
            },
            {
                ID = "Nightfarer",
                Weight = 1,
            },
            {
                ID = "Sludge",
                Weight = 1,
            },
            {
                ID = "PremoldedCheese",
                Weight = 0.6,
            },
            {
                ID = "SoulJar",
                Weight = 0.4,
            },
            {
                ID = "Mindflayer",
                Weight = 0.4,
            },
        },
    },
    {
        ID = "Arx.PilgrimRiver",
        NameHandle = T{
            Handle = "h00067f25g3881g4c38gb5dcg36f6d30ad02d",
            Text = "Pilgrimage River",
        },
        LevelID = "ARX_Main",
        Bounds = V(250, 123, 410, 59),
        FishingAreas = {
            -- East river
            V(361, 104, 371, 113),
            V(366, 100, 372, 109),
            V(368, 98, 373, 108),
            V(368, 96, 374, 107),
            V(371, 94, 377, 105),
            V(373, 91, 377, 101),
            V(376, 88, 386, 95),
            V(381, 84, 395, 89),
        },
        Fish = {
            {
                ID = "Porgy",
                Weight = 1,
            },
            {
                ID = "PolyamorousTrout",
                Weight = 1,
            },
            {
                ID = "Handkerchief",
                Weight = 0.7,
            },
            {
                ID = "Pitcher",
                Weight = 0.6,
            },
            {
                ID = "ModSettingsMenu",
                Weight = 0.25,
            },
            {
                ID = "FidgetSpinner",
                Weight = 0.25,
            },
        },
    },
    {
        ID = "Arx.Harbour",
        NameHandle = T{
            Handle = "h8567dbafg812fg44f2gb873gb8bac32751f0",
            Text = "Arx Harbour",
        },
        LevelID = "ARX_Main",
        Bounds = V(419, 177, 530, 74),
        Capacity = CAPACITY.HIGH,
        Fish = {
            {
                ID = "Bream",
                Weight = 1,
            },
            {
                ID = "Swordine",
                Weight = 1,
            },
            {
                ID = "Anglerfish",
                Weight = 0.8,
            },
            {
                ID = "Jackpot",
                Weight = 0.7,
            },
            {
                ID = "ProperSeafarer",
                Weight = 0.25,
            },
        },
    },
    {
        ID = "Arx.HarbourCellar",
        NameHandle = T{
            Handle = "h72967dcfge390g4793gba50gc60e650080d9",
            Text = "Harbour Cellar",
        },
        LevelID = "ARX_Main",
        Bounds = V(467, 741, 484, 719),
        FishingAreas = {
            V(467, 730, 478, 736),
        },
        Capacity = CAPACITY.LOW,
        Fish = {
            {
                ID = "Anglerfish",
                Weight = 1,
            },
            {
                ID = "Bream",
                Weight = 1,
            },
            {
                ID = "Painting",
                Weight = 0.2,
            },
            {
                ID = "BuffaloAmulet",
                Weight = 0.15,
            },
        },
    },
    {
        ID = "Arx.BridgeLake",
        NameHandle = T{
            Handle = "h25a516c6g433cg491bg8f59g3003953cf0a0",
            Text = "Arx Bridge Lake",
        },
        LevelID = "ARX_Main",
        Bounds = V(233, 220, 453, 100),
        Fish = {
            {
                ID = "Bream",
                Weight = 1,
            },
            {
                ID = "Anglerfish",
                Weight = 1,
            },
            {
                ID = "Scarf",
                Weight = 0.7,
            },
            {
                ID = "DarkConch",
                Weight = 0.7,
            },
            {
                ID = "Mine",
                Weight = 0.5,
            },
            {
                ID = "AxeHead",
                Weight = 0.3,
            },
        },
    },
    {
        ID = "Arx.EastCity",
        NameHandle = T{
            Handle = "hca694be5gfef5g4c12gb1d0g2668ee1ceb1d",
            Text = "Arx City East",
        },
        LevelID = "ARX_Main",
        Bounds = V(353, 443, 500, 196),
        Capacity = CAPACITY.HIGH,
        Fish = {
            {
                ID = "Piranha",
                Weight = 1,
            },
            {
                ID = "Seaweed",
                Weight = 0.9,
            },
            {
                ID = "SeaPickle",
                Weight = 0.9,
            },
            {
                ID = "Blobfish",
                Weight = 0.7,
            },
            {
                ID = "TorrentedSoul",
                Weight = 0.6,
            },
            {
                ID = "SeaPork",
                Weight = 0.4,
            },
            {
                ID = "LetterOfWill",
                Weight = 0.3,
            },
            {
                ID = "LavoodooDoll",
                Weight = 0.3,
            },
        },
    },
    {
        ID = "Arx.OrphanageFountain",
        Priority = 99, -- Needs to be higher than Arx East.
        NameHandle = T{
            Handle = "hb3581279g28fcg4c78g8c2eg02a8c627730a",
            Text = "Orphanage Fountain",
        },
        LevelID = "ARX_Main",
        Bounds = V(423, 252, 435, 233),
        FishingAreas = {
            V(427, 242, 430, 246),
        },
        Capacity = CAPACITY.LOW,
        Fish = {
            {
                ID = "Scarf",
                Weight = 1,
            },
            {
                ID = "LilyPad",
                Weight = 0.7,
            },
            {
                ID = "WashedPanties",
                Weight = 0.4,
            },
            {
                ID = "WaterRing",
                Weight = 0.2,
            },
        },
    },
    {
        ID = "Arx.LoremasterFountain",
        Priority = 99, -- Needs to be higher than Arx East.
        NameHandle = T{
            Handle = "h0458002dg2eb0g4ff2gaa40g06a2969862e8",
            Text = "Loremaster's Fountain",
        },
        LevelID = "ARX_Main",
        Bounds = V(382, 306, 401, 293),
        FishingAreas = {
            V(388, 297, 392, 301),
        },
        Capacity = CAPACITY.LOW,
        Fish = {
            {
                ID = "Handkerchief",
                Weight = 1,
            },
            {
                ID = "Painting",
                Weight = 0.5,
            },
            {
                ID = "Soap",
                Weight = 0.5,
            },
            {
                ID = "ModSettingsMenu",
                Weight = 0.1,
            },
            {
                ID = "LetterOfWill",
                Weight = 0.1,
            },
        },
    },
    {
        ID = "Arx.City",
        NameHandle = T{
            Handle = "h5bed96c9gd5a1g4f17g9123g64d2d100e069",
            Text = "Arx City West",
        },
        LevelID = "ARX_Main",
        Bounds = V(185, 375, 378, 172),
        Capacity = CAPACITY.HIGH,
        Fish = {
            {
                ID = "Sardine",
                Weight = 1,
            },
            {
                ID = "BladeFish",
                Weight = 0.8,
            },
            {
                ID = "Salt",
                Weight = 0.7,
            },
            {
                ID = "PotLid",
                Weight = 0.7,
            },
            {
                ID = "NonFineChina",
                Weight = 0.7,
            },
            {
                ID = "Frog",
                Weight = 0.5,
            },
        },
    },
    {
        ID = "Arx.KemmMansion",
        Priority = -1, -- Needs to be lower than main Arx.
        NameHandle = T{
            Handle = "h62c5f08fg1929g44ffga109gb609e328dc04",
            Text = "Kemm's Mansion",
        },
        LevelID = "ARX_Main",
        Bounds = V(69, 458, 246, 222),
        FishingAreas = {
            -- East garden; non-functional due to buggy cursor behaviour here - it snaps to specific points, unknown why.
            -- V(107, 267, 115, 272),
            -- V(103, 284, 114, 289),
            -- V(109, 294, 109, 294),
            -- TODO hatch area - needs to be conditional
        },
        Fish = {
            {
                ID = "Aldrovanda",
                Weight = 1,
            },
            {
                ID = "LilyPad",
                Weight = 1,
            },
            {
                ID = "Eel",
                Weight = 0.8,
            },
            {
                ID = "Moss",
                Weight = 0.7,
            },
            {
                ID = "NonFineChina",
                Weight = 0.7,
            },
            {
                ID = "SmallShip",
                Weight = 0.4,
            },
            {
                ID = "SpareLamp",
                Weight = 0.4,
            },
        },
    },
    {
        ID = "Arx.KemmFountain",
        Priority = 99, -- Needs to be higher than Kemm's Garden.
        NameHandle = T{
            Handle = "h1dff0a71g64d7g4364ga247g1131b06184c7",
            Text = "Garden Fountain",
        },
        LevelID = "ARX_Main",
        Bounds = V(169, 245, 182, 234),
        FishingAreas = {
            V(173, 237, 178, 242),
        },
        Capacity = CAPACITY.LOW,
        Fish = {
            {
                ID = "Moss",
                Weight = 1,
            },
            {
                ID = "Petri",
                Weight = 0.7,
            },
            {
                ID = "DescentKey",
                Weight = 0.2,
            },
        },
    },
    {
        ID = "Arx.ConsulateGarden",
        Priority = 99, -- Needs to be higher than Kemm's Garden.
        NameHandle = T{
            Handle = "he0d688a1g69afg4c58gb9d2ga012e2ceeeae",
            Text = "Consulate Garden",
        },
        LevelID = "ARX_Main",
        Bounds = V(185, 428, 216, 392),
        Capacity = CAPACITY.LOW,
        FishingAreas = {
            -- Main fountain
            V(195, 405, 204, 415),

            -- Small fountains; from south-east going counter-clockwise
            V(211, 406, 213, 408),
            V(211, 415, 213, 417),
            V(204, 423, 207, 426),
            V(192, 424, 195, 426),
            V(185, 415, 188, 418),
            V(186, 405, 189, 408),
        },
        Fish = {
            {
                ID = "LilyPad",
                Weight = 1,
            },
            {
                ID = "Frog",
                Weight = 1,
            },
            {
                ID = "WashedPanties",
                Weight = 0.4,
            },
            {
                ID = "RedHerring",
                Weight = 0.3,
            },
            {
                ID = "ReptileEgg",
                Weight = 0.3,
            },
            {
                ID = "LightAtTheEnd",
                Weight = 0.2,
            },
        },
    },
    {
        ID = "Arx.Sewers",
        NameHandle = T{
            Handle = "hb3a20076g8440g428cga186g41ca6eb08455",
            Text = "Sewers Upper Level",
        },
        LevelID = "ARX_Main",
        Bounds = V(156, 799, 208, 706),
        FishingAreas = {
            -- South of waypoint
            V(194, 751, 213, 758),
            V(194, 757, 200, 764),

            -- Waypoint room
            V(173, 771, 194, 777),
            V(194, 765, 201, 768),
            V(194, 768, 198, 778),
            V(194, 778, 200, 798),

            -- Room west of waypoint
            V(158, 766, 167, 770),
            V(155, 771, 168, 774),
            V(155, 774, 165, 777),
            V(161, 776, 166, 782),
            V(161, 783, 166, 795),
            V(159, 763, 167, 765), -- The waterfall into The Mistake's room

            -- The Mistake's room
            V(184, 738, 190, 740),
            V(196, 737, 203, 740),
        },
        Fish = SEWER_FISHES,
    },
    {
        ID = "Arx.LowerSewers",
        NameHandle = T{
            Handle = "ha1711fa9g6162g4addgb7bfgd7e2b1b230c8",
            Text = "Sewers Lower Level",
        },
        LevelID = "ARX_Main",
        Bounds = V(370, 669, 519, 558),
        FishingAreas = {
            -- South near entrance
            V(463, 574, 469, 588),
            V(459, 582, 469, 588),
            V(454, 583, 455, 587),
            -- Gap in middle
            V(451, 592, 456, 596),
            V(456, 595, 459, 596),
            V(460, 596, 461, 600),
            -- North
            V(463, 599, 469, 612),

            -- Left of entrance
            V(446, 615, 454, 620),
            V(446, 602, 453, 612),
            V(437, 598, 449, 602),
            V(443, 596, 447, 597),

            -- Southwest waterfall
            V(414, 557, 421, 574),
            V(413, 575, 429, 588),

            -- Broken plank bridge near center
            V(420, 615, 437, 620),

            -- Far west
            V(375, 588, 388, 637),

            -- North of deathfog room
            V(388, 630, 421, 636),

            -- Trap room
            V(422, 627, 429, 641),
            V(439, 627, 443, 645),

            -- Sewer orphanage
            V(477, 618, 486, 627),
            V(477, 634, 491, 641),
            V(491, 615, 502, 629),
            V(503, 630, 520, 648),
            V(495, 646, 503, 665),
            V(472, 653, 515, 661),

            -- Spikes room
            V(462, 655, 470, 661),
            V(432, 653, 453, 660),
            V(439, 671, 445, 682),
            V(416, 654, 436, 659),
            V(414, 636, 421, 656),
            V(431, 646, 445, 655),
            V(406, 656, 413, 661),

            -- Northwest area, with the pillar bridge
            V(390, 636, 398, 661),
            V(399, 655, 407, 661),
        },
        Fish = SEWER_FISHES,
    },
    {
        ID = "Arx.IsbeilHideout",
        NameHandle = T{
            Handle = "hb0647507g26c5g4f6bg90ffg8c49f63ef0ec",
            Text = "Isbeil's Hideout",
        },
        LevelID = "ARX_Main",
        Bounds = V(257, 694, 323, 602),
        FishingAreas = {
            -- Bridge area
            V(254, 638, 286, 658),
            V(283, 648, 294, 659),
            V(303, 648, 337, 662),
        },
        Capacity = CAPACITY.MIDDLING,
        Fish = {
            {
                ID = "Sludge",
                Weight = 1,
            },
            {
                ID = "GripSlipper",
                Weight = 1,
            },
            {
                ID = "Mindflayer",
                Weight = 0.6,
            },
            {
                ID = "Head",
                Weight = 0.5,
            },
            {
                ID = "LightAtTheEnd",
                Weight = 0.4,
            },
        },
    },
    {
        ID = "Arx.Cathedral",
        NameHandle = T{
            Handle = "hc65bcb04g6710g422eg879cg5210e943749c",
            Text = "Cathedral Path of Blood",
        },
        LevelID = "ARX_Main",
        Bounds = V(281, 493, 321, 436),
        Capacity = CAPACITY.LOW,
        Fish = {
            {
                ID = "Petri",
                Weight = 1,
            },
            {
                ID = "TorrentedSoul",
                Weight = 0.5,
            },
            {
                ID = "Fetish",
                Weight = 0.5,
            },
            {
                ID = "LightAtTheEnd",
                Weight = 0.3,
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