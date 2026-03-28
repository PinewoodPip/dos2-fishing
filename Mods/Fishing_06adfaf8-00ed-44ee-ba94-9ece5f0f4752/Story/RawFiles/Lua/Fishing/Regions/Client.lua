
local Tooltip = Client.Tooltip
local Fishing = GetFeature("Fishing")

local Regions = GetFeature("Fishing.Regions")
local TSK = Regions.TranslatedStrings

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Adjust tooltip of bait items to show usage hint and rarity color.
Tooltip.Hooks.RenderItemTooltip:Subscribe(function (ev)
    local item = ev.Item
    if Regions.IsBait(item) then
        local tooltip = ev.Tooltip

        -- Add hint on how to use bait
        local itemDescription = tooltip:GetFirstElement("ItemDescription")
        local hintLabel = TSK.Label_BaitHint:Format({
            Color = Fishing.ABILITY_SCHOOL_COLOR,
        })
        itemDescription.Label = hintLabel .. "\n\n" .. itemDescription.Label

        -- Recolor item name
        local itemName = tooltip:GetFirstElement("ItemName")
        itemName.Label = Text.Format(Text.StripFormatting(itemName.Label), {
            Color = Regions.FISH_BAIT_RARITY_COLOR,
        })

        -- Set rarity footer
        local itemFooter = tooltip:GetFirstElement("ItemRarity")
        local rarityLabel = TSK.Label_Bait:Format({
            Color = Regions.FISH_BAIT_RARITY_COLOR,
        })
        if itemFooter then
            itemFooter.Label = rarityLabel
        else
            tooltip:InsertElement({
                Type = "ItemRarity",
                Label = rarityLabel,
            })
        end
    end
end)
