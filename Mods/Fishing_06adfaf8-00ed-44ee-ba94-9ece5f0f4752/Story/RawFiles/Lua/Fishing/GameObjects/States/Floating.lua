
local Fishing = GetFeature("Features.Fishing")
local UI = Fishing.UI ---@class Features.Fishing.UI
local StateClass = Fishing:GetClass("Features.Fishing.GameObject.Fish.State")

---@class Features.Fishing.GameObject.Fish.States.Floating : Features.Fishing.GameObject.Fish.State
local _Floating = {
    Type = "Floating",
}
Fishing:RegisterClass("Features.Fishing.GameObject.Fish.States.Floating", _Floating, {"Features.Fishing.GameObject.Fish.State"})

---------------------------------------------
-- METHODS
---------------------------------------------

---@param duration number Duration in seconds.
---@return Features.Fishing.GameObject.Fish.States.Floating
function _Floating:Create(duration)
    local state = StateClass.Create(self, {
        Duration = duration,
    }) ---@cast state Features.Fishing.GameObject.Fish.States.Floating
    return state
end

---@param dt number In seconds.
function _Floating:Update(dt)
    StateClass.Update(self, dt)

    local state = self.Fish.State
    local acceleration = state.Acceleration
    local difficulty = self.Fish.Descriptor.Difficulty

    -- Apply upward acceleration
    acceleration = acceleration - self.Fish.ACCELERATION * difficulty * dt

    state.Acceleration = math.clamp(acceleration, -self.Fish.MAX_ACCELERATION, self.Fish.MAX_ACCELERATION)
    state.Velocity = state.Velocity + acceleration * dt
    state.Velocity = math.clamp(state.Velocity, -self.Fish.MAX_VELOCITY, self.Fish.MAX_VELOCITY)

    state.Position = math.clamp(state.Position + state.Velocity * dt, 0, UI.GetBobberUpperBound())

    if state.Position <= 0 or state.Position >= UI.GetBobberUpperBound() then
        state.Velocity = 0
        state.Acceleration = 0
    end
end

---@return boolean
function _Floating:IsFloating()
    return true
end
