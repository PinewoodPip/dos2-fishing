
local Fishing = GetFeature("Features.Fishing")

---@class Features.Fishing.UI
local UI = Fishing.UI

---------------------------------------------
-- STATE
---------------------------------------------

---Holds the physics state of a GameObject.
---@class Features.Fishing.GameObject.State : Class
local _State = {
    Acceleration = 0,
    Velocity = 0,
    Position = 0,
}
Fishing:RegisterClass("Features.Fishing.GameObject.State", _State)

---Base constructor.
---@return Features.Fishing.GameObject.State
function _State:Create()
    ---@type Features.Fishing.GameObject.State
    local tbl = {
        Acceleration = 0,
        Position = 0,
    }
    return self:__Create(tbl) ---@type Features.Fishing.GameObject.State
end

---------------------------------------------
-- GAME OBJECT
---------------------------------------------

---@class Features.Fishing.GameObject : Class
---@field State Features.Fishing.GameObject.State
---@field Size Vector2
---@field ElementID string
local _GameObject = {}
Fishing:RegisterClass("Features.Fishing.GameObject", _GameObject)

---Base constructor.
---@param elementID string
---@param size Vector2
---@param state Features.Fishing.GameObject.State
---@return Features.Fishing.GameObject
function _GameObject:Create(elementID, size, state)
    ---@type Features.Fishing.GameObject
    local tbl = {
        State = state,
        ElementID = elementID,
        Size = size,
    }
    return self:__Create(tbl) ---@type Features.Fishing.GameObject
end

---Called every tick, before collision callbacks.
---@abstract
---@param deltaTime number In milliseconds.
---@diagnostic disable-next-line: unused-local
function _GameObject:Update(deltaTime) error("Not implemented") end

---Called after `Update()` and all collision callbacks.
---@virtual
---@param deltaTime number In milliseconds.
---@diagnostic disable-next-line: unused-local
function _GameObject:LateUpdate(deltaTime) end

---Returns whether the object is intersecting with another one.
---@param otherObject Features.Fishing.GameObject
---@return boolean
function _GameObject:IsCollidingWith(otherObject)
    local myState = self:GetState()
    local myBound = self:GetUpperBound()
    local myPos = myState.Position
    local otherState = otherObject:GetState()
    local otherBound = otherObject:GetUpperBound()
    local otherPos = otherState.Position
    return (myPos < otherBound and myBound >= otherPos) or (myPos >= otherPos and myPos < otherBound) or (otherPos < myBound and otherPos >= myPos)
end

---Called when the object starts intersecting with another one.
---@diagnostic disable: unused-local
---@param otherObject Features.Fishing.GameObject
---@param deltaTime number In milliseconds.
function _GameObject:OnCollideWith(otherObject, deltaTime) end
---@diagnostic enable: unused-local

---Returns the physics state of the object.
---@return Features.Fishing.GameObject.State
function _GameObject:GetState()
    return self.State
end

---Returns the element bound to this object.
---@return GenericUI_Element
function _GameObject:GetElement()
    return UI:GetElementByID(self.ElementID)
end

---Updates the element's position.
function _GameObject:UpdatePosition()
    local element = self:GetElement()
    element:SetPositionRelativeToParent("BottomLeft", 0, -self.State.Position)
end

---Returns the position of the upper collider bound of the object.
---@return number
function _GameObject:GetUpperBound()
    return self.State.Position + self.Size[2]
end

---------------------------------------------
-- SETUP
---------------------------------------------

UI._GameObjectClass = _GameObject
UI._GameObjectStateClass = _State