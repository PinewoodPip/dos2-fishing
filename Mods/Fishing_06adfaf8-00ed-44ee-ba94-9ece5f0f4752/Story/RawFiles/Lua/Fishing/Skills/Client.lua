
local Fishing = Epip.GetFeature("Features.Fishing")
local Tooltip = Client.Tooltip

---@class Features.Fishing.Skills
local Skills = Epip.GetFeature("Fishing", "Features.Fishing.Skills")

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
    end
end)
