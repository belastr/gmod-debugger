if SERVER then

    util.AddNetworkString("gmod-debugger:menu")
    util.AddNetworkString("gmod-debugger:config")
    util.AddNetworkString("gmod-debugger:core")
    util.AddNetworkString("gmod-debugger:options")
    util.AddNetworkString("gmod-debugger:log")
    util.AddNetworkString("gmod-debugger:logs")

    function GMOD_DEBUGGER:OpenMenu(ply)
        if !GMOD_DEBUGGER:HasAccess(ply) then return end

        net.Start("gmod-debugger:menu")
        net.Send(ply)
    end

    function GMOD_DEBUGGER:SynchronizeConfig(ply)
        if !GMOD_DEBUGGER.config then return end

        local configData = util.Compress(util.TableToJSON(GMOD_DEBUGGER.config))

        net.Start("gmod-debugger:config")
        net.WriteData(configData, #configData)
        net.Send(ply || player.GetHumans())
    end

    function GMOD_DEBUGGER:SendOptions(ply)
        if !GMOD_DEBUGGER.options then return end

        local optionsData = util.Compress(util.TableToJSON(GMOD_DEBUGGER.options))

        net.Start("gmod-debugger:options")
        net.WriteData(optionsData, #optionsData)
        net.Send(ply)
    end

    net.Receive("gmod-debugger:config", function(len, ply)
        if len < 1 then
            GMOD_DEBUGGER:SynchronizeConfig(ply)
        elseif len == 1 then
            GMOD_DEBUGGER:SynchronizeConfig(ply)
            GMOD_DEBUGGER:SendOptions(ply)
            local r = net.ReadBit()
        else
            local t = net.ReadString()
            if t == "Bool" then
                local mod, opt, val = net.ReadString(), net.ReadString(), net.ReadBool()
                GMOD_DEBUGGER:SetConfig(ply, mod, opt, val)
            elseif t == "Table" then
                local mod, opt, val = net.ReadString(), net.ReadString(), net.ReadTable()
                GMOD_DEBUGGER:SetConfig(ply, mod, opt, val)
            end
        end
    end)

    net.Receive("gmod-debugger:core", function(len, ply)
        if !GMOD_DEBUGGER:HasAccess(ply) then return end

        local s = net.ReadUInt(3)
        if s == 0 then
            local _, m = file.Find("gmod-debugger/modules/*", "LUA")
            net.Start("gmod-debugger:core")
            net.WriteUInt(0, 3)
            net.WriteTable(m)
            net.Send(ply)
        end
    end)

    net.Receive("gmod-debugger:log", function()
        local mod, log_len = net.ReadString(), net.ReadUInt(16)
        local logs = util.JSONToTable(util.Decompress(net.ReadData(log_len)), false, true)

        for i, l in ipairs(logs) do
            GMOD_DEBUGGER:SaveLog(mod, l)
        end
    end)

    net.Receive("gmod-debugger:logs", function(_, ply)
        if !GMOD_DEBUGGER:HasAccess(ply) then return end

        local mod, p = net.ReadString(), net.ReadUInt(12)
        local logs = {}
        for i = p * 50 - 49, p * 50 do
            if !GMOD_DEBUGGER.logs[mod][i] then break end
            logs[i - (p - 1) * 50] = GMOD_DEBUGGER.logs[mod][i]
        end
        logs = util.Compress(util.TableToJSON(logs))
        local logs_len = #logs

        net.Start("gmod-debugger:log")
        net.WriteString(mod)
        net.WriteUInt(logs_len, 16)
        net.WriteData(logs, logs_len)
        net.Send(ply)
    end)

elseif CLIENT then

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

    function GMOD_DEBUGGER:RequestModules()
        net.Start("gmod-debugger:core")
        net.WriteUInt(0, 3)
        net.SendToServer()
    end

    net.Receive("gmod-debugger:menu", function()
        GMOD_DEBUGGER.frame = vgui.Create("DebuggerFrame")
    end)

    net.Receive("gmod-debugger:config", function(len)
        local configData = net.ReadData(len / 8)
        GMOD_DEBUGGER.config = util.JSONToTable(util.Decompress(configData), false, true)
        
        if !table.IsEmpty(GMOD_DEBUGGER.options) then return end
        for mod, b in pairs(GMOD_DEBUGGER.config.enabledModules) do
            if !b then continue end
            include("gmod-debugger/modules/" .. mod .. "/init.lua")
        end
    end)

    net.Receive("gmod-debugger:core", function(len)
        local s = net.ReadUInt(3)
        if s == 0 then
            modules = net.ReadTable()
            GMOD_DEBUGGER.frame:SetPath("Home/enabledModules")
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
    
end
