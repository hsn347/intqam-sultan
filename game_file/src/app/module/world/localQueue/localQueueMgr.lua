local localQueueMgr = class("localQueueMgr")
function localQueueMgr:ctor(kingdomMapCell)
	self.queueMap, _UPVALUE0_ = nil, nil
end
function localQueueMgr:addQueue(queue)
	self.queueMap[queue:getId()] = queue
end
function localQueueMgr:removeQueue(queue)
	self.queueMap[queue:getId()] = nil
end
function localQueueMgr:updateQueue(queue)
	if self.queueMap[queue:getId()] and self.queueMap[queue:getId()] ~= queue then
		serviceFunctions.deepMerge(self.queueMap[queue:getId()], queue)
		self.queueMap[queue:getId()].from.army = queue.from.army
		self.queueMap[queue:getId()].from.heroInfo = queue.from.heroInfo
		self.queueMap[queue:getId()].from.armsInfo = queue.from.armsInfo
		self.queueMap[queue:getId()].from.divineBeastInfo = queue.from.divineBeastInfo
	end
end
function localQueueMgr:getQueue(queueId)
	if queueId then
		return self.queueMap[queueId]
	end
end
function localQueueMgr:clear()
	self.queueMap, _UPVALUE0_ = nil, nil
end
function localQueueMgr:dump()
	for _, queue in pairs(self.queueMap) do
		print("localQueueMgr:dump self.queueMap", queue:getId(), queue:getQueueType(), queue:getStatus())
	end
end
return localQueueMgr
