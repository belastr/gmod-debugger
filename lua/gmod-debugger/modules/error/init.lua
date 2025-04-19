GMOD_DEBUGGER.logs.error = {}

if !GMOD_DEBUGGER.config.error then
    GMOD_DEBUGGER.config.error = {}
    GMOD_DEBUGGER.config.error.client = false
    GMOD_DEBUGGER.config.error.clients = {}
    GMOD_DEBUGGER.config.error.server = true
    GMOD_DEBUGGER.config.error.post = false
end

if CLIENT then
    if GMOD_DEBUGGER.config.error.client then
        include("gmod-debugger/modules/error/client.lua")
    end
elseif SERVER then
    if GMOD_DEBUGGER.config.error.client then
        AddCSLuaFile("gmod-debugger/modules/error/client.lua")
    elseif GMOD_DEBUGGER.config.error.server then
        include("gmod-debugger/modules/error/server.lua")
    end
end
