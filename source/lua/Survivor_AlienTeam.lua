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
            
        //local msg = "Techpoints found: %d"
        //msg = string.format(msg, table.count(tps))
        //Print (msg)
        local spawnOrigin = Vector(rps[selectedSpawn]:GetOrigin())
        local team = queuedPlayer:GetTeam()
        local success, player = team:ReplaceRespawnPlayer(queuedPlayer, spawnOrigin, queuedPlayer:GetAngles()) 
        //local success, player = team:ReplaceRespawnPlayer(queuedPlayer, nil, nil) 
        
        if (success) then 
            DestroyEntity(queuedPlayer)
        end
    end
end

//can't call GetSortedRespawnQueue from here so the workaroud has to do
--local function respawnAll(team)
--    local alienSpectators = team:GetSortedRespawnQueue()
--    for i = 1, #alienSpectators do
--        local alienSpectator = alienSpectators[i]
--        local success, player = team:ReplaceRespawnPlayer(alienSpectator, nil, nil)
--    end
--end

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
        if not(alien:GetIsAlive()) then
            respawnNow(alien)
        end
        alien:UpdateArmorAmount(shellLevel)
        alien:UpdateHealthAmount(math.min(12, self.bioMassLevel), self.maxBioMassLevel)
    end
    
    //UpdateCystConstruction(self, timePassed)
    
end