
local V = Vector.Create

---@class Fishing
local Fishing = GetFeature("Fishing")
local TSK = Fishing.TranslatedStrings

---@type table<CharacterHandle, {TargetPosition: Vector3, ReelingIn: boolean, RegionID: Fishing.RegionID}>
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
---@param fish Fishing.Fish
---@param fromPos vec3? If set, the fish will tween from this position into the character; otherwise it will be added to the inventory immediately.
---@return GUID
function Fishing.CatchFish(char, fish, fromPos)
    local charGUID = char.MyGuid
    local spawnPos = fromPos or char.WorldPos
    Osi.CharacterStatusText(charGUID, TSK.Notification_Minigame_Success:GetString())
    Osi.PlayAnimation(charGUID, Fishing.SUCCESS_ANIMATION, "")
    local fishItemGUID = Osi.CreateItemTemplateAtPosition(fish.TemplateID, spawnPos[1], spawnPos[2], spawnPos[3])

    -- Animate the fish coming from the pos into the character
    if fromPos then
        Osi.ItemMoveToPosition(fishItemGUID, char.WorldPos[1], char.WorldPos[2], char.WorldPos[3], 10, 1, "", 0)
        Timer.Start(1, function ()
            Osi.ItemToInventory(fishItemGUID, charGUID, 1, 0, 1)
        end)
    else
        Osi.ItemToInventory(fishItemGUID, charGUID, 1, 0, 1)
    end

    -- Roll for an extra catch
    local extraCatchChance = Fishing.GetExtraCatchChance(char)
    if math.random() <= extraCatchChance then
        Osi.ItemTemplateAddTo(fish.TemplateID, charGUID, 1, 1)
        Osi.CharacterStatusText(char.MyGuid, TSK.Notification_ExtraCatch:Format({
            Color = Fishing.ABILITY_SCHOOL_COLOR,
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
            Color = Fishing.ABILITY_SCHOOL_COLOR,
        }))
    end

    return fishItemGUID
end

---Marks a fish type as having been caught in this playthrough.
---@param fishID Fishing.FishID
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
---@see Fishing.ANIMATION_EVENT
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

    -- Update remaining fish
    -- Note: if multiple players start fishing at the same time before the amount resyncs,
    -- it's technically possible to underflow the amount,
    -- but the timing window for this is so small it's not worth covering;
    -- consider it a secret technique.
    local depletionReductionChance = Fishing.GetFishDepletionReductionChance(ev.Character)
    if math.random() >= depletionReductionChance then
        local remainingFish = Fishing.GetRemainingFish(ev.Region.ID)
        Fishing.SetRemainingFish(ev.Region.ID, remainingFish - 1)
    end
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
        Fishing.CatchFish(char, caughtFish, state.TargetPosition)
        Osi.PlayScaledEffectAtPosition(Fishing.FISH_SPLASH_EFFECT, 1.5, table.unpack(state.TargetPosition + Fishing.TARGET_POS_EFFECT_OFFSET))

        -- Catch treasure chest
        if caughtChest then
            local treasureTable = caughtChest.TreasureTable
            local chestGUID = Osi.CreateItemTemplateAtPosition(caughtChest.Template, table.unpack(state.TargetPosition))
            Osi.GenerateTreasure(chestGUID, treasureTable, char.Stats.Level, char.MyGuid)

            -- Tween it from the water to near the character
            local charPos = char.WorldPos
            local x, y, z = Osi.FindValidPosition(charPos[1], charPos[2], charPos[3], 4, chestGUID)
            if not x then
                x, y, z = charPos[1], charPos[2], charPos[3]
            end
            Osi.ItemMoveToPosition(chestGUID, x, y, z, 10, 1, "", 0)
        end
    elseif ev.Reason == "Failure" then
        Osiris.PlayAnimation(char, Fishing.FAILURE_ANIMATION, "")
    end

    -- Show feedback for the fish in the region being exhausted
    if Fishing.GetRemainingFish(state.RegionID) <= 0 then
        local charGUID = char.MyGuid
        Timer.Start(1, function (_)
            Osi.CharacterStatusText(charGUID, TSK.Notification_Minigame_Depleted:GetString())
            Osi.CharacterStatusText(charGUID, TSK.Notification_Minigame_Depleted_2:GetString()) -- Shown as a separate line, as otherwise it would not be centered.
        end)
    end
