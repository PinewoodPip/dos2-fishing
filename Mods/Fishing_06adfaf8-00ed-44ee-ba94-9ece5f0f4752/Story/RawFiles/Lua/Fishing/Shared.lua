
local DefaultTable = DataStructures.Get("DataStructures_DefaultTable")
local Set = DataStructures.Get("DataStructures_Set")
local V = Vector.Create

---@class Fishing : Feature
local Fishing = {
    _Fish = {}, ---@type table<Fishing.FishID, Fishing.Fish>
    _FishBehaviours = {}, ---@type table<Fishing.Fish.BehaviourType, Fishing.Fish.Behaviour>
    _RegionsByLevel = DefaultTable.Create({}), ---@type DataStructures_DefaultTable<string, Fishing.Region[]>
    _FishesByLevel = DefaultTable.Create({}), ---@type table<string, set<Fishing.FishID>> Maps level ID to fish IDs that can be found in that level.
    _FishToRegions = DefaultTable.Create({}), ---@type table<Fishing.FishID, set<Fishing.RegionID>> Maps fish ID to regions where it can be found.
    _RootTemplateToFish = {}, ---@type table<GUID.ItemTemplate, Fishing.FishID>
    _RegionsByID = {}, ---@type table<Fishing.RegionID, Fishing.Region>
    _CharactersFishing = Set.Create(), -- Not synchronized across clients!

    DEFAULT_REGION_REFRESH_COOLDOWN = 3, -- In in-game hours (1 hour = 5 minutes real time).
    DEFAULT_FISH_PER_REGION = {7, 10}, -- Range of amount of fish that can be found in a region during a spawn cycle.

    NETMSG_STARTED_FISHING = "Fishing.NetMsgs.CharacterStartedFishing",
    NETMSG_STOPPED_FISHING = "Fishing.NetMsgs.CharacterStoppedFishing",
    NETMSG_ENCOUNTERED_FISH = "Fishing.NetMsgs.CharacterEncounteredFish",
    NETMSG_FOUND_TREASURE_CHEST = "Fishing.NetMsgs.CharacterFoundTreasureChest",

    MODVAR_UNIQUE_FISH_CAUGHT = "PlaythroughUniqueFishCaught",
    MODVAR_REGIONS_DISCOVERED = "RegionsDiscovered",
    MODVAR_FISHES_ENCOUNTERED = "PlaythroughFishesEncountered",
    MODVAR_FISHES_REMAINING = "RegionFishRemaining",
    MODVAR_REGION_RESPAWN_COOLDOWN = "RegionRefreshCooldown",
    USERVAR_FISH_CAUGHT = "CharacterFishCaught",

    FISHING_ROD_TEMPLATES = Set.Create({
        "81cbf17f-cc71-4e09-9ab3-ca2a5cb0cefc", -- HAR_FishingRod_A, green fish-shaped lure
        "90cdb693-3564-415a-a8fa-4027b7f76f41", -- HAR_FishingRod_B, classic red/white bobber
        "9fc3cb5f-894e-4783-9eef-fbceef0104b0", -- HAR_FishingRod_C, red/yellow lure
    }),
    ---@type set<GUID>
    FISHING_ROD_VISUAL_TEMPLATES = {
        ["c7639619-4c44-44a3-af53-81275a80af15"] = true, -- Green bobber.
        ["483ecb63-b01a-4452-be65-904d9ff03554"] = true, -- Red/white bobber.
        ["5a14df6e-8e63-425c-9802-1916d630212e"] = true, -- Yellow bobber.
    },
    ---@type table<GUID, Fishing.BobberColor>
    VISUAL_TEMPLATE_TO_BOBBER_COLOR = {
        ["c7639619-4c44-44a3-af53-81275a80af15"] = {
            NormalColor = Color.CreateFromHex(Color.LARIAN.POISON_GREEN),
            HighlightColor = Color.CreateFromHex(Color.LARIAN.GREEN),
        },
        ["483ecb63-b01a-4452-be65-904d9ff03554"] = {
            NormalColor = Color.CreateFromHex("BFBFBF"),
            HighlightColor = Color.CreateFromHex("D8D8D8"),
        },
        ["5a14df6e-8e63-425c-9802-1916d630212e"] = {
            NormalColor = Color.CreateFromHex(Color.LARIAN.GOLD),
            HighlightColor = Color.CreateFromHex(Color.LARIAN.YELLOW),
        },
    },
    WATER_SEARCH_RADIUS = 2.5,
    CURSOR_WATER_SEARCH_RADIUS = 0.5,
    WATER_MAX_DISTANCE = 7.5, -- Distance to water (or fishing areas) that a character must be within for fishing to be available.

    TUNING = {
        BASE_CASTING_RANGE = 7.5,
        BASE_FISH_BITE_DELAY_RANGE = {3.2, 6.5},
        BASE_STARTING_PROGRESS = 0.4, -- As fraction of required progress.
        STARTING_PROGRESS_PER_LEADERSHIP = 0.01,
        BASE_PROGRESS_DRAIN = 0.1,

        BASE_BOBBER_SIZE = 37,
        MAX_BOBBER_SIZE = 80, -- Size at max Fishermancy level.

        CASTING_RANGE_PER_TELEKINESIS = 0.2,
        BITE_DELAY_REDUCTION_PER_PERSUASION = 0.05,
        EXTRA_CATCH_CHANCE_PER_BARTERING = 0.04,
        PROGRESS_DRAIN_REDUCTION_PER_PERSEVERANCE = 0.015,
        PROGRESS_DRAIN_REDUCTION_PER_THIEVERY = 0.04,

        TREASURE_CHEST_SPAWN_DELAY_RANGE = {3.0, 5.0}, -- Time delay range before a chest spawns, in seconds.
        TREASURE_CHEST_BASE_SPAWN_CHANCE = 0.01,
        TREASURE_CHEST_CHANCE_PER_ABILITY = 0.03,
    },

    ABILITY_SCHOOL_COLOR = "86a4f7", ---@type htmlcolor
    ABILITY_SCHOOL_FISH_PER_LEVEL = 15, -- Amount of fish that has to be caught per level in the Fishermancy ability.
    ABILITY_SCHOOL_FISH_PER_LEVEL_GROWTH = 5, -- Extra amount of fish that need to be caught per level in the Fishermancy ability, for each level after the first.
    ABILITY_SCHOOL_UNIQUE_FISH_PER_LEVEL = 5, -- Amount of unique fish that has to be caught per level in the Fishermancy ability.

    TARGET_POS_EFFECT_OFFSET = V(0, 1, 0),

    USE_LEGACY_EVENTS = false,
    USE_LEGACY_HOOKS = false,

    Settings = {},

    TranslatedStrings = {
        Label_FishingRod = {
            Handle = "hf0dada5eg975cg45fcg8c70g6e67792c8430",
            Text = "Fishing Rod",
            ContextDescription = [[Tooltip footer for fishing rod items]],
        },
        Label_FishingRodHint = {
            Handle = "h8e225a0bg8481g4c06gaefag7ff1abbe00fb",
            Text = "To fish, equip a rod, unsheathe it and left-click a body of water while near it.",
            ContextDescription = [[Tooltip for fishing rods]],
        },
        Label_Fish = {
            Handle = "h509d1edagfcc5g4cdcga271g6358aa96bcea",
            Text = "Fish",
        },
        Label_RuneTierPrefix_Tier2 = {
            Handle = "h18b85d49gd618g4ef9gb43egc2413999e187",
            Text = "Greater %s",
            ContextDescription = [[Name for tier 2 fish runes; param is fish name (ex. "Greater Sardine")]],
        },
        Label_RuneTierPrefix_Tier3 = {
            Handle = "h189720b0g8766g43aegac05g52656ff2c260",
            Text = "Descended %s",
            ContextDescription = [[Name for tier 3 fish runes; param is fish name (ex. "Descended Sardine")]],
        },
        Label_Fish_TotalCaught = {
            Handle = "hb9ff816dg02c7g434cg9fe8gc4a76115dfe9",
            Text = "Total Caught: %d",
            ContextDescription = [[Fish tooltip in collection log; param is amount of times the fish was caught]],
        },
        Label_Fish_TotalEncounters = {
            Handle = "hb4657d53g1707g49bbgbfc3g1c240ed5279e",
            Text = "Total Encounters (party-wide): %d",
            ContextDescription = [[Fish tooltip in collection log; param is amount of times the fish was encountered]],
        },
        Label_FishRarity_Common = {
            Handle = "h66cdd0b9g1b6dg413egac30g68b6fcdfe1c4",
            Text = "Common Fish",
            ContextDescription = [[Rarity tooltip for fishes]],
        },
        Label_FishRarity_Uncommon = {
            Handle = "h7d92c127gaccbg45a0g89b0g159d07f1a649",
            Text = "Uncommon Fish",
            ContextDescription = [[Rarity tooltip for fishes]],
        },
        Label_FishRarity_Rare = {
            Handle = "h7581c7d0g0566g4a38g9703ge2d5694a662a",
            Text = "Rare Fish",
            ContextDescription = [[Rarity tooltip for fishes]],
        },
        Label_FishRarity_Epic = {
            Handle = "h89de4a73gc4a2g4f00g9ddag7b5c921ba49d",
            Text = "Epic Fish",
            ContextDescription = [[Rarity tooltip for fishes]],
        },
        Label_FishRarity_Legendary = {
            Handle = "h6aac4362ge637g4d42g953cgcd87f2de7224",
            Text = "Legendary Fish",
            ContextDescription = [[Rarity tooltip for fishes]],
        },
        Level_TheHold = {
            Handle = "h91a4e65bg2030g4a9eg82b8g5f165c27e92b",
            Text = "The Merryweather",
            ContextDescription = [[Map name; refers to the tutorial ship]],
        },
        Notification_RegionDiscovered = {
            Handle = "h9b68207cg7fb6g4860g89d4g8b04d1bd289f",
            Text = "Fishing spot discovered: %s",
            ContextDescription = [[Notification when fishing in a new region; param is region name]],
        },
        Notification_ExtraCatch = {
            Handle = "hace75aecgf1beg4cbagb718ge9188833511f",
            Text = "Extra Catch!",
            ContextDescription = [[Notification when receiving an extra fish from the Bartering bonus]],
        },
        Notification_Minigame_Success = {
            Handle = "h35cacdc8g0b2ag46f4gb003g3122d32bfecc",
            Text = "Got it!",
            ContextDescription = [[Overhead dialog when winning the minigame]],
        },
        Notification_Minigame_Depleted = {
            Handle = "hdaa64d88ge66eg45e3gbedag84d777e29d81",
            Text = "I can't see any more fish around here...",
            ContextDescription = [[Overhead dialog when exhausting the fish in a region]],
        },
        Notification_Minigame_Depleted_2 = {
            Handle = "hcfff1d4dgef32g4ba7ga52cg6dea0fa8f4d6",
            Text = "I should check back later.",
            ContextDescription = [[Overhead dialog when exhausting the fish in a region]],
        },
        Notification_NoFishNearby = {
            Handle = "hede969bbg1756g4bf7gaefdga9c289918025",
            Text = "There don't seem to be any fish here...",
            ContextDescription = [[Notification when trying to fish in an area with no fish]],
        },
        Notification_Minigame_Failure = {
            Handle = "h75475962gde88g4e98g85a2g80d5e5f86ab5",
            Text = "The fish got away...",
            ContextDescription = [[Notification for losing the minigame]],
        },
        Notification_Minigame_ReeledInTooEarly = {
            Handle = "h37a75c7ag70ceg4f26g84d2g6d74a64dd2f3",
            Text = "Too early! I should wait for the fish to bite first.",
            ContextDescription = [[Notification for failing the 1st phase of the minigame by reeling in before the fish bites]],
        },
        Notification_CantFish_AlreadyFishing = {
            Handle = "h40b6a937gfbf3g471dga223g117d1ed92eb8",
            Text = "I'm already fishing!",
            ContextDescription = [[Notification when trying to fish while already fishing (failsafe)]],
        },
        Notification_CantFish_NotTheTime = {
            Handle = "h9c3f1a1cgcd7fg4224g81deg27edf3b307d0",
            Text = "Now's not the time for fishing!",
            ContextDescription = [[Notification when trying to fish during combat or dialogue]],
        },
        Notification_CantFish_NoWater = {
            Handle = "hb5bdc55ag49edg402ega177g0a6cf897eb0a",
            Text = "I'm not close enough to water to fish.",
            ContextDescription = [[Notification when trying to fish without being near water]],
        },
        Notification_CantFish_TooFar = {
            Handle = "ha875440cgfcb2g4231g8747gca7fe6c661d9",
            Text = "I can't cast my rod that far!",
            ContextDescription = [[Notification when trying to fish too far from the character]],
        },
        Notification_CantFish_RegionDepleted = {
            Handle = "h5b6ec6a2gff7eg447dg8620g98f8320ea368",
            Text = "I can't see any fish left here...<br>I should come back later.",
            ContextDescription = [[Notification when trying to fish in a region that has no more fish available]],
        },
        Notification_CantFish_NoRod = {
            Handle = "h55b1d5a2g90b8g4bbfga67egb3350374edb4",
            Text = "I must have a fishing rod equipped to fish!",
            ContextDescription = [[Notification when trying to fish without a fishing rod equipped]],
        },
        Notification_CantFish_RodSheathed = {
            Handle = "h4dd5393cg95eag4ecag8603g5dffd820d81d",
            Text = "I must unsheathe my fishing rod first.",
            ContextDescription = [[Notification when trying to fish with a sheathed fishing rod]],
        },
        Notification_Biting = {
            Handle = "h282e1f37gda86g46e2gaa58g717d71dc5340",
            Text = "Something's on the hook!",
            ContextDescription = [[Notification when a fish bites, during the 1st phase of the minigame]],
        },
        Notification_TreasureChestSpawned = {
            Handle = "h2b584efbg7353g49c9g9f0bg25c1c3bdd843",
            Text = "Treasure has appeared!",
            ContextDescription = [[Notification when a treasure chest spawns during the minigame]],
        },
        Notification_FishermancyLevelUp = {
            Handle = "h60a4c23ega10dg48f7g9d15g9eba6fe26c03",
            Text = "Fishermancy Level Up!",
            ContextDescription = [[Notification when leveling up the Fishermancy ability school]],
        },

        Label_SchoolName = {
            Handle = "h6361a0cbg34edg430bga50eg461695dacb6d",
            Text = "Fishermancy",
            ContextDescription = [[Ability school name shown in the character sheet]],
        },
        Label_SchoolDescription = {
            Handle = "hf8ea30dbg68a5g437dg9027gebc72244dab8",
            Text = "Each point of Fishermancy unlocks fishy techniques based on your other school scores.",
            ContextDescription = [[Tooltip for Fishermancy ability in character sheet]],
        },
        Label_SchoolDescriptionLevelingHint = {
            Handle = "h3f123bb0g4b8cg464dga18fg29fc44cad36a",
            Text = "Your Fishermancy levels up as you catch more fish.<br>%s",
            ContextDescription = [[Tooltip hint for Fishermancy ability in character sheet; param are the requirements for the next level]],
        },
        Label_SchoolDescription_LevelingRequirement_UniqueCatches = {
            Handle = "h1e113f2fg065eg43eag8925gdb08f67a3404",
            Text = "Next level requires catching %d more unique species.",
            ContextDescription = [[Tooltip for Fishermancy ability; param is amount]],
        },
        Label_SchoolDescription_LevelingRequirement_TotalCatches = {
            Handle = "h40d06bbbg6e40g461ega038g5d2a4a4f61ec",
            Text = "Next level requires catching %d more fish in total.",
            ContextDescription = [[Tooltip for Fishermancy ability; param is amount]],
        },
        Label_SchoolDescription_MaxLevel = {
            Handle = "h8d574642g2dccg4fc3gaa67g4ea7531724ed",
            Text = "You've reached the maximum Fishermancy level.",
            ContextDescription = [[Tooltip for Fishermancy ability]],
        },

        Label_MinigameTutorial = {
            Handle = "hcced1bb7ge818g4803gbf45gf0644370163f",
            Text = "Hold Left-Click to raise the bobber,<br>let go to have it fall.<br><br>Keep the bobber by the fish until the right bar fills up!",
            ContextDescription = "Tutorial message",
        },
        Notification_FishCaught = {
            Handle = "h25bb86bcge5edg4a61g9ebdgce438fa04de1",
            Text = "Fish Caught!",
            ContextDescription = "Toast notification for minigame success",
        },
        Notification_CollectionLogHint = {
            Handle = "h13c51b21g9d2bg4489g9e4bg460b162e8b3c",
            Text = "Press %s to open the collection log.",
            ContextDescription = "Toast notification for minigame success, when catching new types of fish",
        },
        Tooltip_ClickToFish = {
            Handle = "h26c81552g4b40g4f9bg88c5g0380578c6964",
            Text = "Click to cast your rod.",
            ContextDescription = "Mouseover text for fishable areas",
        },
    },

    Events = {
        CharacterStartedFishing = {}, ---@type Event<Fishing.Events.CharacterStartedFishing>
        CharacterStoppedFishing = {}, ---@type Event<Fishing.Events.CharacterStoppedFishing>
        FishDiscovered = {}, ---@type Event<Fishing.Events.FishDiscovered> -- **Server-only.**
    },
    Hooks = {
        IsFishingRod = {}, ---@type Event<Fishing.Hooks.IsFishingRod>
    },
}
RegisterFeature("Fishing", Fishing)
local TSK = Fishing.TranslatedStrings

