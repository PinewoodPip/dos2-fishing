
local Fishing = GetFeature("Features.Fishing")
local UI = Fishing.UI ---@class Features.Fishing.UI

---@class Features.Fishing.GameObject.Fish : Features.Fishing.Minigame.GameObjects.Capturable
---@field GetElement fun(self):GenericUI_Element_IggyIcon
---@field Descriptor Features.Fishing.Fish
---@field _IsCollidingWithBobber boolean
local _Fish = {
    Type = "Fish",
    MovementState = nil, ---@type Features.Fishing.GameObject.Fish.State

    BASE_CYCLE_TIME = 2,
    ACCELERATION = 40,
    MAX_ACCELERATION = 30,
    MAX_VELOCITY = 70,
    STATE_CHANGE_COOLDOWN_RANDOM_FACTOR = 0.4, -- Random deviation for state duration, as a fraction of `BASE_CYCLE_TIME`.
    BASE_TWEEN_DURATION = 1.5, -- Base tween duration in seconds, scaled down by fish Difficulty; higher Difficulty results in shorter tween states.
}
Inherit(_Fish, UI._CapturableGameObjectClass)
UI.RegisterGameObject("Features.Fishing.GameObject.Fish", _Fish)

local MovementStates = {
    Sinking = Fishing:GetClass("Features.Fishing.GameObject.Fish.States.Sinking"),
    Floating = Fishing:GetClass("Features.Fishing.GameObject.Fish.States.Floating"),
    Tweening = Fishing:GetClass("Features.Fishing.GameObject.Fish.States.Tweening")
}

---------------------------------------------
-- METHODS
---------------------------------------------

---@override
function _Fish:Update(deltaTime)
    local seconds = deltaTime / 1000
    self.MovementState:Update(seconds)
    self:TransitionState()
    self._IsCollidingWithBobber = false
end

---@override
---@param deltaTime number In milliseconds.
function _Fish:LateUpdate(deltaTime)
    UI._CapturableGameObjectClass.LateUpdate(self, deltaTime)
end

---@override
---@return number
function _Fish:GetRequiredProgress()
    return Fishing.BASE_PROGRESS_REQUIRED * self.Descriptor.Endurance
end

---Returns a randomized state duration in seconds, scaled by fish Difficulty.
---@return number
function _Fish:_RandomStateDuration()
    local cycleTime = self.BASE_CYCLE_TIME / self.Descriptor.Difficulty
    return cycleTime * (math.random() * self.STATE_CHANGE_COOLDOWN_RANDOM_FACTOR * 2 + (1 - self.STATE_CHANGE_COOLDOWN_RANDOM_FACTOR))
end

---Transition to the next movement state.
function _Fish:TransitionState()
    if not self.MovementState:IsFinished() then return end

    local behaviour = Fishing.GetBehaviour(self.Descriptor.Behaviour)
    local transitions = behaviour.Transitions[self.MovementState:GetClassName()]
    local targetStateName = self:_PickRandomTransition(transitions)
    self:SetState(self:CreateState(targetStateName))

    -- Reset velocity and acceleration
    local state = self.State
    state.Velocity = 0
    state.Acceleration = 0
end

---Factory method for creating states with reasonable default parameters.
---@param stateClassName Features.Fishing.GameObject.Fish.StateClassName
---@return Features.Fishing.GameObject.Fish.State
function _Fish:CreateState(stateClassName)
    local class = Fishing:GetClass(stateClassName)
    if stateClassName == "Features.Fishing.GameObject.Fish.States.Tweening" then
        local easingFunc = self:_GetRandomTweenFunction()
        local targetPosition = math.random() * UI.GetBobberUpperBound()
        local duration = self.BASE_TWEEN_DURATION / self.Descriptor.Difficulty
        return class:Create(easingFunc, targetPosition, duration)
    end
    return class:Create(self:_RandomStateDuration())
end

---@override
function _Fish:UpdatePosition()
    local element = self:GetElement()
    element:SetPosition(UI.BLOBBER_AREA_SIZE[1] / 2, UI.BLOBBER_AREA_SIZE[2] - self.State.Position - element:GetSize()[2] / 2)
end

---Picks a target state using weighted random selection over a list of transitions.
---@param transitions Features.Fishing.Fish.Behaviour.Transition[]
---@return Features.Fishing.GameObject.Fish.StateClassName
function _Fish:_PickRandomTransition(transitions)
    local totalWeight = 0
    for _,transition in ipairs(transitions) do
        totalWeight = totalWeight + transition.Weight
    end
    local roll = math.random() * totalWeight
    local usedWeight = 0
    for _,transition in ipairs(transitions) do
        usedWeight = usedWeight + transition.Weight
        if roll <= usedWeight then
            return transition.TargetState
        end
    end
    return transitions[#transitions].TargetState
end

---Sets the movement state.
---@param state Features.Fishing.GameObject.Fish.State
function _Fish:SetState(state)
    self.MovementState = state
    self.MovementState:SetFish(self)
    UI:DebugLog("Fish changed state to", state:GetClassName())
end

---@override
function _Fish:OnCollideWith(otherObject, deltaTime)
    UI._CapturableGameObjectClass.OnCollideWith(self, otherObject, deltaTime)
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
