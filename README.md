# gmod-debugger
A debugger tool with mainly in-game menus and lots of configuration. There are seperated modules that all aim to collect valuable information to then be accessible immediately in-game with options to also extract the information.

## Modules
- Errors (serverside, all clients, selected client)
- Net Messages (serverside, selected client)
- Performance (server tickrate, clients average fps)

## Planned Modules
- SQL/Database (serverside)
- Data Files (serverside)
- Console Commands (all clients)

## Examples
(coming soon)

## Usage
In-game: say /gmod-debugger to open the main menu

From Console: (coming soon)

## Installation
1. Download one of the releases.
2. Put the gmod-debugger folder into garrysmod/addons/.
3. (In case you already have made a configuration set: Create a gmod-debugger directory in garrysmod/data/ and put the config.json inside.)
4. You are all set.

The debugger can be turned off entirely in the autorun init.lua. Simply change the true to false.

The generated log files will come out at the created gmod-debugger directory in garrysmod/data/.
