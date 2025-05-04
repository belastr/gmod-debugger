function GMOD_DEBUGGER:HasAccess(ply)
    if !GMOD_DEBUGGER.config.accessGroups || !GMOD_DEBUGGER.config.accessUsers then return false end
    if GMOD_DEBUGGER.config.accessGroups[ply:GetUserGroup()] then return true end
    if GMOD_DEBUGGER.config.accessUsers[ply:SteamID()] then return true end
    return false
end
