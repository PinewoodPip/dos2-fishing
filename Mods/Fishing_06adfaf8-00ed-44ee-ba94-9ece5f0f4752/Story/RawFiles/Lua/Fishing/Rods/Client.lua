
local Fishing = GetFeature("Fishing")
local FishingTSK = Fishing.TranslatedStrings
local Tooltip = Client.Tooltip

---@class Fishing.Rods
local Rods = GetFeature("Fishing.Rods")

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Update fishing rod templates to have a world tooltip to make them easier to find.
GameState.Events.ClientReady:Subscribe(function (_)
    for _,rod in pairs(Rods._Rods) do
        local template = Ext.Template.GetTemplate(rod.RootTemplate) ---@cast template ItemTemplate
        template.Tooltip = 2
    end
end)

-- Add tooltip hints on how to use fishing rods and fancify their tooltips.
Tooltip.Hooks.RenderItemTooltip:Subscribe(function (ev)
    if Fishing.IsFishingRod(ev.Item) then
        local rod = Rods.GetRod(ev.Item)

        -- Add hint on how to use fishing rods.
        local tooltip = ev.Tooltip
        tooltip:InsertElement({
            Type = "Engraving",
            Label = FishingTSK.Label_FishingRodHint:Format({
                Color = Fishing.ABILITY_SCHOOL_COLOR,
            }),
        })

        -- Recolor header and replace name
        local itemNameElement = tooltip:GetFirstElement("ItemName")
        itemNameElement.Label = rod.Name:Format({
            Color = Fishing.FISHING_ROD_RARITY_COLOR,
        })

        -- Change rarity/footer to indicate the item is a rod
        local rarityElement = tooltip:GetFirstElement("ItemRarity")
        rarityElement.Label = FishingTSK.Label_FishingRod:Format({
            Color = Fishing.FISHING_ROD_RARITY_COLOR,
        })

        -- Change description
        local descriptionElement = tooltip:GetFirstElement("ItemDescription")
        local descriptionTSK = rod.Description
        if descriptionTSK then
            local description = descriptionTSK:GetString()
            if descriptionElement then
                descriptionElement.Label = description
            else
                tooltip:InsertElement({
                    Type = "ItemDescription",
                    Label = description,
                })
            end
        end
    end
end)
