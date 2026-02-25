
local DefaultTable = DataStructures.Get("DataStructures_DefaultTable")
local Set = DataStructures.Get("DataStructures_Set")

---@class Features.Fishing : Feature
local Fishing = {
    _Fish = {}, ---@type table<string, Features.Fishing.Fish>
    _FishBehaviours = {}, ---@type table<Features.Fishing.Fish.BehaviourType, Features.Fishing.Fish.Behaviour>
    _RegionsByLevel = DefaultTable.Create({}), ---@type DataStructures_DefaultTable<string, Features.Fishing.Region[]>
    _RegionsByID = {}, ---@type table<string, Features.Fishing.Region>
    _CharactersFishing = Set.Create(), -- Not synchronized across clients!

    NETMSG_STARTED_FISHING = "Features.Fishing.NetMsgs.CharacterStartedFishing",
    NETMSG_STOPPED_FISHING = "Features.Fishing.NetMsgs.CharacterStoppedFishing",

    MODVAR_UNIQUE_FISH_CAUGHT = "PlaythroughUniqueFishCaught",
    USERVAR_FISH_CAUGHT = "CharacterFishCaught",

    FISHING_ROD_TEMPLATES = Set.Create({
        "81cbf17f-cc71-4e09-9ab3-ca2a5cb0cefc", -- HAR_FishingRod_A, green fish-shaped lure
        "90cdb693-3564-415a-a8fa-4027b7f76f41", -- HAR_FishingRod_B, classic red/white bobber
        "9fc3cb5f-894e-4783-9eef-fbceef0104b0", -- HAR_FishingRod_C, red/yellow lure
    }),
    WATER_SEARCH_RADIUS = 1.5,
    WATER_MAX_DISTANCE = 3.5, -- Distance to water (or fishing areas) that a character must be within for fishing to be available.

    USE_LEGACY_EVENTS = false,
    USE_LEGACY_HOOKS = false,

    Settings = {},

    TranslatedStrings = {
        Notification_Minigame_Success = {
            Handle = "h35cacdc8g0b2ag46f4gb003g3122d32bfecc",
            Text = "Got it!",
            ContextDescription = [[Overhead dialog when winning the minigame]],
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
        ["hcced1bb7ge818g4803gbf45gf0644370163f"] = {
            Text = "Hold left-click to raise the bar,\nlet go to have it fall.\n\nKeep the bar by the fish until the yellow bar fills up!",
            ContextDescription = "Tutorial message",
            LocalKey = "MinigameTutorialHint",
        },
        ["h25bb86bcge5edg4a61g9ebdgce438fa04de1"] = {
            Text = "Fish Caught!",
            ContextDescription = "Toast notification for minigame success",
            LocalKey = "Toast_Success",
        },
        ["h13c51b21g9d2bg4489g9e4bg460b162e8b3c"] = {
            Text = "Press %s to open the collection log.",
            ContextDescription = "Toast notification for minigame success, when catching new types of fish",
            LocalKey = "Toast_Success_Subtitle",
        },
        ["h26c81552g4b40g4f9bg88c5g0380578c6964"] = {
            Text = "Click to start fishing.",
            ContextDescription = "Mouseover text for fishable areas",
            LocalKey = "CharacterTask_MouseTextTooltip",
        },
        ["hf433845bg662bg4cdegbbd5g002d2abb4743"] = {
            Text = "You haven't caught this fish yet.",
            ContextDescription = "Tooltip for fish not registered in collection log",
            LocalKey = "CollectionLog_UncaughtFish",
        },
    },

    Events = {
        CharacterStartedFishing = {}, ---@type Event<Features.Fishing.Event.CharacterStartedFishing>
        CharacterStoppedFishing = {}, ---@type Event<Features.Fishing.Event.CharacterStoppedFishing>
    },
    Hooks = {
        IsFishingRod = {}, ---@type Event<Feature_Fishin_Hook_IsFishingRod>
    },
}
Epip.RegisterFeature("Fishing", Fishing)

Fishing:RegisterModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_UNIQUE_FISH_CAUGHT, {
    Persistent = true,
    DefaultValue = {},
})
Fishing:RegisterUserVariable(Fishing.USERVAR_FISH_CAUGHT, {
    Persistent = true,
    DefaultValue = {},
})

---------------------------------------------
-- EVENTS
---------------------------------------------

---@class Features.Fishing.NetMsg.CharacterStartedFishing : NetLib_Message_Character
---@field RegionID string
---@field FishID string

---@class Features.Fishing.NetMsg.CharacterStoppedFishing : NetLib_Message_Character
---@field Reason Features.Fishing.MinigameExitReason
---@field CaughtFishID string? `nil` unless the minigame was won.

