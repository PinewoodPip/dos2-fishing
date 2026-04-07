
local Fishing = GetFeature("Fishing") ---@class Fishing

---@class Fishing.Rods :Feature
local Rods = {
    DEFAULT_BOBBER = {
        NormalColor = Color.CreateFromHex(Color.LARIAN.POISON_GREEN),
        HighlightColor = Color.CreateFromHex(Color.LARIAN.GREEN),
    },

    ROD_REEL_IN_COOLDOWN_REDUCTION = 1, -- Cooldown reduction for Reel In with a rod equipped, in turns.

    ---@type table<string, Fishing.Rod>
    _Rods = {},
    _VisualTemplateToRodID = {}, ---@type table<GUID, Fishing.RodID>
    _RootTemplateToRodID = {}, ---@type table<GUID, Fishing.RodID>

    TranslatedStrings = {
        Perk_ReelInCooldownReduction = {
            Handle = "h33f04487g232dg4fe5g8090ga699a730bc16",
            Text = "-%d turn cooldown to Reel In",
            ContextDescription = [[Tooltip for fishing rod bonus; param is cooldown reduction]],
        },
    },
}
RegisterFeature("Fishing.Rods", Rods)
Fishing.Rods = Rods

---------------------------------------------
-- CLASSES
---------------------------------------------

---@alias Fishing.RodID string

---@class Fishing.Rod
---@field ID Fishing.RodID
---@field Name TextLib_TranslatedString
---@field Description TextLib_TranslatedString
---@field RootTemplate GUID.ItemTemplate
---@field VisualTemplate GUID
---@field Bobber Fishing.BobberColor? Defaults to `DEFAULT_BOBBER`

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns the descriptor for the fishing rod equipped by char, if any.
---@param char Character
---@return Fishing.Rod? -- `nil` if char has no fishing rod equipped.
function Rods.GetEquippedRod(char)
    local rodItem = Item.GetEquippedItem(char, "Weapon") or Item.GetEquippedItem(char, "Shield")
    if not rodItem then return nil end
    local visualTemplate = rodItem.CurrentTemplate.VisualTemplate
    return Rods.GetByVisualTemplate(visualTemplate)
end

---Returns the bobber descriptor of char's fishing rod, if they have one equipped.
---@param char Character
---@return Fishing.BobberColor? -- `nil` if the character has no fishing rod equipped.
function Rods.GetBobber(char)
    local rod = Rods.GetEquippedRod(char)
    if not rod then return nil end
    return rod.Bobber or Rods.DEFAULT_BOBBER
end

---Returns a rod by its ID, or from an item.
---@param id Fishing.RodID|Item
---@return Fishing.Rod
function Rods.GetRod(id)
    local rod = nil
    if type(id) ~= "string" then -- Item overload.
        rod = Rods.GetByVisualTemplate(id.CurrentTemplate.VisualTemplate) or Rods.GetByRootTemplate(id.CurrentTemplate.Id)
    else
        rod = Rods._Rods[id]
    end
    return rod
end

---Returns a rod by its visual template.
---@param visualTemplate GUID
---@return Fishing.Rod? -- `nil` if the template does not correspond to a rod.
function Rods.GetByVisualTemplate(visualTemplate)
    local rodID = Rods._VisualTemplateToRodID[visualTemplate]
    return rodID and Rods.GetRod(rodID) or nil
end

---Returns a rod by its root template.
---@param rootTemplate GUID.ItemTemplate
---@return Fishing.Rod? -- `nil` if the template does not correspond to a rod.
function Rods.GetByRootTemplate(rootTemplate)
    local rodID = Rods._RootTemplateToRodID[rootTemplate]
    return rodID and Rods.GetRod(rodID) or nil
end

---Returns all registered rods.
---@return table<string, Fishing.Rod>
function Rods.GetAllRods()
    return Rods._Rods
end

---Registers a fishing rod.
---@param rod Fishing.Rod
function Rods.RegisterRod(rod)
    Rods._Rods[rod.ID] = rod
    Rods._RootTemplateToRodID[rod.RootTemplate] = rod.ID
    Rods._VisualTemplateToRodID[rod.VisualTemplate] = rod.ID
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Mark items with rod root/visual templates as fishing rods.
-- Visual template check covers various locally-placed rods in Origins levels (which were seemingly *not* created from the root templates).
Fishing.Hooks.IsFishingRod:Subscribe(function (ev)
    local template = ev.Item.RootTemplate
    if Rods.GetByVisualTemplate(template.VisualTemplate) or Rods.GetByRootTemplate(template.Id) then
        ev.IsFishingRod = true
    end
end, {StringID = "DefaultImplementation"})
