
local Fishing = Epip.GetFeature("Features.Fishing")

---@class Features.Fishing.Runes : Feature
local Runes = {
    TranslatedStrings = {
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
