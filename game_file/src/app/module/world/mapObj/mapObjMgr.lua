local mapObjMgr = class("mapObjMgr")
function mapObjMgr:ctor(kingdomMapCell)
	self.kingdomMapCell = kingdomMapCell
	self.kid = kingdomMapCell.kid
	self.mapObjMap, _UPVALUE0_, self.uid = kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid
end
function mapObjMgr:addMapObj(mapObjData)
	self.mapObjMap[mapObjData.id] = mapObjData
end
function mapObjMgr:removeMapObj(mapObjData)
	self.mapObjMap[mapObjData.id] = nil
end
function mapObjMgr:updateMapObj(mapObjData)
	if self.mapObjMap[mapObjData.id] and self.mapObjMap[mapObjData.id] ~= mapObjData then
		self.mapObjMap[mapObjData.id] = mapObjData
	end
end
function mapObjMgr:updateMapObjMerge(mapObjData)
	if self.mapObjMap[mapObjData.id] and self.mapObjMap[mapObjData.id] ~= mapObjData then
		serviceFunctions.deepMerge(self.mapObjMap[mapObjData.id], mapObjData)
	end
end
function mapObjMgr:getMapObj(mapObjId)
	if mapObjId then
		return self.mapObjMap[mapObjId]
	end
end
function mapObjMgr:getAllMapObj()
	return self.mapObjMap
end
function mapObjMgr:getMapObjByType(instanceType)
	local _ENV, tableObj
	for _, v in pairs(self.mapObjMap) do
		if v.type == instanceType then
			table.insert(tableObj, v)
		end
	end
	return tableObj
end
function mapObjMgr:clear()
	self.mapObjMap, _UPVALUE0_ = nil, nil
end
function mapObjMgr:dump()
	print("mapObjMgr:dump", table.nums(self.mapObjMap))
end
return mapObjMgr
