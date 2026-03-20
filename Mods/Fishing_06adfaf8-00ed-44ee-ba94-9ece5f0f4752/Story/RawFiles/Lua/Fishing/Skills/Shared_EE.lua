
---@class Features.Fishing.Skills
local Skills = GetFeature("Features.Fishing.Skills")

-- Maps skills to stat property overrides to apply when EE is enabled.
-- **Remapping SkillProperties only supports Status-type properties.**
---@type table<skill, StatsLib_StatsEntry_SkillData|{SkillPropertyRemap: table<string, string>}>
Skills.EE_STATS_OVERRIDES = {
    ["Projectile_PIP_Fishing_BlueFireball"] = {
        ActionPoints = 4,
    },
    ["Shout_PIP_Fishing_Hornpipe"] = {
        ActionPoints = 2,
    },
    ["Projectile_PIP_Fishing_DeployFishnets"] = {
        ActionPoints = 4,
    },
    ["Target_PIP_Fishing_Sashimi"] = {
        ActionPoints = 5,
        ["Magic Cost"] = 0,
        SkillPropertyRemap = {
            ["DISARMED"] = "AMER_ATAXIA_APPLY",
        },
    },
    ["Shout_PIP_Fishing_ReturnToCrab"] = {
        ActionPoints = 3,
    },
    ["Shout_PIP_Fishing_WithTheCurrents"] = {
        ActionPoints = 2,
    },
    ["Target_PIP_Fishing_ReelIn"] = {
        ActionPoints = 4,
        SkillPropertyRemap = {
            ["CRIPPLED"] = "AMER_SLOWED_APPLY",
        },
    },
    ["Projectile_PIP_Fishing_CannonBall"] = {
        ActionPoints = 4,
    },
    ["Summon_PIP_Fishing_Swashbuckler"] = {
        ActionPoints = 4,
    },
    ["Shout_PIP_Fishing_TurnOnTheTides"] = {
        ActionPoints = 4,
        ["Magic Cost"] = 0,
    },
}

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Apply EE-specific stat overrides.
Ext.Events.StatsLoaded:Subscribe(function (_)
    if EpicEncounters.IsEnabled() then
        for skillID,statOverrides in pairs(Skills.EE_STATS_OVERRIDES) do
            local skill = Stats.Get("StatsLib_StatsEntry_SkillData", skillID)
            for field,value in pairs(statOverrides) do
                -- Remap skill properties
                if field == "SkillPropertyRemap" then
                    local skillProps = skill.SkillProperties
                    for oldProp,newProp in pairs(value) do
                        for i,prop in ipairs(skillProps) do
                            ---@cast prop StatPropertyStatus
                            if prop.Type == "Status" and prop.Action == oldProp then
                                skillProps[i] = {
                                    Type = "Status",
                                    Action = newProp,
                                    Context = prop.Context,
                                    Duration = prop.Duration,
                                    StatsId = prop.StatsId,
                                    StatusChance = prop.StatusChance,
                                    SurfaceBoost = prop.SurfaceBoost,
                                    SurfaceBoosts = prop.SurfaceBoosts,
                                }
                            end
                        end
                    end
                    skill.SkillProperties = skillProps
                else -- Simply field overrides
                    skill[field] = value
                end
            end
        end
    end
end, {StringID = "Fishing.Skills.EE_Overrides"})
