
local Fishing = GetFeature("Fishing")
local UI = Fishing.UI ---@class Fishing.UI

---@class Fishing.GameObject.Bobber : Fishing.GameObject
---@field GetElement fun(self):GenericUI_Element_Color
---@field _IsCollidingWithFish boolean
---@field _RaiseSoundCooldown number
local _Bobber = {
    Type = "Bobber",

    -- UI_Game_Skillbar_Lock too clicky
    -- UI_Game_Reward_MoveCursor soft
    RAISE_SOUND = "UI_Game_Reward_MoveCursor", -- UI_Game_Dialog_Open has variation, nice swoosh, maybe use for fish leaving the zone
    RAISE_SOUND_COOLDOWN = 0.27, -- In seconds.
    BOTTOM_BOUNCE_FACTOR = 0.9, -- Fraction of downward speed converted into upward upon bouncing from the bottom.
    MIN_BOUNCE_SPEED = 12, -- Minimum velocity required for the bobber to bounce when reaching the bottom.
    FISH_ENTER_SOUND = "UI_Game_PartyFormation_PickUp", -- Sound to play when the bobber enters a fish's range.
    FISH_EXIT_SOUND = "UI_Game_Dialog_Open", -- Sound to play when the bobber exits a fish's range.
}
Fishing:RegisterClass("Fishing.GameObject.Bobber", _Bobber, {"Fishing.GameObject"})
UI.RegisterGameObject("Fishing.GameObject.Bobber", _Bobber)

---------------------------------------------
-- METHODS
---------------------------------------------

---Creates a Bobber game object.
---@param elementID string
---@param size Vector2
---@param state Fishing.GameObject.State
---@return Fishing.GameObject.Bobber
function _Bobber:Create(elementID, size, state)
    local tbl = UI._GameObjectClass.Create(self, elementID, size, state)
    ---@cast tbl Fishing.GameObject.Bobber
    tbl._IsCollidingWithFish = false
    tbl._RaiseSoundCooldown = 0
    return tbl
end

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

    local upperBound = UI.GetBobberUpperBound() -- TODO use gameobject method
    state.Position = math.clamp(state.Position + state.Velocity * seconds, 0, upperBound)

    -- Bounce when reaching the bottom
    if state.Position <= 0 then
        if state.Velocity < 0 then
            local upBounceSpeed = -state.Velocity
            if upBounceSpeed >= self.MIN_BOUNCE_SPEED then
                state.Velocity = math.min(upBounceSpeed * self.BOTTOM_BOUNCE_FACTOR, UI.MAX_VELOCITY)
            else
                state.Velocity = 0
            end
        end
        state.Acceleration = 0
    elseif state.Position >= upperBound then
        state.Velocity = 0
        state.Acceleration = 0
    end

    -- Update visuals
    local element = self:GetElement()
    local bobberColor = Fishing.GetBobberColor(UI.GetCharacter())
    element:SetColor(wasColliding and bobberColor.HighlightColor or bobberColor.NormalColor)

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
function _Bobber:OnCollideWith(otherObject, _)
    local className = otherObject:GetClassName()
    if className == "Fishing.GameObject.Fish" or className == "Fishing.GameObject.TreasureChest" then
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
