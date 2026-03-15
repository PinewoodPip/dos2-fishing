
---@class Features.Fishing.Trader : Feature
local Trader = {
    TRADER_ROOTTEMPLATE = "a093021b-46fc-4b6d-87dc-21ea6fa535b7",
    DIALOG_FLAGS = {
        OPEN_CODEX = "PIP_AskedAboutCollectionLog",
        COLLECTION_LOG_PROGRESS_PREFIX = "PIP_Fishing_CollectionLog_", -- Meant to be suffixed with the completion percentage, in increments of 10%.
    },
    DIALOG_ID = "PIP_Pip_FortJoy",
    NETMSG_OPEN_CODEX = "Fishing.NetMsgs.Trader.OpenCodex",
}
Epip.RegisterFeature("Fishing", "Features.Fishing.Trader", Trader)
