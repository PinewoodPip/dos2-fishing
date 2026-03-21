
---@class Features.Fishing.Skills
local Skills = GetFeature("Features.Fishing.Skills")
local TSK = Skills.TranslatedStrings

-- Register TSKs
TSK.Label_SourceInfusions = Skills:RegisterTranslatedString({
    Handle = "h2e21d306gd493g49ddg99ecg23d0973d421b",
    Text = "Source Infusions:",
    ContextDescription = [[Tooltip for skills in EE]],
})
TSK.Label_SourceInfusionRequirement = Skills:RegisterTranslatedString({
    Handle = "h4877ab7dgdc86g4187g8a46gab32870fe0e6",
    Text = "(requires %d %s)",
    ContextDescription = [[Tooltip for Source Infusions; params are ability score and ability type]],
})

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
    },
    ["Target_PIP_Fishing_ReelIn"] = {
        {
            Handle = "h4c0461bbgc6e3g4a5eg859cg13c14d077c7b",
            Text = "+5% accuracy (+1% per Warfare) while casting. Apply up to Slowed III to target for 2 turns.",
        },
        {
            Handle = "h3da30147gca72g4e45gaafeg11eec60d860b",
            Text = "-0.5m (-0.1m per Warfare) distance threshold for dealing damage while reeling in. Recover 1AP.",
        },
        {
            Handle = "h8ca33dc7gb437g4ca0g910cge14f5baf5469",
            Text = "<font color='c80030'>Pay 3 more AP:</font> Cast again on all visible enemies within 15m.",
        },
    },
    ["Shout_PIP_Fishing_WithTheCurrents"] = {
        {
            Handle = "h7bf03231g8669g4705gb52cge1f51507a071",
            Text = "Apply 1 Battered to targets struck. +1 turn duration.",
        },
        {
            Handle = "h3ca36071gd8abg4296g806cg04c68e54126b",
            Text = "With the Currents now also activates on turn start and grants +1 turn duration to Seaburn applied.",
        },
        {
            Handle = "h983dde22gc37bg4386g94b4gee4b87209d9f",
            Text = "With the Currents grants +1 turn duration to Seaburn applied. Recover 1SP.",
        },
    },
    ["Shout_PIP_Fishing_TurnOnTheTides"] = {
        {
            Handle = "h69fa4245g06abg4744g90cegc21a3df89592",
            Text = "+2m splash range to Turned On Tides. +1 turn duration.",
        },
        {
            Handle = "hcf05c040g7901g4512ga643gc8952e18fb2f",
            Text = "Also apply to allied heroes within 13m, including self. Turned On Tides grants +1 Hydrosophist to summons.",
        },
        {
            Handle = "h95e991d4g1047g45bdg8d6dgb4b28dc1f01f",
            Text = "Turned On Tides creates +1 splash at the start of turn.",
        },
    },
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
            ["CRIPPLED"] = "", -- Applied via SI1 instead.
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
