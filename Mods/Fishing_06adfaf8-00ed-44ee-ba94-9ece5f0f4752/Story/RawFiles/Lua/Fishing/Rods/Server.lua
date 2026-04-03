
---@class Fishing.Rods
local Rods = GetFeature("Fishing.Rods")

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Cheat to add all fishing rods.
Ext.RegisterConsoleCommand("fishaddrods", function (_)
    local charGUID = Osi.CharacterGetHostCharacter()
    for _,rod in pairs(Rods._Rods) do
        Osi.ItemTemplateAddTo(rod.RootTemplate, charGUID, 1, 1)
    end
end)