Fishing:RegisterModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_UNIQUE_FISH_CAUGHT, {
    Persistent = true,
    DefaultValue = {},
})
Fishing:RegisterModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_REGIONS_DISCOVERED, {
    Persistent = true,
    DefaultValue = {},
})
Fishing:RegisterModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_FISHES_ENCOUNTERED, {
    Persistent = true,
    DefaultValue = {},
})
Fishing:RegisterUserVariable(Fishing.USERVAR_FISH_CAUGHT, {
    Persistent = true,
    DefaultValue = {},
})
Fishing:RegisterModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_FISHES_REMAINING, {
    Persistent = false,
    DefaultValue = {},
})
Fishing:RegisterModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_REGION_RESPAWN_COOLDOWN, {
    Persistent = false,
    DefaultValue = {},
})

---@type table<ItemLib_Rarity, TextLib_TranslatedString>
Fishing.RARITY_TO_LABEL = {
    ["Common"] = TSK.Label_FishRarity_Common,
    ["Uncommon"] = TSK.Label_FishRarity_Uncommon,
    ["Rare"] = TSK.Label_FishRarity_Rare,
    ["Epic"] = TSK.Label_FishRarity_Epic,
    ["Legendary"] = TSK.Label_FishRarity_Legendary,
    -- There are currently no divine/unique fish.
}

