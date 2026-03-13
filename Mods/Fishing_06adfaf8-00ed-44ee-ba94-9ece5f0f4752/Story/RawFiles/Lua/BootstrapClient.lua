
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
            "Fishing/Data/Regions/NamelessIsle.lua",
            "Fishing/Data/Regions/Arx.lua",

            "Fishing/Client_UI.lua",
            "Fishing/GameObjects/_GameObject.lua",
            "Fishing/GameObjects/States/_State.lua",
            "Fishing/GameObjects/States/Floating.lua",
            "Fishing/GameObjects/States/Sinking.lua",
            "Fishing/GameObjects/States/Tweening.lua",
            "Fishing/GameObjects/Fish.lua",
            "Fishing/GameObjects/Bobber.lua",

            "Fishing/Client_CharacterTask.lua",
            "Fishing/CharacterSheet.lua",
            "Fishing/CollectionLog.lua",

            "Fishing/GenerateStats.lua",
        }
    },
    {ScriptSet = "Fishing/Runes"},
    {ScriptSet = "Fishing/Skills"},
}
for _,script in ipairs(scripts) do
    RequestScriptLoad(script)
end
