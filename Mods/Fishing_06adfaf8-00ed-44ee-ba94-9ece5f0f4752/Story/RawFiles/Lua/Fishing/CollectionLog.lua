
---------------------------------------------
-- Implements a Codex section that displays caught fish types.
---------------------------------------------

local Generic = Client.UI.Generic
local Codex = Epip.GetFeature("Feature_Codex")
local GridSectionClass = Codex:GetClass("Features.Codex.Sections.Grid")
local TextPrefab = Generic.GetPrefab("GenericUI_Prefab_Text")
local HotbarSlot = Generic.GetPrefab("GenericUI_Prefab_HotbarSlot")
local LabelPrefab = Generic.GetPrefab("GenericUI.Prefabs.FormLabel")
local Icons = Epip.GetFeature("Feature_GenericUITextures").ICONS
local CommonStrings = Text.CommonStrings
local Fishing = GetFeature("Fishing")
local V = Vector.Create

---@class Fishing.CollectionLog : Feature
local CollectionLog = {
    -- Order in which to display levels in the region source tooltips.
    -- Unspecified levels will be sorted alphabetically afterwards.
    LEVEL_ORDER = {
        "FJ_FortJoy_Main",
        "LV_HoE_Main",
        "RC_Main",
        "CoS_Main",
        "ARX_Main",
    },
    TranslatedStrings = {
        Section_Name = {
            Handle = "hcdbc8107gbb79g4850gba76g447a5d916989",
            Text = "Fishing",
            ContextDescription = [[Section name]],
        },
        Section_Description = {
           Handle = "hd28bfe3cg4d84g4384gb5f9ge7be4a6e3a8b",
           Text = "Displays all your caught fishes.",
           ContextDescription = [[Section tooltip]],
        },
        Notification_KeybindHint = {
            Handle = "hd1dc9edegf7e0g4c62g979fg09713480d863",
            Text = "Press %s to open the Collection Log.",
            ContextDescription = [[Notification hint; param is the keybind]],
        },
        Label_Stats = {
            Handle = "he1ab927fg5d1dg42bcg89f7g2a77aa09ecc0",
            Text = "Stats",
            ContextDescription = [[Header in codex section]],
        },
        Label_CollectionLog = {
            Handle = "h682c031agb5cfg451bg9c23g34018d305320",
            Text = "Collection Log",
            ContextDescription = [[Header in codex section]],
        },
        Label_RegionsHint = {
            Handle = "h11091fbeg8bafg4be2gb697g9a365ba43e38",
            Text = "——— Habitats ———",
            ContextDescription = [[Header in fish tooltip]],
        },
        Label_UncaughtFish = {
            Handle = "hf433845bg662bg4cdegbbd5g002d2abb4743",
            Text = "You haven't caught this fish yet. Discover more fishing spots in Rivellon for a chance to encounter this fish.",
            ContextDescription = "Tooltip for fish not registered in collection log",
            LocalKey = "CollectionLog_UncaughtFish",
        },
        Label_Stat_FishDiscovered = {
            Handle = "he154277cg9200g43d2g9368g6cf4a44473bd",
            Text = "Fishes discovered:",
            ContextDescription = [[Stat label]],
        },
        Label_Stat_TotalCatches = {
            Handle = "h97de6b7bg20c5g4c54g9019g40f729b5a7b3",
            Text = "Total fish caught:",
            ContextDescription = [[Stat label]],
        },
        Label_Stat_TotalEncounters = {
            Handle = "he7dbe78dgbb53g4214gab61gd3610cfd37fc",
            Text = "Total fish encountered:",
            ContextDescription = [[Stat label]],
        },
        Label_Stat_LossRate = {
            Handle = "h3e09daedg0a0cg470cgb17dgd60d6c3ee724",
            Text = "Lossrate:",
            ContextDescription = [[Stat label]],
        },
        Setting_ActFilter_Name = {
            Handle = "hc6911e5fgd5c6g4d88g9e16gca4953e492c5",
            Text = "Region",
            ContextDescription = [[Filter setting name]],
        },
        Setting_ActFilter_Description = {
            Handle = "h2c492ce6g1eb1g4becgbbdeg8b58381e9fd1",
            Text = "Filters shown fish by the overarching region they can be caught in.",
            ContextDescription = [[Tooltip for "Region" filter setting]],
        },
        InputAction_OpenCollectionLog_Name = {
            Handle = "h0da442c6g239eg4bdfg92e2gfdb2e8228593",
            Text = "Fishing: Open Collection Log",
            ContextDescription = [[Keybind name]],
        },
    },
    Settings = {},

    USE_LEGACY_EVENTS = false,
    USE_LEGACY_HOOKS = false,

    Hooks = {
        IsFishVisible = {}, ---@type Hook<Fishing.CollectionLog.Hooks.IsFishVisible>
    }
}
RegisterFeature("Fishing.CollectionLog", CollectionLog)
local TSK = CollectionLog.TranslatedStrings

