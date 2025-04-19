hook.Add("OnLuaError", "gmod-debugger:error", function(error_msg, _, error_stack, addon)
    if GMOD_DEBUGGER.config.error.server then
        if !GMOD_DEBUGGER.logs.error[error_msg] then
            GMOD_DEBUGGER.logs.error[error_msg] = {stack = GMOD_DEBUGGER.config.error.stack && error_stack || false, count = 1}
        else
            GMOD_DEBUGGER.logs.error[error_msg].count = GMOD_DEBUGGER.logs.error[error_msg].count + 1
        end
    end
end)