---Maps fish rune tier to their name prefix TSK.
---@type table<integer, TextLib_TranslatedString?>
Fishing.RUNE_TIER_PREFIXES = {
    [2] = TSK.Label_RuneTierPrefix_Tier2,
    [3] = TSK.Label_RuneTierPrefix_Tier3,
}

-- Maps level IDs to their name TSK handles.
-- We cannot fetch anything but the current level,
-- thus this extra table is necessary.
Fishing.LEVEL_NAME_TSKHANDLES = {
    ["TUT_Tutorial_A"] = TSK.Level_TheHold.Handle, -- Uses a custom TSK as the ingame name is misleading ("The Hold")
    ["FJ_FortJoy_Main"] = "h0d7789e0g8140g4391g8511gc41a2ad8a476", -- "Fort Joy"
    ["LV_HoE_Main"] = "hde585bf1gd58ag49a9g88dagbab9b9b94ab1", -- "The Lady Vengeance"
    ["RC_Main"] = "he5f965fdg9423g4699g87d0g4af1b2e155b6", -- "Reaper's Coast"
    ["CoS_Main"] = "h3a427261gf3cbg489fgb36agf90c6fc1844b", -- "The Nameless Isle"
    ["ARX_Main"] = "hd8971510g1ba0g4b01gad48g6aa3600195e4", -- "Arx"
}

