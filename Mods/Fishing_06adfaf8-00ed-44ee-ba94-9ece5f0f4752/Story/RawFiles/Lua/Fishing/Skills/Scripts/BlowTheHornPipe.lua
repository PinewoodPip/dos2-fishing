
---@class Fishing.Skills
local Skills = GetFeature("Fishing.Skills")

Skills.HORNPIPE_TUNING = {
    HORNPIPE_STATUS_ID = "PIP_Fishing_Hornpipe",
    SEASICK_EXTRA_DURATION = 6.0, -- In seconds.
    HYDROSOPHIST_SEASICK_DURATION = 12.0, -- In seconds.
}
local TUNING = Skills.HORNPIPE_TUNING

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Hornpipe status: Hydrosophist skill hits apply Seasick.
Ext.Events.StatusHitEnter:Subscribe(function (ev)
    local context = ev.Context
    local attackerHandle = context.Status.HitByHandle
    local defenderHandle = context.Status.OwnerHandle
    if Ext.Utils.GetHandleType(attackerHandle) ~= "ServerCharacter" or Ext.Utils.GetHandleType(defenderHandle) ~= "ServerCharacter" then return end
    local attacker = Character.Get(attackerHandle)
    local defender = Character.Get(defenderHandle)
    local skill = ev.Hit.SkillId
    if skill == "" then return end
    skill = skill:gsub("_%-1$", "") -- Remove level suffix.
    local skillStat = Stats.Get("StatsLib_StatsEntry_SkillData", skill)
    if skillStat.Ability == "Water" then
        Osi.ApplyStatus(defender.MyGuid, Skills.SEASICK_ID, TUNING.HYDROSOPHIST_SEASICK_DURATION, 0, attacker.MyGuid)
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
    if status.StatusId == Skills.SEASICK_ID then
        local sourceHandle = status.StatusSourceHandle
        if Ext.Utils.GetHandleType(sourceHandle) ~= "ServerCharacter" then return end
        local source = Character.Get(sourceHandle)
        if not source:GetStatus(TUNING.HORNPIPE_STATUS_ID) then return end
        status.LifeTime = status.LifeTime + TUNING.SEASICK_EXTRA_DURATION
        status.CurrentLifeTime = status.CurrentLifeTime + TUNING.SEASICK_EXTRA_DURATION
        status.RequestClientSync = true
        status.RequestClientSync2 = true
    end
end)
