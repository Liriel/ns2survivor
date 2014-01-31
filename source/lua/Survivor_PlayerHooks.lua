//
// lua\Survivor_PlayerHooks.lua
//
//    Created by:   Lassi lassi@heisl.org
//

local HotReload = SurvivorPlayer
if(not HotReload) then
  SurvivorPlayer = SurvivorPlayer or {}
  ClassHooker:Mixin("SurvivorPlayer")
end

function SurvivorPlayer:OnLoad()
  ClassHooker:SetClassCreatedIn("Player", "lua/Player.lua") 
  self:PostHookClassFunction("Player", "OnCreate", "OnCreate_Hook")
end

function SurvivorPlayer:OnCreate_Hook(self)
	//Print("PlayerHooked")
end

if (not HotReload) then
	SurvivorPlayer:OnLoad()
end
