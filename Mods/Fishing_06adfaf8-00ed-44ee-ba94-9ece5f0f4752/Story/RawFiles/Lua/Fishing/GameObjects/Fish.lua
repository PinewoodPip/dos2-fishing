
local Fishing = GetFeature("Fishing")
local _Autonomous = Fishing:GetClass("Fishing.Minigame.GameObjects.Autonomous")
local UI = Fishing.UI ---@class Fishing.UI

---@class Fishing.GameObject.Fish : Fishing.Minigame.GameObjects.Autonomous
---@field GetElement fun(self):GenericUI_Element_IggyIcon
---@field Descriptor Fishing.Fish
---@field _IsCollidingWithBobber boolean
local _Fish = {
    Type = "Fish",

    BASE_CYCLE_TIME = 2,
    ACCELERATION = 40,
    MAX_ACCELERATION = 30,
    MAX_VELOCITY = 70,
    STATE_CHANGE_COOLDOWN_RANDOM_FACTOR = 0.4,
    BASE_TWEEN_DURATION = 1.5, -- Base tween duration in seconds, scaled down by fish Difficulty; higher Difficulty results in shorter tween states.
}
Fishing:RegisterClass("Fishing.GameObject.Fish", _Fish, {"Fishing.Minigame.GameObjects.Autonomous"})
UI.RegisterGameObject("Fishing.GameObject.Fish", _Fish)

local MovementStates = {
    Sinking = Fishing:GetClass("Fishing.GameObject.MovementStates.Sinking"),
    Floating = Fishing:GetClass("Fishing.GameObject.MovementStates.Floating"),
    Tweening = Fishing:GetClass("Fishing.GameObject.MovementStates.Tweening")
}

---------------------------------------------
-- METHODS
---------------------------------------------

---Creates a Fish game object.
---@param descriptor Fishing.Fish
---@param elementID string
---@param size Vector2
---@param state Fishing.GameObject.State
---@return Fishing.GameObject.Fish
function _Fish:Create(descriptor, elementID, size, state)
    local instance = _Autonomous.Create(self, elementID, size, state) ---@cast instance Fishing.GameObject.Fish
    instance.Descriptor = descriptor
    instance._IsCollidingWithBobber = false
    instance:SetState(instance:CreateState("Fishing.GameObject.MovementStates.Sinking"))
    return instance
end

---@override
---@return number
function _Fish:GetDifficulty()
    return self.Descriptor.Difficulty
end

---@override
---@return number
function _Fish:GetRequiredProgress()
    return Fishing.BASE_PROGRESS_REQUIRED * self.Descriptor.Endurance
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
---@param stateClassName Fishing.GameObject.MovementState.ClassName
---@return Fishing.GameObject.MovementState
function _Fish:CreateState(stateClassName)
    local class = Fishing:GetClass(stateClassName)
    if stateClassName == "Fishing.GameObject.MovementStates.Tweening" then
        local easingFunc = self:_GetRandomTweenFunction()
        local targetPosition = math.random() * UI.GetBobberUpperBound()
        local duration = self.BASE_TWEEN_DURATION / self.Descriptor.Difficulty
        return class:Create(easingFunc, targetPosition, duration)
    end
    return class:Create(self:__RandomStateDuration())
end

---@override
function _Fish:UpdatePosition()
    local element = self:GetElement()
    element:SetPosition(UI.BOBBER_AREA_SIZE[1] / 2, UI.BOBBER_AREA_SIZE[2] - self.State.Position - element:GetSize()[2] / 2)
end

---Picks a target state using weighted random selection over a list of transitions.
---@param transitions Fishing.Fish.Behaviour.Transition[]
---@return Fishing.GameObject.MovementState.ClassName
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

---@override
---@param state Fishing.GameObject.MovementState
function _Fish:SetState(state)
    _Autonomous.SetState(self, state)
    UI:DebugLog("Fish changed state to", state:GetClassName())
end

---@override
function _Fish:OnCollideWith(otherObject, deltaTime)
    UI._CapturableGameObjectClass.OnCollideWith(self, otherObject, deltaTime)
end

---Returns a random tweening function for the Tweening state.
---@return Fishing.GameObject.MovementStates.Tweening.EasingFunction
function _Fish:_GetRandomTweenFunction()
    local TweenState = MovementStates.Tweening
    local tweenTypes = {}
    for tweenType,_ in pairs(TweenState.EASING_FUNCTIONS) do
        table.insert(tweenTypes, tweenType)
    end
    return tweenTypes[math.random(1, #tweenTypes)]
end
