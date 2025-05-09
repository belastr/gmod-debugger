net.Receive("gmod-debugger:performance", function()
    if table.IsEmpty(GMOD_DEBUGGER.config.performance.clients) || GMOD_DEBUGGER.config.performance.clients[LocalPlayer():SteamID()] then
        net.Start("gmod-debugger:performance")
        net.WriteFloat(1 / FrameTime())
        net.SendToServer()
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

    local info = vgui.Create("DLabel", labels)
    info:Dock(LEFT)
    info:DockMargin(0, 0, 5, 0)
    info:SetFont("GModDebuggerFontBold")
    info:SetTextColor(Color(51, 51, 51))
    info:SetText("average player fps | server tickrate (- means disabled)")
    info:SizeToContentsX()

    local logFile = vgui.Create("DButton", labels)
    logFile:Dock(RIGHT)
    logFile:SetFont("GModDebuggerFontBold")
    logFile:SetText("Print to Log File (/data/gmod-debugger/logs/performance)")
    logFile:SizeToContentsX()
    logFile.DoClick = function(s)
        GMOD_DEBUGGER:CreateLogFileFolders("performance")
        local content = os.date("performance log file generated on %m/%d at %I:%M%p\n\n", os.time())
        for _, l in ipairs(GMOD_DEBUGGER.logs.performance) do
            content = content .. os.date("[%m/%d %H:%M:%S] ", l.time)

            content = content .. "clients average fps: "
            if l.client && l.client != 0 then
                content = content .. l.client
            else
                content = content .. "disabled"
            end

            content = content .. " - server tickrate: "
            if l.server && l.server != 0 then
                content = content .. l.server
            else
                content = content .. "disabled"
            end

            content = content .. "\n"
        end
        local suc = file.Write(os.date("gmod-debugger/logs/performance/l_%Y-%m-%d_%H-%M-%S.txt", os.time()), content)
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

    for i, l in ipairs(GMOD_DEBUGGER.logs.performance) do
        local log = vgui.Create("DebuggerPerformanceLog", page)
        log:SetData(l)
        log.altLine = i % 2 == 0
    end

    local bufferBottom = vgui.Create("Panel", page)
    bufferBottom:Dock(TOP)
    bufferBottom:SetTall(20)
end

hook.Add("gmod-debugger:log", "gmod-debugger:performance", function(mod)
    if mod == "performance" then
        logs()
    end
end)

hook.Add("gmod-debugger:logs", "gmod-debugger:performance", function(mod, i, panel)
    if mod == "performance" then
        page = panel

        net.Start("gmod-debugger:logs")
        net.WriteString("performance")
        net.WriteUInt(tonumber(i), 12)
        net.SendToServer()
    end
end)

language.Add("performance.client", "log average fps of players")
language.Add("performance.clients", "log average fps of selected players (leave empty to log all players)")
language.Add("performance.logfiles", "automatically generate a log file for each session")
language.Add("performance.server", "log tickrate of server")
