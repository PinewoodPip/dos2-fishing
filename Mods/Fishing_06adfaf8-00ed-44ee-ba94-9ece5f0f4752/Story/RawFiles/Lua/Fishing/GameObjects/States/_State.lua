
local Fishing = GetFeature("Features.Fishing")

---@class Features.Fishing.GameObject.MovementState : Class
---@field Owner Features.Fishing.Minigame.GameObjects.Autonomous
---@field Duration number Total duration in seconds.
---@field TimeElapsed number Elapsed time in seconds.
local State = {}
Fishing:RegisterClass("Features.Fishing.GameObject.MovementState", State)

---@alias Features.Fishing.GameObject.MovementState.ClassName "Features.Fishing.GameObject.MovementState"|"Features.Fishing.GameObject.MovementStates.Floating"|"Features.Fishing.GameObject.MovementStates.Sinking"|"Features.Fishing.GameObject.MovementStates.Tweening"

---------------------------------------------
-- METHODS
---------------------------------------------

---Base constructor.
---@param state table|Features.Fishing.GameObject.MovementState State data.
---@return Features.Fishing.GameObject.MovementState
function State:Create(state)
    state = self:__Create(state) ---@cast state Features.Fishing.GameObject.MovementState
    state.TimeElapsed = 0
    return state
end

---@param owner Features.Fishing.Minigame.GameObjects.Autonomous
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
