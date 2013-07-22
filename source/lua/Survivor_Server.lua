//
// lua\Survivor_Server.lua
//
//    Created by:   Lassi lassi@heisl.org
//

// RandomizeAliensServer.lua
Script.Load("lua/Server.lua")
Print "Server VM"
//load the shared script
Script.Load("lua/Survivor_Shared.lua")

Script.Load("lua/Survivor_AlienTeam.lua")
Script.Load("lua/Survivor_MarineTeam.lua")

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