//
// lua\Survivor_Gamerules.lua
//
//    Created by:   Lassi lassi@heisl.org
//

surviviorGamePhase = kSurvivorGamePhase.NotStarted
//gHUDMapEnabled = false

if (Server) then
    //if the survivor pahse of the the game has started already players have to wait 
    //until a new round begins
    function NS2Gamerules:GetCanJoinTeamNumber(teamNumber)      
        return ((teamNumber == 1) and (surviviorGamePhase ~= kSurvivorGamePhase.Survival))
    end

    local ns2ResetGame = NS2Gamerules.ResetGame
    function NS2Gamerules:ResetGame()
        // Disable auto team balance
        Server.SetConfigSetting("auto_team_balance", nil)
        Print "ResetGame called"
       
        ns2ResetGame(self)
    end
    
    //friendly fire is enabled in the frag your neighbor pahse of the game
    function GetFriendlyFire() 
        return (surviviorGamePhase == kSurvivorGamePhase.FragYourNeighbor)
    end
    
    local ns2OnEntityKilled = NS2Gamerules.OnEntityKilled
    function NS2Gamerules:OnEntityKilled(targetEntity, attacker, doer, point, direction)       
        //call base method before moving the player to another team to have the right 
        //team colors displayed in the Player killed Player message
        ns2OnEntityKilled(self, targetEntity, attacker, doer, point, direction)
                
        //check if the killed entity was a marine
        if (targetEntity:isa("Player")) then
            if (targetEntity:GetTeamNumber() == 1) then
                //If the marine was the first one to get killed goto phase two:Survive!
                //this disables friendly fire
                if (surviviorGamePhase == kSurvivorGamePhase.FragYourNeighbor) then
                    //move on to normal game (phase 2)
                    SetSurvivorGamePhase(kSurvivorGamePhase.Survival)
                    
                    //reset highdamage
                    self:SetDamageMultiplier(1)
                    //restore marine health and armor
                    targetEntity:GetTeam():RestoreTeamHealth()
                    
                    //find all power nodes
                    local powerPoints = Shared.GetEntitiesWithClassname("PowerPoint")
                    
                    //randomly select the one that can be repared
                    local powerPointRandomizer = Randomizer()
                    powerPointRandomizer:randomseed(Shared.GetSystemTime()) 
                    local repairablePowerPointIndex = powerPointRandomizer:random(1,powerPoints:GetSize())
                    local repairablePowerPoint = powerPoints:GetEntityAtIndex(repairablePowerPointIndex - 1)
                    
                    //socket power node
                    //repairablePowerPoint:SetInternalPowerState(PowerPoint.kPowerState.destroyed)
                    repairablePowerPoint:SocketPowerNode()
                    Print(string.format("Repairable PowerPoint is in %s", repairablePowerPoint:GetLocationName()))
                    
                    //add event listener
                    repairablePowerPoint:GetTeam():AddListener("OnConstructionComplete",function(structure)
                        if(structure == repairablePowerPoint) then
                            Print "Repairable PowerPoint constructed!"
                            //turn on the lights
                            for index, entity in ientitylist(powerPoints) do
                                if(entity ~= repairablePowerPoint) then
                                    entity:SetLightMode(kLightMode.Normal)
                                end
                            end 
                        end
                    end)
                   
                    //turn off the lights
                    for index, entity in ientitylist(powerPoints) do
                        entity:SetLightMode(kLightMode.NoPower)
                    end
                    
                    //play power out sound
                    //self:PlaySound(kDestroyedSound)
                    //self:PlaySound(kDestroyedPowerDownSound)
                end
            
                //move player to alien team
                success, newEntity = NS2Gamerules.JoinTeam(self, targetEntity, 2)
            end
        end
    end
    
    function SetSurvivorGamePhase(gamePhase)
        Print (string.format("Game phase %s has started", kSurvivorGamePhase))
        surviviorGamePhase = gamePhase
    end
    
    // start the game as soon as all players have joined marines
    function NS2Gamerules:CheckGameStart()
        local team1Players = self.team1:GetNumPlayers()
        local totalPlayers = Server.GetNumPlayers()
        
        if ((team1Players < totalPlayers) or (totalPlayers == 0)) then
            //TODO: print a message that all players have to join marine for the game to start
            
            //debug message
            /*local msg = "Players on server: %d; Players in Marine Team: %d"
            msg = string.format(msg, totalPlayers, team1Players)
            Print (msg)
            */
            return
        end
                //start the game already!
        if self:GetGameState() == kGameState.NotStarted then
            self:SetGameState(kGameState.PreGame)
            SetSurvivorGamePhase(kSurvivorGamePhase.FragYourNeighbor)
            self:SetDamageMultiplier(100)
            showMarinesOnMap(self.team1, false)
        end
    end
    
    // the game ends when: all players are aliens 
    //                     the time is up
    function NS2Gamerules:CheckGameEnd()    
        if (self:GetGameStarted() and self.timeGameEnded == nil and not self.preventGameEnd) then
            if (self.timeLastGameEndCheck == nil or (Shared.GetTime() > self.timeLastGameEndCheck + 1)) then
                local team1Players = self.team1:GetNumPlayers()
                local team2Players = self.team2:GetNumPlayers()
                
                if (team1Players == 0) then
                    SetSurvivorGamePhase(kSurvivorGamePhase.NotStarted)
                    self:EndGame(self.team2)
                end
                //TODO: check if time is up
            end
        end
    end
    
    
    function showMarinesOnMap(team1, show)
        local playerIds = team1.playerIds
        
        for _, playerId in ipairs(playerIds) do     
            local player = Shared.GetEntity(playerId)
            
            if player ~= nil and player:GetId() ~= Entity.invalidId and player:GetIsAlive() then
                //player.gHUDMapEnabled = false
                player.minimapVisible=false
            end
        end
    end
    
    
    
end