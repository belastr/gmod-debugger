GMOD_DEBUGGER.logs.error = {}

if !GMOD_DEBUGGER.config.error then
    GMOD_DEBUGGER.config.error = {}
    GMOD_DEBUGGER.config.error.client = true
    GMOD_DEBUGGER.config.error.clients = {}
    GMOD_DEBUGGER.config.error.server = true
    GMOD_DEBUGGER.config.error.stack = true
    GMOD_DEBUGGER.config.error.post = false
end

if CLIENT then
    print("including client")
    include("gmod-debugger/modules/error/client.lua")
elseif SERVER then
    AddCSLuaFile("gmod-debugger/modules/error/client.lua")
    include("gmod-debugger/modules/error/server.lua")
end
