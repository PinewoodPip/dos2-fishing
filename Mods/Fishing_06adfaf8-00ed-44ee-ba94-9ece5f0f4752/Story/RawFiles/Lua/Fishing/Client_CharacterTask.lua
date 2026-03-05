
local Tooltip = Client.Tooltip

---@class Features.Fishing
local Fishing = Epip.GetFeature("Features.Fishing")
Fishing._CharacterTasks = {} ---@type table<CharacterHandle, Features.Fishing.CharacterTask>

---@class Features.Fishing.CharacterTask : UserspaceCharacterTaskCallbacks
local _Task = {
    IsPreviewing = false,
    CharacterHandle = nil, ---@type ComponentHandle

    ID = "Epip_Feature_Fishing",
    WATER_SEARCH_RADIUS = 0.3,
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
    return 0
end

-- Called when left click is pressed, even if the task does not have top priority.
function _Task:Start()
    if self:MeetsRequirements() then
        Fishing.Start(self:GetCharacter())
    end
end

-- Called when right-click is pressed.
function _Task:Stop() end

function _Task:HasValidTargetPos() -- TODO make it require looking at the water
    local char = Character.Get(self.CharacterHandle)
    local region = Fishing.GetRegionAt(char.WorldPos)
    local isCursorByWater = Fishing.IsPositionNearWater(Pointer.GetWalkablePosition(), self.WATER_SEARCH_RADIUS)

    return region and (isCursorByWater or Fishing.CanFish(char))
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

---@diagnostic disable-next-line: unused-local
function _Task:HandleInputEvent(ev, _) end -- Custom character tasks require all methods to be defined even if not used.

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
