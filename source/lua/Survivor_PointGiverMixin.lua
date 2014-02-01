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

    if not self.constructPoints then
      self.constructPoints = {}
    end

		//only reward pionts for building the power node
    if builder and builder:isa("Player") and GetAreFriends(self, builder) and self:GetClassName()=="PowerPoint" then
    
      local builderId = builder:GetId()
    
      if not self.constructPoints[builderId] then
        self.constructPoints[builderId] = 0
      end

      self.constructPoints[builderId] = self.constructPoints[builderId] + (newFraction - oldFraction)
    
    end
  end

  //no need to override: 
	//function PointGiverMixin:OnConstructionComplete()

  function PointGiverMixin:OnEntityChange(oldId, newId)
  
  end

  function PointGiverMixin:OnUpdatePlayer(deltaTime)   

		//periodically award points in survival phase
    if self:isa("Player") and surviviorGamePhase 
			and surviviorGamePhase == kSurvivorGamePhase.Survival 
			and self:GetTeamNumber() == kTeam1Index then

			self.lastTimeSurvivalPointsGiven = self.lastTimeSurvivalPointsGiven or Shared.GetTime()
			if self.lastTimeSurvivalPointsGiven + kSurvivalSecondsPerPoint < Shared.GetTime() then
				if HasMixin(self, "Scoring") then
				  //TODO: replace w/ config value
				  self:AddScore(1,0,false)
				  self.lastTimeSurvivalPointsGiven = Shared.GetTime()
			  end
		  end

	  end

  end

end
