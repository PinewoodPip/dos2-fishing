
local Fishing = GetFeature("Features.Fishing")

---@class Features.Fishing.Runes : Feature
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
    }
}
RegisterFeature("Fishing.Runes", Runes)

---Returns whether value is an extender Item object.
---@param value any
---@return boolean
local function IsItemObject(value)
    return GetExtType(value) == "EclItem" or GetExtType(value) == "EsvItem"
end

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns the fish associated with a fish rune.
---@param rune Item|StatsLib_StatsEntry_Object
---@return Features.Fishing.Fish? --`nil` if the item is not a fish rune.
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
---@param fish Features.Fishing.Fish|string
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
