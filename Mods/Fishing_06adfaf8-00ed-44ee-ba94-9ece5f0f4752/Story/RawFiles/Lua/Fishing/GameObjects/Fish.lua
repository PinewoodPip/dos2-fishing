
local Fishing = Epip.GetFeature("Features.Fishing")
local UI = Fishing.UI ---@class Features.Fishing.UI

---@class Features.Fishing.GameObject.Fish : Features.Fishing.GameObject
---@field Descriptor Features.Fishing.Fish
local _Fish = {
    Type = "Fish",
    MovementState = nil, ---@type Features.Fishing.GameObject.Fish.State

    BASE_CYCLE_TIME = 2,
    ACCELERATION = 40,
    MAX_ACCELERATION = 30,
    MAX_VELOCITY = 70,
    STATE_CHANGE_COOLDOWN_RANDOM_FACTOR = 0.4, -- Random deviation for time between movement state changes, as fraction of `CYCLE_TIME`.

    _StateChangeCooldown = 0,
}
Inherit(_Fish, UI._GameObjectClass)
UI.RegisterGameObject("Features.Fishing.GameObject.Fish", _Fish)

---------------------------------------------
-- METHODS
---------------------------------------------

function _Fish:Update(deltaTime)
    local seconds = deltaTime / 1000

    -- Update current state
    self.MovementState:Update(seconds)

    -- Switch states based on timer
    -- Higher difficulty reduces time between changing movement patterns.
    self._StateChangeCooldown = self._StateChangeCooldown - seconds
    if self._StateChangeCooldown < 0 then
        self:TransitionState()

        -- Randomize time until next state
        local cycleTime = self.BASE_CYCLE_TIME / self.Descriptor.Difficulty
        self._StateChangeCooldown = cycleTime * (math.random() * self.STATE_CHANGE_COOLDOWN_RANDOM_FACTOR * 2 + (1 - self.STATE_CHANGE_COOLDOWN_RANDOM_FACTOR))
    end
end

---Transition to the next movement state. TODO it should be the states that do this
function _Fish:TransitionState()
    if self.MovementState:IsFloating() then
        self:SetState("Features.Fishing.GameObject.Fish.States.Sinking")
    else
        self:SetState("Features.Fishing.GameObject.Fish.States.Floating")
    end

    -- Reset velocity and acceleration
    local state = self.State
    state.Velocity = 0
    state.Acceleration = 0
end

---@param stateClassName Features.Fishing.GameObject.Fish.StateClassName
function _Fish:SetState(stateClassName)
    local StateClass = Fishing:GetClass(stateClassName)
    if not StateClass then
        UI:__Error("Fish", "Unknown state: " .. stateClassName)
        return
    end

    self.MovementState = StateClass:Create()
    self.MovementState:SetFish(self)
end
