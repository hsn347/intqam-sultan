local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local allianceBuildCellBase = include("allianceBuildCellBase")
local allianceResPoint = class("allianceResPoint", allianceBuildCellBase)
function allianceResPoint:ctor(...)
	allianceResPoint.super.ctor(self, ...)
end
function allianceResPoint:create(bid, iid)
	return allianceResPoint.super.create(allianceResPoint, bid, iid)
end
function allianceResPoint:demolish()
	allianceResPoint.super.demolish(self)
	return gErrDef.Err_None
end
function allianceResPoint:complete(completeTime, validTime)
	allianceResPoint.super.complete(self, completeTime)
	self.property.validTime = validTime
end
function allianceResPoint:getMapStatus()
	if self.property.mapData then
		return self.property.mapData.mapStatus
	end
end
function allianceResPoint:getBuildStartTime()
	if self.property.mapData then
		return self.property.mapData.startTime
	end
end
function allianceResPoint:getBuildFinishTime()
	if self.property.mapData then
		return self.property.mapData.finishTime
	end
end
function allianceResPoint:getBuildRemainTime()
	local remainTime = 0
	local finishTime = self:getBuildFinishTime()
	if finishTime then
		remainTime = finishTime - serviceFunctions.systemTime()
		if remainTime < 0 then
			remainTime = 0
		end
		return remainTime
	end
	return nil
end
function allianceResPoint:getBuildingStatus()
	if self:isFree() then
		if gErrDef.Err_None ~= self:isCondEnough() then
			return gAllianceBuildingStatus.LOCK
		else
			local num = self.command.getNumOfSetBuilding(gAllianceBuildType.RESOURCE)
			if 1 <= num then
				return gAllianceBuildingStatus.UNSET
			else
				return self:getStatus()
			end
		end
	elseif self:isBuilding() or self:isCompleted() then
		return self:getStatus()
	end
end
function allianceResPoint:getRemainLifeTime()
	local remainTime = 0
	if not self:isCompleted() then
		return remainTime
	end
	if not self:isCompleted() then
		return remainTime
	end
	remainTime = self.property.validTime - (serviceFunctions.systemTime() - self.property.completeTime)
	if remainTime < 0 then
		remainTime = 0
	end
	return remainTime
end
function allianceResPoint:getBuildValueInfo()
	if not self:isBuilding() then
		return
	end
	local buildSpeed = self.property.mapData.buildSpeed
	local buildSpeedTime = self.property.mapData.buildSpeedTime
	local surplusPoint = self.property.mapData.surplusPoint
	if 0 < buildSpeed then
		surplusPoint = self.property.mapData.surplusPoint - buildSpeed * (serviceFunctions.systemTime() - buildSpeedTime)
	end
	local totalBuildValue = self.property.totalBuildValue
	return math.floor(totalBuildValue - surplusPoint), totalBuildValue
end
function allianceResPoint:getCaptainUID()
	if not self:isBuilding() then
		return
	end
	return self.property.mapData.captainUid
end
function allianceResPoint:getMaxNumOfQueue()
	local ret = 0
	if not self:isBuilding() then
		return ret
	end
	if not self.property.mapData.captainUid then
		ret = 3
		return ret
	end
	ret = self.property.mapData.buildMaxQueueNum or ret
	return ret
end
function allianceResPoint:getMaxNumOfSoldier()
	local ret = 0
	if not self:isBuilding() then
		return ret
	end
	ret = self.property.mapData.buildMaxNum or ret
	return ret
end
function allianceResPoint:getCurNumOfSoldier()
	local ret = 0
	if not self:isBuilding() then
		return ret
	end
	ret = self.property.mapData.totalArmyNum or ret
	return ret
end
function allianceResPoint:canMarch()
	if not self:isBuilding() then
		return gErrDef.Err_ILLEGAL_PARAMS
	end
	local remainNum = 0
	if not self.property.mapData.captainUid then
		local buildLogic = include("buildLogic")
		remainNum = buildLogic.getExpArmyCount().total
		return gErrDef.Err_None, remainNum
	end
	local buildMaxQueueNum = self.property.mapData.buildMaxQueueNum
	local buildMaxNum = self.property.mapData.buildMaxNum
	local totalArmyNum = self.property.mapData.totalArmyNum
	if buildMaxNum <= totalArmyNum then
		return gErrDef.Err_ALLIANCE_BUILDING_SOLDIER_FULL
	end
	local curQueueNum = self.property.mapData.inNum
	if buildMaxQueueNum <= curQueueNum then
		return gErrDef.Err_ALLIANCE_BUILDING_QUEUE_FULL
	end
	remainNum = buildMaxNum - totalArmyNum
	return gErrDef.Err_None, remainNum
end
function allianceResPoint:dump()
end
return allianceResPoint
