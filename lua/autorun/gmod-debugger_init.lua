GMOD_DEBUGGER = GMOD_DEBUGGER || true // change this to 'false' if you want the debugger to not run at all

if CLIENT && GMOD_DEBUGGER then
    include("gmod-debugger/init.lua")
    GMOD_DEBUGGER:RequestConfig()

    for _, mod in ipairs(GMOD_DEBUGGER.config.enabledModules) do
        include("gmod-debugger/modules/" .. mod .. "/init.lua")
    end
elseif SERVER && GMOD_DEBUGGER then
    local col = Color(88, 101, 242)
    local function MsgD(msg)
        MsgC(col, "# ", color_white, msg, "\n")
    end
    local function MsgE(msg)
        MsgC(col, "# ", Color(255, 0, 0), msg, "\n")
        MsgC(col, "#####################<\n")
    end

    MsgC(col, "### gmod-debugger ###>\n")
    MsgD("initialising")
    MsgD("")

    MsgD("loading debugger core")
    AddCSLuaFile("gmod-debugger/init.lua")
    include("gmod-debugger/init.lua")
    MsgD("completed debugger core")
    MsgD("")

    MsgD("loading debugger config")
    local config = file.Read("gmod-debugger/config.json")
    if !config then MsgE("ERROR: config file at garrysmod/data/gmod-debugger/config.json was not found, aborting") return end
    MsgD("")

    GMOD_DEBUGGER.config = util.JSONToTable(config, false, true)

    MsgD("loading debugger modules")
    for _, mod in ipairs(GMOD_DEBUGGER.config.enabledModules) do
        MsgD("attempting to load module: " .. mod)
        AddCSLuaFile("gmod-debugger/modules/" .. mod .. "/init.lua")
        include("gmod-debugger/modules/" .. mod .. "/init.lua")
    end
    MsgD("completed debugger modules")
    MsgD("")

    MsgC(col, "#####################<\n")
end