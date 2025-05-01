if CLIENT then
    include("gmod-debugger/modules/error/client.lua")
    include("gmod-debugger/modules/error/derma/log.lua")
elseif SERVER then
    GMOD_DEBUGGER:InitModule("error", {
        client = {"Bool", false},
        clients = {"Plys", {}},
        logfiles = {"Bool", false},
        server = {"Bool", true},
        stack = {"Bool", true},
        post = {"Bool", false}
    })

    AddCSLuaFile("gmod-debugger/modules/error/client.lua")
    AddCSLuaFile("gmod-debugger/modules/error/derma/log.lua")
    include("gmod-debugger/modules/error/server.lua")
end
