
local Fishing = Epip.GetFeature("Features.Fishing")

---@class Features.Fishing.Skills : Feature
local Skills = {
    ---Maps a Fishermancy skill to its associated other school.
    ---@type table<string, AbilityType>
    FISHERMANCY_SKILLS = {
        ["Projectile_PIP_Fishing_BlueFireball"] = "FireSpecialist",
        ["Shout_PIP_Fishing_Hornpipe"] = "WaterSpecialist",
        ["Target_PIP_Fishing_Sashimi"] = "RogueLore",
        ["Shout_PIP_Fishing_WithTheCurrents"] = "AirSpecialist",
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
        Skill_Hornpipe_DisplayName = {
            Handle = "hb1ec7f6dg8d10g461bga0dcg5ac5945f0004",
            Text = "Blow the Hornpipe",
            ContextDescription = [[Skill name]],
            StringKey = "Shout_PIP_Fishing_Hornpipe_DisplayName",
        },
        Skill_Hornpipe_Description = {
            Handle = "h3a713104g80b4g426ag8ed7ga2747320e096",
            Text = "Get the voyage started on the right foot by blowing the hornpipe, applying Horned Pipe Spirit to allies in range.<br>Horned Pipe Spirit restores 1% Vitality and Magic Armor per point in the status owner's Fishermancy upon dealing a critical hit.",
            ContextDescription = [[Skill tooltip for "Blow the Hornpipe"]],
            StringKey = "Shout_PIP_Fishing_Hornpipe_Description",
        },
        Skill_Sashimi_DisplayName = {
            Handle = "hd7910501gf347g4ba1gb973gb602f88e61ee",
            Text = "Prepare Sashimi",
            ContextDescription = [[Skill name]],
            StringKey = "Target_PIP_Fishing_Sashimi_DisplayName",
        },
        Skill_Sashimi_Description = {
            Handle = "h48590371g58b1g4d5bga23dgfc37d526e44c",
            Text = "Attempt to process the target into sashimi, dealing [1]. If a non-boss target has Seaburn and less than 20% (+1% per Fishermancy) Vitality, it dies and becomes sashimi.",
            ContextDescription = [[Skill tooltip for "Prepare Sashimi"]],
            StringKey = "Target_PIP_Fishing_Sashimi_Description",
        },
        Skill_WithTheCurrents_DisplayName = {
            Handle = "hdd0db2b3ge2ecg4735gb980gc3110a2ca2c2",
            Text = "With the Currents",
            ContextDescription = [[Skill name]],
            StringKey = "Shout_PIP_Fishing_WithTheCurrents_DisplayName",
        },
        Skill_WithTheCurrents_Description = {
            Handle = "hff2e328bg115eg4d46g9c1fge2fc231a8c31",
            Text = "Create a cursed water surface and apply With the Currents to yourself, summoning a ring of fish around you that will bite enemies that move or are moved within [1] of you, dealing [2], applying Seaburn and creating a cursed water surface.",
            ContextDescription = [[Skill tooltip for "With the Currents"]],
            StringKey = "Shout_PIP_Fishing_WithTheCurrents_Description",
        },
        Status_Seaburn_DisplayName = {
            Handle = "hbe276f31gd6c5g475dgb83bg1690ee01327f",
            Text = "Seaburn",
            ContextDescription = [[Status name]],
            StringKey = "PIP_FISHING_SEABURN_DisplayName",
        },
        Status_Seaburn_Description = {
            Handle = "h828e84d7g9080g4345g94e3gecbb1ac24bab",
            Text = "Deals [1] every turn.<br>Reduces water and air resistance.",
            ContextDescription = [[Status tooltip for "Seaburn"]],
            StringKey = "PIP_FISHING_SEABURN_Description",
        },
        Status_Hornpipe_DisplayName = {
            Handle = "h8b39a27age17cg4527gbaaeg9963bbd7230d",
            Text = "Horned Pipe Spirit",
            ContextDescription = [[Status name]],
        },
        Status_Hornpipe_Description = {
            Handle = "h088afc65gf93dg4220gabefg08d09791dbe2",
            Text = "Restores 1% Vitality and Magic Armor per point in the status owner's Fishermancy upon dealing a critical hit.",
            ContextDescription = [[Status tooltip for "Horned Pipe Spirit"]],
        },
        Status_WithTheCurrent_DisplayName = {
            Handle = "h7fda51b1g17ecg4e7eg92acge597024dc68d",
            Text = "With the Currents",
            ContextDescription = [[Status name]],
            StringKey = "PIP_FISHING_WITH_THE_CURRENT_DisplayName",
        },
        Status_WithTheCurrent_Description = {
            Handle = "h62dd5ff4g57e7g4525gaf99g6924095308a2",
            Text = "TODO",
            ContextDescription = [[Status tooltip for "With the Currents"]],
            StringKey = "PIP_FISHING_WITH_THE_CURRENT_Description",
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
