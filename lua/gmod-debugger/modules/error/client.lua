local tmpLogs = {}

timer.Create("gmod-debugger:error", 5, 0, function()
    GMOD_DEBUGGER:SendLog("error", tmpLogs)
    timer.Stop("gmod-debugger:error")
end)
timer.Stop("gmod-debugger:error")

hook.Add("OnLuaError", "gmod-debugger:error", function(errormsg, _, error_stack)
    if tmpLogs[1] && tmpLogs[1].error_msg == errormsg then
        tmpLogs[1].data.count = tmpLogs[1].data.count + 1
    else
        local log = {error_msg = errormsg, data = {stack = GMOD_DEBUGGER.config.error.stack && error_stack || false, count = 1}}
        if !log.data.time then
            log.data.time = os.time()
        end
        table.insert(tmpLogs, 1, log)
        end
        timer.Start("gmod-debugger:error")
end)

local page
local function logs()
    local bufferTop = vgui.Create("Panel", page)
    bufferTop:Dock(TOP)
    bufferTop:SetTall(20)

    local labels = vgui.Create("Panel", page)
    labels:Dock(TOP)
    labels:DockMargin(0, 0, 0, 10)
    labels:SetTall(18)

    local cl = vgui.Create("DLabel", labels)
    cl:SetPos(0, 0)
    cl:SetTall(18)
    cl:SetFont("Default")
    cl:SetTextColor(Color(222, 169, 9))
    cl:SetText("Client")
    cl:SizeToContentsX()

    local sv = vgui.Create("DLabel", labels)
    sv:SetPos(cl:GetWide() + 5, 0)
    sv:SetTall(18)
    sv:SetFont("Default")
    sv:SetTextColor(Color(3, 169, 244))
    sv:SetText("Server")
    sv:SizeToContentsX()

    for i, l in ipairs(GMOD_DEBUGGER.logs.error) do
        local log = vgui.Create("DebuggerLog", page)
        log:SetData(l)
        log.altLine = i % 2 == 0
    end

    local bufferBottom = vgui.Create("Panel", page)
    bufferBottom:Dock(TOP)
    bufferBottom:SetTall(20)
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
