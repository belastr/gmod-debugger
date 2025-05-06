GMOD_DEBUGGER = istable(GMOD_DEBUGGER) && GMOD_DEBUGGER || {}
GMOD_DEBUGGER.logs = GMOD_DEBUGGER.logs || {}
GMOD_DEBUGGER.options = GMOD_DEBUGGER.options || {}

if CLIENT then
    surface.CreateFont("GModDebuggerFont", {
        font = "Arial",
        size = 14,
    })
    surface.CreateFont("GModDebuggerFontBold", {
        font = "Arial",
        size = 14,
        weight = 700,
    })
    surface.CreateFont("GModDebuggerFontHead", {
        font = "Arial",
        size = 17,
        weight = 700,
    })
    surface.CreateFont("GModDebuggerFontTitle", {
        font = "Arial",
        size = 25,
        weight = 700,
    })

    for _, f in ipairs(file.Find("gmod-debugger/derma/*.lua", "LUA")) do
        include("gmod-debugger/derma/" .. f)
    end
    include("gmod-debugger/access.lua")
    include("gmod-debugger/menu.lua")
elseif SERVER then
    resource.AddWorkshop("3477086034")

    for _, f in ipairs(file.Find("gmod-debugger/derma/*.lua", "LUA")) do
        AddCSLuaFile("gmod-debugger/derma/" .. f)
    end
    AddCSLuaFile("gmod-debugger/access.lua")
    AddCSLuaFile("gmod-debugger/menu.lua")
    include("gmod-debugger/access.lua")
    include("gmod-debugger/menu_networking.lua")
    include("gmod-debugger/chat_commands.lua")
end
