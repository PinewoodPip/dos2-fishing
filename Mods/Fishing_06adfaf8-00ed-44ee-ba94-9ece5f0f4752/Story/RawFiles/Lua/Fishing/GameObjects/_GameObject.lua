
---@class Features.Fishing.UI
local UI = Epip.GetFeature("Features.Fishing").UI

---------------------------------------------
-- STATE
---------------------------------------------

---Holds the physics state of a GameObject.
---@class Features.Fishing.GameObject.State
local _State = {
    Acceleration = 0,
    Velocity = 0,
    Position = 0,
}

---@return Features.Fishing.GameObject.State
function _State.Create()
    ---@type Features.Fishing.GameObject.State
    local tbl = {
        Acceleration = 0,
        Position = 0,
    }
    Inherit(tbl, _State)

    return tbl
end

---------------------------------------------
-- GAME OBJECT
---------------------------------------------

---@class Features.Fishing.GameObject
---@field State Features.Fishing.GameObject.State
---@field Size Vector2D
---@field ElementID string
---@field Type string
local _GameObject = {}

function _GameObject:Create(elementID, size, state)
    ---@type Features.Fishing.GameObject
    local tbl = {
        State = state,
        ElementID = elementID,
        Size = size,
    }
    Inherit(tbl, self)

    return tbl
end

function _GameObject:GetUpperBound()
    return self.State.Position + self.Size[2]
end

---@diagnostic disable: unused-local
---@param deltaTime number In milliseconds.
function _GameObject:Update(deltaTime) error("Not implemented") end -- TODO use template method pattern
---@diagnostic enable: unused-local

---@param otherObject Features.Fishing.GameObject
---@return boolean
function _GameObject:IsCollidingWith(otherObject)
    local myState = self:GetState()
    local otherState = otherObject:GetState()

    return myState.Position < (otherObject:GetUpperBound()) and self:GetUpperBound() >= otherState.Position
end

---@diagnostic disable: unused-local
---@param otherObject Features.Fishing.GameObject
---@param deltaTime number In milliseconds.
function _GameObject:OnCollideWith(otherObject, deltaTime) end
---@diagnostic enable: unused-local

---@return Features.Fishing.GameObject.State
function _GameObject:GetState()
    return self.State
end

---@return GenericUI_Element
function _GameObject:GetElement()
    return UI:GetElementByID(self.ElementID)
end

function _GameObject:UpdatePosition()
    local element = self:GetElement()

    element:SetPositionRelativeToParent("Bottom", 0, -self.State.Position)
end

---------------------------------------------
-- SETUP
---------------------------------------------

UI._GameObjectClass = _GameObject
UI._GameObjectStateClass = _State