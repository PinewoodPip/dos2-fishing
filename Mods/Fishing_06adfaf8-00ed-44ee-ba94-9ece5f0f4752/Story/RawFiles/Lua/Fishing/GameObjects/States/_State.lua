
local Fishing = GetFeature("Fishing")

---@class Fishing.GameObject.MovementState : Class
---@field Owner Fishing.Minigame.GameObjects.Autonomous
---@field Duration number Total duration in seconds.
---@field TimeElapsed number Elapsed time in seconds.
local State = {}
Fishing:RegisterClass("Fishing.GameObject.MovementState", State)

---@alias Fishing.GameObject.MovementState.ClassName "Fishing.GameObject.MovementState"|"Fishing.GameObject.MovementStates.Floating"|"Fishing.GameObject.MovementStates.Sinking"|"Fishing.GameObject.MovementStates.Tweening"|"Fishing.GameObject.MovementStates.Shaking"

---------------------------------------------
-- METHODS
---------------------------------------------

---Base constructor.
---@param state table|Fishing.GameObject.MovementState State data.
---@return Fishing.GameObject.MovementState
function State:Create(state)
    state = self:__Create(state) ---@cast state Fishing.GameObject.MovementState
    state.TimeElapsed = 0
    return state
end

---@param owner Fishing.Minigame.GameObjects.Autonomous
function State:SetOwner(owner)
    self.Owner = owner
end

---@virtual
---@param dt number In seconds.
function State:Update(dt)
    self.TimeElapsed = self.TimeElapsed + dt
end

---Returns whether the fish is moving upward.
---@return boolean
function State:IsFloating()
    return false
end

---Returns whether the fish is moving downward.
---@return boolean
function State:IsSinking()
    return false
end

---Returns whether this state has ended and the state machine should transition to a new one.
---@return boolean
function State:IsFinished()
    return self.TimeElapsed >= self.Duration
end
