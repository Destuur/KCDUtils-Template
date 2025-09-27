-- {{MODNAME_CLASS}} config.lua
--[[
    Configuration Template for Kingdom Come: Deliverance II
    Generated with VS Code Extension

    Mod Name: {{MODNAME_CLASS}}
    Author: <Your Name Here>
    Version: 0.1.0
    Namespace / Table: {{MODNAME_CLASS}}Config
    Description: Default configuration values and menu integration
                 for the mod. Handles OnMenuChanged events to update
                 in-game configuration.
--]]

------------------------------------------------------------
-- Ensure the config namespace exists
------------------------------------------------------------
{{MODNAME_CLASS}}Config = {{MODNAME_CLASS}}Config or {}

------------------------------------------------------------
-- Default in-game configuration
-- These are copied to mod.Config on initialization
------------------------------------------------------------
{{MODNAME_CLASS}}Config.defaultConfig = {
    firstSetting  = false,      -- Example boolean setting
    secondSetting = 5,          -- Example numeric setting
    thirdSetting  = "option1"   -- Example string/choice setting
}

------------------------------------------------------------
-- Menu configuration for KCDUtils
-- Defines how each setting appears in the in-game UI
-- Supports "choice" (with optional valueMap) and "value" types
------------------------------------------------------------
{{MODNAME_CLASS}}Config.menuConfigTable = {
    {
        key      = "firstSetting",
        type     = "choice",            
        choices  = {"No","Yes"},        
        valueMap = {false,true},        
        default  = {{MODNAME_CLASS}}Config.defaultConfig.firstSetting,
        tooltip  = "@ui_{{MODNAME_FOLDER}}_firstSetting_tooltip"
    },
    {
        key      = "secondSetting",
        type     = "value",             
        min      = 1,
        max      = 10,
        default  = {{MODNAME_CLASS}}Config.defaultConfig.secondSetting,
        tooltip  = "@ui_{{MODNAME_FOLDER}}_secondSetting_tooltip"
    },
    {
        key      = "thirdSetting",
        type     = "choice",            
        choices  = {"option1","option2","option3"},
        valueMap = {"option1","option2","option3"}, 
        default  = {{MODNAME_CLASS}}Config.defaultConfig.thirdSetting,
        tooltip  = "@ui_{{MODNAME_FOLDER}}_thirdSetting_tooltip"
    }
}

------------------------------------------------------------
-- Event handler called whenever the in-game menu changes
-- Updates mod.Config and persists changes via KCDUtils
-- newConfig can be nil (reset) or a table of changed items
------------------------------------------------------------
function {{MODNAME_CLASS}}Config.OnMenuChanged(mod, newConfig)
    if not newConfig then
        -- Reset all values to default
        for key, value in pairs({{MODNAME_CLASS}}Config.defaultConfig) do
            mod.Config[key] = value
        end
    else
        -- Apply changes from the menu
        for _, cfg in ipairs(newConfig) do
            local key = cfg.id
            if cfg.valueMap then
                local index = (cfg._selectedIndex or 0) + 1
                mod.Config[key] = cfg.valueMap[index]
            elseif cfg.value ~= nil then
                mod.Config[key] = cfg.value
            end
        end
    end

    -- Persist changes and rebuild the menu
    KCDUtils.Config.SaveAll(mod.Name, mod.Config)
    KCDUtils.Menu.BuildWithDB(mod)

    --------------------------------------------------------
    -- Optional: add additional reactions to config changes here
    --------------------------------------------------------
end
