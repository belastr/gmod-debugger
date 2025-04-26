hook.Add("OnLuaError", "gmod-debugger:error", function(errormsg, _, error_stack)
    if GMOD_DEBUGGER.config.error.server then
        local d = {stack = GMOD_DEBUGGER.config.error.stack && error_stack || false, count = 1, server = true, time = os.time()}
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
    end
end)
