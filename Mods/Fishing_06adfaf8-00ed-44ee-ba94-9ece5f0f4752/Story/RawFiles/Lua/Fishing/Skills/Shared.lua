
local Fishing = Epip.GetFeature("Features.Fishing")

---@class Features.Fishing.Skills : Feature
local Skills = {
    ---Maps a Fishermancy skill to its associated other school.
    ---@type table<string, AbilityType>
    FISHERMANCY_SKILLS = {
        ["Projectile_PIP_Fishing_BlueFireball"] = "FireSpecialist",
    },
    TranslatedStrings = {
        Label_SkillSchoolFooter = {
            Handle = "h8a92f9e4ge7dcg466ag9a69g9987014b5c35",
            Text = "Fishermancy + %s",
            ContextDescription = [[Footer for Fishermancy skill tooltips; param is the other school of the skill]],
        },
        Skill_BlueFireball_DisplayName = {
            Handle = "h63cc250fg2bfeg4c3cgb888gbd8d5beb1be4",
            Text = "Blue Fireball",
            ContextDescription = [[Skill name]],
            StringKey = "Projectile_PIP_Fishing_BlueFireball_DisplayName",
        },
        Skill_BlueFireball_Description = {
            Handle = "had5aae6cg5f8cg4ee5gafccg253ff5269b76",
            Text = "Launch a volatile ball of blue fire at target point, dealing [1] and creating cursed water in a [2] radius.<br><br>Seaburn decreases water and air resistance.",
            ContextDescription = [[Skill tooltip for "Blue Fireball"]],
            StringKey = "Projectile_PIP_Fishing_BlueFireball_Description",
        },
        Status_Seaburn_DisplayName = {
            Handle = "hbe276f31gd6c5g475dgb83bg1690ee01327f",
            Text = "Seaburn",
            ContextDescription = [[Status name]],
            StringKey = "PIP_FISHING_SEABURN_DisplayName",
        },
        Status_Seaburn_Description = {
            Handle = "h828e84d7g9080g4345g94e3gecbb1ac24bab",
            Text = "Deals [1] every turn.",
            ContextDescription = [[Status tooltip for "Seaburn"]],
            StringKey = "PIP_FISHING_SEABURN_Description",
        },
    },
}
Epip.RegisterFeature("Fishing", "Features.Fishing.Skills", Skills)

---------------------------------------------
-- CUSTOM REQUIREMENTS
---------------------------------------------

-- Register Fishermancy requirement.
local ReqFishermancy = Ext.Stats.Requirement.Add("PIP_Fishermancy")
ReqFishermancy.Description = "Fishermancy"
ReqFishermancy.Callbacks.EvaluateCallback = function(_, ctx)
    local char = ctx.ClientCharacter or ctx.ServerCharacter ---@type Character
    if not char then return false end

    local abilityScore = Fishing.GetAbilityScore(char)
    local reqMet = abilityScore >= ctx.Requirement.Param

    if ctx.Requirement.Not then
        reqMet = not reqMet
    end
    return reqMet
end

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns the school associated with a Fishermancy skill.
---@param skillID skill
---@return AbilityType
function Skills.GetFishermancySchool(skillID)
    return Skills.FISHERMANCY_SKILLS[skillID]
end

---Returns whether a skill is from the Fishermancy ability school.
---@param skillID skill
---@return boolean
function Skills.IsFishermancySkill(skillID)
    return Skills.GetFishermancySchool(skillID) ~= nil
end
