
local Fishing = GetFeature("Fishing")

---@class Fishing.Skills
local Skills = GetFeature("Fishing.Skills")

Skills.HORNPIPE_TUNING = {
    SEASICK_EXTRA_DURATION = 6.0, -- In seconds.
}
local TUNING = Skills.HORNPIPE_TUNING

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Hornpipe status: crits against Wet or Seasick'd enemies restore Vitality and Magic Armor to the attacker.
-- TODO limit to once per turn?
Ext.Events.StatusHitEnter:Subscribe(function (ev)
    local context = ev.Context
    local attackerHandle = context.Status.HitByHandle
    if Ext.Utils.GetHandleType(attackerHandle) ~= "ServerCharacter" then return end
    local attacker = Character.Get(attackerHandle)
    local status = attacker:GetStatus("PIP_Fishing_Hornpipe")
    if status and ev.Hit.Hit.CriticalHit then
        local VITALITY_PER_POINT = 1
        local MAGIC_ARMOR_PER_POINT = 1
        local statusSource = Character.Get(status.OwnerHandle)
        local sourceFishermancy = Fishing.GetAbilityScore(statusSource)
        local currentHPPercentage = attacker.Stats.CurrentVitality / attacker.Stats.MaxVitality * 100
        local healAmount = VITALITY_PER_POINT * sourceFishermancy
        local healMagicArmorAmount = MAGIC_ARMOR_PER_POINT * sourceFishermancy
        Osi.CharacterSetHitpointsPercentage(attacker.MyGuid, currentHPPercentage + healAmount)
        Osi.CharacterSetMagicArmorPercentage(attacker.MyGuid, currentHPPercentage + healMagicArmorAmount)
        -- TODO some splash visual
    end
end)

-- SI3 effect: reduce cooldowns of Hydrosophist skills when proccing Seasick with crits.
Osiris.RegisterSymbolListener("PROC_PIP_ReduceCooldowns", 3, "before", function (charGUID, skillAbility, lifetime)
    local char = Character.Get(charGUID)
    local skillManager = char.SkillManager
    for _,skill in pairs(skillManager.Skills) do
        local stat = Stats.Get("StatsLib_StatsEntry_SkillData", skill.SkillId)
        local ability = Stats.SKILL_ABILITY_TO_STATISTIC[stat.Ability] -- Remap to SkillData ability IDs.
        if ability == skillAbility then
            skill.ActiveCooldown = math.max(0, skill.ActiveCooldown - lifetime)
            skill.ShouldSyncCooldown = true
        end
    end
end)

-- Increase duration of Seasick applied by characters with Hornpipe.
Ext.Events.BeforeStatusApply:Subscribe(function (ev)
    local status = ev.Status
    if status.StatusId == "PIP_FISHING_SEASICK" then
        local sourceHandle = status.StatusSourceHandle
        if Ext.Utils.GetHandleType(sourceHandle) ~= "ServerCharacter" then return end
        local source = Character.Get(sourceHandle)
        if not source:GetStatus("PIP_Fishing_Hornpipe") then return end
        status.LifeTime = status.LifeTime + TUNING.SEASICK_EXTRA_DURATION
        status.CurrentLifeTime = status.CurrentLifeTime + TUNING.SEASICK_EXTRA_DURATION
        status.RequestClientSync = true
        status.RequestClientSync2 = true
    end
end)
