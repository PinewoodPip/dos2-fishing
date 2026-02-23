
---@class Features.Fishing
local Fishing = Epip.GetFeature("Features.Fishing")
local TSK = Fishing.TranslatedStrings

Fishing.MINIGAME_ANIMATION = "skill_prepare_weapon_01_loop"
Fishing.ANIMATION_EVENT = "EPIP_FISHING_LOOP"
Fishing.SUCCESS_ANIMATION = "use_loot"
Fishing.FAILURE_ANIMATION = "emotion_sad"

---------------------------------------------
-- METHODS
---------------------------------------------

---@param char EsvCharacter
function Fishing.PlayAnimation(char)
    Osiris.PlayAnimation(char, Fishing.MINIGAME_ANIMATION, Fishing.ANIMATION_EVENT)
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
    Osi.ItemDestroy(dummyItemGUID)

    Fishing.PlayAnimation(char) -- Should be done after facing the target, as characters cannot turn during an animation.
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

-- Untag characters when they finish fishing.
Fishing.Events.CharacterStoppedFishing:Subscribe(function (ev)
    local char = ev.Character

    -- Stop previous animation
    Osiris.CharacterFlushQueue(char)

    Fishing._CharactersFishing:Remove(char.Handle)

    -- Success/failure feedback
    if ev.Reason == "Success" then
        Osiris.CharacterStatusText(char, TSK.Notification_Minigame_Success:GetString())
        Osiris.PlayAnimation(char, Fishing.SUCCESS_ANIMATION, "")
        Osiris.ItemTemplateAddTo(ev.CaughtFish.TemplateID, char, 1, 1)
    elseif ev.Reason == "Failure" then
        Osiris.PlayAnimation(char, Fishing.FAILURE_ANIMATION, "")
    end
end)

-- Listen for clients starting to fish and forward the event.
Net.RegisterListener(Fishing.NETMSG_STARTED_FISHING, function (payload)
    local region = Fishing.GetRegion(payload.RegionID)
    Fishing.Events.CharacterStartedFishing:Throw({
        Character = payload:GetCharacter(),
        Region = region,
        TargetPosition = payload.TargetPosition,
    })
end)

-- Listen for clients exiting the minigame and forward the event.
Net.RegisterListener(Fishing.NETMSG_STOPPED_FISHING, function (payload)
    Fishing.Events.CharacterStoppedFishing:Throw({
        Character = payload:GetCharacter(),
        Reason = payload.Reason,
        CaughtFish = Fishing.GetFish(payload.CaughtFishID),
    })
end)

-- Cheat to add all fish items.
Ext.RegisterConsoleCommand("fishaddall", function (_)
    local charGUID = Osi.CharacterGetHostCharacter()
    for _,fish in pairs(Fishing._Fish) do
        Osiris.ItemTemplateAddTo(fish.TemplateID, charGUID, 1, 0)
    end
end)
