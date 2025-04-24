hook.Add("OnLuaError", "gmod-debugger:error", function(error_msg, _, error_stack)
    if GMOD_DEBUGGER.config.error.server then
        local d = {stack = GMOD_DEBUGGER.config.error.stack && error_stack || false, count = 1, server = true}
        GMOD_DEBUGGER:SaveLog("error", {msg = error_msg, data = d})
    end
end)

hook.Add("gmod-debugger:saveLog", "gmod-debugger:error", function(mod, log)
    if mod == "error" && GMOD_DEBUGGER.config.error.server then
        if !GMOD_DEBUGGER.logs.error[log.msg] then
            GMOD_DEBUGGER.logs.error[log.msg] = log.data
        else
            GMOD_DEBUGGER.logs.error[log.msg].count = GMOD_DEBUGGER.logs.error[log.msg].count + log.data.count
        end
    end
end)
