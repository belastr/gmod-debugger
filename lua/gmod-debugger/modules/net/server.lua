function net.Incoming(len, client)
    local i = net.ReadHeader()
    local strName = util.NetworkIDToString(i)
    if !strName then return end

    local func = net.Receivers[strName:lower()]
    if !func then return end

    len = len - 16
    func(len, client)

    if GMOD_DEBUGGER.config.net.server && !GMOD_DEBUGGER.config.net.networkStringsBlacklist[strName] && !string.StartsWith(strName, "gmod-debugger:") then
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
        if GMOD_DEBUGGER.config.net.logfiles then
            GMOD_DEBUGGER:CreateLogFileFolders("net")
            if !file.Exists("gmod-debugger/logs/net/" .. GMOD_DEBUGGER.sessionKey .. ".txt", "DATA") then
                file.Write("gmod-debugger/logs/net/" .. GMOD_DEBUGGER.sessionKey .. ".txt", "net log file automatically generated for session " .. GMOD_DEBUGGER.sessionKey .. "\n\n")
            end

            local content = os.date("[%m/%d %H:%M:%S] ", log.time)
            if log.client then
                content = content .. "[cl] [" .. log.client .. "] "
            else
                content = content .. "[sv] [" .. log.ply .. "] "
            end
            content = content .. log.str .. " [x" .. log.count .. "]\n"

            file.Append("gmod-debugger/logs/net/" .. GMOD_DEBUGGER.sessionKey .. ".txt", content)
        end
    end
end)
