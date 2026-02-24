
Mod.GUIDS.FISHING = "06adfaf8-00ed-44ee-ba94-9ece5f0f4752"

local PREFIXED_GUID = "Fishing_06adfaf8-00ed-44ee-ba94-9ece5f0f4752"
local EE_CORE_GUID = "63bb9b65-2964-4c10-be5b-55a63ec02fa0"

---Returns whether a script load request can be fulfilled.
---@param request ScriptLoadRequest
---@return boolean
local function CanLoadRequest(request)
    local canLoad = false
    if request.WIP then
        if Epip.IsDeveloperMode(true) then
            canLoad = true
        end
    elseif request.Developer then
        if Epip.IsDeveloperMode() then
            canLoad = true
        end
    else
        canLoad = true
    end

    if request.RequiresEE then
        canLoad = canLoad and Ext.Mod.IsModLoaded(EE_CORE_GUID)
    end

    if request.GameModes then
        local gameMode = Ext.GetGameMode()
        local index = GAMEMODE_MASK[gameMode]

        canLoad = canLoad and ((request.GameModes & index) ~= 0)
    end

    for _,guid in ipairs(request.RequiredMods or {}) do -- Check mod requirements
        canLoad = canLoad and Ext.Mod.IsModLoaded(guid)
        if not canLoad then break end
    end
    return canLoad
end

---Requests a script to be loaded.
---@param script ScriptLoadRequest|string
---@return any --Only for simple requests (string).
function RequestScriptLoad(script)
    if type(script) == "table" and CanLoadRequest(script) then
        if script.ScriptSet then
            local contextSpecificScript = "/Client.lua"
            if Ext.IsServer() then
                contextSpecificScript = "/Server.lua"
            end

            Ext.Require(PREFIXED_GUID, script.ScriptSet .. "/Shared.lua")
            Ext.Require(PREFIXED_GUID, script.ScriptSet .. contextSpecificScript)
        elseif script.Script then
            Ext.Require(PREFIXED_GUID, script.Script)
        end

        for _,subScript in ipairs(script.Scripts or {}) do
            RequestScriptLoad(subScript)
        end
    elseif type(script) == "string" then
        return Ext.Require(PREFIXED_GUID, script)
    end
end