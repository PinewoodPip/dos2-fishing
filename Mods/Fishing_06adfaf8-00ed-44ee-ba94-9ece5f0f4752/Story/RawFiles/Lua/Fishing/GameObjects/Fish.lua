
local Fishing = Epip.GetFeature("Features.Fishing")
local UI = Fishing.UI ---@class Features.Fishing.UI

---@class Features.Fishing.GameObject.Fish : Features.Fishing.GameObject
local _Fish = {
    Type = "Fish",
    Timer = 0,
    CYCLE_TIME = 2,
    MovementState = nil, ---@type Features.Fishing.GameObject.Fish.State
    ACCELERATION = 40,
    MAX_ACCELERATION = 30,
    MAX_VELOCITY = 70,
}
Inherit(_Fish, UI._GameObjectClass)
UI.RegisterGameObject("Features.Fishing.GameObject.Fish", _Fish)

function _Fish:Update(deltaTime)
    local seconds = deltaTime / 1000

    -- Update current state
    self.MovementState:Update(seconds)

    -- Switch states based on timer
    self.Timer = self.Timer + seconds
    if self.Timer > self.CYCLE_TIME then
        self:TransitionState()
        self.Timer = 0
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
