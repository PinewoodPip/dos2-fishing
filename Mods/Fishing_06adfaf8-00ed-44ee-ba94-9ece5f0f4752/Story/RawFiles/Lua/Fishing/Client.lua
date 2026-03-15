
local CharacterSheet = Client.UI.CharacterSheet
local PartyInventory = Client.UI.PartyInventory
local NotificationUI = Client.UI.Notification
local Tooltip = Client.Tooltip
local Input = Client.Input
local V = Vector.Create

---@class Features.Fishing
local Fishing = Epip.GetFeature("Features.Fishing")
local TSK = Fishing.TranslatedStrings
Fishing.FISHING_ROD_RARITY_COLOR = Color.LARIAN.BLUE
Fishing.SKILL_ABILITY_ICON = "PIP_Fishing_SkillAbility"

-- Bite phase tuning
Fishing.FISH_BITE_DELAY_RANGE = {3.2, 6.5} -- Time range (in seconds) for how long it can take for a fish to bite after the player starts fishing.
Fishing.FISH_BITE_DURATION = 0.4 -- Duration the player has to react to a bite before the fish gets away, in seconds.

-- Reeling phase tuning
Fishing.STARTING_PROGRESS = 0.45 -- As fraction of required progress.
Fishing.BASE_PROGRESS_REQUIRED = 1
Fishing.PROGRESS_DRAIN = 0.1
Fishing.BITE_ALERT_EFFECT = "PIP_FX_ExclamationMark"
Fishing.BITE_ALERT_SOUND = "UI_Handling_Lockpick_Stop"
Fishing.SPLASH_EFFECT_INTERVAL = 1 -- Interval between small splash effects during the waiting-for-bite phase, in seconds.

Fishing._MINIGAME_TIMER_INFIXES = {"BiteNotification", "BiteTimeout"}

Fishing._States = {} ---@type table<CharacterHandle, Features.Fishing.GameState>

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
-- CLASSES
---------------------------------------------

---@alias Features.Fishing.GameStateType "WaitingForBite" | "Fishing"

---@class Features.Fishing.GameState
---@field Type Features.Fishing.GameStateType
---@field CharacterHandle CharacterHandle
---@field TargetPosition Vector3

---@class Features.Fishing.GameStates.WaitingForBite : Features.Fishing.GameState
---@field Type "WaitingForBite"
---@field BiteTime integer Monotonic time at which the fish will bite.

---@class Features.Fishing.GameStates.Fishing : Features.Fishing.GameState
---@field Type "Fishing"
---@field CurrentFish Features.Fishing.Fish
---@field Progress number

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

---Returns char's fishing minigame state, if they're fishing.
---@param char EclCharacter
---@return Features.Fishing.GameState?
function Fishing.GetState(char)
    return Fishing._States[char.Handle]
end

