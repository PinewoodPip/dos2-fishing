
local V = Vector.Create

local Fishing = Epip.GetFeature("Features.Fishing")

---Utility method to register translated strings for a region.
local T = function(tsk)
    local tskEntry = Fishing:RegisterTranslatedString(tsk)
    tskEntry.ContextDescription = "Fishing region name"
    return tskEntry.Handle
end


---@type Features.Fishing.Region[]
local regions = {
    {
        ID = "CoS.NorthCoast",
        NameHandle = T{
            Handle = "h120b0697ge5aag4425gb670g849d10ea7cd9",
            Text = "Nameless Isle North Coast",
        },
        LevelID = "CoS_Main",
        Bounds = V(55, 1005, 349, 929),
        Fish = {
            {
                ID = "Riftling",
                Weight = 1,
            },
            {
                ID = "Moss",
                Weight = 0.8,
            },
            {
                ID = "Hurchin",
                Weight = 0.8,
            },
            {
                ID = "BladeFish",
                Weight = 0.6,
            },
            {
                ID = "SharkTooth",
                Weight = 0.6,
            },
            {
                ID = "AxeHead",
                Weight = 0.5,
            },
            {
                ID = "LavoodooDoll",
                Weight = 0.4,
            },
            {
                ID = "Fetish",
                Weight = 0.4,
            },
        },
    },
    -- TODO! This are needs to only be conditionally available
    -- {
    --     ID = "CoS.WaterPortal",
    --     NameHandle = T{
    --         Handle = "h54a1bd55g543dg4b3fga61eg56c937bc81df",
    --         Text = "Nameless Isle Water Temple",
    --     },
    --     LevelID = "CoS_Main",
    --     Bounds = V(104, 923, 146, 870),
    --     FishingAreas = {
    --     },
    --     Fish = {
    --     },
    -- },
    {
        ID = "CoS.WestCoast",
        NameHandle = T{
            Handle = "hb04e74b3gfff8g490fgb656g0f71f0ae5b88",
            Text = "Nameless Isle West Coast",
        },
        LevelID = "CoS_Main",
        Bounds = V(33, 922, 94, 782),
        Fish = {
            {
                ID = "Aldrovanda",
                Weight = 1,
            },
            {
                ID = "BlueShell",
                Weight = 1,
            },
            {
                ID = "PolyamorousTrout",
                Weight = 1,
            },
            {
                ID = "Piranha",
                Weight = 0.8,
            },
            {
                ID = "Salt",
                Weight = 0.8,
            },
            {
                ID = "CrabClaw",
                Weight = 0.7,
            },
            {
                ID = "Petri",
                Weight = 0.5,
            },
        },
    },
    {
        ID = "CoS.SouthCoast",
        NameHandle = T{
            Handle = "h6d35e63ag700cg4b91g8fdbg6d64ada4e17d",
            Text = "Nameless Isle South Coast",
        },
        LevelID = "CoS_Main",
        FishableSurfaceType = "Lava",
        Bounds = V(88, 783, 316, 616),
        Fish = {
            {
                ID = "Blobfish",
                Weight = 1,
            },
            {
                ID = "HotShell",
                Weight = 1,
            },
            {
                ID = "FishBone",
                Weight = 1,
            },
            {
                ID = "DarkConch",
                Weight = 0.8,
            },
            {
                ID = "ReptileEgg",
                Weight = 0.4,
            },
            {
                ID = "NonFineChina",
                Weight = 0.4,
            },
        },
    },
    {
        ID = "CoS.LadyVengeance",
        NameHandle = T{
            Handle = "hbec6e4f2g031bg447cgbd3cg3795dc9be16c",
            Text = "Lady Vengeance (Nameless Isle sea)",
        },
        LevelID = "CoS_Main",
        Bounds = V(-32, 749, 29, 623),
        FishingAreas = {
            V(-40, 627, -22, 729), -- West
            V(-33, 616, 23, 638), -- South
            V(10, 620, 35, 732), -- East
        },
        Fish = {
            {
                ID = "Aldrovanda",
                Weight = 1,
            },
            {
                ID = "GilledMushroom",
                Weight = 1,
            },
            {
                ID = "Hurchin",
                Weight = 1,
            },
            {
                ID = "Piranha",
                Weight = 0.8,
            },
            {
                ID = "Salt",
                Weight = 0.8,
            },
            {
                ID = "CrabClaw",
                Weight = 0.7,
            },
        },
    },
    {
        ID = "CoS.VrogirEnclave",
        NameHandle = T{
            Handle = "h0329e50bgad93g4becg8cd2ga85c658359f8",
            Text = "Nameless Isle Temple of Vrogir",
        },
        LevelID = "CoS_Main",
        Bounds = V(255, 530, 387, 382), -- Note that this spawn 2 subregions.
        FishingAreas = {
            V(273, 477, 296, 488), -- Southwest hole
            V(272, 498, 321, 520), -- North hole
            -- East hole
            V(292, 470, 316, 485),
            V(304, 487, 314, 504),
        },
        Fish = {
            {
                ID = "LilyPad",
                Weight = 1,
            },
            {
                ID = "NonFineChina",
                Weight = 1,
            },
            {
                ID = "Aldrovanda",
                Weight = 0.8,
            },
            {
                ID = "SourceStarFish",
                Weight = 0.4,
            },
            {
                ID = "TemporalGear",
                Weight = 0.1,
            },
        },
    },
    {
        ID = "CoS.AcademyOfTheSeven",
        NameHandle = "h5ff3c6fbg31ceg4c43ga706ga49d9f56e5ec", -- "The Academy of the Seven"
        LevelID = "CoS_Main",
        FishableSurfaceType = "Source",
        FishingAreas = {
            V(563, 725, 572, 734), -- Source pool in the final area
        },
        Bounds = V(553, 739, 660, 584),
        Fish = {
            {
                ID = "SourceStarFish",
                Weight = 1,
            },
            {
                ID = "CrystalCoral",
                Weight = 0.7,
            },
            {
                ID = "TemporalGear",
                Weight = 0.1,
            },
        },
    },
    {
        ID = "CoS.MurkyCave",
        NameHandle = T{
            Handle = "ha1ec473fgbe2ag4291gb09fg77a60c691101",
            Text = "Nameless Isle Seaside Cave",
        },
        LevelID = "CoS_Main",
        Bounds = V(595, 292, 642, 212),
        FishingAreas = {
            V(620, 221, 626, 233), -- Southeast puddle
            V(605, 257, 624, 268), -- North puddle
            V(629, 248, 635, 263), -- Northeast puddle
            V(590, 280, 602, 287), -- North waterfall
            V(596, 228, 606, 236), -- Southwest puddle, very awkward spot
        },
        Fish = {
            {
                ID = "Hurchin",
                Weight = 1,
            },
            {
                ID = "Fetish",
                Weight = 0.4,
            },
            {
                ID = "MessagelessBottle",
                Weight = 0.2,
            },
        },
    },
    {
        ID = "CoS.SallowManCave",
        NameHandle = T{
            Handle = "hbd9945d0g2743g4033g9a45gf024804394d5",
            Text = "Nameless Isle Sallow Man's Hideout",
        },
        LevelID = "CoS_Main",
        Bounds = V(20, 318, 153, 187),
        FishableSurfaceType = "Lava",
        Fish = {
            {
                ID = "FishBone",
                Weight = 1,
            },
            {
                ID = "Mine",
                Weight = 0.8,
            },
            {
                ID = "Head",
                Weight = 0.6,
            },
            {
                ID = "LavoodooDoll",
                Weight = 0.6,
            },
            {
                ID = "Fetish",
                Weight = 0.4,
            },
            {
                ID = "ReptileEgg",
                Weight = 0.3,
            },
        },
    },
    {
        ID = "CoS.TempleOfDuna",
        NameHandle = T{
            Handle = "h55a0e39egdc2fg4695g8717g6c3d8510b0c4",
            Text = "Nameless Isle Temple of Duna",
        },
        LevelID = "CoS_Main",
        Bounds = V(478, 291, 538, 197),
        FishingAreas = {
            -- North
            V(488, 245, 507, 267),
            V(489, 265, 496, 277),

            -- South
            V(503, 196, 524, 203),
            V(509, 200, 516, 210),
        },
        Fish = {
            {
                ID = "FishBone",
                Weight = 1,
            },
            {
                ID = "Fetish",
                Weight = 0.4,
            },
            {
                ID = "ReptileEgg",
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