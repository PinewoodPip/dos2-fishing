
local Fishing = GetFeature("Fishing")

---@class Fishing.Regions : Feature
local Regions = {
    BAIT_TEMPLATE_ID = "e7a7ba01-5789-4470-881e-54b858192ca9",

    FISH_PER_BAIT = 3, -- Amount of fish that are added to the region's pool when bait is used on it.
    BAIT_WATER_SEARCH_RADIUS = 5, -- Search radius for fishable surfaces when using bait, in meters. Should be more generous than the cursor search radius, as the bait check is performed from the character's position.
    FISH_BAIT_RARITY_COLOR = Fishing.ABILITY_SCHOOL_COLOR,

    -- Ranges for the amount of fish that can be found in a region during a spawn cycle.
    REGION_CAPACITIES = {
        LOW = {4, 7},
        MIDDLING = {6, 8},
        DEFAULT = {7, 11},
        HIGH = {13, 17},
    },

    TranslatedStrings = {
        Label_Bait = {
            Handle = "h3cd9d5e1g99fdg4a38g86b7g420dc92c4252",
            Text = "Fish Bait",
            ContextDescription = [[Tooltip footer for bait items]],
        },
        Label_BaitDescription = {
            Handle = "h23fdd504g68abg40b2g8264g1cd59c80bf7f",
            Text = [[A fishy pellet that fish find quite "yum". It has a strange color and texture, almost like an orb. Makes you ponder...]],
            ContextDescription = [[Tooltip for bait item]],
        },
        Label_BaitHint = {
            Handle = "h580af236g3b7fg4af3gb05ege9a9a730990c",
            Text = "Use while standing near water to attract more fish.",
            ContextDescription = [[Tooltip hint for bait item]],
        },
        Notification_Bait_Used = {
            Handle = "h986796b9g3dccg4381g8bc4gd079531d0c73",
            Text = "Here fishy fishy!",
            ContextDescription = [[Overhead text when using bait]],
        },
        Notification_Bait_NotNearWater = {
            Handle = "hc534f656g75c6g4699gb489gc94f862dd0e1",
            Text = "I need to be near water to sprinkle bait.",
            ContextDescription = [[Overhead text when using bait away from water]],
        },
    }
}
RegisterFeature("Fishing.Regions", Regions)

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns whether an item is fishing bait.
---@param item Item
---@return boolean
function Regions.IsBait(item)
    return item.CurrentTemplate.Id == Regions.BAIT_TEMPLATE_ID
end
