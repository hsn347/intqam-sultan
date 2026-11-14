local gametop = gModuleMgr.getObject("gametop")
local localWarHallQueueMgr = class("localWarHallQueueMgr")
function localWarHallQueueMgr:ctor(kingdomMapCell, queueRoot)
	self.kingdomMapCell = kingdomMapCell
	self.queueRoot = queueRoot
	self.countList, _ENV, self.whiteListQueueMap, _ENV, self.warHallQueueMap, _ENV, self.uid = kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid
	for _, classType in pairs(gAllianceQueueClassType) do
		self.countList[classType] = 0
	end
end
function localWarHallQueueMgr:addQueue(queue, selfAid, ignoreMsg)
	selfAid = selfAid or self:getSelfAid()
	if not selfAid or selfAid <= 0 then
		return
	end
	if not queue:isWarHallQueue() then
		return
	end
	local thisQueue, otherQueueMap = self:getNeedAddOccupyQueues(queue, selfAid)
	if otherQueueMap then
		for _, otherQueue in pairs(otherQueueMap) do
			self:addWarHallQueue(otherQueue, selfAid, ignoreMsg)
		end
	end
	if thisQueue then
		self:addWarHallQueue(thisQueue, selfAid, ignoreMsg)
	end
end
function localWarHallQueueMgr:addWarHallQueue(queue, selfAid, ignoreMsg)
	if not queue:isWarHallQueue() then
		return
	end
	local isQueueInWarHall, indexID, classType, isFilter = self:isQueueInWarHall(queue, selfAid)
	if isQueueInWarHall and queue:isMainQueueFun() then
		return
	end
	if self:isFilterByWhiteList(queue) then
		self.whiteListQueueMap[queue:getId()] = queue
		return
	end
	if queue:isMainQueueFun() then
		if not self.warHallQueueMap[indexID] then
			queue.queues, _ENV, _ENV = queue, queue, queue
			queue.isMass = queue:getMoveLineType() == gMapMoveLineType.moveLineTypeMass
			queue.isFilter = isFilter
			self.warHallQueueMap[indexID], queue.newClassType = queue, classType
		end
		self.warHallQueueMap[indexID].queues[queue:getId()] = queue
		local newClassType = self.warHallQueueMap[indexID].newClassType
		self.countList[newClassType] = self.countList[newClassType] + 1
		if not ignoreMsg then
			_ENV = self.countList[newClassType] + 1
			;(self.countList[newClassType] + 1).msg = "MESSAGE_GREEN_POINT_UPDATE"
			;(self.countList[newClassType] + 1).type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR
			SoraDSendMessage(self.countList[newClassType] + 1)
			_ENV = GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR
			GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR.msg = "MESSAGE_ALLIACNE_WAR_MAIN_ADD_NEW"
			GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR.data = self.warHallQueueMap[indexID]
			GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR.indexID = indexID
			GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR.queueID = queue:getId()
			self:notifyMsg(GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR)
			if not queue:isFromAlliance(selfAid) then
				self.kingdomMapCell:resetBuildQueueColorByQueue(queue)
			end
		end
	elseif self.warHallQueueMap[indexID] then
		_ENV = self.kingdomMapCell
		self.kingdomMapCell.msg = "MESSAGE_ALLIACNE_WAR_RALLY_ADD_NEW"
		self.kingdomMapCell.data = self.warHallQueueMap[indexID]
		self.kingdomMapCell.indexID = indexID
		self:notifyMsg(self.kingdomMapCell)
	end
	self:updateFilter(indexID, isFilter)
end
function localWarHallQueueMgr:removeQueue(queue)
	local selfAid = self:getSelfAid()
	if not selfAid or selfAid <= 0 then
		return
	end
	if not queue:isWarHallQueue() then
		return
	end
	self:removeWarHallQueue(queue)
	if queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking then
		local queueMap = self:getNeedRemoveOccupyQueues(queue, selfAid)
		if queueMap then
			for _, _queue in pairs(queueMap) do
				if not _queue:isFromAlliance(selfAid) or not _queue:isOccupyMassQueue() then
					self:removeWarHallQueue(_queue)
				end
			end
		end
	end
