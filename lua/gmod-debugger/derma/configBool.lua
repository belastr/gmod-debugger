local PANEL = {}

function PANEL:Init()
    self.value = true
    self:Dock(TOP)
    self:DockMargin(0, 0, 0, 5)
    self:SetTall(22)

    self.btn = vgui.Create("DButton", self)
    self.btn:Dock(RIGHT)
    self.btn:SetText("")
    self.btn.DoClick = function()
        self.value = !self.value
        net.Start("gmod-debugger:config")
        net.WriteString("Bool")
        net.WriteString(self.module)
        net.WriteString(self.option)
        net.WriteBool(self.value)
        net.SendToServer()
    end
    self.btn.Paint = function(_, w)
        if self.value then
            draw.RoundedBox(4, 0, 0, w, 22, Color(0, 130, 255))
            draw.RoundedBox(4, w / 2, 2, w / 2 - 2, 18, Color(252, 252, 252))
        else
            draw.RoundedBox(4, 0, 0, w, 22, Color(51, 51, 51))
            draw.RoundedBox(4, 2, 2, w / 2 - 2, 18, Color(252, 252, 252))
        end
    end

    self.text = vgui.Create("DLabel", self)
    self.text:Dock(FILL)
    self.text:SetFont("GModDebuggerFontBold")
    self.text:SetTextColor(Color(51, 51, 51))
    self.text:SetText("")
end

function PANEL:SetValue(val)
    self.value = val
end

function PANEL:SetText(txt)
    self.text:SetText(txt)
end

function PANEL:SetModule(mod)
    self.module = mod
end

function PANEL:SetOption(opt)
    self.option = opt
end

vgui.Register("DebuggerConfigBool", PANEL, "Panel")
