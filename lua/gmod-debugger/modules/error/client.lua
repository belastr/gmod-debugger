local tmpLogs = {}

timer.Create("gmod-debugger:error", 5, 0, function()
    for error_msg, d in pairs(tmpLogs) do
        GMOD_DEBUGGER:SendLog("error", {msg = error_msg, data = d})
        tmpLogs[error_msg] = nil
    end
    timer.Stop("gmod-debugger:error")
end)
timer.Stop("gmod-debugger:error")

hook.Add("OnLuaError", "gmod-debugger:error", function(error_msg, _, error_stack)
    if GMOD_DEBUGGER.config.error.client then
        if !tmpLogs[error_msg] then
            tmpLogs[error_msg] = {stack = GMOD_DEBUGGER.config.error.stack && error_stack || false, count = 1}
        else
            tmpLogs[error_msg].count = tmpLogs[error_msg].count + 1
        end
        timer.Start("gmod-debugger:error")
    end
end)
