
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
    end
end)

-- Update collection log completion flags starting the dialogue.
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
