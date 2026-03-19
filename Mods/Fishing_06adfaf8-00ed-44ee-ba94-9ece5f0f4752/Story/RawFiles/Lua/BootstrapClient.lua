
-- Check if Epip is loaded
if not Ext.Mod.IsModLoaded("7d32cb52-1cfd-4526-9b84-db4867bf9356") then
    Ext.Utils.ShowErrorAndExitGame("The Fishing mod requires Epip. See the website for installation instructions.<br>https://www.pinewood.team/epip/")
    return
end

-- Import Epip and check version
local EpipMod = Mods["EpipEncounters"]
local Epip = EpipMod.Epip ---@type Epip
if Epip.VERSION < 1075 then
    Ext.Utils.ShowErrorAndExitGame("The Fishing mod requires Epip v1076 or higher. Please update!<br>https://www.pinewood.team/epip/")
    return
end
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
            "Fishing/Data/Regions/LadyVengeance.lua",
            "Fishing/Data/Regions/ReapersCoast.lua",
            "Fishing/Data/Regions/NamelessIsle.lua",
            "Fishing/Data/Regions/Arx.lua",
            "Fishing/Data/TreasureChests.lua",

            "Fishing/Client_UI.lua",
            "Fishing/GameObjects/_GameObject.lua",
            "Fishing/GameObjects/Capturable.lua",
            "Fishing/GameObjects/States/_State.lua",
            "Fishing/GameObjects/States/Floating.lua",
            "Fishing/GameObjects/States/Sinking.lua",
            "Fishing/GameObjects/States/Tweening.lua",
            "Fishing/GameObjects/Fish.lua",
            "Fishing/GameObjects/TreasureChest.lua",
            "Fishing/GameObjects/Bobber.lua",

            "Fishing/Client_CharacterTask.lua",
            "Fishing/CharacterSheet.lua",
            "Fishing/CollectionLog.lua",

            "Fishing/GenerateStats.lua",
        }
    },
    {ScriptSet = "Fishing/Runes"},
    {ScriptSet = "Fishing/Skills"},
    {ScriptSet = "Fishing/Trader"},
    "Fishing/Tooltips/Client.lua",
    "Fishing/ControllerSupportWarning/Client.lua",
}
for _,script in ipairs(scripts) do
    RequestScriptLoad(script)
end
