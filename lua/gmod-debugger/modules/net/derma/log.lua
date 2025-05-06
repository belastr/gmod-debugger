local PANEL = {}

function PANEL:Init()
    self.altLine = false

    self.columnTime = vgui.Create("DLabel", self)
    self.columnTime:SetFont("GModDebuggerFont")
    self.columnTime:SetContentAlignment(5)
    self.columnTime.Paint = function(_, w, h)
        surface.SetDrawColor(144, 190, 239)
        surface.DrawOutlinedRect(0, 0, w + 1, h, 1)
    end

    self.columnID = vgui.Create("DLabel", self)
    self.columnID:SetFont("GModDebuggerFont")
    self.columnID:SetTextColor(Color(0, 130, 255))
    self.columnID:SetContentAlignment(5)
    self.columnID.Paint = function(_, w, h)
        surface.SetDrawColor(144, 190, 239)
        surface.DrawOutlinedRect(0, 0, w + 1, h, 1)
    end

    self.columnLength = vgui.Create("DLabel", self)
    self.columnLength:SetFont("GModDebuggerFont")
    self.columnLength:SetTextColor(Color(0, 130, 255))
    self.columnLength:SetContentAlignment(5)
    self.columnLength.Paint = function(_, w, h)
        surface.SetDrawColor(144, 190, 239)
        surface.DrawOutlinedRect(0, 0, w + 1, h, 1)
    end

    self.columnText = vgui.Create("DLabel", self)
    self.columnText:SetFont("GModDebuggerFont")
    self.columnText:SetTextColor(Color(0, 130, 255))
    self.columnText:SetContentAlignment(4)
    self.columnText:SetTextInset(5, 0)
    self.columnText.Paint = function(_, w, h)
        surface.SetDrawColor(144, 190, 239)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    self.columnCount = vgui.Create("DLabel", self)
    self.columnCount:SetFont("GModDebuggerFont")
    self.columnCount:SetTextColor(Color(0, 130, 255))
    self.columnCount:SetContentAlignment(5)
    self.columnCount.Paint = function(_, w, h)
        surface.SetDrawColor(144, 190, 239)
        surface.DrawOutlinedRect(-1, 0, w + 1, h, 1)
    end

    self:Dock(TOP)
    self:DockMargin(0, -1, 0, 0)
    self:SetTall(28)
end

function PANEL:Paint(w, h)
    if self.altLine then
        surface.SetDrawColor(235, 243, 251)
    else
        surface.SetDrawColor(246, 248, 251)
    end
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(144, 190, 239)
    surface.DrawOutlinedRect(0, 0, w, h, 1)
end

function PANEL:PerformLayout(w, h)
    self.columnTime:SetPos(0, 0)
    self.columnTime:SetSize(100, 28)

    self.columnID:SetPos(100, 0)
    self.columnID:SetSize(130, 28)

    self.columnLength:SetPos(230, 0)
    self.columnLength:SetSize(40, 28)

    self.columnText:SetPos(270, 0)
    self.columnText:SetSize(w - 300, 28)

    self.columnCount:SetPos(w - 30, 0)
    self.columnCount:SetSize(30, 28)
end

function PANEL:SetData(log)
    self.columnText:SetText(log.str)
    if !log.client then
        self.columnTime:SetTextColor(Color(3, 169, 244))
        self.columnID:SetText(log.ply)
    else
        self.columnTime:SetTextColor(Color(222, 169, 9))
        self.columnID:SetText(log.client)
    end
    self.columnTime:SetText(os.date("[%m/%d %I:%M%p]", log.time))
    self.columnLength:SetText(log.length)
    self.columnCount:SetText("x" .. log.count)
end

vgui.Register("DebuggerNetLog", PANEL, "DPanel")
