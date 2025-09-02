------------------------------------------------------------
--- Define the main mod table / namespace.
--- This ensures that {{MODNAME_CLASS}} exists and can
--- store all mod-related data and functions.
------------------------------------------------------------
{{MODNAME_CLASS}} = {{MODNAME_CLASS}} or {} -- die Mod-Tabelle

------------------------------------------------------------
--- 1. Config table with default values.
--- Use this table to store mod settings that can be
--- saved and loaded from the database.
--- Example: SomeSetting = "Default Value"
------------------------------------------------------------
{{MODNAME_CLASS}}.Config = {{MODNAME_CLASS}}.Config or {
    SomeSetting = "Default Value",
    AnotherSetting = 42,
    YetAnotherSetting = true
}

------------------------------------------------------------
--- 2. ConfigMethods namespace.
--- All methods that interact with the Config table
--- are grouped here, keeping the main namespace clean.
------------------------------------------------------------
{{MODNAME_CLASS}}.ConfigMethods = {{MODNAME_CLASS}}.ConfigMethods or {}

------------------------------------------------------------
--- Load(): reads saved settings from the database
--- into {{MODNAME_CLASS}}.Config.
------------------------------------------------------------
function {{MODNAME_CLASS}}.ConfigMethods.Load()
    KCDUtils.Core.Config.LoadFromDB("{{MODNAME_CLASS}}", {{MODNAME_CLASS}}.Config)
end

------------------------------------------------------------
--- Save(): writes the current config table to the database.
------------------------------------------------------------
function {{MODNAME_CLASS}}.ConfigMethods.Save()
    KCDUtils.Core.Config.SaveAll("{{MODNAME_CLASS}}", {{MODNAME_CLASS}}.Config)
end

------------------------------------------------------------
--- Dump(): prints the current config table to the console/log
--- for debugging purposes.
------------------------------------------------------------
function {{MODNAME_CLASS}}.ConfigMethods.Dump()
    KCDUtils.Core.Config.Dump("{{MODNAME_CLASS}}")
end

------------------------------------------------------------
--- Initial load of the config when the mod starts.
------------------------------------------------------------
{{MODNAME_CLASS}}.ConfigMethods.Load() -- Initiales Laden der Config
