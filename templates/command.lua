-- {{MODNAME_CLASS}} command.lua
--[[
    Command functions template for Kingdom Come: Deliverance II
    Generated with VS Code Extension

    Mod Name: {{MODNAME_CLASS}}
    Namespace / Table: {{MODNAME_CLASS}}
    Description: Handles console commands and binds them for KCD2 keybinder integration.
--]]

------------------------------------------------------------
-- Ensure the global mod table exists
------------------------------------------------------------
{{MODNAME_CLASS}} = {{MODNAME_CLASS}} or {}

------------------------------------------------------------
-- Local helper: retrieves mod, config, db, log safely
-- This prevents repeated nil-checks in command functions
------------------------------------------------------------
local function GetModStuff()
    local mod = {{MODNAME_CLASS}}
    if not mod then return nil, nil, nil, nil end
    local config = mod.Config
    local db     = mod.DB
    local log    = mod.Logger
    return mod, config, db, log
end

------------------------------------------------------------
-- Example console command functions
-- These functions will be bound to in-game commands
------------------------------------------------------------

local function showStatus()
    local mod, config, db, log = GetModStuff()
    if not config or not log then return end

    log:Info("{{MODNAME_CLASS}} Mod Status:")
    for k,v in pairs(config) do
        log:Info("  " .. k .. ": " .. tostring(v))
    end
end

local function resetConfig()
    local mod, config, db, log = GetModStuff()
    if not config or not db or not log or not mod then return end

    log:Info("Resetting {{MODNAME_CLASS}} configuration to defaults.")
    for k,v in pairs({{MODNAME_CLASS}}Config.defaultConfig) do
        config[k] = v
    end

    KCDUtils.Config.SaveAll(mod.Name, config)
    KCDUtils.Menu.BuildWithDB(mod)
    KCDUtils.UI.ShowNotification("@ui_{{MODNAME_FOLDER}}_config_reset")
    log:Info("{{MODNAME_CLASS}} configuration reset to defaults.")
end

local function printHelp()
    local mod, config, db, log = GetModStuff()
    if not log then return end

    log:Info("{{MODNAME_CLASS}} Mod Commands:")
    log:Info("  {{MODNAME_FOLDER}}_show_status - Show current config")
    log:Info("  {{MODNAME_FOLDER}}_reset       - Reset config to defaults")
    log:Info("  {{MODNAME_FOLDER}}_help        - Show command help")
end

------------------------------------------------------------
-- Binding annotations for KCD2 Keybinder integration
-- @bindingCommand defines the console command string
-- @bindingMap specifies the context in which the keybind is active
------------------------------------------------------------
--- @bindingCommand {{MODNAME_FOLDER}}_show_status
--- @bindingMap movement
KCDUtils.Command.AddFunction("{{MODNAME_FOLDER}}", "show_status", showStatus, "Show current configuration and status")
KCDUtils.Command.AddFunction("{{MODNAME_FOLDER}}", "reset", resetConfig, "Reset configuration to defaults")
KCDUtils.Command.AddFunction("{{MODNAME_FOLDER}}", "help", printHelp, "Show command help")
