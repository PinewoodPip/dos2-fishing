
local Runes = GetFeature("Fishing.Runes")

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Warn about equipping fish runes into unintended item slots.
Osiris.RegisterSymbolListener("RuneInserted", 4, "after", function (charGUID, itemGUID, runeTemplate, _)
    local template = Ext.Template.GetTemplate(Text.RemoveGUIDPrefix(runeTemplate)) ---@cast template ItemTemplate
    local stats = Stats.Get("StatsLib_StatsEntry_Object", template.Stats)
    local item = Item.Get(itemGUID)
    if Runes.IsFishRune(stats) and not Runes.CanEquipFishRune(item) then
        Osi.OpenMessageBox(charGUID, Runes.TranslatedStrings.MsgBox_WrongRuneSlot_Body:GetString())
        -- Osi.ItemRemoveRune(charGUID, itemGUID, slot) -- TODO this needs special handling in the case of EE to avoid conflict with their rune removal script
    end
end)
