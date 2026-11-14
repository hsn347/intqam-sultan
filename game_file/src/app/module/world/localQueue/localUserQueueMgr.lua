local localUserQueueMgr = class("localUserQueueMgr")
function localUserQueueMgr:ctor(kingdomMapCell, queueRoot)
	self.uid = kingdomMapCell.uid
	self.toUserQueueMap, _UPVALUE0_, self.fromUserQueueMap, _UPVALUE0_, self.queueRoot = kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid, queueRoot
end
function localUserQueueMgr:addQueue(queue)
	if queue:getUid() then
		if not self.fromUserQueueMap[queue:getUid()] then
			self.fromUserQueueMap[queue:getUid()], _ENV = queue, queue
		end
		self.fromUserQueueMap[queue:getUid()][queue:getId()] = queue
		if queue:isFromUser(self.uid) then
			local eventState = gMapEventStateDef.mapEventStateAdd
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW"
			;(nil).eventState = eventState
			;(nil).data = queue
			self:notifyMsg(nil, nil)
			_ENV = self
			self.msg = "MESSAGE_UI_PANDECT_MARCH"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_UI_PANDECT_CAR"
			SoraDSendMessage(self)
		end
	end
	if queue:getToUid() then
		if not self.toUserQueueMap[queue:getToUid()] then
			self.toUserQueueMap[queue:getToUid()], _ENV = queue, queue
		end
		self.toUserQueueMap[queue:getToUid()][queue:getId()] = queue
		if self:isHelpMeQueue(queue) or self:isHelpMyAllianceQueue(queue) then
			_ENV = self
			_ENV, _UPVALUE1_, self.msg = nil, queue, "MESSAGE_REINFORCEMENTS_ADD"
			;(nil).data = queue
			self.data, queue[1] = queue
			SoraDSendMessage(self, nil)
		end
	end
end
function localUserQueueMgr:removeQueue(queue)
	if queue:getUid() then
		if self.fromUserQueueMap[queue:getUid()] then
			self.fromUserQueueMap[queue:getUid()][queue:getId()] = nil
		end
		if queue:isFromUser(self.uid) or queue:isMassMainQueue() then
			local eventState = gMapEventStateDef.mapEventStateDelete
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW"
			;(nil).eventState = eventState
			;(nil).data = queue
			self:notifyMsg(nil, nil)
			_ENV = self
			_ENV, self.msg = nil, "MESSAGE_ARMY_WORLDMAPCONTROL_CLOSEWINDOW"
			self.data, (nil).id = nil, queue:getId()
			SoraDSendMessage(self)
			_ENV = self
			_ENV, self.msg = nil, "MESSAGE_SERVER_WORLD_MAP_REMAINS_DISAPPEAR"
			self.data, (nil).id = nil, queue:getId()
			SoraDSendMessage(self, nil)
			_ENV = self
			self.msg = "MESSAGE_UI_PANDECT_MARCH"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_UI_PANDECT_CAR"
			SoraDSendMessage(self)
		end
	end
	if queue:getToUid() and self.toUserQueueMap[queue:getToUid()] then
		local orgQueue = self.toUserQueueMap[queue:getToUid()][queue:getId()]
		self.toUserQueueMap[queue:getToUid()][queue:getId()] = nil
		if self:isHelpMeQueue(orgQueue) then
			_ENV = self
			_ENV, self.msg = orgQueue, "MESSAGE_REINFORCEMENTS_SUB"
			self.data, orgQueue[1] = orgQueue, orgQueue:getId()
			self.data, orgQueue[2] = orgQueue, orgQueue:getId()
			SoraDSendMessage(self, nil)
		elseif self:isHelpMyAllianceQueue(queue) then
			_ENV = self
			_ENV, self.msg = queue, "MESSAGE_REINFORCEMENTS_SUB"
			self.data, queue[1] = queue, orgQueue:getFromUid()
			self.data, queue[2] = queue, orgQueue:getFromUid()
			SoraDSendMessage(self, nil)
		end
	end
