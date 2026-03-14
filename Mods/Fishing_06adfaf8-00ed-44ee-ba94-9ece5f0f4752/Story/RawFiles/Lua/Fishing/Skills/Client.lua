
local Fishing = Epip.GetFeature("Features.Fishing")
local Tooltip = Client.Tooltip

---@class Features.Fishing.Skills
local Skills = Epip.GetFeature("Fishing", "Features.Fishing.Skills")
local TSK = Skills.TranslatedStrings

-- Maps skillbook string key to its Fishermancy skill.
---@type table<string, skill>
Skills._SKILLBOOK_STRING_KEYS = {
    ["PIP_Fishing_Skillbook_BlueFireBall"] = "Projectile_PIP_Fishing_BlueFireball",
    ["PIP_Fishing_Skillbook_Hornpipe"] = "Shout_PIP_Fishing_Hornpipe",
    ["PIP_Fishing_Skillbook_Sashimi"] = "Target_PIP_Fishing_Sashimi",
    ["PIP_Fishing_Skillbook_ReturnToCrab"] = "Shout_PIP_Fishing_ReturnToCrab",
    ["PIP_Fishing_Skillbook_WithTheCurrents"] = "Shout_PIP_Fishing_WithTheCurrents",
    ["PIP_Fishing_Skillbook_ReelIn"] = "Target_PIP_Fishing_ReelIn",
    ["PIP_Fishing_Skillbook_CannonBall"] = "Projectile_PIP_Fishing_CannonBall",
    ["PIP_Fishing_Skillbook_Swashbuckler"] = "Summon_PIP_Fishing_Swashbuckler",
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
