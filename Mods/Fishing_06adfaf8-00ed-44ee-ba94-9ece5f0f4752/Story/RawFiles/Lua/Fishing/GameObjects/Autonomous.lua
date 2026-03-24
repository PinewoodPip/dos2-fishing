
---------------------------------------------
-- Base class for a game object that uses a state machine for its movement.
---------------------------------------------

local Fishing = GetFeature("Fishing")
local _Capturable = Fishing:GetClass("Fishing.Minigame.GameObjects.Capturable")
local UI = Fishing.UI ---@class Fishing.UI

---@class Fishing.Minigame.GameObjects.Autonomous : Fishing.Minigame.GameObjects.Capturable
---@field MovementState Fishing.GameObject.MovementState
local _Autonomous = {
    BASE_CYCLE_TIME = 2,
    ACCELERATION = 40,
    MAX_ACCELERATION = 30,
    MAX_VELOCITY = 70,
    STATE_CHANGE_COOLDOWN_RANDOM_FACTOR = 0.4, -- Random deviation for state duration, as a fraction of `BASE_CYCLE_TIME`.
}
Fishing:RegisterClass("Fishing.Minigame.GameObjects.Autonomous", _Autonomous, {"Fishing.Minigame.GameObjects.Capturable"})

---------------------------------------------
-- METHODS
---------------------------------------------

---Base constructor.
---@param elementID string
---@param size Vector2
---@param state Fishing.GameObject.State
---@return Fishing.Minigame.GameObjects.Autonomous
function _Autonomous:Create(elementID, size, state)
    local instance = _Capturable.Create(self, elementID, size, state) ---@cast instance Fishing.Minigame.GameObjects.Autonomous
    return instance
end

---Transitions to the next movement state.
---@abstract
function _Autonomous:TransitionState() error("Not implemented") end

---Returns the value used for movement difficulty scaling.
---@abstract
---@return number
function _Autonomous:GetDifficulty() error("Not implemented") end

---Returns a randomized state duration in seconds, scaled by difficulty.
---@return number
function _Autonomous:__RandomStateDuration()
    local cycleTime = self.BASE_CYCLE_TIME / self:GetDifficulty()
    return cycleTime * (math.random() * self.STATE_CHANGE_COOLDOWN_RANDOM_FACTOR * 2 + (1 - self.STATE_CHANGE_COOLDOWN_RANDOM_FACTOR))
end

---Sets the movement state.
---@param state Fishing.GameObject.MovementState
function _Autonomous:SetState(state)
    self.MovementState = state
    self.MovementState:SetOwner(self)
end

---@override
---@param deltaTime number In milliseconds.
function _Autonomous:Update(deltaTime)
    local seconds = deltaTime / 1000
    self.MovementState:Update(seconds)
    self:TransitionState()
    self._IsCollidingWithBobber = false
end

---@override
---@param deltaTime number In milliseconds.
function _Autonomous:LateUpdate(deltaTime)
    _Capturable.LateUpdate(self, deltaTime)
end

---------------------------------------------
-- SETUP
---------------------------------------------

UI._AutonomousGameObjectClass = _Autonomous
