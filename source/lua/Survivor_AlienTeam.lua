//
// lua\Survivor_AlienTeam.lua
//
//    Created by:   Lassi lassi@heisl.org
//

//don't spwan initail structures at game start
function AlienTeam:SpawnInitialStructures(techPoint) 
    return nil, nil 
end

function AlienTeam:GetHasAbilityToRespawn() 
    return true 
end

local function respawnNow(queuedPlayer)
    //local tps = Shared.GetEntitiesWithClassname("TechPoint")
    local rps = GetAvailableResourcePoints();
    
    if (table.count(rps) > 0) then
        local resourcePointRandomizer = Randomizer()
        resourcePointRandomizer:randomseed(Shared.GetSystemTime())
        local selectedSpawn = resourcePointRandomizer:random(1, #rps)
        
        local spawnOrigin = Vector(rps[selectedSpawn]:GetOrigin()) + Vector(0.01, 0.2, 0)
        local team = queuedPlayer:GetTeam()
        local success, player = team:ReplaceRespawnPlayer(queuedPlayer, spawnOrigin, queuedPlayer:GetAngles()) 
        //local success, player = team:ReplaceRespawnPlayer(queuedPlayer, nil, nil) 
        
        if (success) then 
            //give the newborn skulk it's upgrade
            player:GiveUpgrade(kTechId.Leap)
            DestroyEntity(queuedPlayer)
        end
    end
end

function AlienTeam:Update(timePassed)

    PROFILE("AlienTeam:Update")
    
    PlayingTeam.Update(self, timePassed)
    
    self:UpdateTeamAutoHeal(timePassed)
    //UpdateEggGeneration(self)
    //UpdateEggCount(self)
    //UpdateAlienSpectators(self)
    //self:UpdateBioMassLevel()
    //respawnAll(PlayingTeam)
    
    local shellLevel = GetShellLevel(self:GetTeamNumber())  
    for index, alien in ipairs(GetEntitiesForTeam("Alien", self:GetTeamNumber())) do
        alien:UpdateArmorAmount(shellLevel)
        alien:UpdateHealthAmount(math.min(12, self.bioMassLevel), self.maxBioMassLevel)
    end
    
    for index, queuedPlayer in ipairs(self:GetSortedRespawnQueue()) do
        self:RemovePlayerFromRespawnQueue(queuedPlayer)
        respawnNow(queuedPlayer)
    end
    
    //UpdateCystConstruction(self, timePassed)
    
end