
local V = Vector.Create

---@class Features.Fishing
local Fishing = GetFeature("Features.Fishing")
local TSK = Fishing.TranslatedStrings

---@type table<CharacterHandle, {TargetPosition: Vector3, ReelingIn: boolean}>
Fishing._CharacterStates = {}

Fishing.MINIGAME_ANIMATION = "skill_prepare_weapon_01_loop"
Fishing.ANIMATION_EVENT = "EPIP_FISHING_LOOP"
Fishing.SUCCESS_ANIMATION = "use_loot"
Fishing.FAILURE_ANIMATION = "emotion_sad"
Fishing.FISH_SPLASH_EFFECT = "PIP_FX_LargeSplash"

---------------------------------------------
-- METHODS
---------------------------------------------

---Grants the fish item to char and increments statistics.
---@param char EsvCharacter
---@param fish Features.Fishing.Fish
---@return GUID
function Fishing.CatchFish(char, fish)
    local charGUID = char.MyGuid
    Osi.CharacterStatusText(charGUID, TSK.Notification_Minigame_Success:GetString())
    Osi.PlayAnimation(charGUID, Fishing.SUCCESS_ANIMATION, "")
    local fishItemGUID = Osi.ItemTemplateAddTo(fish.TemplateID, charGUID, 1, 1)

    -- Roll for an extra catch
    local extraCatchChance = Fishing.GetExtraCatchChance(char)
    if math.random() <= extraCatchChance then
        Osi.ItemTemplateAddTo(fish.TemplateID, charGUID, 1, 1)
        Osi.CharacterStatusText(char.MyGuid, TSK.Notification_ExtraCatch:Format({
            Color = Color.LARIAN.LIGHT_BLUE,
        })) -- TODO play some kaching sound fx too
    end
    local oldFishermancy = Fishing.GetAbilityScore(char)

    -- Track stats
    Fishing.AddFishCatchCount(char, fish.ID)
    Fishing.MarkFishTypeAsCaught(fish.ID)

    -- Show skill ability level up feedback 
    local newFishermancy = Fishing.GetAbilityScore(char)
    if newFishermancy > oldFishermancy then
        Osi.CharacterPlayHUDSound(charGUID, "UI_Game_LevelUp")
        Osi.PlayEffect(charGUID, "RS3_FX_GP_Status_LevelUp_01")
        Osi.CharacterStatusText(charGUID, TSK.Notification_FishermancyLevelUp:Format({
            Color = Color.LARIAN.GOLD,
        }))
    end

    return fishItemGUID
end

---Marks a fish type as having been caught in this playthrough.
---@param fishID Features.Fishing.FishID
function Fishing.MarkFishTypeAsCaught(fishID)
    local fishCaught, _ = Fishing.GetUniqueFishCaught()
    local wasCaught = fishCaught[fishID]
    if wasCaught then return end

    local fish = Fishing.GetFish(fishID)
    local uniqueFishCaught = Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_UNIQUE_FISH_CAUGHT)
    uniqueFishCaught[fishID] = true
    Fishing:SetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_UNIQUE_FISH_CAUGHT, uniqueFishCaught)

    Fishing.Events.FishDiscovered:Throw({
        Fish = fish,
    })
end

---Starts the fishing animation loop for char.
---@see Features.Fishing.ANIMATION_EVENT
---@param char EsvCharacter
function Fishing.PlayAnimation(char)
    local state = Fishing._CharacterStates[char.Handle]
    Osiris.PlayAnimation(char, Fishing.MINIGAME_ANIMATION, Fishing.ANIMATION_EVENT)
    if state.ReelingIn then
        Osi.PlayScaledEffectAtPosition("PIP_FX_ContinuousSplashes", 4, table.unpack(state.TargetPosition + Fishing.TARGET_POS_EFFECT_OFFSET))
    end
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Tag characters when they start fishing and play an animation.
Fishing.Events.CharacterStartedFishing:Subscribe(function (ev)
    local char = ev.Character
    Fishing._CharactersFishing:Add(char.Handle)

    -- Face target position
    -- Unfortunately there's no Osiris call for this that takes position (only GUID) and the ROTATE status doesn't seem usable, so we spawn a temporary item as a workaround.
    local x, y, z = table.unpack(ev.TargetPosition)
    local dummyItemGUID = Osi.CreateItemTemplateAtPosition(Item.TEMPLATES.GOLD, x, y, z) -- Gold template conveniently has no destroy visuals.
    Osi.CharacterLookAt(char.MyGuid, dummyItemGUID, 1)

    -- Play telekinesis beam effect if the casting range was boosted
    local castingRange = Vector.GetLength(V(char.WorldPos) - ev.TargetPosition)
    if castingRange > Fishing.TUNING.BASE_CASTING_RANGE then
        Osi.PlayBeamEffect(char.MyGuid, dummyItemGUID, Item.TELEKINESIS_BEAM_EFFECT, "Dummy_R_Hand", "Dummy_Root")
    end

    Osi.ItemDestroy(dummyItemGUID) -- Not immediate; processed at the end of tick, thus it's safe to use the GUID throughout this listener.

    Fishing.PlayAnimation(char) -- Should be done after facing the target, as characters cannot turn during an animation.

    Fishing.MarkRegionAsDiscovered(ev.Region.ID)
end)

