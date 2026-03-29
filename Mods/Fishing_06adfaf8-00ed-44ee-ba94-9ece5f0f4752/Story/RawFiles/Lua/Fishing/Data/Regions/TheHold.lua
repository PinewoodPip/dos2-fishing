
local V = Vector.Create

local Fishing = GetFeature("Fishing")

---Utility method to register translated strings for a region.
local T = function(tsk)
    local tskEntry = Fishing:RegisterTranslatedString(tsk)
    tskEntry.ContextDescription = "Fishing region name"
    return tskEntry.Handle
end

---@type Fishing.Region[]
local regions = {
    {
        ID = "TUT.TheHold",
        IsSecret = true,
        NameHandle = T({
            Handle = "h5b69eddbg13bag4ecaga2d8g67a510ce7d08",
            Text = "The Stormy Seas",
        }),
        LevelID = "TUT_Tutorial_A",
        Bounds = V(-22, 59, 81, 6),
        FishingAreas = {
            -- North
            V(-29, 38, 80, 55),
            V(-24, 34, -6, 42), -- Corner on the west
            -- South
            V(-29, 1, 64, 13),
            V(-27, 7, -5, 14), -- Corner on the west
        },
        Fish = {
            {
                ID = "Piranha",
                Weight = 1,
            },
            {
                ID = "GenericVoidwoken",
                Weight = 0.8,
            },
            {
                ID = "Nightfarer",
                Weight = 0.4,
            },
        },
    },
}
for _,region in ipairs(regions) do
    local bounds = region.Bounds

    -- Set the bounds to use width/height for 3rd and 4th element, instead of coords.
    bounds[3] = bounds[3] - bounds[1]
    bounds[4] = bounds[2] - bounds[4]
    if region.FishingAreas then
        for _,area in ipairs(region.FishingAreas) do
            area[3] = area[3] - area[1]
            area[4] = area[4] - area[2]
        end
    end

    Fishing.RegisterRegion(region)
end