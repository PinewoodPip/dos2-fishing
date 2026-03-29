
local Fishing = GetFeature("Fishing")
local UI = Fishing.UI ---@class Fishing.UI
local StateClass = Fishing:GetClass("Fishing.GameObject.MovementState")

---@class Fishing.GameObject.MovementStates.Shaking : Fishing.GameObject.MovementState
---@field _LastJitterTime integer Monotonic timestamp (ms) of the last jitter application.
local _Shaking = {
    Type = "Shaking",
    DRIFT_AMPLITUDE = 80, -- Max sinusoidal drift per second.
    DRIFT_FREQUENCY = 0.5, -- Oscillations per second.
    SHAKE_AMPLITUDE = 40, -- Max position change per jitter tick.
    JITTER_INTERVAL = 0.25, -- Duration between jitter ticks, in seconds.
}
Fishing:RegisterClass("Fishing.GameObject.MovementStates.Shaking", _Shaking, {"Fishing.GameObject.MovementState"})

---------------------------------------------
-- METHODS
---------------------------------------------

---@param duration number Duration in seconds.
---@return Fishing.GameObject.MovementStates.Shaking
function _Shaking:Create(duration)
    local state = StateClass.Create(self, {
        Duration = duration,
        _LastJitterTime = 0,
    }) ---@cast state Fishing.GameObject.MovementStates.Shaking
    return state
end

---@param dt number In seconds.
function _Shaking:Update(dt)
    StateClass.Update(self, dt)

    local physics = self.Owner.State
    local difficulty = self.Owner:GetDifficulty()

    -- Apply a random jitter; interval shrinks with difficulty
    local now = Ext.Utils.MonotonicTime()
    local offset = 0
    if now - self._LastJitterTime >= self.JITTER_INTERVAL / difficulty * 1000 then
        offset = (math.random() * 2 - 1) * self.SHAKE_AMPLITUDE * dt
        self._LastJitterTime = now
    end

    -- Add a sinusoidal drift; frequency scales with difficulty
    local drift = math.sin(self.TimeElapsed * self.DRIFT_FREQUENCY * difficulty * 2 * math.pi) * self.DRIFT_AMPLITUDE * dt

    physics.Position = math.clamp(physics.Position + offset + drift, 0, UI.GetBobberUpperBound())
    physics.Velocity = 0
    physics.Acceleration = 0
end
