local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local createAllianceBuildingCD = class("createAllianceBuildingCD")
function createAllianceBuildingCD:ctor(property)
	self.property = property
end
function createAllianceBuildingCD:destroy()
	self.property.CDFinishTimeList, _UPVALUE0_ = nil, nil
end
function createAllianceBuildingCD:create(aid)
	createAllianceBuildingCD = nil
	;(nil).CDFinishTimeList, createAllianceBuildingCD, (nil).aid = nil, nil, aid
	local property
	return createAllianceBuildingCD.new(property)
end
function createAllianceBuildingCD:initialize(property)
	if property then
		self.property = property
	end
end
function createAllianceBuildingCD:inBuildCD(bid)
	if allianceBuildingltCtrl:hasCD(bid) then
		local finishTime = self:getCDFinishTime(bid)
		if finishTime then
			local currentTime = serviceFunctions.systemTime()
			if finishTime >= currentTime then
				return true
			else
				self:removeCDFinishTime(bid)
			end
		end
	end
	return false
end
function createAllianceBuildingCD:startTimingCD(bid, finishTime)
	if allianceBuildingltCtrl:hasCD(bid) then
		self:setCDFinishTime(bid, finishTime)
	end
end
function createAllianceBuildingCD:getDBData()
	return self.property
end
function createAllianceBuildingCD:getCDRemainTime(bid)
	local remainTime = 0
	if not self:inBuildCD(bid) then
		return remainTime
	end
	local currentTime = serviceFunctions.systemTime()
	remainTime = self:getCDFinishTime(bid) - currentTime
	if remainTime < 0 then
		remainTime = 0
	end
	return remainTime
end
function createAllianceBuildingCD:dump()
end
function createAllianceBuildingCD:setCDFinishTime(bid, time)
	self.property.CDFinishTimeList[tostring(bid)] = time
end
function createAllianceBuildingCD:getCDFinishTime(bid)
	return self.property.CDFinishTimeList[tostring(bid)]
end
function createAllianceBuildingCD:removeCDFinishTime(bid)
	self.property.CDFinishTimeList[tostring(bid)] = nil
end
return createAllianceBuildingCD
