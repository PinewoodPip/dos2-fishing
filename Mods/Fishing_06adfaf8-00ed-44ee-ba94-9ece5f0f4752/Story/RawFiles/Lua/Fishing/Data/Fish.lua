
local Fishing = Epip.GetFeature("Features.Fishing")

---@type table<string, Features.Fishing.Fish>
local fishes = {
    ["NormieShell"] = {
        TemplateID = "0b65b8bb-d88c-48df-bd66-3fa66060fb52",
        Behaviour = "Sinker",
        Difficulty = 0.8,
    },
    ["BlueShell"] = {
        TemplateID = "c5514b5f-e468-4908-a63d-0c33c07dadc4",
        Behaviour = "Chill",
        Difficulty = 0.9,
    },
    ["Handkerchief"] = {
        TemplateID = "bc16aace-2992-46cd-982b-264b4507c2b6",
        Behaviour = "Floater",
        Difficulty = 0.8,
    },
    ["Scarf"] = {
        TemplateID = "72fd73e8-0331-4409-b822-7b092e0ceb1c",
        Behaviour = "Floater",
        Difficulty = 0.8,
    },
    ["BranchingCoral"] = {
        TemplateID = "36da05e4-65d7-4c01-9ef0-190db1154bb6",
        Behaviour = "Chill",
        Difficulty = 1.2,
    },
    ["PearlClam"] = {
        TemplateID = "7a52514d-ec8d-4674-b60b-44589de635dd",
        Behaviour = "Chill",
        Difficulty = 1.5,
        Endurance = 1.2,
    },
    ["Starfish"] = {
        TemplateID = "9c508a76-4e09-4747-a889-efcf8d18bb14",
        Behaviour = "Chill",
        Difficulty = 1.2,
        Endurance = 1.2,
    },
    ["SpikyConch"] = {
        TemplateID = "9ef3ea02-d89e-4e9a-abfe-980303207c6b",
        Behaviour = "Aggressive",
        Difficulty = 1.3,
        Endurance = 1.1,
    },
    ["WashedPanties"] = {
        TemplateID = "36308031-2f2b-4ea7-abe3-6f4aaddc3dc2",
        Behaviour = "Floater",
        Difficulty = 1.5,
        Endurance = 0.9,
    },
    ["Pearl"] = {
        TemplateID = "bd05132f-a9f7-48a1-a9e1-ca8a47c95b01",
        Behaviour = "Chill",
        Difficulty = 2,
        Endurance = 0.8,
    },
    ["FishBone"] = {
        TemplateID = "0cca7d41-cb49-4956-b74f-6bc257212526",
        Behaviour = "Chill",
        Difficulty = 1.4,
    },
    ["Socks"] = {
        TemplateID = "83236aea-ab5b-486d-896d-73072996ec08",
        Behaviour = "Floater",
        Difficulty = 0.7,
    },
    ["CrystalCoral"] = {
        TemplateID = "07fd4252-bcfe-4b30-870b-34e6ed306b85",
        Behaviour = "Chill",
        Difficulty = 1.5,
        Endurance = 1.1,
    },
    ["NonFineChina"] = {
        TemplateID = "b38e07ef-2ac7-4bdb-9a1c-cf0aadc475e2",
        Behaviour = "Sinker",
        Difficulty = 1.2,
    },
    ["Corncomber"] = {
        TemplateID = "29983563-3ade-467f-8d9e-ff59f3446df9",
        Behaviour = "Sinker",
        Difficulty = 0.9,
        Endurance = 0.9,
    },
    ["MoonJelly"] = {
        TemplateID = "c95533e6-92b0-48a7-b7d9-8a9012bd9b07",
        Behaviour = "Chill",
        Difficulty = 1.3,
    },
    ["Gooseberry"] = {
        TemplateID = "0105e2ce-98e5-4fc9-9552-8c30f4b22dc7",
        Behaviour = "Chill",
        Difficulty = 1,
    },
    ["DescentKey"] = {
        TemplateID = "c9c8ad3b-9ee6-46c2-a5b0-8a228c57619a",
        Behaviour = "Sinker",
        Difficulty = 2.5,
        Endurance = 1.2,
    },
    ["GoldenShell"] = {
        TemplateID = "85ea72e9-85fa-4338-8bf8-c50d4746f30e",
        Behaviour = "Chill",
        Difficulty = 0.9,
    },
    ["SeaPickle"] = {
        TemplateID = "b248d058-e2c4-465b-9fbe-479980b5df05",
        Behaviour = "Chill",
        Difficulty = 1,
    },
    ["Seaweed"] = {
        TemplateID = "6d7b4477-85f1-4ec7-97bb-55c14a959e12",
        Behaviour = "Chill",
        Difficulty = 0.8,
        Endurance = 0.8,
    },
    ["SeabedRoll"] = {
        TemplateID = "293f7126-7871-4970-b1be-8639d8bbb54b",
        Behaviour = "Sinker",
        Difficulty = 1.1,
    },
    ["TorrentedSoul"] = {
        TemplateID = "0d547d36-340b-45f4-a9c4-c601fef20c31",
        Behaviour = "Aggressive",
        Difficulty = 1.4,
        Endurance = 1.5,
    },
    ["WaspNest"] = {
        TemplateID = "ad130829-18f7-47f8-be8a-c211fb03d9be",
        Behaviour = "Aggressive",
        Difficulty = 1.5,
        Endurance = 1.2,
    },
    ["CrabClaw"] = {
        TemplateID = "367cd086-70d6-40d8-9d67-5e740c3a26bf",
        Behaviour = "Aggressive",
        Difficulty = 1.5,
        Endurance = 1.5,
    },
    ["Bucket"] = {
        TemplateID = "ccd5a301-1c5b-4e23-a66e-d6de28d2a6ca",
        Behaviour = "Chill",
        Difficulty = 0.85,
        Endurance = 2,
    },
    ["LilyPad"] = {
        TemplateID = "88fb39e1-80be-4134-970b-8e216c14481e",
        Behaviour = "Floater",
        Difficulty = 0.7,
        Endurance = 1.2,
    },
    ["Aldrovanda"] = {
        TemplateID = "f203717d-c226-46c2-83f3-f7c371816380",
        Behaviour = "Aggressive",
        Difficulty = 1.3,
        Endurance = 1.1,
    },
    ["Blobfish"] = {
        TemplateID = "25df0fdd-5825-43ce-b68c-5b6ac5beb640",
        Behaviour = "Sinker",
        Difficulty = 1.1,
        Endurance = 1.5,
    },
    ["AxeHead"] = {
        TemplateID = "b7dfe5c3-b97a-48b9-b951-00e784a94fc9",
        Behaviour = "Sinker",
        Difficulty = 1.1,
        Endurance = 1.4,
    },
    ["Fetish"] = {
        TemplateID = "0e5517fd-8072-4dd6-91c3-dda9362d7a2b",
        Behaviour = "Chill",
        Difficulty = 1.2,
        Endurance = 1,
    },
    ["Painting"] = {
        TemplateID = "bb14222f-5d29-4d30-ab25-a0dc9f8cde3f",
        Behaviour = "Chill",
        Difficulty = 1.1,
        Endurance = 1.6,
    },
    ["Head"] = {
        TemplateID = "62b40302-0708-413d-8632-684a77962bcd",
        Behaviour = "Chill",
        Difficulty = 1.3,
        Endurance = 0.9,
    },
    ["FloodRose"] = {
        TemplateID = "556e0b21-8db5-4f91-9b92-ab8c088ee6b7",
        Behaviour = "Floater",
        Difficulty = 1.7,
        Endurance = 1,
    },
    ["Salt"] = {
        TemplateID = "ddf213ab-1f45-4f7a-987c-f7496630c947",
        Behaviour = "Sinker",
        Difficulty = 0.7,
        Endurance = 0.7,
    },
    ["MessagelessBottle"] = {
        TemplateID = "edeb3a42-6b45-4618-b0ca-9cde19a92604",
        Behaviour = "Sinker",
        Difficulty = 0.9,
        Endurance = 1.2,
    },
    ["Mine"] = {
        TemplateID = "b69cfc00-1570-4fe0-afca-612e1288e0d0",
        Behaviour = "Sinker",
        Difficulty = 1.2,
        Endurance = 1.3,
    },
    ["Soap"] = {
        TemplateID = "e7d8e36e-9126-42ad-be26-ae784d05440b",
        Behaviour = "Chill",
        Difficulty = 0.8,
        Endurance = 0.9,
    },
    ["SharkTooth"] = {
        TemplateID = "c9ea6c04-5d7b-4733-aa27-f6aa4ab8bd5a",
        Behaviour = "Chill",
        Difficulty = 1.3,
        Endurance = 0.8,
    },
    ["WaterRing"] = {
        TemplateID = "672d4807-70f6-462a-87e6-878ac2546bd0",
        Behaviour = "Sinker",
        Difficulty = 1.7,
        Endurance = 0.9,
    },
    ["SeaPork"] = {
        TemplateID = "5b9840b7-db3a-4202-a970-dafa97dfc638",
        Behaviour = "Aggressive",
        Difficulty = 2,
        Endurance = 1.2,
    },
    ["Quiver"] = {
        TemplateID = "1f281ebd-b8ec-48f0-b2b0-e32acbe71f85",
        Behaviour = "Aggressive",
        Difficulty = 1.7,
        Endurance = 0.8,
    },
    ["Starstone"] = {
        TemplateID = "65cc0ad3-9296-4dd9-ad35-dfe47bc5a0ad",
        Behaviour = "Aggressive",
        Difficulty = 1.8,
        Endurance = 0.7,
    },
    ["BuffaloAmulet"] = {
        TemplateID = "028b6e15-30b9-4c7a-81b7-b4c4f9fa82df",
        Behaviour = "Aggressive",
        Difficulty = 1.9,
        Endurance = 1.7,
    },
    ["Dandelion"] = {
        TemplateID = "c9f7f6af-0770-4fc0-a4ec-f3cbbe33ebcc",
        Behaviour = "Sinker",
        Difficulty = 0.7,
        Endurance = 0.7,
    },
    ["TemporalGear"] = {
        TemplateID = "9a13346b-63cc-42e4-9dc7-f04da5846cb2",
        Behaviour = "Sinker",
        Difficulty = 1.5,
        Endurance = 2.2,
    },
    ["Moss"] = {
        TemplateID = "505d83a0-8001-4f86-975a-e007f19c7891",
        Behaviour = "Floater",
        Difficulty = 0.8,
        Endurance = 0.5,
    },
    ["ZandalorTrunks"] = {
        TemplateID = "57e298f1-533a-481f-9743-ef03364e73b4",
        Behaviour = "Floater",
        Difficulty = 2,
        Endurance = 1.3,
    },
    ["SourceStarFish"] = {
        TemplateID = "8f6ba58a-b68f-436d-828f-3802def990f0",
        Behaviour = "Chill",
        Difficulty = 1.5,
        Endurance = 1,
    },
    ["LavoodooDoll"] = {
        TemplateID = "e869b3a4-adb1-4c4a-8a49-b52e0424049f",
        Behaviour = "Aggressive",
        Difficulty = 1.8,
        Endurance = 1.5,
    },
    ["Hurchin"] = {
        TemplateID = "fe731665-4318-462c-b384-a7f8b38444e5",
        Behaviour = "Aggressive",
        Difficulty = 1.5,
        Endurance = 0.8,
    },
    ["Anglerfish"] = {
        TemplateID = "132a0eff-89df-4ea4-a0a6-47fc7e45cfac",
        Behaviour = "Aggressive",
        Difficulty = 1.7,
        Endurance = 1.5,
    },

    -- TODO remove/update with custom roottemplate
    ["Swordfish"] = {
        Icon = "Item_CON_Food_Fish_F",
        TemplateID = "6e06b364-76ae-4f2b-911b-af879adeec72",
        Difficulty = 2.5,
        Endurance = 1.5,
        Behaviour = "Aggressive",
    },
}
for id,fish in pairs(fishes) do
    fish.ID = id
    fish.NameHandle = Fishing:GetTranslatedStringHandleForKey(id .. "_Name")
    fish.DescriptionHandle = Fishing:GetTranslatedStringHandleForKey(id .. "_Description")
    Fishing.RegisterFish(fish)
end
