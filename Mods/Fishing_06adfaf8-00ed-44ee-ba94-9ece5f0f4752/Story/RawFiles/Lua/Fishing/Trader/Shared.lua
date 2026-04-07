
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
    BARK_COOLDOWN = 4, -- In seconds.

    TranslatedStrings = {
        Bark_Attacked_1 = {
            Handle = "ha48234b9g217dg4416g81a4g927dea53ea1c",
            Text = "There's no need for that.",
            ContextDescription = [[Bark when the trader is attacked]],
        },
        Bark_Attacked_2 = {
            Handle = "h6c6abe11g608cg449cg88f0g3b08fa3345b1",
            Text = "Calm down.",
            ContextDescription = [[Bark when the trader is attacked]],
        },
        Bark_Attacked_3 = {
            Handle = "h761e5dabgf535g4151gb4f1ge0c7b2c63537",
            Text = "Some day your actions will have consequences.",
            ContextDescription = [[Bark when the trader is attacked]],
        },
        Bark_Attacked_4 = {
            Handle = "h4e2c324agd704g49b3g8f5agfb89ff8fecaf",
            Text = "Stop tickling me!",
            ContextDescription = [[Bark when the trader is attacked]],
        },
        Bark_Attacked_5 = {
            Handle = "h813149afgf249g4708g862bg4725641abda5",
            Text = "Ahh~!",
            ContextDescription = [[Bark when the trader is attacked]],
        },
    },
}
RegisterFeature("Fishing.Trader", Trader)
local TSK = Trader.TranslatedStrings

-- Barks to play when the trader is attacked.
---@type TextLib_TranslatedString[]
Trader.ATTACKED_BARKS = {
    TSK.Bark_Attacked_1,
    TSK.Bark_Attacked_2,
    TSK.Bark_Attacked_3,
    TSK.Bark_Attacked_4,
    TSK.Bark_Attacked_5,
}
