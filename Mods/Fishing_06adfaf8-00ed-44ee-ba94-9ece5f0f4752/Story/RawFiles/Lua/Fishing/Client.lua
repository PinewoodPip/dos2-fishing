
local NotificationUI = Client.UI.Notification
local V = Vector.Create

---@class Features.Fishing
local Fishing = Epip.GetFeature("Features.Fishing")
local TSK = Fishing.TranslatedStrings
Fishing.OPEN_LOG_KEYBIND = "EpipEncounters_Fishing_OpenCollectionLog"

Fishing.Hooks.CanStartFishing = Fishing:AddSubscribableHook("CanStartFishing") ---@type Event<Features.Fishing.Hook.CanStartFishing>

---------------------------------------------
-- EVENTS/HOOKS
---------------------------------------------

---@class Features.Fishing.Hook.CanStartFishing
---@field Character EclCharacter
---@field Region Features.Fishing.Region
---@field CanStartFishing boolean Hookable. Defaults to true.
---@field FailureReason string? Will be shown in a notification toast if CanStartFishing is false.

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns whether char can start the fishing minigame.
---@param char EclCharacter
---@return boolean, string? -- Whether the character can fish, and reason why not (if applicable).
function Fishing.CanFish(char)
    local region = Fishing.GetRegionAt(char.WorldPos)
    local canFish = region ~= nil
    local reason = nil ---@type string?
    if region then
        local hook = Fishing.Hooks.CanStartFishing:Throw({
            Character = char,
            CanStartFishing = true,
            Region = region,
        })
        canFish = hook.CanStartFishing
        reason = hook.FailureReason
    end
    return canFish, reason
end

---@param char Character
function Fishing.Start(char)
    local region = Fishing.GetRegionAt(char.WorldPos)

    -- Cannot fish in areas with no fishing region.
    if not region then
        NotificationUI.ShowWarning(TSK.Notification_NoFishNearby)
    else
        local canFish, reason = Fishing.CanFish(char)
        if canFish then
            local fish = Fishing.GetRandomFish(region)

            Fishing._CharactersFishing:Add(char.Handle)

            if Fishing:IsDebug() then
                NotificationUI.ShowNotification("Starting fishing in " .. region.ID)
            end

            Fishing.Events.CharacterStartedFishing:Throw({
                Character = char,
                Region = region,
                Fish = fish,
            })

            Net.PostToServer("Feature_Fishing_NetMsg_CharacterStartedFishing", {
                CharacterNetID = char.NetID,
                RegionID = region.ID,
                FishID = fish.ID,
            })
        else -- Otherwise show failure reason (if provided)
            if reason then
                NotificationUI.ShowNotification(reason)
            end
        end
    end
end

---@param char EclCharacter?
---@param searchRadius number? Defaults to WATER_SEARCH_RADIUS.
---@return boolean
function Fishing.IsNearWater(char, searchRadius)
    char = char or Client.GetCharacter()
    local position = char.WorldPos

    return Fishing.IsPositionNearWater(Vector.Create(position), searchRadius)
end

---Returns whether a position is near a Deepwater surface.
---@param position Vector3D
---@param searchRadius number? Defaults to WATER_SEARCH_RADIUS.
---@return boolean
function Fishing.IsPositionNearWater(position, searchRadius)
    local grid = Ext.Entity.GetAiGrid()
    local foundCell = grid:SearchForCell(position[1], position[3], searchRadius or Fishing.WATER_SEARCH_RADIUS, "Deepwater", 0)

    return foundCell
end

---@param fishID string
---@return integer
function Fishing.GetTimesCaught(fishID)
    return Fishing:GetSettingValue(Fishing.Settings.FishCaught)[fishID] or 0
end

---@return integer
function Fishing.GetTotalFishCaught()
    local fishes = Fishing.GetFishes()
    local total = 0

    for id,_ in pairs(fishes) do
        total = total + Fishing.GetTimesCaught(id)
    end

    return total
end

