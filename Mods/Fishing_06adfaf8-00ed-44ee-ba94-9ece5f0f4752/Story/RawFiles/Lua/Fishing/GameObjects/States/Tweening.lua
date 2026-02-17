
local Fishing = Epip.GetFeature("Features.Fishing")
local UI = Fishing.UI ---@class Features.Fishing.UI
local StateClass = Fishing:GetClass("Features.Fishing.GameObject.Fish.State")

---@class Features.Fishing.GameObject.Fish.States.Tweening : Features.Fishing.GameObject.Fish.State
---@field TargetPosition number Target position within minigame bounds.
---@field EasingFunction Features.Fishing.GameObject.Fish.States.Tweening.EasingFunction
---@field _StartPosition number
local _Tweening = {
    Type = "Tweening",
}
Fishing:RegisterClass("Features.Fishing.GameObject.Fish.States.Tweening", _Tweening, {"Features.Fishing.GameObject.Fish.State"})

---@alias Features.Fishing.GameObject.Fish.States.Tweening.EasingFunction "Quadratic"|"Quartic"

---@type table<Features.Fishing.GameObject.Fish.States.Tweening.EasingFunction, fun(t: number): number>
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

---@param easingFunction Features.Fishing.GameObject.Fish.States.Tweening.EasingFunction
---@param targetPosition number Position within minigame bounds.
---@param duration number Duration in seconds.
---@return Features.Fishing.GameObject.Fish.States.Tweening
function _Tweening:Create(easingFunction, targetPosition, duration)
    local state = StateClass.Create(self, {
        EasingFunction = easingFunction,
        TargetPosition = targetPosition,
        Duration = duration,
    }) ---@cast state Features.Fishing.GameObject.Fish.States.Tweening
    return state
end

function _Tweening:Update(dt)
    StateClass.Update(self, dt)

    local fishState = self.Fish.State

    -- Iniitialize starting position
    if not self._StartPosition then
        self._StartPosition = fishState.Position
    end

    -- Update position
    local t = math.clamp(self.TimeElapsed / self.Duration, 0, 1)
    local position = self.EASING_FUNCTIONS[self.EasingFunction](t)
    fishState.Position = self._StartPosition + (self.TargetPosition - self._StartPosition) * position
    fishState.Velocity = 0 -- TODO would anything need these?
    fishState.Acceleration = 0
end
