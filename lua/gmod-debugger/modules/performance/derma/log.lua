local PANEL = {}

function PANEL:Init()
    self.altLine = false

    self.columnTime = vgui.Create("DLabel", self)
    self.columnTime:SetFont("GModDebuggerFont")
    self.columnTime:SetTextColor(Color(51, 51, 51))
    self.columnTime:SetContentAlignment(5)
    self.columnTime.Paint = function(_, w, h)
        surface.SetDrawColor(144, 190, 239)
        surface.DrawOutlinedRect(0, 0, w + 1, h, 1)
    end

    self.columnClient = vgui.Create("DLabel", self)
    self.columnClient:SetFont("GModDebuggerFont")
    self.columnClient:SetContentAlignment(5)
    self.columnClient.Paint = function(_, w, h)
        surface.SetDrawColor(144, 190, 239)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    self.columnServer = vgui.Create("DLabel", self)
    self.columnServer:SetFont("GModDebuggerFont")
    self.columnServer:SetContentAlignment(5)
    self.columnServer.Paint = function(_, w, h)
        surface.SetDrawColor(144, 190, 239)
        surface.DrawOutlinedRect(-1, 0, w + 1, h, 1)
    end

    self:Dock(TOP)
    self:DockMargin(0, -1, 0, 0)
    self:SetTall(28)
end

function PANEL:Paint(_, h)
    if self.altLine then
        surface.SetDrawColor(235, 243, 251)
    else
        surface.SetDrawColor(246, 248, 251)
    end
    surface.DrawRect(0, 0, 200, h)
    surface.SetDrawColor(144, 190, 239)
    surface.DrawOutlinedRect(0, 0, 200, h, 1)
end

function PANEL:PerformLayout()
    self.columnTime:SetPos(0, 0)
    self.columnTime:SetSize(100, 28)

    self.columnClient:SetPos(100, 0)
    self.columnClient:SetSize(50, 28)

    self.columnServer:SetPos(150, 0)
    self.columnServer:SetSize(50, 28)
end

function PANEL:SetData(log)
    self.columnTime:SetText(os.date("[%m/%d %I:%M%p]", log.time))

    if !log.client || log.client == 0 then
        self.columnClient:SetTextColor(Color(51, 51, 51))
    elseif log.client >= 120 then
        self.columnClient:SetTextColor(Color(67, 244, 54))
    elseif log.client >= 60 then
        self.columnClient:SetTextColor(Color(67, 144, 54))
    elseif log.client >= 30 then
        self.columnClient:SetTextColor(Color(244, 144, 54))
    else
        self.columnClient:SetTextColor(Color(244, 67, 54))
    end
    self.columnClient:SetText(log.client != 0 && log.client || "-")

    if !log.server || log.server == 0 then
        self.columnServer:SetTextColor(Color(51, 51, 51))
    elseif log.server > 15.7 then
        self.columnServer:SetTextColor(Color(67, 244, 54))
    else
        self.columnServer:SetTextColor(Color(244, 67, 54))
    end
    self.columnServer:SetText(log.server != 0 && log.server || "-")
end

vgui.Register("DebuggerPerformanceLog", PANEL, "DPanel")