local InputActions = {
    Open = CollectionLog:RegisterInputAction("OpenCollectionLog", {
        NameHandle = TSK.InputAction_OpenCollectionLog_Name.Handle,
        DefaultInput1 = {Keys = {"lshift", "f"}}
    })
}

---------------------------------------------
-- EVENTS AND HOOKS
---------------------------------------------

---@class Fishing.CollectionLog.Hooks.IsFishVisible
---@field Fish Fishing.Fish
---@field Valid boolean Hookable. Defaults to `true`.

---------------------------------------------
-- SETTINGS
---------------------------------------------

CollectionLog.Settings.ActFilter = CollectionLog:RegisterSetting("ActFilter", {
    Type = "Choice",
    NameHandle = TSK.Setting_ActFilter_Name.Handle,
    DescriptionHandle = TSK.Setting_ActFilter_Description.Handle,
    DefaultValue = "Any",
    ---@type SettingsLib_Setting_Choice_Entry[]
    Choices = {
        {ID = "Any", NameHandle = CommonStrings.Any.Handle},
        {ID = "FJ_FortJoy_Main", NameHandle = "h0d7789e0g8140g4391g8511gc41a2ad8a476"}, -- "Fort Joy"
        {ID = "RC_Main", NameHandle = "he5f965fdg9423g4699g87d0g4af1b2e155b6"}, -- "Reaper's Coast"
        {ID = "CoS_Main", NameHandle = "h7ae018b7g8196g481bgb2beg6649b6c6fbf8"}, -- "The Nameless Isle"
        {ID = "ARX_Main", NameHandle = "hd8971510g1ba0g4b01gad48g6aa3600195e4"}, -- "Arx"
    }
})

---------------------------------------------
-- METHODS
---------------------------------------------

---Builds region display lines for a fish's habitat tooltip section.
---@param fishID Fishing.FishID
---@return string[] levelLines
function CollectionLog.GetHabitatTooltip(fishID)
    local regions = Fishing.GetFishRegions(fishID)
    local regionsByLevel = {} ---@type table<string, {LevelName: string, Regions: string[]}>
    for _,region in pairs(regions) do
        local levelID = region.LevelID
        if not regionsByLevel[levelID] then
            regionsByLevel[levelID] = {
                LevelName = Fishing.GetLevelName(levelID),
                Regions = {},
            }
        end
        local levelEntry = regionsByLevel[levelID]
        local isDiscovered = Fishing.IsRegionDiscovered(region.ID)
        if isDiscovered or not region.IsSecret then
            table.insert(levelEntry.Regions, isDiscovered and Fishing.GetRegionName(region) or "???")
        end
    end

    -- Sort by level
    local levelOrder = {}
    for levelID,_ in pairs(regionsByLevel) do
        table.insert(levelOrder, levelID)
    end
    table.sort(levelOrder, function (a, b)
        local aIndex = table.reverseLookup(CollectionLog.LEVEL_ORDER, a)
        local bIndex = table.reverseLookup(CollectionLog.LEVEL_ORDER, b)
        if aIndex and bIndex then -- Sort both by specified order
            return aIndex < bIndex
        elseif aIndex then
            return true
        elseif bIndex then
            return false
        else -- Sort by name
            return a < b
        end
    end)

    -- Build per-level region source labels
    local levelLines = {}
    for _,levelID in ipairs(levelOrder) do
        local levelEntry = regionsByLevel[levelID]
        table.sort(levelEntry.Regions, function (a, b) return a < b end)
        local regionsString = table.concat(levelEntry.Regions, ", ")
        table.insert(levelLines, Text.Format("%s: %s", {
            FormatArgs = {
                Text.Format(levelEntry.LevelName, {
                    FontType = Text.FONTS.BOLD,
                }),
                regionsString,
            },
        }))
    end

    return levelLines
end

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns a list of valid fishes to show.
---@see Fishing.CollectionLog.Hooks.IsFishVisible
---@return Fishing.Fish[]
function CollectionLog.GetFishes()
    local fishes = {} ---@type Fishing.Fish[]
    for _,fish in pairs(Fishing.GetFishes()) do
        local hook = CollectionLog.Hooks.IsFishVisible:Throw({
            Fish = fish,
            Valid = true
        })
        if hook.Valid then
            table.insert(fishes, fish)
        end
    end

    -- Sort by rarity ascending, then name
    local rarityOrder = Item.RARITY_ORDER_MAP
    table.sort(fishes, function (a, b)
        if a.Rarity == b.Rarity then
            return a:GetName() < b:GetName()
        end
        return rarityOrder[a.Rarity] < rarityOrder[b.Rarity]
    end)

    return fishes