end
function localUserQueueMgr:updateQueue(queue)
	if queue:getUid() then
		if queue:isFromUser(self.uid) then
			local eventState = gMapEventStateDef.mapEventStateModify
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW"
			;(nil).eventState = eventState
			;(nil).data = queue
			self:notifyMsg(nil, nil)
			_ENV = self
			_ENV, self.msg = nil, "MESSAGE_ARMY_SPEEDUP_TIMEREFRESH"
			self.data, (nil).id = nil, queue:getId()
			SoraDSendMessage(self)
		else
			local mySlaveQueue = self:getMySalveQueueByMainQueue(queue)
			if mySlaveQueue then
				_ENV = nil
				;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW"
				;(nil).eventState = gMapEventStateDef.mapEventStateModify
				;(nil).data = mySlaveQueue
				self:notifyMsg(nil, nil)
				_ENV = self
				_ENV, self.msg = nil, "MESSAGE_ARMY_SPEEDUP_TIMEREFRESH"
				self.data, (nil).id = nil, mySlaveQueue:getId()
				SoraDSendMessage(self)
				_ENV = self
				self.msg = "MESSAGE_UI_PANDECT_MARCH"
				SoraDSendMessage(self)
				_ENV = self
				self.msg = "MESSAGE_UI_PANDECT_CAR"
				SoraDSendMessage(self)
			end
		end
	end
	if queue:getToUid() and (self:isHelpMeQueue(queue) or self:isHelpMyAllianceQueue(queue)) then
		_ENV = self
		_ENV, _UPVALUE1_, self.msg = nil, queue, "MESSAGE_REINFORCEMENTS_ADD"
		;(nil).data = queue
		self.data, queue[1] = queue
		SoraDSendMessage(self, nil)
	end
end
function localUserQueueMgr:notifyMsg(msg)
	if self.queueRoot:isWarQueueRoot() then
		return
	end
	SoraDSendMessage(msg)
end
function localUserQueueMgr:getFromUserQueueMap(uid, moveLineType, queueType, queueStatus, toMapObjId, toObjId, isExceptHeroReturnQueue)
	local _ENV, queueMap
	if uid and self.fromUserQueueMap[uid] then
		for queueId, queue in pairs(self.fromUserQueueMap[uid]) do
			if (not moveLineType or moveLineType == queue:getMoveLineType()) and (not queueType or queueType == queue:getQueueType()) and (not queueStatus or queueStatus == queue:getStatus()) and (not toMapObjId or toMapObjId == queue:getToId()) and (not toObjId or toObjId == queue:getToObjId()) and (not isExceptHeroReturnQueue or not queue:isHeroReturnFun()) then
				queueMap[queueId] = queue
			end
		end
	end
	return queueMap
end
function localUserQueueMgr:getToUserQueueMap(uid, moveLineType, queueType, queueStatus)
	local _ENV, queueMap
	if uid and self.toUserQueueMap[uid] then
		for queueId, queue in pairs(self.toUserQueueMap[uid]) do
			if (not moveLineType or moveLineType == queue:getMoveLineType()) and (not queueType or queueType == queue:getQueueType()) and (not queueStatus or queueStatus == queue:getStatus()) then
				queueMap[queueId] = queue
			end
		end
	end
	return queueMap
end
function localUserQueueMgr:getMyMassQueueMap(uid)
	local _ENV, queueMap
	if uid and self.fromUserQueueMap[uid] then
		for queueId, queue in pairs(self.fromUserQueueMap[uid]) do
			if queue:isMassMainQueue() and not queue:hasToUser() and queue:isMassing() then
				queueMap[queueId] = queue
			end
		end
	end
	return queueMap
end
function localUserQueueMgr:hasFromUserQueueToMapType(uid, mapType)
	if self.fromUserQueueMap[uid] then
		for _, queue in pairs(self.fromUserQueueMap[uid]) do
			if not mapType or mapType == queue:getToMapType() then
				return true
			end
		end
	end
end
function localUserQueueMgr:hasFromUserQueue(uid, moveLineType, queueType, queueStatus, toMapObjId, toObjId)
	if self.fromUserQueueMap[uid] then
		for _, queue in pairs(self.fromUserQueueMap[uid]) do
			if (not moveLineType or moveLineType == queue:getMoveLineType()) and (not queueType or queueType == queue:getQueueType()) and (not queueStatus or queueStatus == queue:getStatus()) and (not toMapObjId or toMapObjId == queue:getToId()) and (not toObjId or toObjId == queue:getToObjId()) then
				return true, queue:getId()
			end
		end
	end
end
function localUserQueueMgr:hasToUserQueue(uid, moveLineType, queueType, queueStatus)
	if self.toUserQueueMap[uid] then
		for _, queue in pairs(self.toUserQueueMap[uid]) do
			if (not moveLineType or moveLineType == queue:getMoveLineType()) and (not queueType or queueType == queue:getQueueType()) and (not queueStatus or queueStatus == queue:getStatus()) then
				return true
			end
		end
	end
end
function localUserQueueMgr:isHelpMeQueue(queue)
	return queue and queue:isToUser(self.uid) and queue:getQueueType() == gMapMoveLineServerType.moveLineTypeArmyHelp and queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking
