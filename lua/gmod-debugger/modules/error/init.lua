if CLIENT then
    include("gmod-debugger/modules/error/client.lua")
elseif SERVER then
    GMOD_DEBUGGER:InitModule("error", {
        client = {"Bool", false},
        //clients = {"PlyTbl", {}},
        server = {"Bool", true},
        stack = {"Bool", true},
        post = {"Bool", true}
    })

    AddCSLuaFile("gmod-debugger/modules/error/client.lua")
    include("gmod-debugger/modules/error/server.lua")
end