---@param char Character
function Fishing.Start(char)
    local region = Fishing.GetRegionAt(char.WorldPos)
    local charHandle = char.Handle

    -- Cannot fish in areas with no fishing region.
    if not region then
        NotificationUI.ShowWarning(TSK.Notification_NoFishNearby)
    else
        local canFish, reason = Fishing.CanFish(char)
        if canFish then
            local minBiteTime, maxBiteTime = table.unpack(Fishing.FISH_BITE_DELAY_RANGE)
            local biteTimeRange = maxBiteTime - minBiteTime
            local biteTime = minBiteTime + math.random() * biteTimeRange

            Fishing._CharactersFishing:Add(char.Handle)
            Fishing._States[char.Handle] = {
                Type = "WaitingForBite",
                CharacterHandle = char.Handle,
                BiteTime = Ext.Utils.MonotonicTime() + biteTime * 1000,
                TargetPosition = V(Pointer.GetWalkablePosition()),
            }

            if Fishing:IsDebug() then
                NotificationUI.ShowNotification("Starting fishing in " .. region.ID)
            end

            -- Periodically play small ripples/splashes until the real bite
            local splashTimer = Timer.Start("Fishing.Splash." .. char.MyGuid, Fishing.SPLASH_EFFECT_INTERVAL, function (ev)
                char = Character.Get(charHandle)
                local state = Fishing.GetState(char)
                if state and state.Type == "WaitingForBite" then
                    local targetPos = state.TargetPosition + Fishing.TARGET_POS_EFFECT_OFFSET
                    Fishing._PlayEffect(targetPos, "PIP_FX_SmallSplash", 2.5)
                else
                    ev.Timer:Cancel()
                end
            end)
            splashTimer:SetRepeatCount(-1)

            -- Show timing hint when the fish bites
            Timer.Start("Fishing.BiteNotification." .. char.MyGuid, biteTime, function (_)
                char = Character.Get(charHandle)
                NotificationUI.ShowNotification(TSK.Notification_Biting:GetString(), nil, nil, Fishing.BITE_ALERT_SOUND)

                -- Play alert effect
                local effectPos = V(char.WorldPos) + V(0, char.Height, 0)
                Fishing._PlayEffect(effectPos, Fishing.BITE_ALERT_EFFECT)

                splashTimer:Cancel()
            end)

            -- Fail the minigame if the player missed the bite
            Timer.Start("Fishing.BiteTimeout." .. char.MyGuid, biteTime + Fishing.FISH_BITE_DURATION, function (_)
                char = Character.Get(charHandle)
                local state = Fishing.GetState(char)
                if state and state.Type == "WaitingForBite" then
                    Fishing.Stop(char, "Failure")
                end
            end)

            -- Show feedback for discovering new regions
            if not Fishing.IsRegionDiscovered(region.ID) then
                local regionName = Text.GetTranslatedString(region.NameHandle)
                NotificationUI.ShowIconNotification(TSK.Notification_RegionDiscovered:Format(regionName), "Item_HAR_FishingRod_ABC")
            end

            -- Hide main panel UIs
            CharacterSheet:TryHide()
            PartyInventory:TryHide()

            -- Throw events
            local targetPos = Pointer.GetWalkablePosition()
            Fishing.Events.CharacterStartedFishing:Throw({
                Character = char,
                Region = region,
                TargetPosition = targetPos,
            })
            Net.PostToServer(Fishing.NETMSG_STARTED_FISHING, {
                CharacterNetID = char.NetID,
                RegionID = region.ID,
                TargetPosition = targetPos,
            })
        else -- Otherwise show failure reason (if provided)
            if reason then
                NotificationUI.ShowNotification(reason)
            end
        end
    end
end

---Attempts to proceed to the reeling part of the minigame.
---@param char EclCharacter
function Fishing.ReelIn(char)
    local state = Fishing.GetState(char)
    if state and state.Type ~= "WaitingForBite" then Fishing:__Error("ReelIn", "Character is not waiting for bite") return end
    ---@cast state Features.Fishing.GameStates.WaitingForBite

    -- Transition to fishing state,
    -- or fail the minigame if reeling was mistimed.
    local now = Ext.Utils.MonotonicTime()
    if now > state.BiteTime and now < state.BiteTime + Fishing.FISH_BITE_DURATION * 1000 then
        local region = Fishing.GetRegionAt(char.WorldPos)
        local fish = Fishing.GetRandomFish(region)
        Fishing._States[char.Handle] = {
            Type = "Fishing",
            CharacterHandle = char.Handle,
            CurrentFish = fish,
            Progress = Fishing.STARTING_PROGRESS * fish.Endurance,
            TargetPosition = state.TargetPosition,
        }
        Net.PostToServer(Fishing.NETMSG_ENCOUNTERED_FISH, {
            CharacterNetID = char.NetID,
            FishID = fish.ID,
        })
        Fishing.UI.Start(char) -- TODO extract in case someone wants to replace the minigame entirely
    else
        Fishing.Stop(char, "ReeledInTooEarly")
    end
end

---@param char EclCharacter?
---@param searchRadius number? Defaults to WATER_SEARCH_RADIUS.
---@param waterSurface SurfaceType? Defaults to "Deepwater".
---@return boolean
function Fishing.IsNearWater(char, searchRadius, waterSurface)
    char = char or Client.GetCharacter()
    local position = char.WorldPos
    return Fishing.IsPositionNearWater(Vector.Create(position), searchRadius, waterSurface)
end

---Returns whether a position is near a Deepwater surface.
---@param position Vector3D
---@param searchRadius number? Defaults to WATER_SEARCH_RADIUS.
---@param waterSurface SurfaceType? Defaults to "Deepwater".
---@return boolean
function Fishing.IsPositionNearWater(position, searchRadius, waterSurface)
    local grid = Ext.Entity.GetAiGrid()
    local surfaceFlags = Ext.Enums.ESurfaceFlag[waterSurface or "Deepwater"]
    local foundCell = grid:SearchForCell(position[1], position[3], searchRadius or Fishing.WATER_SEARCH_RADIUS, surfaceFlags.__Value, 0)
    return foundCell
