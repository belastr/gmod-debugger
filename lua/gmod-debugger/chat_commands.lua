hook.Add("PlayerSay", "gmod-debugger:chat_commands", function(ply, msg)
    if string.StartsWith(msg, "/gmod-debugger") then
        net.Start("gmod-debugger:menu")
        net.Send(ply)
    end
end)
