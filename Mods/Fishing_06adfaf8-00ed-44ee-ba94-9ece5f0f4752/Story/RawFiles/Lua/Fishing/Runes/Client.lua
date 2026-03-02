
local Tooltip = Client.Tooltip
local Fishing = Epip.GetFeature("Features.Fishing")

local Runes = Epip.GetFeature("Features.Fishing.Runes")
local TSK = Runes.TranslatedStrings

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Show a "Cannot equip" warning for unusable fish rune slots.
Tooltip.Hooks.RenderItemTooltip:Subscribe(function (ev)
    local item = ev.Item
    if Runes.IsFishRune(item) then
        local runeElement = ev.Tooltip:GetFirstElement("RuneEffect")
        for i=1,Item.MAX_RUNE_SLOTS,1 do
            local runeLabel = runeElement["Rune" .. i]
            if runeLabel == "" then
                runeElement["Rune" .. i] = TSK.Label_CannotEquip:Format({Size = 18})
            end
        end
    end
end)
