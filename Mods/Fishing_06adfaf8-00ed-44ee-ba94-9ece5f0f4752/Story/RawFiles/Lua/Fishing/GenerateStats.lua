
---------------------------------------------
-- Utility script to generate the stats files for fishes & their runes.
-- If modding, there's no need to fiddle with this, instead overwrite the stats objects as usual.
---------------------------------------------

local Fishing = Epip.GetFeature("Features.Fishing")

local MAX_RUNE_TIER = 3

---Map of fishes to their rune stat boosts.
---@type table<string, table<1|2|3, StatsLib_StatsEntry_Armor>>
local STAT_BOOSTS = {
    ["NormieShell"] = {
        [1] = {
            ["VitalityBoost"] = 4,
        },
        [2] = {
            ["VitalityBoost"] = 9,
        },
        [3] = {
            ["VitalityBoost"] = 17,
        },
    },
    ["BlueShell"] = {
        [1] = {
            ["WaterSpecialist"] = 1,
            ["Water"] = 5,
        },
        [2] = {
            ["WaterSpecialist"] = 2,
            ["Water"] = 10,
        },
        [3] = {
            ["WaterSpecialist"] = 3,
            ["Water"] = 15,
        },
    },
    ["Handkerchief"] = {
        [1] = {
            ["DodgeBoost"] = 3,
            ["Movement"] = 5,
        },
        [2] = {
            ["DodgeBoost"] = 7,
            ["Movement"] = 15,
        },
        [3] = {
            ["DodgeBoost"] = 12,
            ["Movement"] = 24,
        },
    },
    ["Scarf"] = {
        [1] = {
            ["Sneaking"] = 1,
            ["Movement"] = 10,
        },
        [2] = {
            ["Sneaking"] = 2,
            ["Movement"] = 20,
        },
        [3] = {
            ["Sneaking"] = 4,
            ["Movement"] = 40,
        },
    },
    ["BranchingCoral"] = {
        [1] = {
            ["Summoning"] = 1,
            ["Water"] = 3,
        },
        [2] = {
            ["Summoning"] = 2,
            ["Water"] = 7,
        },
        [3] = {
            ["Summoning"] = 3,
            ["Water"] = 15,
        },
    },
    ["PearlClam"] = {
        [1] = {
            ["Barter"] = 1,
        },
        [2] = {
            ["Barter"] = 2,
            ["Luck"] = 1,
        },
        [3] = {
            ["Barter"] = 3,
            ["Luck"] = 2,
        },
    },
    ["Starfish"] = {
        [1] = {
            ["VitalityBoost"] = 2,
            ["Perseverance"] = 1,
        },
        [2] = {
            ["VitalityBoost"] = 5,
            ["Perseverance"] = 2,
        },
        [3] = {
            ["VitalityBoost"] = 10,
            ["Perseverance"] = 3,
        },
    },
    ["SpikyConch"] = {
        [1] = {
            ["PainReflection"] = 1,
            ["Physical"] = 3,
        },
        [2] = {
            ["PainReflection"] = 2,
            ["Physical"] = 6,
        },
        [3] = {
            ["PainReflection"] = 4,
            ["Physical"] = 10,
        },
    },
    ["WashedPanties"] = {
        [1] = {
            ["SingleHanded"] = 1,
            ["Luck"] = 1,
        },
        [2] = {
            ["SingleHanded"] = 2,
            ["Luck"] = 1,
        },
        [3] = {
            ["SingleHanded"] = 4,
            ["Luck"] = 2,
        },
    },
    ["Pearl"] = {
        [1] = {
            ["Barter"] = 1,
            ["WitsBoost"] = 1,
        },
        [2] = {
            ["Barter"] = 2,
            ["WitsBoost"] = 2,
        },
        [3] = {
            ["Barter"] = 3,
            ["WitsBoost"] = 3,
        },
    },
    ["FishBone"] = {
        [1] = {
            ["Necromancy"] = 1,
            ["VitalityBoost"] = 5,
        },
        [2] = {
            ["Necromancy"] = 2,
            ["VitalityBoost"] = 10,
        },
        [3] = {
            ["Necromancy"] = 3,
            ["VitalityBoost"] = 15,
        },
    },
    ["Socks"] = {
        [1] = {
            ["EarthSpecialist"] = 1,
            ["Earth"] = 5,
        },
        [2] = {
            ["EarthSpecialist"] = 2,
            ["Earth"] = 9,
        },
        [3] = {
            ["EarthSpecialist"] = 3,
            ["Earth"] = 15,
        },
    },
    ["CrystalCoral"] = {
        [1] = {
            ["MagicArmorBoost"] = 10,
            ["IntelligenceBoost"] = 3,
        },
        [2] = {
            ["MagicArmorBoost"] = 20,
            ["IntelligenceBoost"] = 5,
        },
        [3] = {
            ["MagicArmorBoost"] = 40,
            ["IntelligenceBoost"] = 10,
        },
    },
    ["NonFineChina"] = {
        [1] = {
            ["Thievery"] = 1,
            ["Perseverance"] = 1,
        },
        [2] = {
            ["Thievery"] = 2,
            ["Perseverance"] = 2,
        },
        [3] = {
            ["Thievery"] = 3,
            ["Perseverance"] = 3,
            ["Flags"] = "Unrepairable",
        },
    },
    ["Corncomber"] = {
        [1] = {
            ["AccuracyBoost"] = 6,
        },
        [2] = {
            ["AccuracyBoost"] = 12,
        },
        [3] = {
            ["AccuracyBoost"] = 17,
            ["Flags"] = "AcidImmunity",
        },
    },
    ["MoonJelly"] = {
        [1] = {
            ["MemoryBoost"] = 3,
            ["Flags"] = "PoisonContact",
        },
        [2] = {
            ["MemoryBoost"] = 5,
            ["Flags"] = "PoisonContact",
        },
        [3] = {
            ["MemoryBoost"] = 10,
            ["Flags"] = "PoisonContact",
        },
    },
    ["Gooseberry"] = {
        [1] = {
            ["Poison"] = 6,
            ["APMaximum"] = 1,
        },
        [2] = {
            ["Poison"] = 12,
            ["APMaximum"] = 2,
        },
        [3] = {
            ["Poison"] = 19,
            ["APMaximum"] = 3,
        },
    },
    ["DescentKey"] = {
        [1] = {
            ["Initiative"] = 5,
            ["Leadership"] = 1,
            ["Sourcery"] = 1,
        },
        [2] = {
            ["Initiative"] = 10,
            ["Leadership"] = 2,
            ["Sourcery"] = 2,
        },
        [3] = {
            ["Initiative"] = 15,
            ["Leadership"] = 3,
            ["Sourcery"] = 3,
        },
    },
    ["GoldenShell"] = {
        [1] = {
            ["FireSpecialist"] = 1,
            ["Fire"] = 7,
        },
        [2] = {
            ["FireSpecialist"] = 2,
            ["Fire"] = 14,
        },
        [3] = {
            ["FireSpecialist"] = 3,
            ["Fire"] = 19,
            ["Flags"] = "BurnImmunity",
        },
    },
    ["SeaPickle"] = {
        [1] = {
            ["Water"] = 4,
            ["Poison"] = 6,
        },
        [2] = {
            ["Water"] = 8,
            ["Poison"] = 14,
        },
        [3] = {
            ["Water"] = 12,
            ["Poison"] = 20,
        },
    },
    ["Seaweed"] = {
        [1] = {
            ["APStart"] = 1,
        },
        [2] = {
            ["APStart"] = 2,
        },
        [3] = {
            ["APStart"] = 3,
            ["APMaximum"] = 1,
        },
    },
    ["SeabedRoll"] = {
        [1] = {
            ["ConstitutionBoost"] = 1,
        },
        [2] = {
            ["ConstitutionBoost"] = 2,
        },
        [3] = {
            ["ConstitutionBoost"] = 3,
            ["Flags"] = "SleepingImmunity",
        },
    },
    ["TorrentedSoul"] = {
        [1] = {
            ["Necromancy"] = 1,
            ["Perseverance"] = 1,
        },
        [2] = {
            ["Necromancy"] = 2,
            ["Perseverance"] = 2,
        },
        [3] = {
            ["Necromancy"] = 3,
            ["Perseverance"] = 3,
        },
    },
    ["WaspNest"] = {
        [1] = {
            ["Ranged"] = 1,
            ["Initiative"] = 2,
        },
        [2] = {
            ["Ranged"] = 2,
            ["Initiative"] = 4,
        },
        [3] = {
            ["Ranged"] = 3,
            ["Initiative"] = 7,
        },
    },
    ["CrabClaw"] = {
        [1] = {
            ["TwoHanded"] = 1,
            ["StrengthBoost"] = 2,
        },
        [2] = {
            ["TwoHanded"] = 2,
            ["StrengthBoost"] = 4,
        },
        [3] = {
            ["TwoHanded"] = 3,
            ["StrengthBoost"] = 7,
        },
    },
    ["Bucket"] = {
        [1] = {
            ["WaterSpecialist"] = 1,
            ["MemoryBoost"] = 1,
        },
        [2] = {
            ["WaterSpecialist"] = 2,
            ["MemoryBoost"] = 3,
        },
        [3] = {
            ["WaterSpecialist"] = 3,
            ["MemoryBoost"] = 5,
        },
    },
    ["LilyPad"] = {
        [1] = {
            ["AccuracyBoost"] = 4,
            ["Movement"] = 8,
        },
        [2] = {
            ["AccuracyBoost"] = 7,
            ["Movement"] = 16,
        },
        [3] = {
            ["AccuracyBoost"] = 15,
            ["Movement"] = 25,
            ["Flags"] = "DiseasedImmunity",
        },
    },
    ["Aldrovanda"] = {
        [1] = {
            ["EarthSpecialist"] = 1,
            ["Perseverance"] = 1,
        },
        [2] = {
            ["EarthSpecialist"] = 2,
            ["Perseverance"] = 2,
        },
        [3] = {
            ["EarthSpecialist"] = 3,
            ["Perseverance"] = 3,
        },
    },
    ["Blobfish"] = {
        [1] = {
            ["Polymorph"] = 1,
            ["SingleHanded"] = 1,
        },
        [2] = {
            ["Polymorph"] = 2,
            ["SingleHanded"] = 2,
        },
        [3] = {
            ["Polymorph"] = 3,
            ["SingleHanded"] = 3,
        },
    },
    ["AxeHead"] = {
        [1] = {
            ["TwoHanded"] = 1,
            ["StrengthBoost"] = 2,
        },
        [2] = {
            ["TwoHanded"] = 2,
            ["StrengthBoost"] = 4,
        },
        [3] = {
            ["TwoHanded"] = 3,
            ["StrengthBoost"] = 7,
        },
    },
    ["Fetish"] = {
        [1] = {
            ["Summoning"] = 1,
            ["CriticalChance"] = 3,
        },
        [2] = {
            ["Summoning"] = 2,
            ["CriticalChance"] = 7,
        },
        [3] = {
            ["Summoning"] = 3,
            ["CriticalChance"] = 12,
        },
    },
    ["Painting"] = {
        [1] = {
            ["Persuasion"] = 1,
            ["Barter"] = 1,
        },
        [2] = {
            ["Persuasion"] = 2,
            ["Barter"] = 2,
        },
        [3] = {
            ["Persuasion"] = 3,
            ["Barter"] = 3,
        },
    },
    ["Head"] = {
        [1] = {
            ["Necromancy"] = 2,
            ["VitalityBoost"] = -10,
        },
        [2] = {
            ["Necromancy"] = 4,
            ["VitalityBoost"] = -24,
        },
        [3] = {
            ["Necromancy"] = 6,
            ["VitalityBoost"] = -45,
            ["Flags"] = "MadnessImmunity"
        },
    },
    ["FloodRose"] = {
        [1] = {
            ["WaterSpecialist"] = 1,
            ["WitsBoost"] = 3,
        },
        [2] = {
            ["WaterSpecialist"] = 2,
            ["WitsBoost"] = 6,
        },
        [3] = {
            ["WaterSpecialist"] = 3,
            ["WitsBoost"] = 9,
        },
    },
    ["Salt"] = {
        [1] = {
            ["Physical"] = 3,
            ["Piercing"] = 3,
        },
        [2] = {
            ["Physical"] = 6,
            ["Piercing"] = 6,
        },
        [3] = {
            ["Physical"] = 9,
            ["Piercing"] = 9,
        },
    },
    ["MessagelessBottle"] = {
        [1] = {
            ["MemoryBoost"] = 3,
            ["WitsBoost"] = 3,
        },
        [2] = {
            ["MemoryBoost"] = 6,
            ["WitsBoost"] = 6,
        },
        [3] = {
            ["MemoryBoost"] = 9,
            ["WitsBoost"] = 9,
        },
    },
    ["Mine"] = {
        [1] = {
            ["FireSpecialist"] = 1,
            ["Initiative"] = 4,
        },
        [2] = {
            ["FireSpecialist"] = 2,
            ["Initiative"] = 8,
        },
        [3] = {
            ["FireSpecialist"] = 3,
            ["Initiative"] = 12,
        },
    },
    ["Soap"] = {
        [1] = {
            ["Water"] = 5,
        },
        [2] = {
            ["Water"] = 9,
        },
        [3] = {
            ["Water"] = 14,
            ["Flags"] = "PoisonImmunity",
        },
    },
    ["SharkTooth"] = {
        [1] = {
            ["SingleHanded"] = 1,
            ["StrengthBoost"] = 3,
        },
        [2] = {
            ["SingleHanded"] = 2,
            ["StrengthBoost"] = 6,
        },
        [3] = {
            ["SingleHanded"] = 3,
            ["StrengthBoost"] = 9,
        },
    },
    ["WaterRing"] = {
        [1] = {
            ["WaterSpecialist"] = 2,
            ["MagicArmorBoost"] = 15,
        },
        [2] = {
            ["WaterSpecialist"] = 3,
            ["MagicArmorBoost"] = 30,
        },
        [3] = {
            ["WaterSpecialist"] = 4,
            ["MagicArmorBoost"] = 50,
        },
    },
    ["SeaPork"] = {
        [1] = {
            ["Earth"] = 5,
            ["FinesseBoost"] = 3,
        },
        [2] = {
            ["Earth"] = 8,
            ["FinesseBoost"] = 5,
        },
        [3] = {
            ["Earth"] = 13,
            ["FinesseBoost"] = 7,
        },
    },
    ["Quiver"] = {
        [1] = {
            ["Ranged"] = 1,
            ["FinesseBoost"] = 3,
        },
        [2] = {
            ["Ranged"] = 2,
            ["FinesseBoost"] = 5,
        },
        [3] = {
            ["Ranged"] = 3,
            ["FinesseBoost"] = 8,
        },
    },
    ["Starstone"] = {
        [1] = {
            ["IntelligenceBoost"] = 5,
        },
        [2] = {
            ["IntelligenceBoost"] = 10,
        },
        [3] = {
            ["IntelligenceBoost"] = 15,
        },
    },
    ["BuffaloAmulet"] = {
        [1] = {
            ["Leadership"] = 1,
            ["StrengthBoost"] = 3,
        },
        [2] = {
            ["Leadership"] = 2,
            ["StrengthBoost"] = 6,
        },
        [3] = {
            ["Leadership"] = 3,
            ["StrengthBoost"] = 9,
        },
    },
    ["Dandelion"] = {
        [1] = {
            ["AirSpecialist"] = 1,
            ["Movement"] = 10,
        },
        [2] = {
            ["AirSpecialist"] = 2,
            ["Movement"] = 20,
        },
        [3] = {
            ["AirSpecialist"] = 3,
            ["Movement"] = 30,
        },
    },
    ["TemporalGear"] = {
        [1] = {
            ["RogueLore"] = 1,
            ["WitsBoost"] = 3,
        },
        [2] = {
            ["RogueLore"] = 2,
            ["WitsBoost"] = 6,
        },
        [3] = {
            ["RogueLore"] = 3,
            ["WitsBoost"] = 9,
        },
    },
    ["Moss"] = {
        [1] = {
            ["EarthSpecialist"] = 1,
            ["Sneaking"] = 1,
        },
        [2] = {
            ["EarthSpecialist"] = 2,
            ["Sneaking"] = 2,
        },
        [3] = {
            ["EarthSpecialist"] = 3,
            ["Sneaking"] = 3,
        },
    },
    ["ZandalorTrunks"] = {
        [1] = {
            ["Telekinesis"] = 1,
            ["IntelligenceBoost"] = 1,
        },
        [2] = {
            ["Telekinesis"] = 2,
            ["IntelligenceBoost"] = 3,
        },
        [3] = {
            ["Telekinesis"] = 3,
            ["IntelligenceBoost"] = 5,
            ["Flags"] = "ClairvoyantImmunity",
        },
    },
    ["SourceStarFish"] = {
        [1] = {
            ["Sourcery"] = 1,
            ["Reflection"] = "20:Air:melee",
        },
        [2] = {
            ["Sourcery"] = 2,
            ["Reflection"] = "40:Air:melee",
        },
        [3] = {
            ["Sourcery"] = 3,
            ["Reflection"] = "60:Air:melee",
        },
    },
    ["LavoodooDoll"] = {
        [1] = {
            ["DualWielding"] = 1,
        },
        [2] = {
            ["DualWielding"] = 2,
        },
        [3] = {
            ["DualWielding"] = 3,
        },
    },
    ["Hurchin"] = {
        [1] = {
            ["PainReflection"] = 2,
            ["Piercing"] = 5,
        },
        [2] = {
            ["PainReflection"] = 4,
            ["Piercing"] = 10,
        },
        [3] = {
            ["PainReflection"] = 6,
            ["Piercing"] = 15,
        },
    },
    ["Anglerfish"] = {
        [1] = {
            ["Ranged"] = 1,
        },
        [2] = {
            ["Ranged"] = 2,
        },
        [3] = {
            ["Ranged"] = 3,
        },
    },
    ["BladeFish"] = {
        [1] = {
            ["WarriorLore"] = 1,
            ["FinesseBoost"] = 3,
        },
        [2] = {
            ["WarriorLore"] = 2,
            ["FinesseBoost"] = 6,
        },
        [3] = {
            ["WarriorLore"] = 3,
            ["FinesseBoost"] = 9,
        },
    },
    ["Epipe"] = {
        [1] = {
            ["Repair"] = 1,
            ["MemoryBoost"] = 3,
        },
        [2] = {
            ["Repair"] = 2,
            ["MemoryBoost"] = 6,
        },
        [3] = {
            ["Repair"] = 3,
            ["MemoryBoost"] = 9,
            ["ExtraProperties"] = "SELF:ONEQUIP:CLEAR_MINDED",
        },
    },
    ["ModSettingsMenu"] = {
        [1] = {
            ["MemoryBoost"] = 1,
            ["Earth"] = 5,
        },
        [2] = {
            ["MemoryBoost"] = 2,
            ["Earth"] = 10,
        },
        [3] = {
            ["MemoryBoost"] = 3,
            ["Earth"] = 15,
        },
    },
    ["Frog"] = {
        [1] = {
            ["Water"] = 4,
            ["Earth"] = 4,
        },
        [2] = {
            ["Water"] = 8,
            ["Earth"] = 8,
        },
        [3] = {
            ["Water"] = 12,
            ["Earth"] = 12,
        },
    },
    ["FidgetSpinner"] = {
        [1] = {
            ["RogueLore"] = 1,
            ["FinesseBoost"] = 3,
        },
        [2] = {
            ["RogueLore"] = 2,
            ["FinesseBoost"] = 6,
        },
        [3] = {
            ["RogueLore"] = 3,
            ["FinesseBoost"] = 9,
        },
    },
    ["GilledMushroom"] = {
        [1] = {
            ["EarthSpecialist"] = 1,
            ["Poison"] = 5,
        },
        [2] = {
            ["EarthSpecialist"] = 2,
            ["Poison"] = 10,
        },
        [3] = {
            ["EarthSpecialist"] = 3,
            ["Poison"] = 15,
        },
    },
    ["LetterOfWill"] = {
        [1] = {
            ["Persuasion"] = 1,
            ["MemoryBoost"] = 3,
        },
        [2] = {
            ["Persuasion"] = 2,
            ["MemoryBoost"] = 6,
        },
        [3] = {
            ["Persuasion"] = 3,
            ["MemoryBoost"] = 9,
        },
    },
    ["Pomfret"] = {
        [1] = {
            ["Water"] = 4,
            ["FinesseBoost"] = 1,
        },
        [2] = {
            ["Water"] = 7,
            ["FinesseBoost"] = 2,
        },
        [3] = {
            ["Water"] = 10,
            ["FinesseBoost"] = 3,
        },
    },
    ["PolyamorousTrout"] = {
        [1] = {
            ["Polymorph"] = 1,
        },
        [2] = {
            ["Polymorph"] = 2,
        },
        [3] = {
            ["Polymorph"] = 3,
        },
    },
    ["ProperSeafarer"] = {
        [1] = {
            ["Leadership"] = 1,
            ["Perseverance"] = 1,
        },
        [2] = {
            ["Leadership"] = 2,
            ["Perseverance"] = 2,
        },
        [3] = {
            ["Leadership"] = 3,
            ["Perseverance"] = 3,
        },
    },
    ["SmallShip"] = {
        [1] = {
            ["Movement"] = 8,
            ["FinesseBoost"] = 2,
        },
        [2] = {
            ["Movement"] = 16,
            ["FinesseBoost"] = 4,
        },
        [3] = {
            ["Movement"] = 32,
            ["FinesseBoost"] = 6,
        },
    },
    ["Pitcher"] = {
        [1] = {
            ["Water"] = 7,
        },
        [2] = {
            ["Water"] = 13,
        },
        [3] = {
            ["Water"] = 19,
        },
    },
    ["PremoldedCheese"] = {
        [1] = {
            ["ConstitutionBoost"] = 1,
            ["Poison"] = 9,
        },
        [2] = {
            ["ConstitutionBoost"] = 2,
            ["Poison"] = 15,
        },
        [3] = {
            ["ConstitutionBoost"] = 3,
            ["Poison"] = 25,
        },
    },
    ["PotLid"] = {
        [1] = {
            ["ArmorBoost"] = 15,
        },
        [2] = {
            ["ArmorBoost"] = 25,
        },
        [3] = {
            ["ArmorBoost"] = 50,
            ["Flags"] = "DisarmedImmunity",
        },
    },
    ["Riftling"] = {
        [1] = {
            ["Summoning"] = 1,
        },
        [2] = {
            ["Summoning"] = 2,
        },
        [3] = {
            ["Summoning"] = 3,
        },
    },
    ["Pufferfish"] = {
        [1] = {
            ["Reflection"] = "30:Poison:melee",
        },
        [2] = {
            ["Reflection"] = "50:Poison:melee",
        },
        [3] = {
            ["Reflection"] = "70:Poison:melee",
        },
    },
    ["ReptileEgg"] = {
        [1] = {
            ["Fire"] = 4,
        },
        [2] = {
            ["Fire"] = 8,
        },
        [3] = {
            ["Fire"] = 12,
        },
    },
    ["Piranha"] = {
        [1] = {
            ["Ranged"] = 1,
            ["Initiative"] = 4,
        },
        [2] = {
            ["Ranged"] = 2,
            ["Initiative"] = 8,
        },
        [3] = {
            ["Ranged"] = 3,
            ["Initiative"] = 12,
        },
    },
    ["Porgy"] = {
        [1] = {
            ["VitalityBoost"] = 4,
        },
        [2] = {
            ["VitalityBoost"] = 6,
        },
        [3] = {
            ["VitalityBoost"] = 12,
        },
    },
    ["Bream"] = {
        [1] = {
            ["FinesseBoost"] = 3,
        },
        [2] = {
            ["FinesseBoost"] = 6,
        },
        [3] = {
            ["FinesseBoost"] = 9,
        },
    },
    ["SoulJar"] = {
        [1] = {
            ["Necromancy"] = 1,
            ["MemoryBoost"] = 1,
        },
        [2] = {
            ["Necromancy"] = 2,
            ["MemoryBoost"] = 2,
        },
        [3] = {
            ["Necromancy"] = 3,
            ["MemoryBoost"] = 3,
        },
    },
    ["SourceTouchedSchool"] = {
        [1] = {
            ["Sourcery"] = 1,
            ["Summoning"] = 1,
        },
        [2] = {
            ["Sourcery"] = 2,
            ["Summoning"] = 2,
        },
        [3] = {
            ["Sourcery"] = 3,
            ["Summoning"] = 3,
        },
    },
    ["SpareLamp"] = {
        [1] = {
            ["SightBoost"] = 1,
            ["AirSpecialist"] = 1,
        },
        [2] = {
            ["SightBoost"] = 2,
            ["AirSpecialist"] = 2,
        },
        [3] = {
            ["SightBoost"] = 3,
            ["AirSpecialist"] = 3,
        },
    },
    ["Rockfish"] = {
        [1] = {
            ["EarthSpecialist"] = 1,
            ["ConstitutionBoost"] = 3,
        },
        [2] = {
            ["EarthSpecialist"] = 2,
            ["ConstitutionBoost"] = 6,
        },
        [3] = {
            ["EarthSpecialist"] = 3,
            ["ConstitutionBoost"] = 10,
        },
    },
    ["Sludge"] = {
        [1] = {
            ["Poison"] = 3,
            ["ConstitutionBoost"] = 1,
        },
        [2] = {
            ["Poison"] = 6,
            ["ConstitutionBoost"] = 2,
        },
        [3] = {
            ["Poison"] = 9,
            ["ConstitutionBoost"] = 3,
        },
    },
    ["Stringfish"] = {
        [1] = {
            ["Ranged"] = 1,
            ["RangerLore"] = 1,
        },
        [2] = {
            ["Ranged"] = 2,
            ["RangerLore"] = 2,
        },
        [3] = {
            ["Ranged"] = 3,
            ["RangerLore"] = 3,
        },
    },
    ["Swordine"] = {
        [1] = {
            ["TwoHanded"] = 1,
            ["WarriorLore"] = 1,
        },
        [2] = {
            ["TwoHanded"] = 2,
            ["WarriorLore"] = 2,
        },
        [3] = {
            ["TwoHanded"] = 3,
            ["WarriorLore"] = 3,
        },
    },
    ["LightAtTheEnd"] = {
        [1] = {
            ["AirSpecialist"] = 1,
            ["DodgeBoost"] = 4,
        },
        [2] = {
            ["AirSpecialist"] = 2,
            ["DodgeBoost"] = 7,
        },
        [3] = {
            ["AirSpecialist"] = 3,
            ["DodgeBoost"] = 12,
        },
    },
    ["Petri"] = {
        [1] = {
            ["Loremaster"] = 1,
            ["IntelligenceBoost"] = 1,
        },
        [2] = {
            ["Loremaster"] = 2,
            ["IntelligenceBoost"] = 2,
        },
        [3] = {
            ["Loremaster"] = 3,
            ["IntelligenceBoost"] = 3,
        },
    },
    ["HotShell"] = {
        [1] = {
            ["FireSpecialist"] = 1,
            ["Fire"] = 5,
        },
        [2] = {
            ["FireSpecialist"] = 2,
            ["Fire"] = 10,
        },
        [3] = {
            ["FireSpecialist"] = 3,
            ["Fire"] = 15,
        },
    },
    ["Jackpot"] = {
        [1] = {
            ["Water"] = 4,
            ["Thievery"] = 1,
        },
        [2] = {
            ["Water"] = 8,
            ["Thievery"] = 2,
        },
        [3] = {
            ["Water"] = 12,
            ["Thievery"] = 3,
        },
    },
    ["PyrokineticSnapper"] = {
        [1] = {
            ["FireSpecialist"] = 1,
            ["Fire"] = 7,
        },
        [2] = {
            ["FireSpecialist"] = 2,
            ["Fire"] = 13,
        },
        [3] = {
            ["FireSpecialist"] = 3,
            ["Fire"] = 20,
        },
    },
    ["RedHerring"] = {
        [1] = {
            ["Sneaking"] = 1,
            ["Thievery"] = 1,
        },
        [2] = {
            ["Sneaking"] = 2,
            ["Thievery"] = 2,
        },
        [3] = {
            ["Sneaking"] = 3,
            ["Thievery"] = 3,
        },
    },
    ["SardineSchool"] = {
        [1] = {
            ["DodgeBoost"] = 3,
            ["WaterSpecialist"] = 1,
        },
        [2] = {
            ["DodgeBoost"] = 6,
            ["WaterSpecialist"] = 2,
        },
        [3] = {
            ["DodgeBoost"] = 12,
            ["WaterSpecialist"] = 3,
        },
    },
    ["Sardine"] = {
        [1] = {
            ["StrengthBoost"] = 2,
        },
        [2] = {
            ["StrengthBoost"] = 4,
        },
        [3] = {
            ["StrengthBoost"] = 6,
        },
    },
    ["Mindflayer"] = {
        [1] = {
            ["IntelligenceBoost"] = 2,
        },
        [2] = {
            ["IntelligenceBoost"] = 4,
        },
        [3] = {
            ["IntelligenceBoost"] = 6,
            ["Flags"] = "MadnessImmunity",
        },
    },
    ["Eel"] = {
        [1] = {
            ["AirSpecialist"] = 1,
            ["FinesseBoost"] = 1,
        },
        [2] = {
            ["AirSpecialist"] = 2,
            ["FinesseBoost"] = 2,
        },
        [3] = {
            ["AirSpecialist"] = 3,
            ["FinesseBoost"] = 3,
        },
    },
    ["DarkConch"] = {
        [1] = {
            ["Sneaking"] = 1,
            ["Necromancy"] = 1,
        },
        [2] = {
            ["Sneaking"] = 2,
            ["Necromancy"] = 2,
        },
        [3] = {
            ["Sneaking"] = 3,
            ["Necromancy"] = 3,
        },
    },
    ["Nightfarer"] = {
        [1] = {
            ["RogueLore"] = 1,
            ["Sneaking"] = 1,
        },
        [2] = {
            ["RogueLore"] = 2,
            ["Sneaking"] = 2,
        },
        [3] = {
            ["RogueLore"] = 3,
            ["Sneaking"] = 3,
        },
    },
    ["GripSlipper"] = {
        [1] = {
            ["Movement"] = 17,
            ["Sneaking"] = 1,
        },
        [2] = {
            ["Movement"] = 34,
            ["Sneaking"] = 2,
        },
        [3] = {
            ["Movement"] = 60,
            ["Sneaking"] = 3,
        },
    },
    ["GenericVoidwoken"] = {
        [1] = {
            ["Perseverance"] = 1,
        },
        [2] = {
            ["Perseverance"] = 2,
        },
        [3] = {
            ["Perseverance"] = 3,
        },
    },
}