end
function localWarHallQueueMgr:removeWarHallQueue(queue)
	if not queue:isWarHallQueue() then
		return
	end
	local isQueueInWarHall, indexID, classType, isFilter = self:isQueueInWarHall(queue)
	if not isQueueInWarHall and queue:isMainQueueFun() then
		return
	end
	if self:isFilterByWhiteList(queue) then
		self.whiteListQueueMap[queue:getId()] = nil
		return
	end
	if queue:isMainQueueFun() then
		if self.warHallQueueMap[indexID] then
			self.warHallQueueMap[indexID].queues[queue:getId()] = nil
			self.warHallQueueMap[indexID].isFilter = isFilter
			local newClassType = self.warHallQueueMap[indexID].newClassType
			self.countList[newClassType] = self.countList[newClassType] - 1
			if not next(self.warHallQueueMap[indexID].queues) then
				self.warHallQueueMap[indexID] = nil
			end
			_ENV = self.warHallQueueMap[indexID].queues
			self.warHallQueueMap[indexID].queues.msg = "MESSAGE_GREEN_POINT_UPDATE"
			self.warHallQueueMap[indexID].queues.type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR
			SoraDSendMessage(self.warHallQueueMap[indexID].queues)
			_ENV = GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR
			GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR.msg = "MESSAGE_ALLIACNE_WAR_MAIN_DELETE_NEW"
			GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR.data = self.warHallQueueMap[indexID]
			GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR.indexID = indexID
			GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR.newClassType = newClassType
			GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR.queueID = queue:getId()
			self:notifyMsg(GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR)
			local selfAid = self:getSelfAid()
			if not queue:isFromAlliance(selfAid) then
				self.kingdomMapCell:resetBuildQueueColorByQueue(queue)
			end
		end
	elseif self.warHallQueueMap[indexID] then
		_ENV = self.kingdomMapCell.resetBuildQueueColorByQueue
		self.kingdomMapCell.resetBuildQueueColorByQueue.msg = "MESSAGE_ALLIACNE_WAR_RALLY_DELETE_NEW"
		self.kingdomMapCell.resetBuildQueueColorByQueue.data = self.warHallQueueMap[indexID]
		self.kingdomMapCell.resetBuildQueueColorByQueue.indexID = indexID
		self:notifyMsg(self.kingdomMapCell.resetBuildQueueColorByQueue)
	end
	self:updateFilter(indexID, isFilter)
end
function localWarHallQueueMgr:updateQueue(queue, orgQueueStatus)
	local selfAid = self:getSelfAid()
	if not selfAid or selfAid <= 0 then
		return
	end
	if not queue:isWarHallQueue() then
		return
	end
	if queue:getStatus() < gMapMoveLineStatusType.moveLineStatusTypeWorking then
		self:updateWarHallQueue(queue)
	elseif queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking then
		if orgQueueStatus == gMapMoveLineStatusType.moveLineStatusTypeWorking then
			return
		end
		self:removeWarHallQueue(queue)
		local thisQueue, otherQueueMap = self:getNeedAddOccupyQueues(queue, selfAid)
		if otherQueueMap then
			for _, otherQueue in pairs(otherQueueMap) do
				if otherQueue:getId() ~= queue:getId() then
					self:removeWarHallQueue(otherQueue)
					self:addWarHallQueue(otherQueue, selfAid)
				end
			end
		end
	end
end
function localWarHallQueueMgr:updateWarHallQueue(queue)
	if not queue:isWarHallQueue() then
		return
	end
	local isQueueInWarHall, indexID, classType, isFilter = self:isQueueInWarHall(queue)
	if not isQueueInWarHall and queue:isMainQueueFun() then
		return
	end
	if self:isFilterByWhiteList(queue) then
		self.whiteListQueueMap[queue:getId()] = queue
		return
	end
	if queue:isMainQueueFun() then
		local warHallData = self.warHallQueueMap[indexID]
		if warHallData then
			local newClassType = warHallData.newClassType
			if newClassType ~= classType then
				self.countList[newClassType] = self.countList[newClassType] - 1
				self.countList[classType] = self.countList[classType] + 1
				warHallData.newClassType = classType
				_ENV = self.countList[classType] + 1
				;(self.countList[classType] + 1).msg = "MESSAGE_GREEN_POINT_UPDATE"
				;(self.countList[classType] + 1).type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR
				SoraDSendMessage(self.countList[classType] + 1)
			end
			warHallData.queues[queue:getId()] = queue
			_ENV = queue
			queue.msg = "MESSAGE_ALLIACNE_WAR_UPDATE_STATUS_NEW"
			queue.data = warHallData
			queue.indexID = indexID
			queue.queueID = queue:getId()
			self:notifyMsg(queue)
		end
	elseif self.warHallQueueMap[indexID] then
		_ENV = self.notifyMsg
		self.notifyMsg.msg = "MESSAGE_ALLIACNE_WAR_RALLY_MASS_UPDATE_NEW"
		self.notifyMsg.data = self.warHallQueueMap[indexID]
		self.notifyMsg.indexID = indexID
		self:notifyMsg(self.notifyMsg)
	end
	self:updateFilter(indexID, isFilter)