-- Loop animation if the character is still fishing.
Osiris.RegisterSymbolListener("StoryEvent", 2, "after", function (obj, event)
    if event == Fishing.ANIMATION_EVENT then
        local char = Character.Get(obj)
        if Fishing.IsFishing(char) then
            Fishing.PlayAnimation(char)
        end
    end
end)

-- Play Lucky Charm FX when a character encounters a chest.
Net.RegisterListener(Fishing.NETMSG_FOUND_TREASURE_CHEST, function (payload)
    local char = payload:GetCharacter()
    Osi.PlayEffect(char.MyGuid, Item.LUCKY_CHARM_EFFECT, Item.LUCKY_CHARM_EFFECT_BONE)
    Osi.CharacterPlayHUDSound(char.MyGuid, "UI_LuckyFind")
end)

-- Untag characters when they finish fishing.
Fishing.Events.CharacterStoppedFishing:Subscribe(function (ev)
    local state = Fishing._CharacterStates[ev.Character.Handle]
    local char = ev.Character

    -- Stop previous animation
    Osiris.CharacterFlushQueue(char)

    Fishing._CharactersFishing:Remove(char.Handle)

    -- Success/failure feedback
    if ev.Reason == "Success" then
        local caughtFish = ev.CaughtFish
        local caughtChest = ev.CaughtChest

        -- Catch fish
        Fishing.CatchFish(char, caughtFish)
        Osi.PlayScaledEffectAtPosition(Fishing.FISH_SPLASH_EFFECT, 3, table.unpack(state.TargetPosition + Fishing.TARGET_POS_EFFECT_OFFSET))

        -- Catch treasure chest
        if caughtChest then
            local treasureTable = caughtChest.TreasureTable
            local chestGUID = Osi.CreateItemTemplateAtPosition(caughtChest.Template, table.unpack(state.TargetPosition))
            Osi.GenerateTreasure(chestGUID, treasureTable, char.Stats.Level, char.MyGuid)
            Osi.ItemToInventory(chestGUID, char.MyGuid, 1, 0, 1)
        end
    elseif ev.Reason == "Failure" then
        Osiris.PlayAnimation(char, Fishing.FAILURE_ANIMATION, "")
    end
end)

-- Listen for clients starting to fish and forward the event.
Net.RegisterListener(Fishing.NETMSG_STARTED_FISHING, function (payload)
    local region = Fishing.GetRegion(payload.RegionID)
    local char = payload:GetCharacter()
    Fishing._CharacterStates[char.Handle] = {
        TargetPosition = V(payload.TargetPosition),
        ReelingIn = false,
    }
    Fishing.Events.CharacterStartedFishing:Throw({
        Character = char,
        Region = region,
        TargetPosition = payload.TargetPosition,
    })
end)

-- Listen for clients exiting the minigame and forward the event.
Net.RegisterListener(Fishing.NETMSG_STOPPED_FISHING, function (payload)
    local char = payload:GetCharacter()
    Fishing.Events.CharacterStoppedFishing:Throw({
        Character = char,
        Reason = payload.Reason,
        CaughtFish = payload.CaughtFishID and Fishing.GetFish(payload.CaughtFishID) or nil,
        CaughtChest = payload.CaughtChestID and Fishing.GetTreasureChest(payload.CaughtChestID) or nil,
    })
    Fishing._CharacterStates[char.Handle] = nil
end)

-- Listen for clients encountering fishes.
Net.RegisterListener(Fishing.NETMSG_ENCOUNTERED_FISH, function (payload)
    Fishing.AddFishEncounter(payload.FishID)
    local char = payload:GetCharacter()
    local state = Fishing._CharacterStates[char.Handle]
    state.ReelingIn = true
    Osi.PlayEffectAtPosition(Fishing.FISH_SPLASH_EFFECT, table.unpack(state.TargetPosition + Fishing.TARGET_POS_EFFECT_OFFSET))
end)

-- Cheat to add all fish items.
Ext.RegisterConsoleCommand("fishaddall", function (_, amount)
    amount = tonumber(amount) or 1
    local charGUID = Osi.CharacterGetHostCharacter()
    local char = Character.Get(charGUID)
    for _,fish in pairs(Fishing.GetFishes()) do
        for _=1,amount,1 do
            Fishing.CatchFish(char, fish)
        end
    end
    Osi.CharacterFlushQueue(charGUID) -- Skip all catch animations, as they would've been queued otherwise.
end)
Ext.RegisterConsoleCommand("fishaddallrunes", function (_)
    local charGUID = Osi.CharacterGetHostCharacter()
    for _,fish in pairs(Fishing.GetFishes()) do
        for tier=1,#fish.RootTemplates,1 do
            local runeTemplate = fish.RootTemplates[tier]
            Osi.ItemTemplateAddTo(runeTemplate, charGUID, 1, 1)
        end
    end
end)

-- Cheat to emulate catching a fish.
Ext.RegisterConsoleCommand("fishcatch", function (_, fishID, amount)
    amount = tonumber(amount) or 1
    local charGUID = Osi.CharacterGetHostCharacter()
    local fish = Fishing.GetFish(fishID)
    for _=1,amount,1 do
        Fishing.CatchFish(Character.Get(charGUID), fish)
    end
end)

-- Cheat to discover all regions.
Ext.RegisterConsoleCommand("fishdiscoverall", function (_)
    for _,regions in pairs(Fishing._RegionsByLevel) do
        for _,region in pairs(regions) do
            Fishing.MarkRegionAsDiscovered(region.ID)
        end
    end
end)
