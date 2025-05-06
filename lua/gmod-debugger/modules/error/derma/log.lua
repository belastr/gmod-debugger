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

    self.columnText = vgui.Create("DLabel", self)
    self.columnText:SetFont("GModDebuggerFont")
    self.columnText:SetTextColor(Color(244, 67, 54))
    self.columnText:SetContentAlignment(4)
    self.columnText:SetTextInset(5, 0)
    self.columnText.Paint = function(_, w, h)
        surface.SetDrawColor(144, 190, 239)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    self.columnCount = vgui.Create("DLabel", self)
    self.columnCount:SetFont("GModDebuggerFont")
    self.columnCount:SetTextColor(Color(244, 67, 54))
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

    self.columnText:SetPos(100, 0)
    self.columnText:SetSize(w - 130, 28)

    self.columnCount:SetPos(w - 30, 0)
    self.columnCount:SetSize(30, 28)
end

function PANEL:SetData(log)
    if !log.data.client then
        self.columnTime:SetTextColor(Color(3, 169, 244))
        self.columnText:SetText(log.error_msg)
    else
        self.columnTime:SetTextColor(Color(222, 169, 9))
        self.columnText:SetText("[" .. log.data.client .. "] " .. log.error_msg)
    end
    self.columnTime:SetText(os.date("[%m/%d %I:%M%p]", log.data.time))
    self.columnCount:SetText("x" .. log.data.count)

    if log.data.stack then
        self:SetTall(28 + #log.data.stack * 18)

        for i, l in ipairs(log.data.stack) do
            local row = vgui.Create("DLabel", self)
            row:SetPos(0, 28 + (i - 1) * 18)
            row:SetSize(ScrW(), 18)
            row:SetFont("GModDebuggerFont")
            row:SetTextColor(Color(244, 67, 54))
            row:SetText(string.rep(" ", i + 1) .. i .. ". " .. l.Function .. " - " .. l.File .. ":" .. l.Line)
            row:SetContentAlignment(4)
            row:SetTextInset(5, 0)
        end
    end
end

vgui.Register("DebuggerLog", PANEL, "DPanel")
