local locLogs = {}

timer.Create("gmod-debugger:net", 5, 0, function()
    GMOD_DEBUGGER:SendLog("net", locLogs)
    timer.Stop("gmod-debugger:net")
end)
timer.Stop("gmod-debugger:net")

function net.Incoming(len, client)
    local i = net.ReadHeader()
    local strName = util.NetworkIDToString(i)
    if !strName then return end

    local func = net.Receivers[strName:lower()]
    if !func then return end

    len = len - 16
    func(len, client)

    if !string.StartsWith(strName, "gmod-debugger:") then
        if locLogs[1] && locLogs[1].str == strName then
            locLogs[1].count = locLogs[1].count + 1
        else
            local log = {str = strName, count = 1}
            table.insert(locLogs, 1, log)
        end
    end
end

language.Add("net.server", "log net messages received on the serverside")