end

---Returns the complete tooltip for a fish.
---For undiscovered fish, the name and rarity are masked with "???" and only
---habitat regions that have already been discovered are shown.
---@param fishID Fishing.FishID
---@return TooltipLib_FormattedTooltip
function CollectionLog.GetFishTooltip(fishID)
    local fish = Fishing.GetFish(fishID)
    local isDiscovered = Fishing.IsFishDiscovered(fishID)
    local levelLines = CollectionLog.GetHabitatTooltip(fishID)
    local tooltip = fish:GetTooltip()

    -- Hide names and descriptions of undiscovered fish.
    if not isDiscovered then
        for _,element in ipairs(tooltip.Elements) do
            if element.Type == "ItemName" then
                local rarityColor = fish:GetRarityColor()
                element.Label = Text.Format("???", {Color = rarityColor})
            elseif element.Type == "SkillDescription" and element._IsDescription then
                element.Label = TSK.Label_UncaughtFish:Format({
                    FontType = Text.FONTS.ITALIC,
                })
            end
        end
    end

    -- Add habitat list
    local linesString = table.concat(levelLines, "<br>")
    if linesString ~= "" then
        local habitatHeader = TSK.Label_RegionsHint:Format({
            Color = Color.LARIAN.GREEN,
            Align = "Center",
        })
        table.insert(tooltip.Elements, {
            Type = "SkillDescription",
            Label = habitatHeader .. linesString,
        })
    end

    return tooltip
end

---------------------------------------------
-- SECTION
---------------------------------------------

---@class Fishing.CollectionLog.CodexSection : Features.Codex.Sections.Grid
local Section = {
    Name = TSK.Section_Name,
    Description = TSK.Section_Description,
    Icon = Icons.COMBAT_LOG_FILTERS.ITEMS, -- TODO
    Settings = {
        CollectionLog.Settings.ActFilter,
    },
}
Codex:RegisterClass("Fishing.CollectionLog.CodexSection", Section, {"Features.Codex.Sections.Grid"})
Codex.RegisterSection("Fish", Section)

---Decorates a string with leading & trailing em-dashes.
---@param text string
---@return string
local function WrapWithDashes(text)
    return string.format("———    %s    ———", text)
end

---@override
---@param root GenericUI_Element_Empty
function Section:Render(root)
    local HEADER_X_OFFSET = -40

    GridSectionClass.Render(self, root)

    -- Stats header
    local statsHeader = TextPrefab.Create(Codex.UI, self:__PrefixElement("StatsHeader"), root, WrapWithDashes(TSK.Label_Stats:GetString()), "Center", V(self.GRID_LIST_FRAME[1], 50))
    statsHeader:SetStroke(0, 2, 1, 15, 15)
    statsHeader:Move(HEADER_X_OFFSET, -20)

    -- Add stat labels
    local statsGrid = root:AddChild(self:__PrefixElement("StatsGrid"), "GenericUI_Element_Grid")
    self.StatsGrid = statsGrid -- Should be set before calling AddStatLabel()
    statsGrid:SetGridSize(2, 2)
    local fishDiscoveredLabel = self:AddStatLabel("FishDiscoveredLabel", TSK.Label_Stat_FishDiscovered)
    local totalCatchesLabel = self:AddStatLabel("TotalCatchesLabel", TSK.Label_Stat_TotalCatches)
    local totalEncountersLabel = self:AddStatLabel("TotalEncountersLabel", TSK.Label_Stat_TotalEncounters)
    local lossRateLabel = self:AddStatLabel("LossRateLabel", TSK.Label_Stat_LossRate)
    self.StatLabels = {
        FishDiscovered = fishDiscoveredLabel,
        TotalCatches = totalCatchesLabel,
        TotalEncounters = totalEncountersLabel,
        LossRate = lossRateLabel,
    }
    statsGrid:Move(0, 20)

    self.GridScrollList:Move(0, 70) -- Move down to make space for stats

    -- Collection log header
    local collectionLogHeader = TextPrefab.Create(Codex.UI, self:__PrefixElement("CollectionLogHeader"), root, WrapWithDashes(TSK.Label_CollectionLog:GetString()), "Center", V(self.GRID_LIST_FRAME[1], 50))
    collectionLogHeader:SetStroke(0, 2, 1, 15, 15)
    local headerX, _ = collectionLogHeader:GetPosition()
    local _, gridY = self.GridScrollList:GetPosition()
    collectionLogHeader:SetPosition(headerX - HEADER_X_OFFSET - 80, gridY - 40)

    statsGrid:RepositionElements()
