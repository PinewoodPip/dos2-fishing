
local Fishing = GetFeature("Fishing")

---@class Fishing.Runes : Feature
local Runes = {
    -- Slots that accept fish runes.
    ---@type set<ItemSlot>
    ITEM_SLOT_WHITELIST = {
        ["Helmet"] = true,
        ["Breast"] = true,
        ["Leggings"] = true,
        ["Belt"] = true,
        ["Boots"] = true,
        ["Gloves"] = true,
    },

    -- Maps fish rarity to Loremaster required to identify its effects.
    ---@type table<ItemLib_Rarity, integer>
    LOREMASTER_REQUIREMENTS = {
        ["Rare"] = 1,
        ["Epic"] = 2,
        ["Legendary"] = 3,
    },

    TranslatedStrings = {
        Label_FishRune = {
            Handle = "h51d68a3cg1f4cg4ed2gb01ag1ce7c50a811b",
            Text = "Tier %d Fish Essence",
            ContextDescription = [[Tooltip for fish runes. Param is rune tier]],
        },
        Label_CannotEquip = {
            Handle = "h699aa192g51efg46acgadb7g69da8828850b",
            Text = "Cannot equip.",
            ContextDescription = [[Tooltip for invalid rune slots for fish runes]],
        },
        Label_Unidentified = {
            Handle = "h03b7c934g86d9g4c8fg97a2gc84d1de4744e",
            Text = "Unidentified fish essence.<br>Requires Loremaster %d to identify.",
            ContextDescription = [[Tooltip for fish runes that the player does not have enough Loremaster for; param is Loremaster requirement]],
        },
        MsgBox_WrongRuneSlot_Body = {
            Handle = "ha7b764eegee70g4dc4g8409g12a4b25dc6bc",
            Text = "This fish essence does not work in this item slot.<br>I should remove it.",
            ContextDescription = [[Message box when equipping fish runes in the wrong slot]],
        },
        Label_Descended = {
            Handle = "h95783f9cgad6bg4e87g87f6g8aaab72b4f1e",
            Text = "This fish cannot descend any further.",
            ContextDescription = [[Label for max-tier fish runes]],
        },

        Effect_Epipe = {
            Handle = "h4bdb1662g0072g4fb6gb536g1d79d4f25e05",
            Text = "+%s%% Quality-of-life",
            ContextDescription = [[Easter egg tooltip for Epipe fish rune; param is amount as percentage]],
        },
        Effect_DescentKey = {
            Handle = "ha6a7d3cdg3dfcg4defg8946g5f355d78e773",
            Text = "+%s%% Epic Encounters",
            ContextDescription = [[Easter egg tooltip for Descent Key fish rune; param is amount as percentage]],
        },
        Effect_FidgetSpinner = {
            Handle = "h759cdefdg837dg46cdg94d3g32d7808c597c",
            Text = "-%s%% Attention span",
            ContextDescription = [[Easter egg tooltip for Fidget Spinner fish rune; param is amount as percentage]],
        },
        Effect_SourceStarFish = {
            Handle = "h96d9f729geed5g4030g9f31gb6ae6648d63c",
            Text = "Set Potion.",
            ContextDescription = [[Easter egg tooltip for Source Starfish fish rune]],
        },
    }
}
RegisterFeature("Fishing.Runes", Runes)

---Returns whether value is an extender Item object.
---@param value any
---@return boolean
local function IsItemObject(value)
    return GetExtType(value) == "ecl::Item" or GetExtType(value) == "esv::Item"
end

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns the fish associated with a fish rune.
---@param rune Item|StatsLib_StatsEntry_Object
---@return Fishing.Fish? --`nil` if the item is not a fish rune.
function Runes.GetFish(rune)
    local templateID
    if IsItemObject(rune) then
        ---@cast rune Item
        templateID = rune.RootTemplate.Id
    else -- Stat object overload.
        ---@cast rune StatsLib_StatsEntry_Object
        templateID = rune.RootTemplate
    end
    return Fishing.GetFishByTemplate(templateID)
end

---Returns whether char's party has enough Loremaster to identify the fish rune.
---@param char Character
---@param rune Item
---@return boolean
function Runes.IsIdentified(char, rune)
    local loremaster = Character.GetHighestPartyAbility(char, "Loremaster")
    return loremaster >= Runes.GetIdentificationRequirement(rune)
end

---Returns the Loremaster requirement to identify a fish rune.
---@param rune Item
---@return integer? -- `nil` if the item is not a fish rune.
function Runes.GetIdentificationRequirement(rune)
    if not Runes.IsFishRune(rune) then return nil end
    local fish = Runes.GetFish(rune)
    local requirement =  Runes.LOREMASTER_REQUIREMENTS[fish.Rarity] or 0

    -- Increase requirement for higher-tier runes
    local runeTier = Runes.GetFishRuneTier(rune)
    requirement = requirement + (runeTier - 1)

    return math.min(requirement, 5) -- Cap at Loremaster 5 to prevent higher-tier runes from becoming annoying to identify, if another mod adds them.
end

---Returns whether an item is valid for inserting fish runes.
---Ignores whether the item has rune slots.
---@param item Item
---@return boolean
function Runes.CanEquipFishRune(item)
    local itemSlot = Item.GetItemSlot(item)
    return itemSlot and Runes.ITEM_SLOT_WHITELIST[itemSlot] or false
end

---Returns whether an item is a fish rune.
---@param item Item|StatsLib_StatsEntry_Object
---@return boolean
function Runes.IsFishRune(item)
    return Runes.GetFish(item) ~= nil
end

---Returns the fish rune tier of an item.
---@param item Item|StatsLib_StatsEntry_Object
---@return integer? -- `nil` if the item is not a fish rune.
function Runes.GetFishRuneTier(item)
    local fish = Runes.GetFish(item)
    if not fish then return nil end
    if IsItemObject(item) then
        return Stats.Get("StatsLib_StatsEntry_Object", item.StatsId).RuneLevel
    else -- Stat object overload.
        ---@cast item StatsLib_StatsEntry_Object
        return item.RuneLevel
    end
end

---Returns the highest tier of a fish rune that is equipped by char, if any.
---@param char Character
---@param fish Fishing.Fish|string
---@return integer? -- `nil` if the fish rune is not equipped.
function Runes.GetEquippedRuneTier(char, fish)
    fish = type(fish) == "string" and Fishing.GetFish(fish) or fish
    local equippedItems = Character.GetEquippedItems(char)
    local highestTier = nil
    for _,item in pairs(equippedItems) do
        local runes = Item.GetRunes(item)
        for _,rune in pairs(runes) do
            local runeFish = Runes.GetFish(rune)
            if runeFish and runeFish.ID == fish.ID then
                local runeTier = Runes.GetFishRuneTier(rune)
                highestTier = highestTier and math.max(highestTier, runeTier) or runeTier
            end
        end
    end
    return highestTier
end
