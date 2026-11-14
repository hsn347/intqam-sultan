local mapPosQueueMgr = class("mapPosQueueMgr")
function mapPosQueueMgr:ctor(kingdomMapCell)
	self.kingdomMapCell = kingdomMapCell
	self.kid = kingdomMapCell.kid
	self.xyqMap, _UPVALUE0_, self.uid = kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid
end
function mapPosQueueMgr:addQueue(queueData)
	self:addQueueToPos(queueData.to.x, queueData.to.y, queueData)
end
function mapPosQueueMgr:addQueueToPos(x, y, queueData)
	local xy = serviceFunctions.getMapKey(x, y)
	if not self.xyqMap[xy] then
		self.xyqMap[xy], _ENV = y, y
	end
	self.xyqMap[xy][queueData.id] = queueData
end
function mapPosQueueMgr:removeQueue(queueData)
	self:removeQueueToPos(queueData.to.x, queueData.to.y, queueData)
end
function mapPosQueueMgr:removeQueueToPos(x, y, queueData)
	local xy = serviceFunctions.getMapKey(x, y)
	if self.xyqMap[xy] and self.xyqMap[xy][queueData.id] then
		self.xyqMap[xy][queueData.id] = nil
	end
end
function mapPosQueueMgr:updateQueue(queueData)
end
function mapPosQueueMgr:getToPosQueueMap(x, y)
	local xy = serviceFunctions.getMapKey(x, y)
	return self.xyqMap[xy]
end
function mapPosQueueMgr:hasQueueToPos(x, y)
	local xy = serviceFunctions.getMapKey(x, y)
	return self.xyqMap[xy] and next(self.xyqMap[xy])
end
function mapPosQueueMgr:clear()
	self.xyqMap, _UPVALUE0_ = nil, nil
end
return mapPosQueueMgr
