local allianceWarCell = class("allianceWarCell")
function allianceWarCell:ctor()
	self.warData, _UPVALUE0_ = nil, nil
end
function allianceWarCell:getWarData(kid)
	if not self.warData[kid] then
		_UPVALUE0_ = nil
		;(nil).warStatus = 0
		;(nil).warStartTime = 0
		;(nil).realStartTime = 0
		;(nil).warMaxTime = 0
		;(nil).warCampData, _UPVALUE0_, (nil).warStatusTime = nil, nil, 0
		;(nil).style = 0
		;(nil).atkPlus = 0
		;(nil).defPlus = 0
		;(nil).hpPlus = 0
		;(nil).remindFreeMoveTimesByTransPoints = 0
		self.warData[kid], (nil).watchNum = nil, 0
	end
	return self.warData[kid]
end
function allianceWarCell:clearWarData()
	self.warData, _UPVALUE0_ = nil, nil
end
function allianceWarCell:setWarStatus(kid, warStatus, warStartTime, warMaxTime)
	local warData = self:getWarData(kid)
	warData.warStatus = warStatus
	warData.warStartTime = warStartTime
	warData.warMaxTime = warMaxTime
	warData.realStartTime = warStartTime - PYRAMIDWAR_ALLIANCE_BATTLE_READY_TIME
	local curTime = serviceFunctions.systemTime()
	if warStatus == gKingdomWarStatusType.inWar then
		warData.warStatusTime = warMaxTime - (curTime - warStartTime)
	else
		warData.warStatusTime = warStartTime - curTime
	end
	warData.warStatusTime = math.max(warData.warStatusTime, 0)
	return warData
end
function allianceWarCell:setAllianceWarPlus(kid, atkPlus, defPlus, hpPlus)
	local warData = self:getWarData(kid)
	if atkPlus then
		warData.atkPlus = atkPlus
	end
	if defPlus then
		warData.defPlus = defPlus
	end
	if hpPlus then
		warData.hpPlus = hpPlus
	end
	return warData
end
function allianceWarCell:setAllianceWarStyle(kid, style)
	local warData = self:getWarData(kid)
	warData.style = style or 0
	return warData
end
function allianceWarCell:setAllianceWarCampData(kid, warCampData)
