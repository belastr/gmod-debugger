function net.Incoming(len, client)
    local i = net.ReadHeader()
    local strName = util.NetworkIDToString(i)
    if !strName then return end

    local func = net.Receivers[strName:lower()]
    if !func then return end

    len = len - 16
    func(len, client)

    if GMOD_DEBUGGER.config.net.server && !string.StartsWith(strName, "gmod-debugger:") then
        GMOD_DEBUGGER:SaveLog("net", {str = strName, count = 1, ply = client:SteamID(), time = os.time(), length = len + 16})
    end
end

hook.Add("gmod-debugger:saveLog", "gmod-debugger:net", function(mod, log)
    if mod == "net" then
        if GMOD_DEBUGGER.logs.net[1] && GMOD_DEBUGGER.logs.net[1].str == log.str then
            GMOD_DEBUGGER.logs.net[1].count = GMOD_DEBUGGER.logs.net[1].count + log.count
        else
            if !log.time then
                log.time = os.time()
            end
            table.insert(GMOD_DEBUGGER.logs.net, 1, log)
        end
    end
end)
