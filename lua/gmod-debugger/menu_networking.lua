util.AddNetworkString("gmod-debugger:menu")
util.AddNetworkString("gmod-debugger:config")
util.AddNetworkString("gmod-debugger:options")
util.AddNetworkString("gmod-debugger:log")

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

function GMOD_DEBUGGER:SaveLog(mod, log)
    hook.Run("gmod-debugger:saveLog", mod, log)
end

net.Receive("gmod-debugger:config", function(len, ply)
    if len < 1 then
        GMOD_DEBUGGER:SynchronizeConfig(ply)
    elseif len == 1 then
        GMOD_DEBUGGER:SynchronizeConfig(ply)
        GMOD_DEBUGGER:SendOptions(ply)
        local r = net.ReadBit()
    end
end)

net.Receive("gmod-debugger:log", function()
    local mod, log_len = net.ReadString(), net.ReadUInt(16)
    local log = util.JSONToTable(util.Decompress(net.ReadData(log_len)), false, true)

    GMOD_DEBUGGER:SaveLog(mod, log)
end)
