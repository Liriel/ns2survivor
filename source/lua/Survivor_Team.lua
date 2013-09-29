//
// lua\Survivor_Team.lua
//
//    Created by:   Lassi lassi@heisl.org
//

function Team:RestoreTeamHealth()
    local playerIds = self.playerIds
    
    for _, playerId in ipairs(playerIds) do     
        local player = Shared.GetEntity(playerId)
        
        if player ~= nil and player:GetId() ~= Entity.invalidId and player:GetIsAlive() then
            //max health gets clamped 
            player:SetHealth(9999)
            player:SetArmor(9999, false)
        end
    end
end