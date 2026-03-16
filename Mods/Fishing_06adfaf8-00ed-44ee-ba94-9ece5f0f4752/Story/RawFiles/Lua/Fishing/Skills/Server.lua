
---@class Features.Fishing.Skills
local Skills = GetFeature("Features.Fishing.Skills")

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns the enemies of char within a radius of them.
---@param char EsvCharacter
---@param radius number
---@return EsvCharacter[]
function Skills.GetNearbyEnemies(char, radius)
    local charGUID = char.MyGuid
    local allyX, allyY, allyZ = Osi.GetPosition(charGUID)
    local nearbyChars = Ext.Entity.GetCharacterGuidsAroundPosition(allyX, allyY, allyZ, radius)
    local nearbyEnemies = {}
    for _,nearbyGUID in ipairs(nearbyChars) do
        if nearbyGUID ~= charGUID and Osi.CharacterCanSee(charGUID, nearbyGUID) == 1 and Osi.CharacterIsEnemy(charGUID, nearbyGUID) == 1 and Osi.CharacterIsInPartyWith(charGUID, nearbyGUID) == 0 then
            table.insert(nearbyEnemies, Character.Get(nearbyGUID))
        end
    end
    return nearbyEnemies
end

---Makes char cast a skill at target.
---@param char EsvCharacter
---@param skillID skill
---@param target EsvCharacter
function Skills.CastProjectileAt(char, skillID, target)
    local targetX, targetY, targetZ = Osi.GetPosition(target.MyGuid)
    Osi.CharacterUseSkillAtPosition(char.MyGuid, skillID, targetX, targetY, targetZ, 1, 1)
end

---Returns the allies of char that are in combat.
---@param char EsvCharacter
---@return EsvCharacter[]
function Skills.GetCombatAllies(char)
    local allies = Osi.DB_IsPlayer:Get(nil)
    local combatAllies = {}
    for _,tupl in ipairs(allies) do
        local allyGUID = tupl[1]
        if Text.RemoveGUIDPrefix(allyGUID) ~= char.MyGuid and Osi.CharacterIsInPartyWith(allyGUID, char.MyGuid) == 1 and Osi.CharacterIsInCombat(allyGUID) == 1 then -- TODO check same combat instance?
            table.insert(combatAllies, Character.Get(allyGUID))
        end
    end
    return combatAllies
end

---Explodes a projectile at the target's position.
---@param caster EsvCharacter
---@param skillID skill
---@param target EsvCharacter|vec3
function Skills.ExplodeProjectile(caster, skillID, target)
    local casterLevel = caster.Stats.Level
    local targetPos = type(target) == "table" and target or target.WorldPos
    Osi.NRD_ProjectilePrepareLaunch()
    Osi.NRD_ProjectileSetString("SkillId", skillID)
    Osi.NRD_ProjectileSetInt("CasterLevel", casterLevel)
    Osi.NRD_ProjectileSetGuidString("Caster", caster.MyGuid)
    Osi.NRD_ProjectileSetInt("CanDeflect", 0)
    Osi.NRD_ProjectileSetVector3("SourcePosition", table.unpack(targetPos))
    Osi.NRD_ProjectileSetVector3("TargetPosition", table.unpack(targetPos))
    Osi.NRD_ProjectileSetGuidString("Source", caster.MyGuid)
    if target then
        Osi.NRD_ProjectileSetGuidString("Target", target.MyGuid)
        Osi.NRD_ProjectileSetGuidString("HitObject", target.MyGuid)
        Osi.NRD_ProjectileSetGuidString("HitObjectPosition", target.MyGuid)
    end
    Osi.NRD_ProjectileLaunch()
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Cheat to grant all Fishermancy skills.
Ext.RegisterConsoleCommand("fishaddskills", function (_)
    local charGUID = Osi.CharacterGetHostCharacter()
    for skillID,_ in pairs(Skills.FISHERMANCY_SKILLS) do
        Osi.CharacterAddSkill(charGUID, skillID, 0)
    end
end)
