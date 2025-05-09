local sum, amount, sv, t = 0, 0, 0, 0

timer.Create("gmod-debugger:performance", 60, 0, function()
    if amount > 0 || sv > 0 then
        GMOD_DEBUGGER:SaveLog("performance", {client = math.Truncate(sum / amount, 2), server = sv, time = t})
    end
    sum, amount, sv = 0, 0, 0
    if GMOD_DEBUGGER.config.performance.server || GMOD_DEBUGGER.config.performance.client then
        t = os.time()

        if GMOD_DEBUGGER.config.performance.server then
            sv = 1 / FrameTime()
        end
        if GMOD_DEBUGGER.config.performance.client then
            net.Start("gmod-debugger:performance")
            net.Broadcast()
        end
    end
end)

net.Receive("gmod-debugger:performance", function()
    sum = sum + net.ReadFloat()
    amount = amount + 1
end)

hook.Add("gmod-debugger:saveLog", "gmod-debugger:performance", function(mod, log)
    if mod == "performance" then
        table.insert(GMOD_DEBUGGER.logs.performance, 1, log)
        if GMOD_DEBUGGER.config.performance.logfiles then
            GMOD_DEBUGGER:CreateLogFileFolders("performance")
            if !file.Exists("gmod-debugger/logs/performance/" .. GMOD_DEBUGGER.sessionKey .. ".txt", "DATA") then
                file.Write("gmod-debugger/logs/performance/" .. GMOD_DEBUGGER.sessionKey .. ".txt", "performance log file automatically generated for session " .. GMOD_DEBUGGER.sessionKey .. "\n\n")
            end

            local content = os.date("[%m/%d %H:%M:%S] ", log.time)

            content = content .. "clients average fps: "
            if log.client && log.client != 0 then
                content = content .. log.client
            else
                content = content .. "disabled"
            end

            content = content .. " - server tickrate: "
            if log.server && log.server != 0 then
                content = content .. log.server
            else
                content = content .. "disabled"
            end

            content = content .. "\n"

            file.Append("gmod-debugger/logs/performance/" .. GMOD_DEBUGGER.sessionKey .. ".txt", content)
        end
    end
end)
