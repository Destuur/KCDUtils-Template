-- {{MODNAME_CLASS}}.lua (alles in einer Datei)
--[[ 
    Mod Template for Kingdom Come: Deliverance II
    Generated with VS Code Extension

    Mod Name: {{MODNAME_CLASS}}
    Author: <Your Name Here>
    Version: 0.1.0
    Namespace / Table: {{MODNAME_CLASS}}
    Description: Template mod integrating with KCDUtils for config, menu, and events.
--]]

------------------------------------------------------------
-- Register the mod with KCDUtils
-- Creates the namespace/table {{MODNAME_CLASS}} and initializes
-- Logger, DB, Config, Events, and other utilities
------------------------------------------------------------
local mod = KCDUtils.RegisterMod({ Name = "{{MODNAME_FOLDER}}" })

------------------------------------------------------------
-- Default in-game configuration
-- Add your mod-specific settings here
------------------------------------------------------------
mod.Config = {
    firstSetting  = false,       -- Example boolean setting
    secondSetting = 5,           -- Example numeric setting
    thirdSetting  = "option1"    -- Example choice/string setting
}

------------------------------------------------------------
-- Menu configuration for KCDUtils menu system
-- Supports "value" and "choice" types, with optional valueMap
-- for boolean/string mapping
------------------------------------------------------------
local menuConfig = {
    {
        key       = "firstSetting",
        type      = "choice",
        choices   = {"No","Yes"},
        valueMap  = {false,true},
        default   = mod.Config.firstSetting,
        tooltip   = "Enable/disable first setting"
    },
    {
        key       = "secondSetting",
        type      = "value",
        min       = 1,
        max       = 10,
        default   = mod.Config.secondSetting,
        tooltip   = "Set second setting"
    },
    {
        key       = "thirdSetting",
        type      = "choice",
        choices   = {"option1","option2","option3"},
        valueMap  = {"option1","option2","option3"},
        default   = mod.Config.thirdSetting,
        tooltip   = "Choose third setting"
    }
}
KCDUtils.Menu.RegisterMod(mod, menuConfig)

------------------------------------------------------------
-- Shortcuts for easier access to Logger, DB, and Config
------------------------------------------------------------
local log    = mod.Logger
local db     = mod.DB
local config = mod.Config

------------------------------------------------------------
-- Event triggered whenever the in-game configuration menu changes
-- Updates internal config and persists values via KCDUtils
------------------------------------------------------------
mod.On.MenuChanged = function(newConfig)
    for k, cfg in pairs(newConfig) do
        if cfg._selectedIndex then
            config[k] = cfg.valueMap[cfg._selectedIndex + 1]
        else
            config[k] = cfg.value
        end
    end
    KCDUtils.Config.SaveAll(mod.Name, config)
end

------------------------------------------------------------
-- Event triggered when gameplay starts
-- The player is fully in control at this point
------------------------------------------------------------
mod.OnGameplayStarted = function()
    KCDUtils.Config.LoadFromDB(mod.Name, config)
    KCDUtils.UI.ShowNotification("{{MODNAME_CLASS}} initialized!")
end

------------------------------------------------------------
--- Example console command function
--- This can be bound via KCD2Keybinders using the annotations below.
------------------------------------------------------------
local function exampleFunction()
    KCDUtils.UI.ShowReputationGained("KCDUtils approves!")
end

------------------------------------------------------------
--- Binding annotations for KCD2 Keybinder integration
--- -@bindingCommand defines the console command string 
---   that should be mapped to a keybind.
--- -@bindingMap specifies the context in which the keybind
---   will be active (e.g. movement, player, ui).
------------------------------------------------------------
--- @bindingCommand {{MODNAME_FOLDER}}_your_command
--- @bindingMap movement
KCDUtils.Command.AddFunction("{{MODNAME_FOLDER}}", "your_command", exampleFunction, "Message on entering command in console.")

------------------------------------------------------------
--- ########################################################
--- #                                                      #
--- #               Your Code Ends Here                   #
--- #                                                      #
--- ########################################################
------------------------------------------------------------

------------------------------------------------------------
-- Export globally (optional)
-- Makes the mod accessible from other scripts
------------------------------------------------------------
{{MODNAME_CLASS}} = mod
