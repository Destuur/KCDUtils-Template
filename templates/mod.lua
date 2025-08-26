{{MODNAME_CLASS}} = {{MODNAME_CLASS}} or {
    Name = "{{MODNAME_CLASS}}",
    DB = nil,
    Logger = nil,
    Config = nil
}

-- System.LogAlways() because KCDUtils.Logger is not available during initialization
System.LogAlways("{{MODNAME_CLASS}} initializing...")

function {{MODNAME_CLASS}}.Init()
    --------------------------------------------------------
    --- KCDUtils - Mod Initialization
    --------------------------------------------------------
    KCDUtils.RegisterMod({{MODNAME_CLASS}}.Name)
    {{MODNAME_CLASS}}.DB = KCDUtils.DB.Factory({{MODNAME_CLASS}}.Name)
    {{MODNAME_CLASS}}.Logger = KCDUtils.Logger.Factory({{MODNAME_CLASS}}.Name)
    {{MODNAME_CLASS}}.Config = KCDUtils.Config.Factory({{MODNAME_CLASS}}.Name)
    {{MODNAME_CLASS}}.Logger:Info("{{MODNAME_CLASS}} initialized")


    --------------------------------------------------------
    --- KCDUtils - Mod Configuration
    --------------------------------------------------------
    {{MODNAME_CLASS}}.Config:SetDefaults({                                   -- Sets default values for the configuration
        SomeSetting = "Default Value",
        AnotherSetting = 42,
        YetAnotherSetting = true
    })
    {{MODNAME_CLASS}}.Config:Load()                                          -- Loads existing configuration from DB, if DB fails gets values from defaults
                                                                    -- This ensures that all configuration values are available in `{{MODNAME_CLASS}}.Config.Values`
    {{MODNAME_CLASS}}.Config:SetAll()                                        -- Sets all configuration values to the DB.
                                                                    -- The next Config:Load() will get values from the DB
    for key, value in pairs({{MODNAME_CLASS}}.Config.Values) do              -- Logs all configuration values
        {{MODNAME_CLASS}}.Logger:Info(key .. ": " .. tostring(value))
    end


    --------------------------------------------------------
    --- KCDUtils - Mod Logging
    --------------------------------------------------------
    {{MODNAME_CLASS}}.Logger:Log("{{MODNAME_CLASS}} configuration defaults set.")
    {{MODNAME_CLASS}}.Logger:Info("SomeSetting: " .. tostring({{MODNAME_CLASS}}.Config:Get("SomeSetting")))
    {{MODNAME_CLASS}}.Logger:Warn("This is a warning message.")
    {{MODNAME_CLASS}}.Logger:Error("This is an error message.")
    {{MODNAME_CLASS}}.Logger:Log("{{MODNAME_CLASS}} initialization complete.")

    --------------------------------------------------------
    --- KCDUtils - Mod Events
    --------------------------------------------------------
    KCDUtils.Event:DefineEvent("{{MODNAME_CLASS}}Initialized", "Event fired when {{MODNAME_CLASS}} is initialized.")
    KCDUtils.Event:Subscribe("{{MODNAME_CLASS}}Initialized", {{MODNAME_CLASS}}.OnGameStart, { modName = {{MODNAME_CLASS}}.Name , once = true })
    KCDUtils.Event:Publish("{{MODNAME_CLASS}}Initialized", { message = "{{MODNAME_CLASS}} has been initialized!" })


    --------------------------------------------------------
    --- KCDUtils - Mod Commands
    --------------------------------------------------------
    KCDUtils.Command.Add({{MODNAME_CLASS}}.Name,"TestCommand", "PrintCommmandMessage(%1, %2)", "Prints the first argument")

    local function MyCommand(param1, param2)
        {{MODNAME_CLASS}}.Logger:Info("P1: " .. tostring(param1) .. ", P2: " .. tostring(param2))
    end
    
    KCDUtils.Command.AddFunction("{{MODNAME_CLASS}}", "TestTwoParams", MyCommand, "Test command with two params")
    

end

-- KCDUtils - Mod Events
function {{MODNAME_CLASS}}.OnGameStart()
    {{MODNAME_CLASS}}.Logger:Log("Game started - OnGameStart event triggered.")
    KCDUtils.Event:Publish("{{MODNAME_CLASS}}GameStarted", { message = "{{MODNAME_CLASS}} has started the game!" })
    KCDUtils.Event:ListEventsByMod({{MODNAME_CLASS}}.Name)
end

-- KCDUtils - Mod Commands
function PrintCommmandMessage(msg1, msg2)
    {{MODNAME_CLASS}}.Logger:Info(msg1)
    {{MODNAME_CLASS}}.Logger:Info(msg2)
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