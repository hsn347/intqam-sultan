local localQueueRoot = class("localQueueRoot")
_UPVALUE6_ = "localQueueRoot"
;("localQueueRoot")[1] = "localQueueMgr"
;("localQueueRoot")[2] = "localMassQueueMgr"
;("localQueueRoot")[3] = "localUserQueueMgr"
;("localQueueRoot")[4] = "localPosQueueMgr"
;("localQueueRoot")[5] = "localWarHallQueueMgr"
local ("localQueueRoot")[6], tableQueue = "localWatchTowerQueueMgr", "localQueueRoot"
function localQueueRoot:ctor(kingdomMapCell)
	self.kingdomMapCell = kingdomMapCell
	self.kid = kingdomMapCell.kid
	self.uid = kingdomMapCell.uid
	self.queueMgrTable, _ENV, self.isWar = kingdomMapCell.uid, kingdomMapCell.uid, false
	for _, v in ipairs(tableQueue) do
		local queueMgrClass = include(v)
		local queueMgr = queueMgrClass.new(kingdomMapCell, self)
		if queueMgr then
			table.insert(self.queueMgrTable, queueMgr)
			self[v] = queueMgr
		end
	end
end
function localQueueRoot:isWarQueueRoot()
	return self.isWar
end
function localQueueRoot:setWarQueueRoot(isWar)
	self.isWar = isWar
end
function localQueueRoot:getOwnTeamID()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if self.isWar then
		return allianceMgr:getOwnAid()
	end
	return allianceMgr:getOwnTeamID()
end
function localQueueRoot:getSelfAid()
	return self:getOwnTeamID()
end
function localQueueRoot:getQueue(queueID)
	return self.localQueueMgr:getQueue(queueID)
end
function localQueueRoot:getAllWarHallQueue()
	return self.localWarHallQueueMgr:getAllWarHallQueue()
end
function localQueueRoot:getWarHallAllCount()
	return self.localWarHallQueueMgr:getWarHallAllCount()
end
function localQueueRoot:getWarHallData(indexID)
	return self.localWarHallQueueMgr:getWarHallData(indexID)
end
function localQueueRoot:getSortWarHallQueues(indexID)
	return self.localWarHallQueueMgr:getSortWarHallQueues(indexID)
end
function localQueueRoot:isHasWarHallQueues(indexID)
	return self.localWarHallQueueMgr:isHasWarHallQueues(indexID)
end
function localQueueRoot:getWarHallAttackCount()
	return self.localWarHallQueueMgr:getWarHallAttackCount()
end
function localQueueRoot:getWarHallDefendCount()
	return self.localWarHallQueueMgr:getWarHallDefendCount()
end
function localQueueRoot:getWarHallActivityCount()
	return self.localWarHallQueueMgr:getWarHallActivityCount()
end
function localQueueRoot:getWarHallCountByClassType(classType)
	return self.localWarHallQueueMgr:getWarHallCountByClassType(classType)
end
function localQueueRoot:getWorkingCaptainQueue(queue)
	return self.localPosQueueMgr:getWorkingCaptainQueue(queue:getToX(), queue:getToY())
end
function localQueueRoot:isBlock(queue)
	return self.localWarHallQueueMgr:isInBWList(queue)
end
function localQueueRoot:getWarHallQueueFilter(queue, selfAid)
	return self.localWarHallQueueMgr:isFilterBySetting(queue, selfAid)
end
function localQueueRoot:getMassQueuesAttackQueues(queue)
	local _ENV, memberQueueData
	if queue then
		table.insert(memberQueueData, queue)
	end
	local slaveQueueMap = self.localMassQueueMgr:getSlaveQueueMap(queue:getId())
	if slaveQueueMap then
		for _, slaveQueue in pairs(slaveQueueMap) do
			if queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeRally or queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeMoving and slaveQueue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking then
				table.insert(memberQueueData, slaveQueue)
			end
		end
	end
	return memberQueueData
