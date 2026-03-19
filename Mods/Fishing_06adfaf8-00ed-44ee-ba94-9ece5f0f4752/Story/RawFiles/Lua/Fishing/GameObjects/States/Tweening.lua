
local Fishing = GetFeature("Features.Fishing")
local UI = Fishing.UI ---@class Features.Fishing.UI
local StateClass = Fishing:GetClass("Features.Fishing.GameObject.MovementState")

---@class Features.Fishing.GameObject.MovementStates.Tweening : Features.Fishing.GameObject.MovementState
---@field TargetPosition number Target position within minigame bounds.
---@field EasingFunction Features.Fishing.GameObject.MovementStates.Tweening.EasingFunction
---@field _StartPosition number
local _Tweening = {
    Type = "Tweening",
}
Fishing:RegisterClass("Features.Fishing.GameObject.MovementStates.Tweening", _Tweening, {"Features.Fishing.GameObject.MovementState"})

---@alias Features.Fishing.GameObject.MovementStates.Tweening.EasingFunction "Quadratic"|"Quartic"

---@type table<Features.Fishing.GameObject.MovementStates.Tweening.EasingFunction, fun(t: number): number>
_Tweening.EASING_FUNCTIONS = {
    ["Quadratic"] = function (t)
        if t < 0.5 then
            return 2 * t * t
        end
        local f = -2 * t + 2
        return 1 - f * f / 2
    end,
    ["Quartic"] = function (t)
        if t < 0.5 then
            return 8 * t * t * t * t
        end
        local f = -2 * t + 2
        return 1 - f * f * f * f / 2
    end,
}

---------------------------------------------
-- METHODS
---------------------------------------------

---@param easingFunction Features.Fishing.GameObject.MovementStates.Tweening.EasingFunction
---@param targetPosition number Position within minigame bounds.
---@param duration number Duration in seconds.
---@return Features.Fishing.GameObject.MovementStates.Tweening
function _Tweening:Create(easingFunction, targetPosition, duration)
    local state = StateClass.Create(self, {
        EasingFunction = easingFunction,
        TargetPosition = targetPosition,
        Duration = duration,
    }) ---@cast state Features.Fishing.GameObject.MovementStates.Tweening
    return state
end

function _Tweening:Update(dt)
    StateClass.Update(self, dt)

    local physics = self.Owner.State

    -- Iniitialize starting position
    if not self._StartPosition then
        self._StartPosition = physics.Position
    end

    -- Update position
    local t = math.clamp(self.TimeElapsed / self.Duration, 0, 1)
    local position = self.EASING_FUNCTIONS[self.EasingFunction](t)
    physics.Position = self._StartPosition + (self.TargetPosition - self._StartPosition) * position
    physics.Velocity = 0 -- TODO would anything need these?
    physics.Acceleration = 0
end
