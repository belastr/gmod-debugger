local PANEL = {}

function PANEL:Init()
    self:Dock(TOP)
    self:SetTall(60)
    self.text = ""
end

function PANEL:Paint(w)
    surface.SetDrawColor(45, 48, 50)
    surface.DrawLine(0, 9, w, 9)

    surface.SetFont("GModDebuggerFontHead")
    surface.SetTextColor(113, 116, 117)
    surface.SetTextPos(0, 28)
    surface.DrawText(self.text)
end

function PANEL:SetText(text)
    self.text = text
end

local spacer = vgui.RegisterTable(PANEL, "DPanel")

PANEL = {}

function PANEL:Init()
    self:Dock(TOP)
    self:SetTall(24)
    self:SetFont("GModDebuggerFontBold")
    self:SetTextColor(color_white)
    self:SetContentAlignment(4)
    self:SetTextInset(8, 0)
end

function PANEL:Paint(w, h)
    if self:IsHovered() then
        surface.SetDrawColor(28, 95, 159)
        surface.DrawRect(0, 0, w, h)
    elseif self.alt then
        surface.SetDrawColor(49, 52, 54)
        surface.DrawRect(0, 0, w, h)
    end
end

local button = vgui.RegisterTable(PANEL, "DButton")

PANEL = {}

function PANEL:Init()
    self:Dock(TOP)
    self:SetTall(24)
    self:SetExpanded(false)

    self.Header:SetTall(24)
    self.Header:SetFont("GModDebuggerFontBold")
    self.Header:SetTextColor(color_white)
    self.Header:SetContentAlignment(4)
    self.Header:SetTextInset(8, 0)
    self.Header.Paint = function(s, w, h)
        if s:IsHovered() then
            if s:GetParent():GetExpanded() then
                draw.RoundedBoxEx(4, 0, 0, w, h, Color(28, 95, 159), true, true, false, false)
            else
                surface.SetDrawColor(28, 95, 159)
                surface.DrawRect(0, 0, w, h)
            end
        end
    end
end

function PANEL:Paint(w, h)
    if self:IsHovered() then
        surface.SetDrawColor(28, 95, 159)
        surface.DrawRect(0, 0, w, h)
    elseif self:GetExpanded() then
        draw.RoundedBox(4, 0, 0, w, h - 6, Color(45, 48, 50))
    end
end

local buttonC = vgui.RegisterTable(PANEL, "DCollapsibleCategory")

PANEL = {}

function PANEL:Init()
    self.home = vgui.Create("DButton", self)
    self.home:SetFont("GModDebuggerFontHead")
    self.home:SetTextColor(color_white)
    self.home:SetText("Home")
    self.home:SetContentAlignment(5)
    self.home.DoClick = function()
        self:GetParent():SetPath("Home")
        self:Hide()
    end
    self.home.Paint = function() end

    self.btns = vgui.Create("DebuggerPage", self)

    self.spacer1 = vgui.CreateFromTable(spacer, self.btns)
    self.spacer1:SetText("CORE")
    
    self.btn = vgui.CreateFromTable(button, self.btns)
    self.btn:SetText("Enabled Modules")
    self.btn.DoClick = function()
        net.Start("gmod-debugger:core")
        net.WriteUInt(0, 3)
        net.SendToServer()
        self:Hide()
    end
    
    self.btn = vgui.CreateFromTable(button, self.btns)
    self.btn:SetText("Permissions")
    self.btn.DoClick = function()
        self:GetParent():SetPath("Home/permissions")
        self:Hide()
    end

    self.spacer2 = vgui.CreateFromTable(spacer, self.btns)
    self.spacer2:SetText("MODULES")

    for mod, _ in SortedPairs(GMOD_DEBUGGER.options) do
        local btn = vgui.CreateFromTable(buttonC, self.btns)
        btn:SetLabel(mod)

        local btnConfig = vgui.CreateFromTable(button, btn)
        btnConfig:SetText(" config")
        btnConfig:SetTall(20)
        btnConfig.alt = true
        btnConfig.DoClick = function()
            self:GetParent():SetPath("Home/" .. mod .. "/config")
            self:Hide()
        end

        local btnLogs = vgui.CreateFromTable(button, btn)
        btnLogs:SetText(" logs")
        btnLogs:SetTall(20)
        btnLogs.DoClick = function()
            self:GetParent():SetPath("Home/" .. mod .. "/logs")
            self:Hide()
        end

        local buffer = vgui.Create("Panel", btn)
        buffer:Dock(TOP)
        buffer:SetTall(10)
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(60, 60, 60, 252)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:PerformLayout()
    self.home:SetPos(20, 10)
    self.home:SetSize(100, 32)
    self.home:SizeToContentsX()

    self.btns:SetPos(20, 42)
    self.btns:SetSize(self:GetWide() - 40, self:GetTall() - 42)
end

vgui.Register("DebuggerBrowser", PANEL, "DPanel")
