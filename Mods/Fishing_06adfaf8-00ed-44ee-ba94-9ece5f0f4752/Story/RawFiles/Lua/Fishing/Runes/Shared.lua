
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