end
function localWarHallQueueMgr:getIndexID(queue, selfAid)
	local indexID = queue:getId()
	local classType = queue:getAllianceQueueClassType(selfAid)
	local isFilter = false
	if queue:getMoveLineType() == gMapMoveLineType.moveLineTypeMass then
		if queue:isMainQueueFun() then
			isFilter = self:isFilterBySetting(queue, selfAid)
		else
			indexID = queue:getMainId()
			if self.warHallQueueMap[indexID] then
				local mainQueue = self.warHallQueueMap[indexID].queues[queue:getMainId()]
				isFilter = self:isFilterBySetting(mainQueue, selfAid)
			end
		end
	elseif queue:getMoveLineType() == gMapMoveLineType.moveLineTypeAttackLord or queue:getMoveLineType() == gMapMoveLineType.moveLineTypecapture then
		indexID = string.format("%s_%d", queue:getToId(), classType)
		isFilter = self:isFilterBySetting(queue, selfAid)
		if isFilter then
			indexID = string.format("%s_filter", indexID)
		end
	end
	return indexID or queue:getId(), classType, isFilter
end
function localWarHallQueueMgr:isQueueInWarHall(queue, selfAid)
	local indexID, classType, isFilter = self:getIndexID(queue, selfAid)
	return self.warHallQueueMap[indexID] and self.warHallQueueMap[indexID].queues[queue:getMainId()], indexID, classType, isFilter
end
function localWarHallQueueMgr:isFilterBySetting(mainQueue, selfAid)
	dump(mainQueue.from, "mainQueue.from")
	selfAid = selfAid or self:getSelfAid()
	if mainQueue:isFromAlliance(selfAid) or mainQueue:isFromUser(self.uid) then
		return false
	end
	if mainQueue:getQueueType() == gMapMoveLineServerType.moveLineTypeScout then
		return false
	end
	local allianceWarSettingCtrl = include("allianceWarSettingCtrl")
	if mainQueue:getMoveLineType() == gMapMoveLineType.moveLineTypeMass then
		if not allianceWarSettingCtrl:isFilerMass() then
			return false
		end
	elseif not allianceWarSettingCtrl:isFilerSingle() then
		return false
	end
	if mainQueue.from.castleLv and allianceWarSettingCtrl:isFilerLevel() then
		local level = allianceWarSettingCtrl:getFilerLevel()
		if level >= mainQueue.from.castleLv then
			return true
		end
	end
	if mainQueue.from.starLv and allianceWarSettingCtrl:isFilerStar() then
		local star = allianceWarSettingCtrl:getFilerStar()
		if star >= mainQueue.from.starLv then
			return true
		end
	end
	if allianceWarSettingCtrl:isFilerPower() then
		local totalFc = mainQueue:getTotalFc() or 0
		if mainQueue:getMoveLineType() == gMapMoveLineType.moveLineTypeMass then
			local slaveQueueMap = self.queueRoot.localMassQueueMgr:getSlaveQueueMap(mainQueue:getId())
			if slaveQueueMap then
				for _, slaveQueue in pairs(slaveQueueMap) do
					totalFc = totalFc + (slaveQueue:getTotalFc() or 0)
				end
			end
		end
		if totalFc <= allianceWarSettingCtrl:getFilerPower() then
			return true
		end
	end
	return false
end
function localWarHallQueueMgr:isInBWList(queue)
	local allianceBWList = gametop.playertop_:getModule("allianceBWList")
	return allianceBWList:isInBWList(queue:getAid())
end
function localWarHallQueueMgr:isFilterByWhiteList(queue)
	if queue:getAid() and queue:getAid() > 0 and queue:getMoveLineType() ~= gMapMoveLineType.moveLineTypeMass and self:isInBWList(queue) == gAllianceBWListType.WHITE then
		return true
	end
	return false
