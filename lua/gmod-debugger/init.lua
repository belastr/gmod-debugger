GMOD_DEBUGGER = {}
GMOD_DEBUGGER.logs = {}

if CLIENT then
    for _, f in ipairs(file.Find("lua/gmod-debugger/derma/*.lua", "DATA")) do
        AddCSLuaFile("gmod-debugger/derma/" .. f)
        include("gmod-debugger/derma/" .. f)
    end
    AddCSLuaFile("gmod-debugger/menu.lua")
    include("gmod-debugger/menu.lua")
elseif SERVER then
    include("gmod-debugger/menu_networking.lua")
    include("gmod-debugger/chat_commands.lua")
end
