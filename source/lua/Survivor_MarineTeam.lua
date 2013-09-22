//
// lua\Survivor_MarineTeam.lua
//
//    Created by:   Lassi lassi@heisl.org
//

local resourcePointRandomizer = Randomizer()

local ns2MarineTeamInitialize = MarineTeam.Initialize
function MarineTeam:Initialize(teamName, teamNumber)
    //initialize the randomizer
    resourcePointRandomizer:randomseed(Shared.GetSystemTime())    
    ns2MarineTeamInitialize(self, teamName, teamNumber)
end

//don't spwan initail structures at game start
function MarineTeam:SpawnInitialStructures(techPoint) 
    return nil, nil 
end

local function GetArmorLevel(self)

    local armorLevels = 0
    
    local techTree = self:GetTechTree()
    if techTree then
    
        if techTree:GetHasTech(kTechId.Armor3) then
            armorLevels = 3
        elseif techTree:GetHasTech(kTechId.Armor2) then
            armorLevels = 2
        elseif techTree:GetHasTech(kTechId.Armor1) then
            armorLevels = 1
        end
    
    end
    
    return armorLevels

end

function MarineTeam:Update(timePassed)

    PlayingTeam.Update(self, timePassed)
    
    // Update distress beacon mask
    self:UpdateGameMasks(timePassed)    

    //we don't need an infantry portal
    //if GetGamerules():GetGameStarted() then
    //    CheckForNoIPs(self)
    //end
    
    local newArmorLevel = GetArmorLevel(self)
    if self.armorLevel ~= newArmorLevel then
    
        self.armorLevel = newArmorLevel
    
        for index, player in ipairs(GetEntitiesForTeam("Player", self:GetTeamNumber())) do
            player:UpdateArmorAmount(self.armorLevel)
        end
    
    end
    
end

//TODO: change to power nodes
function MarineTeam:RespawnPlayer(player, origin, angles)
    local success = false
    local rps = GetAvailableResourcePoints()
    
    if origin ~= nil and angles ~= nil then
        success = Team.RespawnPlayer(self, player, origin, angles)
    elseif (table.count(rps) > 0) then
    
        local selectedSpawn = resourcePointRandomizer:random(1, #rps)
        local spawnOrigin = rps[selectedSpawn]:GetOrigin() + Vector(0.01, 0.2, 0)
        success = Team.RespawnPlayer(self, player, spawnOrigin, player:GetAngles())
    else
        Print("MarineTeam:RespawnPlayer(): No resource points found.")
    end
    
    return success
end