---@param char EclCharacter
---@param fish Features.Fishing.Fish TODO rework param
---@param reason Features.Fishing.MinigameExitReason
function Fishing.Stop(char, fish, reason)
    Fishing._CharactersFishing:Remove(char.Handle)

    if reason == "Success" then
        Fishing._OnSuccess(fish)
    end

    Fishing.Events.CharacterStoppedFishing:Throw({
        Character = char,
        Reason = reason,
        Fish = fish,
    })

    Net.PostToServer("Feature_Fishing_NetMsg_CharacterStoppedFishing", {
        CharacterNetID = char.NetID,
        Reason = reason,
        FishID = fish.ID,
    })
end

---@param fish Features.Fishing.Fish
function Fishing._OnSuccess(fish)
    local setting = Fishing:GetSettingValue(Fishing.Settings.FishCaught)

    -- Increment catch counter.
    if not setting[fish.ID] then
        setting[fish.ID] = 1
    else
        setting[fish.ID] = setting[fish.ID] + 1
    end

    Fishing:SaveSettings()
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Show notifications for success or failure.
Fishing.Events.CharacterStoppedFishing:Subscribe(function (ev)
    if ev.Reason == "Success" then
        local subTitle = nil

        -- Show a hint on how to open the collection log the first time you catch each type of fish.
        if Fishing.GetTimesCaught(ev.Fish:GetID()) == 1 then
            local keybinds = Client.Input.GetActionBindings(Fishing.OPEN_LOG_KEYBIND)
            local keybind = keybinds[1]

            if keybind then
                subTitle = Text.Format(Fishing.TSK["Toast_Success_Subtitle"], {
                    FormatArgs = {
                        Client.Input.StringifyBinding(keybind, true)
                    }
                })
            end
        end

        NotificationUI.ShowIconNotification(ev.Fish:GetName(), ev.Fish:GetIcon(), nil, Fishing.TSK["Toast_Success"], subTitle, "UI_Notification_ReceiveAbility")
    elseif ev.Reason == "Failure" then
        NotificationUI.ShowWarning(TSK.Notification_Minigame_Failure:GetString())
    end
end)

-- Default conditions that prevent fishing.
Fishing.Hooks.CanStartFishing:Subscribe(function (ev)
    local char = ev.Character
    local reason

    if Fishing.IsFishing(char) then
        reason = TSK.Notification_CantFish_AlreadyFishing:GetString()
    elseif Client.IsInCombat() or Client.IsInDialogue() then
        reason = TSK.Notification_CantFish_NotTheTime:GetString()
    elseif not Fishing.HasFishingRodEquipped(char) then
        reason = TSK.Notification_CantFish_NoRod:GetString()
    elseif not Character.IsUnsheathed(char) then
        reason = TSK.Notification_CantFish_RodSheathed:GetString()
    end

    -- Check if the player and cursor area near water
    local cursorPos = Pointer.GetWalkablePosition()
    local charNearWater = Fishing.IsNearWater(char)
    local canFish = charNearWater and Fishing.IsPositionNearWater(cursorPos)
    if ev.Region.RequiresWater and not charNearWater then
        canFish = false
    end
    if not canFish and ev.Region.FishingAreas then -- Check for manually defined fishing areas
        local charPos = V(char.WorldPos[1], char.WorldPos[3])
        local cursorPos2D = V(cursorPos[1], cursorPos[3])
        local cursorX, cursorY = cursorPos2D[1], cursorPos2D[2]
        local distanceToCursor = Vector.GetLength(cursorPos2D - charPos)
        if distanceToCursor <= Fishing.WATER_MAX_DISTANCE then
            -- Check if the cursor is within any of the fishing areas defined for the region.
            for _,bounds in ipairs(ev.Region.FishingAreas) do
                local boundsX, boundsY, w, h = table.unpack(bounds)
                if cursorX >= boundsX and cursorX <= boundsX + w and cursorY >= boundsY and cursorY <= boundsY + h then
                    canFish = true
                    break
                end
            end
        end
    end
    if not canFish then
        reason = TSK.Notification_CantFish_NoWater:GetString()
    end

    if reason then
        ev.CanStartFishing = false
        ev.FailureReason = reason
    end
end, {StringID = "DefaultImplementation"})

-- Update fishing rod templates to have a world tooltip to make them easier to find.
GameState.Events.ClientReady:Subscribe(function (_)
    for guid in Fishing.FISHING_ROD_TEMPLATES:Iterator() do
        local template = Ext.Template.GetTemplate(guid) ---@cast template ItemTemplate
        template.Tooltip = 2
    end
end)
