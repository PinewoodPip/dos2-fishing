local Fishing = GetFeature("Features.Fishing")
local _Capturable = Fishing:GetClass("Features.Fishing.Minigame.GameObjects.Capturable")
local UI = Fishing.UI ---@class Features.Fishing.UI

---@class Features.Fishing.GameObject.TreasureChest : Features.Fishing.Minigame.GameObjects.Capturable
---@field GetElement fun(self):GenericUI_Element_Color
---@field _IsCollidingWithBobber boolean
---@field MovementState Features.Fishing.GameObject.Fish.State
local _TreasureChest = {
    -- TODO refactor capturable to not require a fish to determine these values
    ---@type Features.Fishing.Fish
    Descriptor = {
        Difficulty = 0.7,
        Endurance = 1.2,
    },

    BASE_CYCLE_TIME = 1.6,
    ACCELERATION = 30,
    MAX_ACCELERATION = 24,
    MAX_VELOCITY = 58,
    STATE_CHANGE_COOLDOWN_RANDOM_FACTOR = 0.25,
    DIFFICULTY = 1.2,
}
Fishing:RegisterClass("Features.Fishing.GameObject.TreasureChest", _TreasureChest, {"Features.Fishing.Minigame.GameObjects.Capturable"})
UI.RegisterGameObject("Features.Fishing.GameObject.TreasureChest", _TreasureChest)

local StateClassNames = {
    FLOATING = "Features.Fishing.GameObject.Fish.States.Floating",
    SINKING = "Features.Fishing.GameObject.Fish.States.Sinking",
}

---------------------------------------------
-- METHODS
---------------------------------------------

---@param elementID string
---@param size Vector2
---@param state Features.Fishing.GameObject.State
---@return Features.Fishing.GameObject.TreasureChest
function _TreasureChest:Create(elementID, size, state)
    local instance = _Capturable.Create(self, elementID, size, state) ---@cast instance Features.Fishing.GameObject.TreasureChest
    instance._IsCollidingWithBobber = false
    instance:SetState(instance:CreateState(StateClassNames.SINKING))
    return instance
end

---@param deltaTime number In milliseconds.
function _TreasureChest:Update(deltaTime)
    local seconds = deltaTime / 1000
    self.MovementState:Update(seconds)
    self:TransitionState()
    self._IsCollidingWithBobber = false
end

---@override
---@param deltaTime number In milliseconds.
function _TreasureChest:LateUpdate(deltaTime)
    _Capturable.LateUpdate(self, deltaTime)
end

---@override
---@return number
function _TreasureChest:GetRequiredProgress()
    return 1
end

---Transition to the opposite movement state.
function _TreasureChest:TransitionState()
    if not self.MovementState:IsFinished() then return end
    local currentStateName = self.MovementState:GetClassName()

    -- Switch between floating and sinking
    local targetStateName = StateClassNames.FLOATING
    if currentStateName == StateClassNames.FLOATING then
        targetStateName = StateClassNames.SINKING
    end
    self:SetState(self:CreateState(targetStateName))
    local state = self.State
    state.Velocity = 0
    state.Acceleration = 0
end

---@param stateClassName Features.Fishing.GameObject.Fish.StateClassName
---@return Features.Fishing.GameObject.Fish.State
function _TreasureChest:CreateState(stateClassName)
    local class = Fishing:GetClass(stateClassName)
    return class:Create(self:_RandomStateDuration())
end

---@override
function _TreasureChest:UpdatePosition()
    local element = self:GetElement()
    element:SetPosition(UI.BOBBER_AREA_SIZE[1] / 2, UI.BOBBER_AREA_SIZE[2] - self.State.Position - element:GetSize()[2] / 2)
end

---@param state Features.Fishing.GameObject.Fish.State
function _TreasureChest:SetState(state)
    self.MovementState = state
    self.MovementState:SetFish(self)
end

---@override
function _TreasureChest:OnCollideWith(otherObject, deltaTime)
    UI._CapturableGameObjectClass.OnCollideWith(self, otherObject, deltaTime)
end

---@return number
function _TreasureChest:_RandomStateDuration()
    local cycleTime = self.BASE_CYCLE_TIME / self.DIFFICULTY
    return cycleTime * (math.random() * self.STATE_CHANGE_COOLDOWN_RANDOM_FACTOR * 2 + (1 - self.STATE_CHANGE_COOLDOWN_RANDOM_FACTOR))
end
