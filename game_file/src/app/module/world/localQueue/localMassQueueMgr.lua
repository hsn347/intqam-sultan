local localMassQueueMgr = class("localMassQueueMgr")
function localMassQueueMgr:ctor(kingdomMapCell, queueRoot)
	self.mainSlaveQueueMap, _UPVALUE0_, self.slaveQueueMap, _UPVALUE0_, self.mainQueueMap, _UPVALUE0_, self.queueRoot = nil, nil, nil, nil, nil, nil, queueRoot
end
function localMassQueueMgr:addQueue(queue)
	if queue:getMoveLineType() == gMapMoveLineType.moveLineTypeMass then
		if queue:isMainQueueFun() then
			self.mainQueueMap[queue:getId()] = queue
		elseif queue:getMainId() then
			self.slaveQueueMap[queue:getId()] = queue
			if not self.mainSlaveQueueMap[queue:getMainId()] then
				self.mainSlaveQueueMap[queue:getMainId()], _ENV = queue, queue
			end
			self.mainSlaveQueueMap[queue:getMainId()][queue:getId()] = queue
		end
	end
end
function localMassQueueMgr:removeQueue(queue)
	if queue:getMoveLineType() == gMapMoveLineType.moveLineTypeMass then
		if queue:isMainQueueFun() then
			self.mainQueueMap[queue:getId()] = nil
			if self.mainSlaveQueueMap[queue:getId()] then
				for slaveQueueId, slaveQueue in pairs(self.mainSlaveQueueMap[queue:getId()]) do
					self.slaveQueueMap[slaveQueueId] = nil
				end
				self.mainSlaveQueueMap[queue:getId()] = nil
			end
		elseif queue:getMainId() then
			self.slaveQueueMap[queue:getId()] = nil
			if self.mainSlaveQueueMap[queue:getMainId()] then
				self.mainSlaveQueueMap[queue:getMainId()][queue:getId()] = nil
			end
		end
	end
end
function localMassQueueMgr:updateQueue(queue)
	if not queue:isMainQueueFun() and queue:getData().isReturn and queue:getOrgMassId() and queue:getMassId() then
		if self.mainQueueMap[queue:getOrgMassId()] then
			self.mainQueueMap[queue:getOrgMassId()] = nil
		end
		if self.mainSlaveQueueMap[queue:getOrgMassId()] then
			self.mainSlaveQueueMap[queue:getOrgMassId()] = nil
		end
	end
end
function localMassQueueMgr:getMainQueue(queueId)
	if queueId then
		return self.mainQueueMap[queueId]
	end
end
function localMassQueueMgr:getSlaveQueue(queueId)
	if queueId then
		return self.slaveQueueMap[queueId]
	end
end
function localMassQueueMgr:getSlaveQueueMap(mainId)
	if mainId then
		if not self.mainSlaveQueueMap[mainId] then
			_UPVALUE0_ = self.mainSlaveQueueMap[mainId]
		end
		return self.mainSlaveQueueMap[mainId]
	end
end
function localMassQueueMgr:getMainQueueBySlaveQueue(slaveQueue)
	if slaveQueue and slaveQueue:getMainId() then
		if slaveQueue:getOrgMassId() then
			return self.queueRoot.localQueueMgr:getQueue(slaveQueue:getMainId())
		else
			return self:getMainQueue(slaveQueue:getMainId())
		end
	end
end
function localMassQueueMgr:isSlaveInMainQueue(mainId, slaveId)
	return self.mainSlaveQueueMap[mainId] and self.mainSlaveQueueMap[mainId][slaveId]
end
function localMassQueueMgr:clear()
	self.mainSlaveQueueMap, _UPVALUE0_, self.slaveQueueMap, _UPVALUE0_, self.mainQueueMap, _UPVALUE0_ = nil, nil, nil, nil, nil, nil
end
function localMassQueueMgr:dump()
	for _, queue in pairs(self.mainQueueMap) do
		print("localMassQueueMgr:dump self.mainQueueMap", queue:getId(), queue:getQueueType(), queue:getStatus())
	end
	for _, queue in pairs(self.slaveQueueMap) do
		print("localMassQueueMgr:dump self.slaveQueueMap", queue:getId(), queue:getQueueType(), queue:getStatus())
	end
	for mainQueueId, slaveQueueMap in pairs(self.mainSlaveQueueMap) do
		for slaveQueueId, _ in pairs(slaveQueueMap) do
			print("localMassQueueMgr:dump self.mainSlaveQueueMap", mainQueueId, slaveQueueId)
		end
	end
end
return localMassQueueMgr
