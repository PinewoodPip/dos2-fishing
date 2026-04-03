
local Fishing = GetFeature("Fishing")
local isEE = EpicEncounters.IsEnabled()

---@class Fishing.Skills
local Skills = GetFeature("Fishing.Skills")

Skills.REEL_IN_TUNING = {
    DAMAGE_ON_MOVE_STATUS = "PIP_Fishing_ReelIn_ScriptedForceMoveDamage",
    BASE_DAMAGE_DISTANCE_THRESHOLD = 5, -- Base travel distance interval for hits while reeling, in meters.
    DAMAGE_DISTANCE_REDUCTION_PER_FISHERMANCY = 0.2, -- Damage distance reduction per Fishermancy point, in meters.
    VALID_POSITION_RADIUS = 4, -- Radius around the caster within which the target can be reeled to.
    PULL_SPREAD_RADIUS = 1.5, -- Random offset radius to pull position, in meters.
    PULL_POSITION_ATTEMPTS = 4, -- Number of pull positions to try in a circle around the caster.
}
local TUNING = Skills.REEL_IN_TUNING

---------------------------------------------
-- METHODS
---------------------------------------------

---Applies the reel-in pull effect to target,
---pulling them to char.
---@param char EsvCharacter
---@param target EsvCharacter
function Skills.ReelIn(char, target)
    -- Find a random position around char to pull to,
    -- to avoid multiple simultaneous targets stacking on the same spot.
    local sourceX, sourceY, sourceZ = Osi.GetPosition(char.MyGuid)
    local posSearchAttempts = TUNING.PULL_POSITION_ATTEMPTS
    local spread = TUNING.PULL_SPREAD_RADIUS
    local startAngle = math.random() * 2 * math.pi
    local angleStep = 2 * math.pi / posSearchAttempts
    local x, y, z = nil, nil, nil
    for i=1,posSearchAttempts,1 do
        local angle = startAngle + i * angleStep
        local pullX = sourceX + math.cos(angle) * spread
        local pullZ = sourceZ + math.sin(angle) * spread
        x, y, z = Osi.FindValidPosition(pullX, sourceY, pullZ, TUNING.VALID_POSITION_RADIUS, target.MyGuid)
        if x then break end
    end
    if not x then return end -- Do nothing if target couldn't be moved to a valid AI grid pos.

    -- Pull target to caster
    Osi.NRD_CreateGameObjectMove(target.MyGuid, x, y, z, "", char.MyGuid)

    -- Apply damage to target while reeling in
    local sourceFishermancy = Fishing.GetAbilityScore(char)
    local damageDistanceThreshold = TUNING.BASE_DAMAGE_DISTANCE_THRESHOLD - sourceFishermancy * TUNING.DAMAGE_DISTANCE_REDUCTION_PER_FISHERMANCY

    -- Apply Source Infusion 2 damage distance reduction
    if isEE then
        damageDistanceThreshold = damageDistanceThreshold + Skills.GetExtendedStat(char, "PIP_ReelIn_DamageDistance")
    end

    Osi.NRD_ApplyDamageOnMove(target.MyGuid, TUNING.DAMAGE_ON_MOVE_STATUS, char.MyGuid, 18, damageDistanceThreshold)

    local targetGUID = target.MyGuid
    local timer = Timer.Start(0.5, function (ev)
        -- Remove status after the target lands.
        -- SHOCKWAVE status is applied by engine during force-move actions.
        target = Character.Get(targetGUID)
        if not target:GetStatus("SHOCKWAVE") then
            ev.Timer:Cancel()
            Osi.RemoveStatus(targetGUID, TUNING.DAMAGE_ON_MOVE_STATUS)
        end
    end)
    timer:SetRepeatCount(-1)
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Cast effect: pull targets towards the caster.
-- Target receives continous damage while travelling, scaling with Fishermancy.
Osiris.RegisterSymbolListener("CharacterStatusApplied", 3, "after", function (targetGUID, statusID, causeeGUID)
    if statusID ~= "PIP_FISHING_REEL_IN" then return end
    local source = Character.Get(causeeGUID)
    local target = Character.Get(targetGUID)
    Skills.ReelIn(source, target)
end)

-- Listen for requests to reel targets from Osiris (ex. Source Infusion effect)
Osiris.RegisterSymbolListener("PROC_PIP_Fishing_ReelIn", 2, "after", function (sourceGUID, targetGUID)
    local source = Character.Get(sourceGUID)
    local target = Character.Get(targetGUID)
    Skills.ReelIn(source, target)
end)