end
function localUserQueueMgr:isHelpMyAllianceQueue(queue)
	print("isHelpMyAllianceQueue", queue:isToAlliance(self.queueRoot:getSelfAid()), queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking, queue:getQueueType() == gMapMoveLineServerType.moveLineTypeGuardAllianceBuild)
	return queue and queue:isToAlliance(self.queueRoot:getSelfAid()) and queue:getQueueType() == gMapMoveLineServerType.moveLineTypeGuardAllianceBuild and queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking
end
function localUserQueueMgr:getMySalveQueueByMainQueue(queue)
	if queue:getMoveLineType() == gMapMoveLineType.moveLineTypeMass and queue:isMainQueueFun() then
		local myQueues = self:getFromUserQueueMap(self.uid, gMapMoveLineType.moveLineTypeMass, nil, gMapMoveLineStatusType.moveLineStatusTypeWorking)
		for _, mySlaveQueue in pairs(myQueues) do
			if self.queueRoot.localMassQueueMgr:isSlaveInMainQueue(queue:getId(), mySlaveQueue:getId()) then
				return mySlaveQueue
			end
		end
	elseif queue:getQueueType() == gMapMoveLineServerType.moveLineTypeReturn and queue:getData().isMassReturn then
		local myQueues = self:getFromUserQueueMap(self.uid, gMapMoveLineType.moveLineTypeMass, nil, gMapMoveLineStatusType.moveLineStatusTypeWorking)
		for _, mySlaveQueue in pairs(myQueues) do
			if mySlaveQueue:getMainId() == queue:getId() then
				return mySlaveQueue
			end
		end
	end
end
function localUserQueueMgr:getFromUserAlreadyReturnQueue(uid)
	local _ENV, queueMap
	if uid and self.fromUserQueueMap[uid] then
		for queueId, queue in pairs(self.fromUserQueueMap[uid]) do
			if queue:getQueueType() == gMapMoveLineServerType.moveLineTypeReturn and queue:getOrgId() then
				queueMap[queue:getOrgId()] = true
			end
		end
	end
	return queueMap
end
function localUserQueueMgr:getFromUserQueueNum(uid, moveLineType, queueType, queueStatus, toMapObjId, toObjId, isExceptHeroReturnQueue)
	local n = 0
	local alreadyReturnQueueMap = self:getFromUserAlreadyReturnQueue(uid)
	local queueMap = self:getFromUserQueueMap(uid, moveLineType, queueType, queueStatus, toMapObjId, toObjId, isExceptHeroReturnQueue)
	for queueId, _ in pairs(queueMap) do
		if not alreadyReturnQueueMap[queueId] then
			n = n + 1
		end
	end
	return n
end
function localUserQueueMgr:getFromInstanceIDQueue(instanceID, uid, moveLineType, queueType)
	if uid and self.toUserQueueMap[uid] then
		for _, queue in pairs(self.toUserQueueMap[uid]) do
			if (not instanceID or instanceID == queue:getFromMapObjId()) and (not moveLineType or moveLineType == queue:getMoveLineType()) and (not queueType or queueType == queue:getQueueType()) then
				return queue
			end
		end
	end
	return nil
end
function localUserQueueMgr:getToInstanceIDQueue(instanceID, uid, moveLineType, queueType)
	if uid and self.fromUserQueueMap[uid] then
		for _, queue in pairs(self.fromUserQueueMap[uid]) do
			if (not instanceID or instanceID == queue:getToMapObjId()) and (not moveLineType or moveLineType == queue:getMoveLineType()) and (not queueType or queueType == queue:getQueueType()) then
				return queue
			end
		end
	end
	return nil
end
function localUserQueueMgr:hasFromUserCommandHallQueue(uid, index, taskType)
	print("==localUserQueueMgr:hasFromUserCommandHallQueue==", index, taskType)
	dump(self.fromUserQueueMap[uid])
	if self.fromUserQueueMap[uid] then
		for _, queue in pairs(self.fromUserQueueMap[uid]) do
			if gMapMoveLineType.moveLineTypeCommandHallNpc == queue:getMoveLineType() and (not index or queue.taskData and index == queue.taskData.index) and (not taskType or queue.taskData and taskType == queue.taskData.type) then
				return true, queue:getId()
			end
		end
	end
end
function localUserQueueMgr:clear()
	self.toUserQueueMap, _UPVALUE0_, self.fromUserQueueMap, _UPVALUE0_ = nil, nil, nil, nil
end
function localUserQueueMgr:dump()
	if not self.fromUserQueueMap[self.uid] then
		local _ENV, queueMap = self.fromUserQueueMap[self.uid], self.fromUserQueueMap[self.uid]
	end
	local str
	local _ENV, queueIds
	for queueId, _ in pairs(queueMap) do
		table.insert(queueIds, queueId)
	end
	str = string.format("selfQueues[%s]", table.concat(queueIds, ","))
	print("localUserQueueMgr:dump", str)
end
return localUserQueueMgr
