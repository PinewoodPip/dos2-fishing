
-- Import Epip
local EpipMod = Mods["EpipEncounters"]
local Epip = EpipMod.Epip ---@type Epip
Epip.ImportGlobals(_ENV)

Ext.Require("BootstrapShared.lua")

-- Load scripts
local scripts = {
    {
        ScriptSet = "Fishing",
        Scripts = {
            "Fishing/FishBehaviours.lua",
            "Fishing/Data/Fish.lua",
            "Fishing/Data/Regions/FortJoy.lua",
            "Fishing/Data/Regions/ReapersCoast.lua",
        }
    },
    {ScriptSet = "Fishing/Runes"},
    {
        ScriptSet = "Fishing/Skills",
        Scripts = {
            "Fishing/Skills/Scripts/BlueFireball.lua",
            "Fishing/Skills/Scripts/BlowTheHornPipe.lua",
            "Fishing/Skills/Scripts/Sashimi.lua",
            "Fishing/Skills/Scripts/ReelIn.lua",
        }
    },
}
for _,script in ipairs(scripts) do
    RequestScriptLoad(script)
end
