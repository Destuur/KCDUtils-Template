# Changelog

## [1.4.0] - 2025-09-21
### Added
- Integration of KCD2 Keybinder annotations (`@bindingCommand` / `@bindingMap`) in the mod template.
  - Automatically generates a unified `keybindSuperactions.xml` for all mods on game start.
  - No manual creation of XML files required for keybindings.
- Config table (`{{MODNAME_CLASS}}.Config`) fully integrated with KCDUtils.RegisterMod.
  - Config is automatically initialized at mod registration.
  - Default values are guaranteed even if no config file exists yet.
- Menu configuration example (`menuConfigTable`) added, demonstrating numeric sliders and choice dropdowns.
- New `ConfigMethods` namespace for clean handling of config:
  - `Load()`, `Save()`, `Dump()` methods to interact with the database and console/log.
- Updated example console command function demonstrating KCDUtils.UI usage with keybinding support.
- Everything split up in different files for more structure.

### Changed
- Template now ensures all Lua files in `{{MODNAME_CLASS}}` folder and subfolders are loaded automatically on mod registration.
- `OnGameplayStarted` now uses the KCDUtils UI functions as example, showing tutorials and hiding existing ones.
- General comments and documentation updated to clarify initialization order, namespace creation, and config handling.


## [1.3.1] - 2025-09-02
### Changed
- Template changes to fit the new namespace structure of KCDUtils


## [1.3.0] - 2025-09-02
### Added
- New feature: create another folder besides `<modName>` with the same name, that holds `config.lua`

### Changed
- The init script got changed, due to changes to `KCDUtils`.
- Scriptloader for easy loading of all additional scripts in the according folder.


## [1.2.0] - 2025-08-29
### Added
- New feature: `git init` directly from the extension, with optional automatic push to a remote repository.

### Changed
- Default workspace location has been updated.
- Path for IntelliSense to KCDUtils has been adjusted for better integration.