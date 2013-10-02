//
// lua\Survivor_MarineTeam.lua
//
//    Created by:   Lassi lassi@heisl.org
//

local resourcePointRandomizer = Randomizer()
local supplyDropInterval = 20
local spawnTechInv = { kTechId.AmmoPack, kTechId.AmmoPack, kTechId.AmmoPack, kTechId.AmmoPack, kTechId.AmmoPack, 
    kTechId.MedPack, kTechId.MedPack, kTechId.Welder, kTechId.Shotgun }

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

//don't socket the power node by the marines starting techpoing
function MarineTeam:OnResetComplete()
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
    
    local newArmorLevel = GetArmorLevel(self)
    if self.armorLevel ~= newArmorLevel then
    
        self.armorLevel = newArmorLevel
    
        for index, player in ipairs(GetEntitiesForTeam("Player", self:GetTeamNumber())) do
            player:UpdateArmorAmount(self.armorLevel)
        end
    
    end
    
    if (Server) and (surviviorGamePhase == kSurvivorGamePhase.Survival) then
        if (self.lastSupplyDrop == nil) then
            self.lastSupplyDrop = Shared:GetTime()
        elseif (self.lastSupplyDrop + supplyDropInterval < Shared:GetTime()) then
            //drop supplies
            self:DropSupplies()
            self.lastSupplyDrop = Shared:GetTime()
        end
    end
    
end

if Server then
    function MarineTeam:DropSupplies()
        local success = false
        local rps = GetAvailableResourcePoints()
        
        //hopefully we found rps
        assert(table.count(rps) > 0)
        
        local selectedSpawn = resourcePointRandomizer:random(1, #rps)
        local xOffset = (resourcePointRandomizer:random(1,30) - 15) / 10        
        local zOffset = (resourcePointRandomizer:random(1,30) - 15) / 10
        local spawnOrigin = rps[selectedSpawn]:GetOrigin() + Vector(xOffset, 1, zOffset)
        
        //get random item index
        local itemIndex = resourcePointRandomizer:random(1, #spawnTechInv)
        local mapName = LookupTechData(spawnTechInv[itemIndex], kTechDataMapName)

        if mapName then
            local droppack = CreateEntity(mapName, spawnOrigin, self:GetTeamNumber())
            //log message
            Print(string.format("Supply drop: %s in %s", mapName, rps[selectedSpawn]:GetLocationName()))
            success = true
        end

        return success        
    end
end

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