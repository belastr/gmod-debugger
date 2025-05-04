GMOD_DEBUGGER = {}
GMOD_DEBUGGER.logs = {}
GMOD_DEBUGGER.options = {}

if CLIENT then
    for _, f in ipairs(file.Find("gmod-debugger/derma/*.lua", "LUA")) do
        include("gmod-debugger/derma/" .. f)
    end
    include("gmod-debugger/access.lua")
    include("gmod-debugger/menu.lua")
elseif SERVER then
    for _, f in ipairs(file.Find("gmod-debugger/derma/*.lua", "LUA")) do
        AddCSLuaFile("gmod-debugger/derma/" .. f)
    end
    AddCSLuaFile("gmod-debugger/access.lua")
    AddCSLuaFile("gmod-debugger/menu.lua")
    include("gmod-debugger/access.lua")
    include("gmod-debugger/menu_networking.lua")
    include("gmod-debugger/chat_commands.lua")
end
