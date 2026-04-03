
local Tooltip = Client.Tooltip
local Fishing = GetFeature("Fishing")

local Runes = GetFeature("Fishing.Runes")
local TSK = Runes.TranslatedStrings

-- Maps fish ID to map of rune tiers to additional text to show within the rune power tooltip.
---@type table<string, table<integer, {TSK: TextLib_TranslatedString, FormatArgs: any[]?}>>
Runes.RUNE_EXTRA_LABELS = {
    ["Epipe"] = {
        [1] = {
            TSK = TSK.Effect_Epipe,
            FormatArgs = {45},
        },
        [2] = {
            TSK = TSK.Effect_Epipe,
            FormatArgs = {120},
        },
        [3] = {
            TSK = TSK.Effect_Epipe,
            FormatArgs = {1337},
        },
    },
    ["DescentKey"] = {
        [1] = {
            TSK = TSK.Effect_DescentKey,
            FormatArgs = {20},
        },
        [2] = {
            TSK = TSK.Effect_DescentKey,
            FormatArgs = {55},
        },
        [3] = {
            TSK = TSK.Effect_DescentKey,
            FormatArgs = {100},
        },
    },
    ["FidgetSpinner"] = {
        [1] = {
            TSK = TSK.Effect_FidgetSpinner,
            FormatArgs = {5},
        },
        [2] = {
            TSK = TSK.Effect_FidgetSpinner,
            FormatArgs = {15},
        },
        [3] = {
            TSK = TSK.Effect_FidgetSpinner,
            FormatArgs = {25},
        },
    },
    ["SourceStarFish"] = {
        [1] = {
            TSK = TSK.Effect_SourceStarFish,
        },
        [2] = {
            TSK = TSK.Effect_SourceStarFish,
        },
        [3] = {
            TSK = TSK.Effect_SourceStarFish,
        },
    },
}

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Rebrand rune tooltips for fish, show extra effects and a "Cannot equip" warning for unusable rune slots.
Tooltip.Hooks.RenderItemTooltip:Subscribe(function (ev)
    local item = ev.Item
    local runeTier = Runes.GetFishRuneTier(item)
    if runeTier then
        local fish = Fishing.GetFishByTemplate(item.RootTemplate.Id)

        -- Rebrand rune slot labels to "Fish Essence"
        local runeSlotElement = ev.Tooltip:GetFirstElement("ArmorSlotType")
        runeSlotElement.Label = TSK.Label_FishRune:Format({
            FormatArgs = {runeTier},
        })

        -- Show warning for unusable slots
        local runeElement = ev.Tooltip:GetFirstElement("RuneEffect")
        for i=1,Item.MAX_RUNE_SLOTS,1 do
            local runeLabel = runeElement["Rune" .. i]
            if runeLabel == "" then
                runeElement["Rune" .. i] = TSK.Label_CannotEquip:Format({Size = 18})
            else
                -- Add extra labels
                if Runes.IsIdentified(Client.GetCharacter(), item) then
                    local extraLabels = Runes.RUNE_EXTRA_LABELS[fish.ID]
                    if extraLabels then
                        local label = extraLabels[runeTier]
                        if label then
                            -- Note: some vanilla labels (ex. status applications) do not add a line break after them - thus we must check for it.
                            local existingLabel = runeElement["Rune" .. i]
                            local infix = string.find(existingLabel, "<br>$") and "" or "<br>"
                            runeElement["Rune" .. i] = runeElement["Rune" .. i] .. infix .. label.TSK:Format({
                                FormatArgs = label.FormatArgs
                            })
                        end
                    end
                else -- Show warning for unidentified runes
                    runeElement["Rune" .. i] = TSK.Label_Unidentified:Format({
                        FormatArgs = {Runes.GetIdentificationRequirement(item)},
                        Color = Fishing.ABILITY_SCHOOL_COLOR,
                        Size = 18,
                    })
                end
            end
        end

        -- Add label for max-tier runes
        if runeTier == #fish.RootTemplates then
            local descElement = ev.Tooltip:GetFirstElement("ItemDescription")
            descElement.Label = descElement.Label .. "<br><br>" .. TSK.Label_Descended:Format({
                Color = Fishing.ABILITY_SCHOOL_COLOR,
            })
        end
    end
end)
