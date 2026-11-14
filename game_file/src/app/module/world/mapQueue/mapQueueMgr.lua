local mapQueueMgr = class("mapQueueMgr")
function mapQueueMgr:ctor(kingdomMapCell)
	self.kingdomMapCell = kingdomMapCell
	self.kid = kingdomMapCell.kid
	self.queueMap, _UPVALUE0_, self.uid = kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid
end
function mapQueueMgr:addQueue(queueData)
	self.queueMap[queueData.id] = queueData
end
function mapQueueMgr:removeQueue(queueData)
	self.queueMap[queueData.id] = nil
end
function mapQueueMgr:updateQueue(queueData)
	local data = self.queueMap[queueData.id]
	if data and data ~= queueData then
		serviceFunctions.deepMerge(data, queueData)
	end
end
function mapQueueMgr:getQueue(queueId)
	if queueId then
		return self.queueMap[queueId]
	end
end
function mapQueueMgr:getAllQueue()
	return self.queueMap
end
function mapQueueMgr:clear()
	self.queueMap, _UPVALUE0_ = nil, nil
end
function mapQueueMgr:dump()
	print("mapQueueMgr:dump", table.nums(self.queueMap))
end
return mapQueueMgr
