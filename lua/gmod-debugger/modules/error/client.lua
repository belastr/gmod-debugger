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

local page
local function logs()
    for error_msg, data in SortedPairs(GMOD_DEBUGGER.logs.error) do
        local log = vgui.Create("Panel", page)
        log:Dock(TOP)
        log:DockMargin(0, 0, 0, 5)
        
        local title = vgui.Create("DLabel", log)
        title:Dock(TOP)
        title:SetTall(20)
        title:SetFont("Default")
        title:SetTextColor(Color(255, 130, 0))
        if data.count > 1 then
            title:SetText(error_msg .. " x" .. data.count)
        else
            title:SetText(error_msg)
        end

        if data.stack then
            local str = ""
            for i, p in ipairs(data.stack) do
                str = str .. string.rep(" ", i + 1) .. i .. ". " .. p.Function .. " - " .. p.File .. ":" .. p.Line .. "\n"
            end

            local stack = vgui.Create("DLabel", log)
            stack:Dock(TOP)
            stack:SetFont("Default")
            stack:SetTextColor(Color(51, 51, 51))
            stack:SetWrap(true)
            stack:SetAutoStretchVertical(true)
            stack:SetText(str)
        end

        timer.Simple(0.01, function()
            log:InvalidateLayout()
            log:SizeToChildren(false, true)
        end)
    end
end

hook.Add("gmod-debugger:log", "gmod-debugger:error", function(mod)
    if mod == "error" then
        logs()
    end
end)

hook.Add("gmod-debugger:logs", "gmod-debugger:error", function(mod, panel)
    if mod == "error" then
        page = panel

        net.Start("gmod-debugger:logs")
        net.WriteString("error")
        net.SendToServer()
    end
end)

language.Add("error.client", "log client errors (significantly increases network traffic)")
language.Add("error.post", "post logs to the discord")
language.Add("error.server", "log server errors")
language.Add("error.stack", "include error stacks in the logs")
