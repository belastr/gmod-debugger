util.AddNetworkString("gmod-debugger:menu")
util.AddNetworkString("gmod-debugger:config")

function GMOD_DEBUGGER:SynchronizeConfig(ply, unreliable)
    local configData = util.Compress(util.TableToJSON(GMOD_DEBUGGER.config))

    net.Start("gmod-debugger:config", unreliable || false)
    net.WriteData(configData, #configData)
    net.Send(ply || player.GetHumans())
end

net.Receive("gmod-debugger:config", function(len, ply)
    if len < 1 then
        GMOD_DEBUGGER:SynchronizeConfig(ply)
        return
    end
end)
