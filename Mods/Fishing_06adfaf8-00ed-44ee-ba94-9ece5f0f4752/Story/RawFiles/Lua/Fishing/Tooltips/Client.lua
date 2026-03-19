
local Tooltip = Client.Tooltip
local Fishing = GetFeature("Features.Fishing")

---@type Feature
local Tooltips = {
    TranslatedStrings = {
        Label_AbilityBonus = {
            Handle = "h86e13650g0d88g43c1g934cg46ebd92d23a7",
            Text = "Fishing bonuses:",
            ContextDescription = [[Tooltip for abilities that give bonuses while fishing]],
        },
        Label_AbilityBonus_Persuasion = {
            Handle = "h58acdf6dg8928g4287g8210gc3cf6d3aca5d",
            Text = "Decreases the time until fish bite by %s%% per point.",
            ContextDescription = [[Tooltip for Persuasion bonus; param is amount per point]],
        },
        Label_AbilityBonus_Telekinesis = {
            Handle = "h89e56530gf511g4019g9715gfeaa57f41719",
            Text = "Increases how far you can cast your rod by %s%% per point.",
            ContextDescription = [[Tooltip for Telekinesis bonus; param is amount per point]],
        },
        Label_AbilityBonus_Bartering = {
            Handle = "haa12aa21g4b0ag4511ga2f5gd77002014197",
            Text = "Grants a %s%% chance to catch an additional fish of the same kind.",
            ContextDescription = [[Tooltip for Bartering bonus; param is amount per point]],
        },
        Label_AbilityBonus_LuckyCharm = {
            Handle = "ha41eebdbg24b8g4d5cg9fb6gc6c454027260",
            Text = "Increases the chance to encounter treasure while fishing by %s%% per point.",
            ContextDescription = [[Tooltip for Lucky Charm bonus; param is amount per point]],
        },
        Label_AbilityBonus_Leadership = {
            Handle = "h1a4340dfg8f95g4739gb94ag1b109c5e876b",
            Text = "Increases the starting capture progress by %s%% per point.",
            ContextDescription = [[Tooltip for Leadership bonus; param is amount per point]],
        },
    },
}
RegisterFeature("Fishing.Tooltips", Tooltips)
local TSK = Tooltips.TranslatedStrings

---@class Features.Fishing.Tooltips.AbilityBonusEntry
---@field Label TextLib_TranslatedString
---@field Getter fun(char:Character):number

---@type table<AbilityType, fun(char:Character):string>
Tooltips.ABILITY_BONUSES = {
    [Tooltip.ABILITY_IDS.PERSUASION] = function (_)
        local value = Fishing.TUNING.BITE_DELAY_REDUCTION_PER_PERSUASION * 100
        value = Text.RemoveTrailingZeros(value)
        return TSK.Label_AbilityBonus_Persuasion:Format(value)
    end,
    [Tooltip.ABILITY_IDS.TELEKINESIS] = function (_)
        local value = Fishing.TUNING.CASTING_RANGE_PER_TELEKINESIS * 100
        value = Text.RemoveTrailingZeros(value)
        return TSK.Label_AbilityBonus_Telekinesis:Format(value)
    end,
    [Tooltip.ABILITY_IDS.BARTERING] = function (_)
        local value = Fishing.TUNING.EXTRA_CATCH_CHANCE_PER_BARTERING * 100
        value = Text.RemoveTrailingZeros(value)
        return TSK.Label_AbilityBonus_Bartering:Format(value)
    end,
    [Tooltip.ABILITY_IDS.LUCKY_CHARM] = function (_)
        local value = Fishing.TUNING.TREASURE_CHEST_CHANCE_PER_LUCK * 100
        value = Text.RemoveTrailingZeros(value)
        return TSK.Label_AbilityBonus_LuckyCharm:Format(value)
    end,
    [Tooltip.ABILITY_IDS.LEADERSHIP] = function (_)
        local value = Fishing.TUNING.STARTING_PROGRESS_PER_LEADERSHIP * 100
        value = Text.RemoveTrailingZeros(value)
        return TSK.Label_AbilityBonus_Leadership:Format(value)
    end,
}

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Show ability bonuses for the fishing minigame.
local function FormatTooltipBonus(str)
    local prefix = TSK.Label_AbilityBonus:GetString() .. "<br><img src='Icon_BulletPoint'> "
    return Text.Format(prefix .. str, {
        Color = Color.LARIAN.LIGHT_BLUE,
    })
end
Tooltip.Hooks.RenderAbilityTooltip:Subscribe(function (ev)
    local abilityBonusGetter = Tooltips.ABILITY_BONUSES[ev.AbilityID]
    if abilityBonusGetter then
        local char = Client.GetCharacter()
        local bonusStr = abilityBonusGetter(char)
        ev.Tooltip:InsertElement({
            Type = "ItemDescription",
            Label = FormatTooltipBonus(bonusStr),
        })
    end
end)