---------------------------------------------
-- Abstract class for a game object that can be "captured" by the player
-- if the bobber intersects with it for long enough.
---------------------------------------------

local Fishing = GetFeature("Features.Fishing")

---@class Features.Fishing.UI
local UI = GetFeature("Features.Fishing").UI

---@class Features.Fishing.Minigame.GameObjects.Capturable : Features.Fishing.GameObject
---@field Progress number
---@field _IsCollidingWithBobber boolean
local _Capturable = {
    Progress = 0,
    _IsCollidingWithBobber = false,
}
Fishing:RegisterClass("Features.Fishing.Minigame.GameObjects.Capturable", _Capturable, {"Features.Fishing.GameObject"})

---------------------------------------------
-- METHODS
---------------------------------------------

---Adds capture progress.
---@param progress number
---@return number -- New progress.
function _Capturable:AddProgress(progress)
    local newProgress = self.Progress + progress
    self:SetProgress(newProgress)
    return self.Progress
end

---Sets the capture progress.
---@param progress number
function _Capturable:SetProgress(progress)
    local requirement = self:GetRequiredProgress()
    self.Progress = math.clamp(progress, 0, requirement)
    if requirement - self.Progress <= 10e-3 then -- Compensate for floating point limitations from clamp().
        self.Progress = requirement
    end
end

---Returns the progress required to capture this object.
---@virtual
---@return number
function _Capturable:GetRequiredProgress()
    return 1
end

---@override
function _Capturable:LateUpdate(deltaTime)
    -- Add progress while colliding with bobber
    if self._IsCollidingWithBobber then
        local drain = UI.GetProgressDrain()
        local progress = (drain + UI.PROGRESS_PER_SECOND) * deltaTime / 1000
        self:AddProgress(progress)
    end
end

---@override
function _Capturable:OnCollideWith(otherObject, _)
    if otherObject:GetClassName() == "Features.Fishing.GameObject.Bobber" then
        self._IsCollidingWithBobber = true
    end
end

---------------------------------------------
-- SETUP
---------------------------------------------

UI._CapturableGameObjectClass = _Capturable