-- Rune gold values per tier
local TIER_GOLD_VALUES = {
    [1] = 150,
    [2] = 300,
    [3] = 500,
}

---Returns a list of fish descriptors sorted by ID.
---Used to avoid the stats entries from being reshuffled when regenerating them (causing annoying diffs)
---@return Features.Fishing.Fish[]
local function GetSortedFishes()
    local fishDescs = Fishing.GetFishes()
    local orderedFishes = {} ---@type Features.Fishing.Fish[]
    for _,fish in pairs(fishDescs) do
        table.insert(orderedFishes, fish)
    end
    table.sort(orderedFishes, function(a,b) return a.ID < b.ID end)
    return orderedFishes
end

---Generates Armor stat entries for all fishes.
local function GenerateArmorStats()
    local sortedFishes = GetSortedFishes()
    local lines = {}
    local addLine = function(line, ...) table.insert(lines, string.format(line, ...)) end

    -- Add dummy entry
    addLine([[new entry "_Boost_PIP_Dummy"]])
    addLine([[type "Armor"]])
    addLine("")

    -- Iterate through all fishes
    for _, fish in ipairs(sortedFishes) do
        local fishID = fish.ID
        -- Get boost values for this fish (use default if not specified)
        local boostValues = STAT_BOOSTS[fishID]
        if not boostValues then
            Ext.PrintWarning("[Fishing] No custom boost values found for fish", fishID)
        end

        -- Generate 3 entries for each fish
        for tier=1,3,1 do
            local entryName = string.format("_Boost_PIP_Fish_%s_%d", fishID, tier)
            local tierData = boostValues[tier]

            addLine([[new entry %s]], entryName)
            addLine([[type "Armor"]])
            addLine([[using "_Boosts_Runes_Armor_Upperbody"]])

            -- Add all data fields for this tier
            for field, value in pairs(tierData) do
                addLine([[data "%s" "%s"]], field, value)
            end

            addLine("")
        end
    end

    return table.concat(lines, "\n")
