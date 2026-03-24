
---@class Fishing.Skills
local Skills = GetFeature("Fishing.Skills")

Skills.SEABURN_TUNING = {
    PROJECTILE_SKILL = "Projectile_PIP_Fishing_Seaburn_ScriptedDamage",
}
local TUNING = Skills.SEABURN_TUNING

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Throw hook for Seaburn targets hit with water damage.
Ext.Events.StatusHitEnter:Subscribe(function (ev)
    local defenderHandle = ev.Context.Status.OwnerHandle
    local attackerHandle = ev.Context.Status.StatusSourceHandle
    if Ext.Utils.GetHandleType(defenderHandle) ~= "ServerCharacter" or Ext.Utils.GetHandleType(attackerHandle) ~= "ServerCharacter" then return end
    local defender = Character.Get(defenderHandle)
    local attacker = Character.Get(attackerHandle)
    local seaburnStatus = defender:GetStatus("PIP_FISHING_SEABURN")
    if not seaburnStatus then return end
    if defender and ev.Hit.Hit.Hit then -- Love it when this naming shenanigan happens. Peak OOP moment
        local hasWaterDamage = ev.Hit.Hit.DamageList:GetByType("Water") > 0
        if hasWaterDamage then
            -- Throw hooks and deal scripted damage.
            local statusSource = Character.Get(seaburnStatus.OwnerHandle)
            Skills.ExplodeProjectile(attacker, TUNING.PROJECTILE_SKILL, defender)
            Osi.PROC_PIP_Seaburn_Detonate(defender.MyGuid, statusSource.MyGuid, attacker.MyGuid)
            if ev.Hit.Hit.CriticalHit then
                Osi.PROC_PIP_Seaburn_Detonate_FromCrit(defender.MyGuid, statusSource.MyGuid, attacker.MyGuid)
            end

            -- Reduce status duration.
            -- Needs a delay so that it's performed after attempting to refresh the status,
            -- if this hit were to reapply it.
            Ext.OnNextTick(function ()
                defender = Character.Get(defenderHandle)
                if not defender then return end
                seaburnStatus = defender:GetStatus("PIP_FISHING_SEABURN")
                if not seaburnStatus then return end
                seaburnStatus.CurrentLifeTime = math.max(0, seaburnStatus.CurrentLifeTime - 6.0)
                seaburnStatus.RequestClientSync = true
                seaburnStatus.RequestClientSync2 = true
                if seaburnStatus.CurrentLifeTime <= 0 then
                    Osi.RemoveStatus(defender.MyGuid, "PIP_FISHING_SEABURN")
                end
            end)
        end
    end
end)

-- Prevent refreshing the duration of Seaburn.
Ext.Events.BeforeStatusApply:Subscribe(function (ev)
    local owner = ev.Owner ---@cast owner EsvCharacter|EsvItem
    if ev.Status.StatusId == "PIP_FISHING_SEABURN" and Entity.IsCharacter(owner) and owner:GetStatus("PIP_FISHING_SEABURN") then
        ev.PreventStatusApply = true
    end
end)
