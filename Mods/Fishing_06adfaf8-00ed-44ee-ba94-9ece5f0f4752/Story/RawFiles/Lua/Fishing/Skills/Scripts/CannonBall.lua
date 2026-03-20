
local Fishing = GetFeature("Features.Fishing")
local V = Vector.Create

---@class Features.Fishing.Skills
local Skills = GetFeature("Features.Fishing.Skills")

Skills.CANNON_BALL_TUNING = {
    IMPACT_SKILL = "Projectile_PIP_Fishing_CannonBall_ScriptedDamage",
    BASE_KNOCKBACK_DISTANCE = 4, -- In meters.
    KNOCKBACK_DISTANCE_PER_FISHERMANCY = 1, -- In meters.
    VALID_POSITION_RADIUS = 4, -- Radius around the caster within which the target can be reeled to.
    POSITION_SEARCH_ATTEMPTS = 250, -- Number of times to search for a valid position to pull the target to.
    POSITION_SEARCH_STEP = 0.25, -- Distance to step in the direction of the projectile when searching for a valid position, in meters.
}

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Cast effect: push targets in direction of the projectile.
-- Distance scales with Fishermancy and extra physical damage is dealt
-- when pushing targets into a wall/obstacle.
Osiris.RegisterSymbolListener("CharacterStatusApplied", 3, "after", function (targetGUID, statusID, causeeGUID)
    if statusID ~= "PIP_FISHING_CANNON_BALL_KNOCKBACK" then return end
    local source = Character.Get(causeeGUID)
    local target = Character.Get(targetGUID)
    local sourcePos = V(source.WorldPos)
    local targetPos = V(target.WorldPos)
    local sourceFishermancy = Fishing.GetAbilityScore(source)
    local maxKnockbackDistance = Skills.CANNON_BALL_TUNING.BASE_KNOCKBACK_DISTANCE + sourceFishermancy * Skills.CANNON_BALL_TUNING.KNOCKBACK_DISTANCE_PER_FISHERMANCY

    -- Add SI2+ bonus knockback
    if EpicEncounters.IsEnabled() then
        maxKnockbackDistance = maxKnockbackDistance + Skills.GetExtendedStat(source, "PIP_CannonBall_PushDistance")
    end

    -- Push target as far as possible in the direction of the projectile
    local dir = Vector.GetNormalized(targetPos - sourcePos)
    local posStep = dir * Skills.CANNON_BALL_TUNING.POSITION_SEARCH_STEP
    local pushPos = targetPos + posStep
    local distanceTravelled = Skills.CANNON_BALL_TUNING.POSITION_SEARCH_STEP
    local x, y, z = Osi.FindValidPosition(pushPos[1], pushPos[2], pushPos[3], Skills.CANNON_BALL_TUNING.VALID_POSITION_RADIUS, target.MyGuid)
    local searchAttempts = Skills.CANNON_BALL_TUNING.POSITION_SEARCH_ATTEMPTS
    local collided = false
    while x and not collided and searchAttempts > 0 and distanceTravelled < maxKnockbackDistance do
        local newPushPos = V(x, y, z) + posStep
        local newX, newY, newZ = Osi.FindValidPosition(newPushPos[1], newPushPos[2], newPushPos[3], Skills.CANNON_BALL_TUNING.VALID_POSITION_RADIUS, target.MyGuid)
        if newX then
            x, y, z = newX, newY, newZ
        else
            collided = true
        end
        distanceTravelled = distanceTravelled + Skills.CANNON_BALL_TUNING.POSITION_SEARCH_STEP
        searchAttempts = searchAttempts - 1
    end
    if not x then return end -- Do nothing if target couldn't be moved to a valid AI grid pos.

    -- Push the target
    Osi.NRD_CreateGameObjectMove(target.MyGuid, x, y, z, "", source.MyGuid)

    -- Deal damage upon impact if the target was pushed into a wall.
    if collided then
        local timer = Timer.Start(0.5, function (ev)
            target = Character.Get(targetGUID)
            if not target:GetStatus("SHOCKWAVE") then
                source = Character.Get(causeeGUID)
                Skills.ExplodeProjectile(source, Skills.CANNON_BALL_TUNING.IMPACT_SKILL, target)
                ev.Timer:Cancel()
            end
        end)
        timer:SetRepeatCount(-1)
    end
end)
