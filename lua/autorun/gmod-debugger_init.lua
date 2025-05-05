GMOD_DEBUGGER = GMOD_DEBUGGER || true // change this to 'false' if you want the debugger to not run at all

if CLIENT && GMOD_DEBUGGER then
    include("gmod-debugger/init.lua")
    hook.Add("InitPostEntity", "gmod-debugger:init", function()
        GMOD_DEBUGGER:RequestConfig(true)
    end)
elseif SERVER && GMOD_DEBUGGER then
    local col = Color(88, 101, 242)
    local function MsgD(msg)
        MsgC(col, "# ", color_white, msg, "\n")
    end
    local function MsgW(msg)
        MsgC(col, "# ", Color(242, 101, 88), "WARNING: ", msg, "\n")
    end

    local key = os.date("s_%Y-%m-%d_%H-%M-%S", os.time())

    MsgC(col, "### gmod-debugger ###>\n")
    MsgD("initialising")
    MsgD("session key: " .. key)
    MsgD("")

    MsgD("loading debugger core")
    AddCSLuaFile("gmod-debugger/init.lua")
    include("gmod-debugger/init.lua")
    MsgD("completed debugger core")
    MsgD("")

    MsgD("loading debugger config")
    local config = file.Read("gmod-debugger/config.json")
    if !config then
        config = util.TableToJSON({enabledModules = {error = true, net = true}, permissions = {accessGroups = {superadmin = true}, accessUsers = {}}}, true)
        if !file.Exists("gmod-debugger", "DATA") then file.CreateDir("gmod-debugger") end
        file.Write("gmod-debugger/config.json", config)
        MsgW("config file at garrysmod/data/gmod-debugger/config.json was not found, creating default") 
    else
        MsgD("config file found")
    end
    MsgD("")

    GMOD_DEBUGGER.config = util.JSONToTable(config, false, true)
    GMOD_DEBUGGER.sessionKey = key

    MsgD("loading debugger modules")
    for mod, b in pairs(GMOD_DEBUGGER.config.enabledModules) do
        if !b then continue end
        MsgD("attempting to load module: " .. mod)
        AddCSLuaFile("gmod-debugger/modules/" .. mod .. "/init.lua")
        include("gmod-debugger/modules/" .. mod .. "/init.lua")
    end
    MsgD("completed debugger modules")
    MsgD("")

    MsgC(col, "#####################<\n")
end
