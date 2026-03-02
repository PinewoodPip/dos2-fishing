
local Fishing = Epip.GetFeature("Features.Fishing")

---@class Features.Fishing.Runes : Feature
local Runes = {
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
    }
}
Epip.RegisterFeature("Fishing.Runes", Runes)

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns whether an item is a fish rune.
---@param item Item
---@return boolean
function Runes.IsFishRune(item)
    return Fishing.GetFishByTemplate(item.RootTemplate.Id) ~= nil
end

---Returns the fish rune tier of an item.
---@param item Item
---@return integer? -- `nil` if the item is not a fish rune.
function Runes.GetFishRuneTier(item)
    local fish = Fishing.GetFishByTemplate(item.RootTemplate.Id)
    if not fish then return nil end
    local stats = item.StatsId
    return Stats.Get("StatsLib_StatsEntry_Object", stats).RuneLevel
end
