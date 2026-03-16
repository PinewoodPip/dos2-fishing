
local CharacterSheet = Client.UI.CharacterSheet
local TooltipUI = Client.UI.Tooltip
local Tooltip = Client.Tooltip

local Fishing = GetFeature("Features.Fishing")
local TSK = Fishing.TranslatedStrings

Fishing.TSKHANDLE_BASE_VALUE_LABEL = "hbb9884d7g3b9ag43dfga88egdcc32db8bd74" -- "Base: [1]"
Fishing._FISHING_STAT_ID = -98
Fishing._DUMMY_STAT_ID = 19 -- Polymorph ID. Used as a workaround to have the engine render the tooltip, as invalid IDs do not result in the tooltip invokes being called.

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Render Fishing "ability" in the character sheet.
CharacterSheet.Hooks.UpdateAbilityStats:Subscribe(function (ev)
    local char = ev.Character
    local score = Fishing.GetAbilityScore(char)
    table.insert(ev.Stats, {
        GroupID = 2, -- Skill abilities.
        IsCivil = false,
        StatID = Fishing._FISHING_STAT_ID,
        Label = TSK.Label_SchoolName:GetString(),
        ValueLabel = score,
        -- Fishermancy cannot be invested into, thus these do not need to be filled in.
        PlusButtonTooltip = "",
        MinusButtonTooltip = "",
    })
end)

-- Render custom tooltip when hovering over the ability.
local isRenderingFishingAbilityTooltip = false
CharacterSheet:RegisterCallListener("showAbilityTooltip", function (ev)
    local statID = ev.Args[1]
    if statID == Fishing._FISHING_STAT_ID then
        -- Hijack the next tooltip render.
        isRenderingFishingAbilityTooltip = true
        ev.Args[1] = Fishing._DUMMY_STAT_ID
    else
        -- Clear the previous icon override
        TooltipUI:GetUI():ClearCustomIcon("tt_ability_" .. Fishing._DUMMY_STAT_ID)
    end
end)
Tooltip.Hooks.RenderAbilityTooltip:Subscribe(function (ev)
    if isRenderingFishingAbilityTooltip and ev.AbilityID == Fishing._DUMMY_STAT_ID then
        local char = Client.GetCharacter()
        local score = Fishing.GetAbilityScore(char)
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
        header.Label = TSK.Label_SchoolName:GetString()
        description.Description = TSK.Label_SchoolDescription:GetString() -- TODO set CurrentLevelEffect, NextLevelEffect, Description2 fields?
        baseValueLabel.Label = Text.FormatLarianTranslatedString(Fishing.TSKHANDLE_BASE_VALUE_LABEL, score)

        -- Set icon
        local tooltipUI = TooltipUI:GetUI()
        tooltipUI:EnableCustomDraw()
        tooltipUI:SetCustomIcon("tt_ability_" .. Fishing._DUMMY_STAT_ID, Fishing.SKILL_ABILITY_ICON, 128, 128)

        -- Add minigame hint
        local minigameHint = TSK.Label_FishingRodHint:Format({Color = Color.LARIAN.GREEN})
        description.Description = description.Description .. "\n" .. minigameHint

        -- Add leveling hint
        local _, uniqueFishCaught = Fishing.GetUniqueFishCaught()
        local totalFishCaught = Fishing.GetTotalFishCaught(char)
        local nextLevelRequirements = Fishing.GetAbilityRequirements(score + 1)
        local requirementsLabels = {} ---@type string[]
        local remainingUniqueFish = nextLevelRequirements.UniqueFishCaught - uniqueFishCaught
        local remainingTotalFish = nextLevelRequirements.TotalFishCaught - totalFishCaught
        if remainingUniqueFish > 0 then -- Unique fish requirement
            table.insert(requirementsLabels, TSK.Label_SchoolDescription_LevelingRequirement_UniqueCatches:Format(remainingUniqueFish))
        end
        if remainingTotalFish > 0 then -- Total catches requirement
            table.insert(requirementsLabels, TSK.Label_SchoolDescription_LevelingRequirement_TotalCatches:Format(remainingTotalFish))
        end
        tooltip:InsertElement({
            Type = "StatsPointValue",
            Label = TSK.Label_SchoolDescriptionLevelingHint:Format({
                FormatArgs = {
                    Text.Join(requirementsLabels, "\n")
                }
            })
        })

        -- Rewrite the stat ID so that other tooltip listeners do not consider this as a vanilla skill ability.
        ---@diagnostic disable-next-line: assign-type-mismatch
        ev.AbilityID = Fishing._FISHING_STAT_ID

        isRenderingFishingAbilityTooltip = false
    end
end, {Priority = math.maxinteger})
