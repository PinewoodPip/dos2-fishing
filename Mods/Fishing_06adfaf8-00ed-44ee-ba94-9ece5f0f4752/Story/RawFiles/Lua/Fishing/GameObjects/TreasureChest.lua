local Fishing = GetFeature("Fishing")
local _Autonomous = Fishing:GetClass("Fishing.Minigame.GameObjects.Autonomous")
local UI = Fishing.UI ---@class Fishing.UI

---@class Fishing.GameObject.TreasureChest : Fishing.Minigame.GameObjects.Autonomous
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
Fishing:RegisterClass("Fishing.GameObject.TreasureChest", _TreasureChest, {"Fishing.Minigame.GameObjects.Autonomous"})
UI.RegisterGameObject("Fishing.GameObject.TreasureChest", _TreasureChest)

local StateClassNames = {
    FLOATING = "Fishing.GameObject.MovementStates.Floating",
    SINKING = "Fishing.GameObject.MovementStates.Sinking",
}

---------------------------------------------
-- METHODS
---------------------------------------------

---@param elementID string
---@param size Vector2
---@param state Fishing.GameObject.State
---@return Fishing.GameObject.TreasureChest
function _TreasureChest:Create(elementID, size, state)
    local instance = _Autonomous.Create(self, elementID, size, state) ---@cast instance Fishing.GameObject.TreasureChest
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

---@param stateClassName Fishing.GameObject.MovementState.ClassName
---@return Fishing.GameObject.MovementState
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
