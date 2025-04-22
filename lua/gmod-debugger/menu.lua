net.Receive("gmod-debugger:menu", function()
    local frame = vgui.Create("DebuggerFrame")
end)

function GMOD_DEBUGGER:RequestConfig(init)
    net.Start("gmod-debugger:config")
    if init then
        net.WriteBit(1)
    end
    net.SendToServer()
end

function GMOD_DEBUGGER:SendLog(mod, log)
    log = util.Compress(util.TableToJSON(log))
    local log_len = #log

    net.Start("gmod-debugger:log")
    net.WriteString(mod)
    net.WriteUInt(log_len, 16)
    net.WriteData(log, log_len)
    net.SendToServer()
end

net.Receive("gmod-debugger:config", function(len)
    local configData = net.ReadData(len / 8)
    GMOD_DEBUGGER.config = util.JSONToTable(util.Decompress(configData), false, true)
    
    for _, mod in ipairs(GMOD_DEBUGGER.config.enabledModules) do
        include("gmod-debugger/modules/" .. mod .. "/init.lua")
    end
end)

net.Receive("gmod-debugger:options", function(len)
    local optionsData = net.ReadData(len / 8)
    GMOD_DEBUGGER.options = util.JSONToTable(util.Decompress(optionsData), false, true)
end)