end

---Finishes the fishing minigame for char.
---@param char EclCharacter
---@param reason Features.Fishing.MinigameExitReason
function Fishing.Stop(char, reason)
    local state = Fishing.GetState(char)
    if not state then Fishing:__Error("Stop", "Character is not fishing") return end
    local fish = nil ---@type Features.Fishing.Fish
    if state.Type == "Fishing" then
        ---@cast state Features.Fishing.GameStates.Fishing
        fish = state.CurrentFish
    end

    -- Clear timers
    for _, timerName in ipairs(Fishing._MINIGAME_TIMER_INFIXES) do
        local timerID = "Fishing." .. timerName .. "." .. char.MyGuid
        local timer = Timer.GetTimer(timerID)
        if timer then
            timer:Cancel()
        end
    end

    Fishing.Events.CharacterStoppedFishing:Throw({
        Character = char,
        Reason = reason,
        CaughtFish = fish,
    })

    Net.PostToServer(Fishing.NETMSG_STOPPED_FISHING, {
        CharacterNetID = char.NetID,
        Reason = reason,
        CaughtFishID = fish and fish.ID or nil,
    })

    Fishing._CharactersFishing:Remove(char.Handle)
    Fishing._States[char.Handle] = nil
end

---Returns whether an item is usable as a fishing rod.
---@param item Item
---@return boolean
function Fishing.IsFishingRod(item)
    return Fishing.FISHING_ROD_TEMPLATES:Contains(item.RootTemplate.Id)
end

