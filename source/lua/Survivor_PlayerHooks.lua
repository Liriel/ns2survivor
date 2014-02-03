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
  self:PostHookClassFunction("Player", "OnUpdatePlayer", "OnUpdatePlayer_Hook")
end

function SurvivorPlayer:OnUpdatePlayer_Hook(self, deltaTime)

	//got this from OnkelDagoberts implementation
	//https://github.com/OnkelDagobert/Last_Resistance/blob/master/lua/Player_Server.lua#L389
  if not self:GetIsAlive() and not self:isa("Spectator") then
  
		//we need to wait until the kFadeToBlackTime is over before changing a players team
		//so all animations and stuff has time to complete
		//https://github.com/Liriel/ns2survivor/issues/9
    if self.timeOfDeath ~= nil 
			and (Shared.GetTime() - self.timeOfDeath > kFadeToBlackTime) then
    
      // Destroy the existing player and create a spectator in their place (but only if it has an owner, ie not a body left behind by Phantom use)
      //local owner = Server.GetOwner(self)
      //if owner then
      
	      Print("OnUpdatePlayer")
        // Queue up the spectator for respawn.
        //let a dead players spawn as alien
        local spectator = self:Replace(AlienSpectator.kMapName, kAlienTeamType)                 
        spectator:GetTeam():ReplaceRespawnPlayer(spectator)  

      //end
    
    end
    
  end
end

if (not HotReload) then
	SurvivorPlayer:OnLoad()
end
