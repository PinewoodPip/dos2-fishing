
local Fishing = GetFeature("Fishing")
local Tooltip = Client.Tooltip

---@class Fishing.Skills
local Skills = GetFeature("Fishing.Skills")
local TSK = Skills.TranslatedStrings

Skills.POTION_TSKHANDLE = "hae185f7aga216g43afg82b3gaf96a75a7890" -- "Potion"
Skills.SET_PROPERTY_TSKHANDLE = "h233bf83cg2204g4f14gb46agad27f95deb43" -- "Set [1].[2][3]"

-- Maps skillbook string key to its Fishermancy skill.
---@type table<string, skill>
Skills._SKILLBOOK_STRING_KEYS = {
    ["PIP_Fishing_Skillbook_BlueFireBall"] = "Projectile_PIP_Fishing_BlueFireball",
    ["PIP_Fishing_Skillbook_Hornpipe"] = "Shout_PIP_Fishing_Hornpipe",
    ["PIP_Fishing_Skillbook_TurnOnTheTides"] = "Shout_PIP_Fishing_TurnOnTheTides",
    ["PIP_Fishing_Skillbook_Sashimi"] = "Target_PIP_Fishing_Sashimi",
    ["PIP_Fishing_Skillbook_ReturnToCrab"] = "Shout_PIP_Fishing_ReturnToCrab",
    ["PIP_Fishing_Skillbook_WithTheCurrents"] = "Shout_PIP_Fishing_WithTheCurrents",
    ["PIP_Fishing_Skillbook_ReelIn"] = "Target_PIP_Fishing_ReelIn",
    ["PIP_Fishing_Skillbook_CannonBall"] = "Projectile_PIP_Fishing_CannonBall",
    ["PIP_Fishing_Skillbook_Swashbuckler"] = "Summon_PIP_Fishing_Swashbuckler",
    ["PIP_Fishing_Skillbook_DeployFishnets"] = "Projectile_PIP_Fishing_DeployFishnets",
}

---@type set<skill>
Skills.SKILLS_WITH_TIERED_STATUSES = {
    ["Target_PIP_Fishing_ReelIn"] = true,
    ["Shout_PIP_Fishing_ReturnToCrab"] = true,
    ["Target_PIP_Fishing_CrabPinch"] = true,
}

---------------------------------------------
-- EVENTS LISTENERS
---------------------------------------------

-- Show Fishermancy school in skill & skillbook tooltip footers.
Tooltip.Hooks.RenderSkillTooltip:Subscribe(function (ev)
    local skill = ev.SkillID
    local otherSchool = Skills.GetFishermancySchool(skill)
    if otherSchool then
        local tooltip = ev.Tooltip
        local skillSchoolElement = tooltip:GetFirstElement("SkillSchool")
        local fishermancyLabel = Fishing.TranslatedStrings.Label_SchoolName:Format({Color = Fishing.ABILITY_SCHOOL_COLOR})
        skillSchoolElement.Label = string.format("%s + %s", skillSchoolElement.Label, fishermancyLabel)
    end
end)
Tooltip.Hooks.RenderItemTooltip:Subscribe(function (ev)
    local item = ev.Item
    local skillbookAction = Item.GetUseActions(item, "SkillBook")[1] ---@cast skillbookAction SkillBookActionData
    if skillbookAction and Skills.IsFishermancySkill(skillbookAction.SkillID) then
        local tooltip = ev.Tooltip
        local schoolElement = tooltip:GetFirstElement("SkillSchool")
        local fishermancyLabel = Fishing.TranslatedStrings.Label_SchoolName:Format({Color = Fishing.ABILITY_SCHOOL_COLOR})
        schoolElement.Label = string.format("%s + %s", schoolElement.Label, fishermancyLabel)

        -- Hide item weight to make more space for the now-dual-skill school label.
        local weightElement = tooltip:GetFirstElement("ItemWeight")
        if weightElement then
            tooltip:RemoveElement(weightElement)
        end
    end
end)

-- Reduce skill tooltip font size in EE, for consistency with other skills.
Tooltip.Hooks.RenderSkillTooltip:Subscribe(function (ev)
    local skillID = ev.SkillID
    if Skills.FISHERMANCY_SKILLS[skillID] and EpicEncounters.IsEnabled() then
        local skillDescription = ev.Tooltip:GetFirstElement("SkillDescription")
        skillDescription.Label = Text.Format(skillDescription.Label, {Size = 19})
    end
end)

