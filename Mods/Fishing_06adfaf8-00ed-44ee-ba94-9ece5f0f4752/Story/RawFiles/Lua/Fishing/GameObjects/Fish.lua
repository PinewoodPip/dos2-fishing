
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
    STATE_CHANGE_COOLDOWN_RANDOM_FACTOR = 0.4, -- Random deviation for state duration, as a fraction of `BASE_CYCLE_TIME`.
    TWEEN_CHANCE = 0.3, -- Chance to entering the Tweening state on each state transition.
    BASE_TWEEN_DURATION = 1.5, -- Base tween duration in seconds, scaled down by fish Difficulty; higher Difficulty results in shorter tween states.
}
Inherit(_Fish, UI._GameObjectClass)
UI.RegisterGameObject("Features.Fishing.GameObject.Fish", _Fish)

local MovementStates = {
    Sinking = Fishing:GetClass("Features.Fishing.GameObject.Fish.States.Sinking"),
    Floating = Fishing:GetClass("Features.Fishing.GameObject.Fish.States.Floating"),
    Tweening = Fishing:GetClass("Features.Fishing.GameObject.Fish.States.Tweening")
}

---------------------------------------------
-- METHODS
---------------------------------------------

function _Fish:Update(deltaTime)
    local seconds = deltaTime / 1000
    self.MovementState:Update(seconds)
    self:TransitionState()
end

---Returns a randomized state duration in seconds, scaled by fish Difficulty.
---@return number
function _Fish:_RandomStateDuration()
    local cycleTime = self.BASE_CYCLE_TIME / self.Descriptor.Difficulty
    return cycleTime * (math.random() * self.STATE_CHANGE_COOLDOWN_RANDOM_FACTOR * 2 + (1 - self.STATE_CHANGE_COOLDOWN_RANDOM_FACTOR))
end

---Transition to the next movement state. TODO it should be the states that do this
function _Fish:TransitionState()
    if not self.MovementState:IsFinished() then return end

    if math.random() < self.TWEEN_CHANCE then
        local TweenState = MovementStates.Tweening
        local easingFunc = self:_GetRandomTweenFunction()
        local targetPosition = math.random() * UI.GetBobberUpperBound() -- TODO avoid tweening to a position too close to current one
        local duration = self.BASE_TWEEN_DURATION / self.Descriptor.Difficulty
        self:SetState(TweenState:Create(easingFunc, targetPosition, duration))
    elseif self.MovementState:IsFloating() then
        self:SetState(MovementStates.Sinking:Create(self:_RandomStateDuration()))
    else
        self:SetState(MovementStates.Floating:Create(self:_RandomStateDuration()))
    end

    -- Reset velocity and acceleration
    local state = self.State
    state.Velocity = 0
    state.Acceleration = 0
end

---Sets the movement state.
---@param state Features.Fishing.GameObject.Fish.State
function _Fish:SetState(state)
    self.MovementState = state
    self.MovementState:SetFish(self)
    UI:DebugLog("Fish changed state to", state:GetClassName())
end

---Returns a random tweening function for the Tweening state.
---@return Features.Fishing.GameObject.Fish.States.Tweening.EasingFunction
function _Fish:_GetRandomTweenFunction()
    local TweenState = MovementStates.Tweening
    local tweenTypes = {}
    for tweenType,_ in pairs(TweenState.EASING_FUNCTIONS) do
        table.insert(tweenTypes, tweenType)
    end
    return tweenTypes[math.random(1, #tweenTypes)]
end
