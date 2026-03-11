
local Tooltip = Client.Tooltip
local Input = Client.Input

---@class Features.Fishing
local Fishing = Epip.GetFeature("Features.Fishing")
Fishing._CharacterTasks = {} ---@type table<CharacterHandle, Features.Fishing.CharacterTask>

---@class Features.Fishing.CharacterTask : UserspaceCharacterTaskCallbacks
local _Task = {
    IsPreviewing = false,
    CharacterHandle = nil, ---@type ComponentHandle

    ID = "Epip_Feature_Fishing",
}
Fishing._CharacterTaskClass = _Task

---------------------------------------------
-- METHODS
---------------------------------------------

---@param char EclCharacter
---@return Features.Fishing.CharacterTask
function _Task.Create(char)
    local tbl = {CharacterHandle = char and char.Handle}
    Inherit(tbl, _Task)

    Fishing._CharacterTasks[char.Handle] = tbl

    return tbl
end

function _Task:GetCharacter()
    return Character.Get(self.CharacterHandle)
end

function _Task:Enter()
    return false
end

function _Task:Attached() end

-- Called once per tick while the task has priority.
function _Task:SetCursor()
    local cc = Ext.UI.GetCursorControl()

    if self.IsPreviewing then
        cc.MouseCursor = "CursorWand_Ground"

        Tooltip.ShowMouseTextTooltip(Fishing.TSK["CharacterTask_MouseTextTooltip"], Vector.Create(30, 20))
    end
end

function _Task:Update()
    self:SetCursor()

    return false
end

-- Necessary for preview to be entered. Called when the priority is highest.
function _Task:CanEnter()
    return self:HasValidTargetPos()
end

function _Task:CanExit()
    return true
end

function _Task:CanExit2()
    return true
end

-- Called when the task loses top priority or is cancelled.
function _Task:ExitPreview()
    self.IsPreviewing = false

    Tooltip.HideMouseTextTooltip()
end

function _Task:Exit() end

function _Task:MeetsRequirements()
    local char = self:GetCharacter()

    return self:HasValidTargetPos() and Fishing.HasFishingRodEquipped(char) and Character.IsUnsheathed(char)
end

function _Task:GetPriority(previousPriority)
    if previousPriority < 9999 and self:MeetsRequirements() then
        return 9999
    end

    return -99
end

function _Task:GetDescription()
    return "Fish! For fish." -- Not used anywhere afaik.
end

function _Task:GetExecutePriority(_)
    return 9999
end

function _Task:HasValidTargetPos()
    local char = Character.Get(self.CharacterHandle)
    local region = Fishing.GetRegionAt(char.WorldPos)
    local isCursorByWater = Fishing.IsPositionNearWater(Pointer.GetWalkablePosition(), Fishing.WATER_CURSOR_SEARCH_RADIUS, region and region.FishableSurfaceType or nil)
    return region ~= nil and (isCursorByWater or Fishing.CanFish(char))
end

function _Task:HasValidTarget()
    return false
end

function _Task:UpdatePreview() end

_Task.GetError = function (self)
    if not self:HasValidTargetPos() then
       return 4
    else
       return 0
    end
 end

function _Task:EnterPreview() -- Called when the task has high enough priority
    self.IsPreviewing = true
end

-- Custom character tasks require all methods to be defined even if not used.
---@diagnostic disable-next-line: unused-local
function _Task:HandleInputEvent(ev, _) end
function _Task:Start() end
function _Task:Stop() end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Attach the task to active characters.
local attached = DataStructures.Get("DataStructures_Set").Create()
Client.Events.ActiveCharacterChanged:Subscribe(function (ev)
    local char = ev.NewCharacter
    if char and not attached:Contains(char.Handle) then
        Ext.Behavior.AttachCharacterTask(char, _Task.ID)
        attached:Add(char.Handle)
    end
end)

-- Start fishing when a valid spot is clicked.
-- This is used in place of Start() as otherwise the character would also attempt to move to the clicked spot (race condition?)
Input.Events.KeyStateChanged:Subscribe(function (ev)
    if ev.InputID ~= "left2" then return end
    local char = Client.GetCharacter()
    local task = char and Fishing._CharacterTasks[char.Handle]
    if task and task.IsPreviewing and task:MeetsRequirements() then
        -- Start fishing on release
        if ev.State == "Released" then
            Fishing.Start(char)
        end
        ev:Prevent() -- Prevent Pressed state as well to avoid side-effects.
    end
end)

-- Hide tooltips from tasks when the cursor hovers over a UI.
GameState.Events.Tick:Subscribe(function()
    for _,task in pairs(Fishing._CharacterTasks) do
        if task.IsPreviewing and Client.IsCursorOverUI() then
            Tooltip.HideMouseTextTooltip()
            break -- Only one such text tooltip may exist at once(?)
        end
    end
end)

---------------------------------------------
-- SETUP
---------------------------------------------

Ext.Behavior.RegisterCharacterTask(_Task.ID, _Task.Create)
