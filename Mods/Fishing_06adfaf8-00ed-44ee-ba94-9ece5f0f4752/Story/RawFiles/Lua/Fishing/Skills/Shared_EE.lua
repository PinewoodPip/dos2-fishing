
---@class Fishing.Skills
local Skills = GetFeature("Fishing.Skills")
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
TSK.Status_Seasick_Description_EE = Skills:RegisterTranslatedString({
    Handle = "hc0ae3818gca63g4763g934bg8e3a6afed390",
    Text = "When hit by water damage, Character receives 1 Harried stack and loses 1 turn of this status.<br>Duration cannot be refreshed.",
    ContextDescription = [[Status tooltip for "Seasick" in EE]],
    StringKey = "PIP_FISHING_SEASICK_Description_EE",
})
TSK.Seasick_ShortDescription_EE = Skills:RegisterTranslatedString({
    Handle = "hb5dd9a85g3885g4d8aga24dg5816ec91faf8",
    Text = [[Seasick reduces water and air resistance and causes targets to suffer 1 Harried stack when hit by water damage, consuming a turn of the status.]],
    ContextDescription = [[Tooltip hint for skills that involve Seasick status in EE]],
})
TSK.Label_TieredStatusHint = Skills:RegisterTranslatedString({
    Handle = "hc4d47eddgb7d5g4d38g8736gdae013b8e8ef",
    Text = [[Tiered statuses apply up to tier 3 and reduce resistances; see your journal for a full description.]],
    ContextDescription = [[Tooltip for skills that apply tiered statuses]],
})

Skills.SKILL_DESCRIPTION_OVERRIDES = {
    ["Projectile_PIP_Fishing_DeployFishnets"] = Skills:RegisterTranslatedString({
        Handle = "hda273868g9d52g458fgb43cg276e5c395c9a",
        Text = "Reach for your trawling equipment and deploy [1] fishnets at target positions.<br><br>Each fishnet takes 1 turn to arm; once armed, enemies approaching within [2] of the trap will trigger the fishnet, dealing [3] damage to enemies within [4], applying up to Slowed II for 2 turns and creating a web surface.",
        ContextDescription = [[Skill tooltip for "Deploy Fishnets" in EE]],
        StringKey = "Projectile_PIP_Fishing_DeployFishnets_Description_EE",
    }),
    ["Shout_PIP_Fishing_CrabDance"] = Skills:RegisterTranslatedString({
        Handle = "ha5f616abgc232g4211g9e8bg364d63b44327",
        Text = [[Perform a crabistic ritual dance, inspiring allies in a [3] radius around you and reminding them of what truly matters, granting +[1] Constitution and +[2] Finesse, Power, and Strength.]],
        ContextDescription = [[Skill tooltip for "Crab Dance" in EE]],
        StringKey = "Shout_PIP_Fishing_CrabDance_Description_EE",
    }),
    ["Target_PIP_Fishing_CrabPinch"] = Skills:RegisterTranslatedString({
        Handle = "h85812b18g86c1g4113gad4fg98261c820be7",
        Text = [[Employ both of your pincers to pinch and punch the target, dealing [1] in a [2] radius and applying up to Weakened III.]],
        ContextDescription = [[Skill tooltip for "Crab Pinch & Punch in EE"]],
        StringKey = "Target_PIP_Fishing_CrabPinch_Description_EE",
    }),
}
-- Also apply skill description overrides to Empowered variants.
Skills.SKILL_DESCRIPTION_OVERRIDES["Shout_PIP_Fishing_CrabDance_Empowered"] = Skills.SKILL_DESCRIPTION_OVERRIDES["Shout_PIP_Fishing_CrabDance"]

