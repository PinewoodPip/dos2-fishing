
local V = Vector.Create

local Fishing = GetFeature("Fishing")
local CAPACITIES = Fishing.REGION_CAPACITIES

---Utility method to register translated strings for a region.
local T = function(tsk)
    local tskEntry = Fishing:RegisterTranslatedString(tsk)
    tskEntry.ContextDescription = "Fishing region name"
    return tskEntry.Handle
end

-- Note: starting regions have more fish so the player doesn't hit a "wall" quickly when starting out (also, bait is not easily available at that point)

---@type Fishing.Region[]
local regions = {
    {
        ID = "FJ.StartingBeach",
        NameHandle = "h5ad7c407g7364g4a4dg9ca4g07ee2b7d9e5e", -- "Fort Joy Beach"
        LevelID = "FJ_FortJoy_Main",
        Bounds = Vector.Create(128, 410, 228, 189),
        Capacity = CAPACITIES.HIGH,
        Fish = {
            {
                ID = "Porgy",
                Weight = 1,
            },
            {
                ID = "Sardine",
                Weight = 0.9,
            },
            {
                ID = "NormieShell",
                Weight = 0.8,
            },
            {
                ID = "Starfish",
                Weight = 0.7,
            },
            {
                ID = "Seaweed",
                Weight = 0.4,
            },
        },
    },
    {
        ID = "FJ.PrisonerArea",
        NameHandle = "h5905ab33g01d7g41f4g81a3ge0a71e0c3e71", -- "Fort Joy Ghetto"
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(83, 257, 291, 52),
        Capacity = CAPACITIES.HIGH,
        Fish = {
            {
                ID = "Porgy",
                Weight = 1,
            },
            {
                ID = "Scarf",
                Weight = 0.9,
            },
            {
                ID = "SpikyConch",
                Weight = 0.8,
            },
            {
                ID = "Piranha",
                Weight = 0.7,
            },
            {
                ID = "Socks",
                Weight = 0.5,
            },
            {
                ID = "SeabedRoll",
                Weight = 0.5,
            },
        },
    },
    {
        ID = "FJ.TurtleBeach",
        NameHandle = T{
            Handle = "h1e1ff28fgd6e3g4cd1ga1f4gbbd6a8cbdee5",
            Text = "Turtle Beach",
        },
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(218, 416, 324, 341),
        Capacity = CAPACITIES.MIDDLING,
        Fish = {
            {
                ID = "BlueShell",
                Weight = 1,
            },
            {
                ID = "Piranha",
                Weight = 0.8,
            },
            {
                ID = "BranchingCoral",
                Weight = 0.7,
            },
            {
                ID = "PearlClam",
                Weight = 0.5,
            },
            {
                ID = "Seaweed",
                Weight = 0.4,
            },
        },
    },
    {
        ID = "FJ.NorthCoast",
        NameHandle = T{
            Handle = "hbcd49682g59ffg4360gad84g80dbac535327",
            Text = "Reaper's Eye North Coast",
        },
        LevelID = "FJ_FortJoy_Main",
        Priority = 2, -- Needs to be higher than starting beach.
        Bounds = V(285, 341, 664, 220),
        Capacity = CAPACITIES.HIGH,
        Fish = {
            {
                ID = "Piranha",
                Weight = 1,
            },
            {
                ID = "Dandelion",
                Weight = 0.9,
            },
            {
                ID = "SeaPickle",
                Weight = 0.6,
            },
            {
                ID = "Pufferfish",
                Weight = 0.6,
            },
            {
                ID = "SharkTooth",
                Weight = 0.4,
            },
        },
    },
    {
        ID = "FJ.SouthCoast",
        NameHandle = T{
            Handle = "h9ce681a2g7903g4b2dg9dbag30d502fbffc5",
            Text = "Reaper's Eye South Coast",
        },
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(303, 120, 591, 5),
        Fish = {
            {
                ID = "SeaPickle",
                Weight = 1,
            },
            {
                ID = "Aldrovanda",
                Weight = 0.8,
            },
            {
                ID = "Corncomber",
                Weight = 0.7,
            },
            {
                ID = "GoldenShell",
                Weight = 0.5,
            },
            {
                ID = "Seaweed",
                Weight = 0.4,
            },
        },
    },
    {
        ID = "FJ.AmadiaSanctuary",
        NameHandle = "h37c1b298ge94ag4dd4gad32g7550e1c3ff80", -- "Amadia's Sanctuary"
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(419, 41, 434, 12),
        Priority = 99,
        Capacity = CAPACITIES.LOW,
        Fish = {
            {
                ID = "NonFineChina",
                Weight = 1,
            },
            {
                ID = "Pearl",
                Weight = 0.5,
            },
            {
                ID = "WashedPanties",
                Weight = 0.3,
            },
            {
                ID = "GoldenShell",
                Weight = 0.8,
            },
        },
    },
    {
        ID = "FJ.DragonBeach",
        NameHandle = T{
            Handle = "h986f9d16g0f55g4cdfg99c4gb315a2cb11c8",
            Text = "Reaper's Eye Dragon Beach",
        },
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(533, 209, 608, 86),
        Capacity = CAPACITIES.MIDDLING,
        Fish = {
            {
                ID = "Gooseberry",
                Weight = 1,
            },
            {
                ID = "Pomfret",
                Weight = 0.8,
            },
            {
                ID = "MoonJelly",
                Weight = 0.8,
            },
            {
                ID = "CrystalCoral",
                Weight = 0.7,
            },
        },
    },
    {
        ID = "FJ.FortDungeons",
        NameHandle = T{
            Handle = "h03918ca1gd68dg42feg8b77g83cd47baf6f7",
            Text = "Fort Joy Dungeons",
        },
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(308, 597, 327, 567),
        Capacity = CAPACITIES.LOW,
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
                ID = "TorrentedSoul",
                Weight = 0.8,
            },
            {
                ID = "DescentKey",
                Weight = 0.15,
            },
        },
    },
    {
        ID = "FJ.RadekaCave",
        NameHandle = T{
            Handle = "haf573039gb7dfg4b7cg87f2gadce781be86b",
            Text = "Radeka's Cave",
        },
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(672, 668, 720, 581),
        FishingAreas = {
            V(703, 601, 710, 634), -- River to the left when entering Radeka's area (the other side of the river is unreachable)
        },
        Capacity = CAPACITIES.LOW,
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
        NameHandle = T{
            Handle = "hb4f45e86gc7b3g4b48gad92g1d87b34e992b",
            Text = "Frog Cave",
        },
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(474, 580, 550, 471),
        Capacity = CAPACITIES.MIDDLING,
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
                ID = "Moss",
                Weight = 1,
            },
            {
                ID = "Frog",
                Weight = 0.9,
            },
            {
                ID = "Handkerchief",
                Weight = 0.8,
            },
            {
                ID = "DarkConch",
                Weight = 0.5,
            },
            {
                ID = "FidgetSpinner",
                Weight = 0.2,
            },
        },
    },
    {
        ID = "FJ.WithermooreCave",
        NameHandle = T{
            Handle = "h46b7ca32gfcdbg456eg93ffga0cbc8c70abb",
            Text = "Withermoore's Hideout",
        },
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(489, 670, 499, 630),
        FishingAreas = {
            V(487, 657, 491, 662), -- Waterfall
            V(497, 656, 503, 661), -- East from the bridge
            V(499, 637, 507, 654), -- East of chest
            V(490, 627, 506, 637), -- South
        },
        Capacity = CAPACITIES.MIDDLING,
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
        NameHandle = "h4bec762bge675g4296g9277g18dc2b1b370f", -- "The Hollow Marshes"
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(312, 237, 511, 130),
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
                ID = "WaspNest",
                Weight = 0.6,
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
        },
    },
    {
        ID = "FJ.FortBridge", -- The drawbridge, specifically.
        NameHandle = T{
            Handle = "hd37c6a61g2417g4310g80dbg4bc75ae29926",
            Text = "Fort Joy Drawbridge",
        },
        Priority = 99, -- Needs to be higher priority than swamp.
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(320, 216, 340, 169),
        FishingAreas = {
            V(322, 170, 337, 201), -- Drawbridge area
            V(328, 201, 338, 207), -- North of drawbridge, near the workshop
        },
        Capacity = CAPACITIES.LOW,
        Fish = {
            {
                ID = "Scarf",
                Weight = 1,
            },
            {
                ID = "Moss",
                Weight = 1,
            },
            {
                ID = "Pitcher",
                Weight = 0.4,
            },
            {
                ID = "MessagelessBottle",
                Weight = 0.3,
            },
        },
    },
    {
        ID = "FJ.BrahmosDesert", -- No idea if this area is actually playable lmao, so don't put unique fish there
        IsSecret = true,
        NameHandle = T{
            Handle = "h69c87adfg0526g4156g8576gb1eb82c20827",
            Text = "Brahmos's Dream",
        },
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(156, 505, 195, 486),
        RequiresWater = true,
        Capacity = CAPACITIES.LOW, -- This is mostly a joke region, we don't want players to feel the need to spend much time here
        Fish = {
            {
                ID = "GoldenShell",
                Weight = 1,
            },
            {
                ID = "PyrokineticSnapper",
                Weight = 0.6,
            },
        },
    },
    {
        ID = "FJ.BraccusTower",
        NameHandle = "h4118bd9ag21f5g4f69gba96ge85d123247a7", -- "Braccus Rex's Tower"
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(578, 689, 638, 595),
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
        NameHandle = T{
            Handle = "h460592c3gafc1g42bbga416ga7f89e03e513",
            Text = "Braccus Rex's Tower Well",
        },
        LevelID = "FJ_FortJoy_Main",
        Priority = 99,
        Bounds = V(634, 650, 639, 645),
        FishingAreas = {
            V(634, 645, 639, 650),
        },
        Capacity = CAPACITIES.MIDDLING, -- Perhaps I'm being too generous with this one...
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
        NameHandle = T{
            Handle = "h46951bebg94c9g489cgaf5cga49af70fd335",
            Text = "Trompdoy's Cave",
        },
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(550, 564, 696, 462),
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
        Capacity = CAPACITIES.MIDDLING,
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
        NameHandle = T{
            Handle = "h23492074g54bcg4551g95ffg52c51c35709c",
            Text = "Braccus's Labyrinth Lava Portal",
        },
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(405, 506, 446, 454),
        FishingAreas = {
            V(417, 454, 430, 490), -- Middle

            -- Northeast
            V(437, 480, 444, 498),
            V(427, 487, 443, 498),

            V(428, 458, 449, 473), -- Southeast
            V(437, 475, 448, 497), -- Northeast
        },
        Capacity = CAPACITIES.LOW,
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
                ID = "PyrokineticSnapper",
                Weight = 0.7,
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
        NameHandle = "h85912bb6g7e2bg40fcg9b85g0d2f2b274964", -- "Braccus's Armoury"
        LevelID = "FJ_FortJoy_Main",
        Bounds = V(328, 482, 338, 476),
        FishingAreas = {
            V(331, 478, 335, 482),
        },
        Capacity = CAPACITIES.LOW,
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