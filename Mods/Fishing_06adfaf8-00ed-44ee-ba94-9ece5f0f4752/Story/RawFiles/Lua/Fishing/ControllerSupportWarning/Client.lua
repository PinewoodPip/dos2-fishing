---------------------------------------------
-- Shows a controller support warning
-- when loading into a session while using a controller.
---------------------------------------------

local MsgBox = Client.UI.MessageBox

---@type Feature
local SupportWarning = {
    TranslatedStrings = {
        MsgBox_ControllerWarning_Header = {
            Handle = "hdbbb471ag86b2g4cf7g812egb18439a6dd10",
            Text = "Fishing Warning",
            ContextDescription = [[Title for controller support message box]],
        },
        MsgBox_ControllerWarning_Body = {
            Handle = "h990c1a63gff39g42f5ga8d1gd47fe4dc6133",
            Text = "The Fishing mod does not currently support controllers.<br>The minigame will not be available.<br>Controller support will be added in a future update.",
            ContextDescription = [[Warning shown when using the mod with a controller]],
        },
    }
}
local TSK = SupportWarning.TranslatedStrings
RegisterFeature("Fishing.SupportWarning", SupportWarning)

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Show controll support warning upon loading into the game.
GameState.Events.ClientReady:Subscribe(function (_)
    if Client.IsUsingController() then
        MsgBox.Open({
            ID = "Fishing.SupportWarning",
            Header = TSK.MsgBox_ControllerWarning_Header:GetString(),
            Message = TSK.MsgBox_ControllerWarning_Body:GetString(),
        })
    end
end)
