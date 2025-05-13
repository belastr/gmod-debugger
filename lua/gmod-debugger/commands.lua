hook.Add("PlayerSay", "gmod-debugger:chat_commands", function(ply, msg)
    if GMOD_DEBUGGER:HasAccess(ply) && string.StartsWith(msg, "/gmod-debugger") then
        GMOD_DEBUGGER:OpenMenu(ply)
        return ""
    end
end)
