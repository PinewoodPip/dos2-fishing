
local Tooltip = Client.Tooltip
local Input = Client.Input

---@class Features.Fishing
local Fishing = GetFeature("Features.Fishing")
local TSK = Fishing.TranslatedStrings
Fishing._CharacterTasks = {} ---@type table<CharacterHandle, Features.Fishing.CharacterTask>

---@class Features.Fishing.CharacterTask : UserspaceCharacterTaskCallbacks
local _Task = {
    RESTART_COOLDOWN = 400, -- Cooldown between stopping fishing and being able to fish again, in milliseconds.
    IsPreviewing = false,
    CharacterHandle = nil, ---@type ComponentHandle
    RestartCooldown = 0,

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

-- Updates the cursor once per tick while the task is previewing.
function _Task:SetCursor()
    local cc = Ext.UI.GetCursorControl()
    if self.IsPreviewing then
        local isTooFar = self:TargetPosIsTooFar()
        local cursorText = isTooFar and TSK.Notification_CantFish_TooFar:GetString() or TSK.Tooltip_ClickToFish:GetString()
        cc.MouseCursor = isTooFar and "CursorWand_Warning" or "CursorWand_Ground"
        Tooltip.ShowMouseTextTooltip(cursorText, Vector.Create(30, 20))
    end
end

function _Task:Update()
    self:SetCursor()

    return false
end

-- Necessary for preview to be entered. Called when the priority is highest.
function _Task:CanEnter()
    return self:HasValidTargetPos() or self:TargetPosIsTooFar()
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

---Returns whether the task can enter the preview state.
---@return boolean
function _Task:CanPreview()
    local char = self:GetCharacter()
    local hasRod = Fishing.HasFishingRodEquipped(char) and Character.IsUnsheathed(char)
    local region = Fishing.GetRegionAt(char.WorldPos)
    local skillState = Character.GetCurrentSkill(char)
    return not skillState and hasRod and region and Fishing.IsCursorNearWater(region) or false
end

function _Task:GetPriority(previousPriority)
    return previousPriority < 9999 and self:CanPreview() and 9999 or -99
end

function _Task:GetExecutePriority(_)
    return 9999
end

function _Task:GetDescription()
    return "Fish! For fish." -- Not used anywhere afaik.
end

function _Task:HasValidTargetPos()
    local char = Character.Get(self.CharacterHandle)
    local region = Fishing.GetRegionAt(char.WorldPos)
    return region ~= nil and (Fishing.CanFish(char))
end

---Returns whether the target position is fishable but out of the character's casting range.
---@return boolean
function _Task:TargetPosIsTooFar()
    local canFish, reason = Fishing.CanFish(self:GetCharacter())
    return not canFish and reason == Fishing.TranslatedStrings.Notification_CantFish_TooFar:GetString()
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
    if task and task.IsPreviewing and task:MeetsRequirements() and not Client.IsCursorOverUI() then
        local isOnCooldown = Ext.Utils.MonotonicTime() - task.RestartCooldown < task.RESTART_COOLDOWN
        if not isOnCooldown and ev.State == "Released" then -- Start fishing on release
            Fishing.Start(char)
        end
        ev:Prevent() -- Prevent Pressed state as well to avoid side-effects.
    end
end)

-- Reset cooldown for being able to fish again after stopping fishing.
Fishing.Events.CharacterStoppedFishing:Subscribe(function (ev)
    local char = ev.Character
    local task = Fishing._CharacterTasks[char.Handle]
    task.RestartCooldown = Ext.Utils.MonotonicTime()
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
