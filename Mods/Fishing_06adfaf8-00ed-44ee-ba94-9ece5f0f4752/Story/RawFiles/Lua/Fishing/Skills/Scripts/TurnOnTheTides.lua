
---@diagnostic disable-next-line: unused-local
local Fishing = GetFeature("Fishing")
local isEE = EpicEncounters.IsEnabled()

---@class Fishing.Skills
local Skills = GetFeature("Fishing.Skills")

Skills.TURN_ON_THE_TIDES_TUNING = {
    BURST_PROJECTILE = "Projectile_PIP_Fishing_TurnOnTheTides_ScriptedDamage",
    IMPACT_FX = "PIP_FX_Skills_SeaWaveImpact",
    STATUS_ID = "PIP_Fishing_TurnOnTheTides",
    HERO_STATUS_ID = "PIP_Fishing_TurnOnTheTides_Hero",

    EXTENDED_STATS = {
        PROJECTILE_REPLACEMENT = "PIP_TurnedOnTides_ProjectileReplacement",
        SPLASH_COUNT = "PIP_TurnedOnTides_SplashCount",
    }
}
local TUNING = Skills.TURN_ON_THE_TIDES_TUNING

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Turned On Tides status: character explodes a water projectile on themselves at turn start.
Osiris.RegisterSymbolListener("ObjectTurnStarted", 1, "after", function (objGUID)
    if Osi.ObjectIsCharacter(objGUID) == 0 then return end
    if Osi.HasActiveStatus(objGUID, TUNING.STATUS_ID) == 1 or Osi.HasActiveStatus(objGUID, TUNING.HERO_STATUS_ID) == 1 then
        local char = Character.Get(objGUID)
        local projectile = TUNING.BURST_PROJECTILE
        local splashCount = 1

        -- Add splashes from SI bonuses & projectile replacements.
        if isEE then
            splashCount = splashCount + Skills.GetExtendedStat(char, TUNING.EXTENDED_STATS.SPLASH_COUNT)
            local projectileReplacements = Skills.GetExtendedStats(char, TUNING.EXTENDED_STATS.PROJECTILE_REPLACEMENT)
            local currentProjectilePriority = 0
            for _,replacement in ipairs(projectileReplacements) do -- Use the override with the highest priority (param2 of the extended stat).
                local replacementPriority = tonumber(replacement[4]) or 0
                if replacementPriority > currentProjectilePriority then
                    projectile = replacement[3]
                    currentProjectilePriority = replacementPriority
                end
            end
        end

        for _=1,splashCount,1 do
            -- TODO stagger/delay extra splashes
            Skills.ExplodeProjectile(char, projectile, char)
            Osi.PlayEffectAtPosition(TUNING.IMPACT_FX, table.unpack(char.WorldPos))
        end
    end
end)