---@class Features.Fishing.Hook.IsFishingRod
---@field Character Character
---@field Item Item
---@field IsFishingRod boolean Hookable. Defaults to false.

---@class Features.Fishing.Event.CharacterStartedFishing
---@field Character Character
---@field Region Features.Fishing.Region
---@field TargetPosition vec3

---@class Features.Fishing.Event.CharacterStoppedFishing
---@field Character Character
---@field Reason Features.Fishing.MinigameExitReason
---@field CaughtFish Features.Fishing.Fish? The fish caught, if any.

---------------------------------------------
-- NET MESSAGES
---------------------------------------------

---@class Features.Fishing.NetMsgs.CharacterStartedFishing : NetLib_Message_Character
---@field RegionID string
---@field TargetPosition vec3

---@class Features.Fishing.NetMsgs.CharacterStoppedFishing : NetLib_Message_Character
---@field Reason Features.Fishing.MinigameExitReason
---@field CaughtFishID string?

---------------------------------------------
-- CLASSES
---------------------------------------------

---@alias Features.Fishing.MinigameExitReason "Success"|"Failure"|"Cancelled"

---@diagnostic disable-next-line: duplicate-doc-alias
---@alias Features.Fishing.Fish.BehaviourType string

---@class Features.Fishing.Fish.Behaviour.Transition
---@field TargetState Features.Fishing.GameObject.Fish.StateClassName
---@field Weight number Relative chance for this transition to be picked.

---@class Features.Fishing.Fish.Behaviour
---@field Type Features.Fishing.Fish.BehaviourType
---@field InitialState Features.Fishing.GameObject.Fish.StateClassName
---@field Transitions table<Features.Fishing.GameObject.Fish.StateClassName, Features.Fishing.Fish.Behaviour.Transition[]> Maps current state to possible transitions.

---@class Features.Fishing.Fish : I_Identifiable, I_Describable
---@field Icon string? Defaults to the template's icon.
---@field TemplateID GUID
---@field Difficulty number Affects the "intensity" of the fish's AI. Higher values are expected to translate to faster movement or shorter intervals between movement states.
---@field Endurance number Multiplier for how much progress the player needs to accumulate to catch the fish.
---@field Behaviour Features.Fishing.Fish.BehaviourType
local _Fish = {
    Difficulty = 1,
    Endurance = 1,
}

---@return string
function _Fish:GetIcon()
    local itemTemplate = Ext.Template.GetTemplate(self.TemplateID) ---@type ItemTemplate

    return self.Icon or itemTemplate.Icon
end

---@return TooltipLib_FormattedTooltip
function _Fish:GetTooltip()
    ---@type TooltipLib_FormattedTooltip
    local tooltip = {
        Elements = {
            {
                Type = "ItemName",
                Label = self:GetName(), -- TODO rarity color
            },
            -- Multiple SkillDescriptions are ordered inversely, lol TODO fix?
            {
                Type = "SkillDescription",
                Label = Text.Format("Total caught: %s", {
                    FormatArgs = {
                        Fishing.GetFishCatchCount(Client.GetCharacter(), self.ID),
                    },
                    Color = Color.LARIAN.GREEN,
                }),
            },
            {
                Type = "SkillDescription",
                Label = self:GetDescription(),
            },
            {
                Type = "ItemRarity",
                Label = "Fish", -- TODO
            }
        }
    }

    return tooltip
end

---@class Features.Fishing.Region : I_Identifiable
---@field LevelID string
---@field Bounds Vector4 X, Y, width, height bounds of the area where fishing will be possible when near deepwater surfaces.
---@field Fish Features.Fishing.Region.FishEntry[]
---@field Priority integer? Defaults to 0.
---@field FishingAreas Vector4[]? Bounds of areas where fishing is possible even without deepwater surfaces.
local _Region = {
    Priority = 0,
}

---@class Features.Fishing.Region.FishEntry
---@field ID string ID of the fish.
---@field Weight number Relative chance for the fish to be picked.

---------------------------------------------
-- METHODS
---------------------------------------------

---@param data Features.Fishing.Fish
function Fishing.RegisterFish(data)
    if not data.ID then Fishing:Error("RegisterFish", "Data must include ID.") end
    Inherit(data, _Fish)
    Interfaces.Apply(data, "I_Identifiable")
    Interfaces.Apply(data, "I_Describable")

    Fishing._Fish[data.ID] = data
end

