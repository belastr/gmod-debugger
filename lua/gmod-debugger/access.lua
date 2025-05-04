function GMOD_DEBUGGER:HasAccess(ply)
    if !GMOD_DEBUGGER.config.permissions.accessGroups || !GMOD_DEBUGGER.config.permissions.accessUsers then return false end
    if GMOD_DEBUGGER.config.permissions.accessGroups[ply:GetUserGroup()] then return true end
    if GMOD_DEBUGGER.config.permissions.accessUsers[ply:SteamID()] then return true end
    return false
end