---------------------------------------------
-- EVENTS
---------------------------------------------

---@class Fishing.Hooks.IsFishingRod
---@field Character Character
---@field Item Item
---@field IsFishingRod boolean Hookable. Defaults to false.

---@class Fishing.Events.CharacterStartedFishing
---@field Character Character
---@field Region Fishing.Region
---@field TargetPosition vec3

---@class Fishing.Events.CharacterStoppedFishing
---@field Character Character
---@field Reason Fishing.MinigameExitReason
---@field CaughtFish Fishing.Fish? The fish caught, if any.
---@field CaughtChest Fishing.TreasureChest? The chest caught, if any.

---@class Fishing.Events.FishDiscovered
---@field Fish Fishing.Fish

---------------------------------------------
-- NET MESSAGES
---------------------------------------------

---@class Fishing.NetMsgs.CharacterStartedFishing : NetLib_Message_Character
---@field RegionID Fishing.RegionID
---@field FishID Fishing.FishID
---@field TargetPosition vec3

---@class Fishing.NetMsgs.CharacterStoppedFishing : NetLib_Message_Character
---@field Reason Fishing.MinigameExitReason
---@field CaughtFishID Fishing.FishID? `nil` unless the minigame was won.
---@field CaughtChestID Fishing.TreasureChestID? `nil` unless a treasure chest was caught.

---@class Fishing.NetMsgs.CharacterEncounteredFish : NetLib_Message_Character
---@field FishID Fishing.FishID

---@class Fishing.NetMsgs.CharacterFoundTreasureChest : NetLib_Message_Character
---@field TreasureChestID Fishing.TreasureChestID

---------------------------------------------
-- CLASSES
---------------------------------------------

---@alias Fishing.FishID string
---@alias Fishing.RegionID string
---@alias Fishing.TreasureChestID string
---@alias Fishing.GameHours integer -- In-game hours, where 1 hour = 5 minutes real time.

---@alias Fishing.MinigameExitReason "Success"|"Failure"|"Cancelled"|"ReeledInTooEarly"

---@diagnostic disable-next-line: duplicate-doc-alias
---@alias Fishing.Fish.BehaviourType string

---@class Fishing.BobberColor
---@field NormalColor RGBColor
---@field HighlightColor RGBColor

---@class Fishing.Fish.Behaviour.Transition
---@field TargetState Fishing.GameObject.MovementState.ClassName
---@field Weight number Relative chance for this transition to be picked.

---@class Fishing.Fish.Behaviour
---@field Type Fishing.Fish.BehaviourType
---@field InitialState Fishing.GameObject.MovementState.ClassName
---@field Transitions table<Fishing.GameObject.MovementState.ClassName, Fishing.Fish.Behaviour.Transition[]> Maps current state to possible transitions.

---@class Fishing.TreasureChest
---@field ID Fishing.TreasureChestID?
---@field Template GUID.ItemTemplate
---@field TreasureTable string
---@field SpawnWeight number? Defaults to 1.

---@class Fishing.Fish : I_Identifiable, I_Describable
---@field Icon icon? Override for the fish's icon, used instead of the template's.
---@field UndiscoveredIcon icon?
---@field Rarity ItemLib_Rarity
---@field TemplateID GUID.ItemTemplate GUID for the tier 1 fish rune template. **Mostly for backwards compatibility; see `Templates` field.**
---@field RootTemplates table<integer, GUID.ItemTemplate> Maps fish rune tier to the corresponding template.
---@field Difficulty number Affects the "intensity" of the fish's AI. Higher values are expected to translate to faster movement or shorter intervals between movement states.
---@field Endurance number Multiplier for how much progress the player needs to accumulate to catch the fish.
---@field Behaviour Fishing.Fish.BehaviourType
local _Fish = {
    Difficulty = 1,
    Endurance = 1,
}

---@return string
function _Fish:GetIcon()
    local itemTemplate = Ext.Template.GetTemplate(self.TemplateID) ---@type ItemTemplate
    return self.Icon or itemTemplate.Icon
end

