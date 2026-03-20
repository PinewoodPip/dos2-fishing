
local Fishing = GetFeature("Features.Fishing")
local CommonStrings = Text.CommonStrings

---@class Features.Fishing.Skills : Feature
local Skills = {
    ---Maps a Fishermancy skill to its associated other school.
    ---@type table<string, AbilityType>
    FISHERMANCY_SKILLS = {
        ["Projectile_PIP_Fishing_BlueFireball"] = "FireSpecialist",
        ["Shout_PIP_Fishing_Hornpipe"] = "WaterSpecialist",
        ["Projectile_PIP_Fishing_DeployFishnets"] = "RangerLore",
        ["Target_PIP_Fishing_Sashimi"] = "RogueLore",
        ["Shout_PIP_Fishing_ReturnToCrab"] = "Polymorph",
        ["Shout_PIP_Fishing_WithTheCurrents"] = "AirSpecialist",
        ["Target_PIP_Fishing_ReelIn"] = "WarriorLore",
        ["Projectile_PIP_Fishing_CannonBall"] = "EarthSpecialist",
        ["Summon_PIP_Fishing_Swashbuckler"] = "Necromancy",
        ["Shout_PIP_Fishing_TurnOnTheTides"] = "Summoning",
    },

    SOURCE_INFUSION_COLOR = "46B195",

    TranslatedStrings = {
        Label_Skillbook = {
            Handle = "hc8b2f0aagf897g4d3bg93f1g4f653c89d697",
            Text = "%s Skillbook",
            ContextDescription = [[Item name for skillbooks; param is the skill name]],
        },
        Label_SkillProperty_Push = {
            Handle = "h81e9467fg5475g407agb8afg2e7eab29b164",
            Text = "Pushes targets back.",
            ContextDescription = [[Tooltip for cannonball skill effect]],
        },
        Label_SkillProperty_ReelIn = {
            Handle = "hf37f3b85g628fg47cdg898ag02fa0efadb1f",
            Text = "Reels in targets.",
            ContextDescription = [[Tooltip for reel-in skill effect]],
        },
        Label_SkillProperty_Sashimi = {
            Handle = "h00e143a8g2b5dg466cg8848g7de7bda87915",
            Text = "Processes targets into sashimi.",
            ContextDescription = [[Tooltip for sashimi skill effect]],
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
        Skill_ReelIn_DisplayName = {
            Handle = "h1962c37eg0600g4728g9343g42d8674ce596",
            Text = "Reel In",
            ContextDescription = [[Skill name]],
            StringKey = "Target_PIP_Fishing_ReelIn_DisplayName",
        },
        Skill_ReelIn_Description = {
            Handle = "h0999dbacgde3eg430ag8071gee3d46d1aeab",
            Text = "Reel in a big catch, dealing [1] and pulling targets towards your position.<br>Targets receive piercing damage every 4m travelled (-0.2m per Fishermancy) while being reeled in.",
            ContextDescription = [[Skill tooltip for "Reel In"]],
            StringKey = "Target_PIP_Fishing_ReelIn_Description",
        },
        Skill_ReturnToCrab_DisplayName = {
            Handle = "h5d1bf810g13b9g444ag8c03gff685503e424",
            Text = "Return to Crab",
            ContextDescription = [[Skill name]],
            StringKey = "Shout_PIP_Fishing_ReturnToCrab_DisplayName",
        },
        Skill_ReturnToCrab_Description = {
            Handle = "ha744eb2cg180eg4594g9fffg7e613e0a21b6",
            Text = "Abandon modernity and return to your primordial origin, becoming crab.<br>Crab form is immune to surfaces and clouds and knows Crab Pinch & Punch, Breath of Fresh Sea Air, Burrow, Crab Dance, and can evolve back into your former form.",
            ContextDescription = [[Skill tooltip for "Return to Crab"]],
            StringKey = "Shout_PIP_Fishing_ReturnToCrab_Description",
        },
        Skill_ReturnToModernity_DisplayName = {
            Handle = "he2f3484fgb3ccg4b42g888cg87a5e0963a04",
            Text = "Return to Modernity",
            ContextDescription = [[Skill name (crab form)]],
            StringKey = "Shout_PIP_Fishing_ReturnToModernity_DisplayName",
        },
        Skill_ReturnToModernity_Description = {
            Handle = "hdb9b640fg72eeg4ee5g8b60g634266c8ce76",
            Text = "Downgrade to your former form.",
            ContextDescription = [[Skill tooltip for "Return to Modernity"]],
            StringKey = "Shout_PIP_Fishing_ReturnToModernity_Description",
        },
        Skill_DeployFishnets_DisplayName = {
            Handle = "h322704d1gdaf7g46e1ga366g6edd7db52a6f",
            Text = "Deploy Fishnets",
            ContextDescription = [[Skill name]],
            StringKey = "Projectile_PIP_Fishing_DeployFishnets_DisplayName",
        },
        Skill_DeployFishnets_Description = {
            Handle = "h4b9d4d07g868eg49e0g8532g301e913d7012",
            Text = "Reach for your equipment and deploy [1] fish nets at target positions. Each fish net takes 1 turn to activate; after arming, enemies approaching will trigger the fishnet, dealing [2] damage to enemies within [3], applying Disarmed for 1 turn and creating a web surface.",
            ContextDescription = [[Skill tooltip for "Deploy Fishnets"]],
            StringKey = "Projectile_PIP_Fishing_DeployFishnets_Description",
        },
        Skill_CrabPinch_DisplayName = {
            Handle = "h01a13c16g65bag4241ga135g202f845fa140",
            Text = "Pinch & Punch",
            ContextDescription = [[Skill name (for crab form)]],
            StringKey = "Target_PIP_Fishing_CrabPinch_DisplayName",
        },
        Skill_CrabPinch_Description = {
            Handle = "h224e8ff6gedb4g4110ga774g536978cd239b",
            Text = "Employ both your pincers to pinch and punch the target, dealing [1] in a [2] radius.",
            ContextDescription = [[Skill tooltip for "Crab Pinch & Punch"]],
            StringKey = "Target_PIP_Fishing_CrabPinch_Description",
        },
        Skill_BreathOfFreshSeaAir_DisplayName = {
            Handle = "he28de083gf004g42edgb73dgb756b524b76a",
            Text = "Breath of Fresh Sea Air",
            ContextDescription = [[Skill name (for crab form)]],
            StringKey = "Cone_PIP_Fishing_BreathOfFreshSeaAir_DisplayName",
        },
        Skill_BreathOfFreshSeaAir_Description = {
            Handle = "h370f563cgbdf8g49d3g9427g8e7d4c6b3b10",
            Text = "Breathe some fresh air into the target's personal space, dealing [1] and creating a blessed water surface in a [2], [3] degree cone.",
            ContextDescription = [[Skill tooltip for "Breath of Fresh Sea Air"]],
            StringKey = "Cone_PIP_Fishing_BreathOfFreshSeaAir_Description",
        },
        Skill_CrabDance_DisplayName = {
            Handle = "h4bcfe654g2e18g470egbfa9gde53ed7f0b3b",
            Text = "Crab Dance",
            ContextDescription = [[Skill name (for crab form)]],
            StringKey = "Shout_PIP_Fishing_CrabDance_DisplayName",
        },
        Skill_CrabDance_Description = {
            Handle = "h91b81eb2gdb9ag4a19g8492g7529fe95d83b",
            Text = "Perform a crabistic ritual dance, inspiring allies and reminding them of what truly matters.",
            ContextDescription = [[Skill tooltip for "Crab Dance"]],
            StringKey = "Shout_PIP_Fishing_CrabDance_Description",
        },
        Skill_CannonBall_DisplayName = {
            Handle = "hcf883158g721eg4daeg98beg0d979e8f86c2",
            Text = "Shoot Canon Ball",
            ContextDescription = [[Skill name]],
            StringKey = "Projectile_PIP_Fishing_CannonBall_DisplayName",
        },
        Skill_CannonBall_Description = {
            Handle = "h4a09fa59gc72dg4e2dgb935gb91783945e69",
            Text = "Shoot the canonical cannon ball, dealing [1] in a wonderfully straight line and pushing away targets hit by 7m (+1m per Fichermancy). Targets pushed into walls or obstacles cause [2] to characters within [3] of their impact.",
            ContextDescription = [[Skill tooltip for "Shoot Canon Ball"]],
            StringKey = "Projectile_PIP_Fishing_CannonBall_Description",
        },
        Skill_SwashbucklingAura_DisplayName = {
            Handle = "hbb7dda26g0b44g477bgab71g3ef7233d81e0",
            Text = "Swashbuckling Spirit",
            ContextDescription = [[Skill name (necromancer summon)]],
            StringKey = "Shout_PIP_Fishing_SwashbucklingAura_DisplayName",
        },
        Skill_SwashbucklingAura_Description = {
            Handle = "h0ee5e72agfda1g42c6gbfc9g40260ed83780",
            Text = "TODO",
            ContextDescription = [[Skill tooltip for "Swashbuckling Spirit" (necromancer summon)]],
            StringKey = "Shout_PIP_Fishing_SwashbucklingAura_Description",
        },
        Skill_SummonSwashbuckler_DisplayName = {
            Handle = "ha46a9cbcg01cdg4425g864eg0d85f385523c",
            Text = "Summon Swashbuckler",
            ContextDescription = [[Skill name]],
            StringKey = "Summon_PIP_Fishing_Swashbuckler_DisplayName",
        },
        Skill_SummonSwashbuckler_Description = {
            Handle = "h30a9a1f0g0d04g4c62g9935g051dba84d38c",
            Text = "Summon the trusty ol' crew, an undead swashbuckler who knows Ice Shard, Terrifying Cruelty, Execute, Dust Blast and Swashbuckling Spirit.<br>Swashbuckling Spirit grants water-based weapon coating to nearby allies while active.",
            ContextDescription = [[Skill tooltip for "Summon Swashbuckler"]],
            StringKey = "Summon_PIP_Fishing_Swashbuckler_Description",
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
        Skill_TurnOnTheTides_DisplayName = {
            Handle = "hc021a1a9gce11g4ed7g8b55g7599019f12b7",
            Text = "Turn on The Tides",
            ContextDescription = [[Skill name]],
            StringKey = "Shout_PIP_Fishing_TurnOnTheTides_DisplayName",
        },
        Skill_TurnOnTheTides_Description = {
            Handle = "ha3dd6e66g284fg4550ga6edgb98c7721f660",
            Text = "Apply Turned On Tides to allied summons, causing them to splash a burst of water at the start of their turns, dealing [1] within [2].",
            ContextDescription = [[Skill tooltip for "Turn on The Tides"]],
            StringKey = "Shout_PIP_Fishing_TurnOnTheTides_Description",
        },
        Status_TurnOnTheTides_DisplayName = {
            Handle = "h146da339gbae2g453dgb25bgb8d1d4d73b12",
            Text = "Turned On Tides",
            ContextDescription = [[Status name]],
            StringKey = "PIP_Fishing_TurnOnTheTides_DisplayName",
        },
        Status_TurnOnTheTides_Description = {
            Handle = "h6fd8b98bg7685g4a8dgaa29g894ee2c1b003",
            Text = "Character causes a burst of waves at the start of their turn, dealing water damage to enemies near them.",
            ContextDescription = [[Tooltip for "Turned On Tides" status]],
            StringKey = "PIP_Fishing_TurnOnTheTides_Description",
        },
        Status_CrabForm_DisplayName = {
            Handle = "h246a2d29g33b1g4befgb733g2dea55daefae",
            Text = "Crab Form",
            ContextDescription = [[Status name]],
            StringKey = "PIP_Polymorphed_Crab_DisplayName",
        },
        Status_CrabForm_Description = {
            Handle = "hfe4ebc0aga743g44a5gb362gf28d17dc7da5",
            Text = "Character is immune to surfaces, but most importantly, is a crab.",
            ContextDescription = [[Status tooltip for "Crab Form"]],
            StringKey = "PIP_Polymorphed_Crab_Description",
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
        Status_WaterCoating_DisplayName = {
            Handle = "h080ffb54g3995g4253gb58ag8189c9f6bc7f",
            Text = "Swashbuckling Spirit",
            ContextDescription = [[Status name]],
            StringKey = "PIP_FISHING_WATER_COATING_DisplayName",
        },
        Status_WaterCoating_Description = {
            Handle = "hc65843e2gd089g426dga6a8g825afa745a8f",
            Text = "Invigorated by the crew; weapon attacks gain additional water damage.",
            ContextDescription = [[Status tooltip for "Swashbuckling Spirit"]],
            StringKey = "PIP_FISHING_WATER_COATING_Description",
        },
        Status_WaterCoatingAura_DisplayName = {
            Handle = "hb0b91f35g12bbg417cg97abg1f3921ef1e03",
            Text = "Swashbuckling Spirit Giver",
            ContextDescription = [[Status name]],
            StringKey = "PIP_FISHING_WATER_COATING_AURA_DisplayName",
        },
        Status_Hornpipe_DisplayName = {
            Handle = "h8b39a27age17cg4527gbaaeg9963bbd7230d",
            Text = "Horned Pipe Spirit",
            ContextDescription = [[Status name]],
            StringKey = "PIP_Fishing_Hornpipe_DisplayName",
        },
        Status_Hornpipe_Description = {
            Handle = "h088afc65gf93dg4220gabefg08d09791dbe2",
            Text = "Restores 1% Vitality and Magic Armor per point in the status owner's Fishermancy upon dealing a critical hit.",
            ContextDescription = [[Status tooltip for "Horned Pipe Spirit"]],
            StringKey = "PIP_Fishing_Hornpipe_Description",
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

        Label_SourceInfusions = {
            Handle = "h2e21d306gd493g49ddg99ecg23d0973d421b",
            Text = "Source Infusions:",
            ContextDescription = [[Tooltip for skills in EE]],
        },
        Label_SourceInfusionRequirement = {
            Handle = "h4877ab7dgdc86g4187g8a46gab32870fe0e6",
            Text = "(requires %d %s)",
            ContextDescription = [[Tooltip for Source Infusions; params are ability score and ability type]],
        },
        SourceInfusion_BlueFireBall_1 = {
            Handle = "h1ee6f732g370ag49aega344g42d455c76628",
            Text = "+25% damage (+4% per Pyrokinetic) while casting.",
            ContextDescription = [[Blue Fireball Source Infusion 1 tooltip]],
        },
        SourceInfusion_BlueFireBall_2 = {
            Handle = "h0fa415f0g1b5ag4f89gbfe0g415029832b3f",
            Text = "+40% damage (+8% per Pyrokinetic) while casting. Allies within 13m of your target, who have at least 1 Pyrokinetic try to cast Blue Fireball with reduced damage as a free ritual reaction at a random visible enemy within 13m of them.",
            ContextDescription = [[Blue Fireball Source Infusion 2 tooltip]],
        },
        SourceInfusion_BlueFireBall_3 = {
            Handle = "h08b0a406g668ag403eg82bag059eb9eb03f0",
            Text = "<font color='c80030'>Pay 3 more AP:</font> Cast again on every visible enemy within 13m.",
            ContextDescription = [[Blue Fireball Source Infusion 3 tooltip]],
        },
        SourceInfusion_CannonBall_1 = {
            Handle = "h433adf49gbc57g42d2ga57cga268a085b53e",
            Text = "+25% damage (+4% per Geomancer) while casting.",
            ContextDescription = [[Cannonball skill Source Infusion 1 tooltip]],
        },
        SourceInfusion_CannonBall_2 = {
            Handle = "h0810e51bg7c61g437agac83g537db5fa98da",
            Text = "+40% damage (+8% per Geomancer) and +1m push distance per Geomancer while casting.",
            ContextDescription = [[Cannonball skill Source Infusion 2 tooltip]],
        },
        SourceInfusion_CannonBall_3 = {
            Handle = "h65c6c5b5g2745g4442ga70bg5b9db0322037",
            Text = "Allies within 13m, who have at least 1 Geomancer try to cast Shoot Canon Ball as a free ritual reaction at all visible enemies within 13m of them. <font color='c80030'>Pay 3 more AP:</font> Cast again on all visible enemies within 13m.",
            ContextDescription = [[Cannonball skill Source Infusion 3 tooltip]],
        },
    },
}
RegisterFeature("Features.Fishing.Skills", Skills)
local TSK = Skills.TranslatedStrings

-- Maps skills to the TSK for their custom skill property.
---@type table<skill, TextLib_TranslatedString>
Skills.SKILL_PROPERTIES = {
    ["Target_PIP_Fishing_ReelIn"] = TSK.Label_SkillProperty_ReelIn,
    ["Target_PIP_Fishing_Sashimi"] = TSK.Label_SkillProperty_Sashimi,
    ["Projectile_PIP_Fishing_CannonBall"] = TSK.Label_SkillProperty_Push,
}

-- Maps skills to their Source Infusion descriptions.
---@type table<skill, TextLib_TranslatedString[]>
Skills.SOURCE_INFUSION_TSKS = {
    ["Projectile_PIP_Fishing_CannonBall"] = {
        TSK.SourceInfusion_CannonBall_1,
        TSK.SourceInfusion_CannonBall_2,
        TSK.SourceInfusion_CannonBall_3,
    },
    ["Projectile_PIP_Fishing_BlueFireball"] = {
        TSK.SourceInfusion_BlueFireBall_1,
        TSK.SourceInfusion_BlueFireBall_2,
        TSK.SourceInfusion_BlueFireBall_3,
    },
}

-- Maps SI level to their requirement of the skill's associated ability.
Skills.SOURCE_INFUSION_LEVEL_TO_ABILITY_REQUIREMENT = {
    [2] = 5,
    [3] = 9,
}

---@type table<SkillAbility, TextLib_TranslatedString>
Skills.ABILITY_TO_NAME_TSK = {
    ["Air"] = CommonStrings.Aerotheurge,
    ["Earth"] = CommonStrings.Geomancer,
    ["Fire"] = CommonStrings.Pyrokinetic,
    ["Water"] = CommonStrings.Hydrosophist,
    ["Warrior"] = CommonStrings.Warfare,
    ["Rogue"] = CommonStrings.Scoundrel,
    ["Summoning"] = CommonStrings.Summoning,
    ["Polymorph"] = CommonStrings.Polymorph,
    ["Death"] = CommonStrings.Necromancer,
}

---------------------------------------------
-- CUSTOM REQUIREMENTS
---------------------------------------------

-- Register Fishermancy requirement.
local ReqFishermancy = Ext.Stats.Requirement.Add("PIP_Fishermancy")
ReqFishermancy.Description = "Fishermancy"
ReqFishermancy.Callbacks.EvaluateCallback = function(_, ctx)
    local char = ctx.ClientCharacter or ctx.ServerCharacter ---@type Character
    if not char then -- Requirements on items (ex. skillbooks) do not set the character fields; infer the character from the stats object instead.
        local charStats = ctx.CharacterStats ---@type CDivinityStats_Character
        local charGUID = charStats.MyGuid
        char = Character.Get(charGUID)
    end
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
