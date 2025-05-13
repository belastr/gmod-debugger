local PANEL = {}
local cross = Material("gmod-debugger/cross.png")

function PANEL:Init()
    self.value = {}
    self:Dock(TOP)
    self:DockMargin(0, 0, 0, 5)
    self:SetTall(22)

    self.btn = vgui.Create("DButton", self)
    self.btn:Dock(RIGHT)
    self.btn:SetWide(32)
    self.btn:SetFont("GModDebuggerFontBold")
    self.btn:SetTextColor(color_white)
    self.btn:SetText("{ }")
    self.btn.DoClick = function()
        local popup = vgui.Create("DFrame", self:GetParent():GetParent())
        popup:SetTitle("UserGroup Table")
        popup:SetSize(250, 250)
        popup:Center()
        popup.Paint = function(_, w, h)
            surface.SetDrawColor(51, 51, 51)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(33, 33, 33)
            surface.DrawRect(0, 0, w, 24)
        end
        popup.btnMaxim:SetVisible(false)
        popup.btnMinim:SetVisible(false)
        popup.lblTitle:SetFont("GModDebuggerFont")
        popup.lblTitle:SetTextColor(color_white)
        popup.btnClose.Paint = function(_, w, h)
            draw.RoundedBox(4, w - h + 2, 2, h - 4, h - 4, Color(51, 51, 51))
            surface.SetDrawColor(color_white)
            surface.SetMaterial(cross)
            surface.DrawTexturedRect(w - h, 0, h, h)
        end

        local btnAdd = vgui.Create("DButton", popup)
        btnAdd:Dock(TOP)
        btnAdd:SetFont("GModDebuggerFont")
        btnAdd:SetText("Add UserGroup")
        btnAdd.DoClick = function()
            local m = DermaMenu()

            local addedGroups = {}
            for _, ply in ipairs(player.GetHumans()) do
                local group = ply:GetUserGroup()
                if addedGroups[group] || self.value[group] then continue end
                addedGroups[group] = true
                m:AddOption(group, function()
                    popup.list:AddLine(group)
                    self.value[group] = true
                end)
            end

            m:AddOption("Enter manually", function() Derma_StringRequest(
                "Add UserGroup", "Input the exact UserGroup name", "",
                function(text)
                    popup.list:AddLine(text)
                    self.value[text] = true
                end,
                nil, "Add")
            end)

            m:Open()
        end
        btnAdd.Paint = function(s)
            if s:IsHovered() then
                s:SetTextColor(Color(0, 130, 255))
            else
                s:SetTextColor(Color(255, 255, 255, 153))
            end
        end

        popup.list = vgui.Create("DListView", popup)
        popup.list:Dock(FILL)
        popup.list:AddColumn("Player")
        popup.list:SetHideHeaders(true)
        popup.list:SetMultiSelect(false)
        popup.list.OnRowSelected = function(s, r, p) s:RemoveLine(r) self.value[p:GetColumnText(1)] = nil end

        for ply, _ in SortedPairs(self.value) do
            popup.list:AddLine(ply)
        end

        popup.OnClose = function()
            net.Start("gmod-debugger:config")
            net.WriteString("Table")
            net.WriteString(self.module)
            net.WriteString(self.option)
            net.WriteTable(self.value)
            net.SendToServer()
        end
    end
    self.btn.Paint = function(s, w)
        if s:IsHovered() then
            draw.RoundedBox(4, 0, 0, w, 22, Color(0, 130, 255))
        else
            draw.RoundedBox(4, 0, 0, w, 22, Color(51, 51, 51))
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

vgui.Register("DebuggerConfigUserGroups", PANEL, "Panel")
