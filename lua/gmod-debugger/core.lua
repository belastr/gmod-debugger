timer.Create("gmod-debugger:config", 5, 0, function()
    GMOD_DEBUGGER:SynchronizeConfig()

    if !file.Exists("gmod-debugger", "DATA") then file.CreateDir("gmod-debugger") end
    file.Write("gmod-debugger/config.json", util.TableToJSON(GMOD_DEBUGGER.config, true))

    timer.Stop("gmod-debugger:config")
end)
timer.Stop("gmod-debugger:config")

hook.Add("ShutDown", "gmod-debugger:shutdown", function()
    GMOD_DEBUGGER.config.enabledModules = table.Copy(GMOD_DEBUGGER.config.toBeEnabledModules)
    GMOD_DEBUGGER.config.toBeEnabledModules = nil

    if !file.Exists("gmod-debugger", "DATA") then file.CreateDir("gmod-debugger") end
    file.Write("gmod-debugger/config.json", util.TableToJSON(GMOD_DEBUGGER.config, true))
end)

hook.Add("gmod-debugger:post", "gmod-debugger:post", function(json)
    /*
    IMPLEMENT http.Post() or Socket
    */
end)

function GMOD_DEBUGGER:SetConfig(ply, mod, opt, val)
    if !GMOD_DEBUGGER:HasAccess(ply) then return end

    GMOD_DEBUGGER.config[mod][opt] = val
    timer.Start("gmod-debugger:config")
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

    if !GMOD_DEBUGGER.config[mod] then
        GMOD_DEBUGGER.config[mod] = {}
    end

    for c, d in pairs(cfg) do
        if GMOD_DEBUGGER.config[mod][c] then continue end
        GMOD_DEBUGGER.config[mod][c] = d[2]
    end
end

function GMOD_DEBUGGER:CreateLogFileFolders(mod)
    if !file.Exists("gmod-debugger/logs", "DATA") then
        file.CreateDir("gmod-debugger/logs")
    end
    if !file.Exists("gmod-debugger/logs/" .. mod, "DATA") then
        file.CreateDir("gmod-debugger/logs/" .. mod)
    end
end
