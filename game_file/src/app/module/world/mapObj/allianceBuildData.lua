local allianceBuildData = class("allianceBuildData")
function allianceBuildData:ctor(kingdomMapCell)
	self.kingdomMapCell = kingdomMapCell
	self.mapObjMapVersion, _UPVALUE0_, self.mapObjMap, _UPVALUE0_, self.kid = kingdomMapCell.kid, kingdomMapCell.kid, kingdomMapCell.kid, kingdomMapCell.kid, kingdomMapCell.kid
end
function allianceBuildData:addMapObj_imp(mapObjData, data, kid, aid, colorId)
	local id = data.id
	if id then
		data.kid = kid
		if data.build then
			data.build.leagueID = aid
			if colorId then
				data.build.colorId = colorId
			end
		end
		mapObjData[id] = data
	end
end
function allianceBuildData:addMapObjArray(data, kid, aid, colorId)
	local mapObjData = self:getAllBuildByKid(kid)
	for _, v in ipairs(data) do
		self:addMapObj_imp(mapObjData, v, kid, aid, colorId)
	end
end
function allianceBuildData:addMapObj(data, kid, aid, colorId)
	local mapObjData = self:getAllBuildByKid(kid)
	self:addMapObj_imp(mapObjData, data, kid, aid, colorId)
end
function allianceBuildData:addMapObj_stronghold(mapObjData, data, kid)
	local id = data.id
	if id then
		data.kid = kid
		mapObjData[id] = data
	end
end
function allianceBuildData:addStrongHoldArray(data, kid)
	local mapObjData = self:getAllBuildByKid(kid)
	for _, v in ipairs(data) do
		self:addMapObj_stronghold(mapObjData, v, kid)
	end
end
function allianceBuildData:updateStrongHold(data, kid)
	local mapObjData = self:getAllBuildByKid(kid)
	self:addMapObj_stronghold(mapObjData, data, kid)
end
function allianceBuildData:removeMapObj(data, kid)
	local id = data.id
	if id then
		local mapObjData = self.mapObjMap[kid]
		if mapObjData then
			mapObjData[id] = nil
		end
	end
end
function allianceBuildData:getAllBuildByKid(kid)
	kid = kid or self.kid
	local mapObjData = self.mapObjMap[kid]
	if nil == mapObjData then
		mapObjData, _UPVALUE0_ = nil, nil
		self.mapObjMap[kid] = mapObjData
	end
	return mapObjData
end
function allianceBuildData:getMapObj(kid, data)
	kid = kid or self.kid
	local mapObjData = self.mapObjMap[kid]
	if mapObjData then
		local id = data.id
		if id then
			return mapObjData[id]
		end
	end
end
function allianceBuildData:resetAllBuildByKid(kid)
	kid = kid or self.kid
	self.mapObjMap[kid], _UPVALUE0_ = nil, nil
	self.mapObjMapVersion[kid] = nil
end
function allianceBuildData:setVersion(kid, version)
	self.mapObjMapVersion[kid] = version
end
function allianceBuildData:getVersion(kid)
	kid = kid or self.kid
	return self.mapObjMapVersion[kid]
end
function allianceBuildData:clear()
	self.mapObjMap, _UPVALUE0_ = nil, nil
end
function allianceBuildData:dump()
	print("allianceBuildData:dump", table.nums(self.mapObjMap))
end
return allianceBuildData
