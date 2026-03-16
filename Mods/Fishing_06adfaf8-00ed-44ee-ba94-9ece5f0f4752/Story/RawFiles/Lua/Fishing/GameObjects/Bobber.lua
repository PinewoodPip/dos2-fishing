
local Fishing = GetFeature("Features.Fishing")
local UI = Fishing.UI ---@class Features.Fishing.UI

---@class Features.Fishing.GameObject.Bobber : Features.Fishing.GameObject
---@field GetElement fun(self):GenericUI_Element_Color
local _Bobber = {
    Type = "Bobber",

    -- UI_Game_Skillbar_Lock too clicky
    -- UI_Game_Reward_MoveCursor soft
    RAISE_SOUND = "UI_Game_Reward_MoveCursor", -- UI_Game_Dialog_Open has variation, nice swoosh, maybe use for fish leaving the zone
    RAISE_SOUND_COOLDOWN = 0.27, -- In seconds.
    FISH_ENTER_SOUND = "UI_Game_PartyFormation_PickUp", -- Sound to play when the bobber enters a fish's range.
    FISH_EXIT_SOUND = "UI_Game_Dialog_Open", -- Sound to play when the bobber exits a fish's range.

    _IsCollidingWithFish = false,
    _RaiseSoundCooldown = 0,
}
Inherit(_Bobber, UI._GameObjectClass)
UI.RegisterGameObject("Features.Fishing.GameObject.Bobber", _Bobber)

---@param deltaTime number In milliseconds.
function _Bobber:Update(deltaTime)
    local wasColliding = self._IsCollidingWithFish
    local state = self.State
    local seconds = deltaTime / 1000
    local acceleration = state.Acceleration
    local applyGravity = not Client.Input.IsKeyPressed("left2") -- TODO turn into a hook

    -- Apply player force or gravity
    local EXPONENT = UI.PHYSICS_EXPONENT
    if applyGravity then
        acceleration = acceleration - (UI.GRAVITY * seconds) ^ EXPONENT
    else
        acceleration = acceleration + (UI.PLAYER_STRENGTH * seconds) ^ EXPONENT
    end

    state.Acceleration = math.clamp(acceleration, -UI.MAX_ACCELERATION, UI.MAX_ACCELERATION)
    state.Velocity = state.Velocity + acceleration * seconds
    state.Velocity = math.clamp(state.Velocity, -UI.MAX_VELOCITY, UI.MAX_VELOCITY)

    state.Position = math.clamp(state.Position + state.Velocity * seconds, 0, UI.GetBobberUpperBound())

    if state.Position <= 0 or state.Position >= UI.GetBobberUpperBound() then -- TODO use gameobject method
        state.Velocity = 0
        state.Acceleration = 0
    end

    -- Update visuals
    local element = self:GetElement()
    element:SetColor(wasColliding and UI.BOBBER_COLLISION_COLOR or UI.BOBBER_COLOR)

    -- Play sound when reeling in
    self._RaiseSoundCooldown = self._RaiseSoundCooldown - seconds
    if not applyGravity and self._RaiseSoundCooldown <= 0 then
        self._RaiseSoundCooldown = self.RAISE_SOUND_COOLDOWN
        UI:PlaySound(self.RAISE_SOUND)
    end

    self._WasCollidingWithFish = wasColliding
    self._IsCollidingWithFish = false
end

---@override
function _Bobber:OnCollideWith(otherObject, deltaTime)
    if otherObject.Type == "Fish" then
        -- Add progress. The drain must be offset.
        local drain = UI.GetProgressDrain()

        UI.AddProgress((drain + UI.PROGRESS_PER_SECOND) * deltaTime / 1000)

        self._IsCollidingWithFish = true

        -- Play sound when entering fish range
        if not self._WasCollidingWithFish then
            UI:PlaySound(self.FISH_ENTER_SOUND)
        end
    end
end

function _Bobber:LateUpdate(_)
    -- Play woosh sound when exiting fish range
    if self._WasCollidingWithFish and not self._IsCollidingWithFish then
        UI:PlaySound(self.FISH_EXIT_SOUND)
    end
end
