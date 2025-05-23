local tmpLogs = {}

timer.Create("gmod-debugger:net", 5, 0, function()
    GMOD_DEBUGGER:SendLog("net", tmpLogs)
    timer.Stop("gmod-debugger:net")
    table.Empty(tmpLogs)
end)
timer.Stop("gmod-debugger:net")

function net.Incoming(len, client)
    local i = net.ReadHeader()
    local strName = util.NetworkIDToString(i)
    if !strName then return end

    local func = net.Receivers[strName:lower()]
    if !func then return end

    len = len - 16
    func(len, client)

    if GMOD_DEBUGGER.config.net.client[LocalPlayer():SteamID()] && !GMOD_DEBUGGER.config.net.networkStringsBlacklist[strName] && !string.StartsWith(strName, "gmod-debugger:") then
        if tmpLogs[1] && tmpLogs[1].str == strName then
            tmpLogs[1].count = tmpLogs[1].count + 1
        else
            local log = {str = strName, count = 1, length = len + 16, client = LocalPlayer():SteamID()}
            table.insert(tmpLogs, 1, log)
        end
        timer.Start("gmod-debugger:net")
    end
end

local function logs()
    if !GMOD_DEBUGGER.frame.page then return end

    local bufferTop = vgui.Create("Panel", GMOD_DEBUGGER.frame.page)
    bufferTop:Dock(TOP)
    bufferTop:SetTall(20)

    local labels = vgui.Create("Panel", GMOD_DEBUGGER.frame.page)
    labels:Dock(TOP)
    labels:DockMargin(0, 0, 0, 10)
    labels:SetTall(18)

    local cl = vgui.Create("DLabel", labels)
    cl:Dock(LEFT)
    cl:DockMargin(0, 0, 5, 0)
    cl:SetFont("GModDebuggerFontBold")
    cl:SetTextColor(Color(222, 169, 9))
    cl:SetText("Client")
    cl:SizeToContentsX()

    local sv = vgui.Create("DLabel", labels)
    sv:Dock(LEFT)
    sv:SetFont("GModDebuggerFontBold")
    sv:SetTextColor(Color(3, 169, 244))
    sv:SetText("Server")
    sv:SizeToContentsX()

    local logFile = vgui.Create("DButton", labels)
    logFile:Dock(RIGHT)
    logFile:SetFont("GModDebuggerFontBold")
    logFile:SetText("Print to Log File (/data/gmod-debugger/logs/net)")
    logFile:SizeToContentsX()
    logFile.DoClick = function(s)
        GMOD_DEBUGGER:CreateLogFileFolders("net")
        local content = os.date("net log file generated on %m/%d at %I:%M%p\n\n", os.time())
        for _, l in ipairs(GMOD_DEBUGGER.logs.net) do
            content = content .. os.date("[%m/%d %I:%M%p] ", l.time)
            if l.client then
                content = content .. "[cl] [" .. l.client .. "] "
            else
                content = content .. "[sv] [" .. l.ply .. "] "
            end
            content = content .. l.str .. " [x" .. l.count .. "]\n\n"
        end
        local suc = file.Write(os.date("gmod-debugger/logs/net/l_%Y-%m-%d_%H-%M-%S.txt", os.time()), content)
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

    for i, l in ipairs(GMOD_DEBUGGER.logs.net) do
        if last && l.time < last then break end
        if first && l.time > first then continue end

        local log = vgui.Create("DebuggerNetLog", GMOD_DEBUGGER.frame.page)
        log:SetData(l)
        log.altLine = i % 2 == 0
    end

    local bufferBottom = vgui.Create("Panel", GMOD_DEBUGGER.frame.page)
    bufferBottom:Dock(TOP)
    bufferBottom:SetTall(20)
end

hook.Add("gmod-debugger:log", "gmod-debugger:net", function(mod)
    if mod == "net" then
        logs()
    end
end)

language.Add("net.client", "log net messages received by the selected clients (can potentially cause a lot of traffic)")
language.Add("net.logfiles", "automatically generate a log file for each session")
language.Add("net.networkStringsBlacklist", "do not log selected net messages")
language.Add("net.server", "log net messages received on the serverside")
