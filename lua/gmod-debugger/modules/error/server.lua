hook.Add("OnLuaError", "gmod-debugger:error", function(errormsg, _, error_stack)
    if GMOD_DEBUGGER.config.error.server then
        local d = {stack = GMOD_DEBUGGER.config.error.stack && error_stack || false, count = 1, client = false, time = os.time()}
        GMOD_DEBUGGER:SaveLog("error", {error_msg = errormsg, data = d})
    end
end)

hook.Add("gmod-debugger:saveLog", "gmod-debugger:error", function(mod, log)
    if mod == "error" then
        if GMOD_DEBUGGER.logs.error[1] && GMOD_DEBUGGER.logs.error[1].error_msg == log.error_msg then
            GMOD_DEBUGGER.logs.error[1].data.count = GMOD_DEBUGGER.logs.error[1].data.count + log.data.count
        else
            if !log.data.time then
                log.data.time = os.time()
            end
            table.insert(GMOD_DEBUGGER.logs.error, 1, log)
        end
        if GMOD_DEBUGGER.config.error.logfiles then
            GMOD_DEBUGGER:CreateLogFileFolders("error")
            if !file.Exists("gmod-debugger/logs/error/" .. GMOD_DEBUGGER.sessionKey .. ".txt", "DATA") then
                file.Write("gmod-debugger/logs/error/" .. GMOD_DEBUGGER.sessionKey .. ".txt", "error log file automatically generated for session " .. GMOD_DEBUGGER.sessionKey .. "\n\n")
            end

            local content = os.date("[%m/%d %H:%M:%S] ", log.data.time)
            if log.data.client then
                content = content .. "[" .. log.data.client .. "] "
            end
            content = content .. log.error_msg .. " [x" .. log.data.count .. "]\n"
            if log.data.stack then
                for i, r in ipairs(log.data.stack) do
                    content = content .. string.rep(" ", i + 1) .. i .. ". " .. r.Function .. " - " .. r.File .. ":" .. r.Line .. "\n"
                end
            end
            content = content .. "\n"

            file.Append("gmod-debugger/logs/error/" .. GMOD_DEBUGGER.sessionKey .. ".txt", content)
        end
    end
end)
