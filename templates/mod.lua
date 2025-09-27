-- {{MODNAME_CLASS}}.lua
--[[
    Mod Initialization Template for Kingdom Come: Deliverance II
    Generated with VS Code Extension

    Mod Name: {{MODNAME_CLASS}}
    Author: <Your Name Here>
    Version: 0.1.0
    Namespace / Table: {{MODNAME_CLASS}}
    Description: Initializes the mod, loads all scripts, sets default config, 
                 and registers events and menu integration.
--]]

------------------------------------------------------------
-- Register the mod with KCDUtils
-- Creates the namespace/table {{MODNAME_CLASS}} and initializes
-- Logger, DB, Config, Events, and other utilities
------------------------------------------------------------
local mod = KCDUtils.RegisterMod({ Name = "{{MODNAME_FOLDER}}" })

-- Export globally (optional)
-- Makes the mod accessible from other scripts
{{MODNAME_CLASS}} = mod

------------------------------------------------------------
-- Load all supporting scripts from the mod folder
-- Use ScriptLoader to recursively include all Lua files
------------------------------------------------------------
ScriptLoader.LoadFolder("Scripts/Mods/{{MODNAME_FOLDER}}")

------------------------------------------------------------
-- Initialize the in-game configuration
-- Copies default values from the helper config table
------------------------------------------------------------
mod.Config = {}
for k, v in pairs({{MODNAME_CLASS}}Config.defaultConfig) do
    mod.Config[k] = v
end

------------------------------------------------------------
-- Register the menu configuration with KCDUtils
-- Provides in-game UI to adjust mod settings
------------------------------------------------------------
KCDUtils.Menu.RegisterMod(mod, {{MODNAME_CLASS}}Config.menuConfigTable)

------------------------------------------------------------
-- Event triggered when gameplay starts
-- Loads saved configuration from the database
-- and shows a notification in-game
------------------------------------------------------------
mod.OnGameplayStarted = function()
    KCDUtils.Config.LoadFromDB(mod.Name, mod.Config)
    KCDUtils.UI.ShowNotification("@ui_notification_{{MODNAME_FOLDER}}_loaded")

    --------------------------------------------------------
    -- Call any additional mod-specific startup logic here
    --------------------------------------------------------
    {{MODNAME_CLASS}}:DoMoreStuff()
end
