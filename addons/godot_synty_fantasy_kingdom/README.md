# Godot Synty Fantasy Kingdom

This addon helps import and prepare the Synty Fantasy Kingdom asset pack for use in the Godot Engine.

## Installation

Before enabling this addon, perform the following steps:

1. Locate your copy of the **Synty Fantasy Kingdom** source files.
2. Copy the `Source_Files` folder to the `godot_synty_fantasy_kingdom` folder.
3. Enable the plugin.
4. Optionally, add a `.gdignore` file to your `Source_Files` folder.
    
    > As the source files should not change, you can hide them from the Godot Engine after the initial import.

## Known issues

- The Synty source files beginning with `SK_` are currently not supported.
- Custom shader materials are not currently not supported
- Repeated re-enabling of the plugin causes Godot to freeze and crash.