---Returns the fish's tooltip, with catch statistics.
---@return TooltipLib_FormattedTooltip
function _Fish:GetTooltip()
    local char = Client.GetCharacter()
    local timesCaught = Fishing.GetFishCatchCount(char, self.ID)
    local timesEncountered = Fishing.GetTotalFishEncounters()[self.ID] or 0

    ---@type TooltipLib_FormattedTooltip
    local tooltip = {
        Elements = {
            self:GetNameTooltip(),
            -- Note: multiple SkillDescriptions are ordered inversely in flash
            {
                Type = "SkillDescription",
                Label = Text.Format("%s<br>%s", {
                    FormatArgs = {
                        TSK.Label_Fish_TotalCaught:Format(timesCaught),
                        TSK.Label_Fish_TotalEncounters:Format(timesEncountered),
                    },
                })
            },
            {
                Type = "SkillDescription",
                Label = self:GetDescription(),
                _IsDescription = true, -- Flag for other scripts to be able to distinguish the description element easily.
            },
            self:GetRarityTooltip(),
        }
    }
    return tooltip
end

---Returns the ItemName tooltip element for the fish.
---@param runeTier integer? Defaults to 1.
---@return TooltipLib_Element
function _Fish:GetNameTooltip(runeTier)
    local tierPrefix = Fishing.RUNE_TIER_PREFIXES[runeTier]
    local name = self:GetName()
    if tierPrefix then
        name = tierPrefix:Format(name)
    end
    local rarityColor = self:GetRarityColor()
    return {
        Type = "ItemName",
        Label = Text.Format(name, {Color = rarityColor}),
    }
end

---Returns the ItemRarity tooltip element for the fish.
---@return TooltipLib_Element
function _Fish:GetRarityTooltip()
    local rarityString = Fishing.RARITY_TO_LABEL[self.Rarity] or TSK.Label_Fish
    local rarityColor = self:GetRarityColor()
    return {
        Type = "ItemRarity",
        Label = rarityString:Format({Color = rarityColor}),
    }
end

---Returns the fish's rarity color.
---@return htmlcolor
function _Fish:GetRarityColor()
    return Color.ITEM_RARITIES[self.Rarity] or Color.WHITE
end

---@class Fishing.Region : I_Identifiable
---@field LevelID string
---@field NameHandle TranslatedStringHandle
---@field Bounds Vector4 X, Y, width, height bounds of the area where fishing will be possible when near deepwater surfaces.
---@field Fish Fishing.Region.FishEntry[]
---@field Priority integer? Defaults to 0.
---@field FishingAreas Vector4[]? Bounds of areas where fishing is possible even without deepwater surfaces.
---@field FishableSurfaceType SurfaceType? Override for the surface type that is considered fishable by default within the region.
---@field IsSecret boolean? If set, the region won't be displayed in the collection log. Defaults to `false`.
local _Region = {
    Priority = 0,
}

---@class Fishing.Region.FishEntry
---@field ID Fishing.FishID ID of the fish.
---@field Weight number Relative chance for the fish to be picked.

---------------------------------------------
-- METHODS
---------------------------------------------

---@param data Fishing.Fish
function Fishing.RegisterFish(data)
    if not data.ID then Fishing:__Error("RegisterFish", "Data must include ID.") end
    Inherit(data, _Fish)
    Interfaces.Apply(data, "I_Identifiable")
    Interfaces.Apply(data, "I_Describable")

    Fishing._Fish[data.ID] = data
    Fishing._RootTemplateToFish[data.TemplateID] = data.ID
    for _,templateID in pairs(data.RootTemplates) do
        Fishing._RootTemplateToFish[templateID] = data.ID
    end
end

---Registers a fishing region.
---@param data Fishing.Region
function Fishing.RegisterRegion(data)
    if not data.ID then Fishing:__Error("RegisterRegion", "Data must include ID.") end
    if #data.Fish == 0 then Fishing:__Error("RegisterRegion", "Regions must have at least one fish entry.") end
    Inherit(data, _Region)
    Interfaces.Apply(data, "I_Identifiable")

    table.insert(Fishing._RegionsByLevel[data.LevelID], data)
    Fishing._RegionsByID[data.ID] = data

    -- Validate fish IDs and cache their regions
    for _,fishEntry in ipairs(data.Fish) do
        if not Fishing.GetFish(fishEntry.ID) then
            Fishing:__Error("RegisterRegion", "Unknown fish ID:", fishEntry.ID)
        end
        Fishing._FishesByLevel[data.LevelID][fishEntry.ID] = true
        Fishing._FishToRegions[fishEntry.ID][data.ID] = true
    end
end

---Returns whether a fish can be caught in the given level.
---@param fishID Fishing.FishID
---@param levelID string
---@return boolean
function Fishing.IsFishAvailable(fishID, levelID)
    return Fishing._FishesByLevel[levelID][fishID]
end

---Returns the regions that a fish can be caught in.
---@param fishID Fishing.FishID
---@return table<Fishing.RegionID, Fishing.Region>
function Fishing.GetFishRegions(fishID)
    local regionIDs = Fishing._FishToRegions[fishID]
    local regions = {} ---@type table<Fishing.RegionID, Fishing.Region>
    for regionID,_ in pairs(regionIDs) do
        regions[regionID] = Fishing.GetRegion(regionID)
    end
    return regions
end

---Registers a fish behaviour.
---@param behaviour Fishing.Fish.Behaviour
function Fishing.RegisterFishBehaviour(behaviour)
    if not behaviour.Type then Fishing:__Error("RegisterFishBehaviour", "Missing Type field") end
    Fishing._FishBehaviours[behaviour.Type] = behaviour
end

---Returns a fish behaviour by ID.
---@param type Fishing.Fish.BehaviourType
---@return Fishing.Fish.Behaviour
function Fishing.GetBehaviour(type)
    return Fishing._FishBehaviours[type]
end

---Returns the regions in the level.
---@param levelID string? Defaults to current level.
---@return Fishing.Region[]
function Fishing.GetRegions(levelID)
    levelID = levelID or Entity.GetLevel().LevelDesc.LevelName
    return Fishing._RegionsByLevel[levelID]
end

