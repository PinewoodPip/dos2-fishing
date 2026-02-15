
local Fishing = Epip.GetFeature("Features.Fishing")

---@class Features.Fishing.GameObject.Fish.State : Class
---@field Fish Features.Fishing.GameObject.Fish
---@field ClassName Features.Fishing.GameObject.Fish.StateClassName
local State = {}
Fishing:RegisterClass("Features.Fishing.GameObject.Fish.State", State)

---@alias Features.Fishing.GameObject.Fish.StateClassName "Features.Fishing.GameObject.Fish.State"|"Features.Fishing.GameObject.Fish.States.Floating"|"Features.Fishing.GameObject.Fish.States.Sinking"

---------------------------------------------
-- METHODS
---------------------------------------------

---Base constructor.
---@param state table|Features.Fishing.GameObject.Fish.State State data.
---@return Features.Fishing.GameObject.Fish.State
function State:Create(state)
    state = self:__Create(state) ---@cast state Features.Fishing.GameObject.Fish.State
    return state
end

---@param fish Features.Fishing.GameObject.Fish
function State:SetFish(fish)
    self.Fish = fish
end

---@virtual
---@param dt number In seconds.
---@diagnostic disable-next-line: unused-local
function State:Update(dt)

end

---Returns whether the fish is moving upward.
---@return boolean
function State:IsFloating()
    return false
end

---Returns whether the fish is moving downward.
---@return boolean
function State:IsSinking()
    return false
end
