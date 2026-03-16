
local Fishing = GetFeature("Features.Fishing")

---@class Features.Fishing.Skills
local Skills = GetFeature("Features.Fishing.Skills")

Skills.REEL_IN_TUNING = {
    DAMAGE_ON_MOVE_STATUS = "PIP_Fishing_ReelIn_ScriptedForceMoveDamage",
    BASE_DAMAGE_DISTANCE_THRESHOLD = 4, -- Base travel distance interval for hits while reeling, in meters.
    DAMAGE_DISTANCE_REDUCTION_PER_FISHERMANCY = 0.2, -- Damage distance reduction per Fishermancy point, in meters.
    VALID_POSITION_RADIUS = 4, -- Radius around the caster within which the target can be reeled to.
}

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Cast effect: pull targets towards the caster.
-- Target receives continous damage while travelling, scaling with Fishermancy.
Osiris.RegisterSymbolListener("CharacterStatusApplied", 3, "after", function (targetGUID, statusID, causeeGUID)
    if statusID ~= "PIP_FISHING_REEL_IN" then return end

    -- Find position to pull to
    local source = Character.Get(causeeGUID)
    local target = Character.Get(targetGUID)
    local sourceX, sourceY, sourceZ = Osi.GetPosition(causeeGUID)
    local x, y, z = Osi.FindValidPosition(sourceX, sourceY, sourceZ, Skills.REEL_IN_TUNING.VALID_POSITION_RADIUS, target.MyGuid)
    if not x then return end -- Do nothing if target couldn't be moved to a valid AI grid pos.

    -- Pull target to caster
    Osi.NRD_CreateGameObjectMove(target.MyGuid, x, y, z, "", source.MyGuid)

    -- Apply damage to target while reeling in
    local sourceFishermancy = Fishing.GetAbilityScore(source)
    local damageDistanceThreshold = Skills.REEL_IN_TUNING.BASE_DAMAGE_DISTANCE_THRESHOLD - sourceFishermancy * Skills.REEL_IN_TUNING.DAMAGE_DISTANCE_REDUCTION_PER_FISHERMANCY
    Osi.NRD_ApplyDamageOnMove(targetGUID, Skills.REEL_IN_TUNING.DAMAGE_ON_MOVE_STATUS, causeeGUID, 18, damageDistanceThreshold)
    local timer = Timer.Start(0.5, function (ev)
        -- Remove status after the target lands.
        -- SHOCKWAVE status is applied by engine during force-move actions.
        target = Character.Get(targetGUID)
        if not target:GetStatus("SHOCKWAVE") then
            ev.Timer:Cancel()
            Osi.RemoveStatus(targetGUID, Skills.REEL_IN_TUNING.DAMAGE_ON_MOVE_STATUS)
        end
    end)
    timer:SetRepeatCount(-1)
end)
