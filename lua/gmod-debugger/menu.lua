net.Receive("gmod-debugger:menu", function()
    local frame = vgui.Create("DebuggerFrame")
    frame:SetPath("Home/error/config")
end)

hook.Add("gmod-debugger:page", "gmod-debugger:menu", function(panel, path)
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
            panel:Clear()
            hook.Run("gmod-debugger:logs", pathTbl[2], panel)
        end
    elseif #pathTbl == 2 then
        panel:Clear()
        local title = vgui.Create("DLabel", panel)
        title:Dock(TOP)
        title:DockMargin(0, 20, 0, 0)
        title:SetFont("DefaultUnderline")
        title:SetTextColor(Color(0, 130, 255))
        title:SetText(pathTbl[2])

        local config = vgui.Create("DButton", panel)
        config:SetPos(0, title:GetY() + title:GetTall() + 25)
        config:SetFont("Default")
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
        logs:SetFont("Default")
        logs:SetText("logs")
        logs:SizeToContents()
        logs.DoClick = function() panel:SetPath("Home/" .. pathTbl[2] .. "/logs") end
        logs.Paint = function(s)
            if s:IsHovered() then
                s:SetTextColor(Color(0, 130, 255))
            else
                s:SetTextColor(Color(51, 51, 51))
            end
        end

        local logfile = vgui.Create("DButton", panel)
        logfile:SetPos(0, logs:GetY() + logs:GetTall() + 5)
        logfile:SetFont("Default")
        logfile:SetText("generate a log file (sv://data/gmod-debugger/logs/" .. pathTbl[2] .. ")" )
        logfile:SizeToContents()
        logfile.DoClick = function() end
        logfile.Paint = function(s)
            if s:IsHovered() then
                s:SetTextColor(Color(0, 130, 255))
            else
                s:SetTextColor(Color(51, 51, 51))
            end
        end
    elseif path == "Home" then
        panel:Clear()
        local title = vgui.Create("DLabel", panel)
        title:Dock(TOP)
        title:SetText("gmod-debugger")
    end
end)

function GMOD_DEBUGGER:RequestConfig(init)
    net.Start("gmod-debugger:config")
    if init then
        net.WriteBit(1)
    end
    net.SendToServer()
end

function GMOD_DEBUGGER:SendLog(mod, log)
    log = util.Compress(util.TableToJSON(log))
    local log_len = #log

    net.Start("gmod-debugger:log", true)
    net.WriteString(mod)
    net.WriteUInt(log_len, 16)
    net.WriteData(log, log_len)
    net.SendToServer()
end

net.Receive("gmod-debugger:config", function(len)
    local configData = net.ReadData(len / 8)
    GMOD_DEBUGGER.config = util.JSONToTable(util.Decompress(configData), false, true)
    
    for _, mod in ipairs(GMOD_DEBUGGER.config.enabledModules) do
        include("gmod-debugger/modules/" .. mod .. "/init.lua")
    end
end)

net.Receive("gmod-debugger:options", function(len)
    local optionsData = net.ReadData(len / 8)
    GMOD_DEBUGGER.options = util.JSONToTable(util.Decompress(optionsData), false, true)
end)

net.Receive("gmod-debugger:log", function(len)
    local mod, logs_len = net.ReadString(), net.ReadUInt(16)
    local logs = net.ReadData(logs_len)
    GMOD_DEBUGGER.logs[mod] = util.JSONToTable(util.Decompress(logs), false, true)

    hook.Run("gmod-debugger:log", mod)
end)
