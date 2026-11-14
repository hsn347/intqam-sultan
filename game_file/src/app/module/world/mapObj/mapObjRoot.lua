local mapObjRoot = class("mapObjRoot")
_UPVALUE4_ = "mapObjRoot"
;("mapObjRoot")[1] = "mapObjMgr"
;("mapObjRoot")[2] = "mapPieceObjMgr"
;("mapObjRoot")[3] = "mapNpcObjMgr"
local ("mapObjRoot")[4], tableMgr = "mapAllianceObjMgr", "mapObjRoot"
function mapObjRoot:ctor(kingdomMapCell)
	self.objMgrTable, _ENV = nil, nil
	for _, v in ipairs(tableMgr) do
		local queueMgrClass = include(v)
		local queueMgr = queueMgrClass.new(kingdomMapCell, self)
		if queueMgr then
			table.insert(self.objMgrTable, queueMgr)
			self[v] = queueMgr
		end
	end
end
function mapObjRoot:addMapObj(mapObjData, kid, pieceId)
	for _, v in ipairs(self.objMgrTable) do
		v:addMapObj(mapObjData, kid, pieceId)
	end
end
function mapObjRoot:removeMapObj(mapObjData, kid, pieceId)
	for _, v in ipairs(self.objMgrTable) do
		v:removeMapObj(mapObjData)
	end
end
function mapObjRoot:updateMapObj(mapObjData)
	for _, v in ipairs(self.objMgrTable) do
		v:updateMapObj(mapObjData)
	end
end
function mapObjRoot:updateMapObjMerge(mapObjData)
	for _, v in ipairs(self.objMgrTable) do
		v:updateMapObjMerge(mapObjData)
	end
end
function mapObjRoot:clear()
	for _, v in ipairs(self.objMgrTable) do
		v:clear()
	end
end
function mapObjRoot:dump()
	for _, v in ipairs(self.objMgrTable) do
		if v.dump then
			v:dump()
		end
	end
end
return mapObjRoot
