GMOD_DEBUGGER.logs.error = {}

if CLIENT then
    if GMOD_DEBUGGER.config.client then
        include("gmod-debugger/modules/error/client.lua")
    end
elseif SERVER then
    if GMOD_DEBUGGER.config.error.client then
        AddCSLuaFile("gmod-debugger/modules/error/client.lua")
    elseif GMOD_DEBUGGER.config.error.server then
        include("gmod-debugger/modules/error/server.lua")
    end
end