end
function localWarHallQueueMgr:getNeedAddOccupyQueues(queue, selfAid)
	selfAid = selfAid or self:getSelfAid()
	if queue:isOccupySingleQueue() and queue:isMainQueueFun() or queue:isOccupyMassQueue() and not queue:isFromAlliance(selfAid) then
		local targetAid = self.queueRoot.localPosQueueMgr:getPosAid(queue:getToX(), queue:getToY())
		if (not targetAid or not (0 < targetAid)) and (queue:getToMapType() == gMapObjTypeDef.mapTypeRadianceWarGate or queue:getToMapType() == gMapObjTypeDef.mapTypeRadianceWarBeacon) then
			targetAid = selfAid
		end
		if targetAid and 0 < targetAid then
			if targetAid == selfAid then
				if queue:getStatus() < gMapMoveLineStatusType.moveLineStatusTypeWorking then
					if not queue:isFromAlliance(selfAid) or queue:isOccupyMassQueue() then
						return queue
					end
				elseif queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking then
					local thisQueue
					if queue:isFromAlliance(selfAid) and queue:isOccupyMassQueue() then
						thisQueue = queue
					end
					return thisQueue, self.queueRoot.localPosQueueMgr:getToPosOtherAllianceQueueMap(queue:getToX(), queue:getToY(), selfAid)
				end
			elseif queue:getStatus() < gMapMoveLineStatusType.moveLineStatusTypeWorking then
				if queue:isFromAlliance(selfAid) then
					return queue
				end
			elseif queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking then
				return nil, self.queueRoot.localPosQueueMgr:getToPosQueueMap(queue:getToX(), queue:getToY(), selfAid)
			end
		end
	else
		return queue
	end
end
function localWarHallQueueMgr:getNeedRemoveOccupyQueues(queue, selfAid)
	selfAid = selfAid or self:getSelfAid()
	if queue:isOccupySingleQueue() and queue:isMainQueueFun() then
		local targetAid = self.queueRoot.localPosQueueMgr:getPosAid(queue:getToX(), queue:getToY())
		if (not targetAid or not (0 < targetAid)) and (queue:getToMapType() == gMapObjTypeDef.mapTypeRadianceWarGate or queue:getToMapType() == gMapObjTypeDef.mapTypeRadianceWarBeacon) then
			targetAid = selfAid
		end
		if targetAid and 0 < targetAid then
			if targetAid == selfAid and targetAid ~= queue:getAid() then
				return self.queueRoot.localPosQueueMgr:getToPosQueueMap(queue:getToX(), queue:getToY(), selfAid)
			elseif targetAid == selfAid or targetAid == queue:getAid() then
				return
			else
				return self.queueRoot.localPosQueueMgr:getToPosOtherAllianceQueueMap(queue:getToX(), queue:getToY(), selfAid)
			end
		else
			return self.queueRoot.localPosQueueMgr:getToPosQueueMap(queue:getToX(), queue:getToY())
		end
	end
end
function localWarHallQueueMgr:getWarHallData(indexID)
	return self.warHallQueueMap[indexID]
end
function localWarHallQueueMgr:getAllWarHallQueue()
	return self.warHallQueueMap
end
function localWarHallQueueMgr:clear()
	self.countList, _ENV, self.whiteListQueueMap, _ENV, self.warHallQueueMap, _ENV = nil, nil, nil, nil, nil, nil
	for _, classType in pairs(gAllianceQueueClassType) do
		self.countList[classType] = 0
	end
	_ENV = pairs(gAllianceQueueClassType)
	pairs(gAllianceQueueClassType).msg = "MESSAGE_GREEN_POINT_UPDATE"
	pairs(gAllianceQueueClassType).type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR
	SoraDSendMessage(pairs(gAllianceQueueClassType))
end
function localWarHallQueueMgr:refreshAll()
	local oldWarHallQueueMap = self.warHallQueueMap
	self:clear()
	for _, warHallData in pairs(oldWarHallQueueMap) do
		for _, queue in pairs(warHallData.queues) do
			self:addQueue(queue, nil, true)
		end
	end
	_ENV = pairs(oldWarHallQueueMap)
	pairs(oldWarHallQueueMap).msg = "MESSAGE_GREEN_POINT_UPDATE"
	pairs(oldWarHallQueueMap).type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR
	SoraDSendMessage(pairs(oldWarHallQueueMap))
end
function localWarHallQueueMgr:getWarHallAttackCount()
	return self:getWarHallCountByClassType(gAllianceQueueClassType.pvp)
