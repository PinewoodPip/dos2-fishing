
---@class Features.Fishing
local Fishing = GetFeature("Features.Fishing")
---@type table<string, Features.Fishing.TreasureChest>
Fishing.TREASURE_CHESTS = {
    ClassicChest = {
        Template = "0f1ec892-bb40-4ce0-a751-9105c0a62f62", -- Classic human treasure chest
        TreasureTable = "RewardMedium",
    },
    BrownPouch = {
        Template = "244deb74-a42b-44b3-94b1-a7fe3620b98e", -- Brown pouch
        TreasureTable = "RewardSmall",
    },
    RichChest = {
        Template = "ba19a135-d416-4c8d-b8ce-32b76a17b0b6", -- "Rich chest"
        TreasureTable = "RewardLarge",
        Weight = 0.7,
    },
    ["RichChest.Steel"] = {
        Template = "355e9c6c-0913-4c80-a50f-f894954a4e7b", -- "Rich_Chest_A_Steel"
        TreasureTable = "RewardCombat",
        Weight = 0.5,
    },
    Barrel = {
        Template = "392a2a5a-55f6-4091-9bd1-12eceeb2abef", -- Barrel C
        TreasureTable = "Specific_BoozeCollection",
    },
    FoodBag = {
        Template = "ff894638-80f5-433a-8170-fe5581e565d1", -- Food bag
        TreasureTable = "PIP_Fishing_Treasure_Food",
    },
    PotionSet = {
        Template = "e7604fc8-d417-4911-838a-83560693e1a0", -- Potion Set (custom template)
        TreasureTable = "PIP_Fishing_Treasure_Potions",
    },
    MerchantBackpack = {
        Template = "360e3e11-c7f8-4281-848a-596e37df884b", -- Merchant backpack
        TreasureTable = "PIP_Fishing_Treasure_OffensiveConsumables",
    },
    RaanaarChest = {
        Template = "dce95037-c28b-42c8-bef2-f2793c497fa8", -- Small raanaar chest
        TreasureTable = "SourcePuppet",
        Weight = 0.2,
    },
    MagicalChest = {
        Template = "661a6684-4a22-4d7a-b736-4518263c9d0b", -- Cupboard (custom template)
        TreasureTable = "PIP_Fishing_Treasure_Magical",
    },
}
for id,chest in pairs(Fishing.TREASURE_CHESTS) do
    chest.ID = id
end

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns a treasure chet by ID.
---@param id Features.Fishing.TreasureChestID
---@return Features.Fishing.TreasureChest
function Fishing.GetTreasureChest(id)
    return Fishing.TREASURE_CHESTS[id]
end

---Returns a random treasure chest descriptor.
---@see Features.Fishing.TREASURE_CHESTS
---@return Features.Fishing.TreasureChest
function Fishing.GetRandomTreasureChest()
    local totalWeight = 0
    for _, chest in pairs(Fishing.TREASURE_CHESTS) do
        totalWeight = totalWeight + (chest.SpawnWeight or 1)
    end
    local randomWeight = math.random() * totalWeight
    for _, chest in pairs(Fishing.TREASURE_CHESTS) do
        randomWeight = randomWeight - (chest.SpawnWeight or 1)
        if randomWeight <= 0 then
            return chest
        end
    end
    ---@diagnostic disable-next-line: return-type-mismatch
    return nil
end