Skills.SEASICK_SHORT_DESCRIPTION_TSK = TSK.Seasick_ShortDescription_EE

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
            Text = "Allies within 13m, who have at least 1 Geomancer try to cast Blast Canon Ball as a free ritual reaction at all visible enemies within 13m of them. <font color='c80030'>Pay 3 more AP:</font> Cast again on all visible enemies within 13m.",
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
            Text = "With the Currents now also activates on turn start and grants +1 turn duration to Seasick applied.",
        },
        {
            Handle = "h983dde22gc37bg4386g94b4gee4b87209d9f",
            Text = "With the Currents grants +1 turn duration to Seasick applied. Recover 1SP.",
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
    ["Summon_PIP_Fishing_Swashbuckler"] = {
        {
            Handle = "h334c05c7gc993g480dga990g8f5a51a1df23",
            Text = "Swashbuckler can now cast Chloroform and Decaying Touch.",
        },
        {
            Handle = "h11754f02g2291g4608gaf51g2a341599d8a7",
            Text = "Swashbuckler gains 2 Source Points and 1 turn of Source Generation.",
        },
        {
            Handle = "h6c669bd1g956eg4598g84a4g35d3c1966e46",
            Text = "Once per turn, Swashbuckler can now emulate Throw Knives as a free reaction against enemies it can see on which Seasick detonates.",
        },
    },
    ["Shout_PIP_Fishing_ReturnToCrab"] = {
        {
            Handle = "haf5374f7gbfbag4e89gb5f9gf8530a33f1a2",
            Text = "Apply up to Terrified III to enemies within 10m upon transforming. +1 turn duration.",
        },
        {
            Handle = "hfabd6671g159ag4a76g8ef7gb8e606a53b8e",
            Text = "Crab Form gains an Empowered Crab Dance skill that has 0 cooldown. +1 turn duration.",
        },
        {
            Handle = "hece1e35bg617ag4171g9708gf0226556867f",
            Text = "Crab Form gains Spellcaster Finesse and +40% invested Finesse. Recover 1 SP.",
        },
    },
    ["Projectile_PIP_Fishing_DeployFishnets"] = {
        {
            Handle = "h7cd22ec4g0a15g4c29g947cg21a36ee25099",
            Text = "Gain an Empowered Deploy Fishnets skill for 2 turns that has 1 turn cooldown, deploys 2 fishnets and costs 2AP.",
        },
        {
            Handle = "hefd9bbe7g564eg4a99g9bcegfa89e853fc28",
            Text = "Empowered Deploy Fishnets can now be cast for 3 turns and deploys 3 fishnets.",
        },
        {
            Handle = "h1a0c48f0g71b0g43eag8b1bgaccb259a57a6",
            Text = "Gain Trawling Grindset for 4 turns: once per turn, Predator reactions can be performed on enemies you can see when they are damaged by fishnets.",
        },
    },
    ["Target_PIP_Fishing_Sashimi"] = {
        {
            Handle = "hc4514440g22cbg4882g93c4g70b72d808243",
            Text = "+5% accuracy (+1% per Scoundrel) while casting. +20% damage (+4% per Scoundrel) while casting.",
        },
        {
            Handle = "hc59f11e5g89c7g4976g9091gf34e8055f0ec",
            Text = "+40% damage (+8% per Scoundrel) while casting.",
        },
        {
            Handle = "hb3001d98g2552g48bdgbcebg0948583ca05d",
            Text = "Attempt to sneak after casting. If your target dies while casting this skill, gain Slashimi for 3 turns: once per turn per target, your basic attack applies Seasick for 1 turn.",
        },
    },
    ["Shout_PIP_Fishing_Hornpipe"] = {
        {
            Handle = "hee2435ebgceabg4e2dg85c2gcfb0ba89747e",
            Text = "Horned Pipe Hype grants +10% water resistance (+1% per Hydrosophist). +1 turn duration.",
        },
        {
            Handle = "h6538ee15gdf35g4a81gadaeg4cdef5ba1a54",
            Text = "Horned Pipe Hype restores 7% (+1% per Hydrosophist) missing Magic Armor upon activating Seasick."
        },
        {
            Handle = "hfdab024dge097g48b7gb48ag374b8451e257",
            Text = "Horned Pipe Hype grants +10% critical chance (+1% per Hydrosophist). While Horned Pipe Hype is active, once per turn, activating Seasick with critical hits reduces the cooldown of Hydrosophist skills by 1 turn.",
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
        AmountOfTargets = 4, -- Reduced since the skill has 0SP base cost in EE.
        ["Magic Cost"] = 0,
    },
    ["Projectile_PIP_Fishing_FishNet"] = {
        SkillPropertyRemap = {
            ["SLOWED"] = "AMER_SLOWED_2",
        },
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
    ["Shout_PIP_Fishing_SwashbucklingAura"] = {
        ActionPoints = 4,
    },
    ["Target_PIP_Fishing_CrabPinch"] = {
        ActionPoints = 4,
        SkillPropertyRemap = {
            ["WEAK"] = "AMER_WEAKENED_APPLY",
        },
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
-- Also show SIs for Empowered skill variants.
Skills.SOURCE_INFUSION_TSKS["Projectile_PIP_Fishing_DeployFishnets_Empowered_1"] = Skills.SOURCE_INFUSION_TSKS["Projectile_PIP_Fishing_DeployFishnets"]
Skills.SOURCE_INFUSION_TSKS["Projectile_PIP_Fishing_DeployFishnets_Empowered_2"] = Skills.SOURCE_INFUSION_TSKS["Projectile_PIP_Fishing_DeployFishnets"]

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

        -- Replace skill descriptions.
        for skill,tsk in pairs(Skills.SKILL_DESCRIPTION_OVERRIDES) do
            local skillData = Stats.Get("StatsLib_StatsEntry_SkillData", skill)
            skillData.Description = tsk.StringKey
        end

        -- Remove armor damage from Seasick.
        local seasickSkill = Stats.Get("StatsLib_StatsEntry_SkillData", "Projectile_PIP_Fishing_Seasick_ScriptedDamage")
        seasickSkill["Damage Multiplier"] = 0
        seasickSkill["Damage Range"] = 0

        -- Replace Seasick description.
        local seasickStatus = Stats.Get("StatsLib_StatsEntry_StatusData", "PIP_FISHING_SEASICK")
        seasickStatus.Description = TSK.Status_Seasick_Description_EE.StringKey
    end
end, {StringID = "Fishing.Skills.EE_Overrides"})
