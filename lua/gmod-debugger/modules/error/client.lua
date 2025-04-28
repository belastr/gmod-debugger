local tmpLogs = {}

timer.Create("gmod-debugger:error", 5, 0, function()
    GMOD_DEBUGGER:SendLog("error", tmpLogs)
    timer.Stop("gmod-debugger:error")
end)
timer.Stop("gmod-debugger:error")

hook.Add("OnLuaError", "gmod-debugger:error", function(errormsg, _, error_stack)
    if GMOD_DEBUGGER.config.error.client then
        if tmpLogs[1] && tmpLogs[1].error_msg == errormsg then
            tmpLogs[1].data.count = tmpLogs[1].data.count + 1
        else
            local log = {error_msg = errormsg, data = {stack = GMOD_DEBUGGER.config.error.stack && error_stack || false, client = LocalPlayer():SteamID(), count = 1}}
            if !log.data.time then
                log.data.time = os.time()
            end
            table.insert(tmpLogs, 1, log)
        end
        timer.Start("gmod-debugger:error")
    end
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
    cl:Dock(LEFT)
    cl:DockMargin(0, 0, 5, 0)
    cl:SetFont("Default")
    cl:SetTextColor(Color(222, 169, 9))
    cl:SetText("Client")
    cl:SizeToContentsX()

    local sv = vgui.Create("DLabel", labels)
    sv:Dock(LEFT)
    sv:SetFont("Default")
    sv:SetTextColor(Color(3, 169, 244))
    sv:SetText("Server")
    sv:SizeToContentsX()

    local logFile = vgui.Create("DButton", labels)
    logFile:Dock(RIGHT)
    logFile:SetFont("Default")
    logFile:SetText("Generate Log File (/data/gmod-debugger/logs/error)")
    logFile:SizeToContentsX()
    logFile.DoClick = function(s)
        GMOD_DEBUGGER:CreateLogFileFolders("error")
        local content = os.date("error log file generated on %m/%d at %I:%M%p\n\n", os.time())
        for _, l in ipairs(GMOD_DEBUGGER.logs.error) do
            content = content .. os.date("[%m/%d %I:%M%p] ", l.data.time)
            if l.data.client then
                content = content .. "[" .. l.data.client .. "] "
            end
            content = content .. l.error_msg .. " [x" .. l.data.count .. "]\n"
            if l.data.stack then
                for i, r in ipairs(l.data.stack) do
                    content = content .. string.rep(" ", i + 1) .. i .. ". " .. r.Function .. " - " .. r.File .. ":" .. r.Line .. "\n"
                end
            end
            content = content .. "\n"
        end
        local suc = file.Write(os.date("gmod-debugger/logs/error/%Y_%m_%d_%H-%M-%S.txt", os.time()), content)
        if suc then
            s:SetText("Log File generated")
            s:SetTextColor(Color(0, 255, 130))
        else
            s:SetText("[ERROR] something went wrong")
            s:SetTextColor(Color(255, 130, 0))
        end
        s:SetMouseInputEnabled(false)
        s:SizeToContentsX()
    end
    logFile.Paint = function(s)
        if !s:IsMouseInputEnabled() then return end
        if s:IsHovered() then
            s:SetTextColor(Color(0, 130, 255))
        else
            s:SetTextColor(Color(51, 51, 51))
        end
    end

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

hook.Add("gmod-debugger:logs", "gmod-debugger:error", function(mod, i, panel)
    if mod == "error" then
        page = panel

        net.Start("gmod-debugger:logs")
        net.WriteString("error")
        net.WriteUInt(tonumber(i), 12)
        net.SendToServer()
    end
end)

language.Add("error.client", "log client errors (if a client is receiving too many errors the log might not be send)")
language.Add("error.logfiles", "automatically generate a log file for each session")
language.Add("error.post", "post logs to the discord")
language.Add("error.server", "log server errors")
language.Add("error.stack", "include error stacks in the logs (increases log size, might be worth turning off when turning on client errors)")
