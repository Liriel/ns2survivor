// lua\Survivor_Shared.lua
//
//    Created by:   Lassi lassi@heisl.org
//
Script.Load("lua/HelloUnknownWorld.lua")

//load the class hooking utilities by fsfod
--Script.Load("lua/PathUtil.lua")
--Script.Load("lua/ClassHooker.lua")
--Script.Load("lua/LoadTracker.lua")

Script.Load("lua/Survivor_Globals.lua")
Script.Load("lua/Survivor_Gamerules.lua")
Script.Load("lua/Survivor_MapBlip.lua")
//not used right now:
//Script.Load("lua/Survivor_Utility.lua")

// register some network messages
Script.Load("lua/Survivor_NetworkMessages.lua")