//
// lua\Survivor_PointGiverMixin.lua
//
//    Created by:   Lassi lassi@heisl.org
//

//
// copy of the original NS2 PointGiverMixin 
//


if Server then
    function PointGiverMixin:OnConstruct(builder, newFraction, oldFraction)

    end

    function PointGiverMixin:OnConstructionComplete()

    end

    function PointGiverMixin:OnEntityChange(oldId, newId)
    
    end

    function PointGiverMixin:OnTakeDamage(damage, attacker, doer, point, direction, damageType, preventAlert)
    
			--[[
        if attacker and attacker:isa("Player") and GetAreEnemies(self, attacker) then
        
            local attackerId = attacker:GetId()
            
            if not self.damagePoints[attackerId] then
                self.damagePoints[attackerId] = 0
            end
            
            self.damagePoints[attackerId] = self.damagePoints[attackerId] + damage
            
        end
      --]] 
    end

    function PointGiverMixin:PreOnKill(attacker, doer, point, direction)
    
        local totalDamageDone = self:GetMaxHealth() + self:GetMaxArmor() * 2        
        local points = self:GetPointValue()
        local resReward = self:isa("Player") and kPersonalResPerKill or 0

				Print ("custom point giver mixin: PreOnKill")
        
				--[[
        // award partial res and score to players who assisted
        for attackerId, damageDone in pairs(self.damagePoints) do  
        
            local currentAttacker = Shared.GetEntity(attackerId)
            if currentAttacker and HasMixin(currentAttacker, "Scoring") then
                
                local damageFraction = Clamp(damageDone / totalDamageDone, 0, 1)                
                local scoreReward = points >= 1 and math.max(1, math.round(points * damageFraction)) or 0    
         
                currentAttacker:AddScore(scoreReward, resReward * damageFraction, attacker == currentAttacker)
                
                if self:isa("Player") and currentAttacker ~= attacker then
                    currentAttacker:AddAssistKill()
                end
                
            end
        
        end
        
        if self:isa("Player") and attacker and GetAreEnemies(self, attacker) then
        
            if attacker:isa("Player") then
                attacker:AddKill()
            end
            
            self:GetTeam():AddTeamResources(kKillTeamReward)
            
        end
       --]] 
    end

end
