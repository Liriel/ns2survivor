//
// lua\Survivor_MarineTeam.lua
//
//    Created by:   Lassi lassi@heisl.org
//

Script.Load("lua/Survivor_PlayingTeam.lua")

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

