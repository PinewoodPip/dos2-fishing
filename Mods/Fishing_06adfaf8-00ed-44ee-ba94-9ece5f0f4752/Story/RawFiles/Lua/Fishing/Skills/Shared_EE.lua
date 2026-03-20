
---@class Features.Fishing.Skills
local Skills = GetFeature("Features.Fishing.Skills")

-- Register TSKs
---@type table<skill, TextLib_TranslatedString[]>
local SourceInfusionTSKs = {
    ["Projectile_PIP_Fishing_BlueFireball"] = {
        {
            Handle = "h1ee6f732g370ag49aega344g42d455c76628",
            Text = "+25% damage (+4% per Pyrokinetic) while casting.",
        },
        {
            Handle = "h0fa415f0g1b5ag4f89gbfe0g415029832b3f",
            Text = "+40% damage (+8% per Pyrokinetic) while casting. Allies within 13m of your target, who have at least 1 Pyrokinetic try to cast Blue Fireball with reduced damage as a free ritual reaction at a random visible enemy within 13m of them.",
        },
        {
            Handle = "h08b0a406g668ag403eg82bag059eb9eb03f0",
            Text = "<font color='c80030'>Pay 3 more AP:</font> Cast again on every visible enemy within 13m.",
        },
    },
    ["Projectile_PIP_Fishing_CannonBall"] = {
        {
            Handle = "h433adf49gbc57g42d2ga57cga268a085b53e",
            Text = "+25% damage (+4% per Geomancer) while casting.",
        },
        {
            Handle = "h0810e51bg7c61g437agac83g537db5fa98da",
            Text = "+40% damage (+8% per Geomancer) and +1m push distance per Geomancer while casting.",
        },
        {
            Handle = "h65c6c5b5g2745g4442ga70bg5b9db0322037",
            Text = "Allies within 13m, who have at least 1 Geomancer try to cast Shoot Canon Ball as a free ritual reaction at all visible enemies within 13m of them. <font color='c80030'>Pay 3 more AP:</font> Cast again on all visible enemies within 13m.",
        },
    }
}
for skill,tsks in pairs(SourceInfusionTSKs) do
    for _,tskData in ipairs(tsks) do
        tskData.ContextDescription = string.format("%s skill Source Infusion tooltip", skill)
        Skills:RegisterTranslatedString(tskData)
    end
end

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

-- Maps skills to their Source Infusion descriptions.
---@type table<skill, TextLib_TranslatedString[]>
Skills.SOURCE_INFUSION_TSKS = {}
for skill,tsks in pairs(SourceInfusionTSKs) do
    Skills.SOURCE_INFUSION_TSKS[skill] = {}
    for i,tsk in ipairs(tsks) do
        Skills.SOURCE_INFUSION_TSKS[skill][i] = tsk
    end
end

-- Maps SI level to their requirement of the skill's associated ability.
Skills.SOURCE_INFUSION_LEVEL_TO_ABILITY_REQUIREMENT = {
    [2] = 5,
    [3] = 9,
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
