
---@class Fishing.Trader : Feature
local Trader = {
    TRADER_ROOTTEMPLATE = "a093021b-46fc-4b6d-87dc-21ea6fa535b7",
    DIALOG_FLAGS = {
        OPEN_CODEX = "PIP_AskedAboutCollectionLog",
        SPOKEN_TO = "PIP_WasSpokenToEver",
        REGION_PREFIX = "PIP_Fishing_Map_", -- Meant to be suffixed with the level ID.
        SPOKEN_IN_PREFIX = "PIP_Fishing_SpokenIn_", -- Meant to be suffixed with the level ID.
        COLLECTION_LOG_PROGRESS_PREFIX = "PIP_Fishing_CollectionLog_", -- Meant to be suffixed with the completion percentage, in increments of 10%.
    },
    DIALOG_ID = "PIP_Pip_FortJoy",
    NETMSG_OPEN_CODEX = "Fishing.NetMsgs.Trader.OpenCodex",
}
RegisterFeature("Fishing.Trader", Trader)
