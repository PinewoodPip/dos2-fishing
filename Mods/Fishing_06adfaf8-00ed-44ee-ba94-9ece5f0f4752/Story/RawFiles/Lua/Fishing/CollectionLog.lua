
---------------------------------------------
-- Implements a Codex section that displays caught fish types.
---------------------------------------------

local Generic = Client.UI.Generic
local Codex = Epip.GetFeature("Feature_Codex")
local GridSectionClass = Codex:GetClass("Features.Codex.Sections.Grid")
local HotbarSlot = Generic.GetPrefab("GenericUI_Prefab_HotbarSlot")
local Icons = Epip.GetFeature("Feature_GenericUITextures").ICONS
local CommonStrings = Text.CommonStrings
local Fishing = Epip.GetFeature("Features.Fishing")

---@class Features.Fishing.CollectionLog : Feature
local CollectionLog = {
    TranslatedStrings = {
        Section_Name = {
            Handle = "hcdbc8107gbb79g4850gba76g447a5d916989",
            Text = "Fish",
            ContextDescription = [[Section name]],
        },
        Section_Description = {
           Handle = "hd28bfe3cg4d84g4384gb5f9ge7be4a6e3a8b",
           Text = "Displays all your caught fishes.",
           ContextDescription = [[Section tooltip]],
        },
        Label_RegionsHint = {
            Handle = "h82ff869cg637eg465eg8448g3636c792b4cb",
            Text = "Found in %s.",
            ContextDescription = [[Codex tooltip for the regions a fish can be found in; param is comma-separated list of regions]],
        },
        Label_UncaughtFish = {
            Handle = "hf433845bg662bg4cdegbbd5g002d2abb4743",
            Text = "You haven't caught this fish yet.",
            ContextDescription = "Tooltip for fish not registered in collection log",
            LocalKey = "CollectionLog_UncaughtFish",
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
        IsFishVisible = {}, ---@type Hook<Features.Fishing.CollectionLog.Hooks.IsFishVisible>
    }
}
Epip.RegisterFeature("Features.Fishing.Codex.CollectionLog", CollectionLog)
local TSK = CollectionLog.TranslatedStrings

local InputActions = {
    Open = CollectionLog:RegisterInputAction("OpenCollectionLog", {
        Name = "Fishing: Open Collection Log",
        DefaultInput1 = {Keys = {"lshift", "f"}}
    })
}

---------------------------------------------
-- EVENTS AND HOOKS
---------------------------------------------

---@class Features.Fishing.CollectionLog.Hooks.IsFishVisible
---@field Fish Features.Fishing.Fish
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

---Returns a list of valid fishes to show.
---@see Features.Fishing.CollectionLog.Hooks.IsFishVisible
---@return Features.Fishing.Fish[]
function CollectionLog.GetFishes()
    local fishes = {} ---@type Features.Fishing.Fish[]
    for _,fish in pairs(Fishing.GetFishes()) do
        local hook = CollectionLog.Hooks.IsFishVisible:Throw({
            Fish = fish,
            Valid = true
        })

        if hook.Valid then
            table.insert(fishes, fish)
        end
    end

    -- Sort by name
    table.sort(fishes, function (a, b)
        return a:GetName() < b:GetName()
    end)

    return fishes
end

---Returns the complete tooltip for a fish.
---@param fishID string
---@return TooltipLib_FormattedTooltip
function CollectionLog.GetFishTooltip(fishID)
    local fish = Fishing.GetFish(fishID)
    local tooltip = table.shallowCopy(fish:GetTooltip())

    -- Append region info to tooltip
    local regions = Fishing.GetFishRegions(fishID)
    local regionNames = {}
    for _,region in pairs(regions) do
        table.insert(regionNames, Text.GetTranslatedString(region.NameHandle))
    end
    table.sort(regionNames, function (a, b) return a < b end) -- Sort alphabetically
    local regionsString = table.concat(regionNames, ", ")
    local regionElement = {
        Type = "SkillDescription",
        Label = TSK.Label_RegionsHint:Format({
            FontType = Text.FONTS.ITALIC,
            FormatArgs = {regionsString},
        }),
    }
    table.insert(tooltip.Elements, regionElement)

    return tooltip
end

---Returns the tooltip to show for fish the player party has not caught yet.
---@return TooltipLib_FormattedTooltip
function CollectionLog.GetUncaughtFishTooltip()
    local tooltip = {
        Elements = {
            {
                Type = "ItemName",
                Label = "???",
            },
            {
                Type = "SkillDescription",
                Label = TSK.Label_UncaughtFish:GetString(),
            },
            {
                Type = "ItemRarity",
                Label = "???",
            },
        }
    }
    return tooltip
end

---------------------------------------------
-- SECTION
---------------------------------------------

---@class Features.Fishing.CollectionLog.CodexSection : Features.Codex.Sections.Grid
local Section = {
    Name = TSK.Section_Name,
    Description = TSK.Section_Description,
    Icon = Icons.COMBAT_LOG_FILTERS.ITEMS, -- TODO
    Settings = {
        CollectionLog.Settings.ActFilter,
    },
}
Codex:RegisterClass("Features.Fishing.CollectionLog.CodexSection", Section, {"Features.Codex.Sections.Grid"})
Codex.RegisterSection("Fish", Section)

---@override
---@param root GenericUI_Element_Empty
function Section:Render(root)
    GridSectionClass.Render(self, root)
end

---@override
function Section:Update(_)
    local fishes = CollectionLog.GetFishes()
    self:__Update(fishes)
end

---@override
---@param index integer
---@return GenericUI_Prefab_HotbarSlot
function Section:__CreateElement(index)
    local slot = HotbarSlot.Create(Codex.UI, "Fish.Slot." .. tostring(index), self.Grid)
    return slot
end

---@override
---@param _ integer
---@param slot GenericUI_Prefab_HotbarSlot
---@param fish Features.Fishing.Fish
function Section:__UpdateElement(_, slot, fish)
    local template = Ext.Template.GetRootTemplate(fish.TemplateID) ---@cast template ItemTemplate
    local char = Client.GetCharacter()
    local wasCaught = Fishing.GetFishCatchCount(char, fish.ID) > 0
    local icon = wasCaught and template.Icon or "unknown"
    local tooltip = wasCaught and CollectionLog.GetFishTooltip(fish.ID) or CollectionLog.GetUncaughtFishTooltip()

    slot:SetIcon(icon)
    slot:SetCanDragDrop(false)
    slot:SetRarityIcon(Item.GetRarityIcon("Unique"))
    slot:SetTooltip("Custom", tooltip)
    slot:SetEnabled(wasCaught)
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
        if not Codex.UI:IsVisible() then
            Codex.UI:Show()
            Codex.UI.SetSection(Section) -- Should be done after Show() else the UI's static elements will not yet be initialized.
        end
    end
end)
