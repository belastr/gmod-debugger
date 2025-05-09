if CLIENT then
    include("gmod-debugger/modules/performance/client.lua")
    include("gmod-debugger/modules/performance/derma/log.lua")
elseif SERVER then
    GMOD_DEBUGGER:InitModule("performance", {
        client = {"Bool", false},
        clients = {"Plys", {}},
        logfiles = {"Bool", false},
        server = {"Bool", true}
    })

    AddCSLuaFile("gmod-debugger/modules/performance/client.lua")
    AddCSLuaFile("gmod-debugger/modules/performance/derma/log.lua")
    include("gmod-debugger/modules/performance/server.lua")

    util.AddNetworkString("gmod-debugger:performance")
end