---@param id Fishing.RegionID
---@return Fishing.Region?
function Fishing.GetRegion(id)
    return Fishing._RegionsByID[id]
end

---Returns the name of a region.
---@param region Fishing.Region
---@param appendLevel boolean? Whether to suffix the name with the level name. Defaults to `false`.
---@return string
function Fishing.GetRegionName(region, appendLevel)
    local name = Text.GetTranslatedString(region.NameHandle)
    if appendLevel then
        local levelName = Fishing.GetLevelName(region.LevelID)
        name = string.format("%s (%s)", name, levelName)
    end
    return name
end

---Returns the maximum rod casting distance for char.
---@param char Character
---@return number -- In meters.
function Fishing.GetCastingRange(char)
    local telekinesis = char.Stats.Telekinesis
    local growth = Fishing.TUNING.CASTING_RANGE_PER_TELEKINESIS * telekinesis
    return Fishing.TUNING.BASE_CASTING_RANGE * (1 + growth)
end

---Returns the bite delay range for char.
---@param char Character
---@return number, number -- Min range, max range, in seconds.
function Fishing.GetBiteDelayRange(char)
    local minDelay, maxDelay = table.unpack(Fishing.TUNING.BASE_FISH_BITE_DELAY_RANGE)
    local persuasion = char.Stats.Persuasion
    local reduction = Fishing.TUNING.BITE_DELAY_REDUCTION_PER_PERSUASION * persuasion
    local multiplier = math.max(0, 1 - reduction)
    return minDelay * multiplier, maxDelay * multiplier
end

---Returns the chance for char to receive an extra copy of the caught fish on successful catches.
---@param char Character
---@return number
function Fishing.GetExtraCatchChance(char)
    local bartering = char.Stats.Barter
    local chance = Fishing.TUNING.EXTRA_CATCH_CHANCE_PER_BARTERING * bartering
    return chance
end

---Returns progress drain per second for char.
---@param char Character?
---@return number
function Fishing.GetProgressDrain(char)
    local perseverance = char.Stats.Perseverance
    local reduction = Fishing.TUNING.PROGRESS_DRAIN_REDUCTION_PER_PERSEVERANCE * perseverance
    local multiplier = math.max(0, 1 - reduction)
    return Fishing.TUNING.BASE_PROGRESS_DRAIN * multiplier
end

---Returns the progress drain multiplier applied while the bobber is colliding with a treasure chest, based on char's Thievery.
---@param char Character
---@return number
function Fishing.GetTreasureChestProgressDrainMultiplier(char)
    local thievery = char.Stats.Thievery
    local reduction = Fishing.TUNING.PROGRESS_DRAIN_REDUCTION_PER_THIEVERY * thievery
    return math.max(0, 1 - reduction)
end

---Returns the starting fish capture progress for char.
---@param char Character?
---@return number -- Normalized.
function Fishing.GetStartingProgress(char)
    local leadership = char.Stats.Leadership
    local bonus = Fishing.TUNING.STARTING_PROGRESS_PER_LEADERSHIP * leadership
    return Fishing.TUNING.BASE_STARTING_PROGRESS + bonus
end

---Returns char's bobber collider size.
---@param char Character
---@return number
function Fishing.GetBobberSize(char)
    local fishermancy = Fishing.GetMaxAbilityScore() or Fishing.GetAbilityScore(char)
    local maxFishermancy = Fishing.GetMaxAbilityScore()
    local sizeBonus = (Fishing.TUNING.MAX_BOBBER_SIZE - Fishing.TUNING.BASE_BOBBER_SIZE) * (fishermancy / maxFishermancy)
    return Fishing.TUNING.BASE_BOBBER_SIZE + sizeBonus
end

---Returns the chance for a treasure chest to spawn in the minigame.
---@param char Character
---@return number
function Fishing.GetTreasureChestChance(char)
    local abilityScore = Mod.IsLoaded(Mod.GUIDS.EE_DERPY) and char.Stats.Thievery or char.Stats.Luck -- Lucky Charm is removed in Derpy, thus we need to shift the effect to a different ability.
    local luck = math.max(0, abilityScore or 0)
    local chance = Fishing.TUNING.TREASURE_CHEST_BASE_SPAWN_CHANCE + luck * Fishing.TUNING.TREASURE_CHEST_CHANCE_PER_ABILITY
    return chance
end

---Returns the name of a level.
---@param levelID string
---@return string
function Fishing.GetLevelName(levelID)
    return Text.GetTranslatedString(Fishing.LEVEL_NAME_TSKHANDLES[levelID] or "h0d1e4595g92d0g434fgae36g0b83733e268b") -- "Unknown" is fallback.
end

---@param char Character
---@return boolean
function Fishing.IsFishing(char)
    return Fishing._CharactersFishing:Contains(char.Handle)
end

---Returns the amount of each fish that char has caught.
---@overload fun(char: Character, fishID: Fishing.FishID): integer
---@param char Character
---@return table<Fishing.FishID, integer> -- Maps fish ID to catch count.
function Fishing.GetFishCatchCount(char, fishID)
    local fishCounts = Fishing:GetUserVariable(char, Fishing.USERVAR_FISH_CAUGHT) or {}
    if fishID then -- ID overload.
        return fishCounts[fishID] or 0
    else
        return fishCounts
    end
end

---Returns the total amount of fishes that char has caught.
---@param char Character
---@return integer
function Fishing.GetTotalFishCaught(char)
    local fishCounts = Fishing.GetFishCatchCount(char)
    local total = 0
    for _,count in pairs(fishCounts) do
        total = total + count
    end
    return total
end

---Returns the total amount of times each fish has been encountered.
---@return table<Fishing.FishID, integer?> -- Maps fish ID to times encountered (`nil` if unencountered).
function Fishing.GetTotalFishEncounters()
    return Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_FISHES_ENCOUNTERED) or {}
end

---Increments the amount of fish caught by char.
---@param char Character
---@param fishID Fishing.FishID
---@param count integer? Defaults to 1.
function Fishing.AddFishCatchCount(char, fishID, count)
    count = count or 1
    local currentCount = Fishing.GetFishCatchCount(char)
    local fishCounts = currentCount or {}
    fishCounts[fishID] = (fishCounts[fishID] or 0) + count
    Fishing:SetUserVariable(char, Fishing.USERVAR_FISH_CAUGHT, fishCounts)
