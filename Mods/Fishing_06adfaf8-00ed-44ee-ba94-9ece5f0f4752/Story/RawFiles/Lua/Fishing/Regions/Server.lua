
local Fishing = GetFeature("Fishing")

local Regions = GetFeature("Fishing.Regions")
local TSK = Regions.TranslatedStrings

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Spawn additional fish in a region when bait is used.
Osiris.RegisterSymbolListener("CharacterUsedItem", 2, "after", function (charGUID, itemGUID)
    local item = Item.Get(itemGUID)
    if Regions.IsBait(item) then
        local char = Character.Get(charGUID)
        local region = Fishing.GetRegionAt(char.WorldPos)
        if region and Fishing.IsPositionFishable(char.WorldPos, Regions.BAIT_WATER_SEARCH_RADIUS) then -- Spawn more fish
            local remainingFish = Fishing.GetRemainingFish(charGUID)
            local fishAdded = Regions.FISH_PER_BAIT
            local newFish = math.max(fishAdded, remainingFish + fishAdded) -- Sanity check in case region was underflowed (technically possible in multiplayer with VERY specific timing)
            Fishing.SetRemainingFish(charGUID, newFish)
            Osi.CharacterStatusText(charGUID, TSK.Notification_Bait_Used:GetString())
            Osi.ItemTemplateRemoveFromParty(item.CurrentTemplate.Id, charGUID, 1)
        else -- Show hint for needing to be near water
            Osi.CharacterStatusText(charGUID, TSK.Notification_Bait_NotNearWater:GetString())
        end
    end
end)