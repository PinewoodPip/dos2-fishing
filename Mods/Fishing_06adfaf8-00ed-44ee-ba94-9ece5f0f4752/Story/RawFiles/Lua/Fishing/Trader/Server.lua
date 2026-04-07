
local Fishing = GetFeature("Fishing")

---@class Fishing.Trader
local Trader = GetFeature("Fishing.Trader")

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Request clients to open their codex when mentioned in dialogue.
Osiris.RegisterSymbolListener("ObjectFlagSet", 3, "after", function (flag, speakerGUID, _)
    if flag == Trader.DIALOG_FLAGS.OPEN_CODEX then
        local char = Character.Get(speakerGUID)
        Net.PostToCharacter(char, Trader.NETMSG_OPEN_CODEX)
    elseif flag == Trader.DIALOG_FLAGS.SPOKEN_TO then
    end
end)

-- Update map-specific flags when starting the dialogue.
Osiris.RegisterSymbolListener("DialogStarted", 2, "after", function (dialogID, instance)
    if dialogID == Trader.DIALOG_ID then
        local charGUID = Osi.DialogGetInvolvedPlayer(instance, 1)
        local levelID = Entity.GetLevel().LevelDesc.LevelName

        -- If speaking to the trader for the first time, set the level-specific spoken flag to avoid that dialogue from playing next time;
        -- would be awkward otherwise, as they're written as though it's your first time meeting him there
        if Osi.ObjectGetFlag(charGUID, Trader.DIALOG_FLAGS.SPOKEN_TO) == 0 then
            Osi.ObjectSetFlag(charGUID, Trader.DIALOG_FLAGS.SPOKEN_IN_PREFIX .. levelID)
        end
        -- Clear any previous level flags
        for _,otherLevelID in pairs(Entity.LEVEL_IDS.ORIGINS) do
            Osi.GlobalClearFlag(Trader.DIALOG_FLAGS.REGION_PREFIX .. otherLevelID)
        end

        -- Set flag for current level
        Osi.GlobalSetFlag(Trader.DIALOG_FLAGS.REGION_PREFIX .. levelID)
    end
end)

-- Update collection log completion flags when starting the dialogue.
Osiris.RegisterSymbolListener("DialogStarted", 2, "after", function (dialogID, instance)
    if dialogID == Trader.DIALOG_ID then
        local charGUID = Osi.DialogGetInvolvedPlayer(instance, 1)
        local _, uniqueFishCaught = Fishing.GetUniqueFishCaught()
        local totalFish = table.getKeyCount(Fishing.GetFishes())
        local completion = uniqueFishCaught / totalFish * 100
        completion = completion // 10 * 10 -- Round down to nearest multiple of 10
        local flag = Trader.DIALOG_FLAGS.COLLECTION_LOG_PROGRESS_PREFIX .. Text.RemoveTrailingZeros(completion)
        Osi.PartySetFlag(charGUID, flag, instance)
    end
end)

-- Heal the trader and play barks when they are attacked by players.
local lastBarkTime = 0
Osiris.RegisterSymbolListener("PROC_PIP_Fishing_TraderAttacked", 2, "after", function (charGUID, _)
    -- Apply a fancy heal on hit.
    -- Not strictly necessary since the trader is immortal,
    -- but it helps to suggest the player to not waste their time trying to kill them.
    local x, y, z = Osi.GetPosition(charGUID)
    Osi.CreateExplosionAtPosition(x, y, z, "Projectile_Grenade_BlessedIce", Osi.CharacterGetLevel(charGUID)) -- Note: CreateExplosion() (the GUID variant) is broken, does not work.

    -- Play bark, with a cooldown
    local now = Ext.Utils.MonotonicTime()
    if now - lastBarkTime < Trader.BARK_COOLDOWN * 1000 then return end
    local bark = Trader.ATTACKED_BARKS[math.random(1, #Trader.ATTACKED_BARKS)]
    Osi.DisplayText(charGUID, bark:GetString())
    lastBarkTime = now
end)
