
---@class Features.Fishing.Skills
local Skills = GetFeature("Features.Fishing.Skills")

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
            local statusSource = Character.Get(seaburnStatus.OwnerHandle)
            Osi.PROC_PIP_Seaburn_Detonate(defender.MyGuid, statusSource.MyGuid, attacker.MyGuid)
            if ev.Hit.Hit.CriticalHit then
                Osi.PROC_PIP_Seaburn_Detonate_FromCrit(defender.MyGuid, statusSource.MyGuid, attacker.MyGuid)
            end
        end
    end
end)