end

---Increments the encounter counter for a fish.
---@param fishID Fishing.FishID
function Fishing.AddFishEncounter(fishID)
    local encounters = Fishing.GetTotalFishEncounters()
    encounters[fishID] = (encounters[fishID] or 0) + 1
    Fishing:SetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_FISHES_ENCOUNTERED, encounters)
end

---Returns the fish types that were caught in this playthrough.
---@return set<Fishing.FishID>, integer -- Fish IDs and count.
function Fishing.GetUniqueFishCaught()
    local uniqueFishCaught = Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_UNIQUE_FISH_CAUGHT) or {}
    local count = 0
    for _,_ in pairs(uniqueFishCaught) do
        count = count + 1
    end
    return uniqueFishCaught, count
end

---Returns whether a fish has been ever caught by the party.
---@param fishID Fishing.FishID
---@return boolean
function Fishing.IsFishDiscovered(fishID)
    local uniqueFishCaught = Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_UNIQUE_FISH_CAUGHT)
    return uniqueFishCaught[fishID]
end

---Returns whether a fishing region has been used at least once.
---@param regionID Fishing.RegionID
---@return boolean
function Fishing.IsRegionDiscovered(regionID)
    local discoveredRegions = Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_REGIONS_DISCOVERED)
    return discoveredRegions[regionID]
end

---Marks a fishing region as being known to the party.
---@param regionID Fishing.RegionID
function Fishing.MarkRegionAsDiscovered(regionID)
    local discoveredRegions = Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_REGIONS_DISCOVERED)
    discoveredRegions[regionID] = true
    Fishing:SetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_REGIONS_DISCOVERED, discoveredRegions)
end

---Returns the amount of fish remaining in the region.
---@param regionID Fishing.RegionID
---@return integer
function Fishing.GetRemainingFish(regionID)
    local remainingFishMap = Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_FISHES_REMAINING)
    return remainingFishMap[regionID] or 0
end

---Refreshes the amount of fish available in the region.
---@param regionID Fishing.RegionID
function Fishing.RespawnFishes(regionID)
    local FISH_PER_REGION = Fishing.DEFAULT_FISH_PER_REGION
    local remainingFish = math.random(FISH_PER_REGION[1], FISH_PER_REGION[2])
    Fishing.SetRemainingFish(regionID, remainingFish)
end

---Sets the amount of fish remaining in the region.
---@param regionID Fishing.RegionID
---@param amount integer
function Fishing.SetRemainingFish(regionID, amount)
    local remainingFishMap = Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_FISHES_REMAINING)
    remainingFishMap[regionID] = amount
    Fishing:SetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_FISHES_REMAINING, remainingFishMap)
end

---Returns the cooldown until the region's fish refresh.
---@param regionID Fishing.RegionID
---@return Fishing.GameHours
function Fishing.GetRegionRespawnCooldown(regionID)
    local cooldownMap = Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_REGION_RESPAWN_COOLDOWN) or {}
    return cooldownMap[regionID]
end

---Sets the cooldown until the region's fish refresh.
---@param regionID Fishing.RegionID
---@param hours Fishing.GameHours
function Fishing.SetRegionRespawnCooldown(regionID, hours)
    local cooldownMap = Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_REGION_RESPAWN_COOLDOWN) or {}
    cooldownMap[regionID] = hours
    Fishing:SetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_REGION_RESPAWN_COOLDOWN, cooldownMap)
end

---Decrements fish respawn cooldowns for the map's regions,
---and respawns fish if need be.
function Fishing.TickRespawnCooldowns()
    local cooldownMap = Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_REGION_RESPAWN_COOLDOWN) or {}
    local regions = Fishing.GetRegions()
    for _,region in ipairs(regions) do
        local regionID = region.ID
        local hours = cooldownMap[regionID] or 0
        cooldownMap[regionID] = hours - 1
        if cooldownMap[regionID] <= 0 then
            Fishing.RespawnFishes(regionID)
            cooldownMap[regionID] = Fishing.GetBaseRespawnCooldown(regionID)
        end
    end
    Fishing:SetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_REGION_RESPAWN_COOLDOWN, cooldownMap)
end

---Returns the time interval for fish respawns in a region.
---@param regionID Fishing.RegionID
---@return Fishing.GameHours
---@diagnostic disable-next-line: unused-local
function Fishing.GetBaseRespawnCooldown(regionID)
    return Fishing.DEFAULT_REGION_REFRESH_COOLDOWN
end

---Returns the fishermancy ability score of char.
---@param char Character
---@return integer
function Fishing.GetAbilityScore(char)
    local totalCatches = Fishing.GetTotalFishCaught(char)
    local _, uniqueFishCount = Fishing.GetUniqueFishCaught()
    local requirements = Fishing.GetAbilityRequirements(1)
    local score = 0
    while totalCatches >= requirements.TotalFishCaught and uniqueFishCount >= requirements.UniqueFishCaught do
        score = score + 1
        requirements = Fishing.GetAbilityRequirements(score + 1)
    end

    -- Starting with the Fishermancer class preset boosts the level to 1.
    -- This makes the starting skills be immediately usable.
    local hasFishermancyPreset = Fishing.HasFishermancerPreset(char)
    if hasFishermancyPreset then
        score = math.max(score, 1)
    end

    return score
end

---Returns the maximum Fishermancy level that can be reached with the amount of unique fish that exist.
---@return integer
function Fishing.GetMaxAbilityScore()
    local uniqueFishTotal = table.getKeyCount(Fishing.GetFishes())
    local requirements = Fishing.GetAbilityRequirements(1)
    local score = 0
    while uniqueFishTotal >= requirements.UniqueFishCaught do
        score = score + 1
        requirements = Fishing.GetAbilityRequirements(score + 1)
    end
    return score
end

