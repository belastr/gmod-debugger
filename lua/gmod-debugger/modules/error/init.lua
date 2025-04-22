if CLIENT then
    include("gmod-debugger/modules/error/client.lua")
elseif SERVER then
    GMOD_DEBUGGER:InitModule("error", {
        client = {"bool", false},
        clients = {"plyTbl", {}},
        server = {"bool", true},
        stack = {"bool", true},
        post = {"bool", true}
    })

    AddCSLuaFile("gmod-debugger/modules/error/client.lua")
    include("gmod-debugger/modules/error/server.lua")
end
