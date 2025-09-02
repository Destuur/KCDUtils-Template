--[[
    Mod Template for Kingdom Come: Deliverance II
    Generated with VS Code Extension

    Mod Name: {{MODNAME_CLASS}}
    Author: <Your Name Here>
    Version: 0.1.0
    Main File: {{MODNAME_CLASS}}.lua
    Namespace / Table: {{MODNAME_CLASS}}

    Description:
    This mod was created using the VS Code Modding Template.
    It automatically integrates with KCDUtils for logging, events, and utilities.

    Dependency:
    - Requires "KCDUtils" to be installed and loaded before this mod.
    - When publishing this mod (e.g. Nexus Mods), please mention
      "KCDUtils" as a dependency in your description/readme.

    Usage (example code):
        {{MODNAME_CLASS}}.Logger:Info("Hello World from {{MODNAME_CLASS}}!")
        KCDUtils.Core.Events:RegisterOnGameplayStarted()
--]]

{{MODNAME_CLASS}} = {{MODNAME_CLASS}} or { Name = "{{MODNAME_CLASS}}" }
{{MODNAME_CLASS}}.DB, {{MODNAME_CLASS}}.Logger = KCDUtils.RegisterMod({{MODNAME_CLASS}})


------------------------------------------------------------
--- Automatically loads all Lua scripts inside the folder:
---     Scripts/Mods/{{MODNAME_CLASS}}/
---
--- This allows you to split your mod into multiple files
--- (e.g., config.lua, helpers.lua, features.lua) without
--- having to require them manually.
---
--- Any new .lua file placed in this folder will be loaded
--- at runtime.
------------------------------------------------------------
ScriptLoader.LoadFolder("Scripts/Mods/{{MODNAME_CLASS}}")


------------------------------------------------------------
--- Init is executed once after all scripts of this mod
--- have been loaded successfully.
---
--- Here you can set up your mod, register events, or do
--- any initialization work.
---
--- Note: By calling KCDUtils.Core.Events:RegisterOnGameplayStarted(),
--- the function {{MODNAME_CLASS}}.OnGameplayStarted will
--- automatically be subscribed to the "gameplay started"
--- event and executed when the player enters the game world.
------------------------------------------------------------
function {{MODNAME_CLASS}}.Init()
    {{MODNAME_CLASS}}.Logger:Info("{{MODNAME_CLASS}} initialized.")
    KCDUtils.Core.Events:RegisterOnGameplayStarted()
end


------------------------------------------------------------
--- OnGameplayStarted is triggered once the game world
--- has fully loaded and the player is in control.
---
--- Use this for tasks that require the world to exist
--- (UI modifications, spawning, world state changes, 
--- timers and everything player related).
---
--- In this template, it hides the current tutorial and
--- shows a new one as an example.
------------------------------------------------------------
function {{MODNAME_CLASS}}.OnGameplayStarted()
    KCDUtils.UI.HideCurrentTutorial()
    KCDUtils.UI.ShowTutorial("{{MODNAME_CLASS}} Tutorial")
end


------------------------------------------------------------
---  Kingdom Come: Deliverance II - Modding Template
---  Written by Destuur (not sponsored by Sir Radzig)
---
---  Disclaimer: No horses, villagers, or bathmaids
---  were harmed in the making of this code.
---
---  Remember: If it breaks, blame the Cumans.
------------------------------------------------------------
--- ########################################################
--- #                                                      #
--- #           Your Code Starts Here, brave scribe!       #
--- #   May your stamina never drain mid swordfight :)     #
--- #                                                      #
--- ########################################################
------------------------------------------------------------

{{MODNAME_CLASS}}.Init()