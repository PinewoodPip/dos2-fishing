
---@diagnostic disable-next-line: unused-local
local Fishing = Epip.GetFeature("Features.Fishing")

---@class Features.Fishing.Skills
local Skills = Epip.GetFeature("Fishing", "Features.Fishing.Skills")

Skills.TURN_ON_THE_TIDES_TUNING = {
    BURST_PROJECTILE = "Projectile_PIP_Fishing_TurnOnTheTides_ScriptedDamage",
    IMPACT_FX = "PIP_FX_Skills_SeaWaveImpact",
    STATUS_ID = "PIP_Fishing_TurnOnTheTides",
}

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Turned On Tides status: character explodes a water projectile on themselves at turn start.
Osiris.RegisterSymbolListener("ObjectTurnStarted", 1, "after", function (objGUID)
    if Osi.ObjectIsCharacter(objGUID) == 0 then return end
    if Osi.HasActiveStatus(objGUID, Skills.TURN_ON_THE_TIDES_TUNING.STATUS_ID) == 1 then
        local char = Character.Get(objGUID)
        Skills.ExplodeProjectile(char, Skills.TURN_ON_THE_TIDES_TUNING.BURST_PROJECTILE, char)
        Osi.PlayEffectAtPosition(Skills.TURN_ON_THE_TIDES_TUNING.IMPACT_FX, table.unpack(char.WorldPos))
    end
end)
