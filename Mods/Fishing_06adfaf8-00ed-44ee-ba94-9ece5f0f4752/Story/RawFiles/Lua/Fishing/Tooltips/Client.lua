
local CharacterSheet = Client.UI.CharacterSheet
local Examine = Client.UI.Examine
local Tooltip = Client.Tooltip
local TooltipUI = Client.UI.Tooltip
local Fishing = GetFeature("Fishing") ---@class Fishing
local FishingTSK = Fishing.TranslatedStrings

---@type Feature
local Tooltips = {
    TSKHANDLE_BASE_VALUE_LABEL = "hbb9884d7g3b9ag43dfga88egdcc32db8bd74", -- "Base: [1]"
    _FISHING_STAT_ID = -98,
    _DUMMY_STAT_ID = 19, -- Polymorph ID. Used as a workaround to have the engine render the tooltip, as invalid IDs do not result in the tooltip invokes being called.

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
        Label_AbilityBonus_Perseverance = {
            Handle = "hefb50da5g094dg4734ga12eg26844a9118a2",
            Text = "Decreases capture progress drain when not reeling in the fish by %s%% per point.",
            ContextDescription = [[Tooltip for Perseverance bonus; param is amount per point]],
        },
        Label_AbilityBonus_Thievery = {
            Handle = "h3b7e91a4g5f2cg4d8agb1e6g8c042f73d9a1",
            Text = "Decreases capture progress drain while reeling in treasure by %s%% per point.",
            ContextDescription = [[Tooltip for Thievery bonus; param is amount per point]],
        },
        Label_AbilityBonus_Thievery_DerpysTweaks = {
            Handle = "h9e825113ged7dg4f0dg88ceg90e26cf396dd",
            Text = "Increases the chance to encounter treasure while fishing by %s%% per point and decreases capture progress drain while reeling in treasure by %s%% per point.",
            ContextDescription = [[Tooltip for Thievery bonus with Derpy's Tweaks; first param is chance increase per point, second param is drain reduction per point]],
        },
    },
}
RegisterFeature("Fishing.Tooltips", Tooltips)
local TSK = Tooltips.TranslatedStrings
local isRenderingFishingAbilityTooltip = false

---@class Fishing.Tooltips.AbilityBonusEntry
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
        local value = Fishing.TUNING.TREASURE_CHEST_CHANCE_PER_ABILITY * 100
        value = Text.RemoveTrailingZeros(value)
        return TSK.Label_AbilityBonus_LuckyCharm:Format(value)
    end,
    [Tooltip.ABILITY_IDS.LEADERSHIP] = function (_)
        local value = Fishing.TUNING.STARTING_PROGRESS_PER_LEADERSHIP * 100
        value = Text.RemoveTrailingZeros(value)
        return TSK.Label_AbilityBonus_Leadership:Format(value)
    end,
    [Tooltip.ABILITY_IDS.PERSEVERANCE] = function (_)
        local value = Fishing.TUNING.PROGRESS_DRAIN_REDUCTION_PER_PERSEVERANCE * 100
        value = Text.RemoveTrailingZeros(value)
        return TSK.Label_AbilityBonus_Perseverance:Format(value)
    end,
    [Tooltip.ABILITY_IDS.THIEVERY] = function (_)
        if Mod.IsLoaded(Mod.GUIDS.EE_DERPY) then -- If Derpy's is enabled, we shift the treasure spawn bonus to Thievery to compensate for Lucky Charm being removed.
            local chanceValue = Fishing.TUNING.TREASURE_CHEST_CHANCE_PER_ABILITY * 100
            local drainValue = Fishing.TUNING.PROGRESS_DRAIN_REDUCTION_PER_THIEVERY * 100
            chanceValue = Text.RemoveTrailingZeros(chanceValue)
            drainValue = Text.RemoveTrailingZeros(drainValue)
            return TSK.Label_AbilityBonus_Thievery_DerpysTweaks:Format(chanceValue, drainValue)
        else
            local value = Fishing.TUNING.PROGRESS_DRAIN_REDUCTION_PER_THIEVERY * 100
            value = Text.RemoveTrailingZeros(value)
            return TSK.Label_AbilityBonus_Thievery:Format(value)
        end
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

-- Show Fishing ability in the character sheet.
CharacterSheet.Hooks.UpdateAbilityStats:Subscribe(function (ev)
    local char = ev.Character
    local score = Fishing.GetAbilityScore(char)
    table.insert(ev.Stats, {
        GroupID = 2, -- Skill abilities.
        IsCivil = false,
        StatID = Tooltips._FISHING_STAT_ID,
        Label = FishingTSK.Label_SchoolName:GetString(),
        ValueLabel = score,
        -- Fishermancy cannot be invested into, thus these do not need to be filled in.
        PlusButtonTooltip = "",
        MinusButtonTooltip = "",
    })
end)

-- Show Fishermancy ability in Examine UI.
Examine.Hooks.GetUpdateData:Subscribe(function (ev)
    local char = Examine.GetCharacter()
    if not char then return end
    local score = Fishing.GetAbilityScore(char)
    if score <= 0 then return end
    ev.Data:AddEntry(Examine.CATEGORIES.STATS, {
        EntryType = Examine.ENTRY_TYPES.SECONDARY_STAT,
        StatID = Tooltips._FISHING_STAT_ID,
        Label = FishingTSK.Label_SchoolName:GetString(),
        IconID = Examine.ICONS.UNKNOWN_CLASS, -- TODO
        ValueLabel = score .. "",
    })
end)

-- Hijack tooltip rendering when hovering over the ability in the character sheet.
CharacterSheet:RegisterCallListener("showAbilityTooltip", function (ev)
    local statID = ev.Args[1]
    if statID == Tooltips._FISHING_STAT_ID then
        -- Hijack the next tooltip render.
        isRenderingFishingAbilityTooltip = true
        ev.Args[1] = Tooltips._DUMMY_STAT_ID
    else
        -- Clear the previous icon override
        TooltipUI:GetUI():ClearCustomIcon("tt_ability_" .. Tooltips._DUMMY_STAT_ID)
    end
end)

-- Hijack tooltip rendering when hovering over the ability in the Examine UI.
Examine:RegisterCallListener("showTooltip", function (ev)
    local statID = ev.Args[2]
    if statID == Tooltips._FISHING_STAT_ID then
        -- Hijack the next tooltip render.
        isRenderingFishingAbilityTooltip = true
        ev.Args[2] = Tooltips._DUMMY_STAT_ID
    else
        -- Clear the previous icon override
        TooltipUI:GetUI():ClearCustomIcon("tt_ability_" .. Tooltips._DUMMY_STAT_ID)
    end
end)

-- Render the school tooltip.
Tooltip.Hooks.RenderAbilityTooltip:Subscribe(function (ev)
    if isRenderingFishingAbilityTooltip and ev.AbilityID == Tooltips._DUMMY_STAT_ID then
        local playerHandle = ev.UI:GetPlayerHandle()
        local char = Ext.Utils.IsValidHandle(playerHandle) and Character.Get(playerHandle) or Client.GetCharacter() -- Need to check the UI player handle in case of UIs such as Examine.
        local score = Fishing.GetAbilityScore(char)
        local maxScore = Fishing.GetMaxAbilityScore()
        local tooltip = ev.Tooltip
        local header = tooltip:GetFirstElement("StatName")
        local description = tooltip:GetFirstElement("AbilityDescription")
        local baseValueLabel = tooltip:GetFirstElement("StatsBaseValue")
        if not baseValueLabel then
            baseValueLabel = {
                Type = "StatsBaseValue",
                Label = ""
            }
            tooltip:InsertElement(baseValueLabel)
        end

        -- Clear other elements (to avoid leakage of extra ones from the vanilla tooltip)
        tooltip.Elements = {header, description, baseValueLabel}

        -- Edit tooltip
        header.Label = FishingTSK.Label_SchoolName:GetString()
        description.Description = FishingTSK.Label_SchoolDescription:GetString() -- TODO set CurrentLevelEffect, NextLevelEffect, Description2 fields?
        baseValueLabel.Label = Text.FormatLarianTranslatedString(Tooltips.TSKHANDLE_BASE_VALUE_LABEL, score)

        -- Set icon
        local tooltipUI = TooltipUI:GetUI()
        tooltipUI:EnableCustomDraw()
        tooltipUI:SetCustomIcon("tt_ability_" .. Tooltips._DUMMY_STAT_ID, Fishing.SKILL_ABILITY_ICON, 128, 128)

        -- Add minigame hint
        local minigameHint = FishingTSK.Label_FishingRodHint:Format({Color = Color.LARIAN.GREEN})
        description.Description = description.Description .. "\n" .. minigameHint

        -- Add leveling hint
        if score ~= maxScore then
            local _, uniqueFishCaught = Fishing.GetUniqueFishCaught()
            local totalFishCaught = Fishing.GetTotalFishCaught(char)
            local nextLevelRequirements = Fishing.GetAbilityRequirements(score + 1)
            local requirementsLabels = {} ---@type string[]
            local remainingUniqueFish = nextLevelRequirements.UniqueFishCaught - uniqueFishCaught
            local remainingTotalFish = nextLevelRequirements.TotalFishCaught - totalFishCaught
            if remainingUniqueFish > 0 then -- Unique fish requirement
                table.insert(requirementsLabels, FishingTSK.Label_SchoolDescription_LevelingRequirement_UniqueCatches:Format(remainingUniqueFish))
            end
            if remainingTotalFish > 0 then -- Total catches requirement
                table.insert(requirementsLabels, FishingTSK.Label_SchoolDescription_LevelingRequirement_TotalCatches:Format(remainingTotalFish))
            end
            tooltip:InsertElement({
                Type = "StatsPointValue",
                Label = FishingTSK.Label_SchoolDescriptionLevelingHint:Format({
                    FormatArgs = {
                        Text.Join(requirementsLabels, "\n")
                    }
                })
            })
        else
            tooltip:InsertElement({
                Type = "StatsPointValue",
                Label = FishingTSK.Label_SchoolDescription_MaxLevel:GetString()
            })
        end

        -- Rewrite the stat ID so that other tooltip listeners do not consider this as a vanilla skill ability.
        ---@diagnostic disable-next-line: assign-type-mismatch
        ev.AbilityID = Tooltips._FISHING_STAT_ID

        isRenderingFishingAbilityTooltip = false
    end
end, {Priority = math.maxinteger})
