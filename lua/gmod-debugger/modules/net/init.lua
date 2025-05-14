if CLIENT then
    include("gmod-debugger/modules/net/client.lua")
    include("gmod-debugger/modules/net/derma/log.lua")
elseif SERVER then
    GMOD_DEBUGGER:InitModule("net", {
        client = {"Plys", {}},
        logfiles = {"Bool", false},
        networkStringsBlacklist = {"Strings", {}},
        server = {"Bool", false}
    })

    AddCSLuaFile("gmod-debugger/modules/net/client.lua")
    AddCSLuaFile("gmod-debugger/modules/net/derma/log.lua")
    include("gmod-debugger/modules/net/server.lua")
end