---Plays a single-loop effect at pos.
---@param pos vec3
---@param effect string
---@param scale number? Defaults to 1.
---@param duration number? Time after which the handler will be disposed. Defaults to 2.
function Fishing._PlayEffect(pos, effect, scale, duration)
    scale = scale or 1
    duration = duration or 2
    local effectHandler = Ext.Visual.Create(pos)
    local effectHandlerHandle = effectHandler.Handle
    effectHandler:ParseFromStats(effect)

    -- Rescale the effect
    local effectHandle = Ext.Visual.Get(effectHandlerHandle).Effects[1]
    Ext.Entity.GetEffect(effectHandle).WorldTransform.Scale = {scale, scale, scale}

    -- Dispose after a delay
    Timer.Start(duration, function (_)
        Ext.Visual.Get(effectHandlerHandle):Delete()
    end)
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Show notifications for success or failure.
Fishing.Events.CharacterStoppedFishing:Subscribe(function (ev)
    if ev.Reason == "Success" then
        local char = ev.Character
        local subTitle = nil

        -- Show a hint on how to open the collection log the first time you catch each type of fish.
        if Fishing.GetFishCatchCount(char, ev.CaughtFish:GetID()) == 1 then
            local CollectionLog = Epip.GetFeature("Features.Fishing.Codex.CollectionLog")
            local keybinds = Input.GetActionBindings(CollectionLog.InputActions.OpenCollectionLog.ID)
            local keybind = keybinds[1]
            if keybind then
                subTitle = Text.Format(Fishing.TSK["Toast_Success_Subtitle"], {
                    FormatArgs = {
                        Input.StringifyBinding(keybind, true)
                    }
                })
            end
        end

        NotificationUI.ShowIconNotification(ev.CaughtFish:GetName(), ev.CaughtFish:GetIcon(), nil, Fishing.TSK["Toast_Success"], subTitle, "UI_Notification_ReceiveAbility")
    elseif ev.Reason == "Failure" then
        NotificationUI.ShowWarning(TSK.Notification_Minigame_Failure:GetString(), nil, "UI_Handling_Fail")
    elseif ev.Reason == "ReeledInTooEarly" then
        NotificationUI.ShowWarning(TSK.Notification_Minigame_ReeledInTooEarly:GetString())
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
    local charNearWater = Fishing.IsNearWater(char, nil, ev.Region.FishableSurfaceType)
    local canFish = charNearWater and Fishing.IsPositionNearWater(cursorPos, nil, ev.Region.FishableSurfaceType)
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

-- Listen for inputs to reel in during WaitingForBite phase.
Input.Events.KeyPressed:Subscribe(function (ev)
    if ev.InputID == "left2" then
        local char = Client.GetCharacter()
        local state = Fishing.GetState(char)
        if state and state.Type == "WaitingForBite" then
            Fishing.ReelIn(char)
        end
    end
end, {EnabledFunctor = GameState.IsInRunningSession})

-- Add tooltip hints on how to use fishing rods.
Tooltip.Hooks.RenderItemTooltip:Subscribe(function (ev)
    if Fishing.IsFishingRod(ev.Item) then
        local tooltip = ev.Tooltip
        tooltip:InsertElement({
            Type = "Engraving",
            Label = TSK.Label_FishingRodHint:Format({
                Color = Color.LARIAN.GREEN,
            }),
        })

        -- Recolor header
        local itemNameElement = tooltip:GetFirstElement("ItemName")
        local itemName = Text.StripFormatting(itemNameElement.Label)
        itemNameElement.Label = Text.Format(itemName, {
            Color = Fishing.FISHING_ROD_RARITY_COLOR,
        })

        -- Change rarity/footer to indicate the item is a rod
        local rarityElement = tooltip:GetFirstElement("ItemRarity")
        rarityElement.Label = TSK.Label_FishingRod:Format({
            Color = Fishing.FISHING_ROD_RARITY_COLOR,
        })
    end
end)

-- Format fish item names & rarity tooltips.
Tooltip.Hooks.RenderItemTooltip:Subscribe(function (ev)
    local fish = Fishing.GetFishByTemplate(ev.Item.RootTemplate.Id)
    if fish then
        local Runes = Epip.GetFeature("Features.Fishing.Runes") -- TODO it's dirty that we have to fetch the feature here
        local tooltip = ev.Tooltip
        local runeTier = Runes.GetFishRuneTier(ev.Item)

        -- Set name (with rarity color)
        local itemNameElement = tooltip:GetFirstElement("ItemName")
        itemNameElement.Label = fish:GetNameTooltip(runeTier).Label

        -- Set description
        local descriptionElement = tooltip:GetFirstElement("ItemDescription")
        local fishDesc = fish:GetDescription()
        if descriptionElement then
            descriptionElement.Label = fishDesc
        else
            tooltip:InsertElement({
                Type = "ItemDescription",
                Label = fishDesc,
            })
        end

        -- Add rarity label
        local itemRarityElement = tooltip:GetFirstElement("ItemRarity")
        local fishRarityTooltip = fish:GetRarityTooltip()
        if itemRarityElement then
            itemRarityElement.Label = fishRarityTooltip.Label
        else
            tooltip:InsertElement(fishRarityTooltip, 1) -- ItemRarity must be among the first elements or the flash element sorting function breaks (vanilla bug)
        end
    end
end)

-- Update fishing rod templates to have a world tooltip to make them easier to find.
GameState.Events.ClientReady:Subscribe(function (_)
    for guid in Fishing.FISHING_ROD_TEMPLATES:Iterator() do
        local template = Ext.Template.GetTemplate(guid) ---@cast template ItemTemplate
        template.Tooltip = 2
    end
end)

-- Replace fish template names & descriptions with TSKs.
GameState.Events.ClientReady:Subscribe(function (_)
    for _,fish in pairs(Fishing.GetFishes()) do
        for i=1,#fish.RootTemplates,1 do
            local templateID = fish.RootTemplates[i]
            local template = Ext.Template.GetTemplate(templateID) ---@cast template ItemTemplate
            local statID = template.Stats

            local tierPrefix = Fishing.RUNE_TIER_PREFIXES[i]
            if tierPrefix then
                local prefixedName = tierPrefix:Format({
                    FormatArgs = {fish:GetName()},
                })
                -- Use raw strings, no need to register actual TSKs for these
                template.DisplayName = prefixedName
                -- Create string key for stat ID (necessary for crafting UI result preview tooltips)
                Ext.L10N.CreateTranslatedString(statID, prefixedName)
            else -- Use base name for tier 1 and fallback.
                template.DisplayName = fish.NameHandle
                Ext.L10N.CreateTranslatedString(statID, fish.NameHandle)
            end

            template.Description = fish.DescriptionHandle
        end
    end
end)
