local PANEL = {}

function PANEL:PerformLayoutInternal()
    local Tall = self.pnlCanvas:GetTall()
    local Wide = self:GetWide()
    local YPos = 0

    self:Rebuild()

    self.VBar:SetUp(self:GetTall(), self.pnlCanvas:GetTall())
    YPos = self.VBar:GetOffset()

    if self.VBar.Enabled then self.VBar:SetWide(0) end

    self.pnlCanvas:SetPos(0, YPos)
    self.pnlCanvas:SetWide(Wide)

    self:Rebuild()

    if Tall != self.pnlCanvas:GetTall() then
        self.VBar:SetScroll(self.VBar:GetScroll())
    end
end

function PANEL:SetPath(path)
    self:GetParent():SetPath(path)
end

vgui.Register("DebuggerPage", PANEL, "DScrollPanel")
