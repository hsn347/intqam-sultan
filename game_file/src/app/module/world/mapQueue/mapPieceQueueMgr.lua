local mapSyncUtilClient = include("mapSyncUtilClient")
local mapPieceQueueMgr = class("mapPieceQueueMgr")
function mapPieceQueueMgr:ctor(kingdomMapCell)
	self.kingdomMapCell = kingdomMapCell
	self.kid = kingdomMapCell.kid
	self.pieceQueueMap, _UPVALUE0_, self.queuePieceMap, _UPVALUE0_, self.uid = kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid
end
function mapPieceQueueMgr:addQueue(queueData, kid)
	kid = kid or queueData.kingdomId
	self.queuePieceMap[queueData.id] = mapSyncUtilClient.getLineCrossPieceIds(queueData.from.x + gPointClientPointPlus, queueData.from.y + gPointClientPointPlus, queueData.to.x + gPointClientPointPlus, queueData.to.y + gPointClientPointPlus)
	if self.queuePieceMap[queueData.id] then
		for _, pieceId in pairs(self.queuePieceMap[queueData.id]) do
			if not self.pieceQueueMap[kid] then
				self.pieceQueueMap[kid], mapSyncUtilClient = queueData.to.y + gPointClientPointPlus, queueData.to.y + gPointClientPointPlus
			end
			if not self.pieceQueueMap[kid][pieceId] then
				self.pieceQueueMap[kid][pieceId], mapSyncUtilClient = queueData.to.y + gPointClientPointPlus, queueData.to.y + gPointClientPointPlus
			end
			self.pieceQueueMap[kid][pieceId][queueData.id] = queueData
		end
	end
end
function mapPieceQueueMgr:removeQueue(queueData, kid)
	kid = kid or queueData.kingdomId
	if self.queuePieceMap[queueData.id] then
		for _, pieceId in pairs(self.queuePieceMap[queueData.id]) do
			if self.pieceQueueMap[kid] and self.pieceQueueMap[kid][pieceId] then
				self.pieceQueueMap[kid][pieceId][queueData.id] = nil
			end
		end
		self.queuePieceMap[queueData.id] = nil
	end
end
function mapPieceQueueMgr:updateQueue(queueData, kid)
end
function mapPieceQueueMgr:getQueuePieceIds(queueId)
	return self.queuePieceMap[queueId]
end
function mapPieceQueueMgr:getQueuePieceMap()
	return self.queuePieceMap
end
function mapPieceQueueMgr:getPieceQueues(kid, pieceId)
	return self.pieceQueueMap[kid] and self.pieceQueueMap[kid][pieceId]
end
function mapPieceQueueMgr:getPieceQueueMap()
	return self.pieceQueueMap
end
function mapPieceQueueMgr:isQueueCrossView(queueData, currViewPieceIds)
	for kid, pieceIds in pairs(currViewPieceIds) do
		for _, pieceId in pairs(pieceIds) do
			if self.pieceQueueMap[kid] and self.pieceQueueMap[kid][pieceId] and self.pieceQueueMap[kid][pieceId][queueData.id] then
				return true
			end
		end
	end
	return false
end
function mapPieceQueueMgr:clear()
	self.pieceQueueMap, _UPVALUE0_, self.queuePieceMap, _UPVALUE0_ = nil, nil, nil, nil
end
return mapPieceQueueMgr
