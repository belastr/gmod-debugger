net.Receive("gmod-debugger:menu", function()
    local frame = vgui.Create("DebuggerFrame")
end)

function GMOD_DEBUGGER:RequestConfig()
    net.Start("gmod-debugger:config")
    net.SendToServer()
end

net.Receive("gmod-debugger:config", function(len)
    local configData = net.ReadData(len / 8)
    GMOD_DEBUGGER.config = util.JSONToTable(util.Decompress(configData), false, true)
    
    for _, mod in ipairs(GMOD_DEBUGGER.config.enabledModules) do
        include("gmod-debugger/modules/" .. mod .. "/init.lua")
    end
end)
