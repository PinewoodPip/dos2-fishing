
local Fishing = GetFeature("Fishing")
local UI = Fishing.UI ---@class Fishing.UI
local StateClass = Fishing:GetClass("Fishing.GameObject.MovementState")

---@class Fishing.GameObject.MovementStates.Floating : Fishing.GameObject.MovementState
local _Floating = {
    Type = "Floating",
}
Fishing:RegisterClass("Fishing.GameObject.MovementStates.Floating", _Floating, {"Fishing.GameObject.MovementState"})

---------------------------------------------
-- METHODS
---------------------------------------------

---@param duration number Duration in seconds.
---@return Fishing.GameObject.MovementStates.Floating
function _Floating:Create(duration)
    local state = StateClass.Create(self, {
        Duration = duration,
    }) ---@cast state Fishing.GameObject.MovementStates.Floating
    return state
end

---@param dt number In seconds.
function _Floating:Update(dt)
    StateClass.Update(self, dt)

    local physics = self.Owner.State
    local acceleration = physics.Acceleration
    local difficulty = self.Owner:GetDifficulty()

    -- Apply upward acceleration
    acceleration = acceleration - self.Owner.ACCELERATION * difficulty * dt

    physics.Acceleration = math.clamp(acceleration, -self.Owner.MAX_ACCELERATION, self.Owner.MAX_ACCELERATION)
    physics.Velocity = physics.Velocity + acceleration * dt
    physics.Velocity = math.clamp(physics.Velocity, -self.Owner.MAX_VELOCITY, self.Owner.MAX_VELOCITY)

    physics.Position = math.clamp(physics.Position + physics.Velocity * dt, 0, UI.GetBobberUpperBound())

    if physics.Position <= 0 or physics.Position >= UI.GetBobberUpperBound() then
        physics.Velocity = 0
        physics.Acceleration = 0
    end
end

---@return boolean
function _Floating:IsFloating()
    return true
end
