local Fishing = GetFeature("Features.Fishing")
local _Autonomous = Fishing:GetClass("Features.Fishing.Minigame.GameObjects.Autonomous")
local UI = Fishing.UI ---@class Features.Fishing.UI

---@class Features.Fishing.GameObject.TreasureChest : Features.Fishing.Minigame.GameObjects.Autonomous
---@field GetElement fun(self):GenericUI_Element_Color
---@field _IsCollidingWithBobber boolean
local _TreasureChest = {
    BASE_CYCLE_TIME = 1.6,
    ACCELERATION = 30,
    MAX_ACCELERATION = 24,
    MAX_VELOCITY = 58,
    STATE_CHANGE_COOLDOWN_RANDOM_FACTOR = 0.25,
    DIFFICULTY = 0.7,
}
Fishing:RegisterClass("Features.Fishing.GameObject.TreasureChest", _TreasureChest, {"Features.Fishing.Minigame.GameObjects.Autonomous"})
UI.RegisterGameObject("Features.Fishing.GameObject.TreasureChest", _TreasureChest)

local StateClassNames = {
    FLOATING = "Features.Fishing.GameObject.MovementStates.Floating",
    SINKING = "Features.Fishing.GameObject.MovementStates.Sinking",
}

---------------------------------------------
-- METHODS
---------------------------------------------

---@param elementID string
---@param size Vector2
---@param state Features.Fishing.GameObject.State
---@return Features.Fishing.GameObject.TreasureChest
function _TreasureChest:Create(elementID, size, state)
    local instance = _Autonomous.Create(self, elementID, size, state) ---@cast instance Features.Fishing.GameObject.TreasureChest
    instance._IsCollidingWithBobber = false
    instance:SetState(instance:CreateState(StateClassNames.SINKING))
    return instance
end

---@override
---@return number
function _TreasureChest:GetDifficulty()
    return self.DIFFICULTY
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

---@param stateClassName Features.Fishing.GameObject.MovementState.ClassName
---@return Features.Fishing.GameObject.MovementState
function _TreasureChest:CreateState(stateClassName)
    local class = Fishing:GetClass(stateClassName)
    return class:Create(self:__RandomStateDuration())
end

---@override
function _TreasureChest:UpdatePosition()
    local element = self:GetElement()
    element:SetPosition(UI.BOBBER_AREA_SIZE[1] / 2, UI.BOBBER_AREA_SIZE[2] - self.State.Position - element:GetSize()[2] / 2)
end

---@override
function _TreasureChest:OnCollideWith(otherObject, deltaTime)
    UI._CapturableGameObjectClass.OnCollideWith(self, otherObject, deltaTime)
end
