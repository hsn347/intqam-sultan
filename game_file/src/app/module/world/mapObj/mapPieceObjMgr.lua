local mapSyncUtilClient = include("mapSyncUtilClient")
local mapPieceObjMgr = class("mapPieceObjMgr")
function mapPieceObjMgr:ctor(kingdomMapCell)
	self.kingdomMapCell = kingdomMapCell
	self.kid = kingdomMapCell.kid
	self.pieceMap, _UPVALUE0_, self.uid = kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid
end
function mapPieceObjMgr:addMapObj(mapObjData, kid, pieceId)
	kid = kid or mapObjData.kid or worldMapDefine.currentMapKindomID
	if kid == nil and worldMapDefine.currentMapKindomID == nil then
		return
	elseif kid == nil then
		kid = worldMapDefine.currentMapKindomID
	end
	pieceId = pieceId or mapSyncUtilClient.getPieceId(cc.p(mapObjData.x, mapObjData.y))
	if not self.pieceMap[kid] then
		self.pieceMap[kid], _ENV = cc.p(mapObjData.x, mapObjData.y)
	end
	if not self.pieceMap[kid][pieceId] then
		self.pieceMap[kid][pieceId], _ENV = cc.p(mapObjData.x, mapObjData.y)
	end
	self.pieceMap[kid][pieceId][mapObjData.id] = mapObjData
end
function mapPieceObjMgr:removeMapObj(mapObjData, kid, pieceId)
	kid = kid or mapObjData.kid
	pieceId = pieceId or mapSyncUtilClient.getPieceId(cc.p(mapObjData.x, mapObjData.y))
	if self.pieceMap[kid] and self.pieceMap[kid][pieceId] then
		self.pieceMap[kid][pieceId][mapObjData.id] = nil
	end
end
function mapPieceObjMgr:updateMapObj(mapObjData)
	self:addMapObj(mapObjData)
end
function mapPieceObjMgr:updateMapObjMerge(mapObjData)
end
function mapPieceObjMgr:getPiece(kid, pieceId)
	return self.pieceMap[kid] and self.pieceMap[kid][pieceId]
end
function mapPieceObjMgr:removePiece(kid, pieceId)
	if self.pieceMap[kid] then
		self.pieceMap[kid][pieceId] = nil
	end
end
function mapPieceObjMgr:getPieceMap()
	return self.pieceMap
end
function mapPieceObjMgr:clear()
	self.queueMap, _UPVALUE0_ = nil, nil
end
return mapPieceObjMgr
