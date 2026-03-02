
local Tooltip = Client.Tooltip

local Runes = Epip.GetFeature("Features.Fishing.Runes")
local TSK = Runes.TranslatedStrings

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Rebrand rune tooltips for fish and show a "Cannot equip" warning for unusable rune slots.
Tooltip.Hooks.RenderItemTooltip:Subscribe(function (ev)
    local item = ev.Item
    if Runes.IsFishRune(item) then
        -- Rebrand rune slot labels to "Fish Essence"
        local runeSlotElement = ev.Tooltip:GetFirstElement("ArmorSlotType")
        runeSlotElement.Label = TSK.Label_FishRune:Format({
            FormatArgs = {Runes.GetFishRuneTier(item)},
        })

        -- Show warning for unusable slots
        local runeElement = ev.Tooltip:GetFirstElement("RuneEffect")
        for i=1,Item.MAX_RUNE_SLOTS,1 do
            local runeLabel = runeElement["Rune" .. i]
            if runeLabel == "" then
                runeElement["Rune" .. i] = TSK.Label_CannotEquip:Format({Size = 18})
            end
        end
    end
end)
