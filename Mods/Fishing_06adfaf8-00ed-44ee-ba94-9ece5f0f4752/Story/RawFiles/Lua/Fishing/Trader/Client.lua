
local CollectionLog = GetFeature("Fishing.CollectionLog")
local Notification = Client.UI.Notification
local Input = Client.Input

---@class Fishing.Trader
local Trader = GetFeature("Fishing.Trader")

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Open the Codex when requested from dialogue and show hint for its keybind.
Net.RegisterListener(Trader.NETMSG_OPEN_CODEX, function (_)
    CollectionLog.Show()

    -- Show keybind hint
    local action = CollectionLog.InputActions.OpenCollectionLog
    local keybind = Input.GetActionBindings(action.ID)[1]
    if keybind then
        local label = CollectionLog.TranslatedStrings.Notification_KeybindHint:Format(Input.StringifyBinding(keybind))
        Notification.ShowNotification(label)
    end
end)
