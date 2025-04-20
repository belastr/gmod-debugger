local PANEL = {}
local cross = Material("gmod-debugger/cross.png")
local lines = Material("gmod-debugger/lines.png")

function PANEL:Init()
    self.btnMaxim:Remove()
    self.btnMinim:Remove()

    self.btnClose.Paint = function()
        draw.RoundedBox(4, 8, 8, 32, 32, Color(51, 51, 51))
        surface.SetDrawColor(color_white)
        surface.SetMaterial(cross)
        surface.DrawTexturedRect(8, 8, 32, 32)
    end

    self.btnBrowse = vgui.Create("DButton", self)
    self.btnBrowse:SetText("")
    self.btnBrowse.DoClick = function() end
    self.btnBrowse.Paint = function()
        draw.RoundedBox(4, 8, 8, 32, 32, Color(0, 130, 255))
        surface.SetDrawColor(color_white)
        surface.SetMaterial(lines)
        surface.DrawTexturedRect(8, 8, 32, 32)
    end

    self.lblTitle:SetContentAlignment(6)
    self.lblTitle:SetFont("CreditsText")
    self.lblTitle:SetTextColor(Color(242, 249, 255))

    self:SetSize(ScrW() / 2, ScrH() / 1.5)
    self:Center()
    self:SetTitle("gmod-debugger")
    self:MakePopup()
end

function PANEL:Think()
    local mousex = math.Clamp(gui.MouseX(), 1, ScrW() - 1)
    local mousey = math.Clamp(gui.MouseY(), 1, ScrH() - 1)
    local _, screenY = self:LocalToScreen(0, 0)

    if self.Dragging then
        local x = mousex - self.Dragging[1]
        local y = mousey - self.Dragging[2]

        self:SetPos(x, y)
    end

    if self.Hovered && mousey < (screenY + 48) then
        self:SetCursor("sizeall")
        return
    end

    self:SetCursor("arrow")
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(252, 252, 252)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(51, 51, 51)
    surface.DrawRect(0, 0, w, 102)

    surface.SetDrawColor(33, 33, 33)
    surface.DrawRect(0, 0, w, 48)

    draw.SimpleText("Home / gmod-debugger", "Default", 20, 70, Color(178, 178, 178))
end

function PANEL:OnMousePressed()
    local _, screenY = self:LocalToScreen(0, 0)

    if gui.MouseY() < (screenY + 48) then
        self.Dragging = {gui.MouseX() - self.x, gui.MouseY() - self.y}
        self:MouseCapture(true)
    end
end

function PANEL:PerformLayout()
    self.btnClose:SetPos(self:GetWide() - 48, 0)
    self.btnClose:SetSize(48, 48)

    self.lblTitle:SetPos(56, 0)
    self.lblTitle:SetSize(self:GetWide() - 112, 48)

    self.btnBrowse:SetPos(0, 0)
    self.btnBrowse:SetSize(48, 48)
end

vgui.Register("DebuggerFrame", PANEL, "DFrame")
