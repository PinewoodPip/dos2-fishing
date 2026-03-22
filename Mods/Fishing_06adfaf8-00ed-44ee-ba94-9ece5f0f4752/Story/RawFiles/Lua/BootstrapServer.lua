
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
            "Fishing/Data/Regions/LadyVengeance.lua",
            "Fishing/Data/Regions/ReapersCoast.lua",
            "Fishing/Data/Regions/NamelessIsle.lua",
            "Fishing/Data/Regions/Arx.lua",
            "Fishing/Data/TreasureChests.lua",
        }
    },
    {ScriptSet = "Fishing/Runes"},
    {
        ScriptSet = "Fishing/Skills",
        Scripts = {
            "Fishing/Skills/Scripts/Seaburn.lua",
            "Fishing/Skills/Scripts/BlueFireball.lua",
            "Fishing/Skills/Scripts/BlowTheHornPipe.lua",
            "Fishing/Skills/Scripts/Sashimi.lua",
            "Fishing/Skills/Scripts/ReelIn.lua",
            "Fishing/Skills/Scripts/CannonBall.lua",
            "Fishing/Skills/Scripts/TurnOnTheTides.lua",
            "Fishing/Skills/Scripts/DeployFishnets.lua",
        }
    },
    {Script = "Fishing/Skills/Shared_EE.lua", RequiresEE = true},
    {ScriptSet = "Fishing/Trader"},
}
for _,script in ipairs(scripts) do
    RequestScriptLoad(script)
end