-- Show Source Infusion descriptions in EE.
Tooltip.Hooks.RenderSkillTooltip:Subscribe(function (ev)
    local infusionDescriptions = Skills.SOURCE_INFUSION_TSKS[ev.SkillID]
    if infusionDescriptions then
        local skillDescription = ev.Tooltip:GetFirstElement("SkillDescription")
        local skill = Stats.Get("StatsLib_StatsEntry_SkillData", ev.SkillID)
        local skillSchool = skill.Ability
        local schoolName = Skills.ABILITY_TO_NAME_TSK[skillSchool]:GetString()

        ---@type string[]
        local lines = {
            TSK.Label_SourceInfusions:Format({Color = Skills.SOURCE_INFUSION_COLOR}),
        }
        for i,tsk in ipairs(infusionDescriptions) do
            local level = Skills.SOURCE_INFUSION_LEVEL_TO_ABILITY_REQUIREMENT[i]
            local requirement = level and (" " .. TSK.Label_SourceInfusionRequirement:Format(level, schoolName)) or ""
            local line = Text.Format("%d%s: ", {
                FormatArgs = {i, requirement},
                Color = Skills.SOURCE_INFUSION_COLOR,
            })
            table.insert(lines, Text.Format(line .. tsk:GetString(), {
                Size = 17,
            }))
        end

        skillDescription.Label = skillDescription.Label .. "<br><br>" .. table.concat(lines, "<br>") .. "<br> " -- Extra line break is necessary to add spacing between the text and skill properties. Trailing space is required for the empty line to show up.
    end
end, {EnabledFunctor = EpicEncounters.IsEnabled})

-- Add tiered statuses journal hint to skills that apply them.
Tooltip.Hooks.RenderSkillTooltip:Subscribe(function (ev)
    _D(ev.Tooltip)
    if Skills.SKILLS_WITH_TIERED_STATUSES[ev.SkillID] then
        local skillDescription = ev.Tooltip:GetFirstElement("SkillDescription")
        skillDescription.Label = skillDescription.Label .. "<br>" .. TSK.Label_TieredStatusHint:Format({
            FontType = Text.FONTS.ITALIC,
            Size = 18,
        })
    end
end)

-- Replace "Set Potion" labels with descriptions of the scripted status effects.
---@param tooltip TooltipLib_FormattedTooltip
---@param skill skill
local function ReplaceSetPotionLabels(tooltip, skill)
    local skillPropertyTSK = Skills.SKILL_PROPERTIES[skill]
    if skillPropertyTSK then
        local setPotionElements = tooltip:GetFirstElement("SkillProperties")
        if setPotionElements then
            local potionLabel = Text.GetTranslatedString(Skills.POTION_TSKHANDLE)
            local setPotionLabel = Text.FormatLarianTranslatedString(Skills.SET_PROPERTY_TSKHANDLE, potionLabel, "", "")
            for _,prop in pairs(setPotionElements.Properties) do
                if prop.Label == setPotionLabel then
                    prop.Label = skillPropertyTSK:GetString()
                    break
                end
            end
        end
    end
end
Tooltip.Hooks.RenderSkillTooltip:Subscribe(function (ev)
    if Skills.IsFishermancySkill(ev.SkillID) then
        ReplaceSetPotionLabels(ev.Tooltip, ev.SkillID)
    end
end)
Tooltip.Hooks.RenderItemTooltip:Subscribe(function (ev)
    local item = ev.Item
    local skillbookAction = Item.GetUseActions(item, "SkillBook")[1] ---@cast skillbookAction SkillBookActionData
    if skillbookAction and Skills.IsFishermancySkill(skillbookAction.SkillID) then
        ReplaceSetPotionLabels(ev.Tooltip, skillbookAction.SkillID)
    end
end)

-- Rename "Set Crab Form" from Return to Modernity skill;
-- technically the skill reapplies the status, which itself has the "Toggle" property so that the status is removed.
Tooltip.Hooks.RenderSkillTooltip:Subscribe(function (ev)
    if ev.SkillID == "Shout_PIP_Fishing_ReturnToModernity" then
        local skillProps = ev.Tooltip:GetFirstElement("SkillProperties")
        if skillProps then
            for _,prop in pairs(skillProps.Properties) do
                local crabStatusName = Text.GetTranslatedString("PIP_Polymorphed_Crab_DisplayName")
                local setPotionLabel = Text.FormatLarianTranslatedString(Skills.SET_PROPERTY_TSKHANDLE, crabStatusName, "", "")
                if prop.Label == setPotionLabel then
                    prop.Label = TSK.Label_RemoveStatus:Format(crabStatusName)
                    break
                end
            end
        end
    end
end)

-- Set names for skillbook items.
GameState.Events.ClientReady:Subscribe(function (_)
    for stringKey,skillID in pairs(Skills._SKILLBOOK_STRING_KEYS) do
        local skill = Stats.Get("StatsLib_StatsEntry_SkillData", skillID)
        local skillName = Text.GetTranslatedString(skill.DisplayName)
        local skillbookName = TSK.Label_Skillbook:Format(skillName)
        local nameHandle = Text.GenerateGUID() -- Doesn't matter; runtime only.
        Text.SetTranslatedString(nameHandle, skillbookName)
        Text.SetStringKey(stringKey, nameHandle)
    end
end)