end
function localQueueRoot:getMassQueuesDefendQueues(queue)
	local _ENV, memberQueueData
	table.insert(memberQueueData, queue)
	local defendQueueMap
	if queue:getToMapType() == gMapObjTypeDef.mapObjTypePlayer then
		defendQueueMap = self.localPosQueueMgr:getToPosQueueMap(queue:getToX(), queue:getToY(), queue:getToAid(), gMapMoveLineServerType.moveLineTypeArmyHelp)
	elseif queue:getToMapType() == gMapObjTypeDef.mapObjTypeAllianceBuild then
		defendQueueMap = self.localPosQueueMgr:getToPosQueueMap(queue:getToX(), queue:getToY(), queue:getToAid(), gMapMoveLineServerType.moveLineTypeGuardAllianceBuild)
	else
		defendQueueMap = self.localPosQueueMgr:getToPosQueueMap(queue:getToX(), queue:getToY(), nil, nil, gMapMoveLineStatusType.moveLineStatusTypeWorking)
	end
	for _, defendQueue in pairs(defendQueueMap) do
		if defendQueue:isMainQueueFun() then
			if defendQueue.isCaptain then
				table.insert(memberQueueData, 1, defendQueue)
			else
				table.insert(memberQueueData, defendQueue)
			end
		end
	end
	return memberQueueData
end
function localQueueRoot:getMassQueuesAttacker(queue)
	local _ENV, memberAttacker
	if queue:getFrom() then
		table.insert(memberAttacker, queue:getFrom())
	end
	local slaveQueueMap = self.localMassQueueMgr:getSlaveQueueMap(queue:getId())
	if slaveQueueMap then
		for _, slaveQueue in pairs(slaveQueueMap) do
			if slaveQueue:getFrom() and (queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeRally or queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeMoving and slaveQueue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking) then
				table.insert(memberAttacker, slaveQueue:getFrom())
			end
		end
	end
	return memberAttacker
end
function localQueueRoot:getMassQueuesDefender(queue)
	local _ENV, memberDefender
	if queue:isTargetCapture() then
	elseif queue:getTo() then
		table.insert(memberDefender, queue:getTo())
	end
	local defendQueueMap
	if queue:getToMapType() == gMapObjTypeDef.mapObjTypePlayer then
		defendQueueMap = self.localPosQueueMgr:getToPosQueueMap(queue:getToX(), queue:getToY(), queue:getToAid(), gMapMoveLineServerType.moveLineTypeArmyHelp)
	elseif queue:getToMapType() == gMapObjTypeDef.mapObjTypeAllianceBuild then
		defendQueueMap = self.localPosQueueMgr:getToPosQueueMap(queue:getToX(), queue:getToY(), queue:getToAid(), gMapMoveLineServerType.moveLineTypeGuardAllianceBuild)
	elseif queue:getToMapType() == gMapObjTypeDef.nebulaDefenceWarBuilding then
		return memberDefender
	else
		defendQueueMap = self.localPosQueueMgr:getToPosQueueMap(queue:getToX(), queue:getToY(), nil, nil, gMapMoveLineStatusType.moveLineStatusTypeWorking)
	end
	for _, defendQueue in pairs(defendQueueMap) do
		if defendQueue:getFrom() and defendQueue:isMainQueueFun() then
			if defendQueue.isCaptain then
				table.insert(memberDefender, 1, defendQueue:getFrom())
			else
				table.insert(memberDefender, defendQueue:getFrom())
			end
		end
	end
	return memberDefender
end
function localQueueRoot:addQueue(queue, teamId)
	for _, v in ipairs(self.queueMgrTable) do
		v:addQueue(queue, teamId)
	end
end
function localQueueRoot:removeQueue(queue, teamId)
	for _, v in ipairs(self.queueMgrTable) do
		v:removeQueue(queue, teamId)
	end
	if queue:getUid() and queue:isFromUser(self.uid) and _G._returnQueueIdList then
		_G._returnQueueIdList[queue.id] = nil
	end
end
function localQueueRoot:updateQueue(queue, orgQueueStatus)
	for _, v in ipairs(self.queueMgrTable) do
		v:updateQueue(queue, orgQueueStatus)
	end
end
function localQueueRoot:clear()
	for _, v in ipairs(self.queueMgrTable) do
		v:clear()
	end
end
function localQueueRoot:changeUid(uid)
	self.uid = uid
	for _, v in ipairs(self.queueMgrTable) do
		v.uid = uid
	end
end
function localQueueRoot:refreshQueueByWarSetting()
	self.localWarHallQueueMgr:refreshAll()
	self.localWatchTowerQueueMgr:refreshAllianceSetting()
end
function localQueueRoot:getWatchTowerLightInfo()
	return self.localWatchTowerQueueMgr:getWatchTowerLightInfo()
end
function localQueueRoot:dump()
	for _, v in ipairs(self.queueMgrTable) do
		v:dump()
	end
end
return localQueueRoot
