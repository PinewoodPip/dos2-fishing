
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
            "Fishing/Shared_Data.lua",

            "Fishing/Client_UI.lua",
            "Fishing/GameObjects/_GameObject.lua",
            "Fishing/GameObjects/States/_State.lua",
            "Fishing/GameObjects/States/Floating.lua",
            "Fishing/GameObjects/States/Sinking.lua",
            "Fishing/GameObjects/States/Tweening.lua",
            "Fishing/GameObjects/Fish.lua",
            "Fishing/GameObjects/Bobber.lua",

            "Fishing/Client_CollectionLogUI.lua",

            "Fishing/Client_CharacterTask.lua",
        }
    },
}
for _,script in ipairs(scripts) do
    RequestScriptLoad(script)
end
