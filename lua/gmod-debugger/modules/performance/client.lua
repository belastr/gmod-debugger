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
    info:SetText("- means disabled")
    info:SizeToContentsX()

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
