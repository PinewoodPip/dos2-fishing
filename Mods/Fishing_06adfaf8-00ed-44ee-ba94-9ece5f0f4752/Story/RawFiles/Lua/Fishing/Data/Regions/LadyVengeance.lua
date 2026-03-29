
local V = Vector.Create

local Fishing = GetFeature("Fishing")
local Regions = GetFeature("Fishing.Regions")
local CAPACITY = Regions.REGION_CAPACITIES

---Utility method to register translated strings for a region.
local T = function(tsk)
    local tskEntry = Fishing:RegisterTranslatedString(tsk)
    tskEntry.ContextDescription = "Fishing region name"
    return tskEntry.Handle
end

---@type Fishing.Region[]
local regions = {
    {
        ID = "LV.Act1ToAct2",
        IsSecret = true,
        NameHandle = T{
            Handle = "h17a1e689g9c54g493ega0c9g7c1a457fbf97",
            Text = "Reaper's Eye High Seas",
        },
        LevelID = "LV_HoE_Main",
        Bounds = V(529, 575, 670, 510),
        FishingAreas = {
            -- North
            V(531, 553, 653, 576),
            -- South
            V(531, 500, 653, 522),
        },
        Capacity = CAPACITY.HIGH,
        Fish = {
            {
                ID = "Piranha",
                Weight = 1,
            },
            {
                ID = "Seaweed",
                Weight = 0.8,
            },
            {
                ID = "SeaPickle",
                Weight = 0.4,
            },
            {
                ID = "Eel",
                Weight = 0.3,
            },
            {
                ID = "Pearl",
                Weight = 0.2,
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