---Returns the requirements to reach the given Fishermancy level.
---@param level integer
---@return {TotalFishCaught: integer, UniqueFishCaught: integer}
function Fishing.GetAbilityRequirements(level)
    local requirements = {
        TotalFishCaught = 0,
        UniqueFishCaught = 0,
    }
    local catchRequirement = Fishing.ABILITY_SCHOOL_FISH_PER_LEVEL
    for _=1,level,1 do -- TODO surely this can be optimized to avoid a for loop - get a mathematician
        requirements.UniqueFishCaught = requirements.UniqueFishCaught + Fishing.ABILITY_SCHOOL_UNIQUE_FISH_PER_LEVEL
        requirements.TotalFishCaught = requirements.TotalFishCaught + catchRequirement
        catchRequirement = catchRequirement + Fishing.ABILITY_SCHOOL_FISH_PER_LEVEL_GROWTH
    end
    return requirements
end

---@param id Fishing.FishID
---@return Fishing.Fish?
function Fishing.GetFish(id)
    return Fishing._Fish[id]
end

---Returns a fish by its root template.
---@param templateID GUID.ItemTemplate
---@return Fishing.Fish?
function Fishing.GetFishByTemplate(templateID)
    local fishID = Fishing._RootTemplateToFish[templateID]
    return Fishing.GetFish(fishID)
end

---@return table<Fishing.FishID, Fishing.Fish>
function Fishing.GetFishes()
    return Fishing._Fish
end

---@param pos Vector3D
---@return Fishing.Region?
function Fishing.GetRegionAt(pos)
    local levelID = Entity.GetLevel().LevelDesc.LevelName
    local regions = Fishing.GetRegions(levelID)
    local region = nil ---@type Fishing.Region
    for _,levelRegion in ipairs(regions) do
        local bounds = levelRegion.Bounds
        -- Boundaries go from north-west to south-east.
        if pos[1] >= bounds[1] and pos[1] <= bounds[1] + bounds[3] and pos[3] <= bounds[2] and pos[3] >= bounds[2] - bounds[4] then
            -- Higher-priority regions take priority.
            if not region or levelRegion.Priority > region.Priority then
                region = levelRegion
            end
        end
    end
    return region
end

---@param region Fishing.Region
---@return Fishing.Fish
function Fishing.GetRandomFish(region)
    local totalWeight = 0
    local fishID
    local seed

    for _,entry in ipairs(region.Fish) do
        totalWeight = totalWeight + entry.Weight
    end

    seed = totalWeight * math.random()

    for _,entry in ipairs(region.Fish) do
        seed = seed - entry.Weight

        if seed <= 0 then
            fishID = entry.ID
            break
        end
    end

    return Fishing.GetFish(fishID)
end

---Returns whether an item is usable as a fishing rod.
---@see Fishing.Hooks.IsFishingRod
---@param item Item
---@return boolean
function Fishing.IsFishingRod(item)
    return Fishing.Hooks.IsFishingRod:Throw({
        Item = item,
        IsFishingRod = false,
    }).IsFishingRod
end

---@param char Character
---@return boolean
function Fishing.HasFishingRodEquipped(char)
    local item = Item.GetEquippedItem(char, "Weapon")
    local hasRod = false
    if item then
        hasRod = Fishing.IsFishingRod(item)
    end
    return hasRod
end

---Returns whether char picked (or is picking) the Fishermancer class preset during character creation.
---@param char Character
---@return boolean
function Fishing.HasFishermancerPreset(char)
    -- Tag is applied post-character creation;
    -- the ClassType check only works during CC,
    -- as the game never repopulates it afterwards;
    -- it resets to the value of the root template of the origin/custom template.
    return char:HasTag("PIP_Fishing_Fishermancer") or char.PlayerCustomData.ClassType == "PIP_Fishermancer"
end

---Returns the bobber colors of char, if they have a fishing rod equipped.
---@see Fishing.VISUAL_TEMPLATE_TO_BOBBER_COLOR
---@param char Character
---@return Fishing.BobberColor? -- `nil` if the character has no fishing rod.
function Fishing.GetBobberColor(char)
    local rod = Item.GetEquippedItem(char, "Weapon")
    if not rod or not Fishing.IsFishingRod(rod) then return nil end
    return Fishing.VISUAL_TEMPLATE_TO_BOBBER_COLOR[rod.CurrentTemplate.VisualTemplate] or {
        NormalColor = Color.CreateFromHex(Color.LARIAN.POISON_GREEN),
        HighlightColor = Color.CreateFromHex(Color.LARIAN.GREEN),
    }
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Mark items with rod root/visual templates as fishing rods.
-- Visual template check covers various locally-placed rods in Origins levels (which were *not* created from the root templates).
Fishing.Hooks.IsFishingRod:Subscribe(function (ev)
    local template = ev.Item.RootTemplate
    if Fishing.FISHING_ROD_TEMPLATES:Contains(template.Id) or Fishing.FISHING_ROD_VISUAL_TEMPLATES[template.VisualTemplate] then
        ev.IsFishingRod = true
    end
end, {StringID = "DefaultImplementation"})

-- Console command to print fish availability across the regions.
-- Useful to analyze distributions of fish across the maps & regions.
Ext.RegisterConsoleCommand("fishavailability", function (_)
    local availability = {} ---@type table<string, {Rarity: ItemLib_Rarity, Acts: table<string, integer>, Total: integer, Regions: table<string, string>}>
    for _,fish in pairs(Fishing.GetFishes()) do
        availability[fish.ID] = {
            Acts = {},
            Total = 0,
            Regions = {},
        }
    end

    -- Count sources of each fish in all regions
    for _,region in pairs(Fishing._RegionsByID) do
        local level = region.LevelID
        for _,fishEntry in ipairs(region.Fish) do
            local fishAvailability = availability[fishEntry.ID]
            if fishAvailability then
                local fish = Fishing.GetFish(fishEntry.ID)
                fishAvailability.Rarity = fish.Rarity
                fishAvailability.Regions[region.ID] = Text.Round(fishEntry.Weight, 2)
                fishAvailability.Acts[level] = (fishAvailability.Acts[level] or 0) + 1
                fishAvailability.Total = fishAvailability.Total + 1
            end
        end
    end

    Fishing:__Log("Fish availability across regions:")
    Ext.Dump(availability)
    IO.SaveFile("Fishing/FishAvailability.txt", availability)
end)