end)

-- Listen for clients starting to fish and forward the event.
Net.RegisterListener(Fishing.NETMSG_STARTED_FISHING, function (payload)
    local region = Fishing.GetRegion(payload.RegionID)
    local char = payload:GetCharacter()
    Fishing._CharacterStates[char.Handle] = {
        TargetPosition = V(payload.TargetPosition),
        RegionID = region.ID,
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

-- Initialize remaining fish in all regions & refresh cooldowns when the game starts.
GameState.Events.RegionStarted:Subscribe(function (ev)
    local remainingFishMap = Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_FISHES_REMAINING)
    local cooldownMap = Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_REGION_RESPAWN_COOLDOWN)
    for _,region in ipairs(Fishing.GetRegions(ev.LevelID)) do
        local regionID = region.ID
        if remainingFishMap[regionID] == nil then
            Fishing.RespawnFishes(regionID)
        end
        if cooldownMap[regionID] == nil then
            Fishing.SetRegionRespawnCooldown(regionID, Fishing.GetBaseRespawnCooldown(regionID))
        end
    end
end)

-- Mark characters at the start of the game as having the Fishermancy preset if they chose it during CC.
-- TODO this is an Origins-specific PROC, find a more general one
Osiris.RegisterSymbolListener("PROC_TUT_LoseWeapons_LostWeapon", 3, "after", function (charGUID, _, itemGUID)
    local item = Item.Get(itemGUID)
    if Fishing.IsFishingRod(item) then
        -- Mark the character as having the preset
        Osi.SetTag(charGUID, "PIP_Fishing_Fishermancer")

        -- Ensure the char has all the skills granted by the preset;
        -- this is necessary to workaround a bug where skills that are in the preset AND granted by starting equipment are not added to the character themselves (ex. Reel In in this case)
        local skills = Ext.Stats.SkillSet.GetLegacy(Fishing.FISHERMANCER_SKILLSET).Skills
        for _,skill in ipairs(skills) do
            Osi.CharacterAddSkill(charGUID, skill, 0)
        end
    end
end)

-- Refresh available fish in regions as time passes.
Osiris.RegisterSymbolListener("NewHour", 1, "after", function (_)
    Fishing.TickRespawnCooldowns()
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

-- Cheat to add a specific fish.
Ext.RegisterConsoleCommand("fishadd", function (_, id)
    local charGUID = Osi.CharacterGetHostCharacter()
    local fish = Fishing.GetFish(id)
    if fish then
        Fishing.CatchFish(Character.Get(charGUID), fish)
    end
end)

-- Cheat to add all fishes of a rarity.
Ext.RegisterConsoleCommand("fishaddrarity", function (_, rarity)
    local charGUID = Osi.CharacterGetHostCharacter()
    for _,fish in pairs(Fishing.GetFishes()) do
        if fish.Rarity == rarity then
            Fishing.CatchFish(Character.Get(charGUID), fish)
        end
    end
end)

-- Cheat to add all fish runes of all tiers.
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

-- Cheats to manipulate remaining fish in regions.
Ext.RegisterConsoleCommand("fishrefreshregions", function (_)
    for _,region in ipairs(Fishing.GetRegions(Entity.GetLevel().LevelDesc.LevelName)) do
        Fishing.RespawnFishes(region.ID)
    end
end)
Ext.RegisterConsoleCommand("fishdepleteregions", function (_)
    for _,region in ipairs(Fishing.GetRegions(Entity.GetLevel().LevelDesc.LevelName)) do
        Fishing.SetRemainingFish(region.ID, 0)
    end
end)
