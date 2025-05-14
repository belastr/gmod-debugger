local modules = modules || {}
GMOD_DEBUGGER.frame = GMOD_DEBUGGER.frame || nil

hook.Add("gmod-debugger:page", "gmod-debugger:menu", function(panel, path)
    if !GMOD_DEBUGGER:HasAccess(LocalPlayer()) then return end

    local pathTbl = string.Explode("/", path)
    if #pathTbl >= 3 then
        if pathTbl[3] == "config" then
            panel:Clear()
            if !GMOD_DEBUGGER.options[pathTbl[2]] then return end
            local bufferTop = vgui.Create("Panel", panel)
            bufferTop:Dock(TOP)
            bufferTop:SetTall(20)
            for o, d in SortedPairs(GMOD_DEBUGGER.options[pathTbl[2]]) do
                local btnConfig = vgui.Create("DebuggerConfig" .. d, panel)
                btnConfig:SetText("#" .. pathTbl[2] .. "." .. o)
                btnConfig:SetValue(GMOD_DEBUGGER.config[pathTbl[2]][o])
                btnConfig:SetModule(pathTbl[2])
                btnConfig:SetOption(o)
            end
            local bufferBottom = vgui.Create("Panel", panel)
            bufferBottom:Dock(TOP)
            bufferBottom:SetTall(20)
        elseif pathTbl[3] == "logs" then
            if !tonumber(pathTbl[4]) then panel:SetPath(pathTbl[1] .. "/" .. pathTbl[2] .. "/" .. pathTbl[3] .. "/1") return end
            panel:Clear()
            hook.Run("gmod-debugger:logs", pathTbl[2], pathTbl[4], panel)
        end
    elseif #pathTbl == 2 then
        panel:Clear()

        if pathTbl[2] == "enabledModules" then
            local bufferTop = vgui.Create("Panel", panel)
            bufferTop:Dock(TOP)
            bufferTop:SetTall(20)
            for _, mod in SortedPairs(modules) do
                local btnConfig = vgui.Create("DebuggerConfigBool", panel)
                btnConfig:SetText(mod)
                btnConfig:SetValue(GMOD_DEBUGGER.config.enabledModules[mod])
                btnConfig:SetModule("enabledModules")
                btnConfig:SetOption(mod)
            end
            local bufferBottom = vgui.Create("Panel", panel)
            bufferBottom:Dock(TOP)
            bufferBottom:SetTall(20)
        elseif pathTbl[2] == "permissions" then
            local bufferTop = vgui.Create("Panel", panel)
            bufferTop:Dock(TOP)
            bufferTop:SetTall(20)

            local btnGroups = vgui.Create("DebuggerConfigUserGroups", panel)
            btnGroups:SetText("#core.accessGroups")
            btnGroups:SetValue(GMOD_DEBUGGER.config.permissions.accessGroups)
            btnGroups:SetModule("permissions")
            btnGroups:SetOption("accessGroups")

            local btnUsers = vgui.Create("DebuggerConfigPlys", panel)
            btnUsers:SetText("#core.accessUsers")
            btnUsers:SetValue(GMOD_DEBUGGER.config.permissions.accessUsers)
            btnUsers:SetModule("permissions")
            btnUsers:SetOption("accessUsers")

            local bufferBottom = vgui.Create("Panel", panel)
            bufferBottom:Dock(TOP)
            bufferBottom:SetTall(20)
        else
            local title = vgui.Create("DLabel", panel)
            title:Dock(TOP)
            title:DockMargin(0, 20, 0, 0)
            title:SetFont("GModDebuggerFontBold")
            title:SetTextColor(Color(0, 130, 255))
            title:SetText(pathTbl[2])
    
            local config = vgui.Create("DButton", panel)
            config:SetPos(0, title:GetY() + title:GetTall() + 25)
            config:SetFont("GModDebuggerFont")
            config:SetText("config")
            config:SizeToContents()
            config.DoClick = function() panel:SetPath("Home/" .. pathTbl[2] .. "/config") end
            config.Paint = function(s)
                if s:IsHovered() then
                    s:SetTextColor(Color(0, 130, 255))
                else
                    s:SetTextColor(Color(51, 51, 51))
                end
            end
    
            local logs = vgui.Create("DButton", panel)
            logs:SetPos(0, config:GetY() + config:GetTall() + 5)
            logs:SetFont("GModDebuggerFont")
            logs:SetText("logs")
            logs:SizeToContents()
            logs.DoClick = function() panel:SetPath("Home/" .. pathTbl[2] .. "/logs/1") end
            logs.Paint = function(s)
                if s:IsHovered() then
                    s:SetTextColor(Color(0, 130, 255))
                else
                    s:SetTextColor(Color(51, 51, 51))
                end
            end
        end
    elseif path == "Home" then
        panel:Clear()

        local title = vgui.Create("DLabel", panel)
        title:Dock(TOP)
        title:DockMargin(0, 20, 0, 0)
        title:SetFont("GModDebuggerFontBold")
        title:SetTextColor(Color(0, 130, 255))
        title:SetText("gmod-debugger")

        local desc = vgui.Create("DLabel", panel)
        desc:SetPos(0, title:GetY() + title:GetTall() + 25)
        desc:SetFont("GModDebuggerFont")
        desc:SetTextColor(Color(51, 51, 51))
        desc:SetText("A debugger tool with mainly in-game menus and lots of configuration. There are seperated modules that all aim to collect valuable information to then be accessible immediately in-game with options to also extract the information.")
        desc:SizeToContents()

        local instruc = vgui.Create("DLabel", panel)
        instruc:SetPos(0, desc:GetY() + desc:GetTall() + 5)
        instruc:SetFont("GModDebuggerFont")
        instruc:SetTextColor(Color(51, 51, 51))
        instruc:SetText("Click the browser button at the top left to navigate through the menu.")
        instruc:SizeToContents()

        local extra = vgui.Create("DLabel", panel)
        extra:SetPos(0, instruc:GetY() + instruc:GetTall() + 25)
        extra:SetFont("GModDebuggerFont")
        extra:SetTextColor(Color(51, 51, 51))
        extra:SetText("Visit the GitHub repository for information about it, giving feedback or contributing to it.")
        extra:SizeToContents()

        local link = vgui.Create("DButton", panel)
        link:SetPos(0, extra:GetY() + extra:GetTall() + 5)
        link:SetFont("GModDebuggerFont")
        link:SetText("GitHub Link")
        link:SizeToContents()
        link.DoClick = function() gui.OpenURL("https://github.com/belastr/gmod-debugger") end
        link.Paint = function(s)
            if s:IsHovered() then
                s:SetTextColor(Color(0, 130, 255))
            else
                s:SetTextColor(Color(51, 51, 51))
            end
        end
    end
end)

function GMOD_DEBUGGER:CreateLogFileFolders(mod)
    if !file.Exists("gmod-debugger", "DATA") then
        file.CreateDir("gmod-debugger")
    end
    if !file.Exists("gmod-debugger/logs", "DATA") then
        file.CreateDir("gmod-debugger/logs")
    end
    if !file.Exists("gmod-debugger/logs/" .. mod, "DATA") then
        file.CreateDir("gmod-debugger/logs/" .. mod)
    end
end

language.Add("core.accessGroups", "UserGroups that can access the gmod-debugger (Add UserGroup can only find groups that are currently online, so you might need to enter them manually)")
language.Add("core.accessUsers", "clients that can access the gmod-debugger")
