
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
        }
    },
}
for _,script in ipairs(scripts) do
    RequestScriptLoad(script)
end
