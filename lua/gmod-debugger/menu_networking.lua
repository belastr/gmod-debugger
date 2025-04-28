util.AddNetworkString("gmod-debugger:menu")
util.AddNetworkString("gmod-debugger:config")
util.AddNetworkString("gmod-debugger:options")
util.AddNetworkString("gmod-debugger:log")
util.AddNetworkString("gmod-debugger:logs")

function GMOD_DEBUGGER:SynchronizeConfig(ply)
    if !GMOD_DEBUGGER.config then return end

    local configData = util.Compress(util.TableToJSON(GMOD_DEBUGGER.config))

    net.Start("gmod-debugger:config")
    net.WriteData(configData, #configData)
    net.Send(ply || player.GetHumans())
end

timer.Create("gmod-debugger:config", 5, 0, function()
    GMOD_DEBUGGER:SynchronizeConfig()
    timer.Stop("gmod-debugger:config")
end)
timer.Stop("gmod-debugger:config")

function GMOD_DEBUGGER:SetConfig(ply, mod, opt, val)
    GMOD_DEBUGGER.config[mod][opt] = val
    timer.Start("gmod-debugger:config")
end

function GMOD_DEBUGGER:SendOptions(ply)
    if !GMOD_DEBUGGER.options then return end

    local optionsData = util.Compress(util.TableToJSON(GMOD_DEBUGGER.options))

    net.Start("gmod-debugger:options")
    net.WriteData(optionsData, #optionsData)
    net.Send(ply)
end

function GMOD_DEBUGGER:SaveLog(mod, log)
    hook.Run("gmod-debugger:saveLog", mod, log)
end

function GMOD_DEBUGGER:InitModule(mod, cfg)
    GMOD_DEBUGGER.logs[mod] = {}

    GMOD_DEBUGGER.options[mod] = {}
    for c, d in pairs(cfg) do
        GMOD_DEBUGGER.options[mod][c] = d[1]
    end

    if GMOD_DEBUGGER.config[mod] then return end

    GMOD_DEBUGGER.config[mod] = {}
    for c, d in pairs(cfg) do
        GMOD_DEBUGGER.config[mod][c] = d[2]
    end
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
        end
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
