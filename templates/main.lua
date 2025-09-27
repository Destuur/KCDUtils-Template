-- main.lua
--[[
    Main logic template for Kingdom Come: Deliverance II mod
    Generated with VS Code Extension

    Mod Name: {{MODNAME_CLASS}}
    Namespace / Table: {{MODNAME_CLASS}}
    Description: Handles in-game logic, menu events, and notifications.
--]]

------------------------------------------------------------
-- Ensure the global mod table exists
-- {{MODNAME_CLASS}} acts as both namespace and mod object
------------------------------------------------------------
{{MODNAME_CLASS}} = {{MODNAME_CLASS}} or {}

-- Shortcuts for convenience
local mod    = {{MODNAME_CLASS}}
local config = mod and mod.Config
local db     = mod and mod.DB
local log    = mod and mod.Logger

------------------------------------------------------------
-- Event: called when the in-game configuration menu changes
-- This updates the config and triggers mod-specific logic
------------------------------------------------------------
mod.OnMenuChanged:Add(function(newConfig)
    -- Update internal config values
    {{MODNAME_CLASS}}Config.OnMenuChanged(mod, newConfig)

    -- Optional: trigger custom mod logic after config change
    {{MODNAME_CLASS}}:DoStuff()
end)

------------------------------------------------------------
-- Example function: perform an action in-game
-- Can be called from events, commands, or other scripts
------------------------------------------------------------
function {{MODNAME_CLASS}}:DoStuff()
    KCDUtils.UI.ShowNotification("Doing stuff in {{MODNAME_CLASS}} mod!")
end

------------------------------------------------------------
-- Another example function, e.g., called on gameplay start
------------------------------------------------------------
function {{MODNAME_CLASS}}:DoMoreStuff()
    KCDUtils.UI.ShowNotification("Doing more stuff in {{MODNAME_CLASS}} mod!")
end