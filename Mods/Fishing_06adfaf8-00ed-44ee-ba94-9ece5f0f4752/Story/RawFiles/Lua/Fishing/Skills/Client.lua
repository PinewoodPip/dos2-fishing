
local Fishing = Epip.GetFeature("Features.Fishing")
local Tooltip = Client.Tooltip

---@class Features.Fishing.Skills
local Skills = Epip.GetFeature("Fishing", "Features.Fishing.Skills")

---------------------------------------------
-- EVENTS LISTENERS
---------------------------------------------

-- Show Fishermancy school in skill tooltip footers.
Tooltip.Hooks.RenderSkillTooltip:Subscribe(function (ev)
    local skill = ev.SkillID
    local otherSchool = Skills.GetFishermancySchool(skill)
    if otherSchool then
        local tooltip = ev.Tooltip
        local skillSchoolElement = tooltip:GetFirstElement("SkillSchool")
        skillSchoolElement.Label = string.format("%s + %s", skillSchoolElement.Label, Fishing.TranslatedStrings.Label_SchoolName:Format({Color = Fishing.ABILITY_SCHOOL_COLOR}))
    end
end)
