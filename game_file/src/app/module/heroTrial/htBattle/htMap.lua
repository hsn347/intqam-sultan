local heroTrialltCtrl = include("heroTrialltCtrl")
local htMap = class("htMap")
htMap.mapID = nil
htMap.isComplete = nil
htMap.lastStageID = nil
function htMap:whetherMapComplete()
	return self.isComplete
end
function htMap:whetherStageAttack(stageID)
	if self.lastStageID ~= stageID then
		return
	end
	return gErrDef.Err_None
end
function htMap:completeStage(stageID)
	if self.lastStageID ~= stageID then
		return
	end
	if heroTrialltCtrl.isLastStageOfMap(stageID) then
		self.lastStageID = 0
		self.defendingSoldiers = nil
	else
		self.lastStageID = heroTrialltCtrl.getNextStage(stageID)
		self.defendingSoldiers = heroTrialltCtrl.getDefendingSoldiersOfStage(self.lastStageID)
	end
	self:updateMapStatus()
	return gErrDef.Err_None
end
function htMap:getLastStage()
	return self.lastStageID
end
function htMap:getMapID()
	return self.mapID
end
function htMap:updateSoldiers(soldiers)
	self.defendingSoldiers = soldiers
end
function htMap:getDefendingSoldiers()
	return self.defendingSoldiers
end
function htMap:dump()
end
function htMap:ctor(mapID, lastStageID, defendingSoldiers)
	self.mapID = mapID
	if lastStageID then
		self.lastStageID = lastStageID
	else
		self.lastStageID = heroTrialltCtrl.getFirstStageOfMap(mapID)
	end
	self.defendingSoldiers = defendingSoldiers or heroTrialltCtrl.getDefendingSoldiersOfStage(self.lastStageID)
	self:updateMapStatus()
end
function htMap:updateMapStatus()
	if 0 == self.lastStageID then
		self.isComplete = true
	else
		self.isComplete = false
	end
end
return htMap
