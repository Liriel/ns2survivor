//
// lua\Survivor_Server.lua
//
//    Created by:   Lassi lassi@heisl.org
//

//currently there are no server hooks so we don't need to load the framework here
//TODO: use it or remove it

////load the class hooking utilities by fsfod
//BEFORE loading the base NS2 server
//Script.Load("lua/PreLoadMod.lua")
//Script.Load("lua/PathUtil.lua")
//Script.Load("lua/ClassHooker.lua")
//Script.Load("lua/LoadTracker.lua")
//
////load mixin & player hooks
//Script.Load("lua/Survivor_PlayerHooks.lua")

// RandomizeAliensServer.lua
Script.Load("lua/Server.lua")
Print "Server VM"
//load the shared script
Script.Load("lua/Survivor_Shared.lua")

Script.Load("lua/Survivor_Team.lua")
Script.Load("lua/Survivor_AlienTeam.lua")
Script.Load("lua/Survivor_MarineTeam.lua")
Script.Load("lua/Survivor_Skulk_Server.lua")

//mixin override
Script.Load("lua/Survivor_PointGiverMixin.lua")

local function postServerMsg(player, message)
    local locationId = -1
    
    Server.SendNetworkMessage(player, "Chat", BuildChatMessage(true, "Server", locationId, player:GetTeamNumber(), kNeutralTeamType, message), true)
end

local function OnClientConnect(client)
    local player = client:GetControllingPlayer()
    local welcomeMsg = "Hello %s welcome to Survivor!"
    welcomeMsg = string.format(welcomeMsg, player:GetName())
    
    postServerMsg(player, "#")
    postServerMsg(player, welcomeMsg)
end

Event.Hook("ClientConnect", OnClientConnect)
