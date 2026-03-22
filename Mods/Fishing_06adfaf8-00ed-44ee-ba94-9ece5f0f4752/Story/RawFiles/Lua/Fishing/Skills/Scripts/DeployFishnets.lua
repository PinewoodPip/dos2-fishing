
---@class Features.Fishing.Skills
local Skills = GetFeature("Features.Fishing.Skills")

Skills.DEPLOY_FISHNETS_TUNING = {
    PROJECTILE_ID = "Projectile_PIP_Fishing_FishNet",
}

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Throw hook for characters being hit by fishnets.
Ext.Events.StatusHitEnter:Subscribe(function (ev)
    local defenderHandle = ev.Context.Status.OwnerHandle
    if Ext.Utils.GetHandleType(defenderHandle) ~= "ServerCharacter" then return end
    if ev.Hit.SkillId == Skills.DEPLOY_FISHNETS_TUNING.PROJECTILE_ID then
        local defender = Character.Get(defenderHandle)
        Osi.PROC_PIP_DamagedByFishnets(defender.MyGuid)
    end
end)