---Registers a fishing region.
---@param data Features.Fishing.Region
function Fishing.RegisterRegion(data)
    if not data.ID then Fishing:__Error("RegisterRegion", "Data must include ID.") end
    if #data.Fish == 0 then Fishing:__Error("RegisterRegion", "Regions must have at least one fish entry.") end
    Inherit(data, _Region)
    Interfaces.Apply(data, "I_Identifiable")

    table.insert(Fishing._RegionsByLevel[data.LevelID], data)

    -- Validate fish IDs
    for _,fishEntry in ipairs(data.Fish) do
        if not Fishing.GetFish(fishEntry.ID) then
            Fishing:__Error("RegisterRegion", "Unknown fish ID:", fishEntry.ID)
        end
    end
end

---Registers a fish behaviour.
---@param behaviour Features.Fishing.Fish.Behaviour
function Fishing.RegisterFishBehaviour(behaviour)
    if not behaviour.Type then Fishing:__Error("RegisterFishBehaviour", "Missing Type field") end
    Fishing._FishBehaviours[behaviour.Type] = behaviour
end

---Returns a fish behaviour by ID.
---@param type Features.Fishing.Fish.BehaviourType
---@return Features.Fishing.Fish.Behaviour
function Fishing.GetBehaviour(type)
    return Fishing._FishBehaviours[type]
end

---@param levelID string
---@return Features.Fishing.Region[]
function Fishing.GetRegions(levelID)
    return Fishing._RegionsByLevel[levelID]
end

---@param id string
---@return Features.Fishing.Region?
function Fishing.GetRegion(id)
    return Fishing._RegionsByID[id]
end

---@param char Character
---@return boolean
function Fishing.IsFishing(char)
    return Fishing._CharactersFishing:Contains(char.Handle)
end

---Returns the amount of each fish that char has caught.
---@overload fun(char: Character, fishID: string): integer
---@param char Character
---@return table<string, integer> -- Maps fish ID to catch count.
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

---Increments the amount of fish caught by char.
---@param char Character
---@param fishID string
---@param count integer? Defaults to 1.
function Fishing.AddFishCatchCount(char, fishID, count)
    count = count or 1
    local currentCount = Fishing.GetFishCatchCount(char)
    local fishCounts = currentCount or {}
    fishCounts[fishID] = (fishCounts[fishID] or 0) + count
    Fishing:SetUserVariable(char, Fishing.USERVAR_FISH_CAUGHT, fishCounts)
end

---Returns the fish types that were caught in this playthrough.
---@return set<string>, integer -- Fish IDs and count.
function Fishing.GetUniqueFishCaught()
    local uniqueFishCaught = Set.Create(Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_UNIQUE_FISH_CAUGHT) or {})
    return uniqueFishCaught, #uniqueFishCaught
end

---Marks a fish type as having been caught in this playthrough.
---@param fishID string
function Fishing.MarkFishTypeAsCaught(fishID)
    local uniqueFishCaught = Fishing:GetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_UNIQUE_FISH_CAUGHT)
    uniqueFishCaught[fishID] = true
    Fishing:SetModVariable(Mod.GUIDS.FISHING, Fishing.MODVAR_UNIQUE_FISH_CAUGHT, uniqueFishCaught)
end

---@param id string
---@return Features.Fishing.Fish?
function Fishing.GetFish(id)
    return Fishing._Fish[id]
end

---@return table<string, Features.Fishing.Fish>
function Fishing.GetFishes()
    return Fishing._Fish
end

---@param pos Vector3D
---@return Features.Fishing.Region?
function Fishing.GetRegionAt(pos)
    local levelID = Entity.GetLevel().LevelDesc.LevelName
    local regions = Fishing.GetRegions(levelID)
    local region = nil ---@type Features.Fishing.Region
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

---@param region Features.Fishing.Region
---@return Features.Fishing.Fish
function Fishing.GetRandomFish(region)
    local totalWeight = 0
    local fishID
    local seed

    for _,entry in ipairs(region.Fish) do
        local fish = Fishing.GetFish(entry.ID)
        if not fish then Fishing:Error("GetRandomFish", "Found unregistered fish " .. entry.ID) end -- TODO move to registerregion

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

---@param char Character
---@return boolean
function Fishing.HasFishingRodEquipped(char)
    local item = Item.GetEquippedItem(char, "Weapon")
    local hasRod = false

    if item then
        local event = Fishing.Hooks.IsFishingRod:Throw({
            Character = char,
            Item = item,
            IsFishingRod = hasRod,
        })

        hasRod = event.IsFishingRod
    end

    return hasRod
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Check for fishing rod template.
Fishing.Hooks.IsFishingRod:Subscribe(function (ev)
    if Fishing.FISHING_ROD_TEMPLATES:Contains(ev.Item.RootTemplate.Id) then
        ev.IsFishingRod = true
    end
end)