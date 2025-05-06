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
    self.btnBrowse.DoClick = function()
        self.browser:ToggleVisible()
    end
    self.btnBrowse.Paint = function()
        draw.RoundedBox(4, 8, 8, 32, 32, Color(0, 130, 255))
        surface.SetDrawColor(color_white)
        surface.SetMaterial(lines)
        surface.DrawTexturedRect(8, 8, 32, 32)
    end

    self.lblTitle:SetContentAlignment(6)
    self.lblTitle:SetFont("GModDebuggerFontTitle")
    self.lblTitle:SetTextColor(Color(242, 249, 255))

    self.pathHome = vgui.Create("DButton", self)
    self.pathHome:SetFont("GModDebuggerFontBold")
    self.pathHome:SetText("Home")
    self.pathHome.DoClick = function() self:SetPath("Home") end
    self.pathHome.Paint = function(btn)
        if btn:IsHovered() then
            btn:SetTextColor(Color(0, 130, 255))
        else
            btn:SetTextColor(Color(255, 255, 255, 153))
        end
    end

    self.btnsPath = vgui.Create("Panel", self)
    self.page = vgui.Create("DebuggerPage", self)
    self.browser = vgui.Create("DebuggerBrowser", self)
    self.browser:SetVisible(false)

    self:SetSize(ScrW() / 2, ScrH() / 1.5)
    self:Center()
    self:SetTitle("gmod-debugger")
    self:MakePopup()

    self:SetPath("Home")
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

    self.pathHome:SetPos(20, 70)
    self.pathHome:SetTall(12)
    self.pathHome:SizeToContentsX()

    self.btnsPath:SetPos(20 + self.pathHome:GetWide(), 70)
    self.btnsPath:SetSize(self:GetWide() - 40 - self.pathHome:GetWide(), 12)

    self.page:SetPos(20, 102)
    self.page:SetSize(self:GetWide() - 40, self:GetTall() - 102)

    self.browser:SetPos(0, 48)
    self.browser:SetSize(self:GetWide(), self:GetTall() - 48)
end

function PANEL:SetPath(path)
    self.btnsPath:Clear()
    if path == "Home" then
        local slash = vgui.Create("DLabel", self.btnsPath)
        slash:Dock(LEFT)
        slash:SetFont("GModDebuggerFont")
        slash:SetTextColor(Color(255, 255, 255, 153))
        slash:SetText(" / ")
        slash:SizeToContentsX()
        
        local btnHome = vgui.Create("DButton", self.btnsPath)
        btnHome:Dock(LEFT)
        btnHome:SetFont("GModDebuggerFontBold")
        btnHome:SetTextColor(color_white)
        btnHome:SetText("gmod-debugger")
        btnHome:SizeToContentsX()
        btnHome.DoClick = function() self:SetPath("Home") end
        btnHome.Paint = function() end
    else
        local pathTbl, pathString = string.Explode("/", path), "Home"
        for i, p in ipairs(pathTbl) do
            if p == "Home" then continue end
            pathString = pathString .. "/" .. p
            local str = pathString

            local slash = vgui.Create("DLabel", self.btnsPath)
            slash:Dock(LEFT)
            slash:SetFont("GModDebuggerFont")
            slash:SetTextColor(Color(255, 255, 255, 153))
            slash:SetText(" / ")
            slash:SizeToContentsX()
            
            local btn = vgui.Create("DButton", self.btnsPath)
            btn:Dock(LEFT)
            btn:SetFont("GModDebuggerFontBold")
            btn:SetText(p)
            btn:SizeToContentsX()
            btn.DoClick = function() self:SetPath(str) end
            if i == #pathTbl then
                btn:SetTextColor(color_white)
                btn.Paint = function() end
            else
                btn.Paint = function(b)
                    if b:IsHovered() then
                        b:SetTextColor(Color(0, 130, 255))
                    else
                        b:SetTextColor(Color(255, 255, 255, 153))
                    end
                end
            end
        end

        local i = tonumber(pathTbl[4])
        if i then
            local btnUp = vgui.Create("DButton", self.btnsPath)
            btnUp:Dock(RIGHT)
            btnUp:SetFont("GModDebuggerFontBold")
            btnUp:SetText(">")
            btnUp:SizeToContentsX()
            if i < 255 then
                btnUp.DoClick = function() self:SetPath(pathTbl[1] .. "/" .. pathTbl[2] .. "/" .. pathTbl[3] .. "/" .. tostring(i + 1)) end
                btnUp.Paint = function(b)
                    if b:IsHovered() then
                        b:SetTextColor(Color(0, 130, 255))
                    else
                        b:SetTextColor(Color(255, 255, 255, 153))
                    end
                end
            else
                btnUp:SetMouseInputEnabled(false)
                btnUp:SetTextColor(Color(255, 255, 255, 75))
                btnUp.Paint = function() end
            end

            local num = vgui.Create("DLabel", self.btnsPath)
            num:Dock(RIGHT)
            num:SetFont("GModDebuggerFontBold")
            num:SetTextColor(color_white)
            num:SetText(" " .. i .. " ")
            num:SizeToContentsX()

            local btnDown = vgui.Create("DButton", self.btnsPath)
            btnDown:Dock(RIGHT)
            btnDown:SetFont("GModDebuggerFontBold")
            btnDown:SetText("<")
            btnDown:SizeToContentsX()
            if i > 1 then
                btnDown.DoClick = function() self:SetPath(pathTbl[1] .. "/" .. pathTbl[2] .. "/" .. pathTbl[3] .. "/" .. tostring(i - 1)) end
                btnDown.Paint = function(b)
                    if b:IsHovered() then
                        b:SetTextColor(Color(0, 130, 255))
                    else
                        b:SetTextColor(Color(255, 255, 255, 153))
                    end
                end
            else
                btnDown:SetMouseInputEnabled(false)
                btnDown:SetTextColor(Color(255, 255, 255, 75))
                btnDown.Paint = function() end
            end
        end
    end
    hook.Run("gmod-debugger:page", self.page, path)
end

vgui.Register("DebuggerFrame", PANEL, "DFrame")