end

---Generates Object stats .txt for all fishes.
local function GenerateObjectStats()
    local orderedFishes = GetSortedFishes()
    local output = {}
    local addLine = function(line, ...) table.insert(output, string.format(line, ...)) end

    -- Generate stat entries for each rune tier
    for _, fish in ipairs(orderedFishes) do
        local fishID = fish.ID
        for tier=1,MAX_RUNE_TIER,1 do
            local entryName = string.format("PIP_FishRune_%s_Tier%d", fishID, tier)
            local armorBoostRef = string.format("_Boost_PIP_Fish_%s_%d", fishID, tier)

            addLine([[new entry %s]], entryName)
            addLine([[type "Object"]])
            addLine([[using "_Runes""]])

            addLine([[data "RootTemplate" "%s"]], fish.RootTemplates[tier])
            addLine([[data "Act part" "1"]])
            addLine([[data "Value" "%d"]], TIER_GOLD_VALUES[tier])
            addLine([[data "RuneLevel" "%d"]], tier)
            addLine([[data "RuneEffectWeapon" "_Boost_PIP_Dummy"]])
            addLine([[data "RuneEffectUpperbody" "%s"]], armorBoostRef)
            addLine([[data "RuneEffectAmulet" "_Boost_PIP_Dummy"]])
            addLine("")
        end
    end

    return table.concat(output, "\n")
end

---Generates ItemCombos.txt for upgrading fish runes through crafting.
local function GenerateItemCombos()
    local output = {}
    local addLine = function(line, ...) table.insert(output, string.format(line, ...)) end
    local sortedFishes = GetSortedFishes()
    for _, fish in ipairs(sortedFishes) do
        local fishID = fish.ID

        -- Recipe for Tier 1 -> Tier 2
        local tier1ID = string.format("PIP_FishRune_%s_Tier1", fishID)
        local tier2ID = string.format("PIP_FishRune_%s_Tier2", fishID)
        local recipe1Name = string.format("%s_%s", tier1ID, tier1ID)

        addLine([[new ItemCombination "%s"]], recipe1Name)
        addLine([[data "RecipeCategory" "Runes"]])
        addLine([[data "Type 1" "Object"]])
        addLine([[data "Object 1" "%s"]], tier1ID)
        addLine([[data "Transform 1" "Transform"]])
        addLine([[data "Type 2" "Object"]])
        addLine([[data "Object 2" "%s"]], tier1ID)
        addLine([[data "Transform 2" "Consume"]])
        addLine([[data "Type 3" "Object"]])
        addLine([[data "Object 3" "%s"]], tier1ID)
        addLine([[data "Transform 3" "Consume"]])
        addLine([[data "Type 4" "Object"]])
        addLine([[data "Object 4" "%s"]], tier1ID)
        addLine([[data "Transform 4" "Consume"]])
        addLine("")

        addLine([[new ItemCombinationResult "%s_1"]], recipe1Name)
        addLine([[data "Result 1" "%s"]], tier2ID)
        addLine([[data "PreviewStatsID" "%s"]], tier2ID)
        addLine("")

        -- Recipe for Tier 2 -> Tier 3
        local tier3ID = string.format("PIP_FishRune_%s_Tier3", fishID)
        local recipe2Name = string.format("%s_%s", tier2ID, tier2ID)

        addLine([[new ItemCombination "%s"]], recipe2Name)
        addLine([[data "RecipeCategory" "Runes"]])
        addLine([[data "Type 1" "Object"]])
        addLine([[data "Object 1" "%s"]], tier2ID)
        addLine([[data "Transform 1" "Transform"]])
        addLine([[data "Type 2" "Object"]])
        addLine([[data "Object 2" "%s"]], tier2ID)
        addLine([[data "Transform 2" "Consume"]])
        addLine([[data "Type 3" "Object"]])
        addLine([[data "Object 3" "%s"]], tier2ID)
        addLine([[data "Transform 3" "Consume"]])
        addLine("")

        addLine([[new ItemCombinationResult "%s_1"]], recipe2Name)
        addLine([[data "Result 1" "%s"]], tier3ID)
        addLine([[data "PreviewStatsID" "%s"]], tier3ID)
        addLine("")
    end

    return table.concat(output, "\n")
end

---Generates stats .txts and saves their files.
Ext.RegisterConsoleCommand("fishgeneratestats", function (_)
    -- Generate Armor stats (for rune boosts)
    local armorContent = GenerateArmorStats()
    local armorFilename = "FishingStats/Armor.txt"
    IO.SaveFile(armorFilename, armorContent, true)
    print(string.format("[Fishing] Generated armor stats saved to %s", armorFilename))

    -- Generate Object stats
    local objectContent = GenerateObjectStats()
    local objectFilename = "FishingStats/Object.txt"
    IO.SaveFile(objectFilename, objectContent, true)
    print(string.format("[Fishing] Generated object stats saved to %s", objectFilename))

    -- Generate crafting recipes
    local combosContent = GenerateItemCombos()
    local combosFilename = "FishingStats/ItemCombos.txt"
    IO.SaveFile(combosFilename, combosContent, true)
    print(string.format("[Fishing] Generated item combos saved to %s", combosFilename))
end)