end
function localWarHallQueueMgr:getWarHallDefendCount()
	return self:getWarHallCountByClassType(gAllianceQueueClassType.pvp_def)
end
function localWarHallQueueMgr:getWarHallActivityCount()
	return self:getWarHallCountByClassType(gAllianceQueueClassType.pve) + self:getWarHallCountByClassType(gAllianceQueueClassType.pve_moving)
end
function localWarHallQueueMgr:getWarHallAllCount()
	local ret = 0
	for k, count in pairs(self.countList) do
		ret = ret + count
	end
	return ret
end
function localWarHallQueueMgr:getWarHallCountByClassType(classType)
	return self.countList[classType] or 0
end
function localWarHallQueueMgr:isHasWarHallQueues(indexID)
	local warHallData = self.warHallQueueMap[indexID]
	if warHallData and warHallData.queues and next(warHallData.queues) then
		return true
	end
end
function localWarHallQueueMgr:getSortWarHallQueues(indexID)
	local warHallData = self.warHallQueueMap[indexID]
	local _ENV, sortQueues
	if warHallData and warHallData.queues and next(warHallData.queues) then
		for _, queue in pairs(warHallData.queues) do
			table.insert(sortQueues, queue)
		end
		table.sort(sortQueues, function(q1, q2)
			local remainTime1 = q1:getStatusRemainTime()
			local remainTime2 = q2:getStatusRemainTime()
			if remainTime1 == remainTime2 then
				if q1:getCreateTime() == q2:getCreateTime() then
					return q1:getId() < q2:getId()
				else
					return q1:getCreateTime() > q2:getCreateTime()
				end
			else
				return remainTime1 < remainTime2
			end
		end)
	end
	return sortQueues
end
function localWarHallQueueMgr:notifyDefendQueueChanged(msgType, indexID, queueId)
	local warHallData = self.warHallQueueMap[indexID]
	if not warHallData then
		indexID = indexID .. "_filter"
		warHallData = self.warHallQueueMap[indexID]
	end
	if warHallData then
		_UPVALUE0_ = nil
		;(nil).msg = msgType
		;(nil).data = warHallData
		;(nil).indexID = indexID
		;(nil).queueID = queueId
		self:notifyMsg(nil)
	end
end
function localWarHallQueueMgr:notifyMsg(msg)
	if msg then
		msg.queueRoot = self.queueRoot
	end
	SoraDSendMessage(msg)
end
function localWarHallQueueMgr:onAddWhiteList(aid)
	self:refreshAll()
end
function localWarHallQueueMgr:onDelWhiteList(aid)
	for _, queue in pairs(self.whiteListQueueMap) do
		if queue:isFromAlliance(aid) then
			self:addQueue(queue)
		end
	end
end
function localWarHallQueueMgr:onAddBlackList(aid)
end
function localWarHallQueueMgr:onDelBlackList(aid)
end
function localWarHallQueueMgr:onDismissAlliance()
	self:refreshAll()
end
function localWarHallQueueMgr:getSelfAid()
	return self.queueRoot:getOwnTeamID()
end
function localWarHallQueueMgr:updateFilter(indexID, isFilter)
	if self.warHallQueueMap[indexID] then
		local oldFiler = self.warHallQueueMap[indexID].isFilter
		local newClassType = self.warHallQueueMap[indexID].newClassType
		self.warHallQueueMap[indexID].isFilter = isFilter
		if oldFiler ~= isFilter then
			_UPVALUE0_ = nil
			;(nil).msg = "MESSAGE_ALLIACNE_WAR_MAIN_FILER_STATUS"
			;(nil).data = self.warHallQueueMap[indexID]
			;(nil).indexID = indexID
			;(nil).newClassType = newClassType
			self:notifyMsg(nil)
		end
	end
end
function localWarHallQueueMgr:dump()
	local str
	local _ENV, warHallQueueIds
	for indexID, warHallData in pairs(self.warHallQueueMap) do
		local _ENV, queueIds
		for queueId, _ in pairs(warHallData.queues) do
			table.insert(queueIds, queueId)
		end
		if next(queueIds) then
			table.insert(warHallQueueIds, string.format("indexID:%s [%s] isMass:%s isFilter:%s \n", indexID, table.concat(queueIds, ","), warHallData.isMass and "true" or "false", warHallData.isFilter and "true" or "false"))
		end
	end
	str = table.concat(warHallQueueIds, " ")
	print("localWarHallQueueMgr:dump", str)
end
return localWarHallQueueMgr
