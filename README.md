# gmod-debugger
A debugger tool with mainly in-game menus and lots of configuration. There are seperated modules that all aim to collect valuable information to then be accessible immediately in-game with options to also extract the information.

## Core Modules
- Errors (serverside, all clients, selected client)
- Net Messages (serverside, local client, selected client)
- Performance (server tickrate, client fps)
- Content Issues (server models, client models/materials/sounds)

## Examples
(coming soon)

## Usage
In-game: say /gmod-debugger to open the main menu
From Console (generating log files only): see console commands (coming soon)

## Installation
1. Download one of the releases.
2. Put the gmod-debugger folder into garrysmod/addons.
3. Create a gmod-debugger directory in garrysmod/data and put the config.json inside.
4. (You can do some config in the json file directly, but all configuration is always available in-game)
5. You are all set.

The debugger can be turned off entirely in the autorun init.lua. Simply change the true to false.