end

---@override
function Section:Update(_)
    local fishes = CollectionLog.GetFishes()
    local char = Client.GetCharacter()

    -- Update fish grid
    self:__Update(fishes)

    -- Update stat values
    local _, uniqueFishCaught = Fishing.GetUniqueFishCaught()
    local totalFishes = table.getKeyCount(Fishing.GetFishes())
    local encountersMap = Fishing.GetTotalFishEncounters()
    local totalEncounters = 0
    for _,encounters in pairs(encountersMap) do
        totalEncounters = totalEncounters + encounters
    end
    local lossRate = totalEncounters > 0 and (100 - Fishing.GetTotalFishCaught(char) / totalEncounters * 100) or 0
    local statLabels = self.StatLabels
    local fishDiscoveredValue = string.format("%d/%d", uniqueFishCaught, totalFishes)
    local actFilter = CollectionLog:GetSettingValue(CollectionLog.Settings.ActFilter)
    if actFilter ~= "Any" then
        -- Append region-specific discovered fish count
        local regionTotal, regionCaught = 0, 0
        for _,fish in pairs(Fishing.GetFishes()) do
            if Fishing.IsFishAvailable(fish.ID, actFilter) then
                regionTotal = regionTotal + 1
                if Fishing.GetFishCatchCount(char, fish.ID) > 0 then
                    regionCaught = regionCaught + 1
                end
            end
        end
        fishDiscoveredValue = string.format("%s (%d/%d)", fishDiscoveredValue, regionCaught, regionTotal)
    end
    statLabels.FishDiscovered:SetValue(fishDiscoveredValue)
    statLabels.TotalCatches:SetValue(Fishing.GetTotalFishCaught(char) .. "") -- TODO use a party-wide catch stat?
    statLabels.TotalEncounters:SetValue(totalEncounters .. "")
    statLabels.LossRate:SetValue(string.format("%s%%", Text.Round(lossRate, 2)))
end

---Creates a stat label element.
---@param id string
---@param labelTSK TextLib_TranslatedString
---@return GenericUI.Prefabs.FormLabel
function Section:AddStatLabel(id, labelTSK)
    local STAT_LABEL_SIZE = V(self.GRID_LIST_FRAME[1] / 2 - 40, 50)
    return LabelPrefab.Create(Codex.UI, self:__PrefixElement(id), self.StatsGrid, labelTSK, STAT_LABEL_SIZE, "")
end

---@override
---@param index integer
---@return GenericUI_Prefab_HotbarSlot
function Section:__CreateElement(index)
    local slot = HotbarSlot.Create(Codex.UI, "Fish.Slot." .. tostring(index), self.Grid)
    return slot
end

---Prefixes an ID with the section's ID.
---@param id string
---@return string
function Section:__PrefixElement(id)
    return self.ID .. "_" .. id
end

---@override
---@param _ integer
---@param slot GenericUI_Prefab_HotbarSlot
---@param fish Fishing.Fish
function Section:__UpdateElement(_, slot, fish)
    local char = Client.GetCharacter()
    local wasCaught = Fishing.GetFishCatchCount(char, fish.ID) > 0
    local icon = wasCaught and fish:GetIcon() or fish.UndiscoveredIcon
    local tooltip = CollectionLog.GetFishTooltip(fish.ID)

    slot:SetIcon(icon)
    slot:SetCanDragDrop(false)
    slot:SetRarityIcon(Item.GetRarityIcon("Unique"))
    slot:SetTooltip("Custom", tooltip)
    slot:SetEnabled(true) -- No need to disable the slot for undiscovered fish (would just make the icons harder to read)
end

---Opens the Codex to the Fishing section.
function CollectionLog.Show()
    if not Codex.UI:IsVisible() then
        Codex.UI:Show()
        Codex.UI.SetSection(Section) -- Should be done after Show() else the UI's static elements will not yet be initialized.
    end
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Apply act filter.
CollectionLog.Hooks.IsFishVisible:Subscribe(function (ev)
    local valid = ev.Valid
    if valid then
        local actFilter = CollectionLog:GetSettingValue(CollectionLog.Settings.ActFilter)
        local fish = ev.Fish
        if actFilter ~= "Any" then
            valid = valid and Fishing.IsFishAvailable(fish.ID, actFilter)
        end
        ev.Valid = valid
    end
end, {StringID = "DefaultImplementation"})

-- Toggle the UI when the keybind is used.
Client.Input.Events.ActionExecuted:Subscribe(function (ev)
    if ev.Action.ID == InputActions.Open.ID then
        CollectionLog.Show()
    end
end)
