local mapAllianceObjMgr = class("mapAllianceObjMgr")
function mapAllianceObjMgr:ctor(kingdomMapCell)
	self.kingdomMapCell = kingdomMapCell
	self.kid = kingdomMapCell.kid
	self.allianceObjID, _UPVALUE0_, self.allianceObjMap, _UPVALUE0_, self.uid = kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid
end
function mapAllianceObjMgr:addMapObj(mapObjData)
	local aid = self:getMapObjAid(mapObjData)
	if aid then
		if not self.allianceObjMap[aid] then
			self.allianceObjMap[aid], _UPVALUE0_ = mapObjData, mapObjData
		end
		self.allianceObjMap[aid][mapObjData.id] = mapObjData
		self.allianceObjID[mapObjData.id] = aid
	end
end
function mapAllianceObjMgr:removeMapObj(mapObjData)
	local aid = self.allianceObjID[mapObjData.id]
	if aid then
		local mapObjDataMap = self.allianceObjMap[aid]
		if mapObjDataMap and mapObjDataMap[mapObjData.id] then
			mapObjDataMap[mapObjData.id] = nil
		end
		self.allianceObjID[mapObjData.id] = nil
	end
end
function mapAllianceObjMgr:updateMapObj(mapObjData)
	local aid = self:getMapObjAid(mapObjData)
	if aid then
		self:addMapObj(mapObjData)
	else
		self:removeMapObj(mapObjData)
	end
end
function mapAllianceObjMgr:updateMapObjMerge(mapObjData)
	self:updateMapObj(mapObjData)
end
function mapAllianceObjMgr:getMapObjAid(mapObjData)
	if mapObjData.type == gMapObjTypeDef.mapObjTypeAllianceBuild and mapObjData.build then
		return mapObjData.build.leagueID
	elseif mapObjData.type == gMapObjTypeDef.mapObjTypeSuperResource and mapObjData.superRes then
		return mapObjData.superRes.leagueID
	elseif mapObjData.type == gMapObjTypeDef.mapObjTypePlayer and mapObjData.user then
		return mapObjData.user.leagueID
	elseif mapObjData.type == gMapObjTypeDef.mapObjTypeResource and mapObjData.resource then
		return mapObjData.resource.leagueID
	elseif mapObjData.type == gMapObjTypeDef.mapObjTypeCampsite and mapObjData.camp then
		return mapObjData.camp.leagueID
	elseif mapObjData.type == gMapObjTypeDef.mapTypeATBuilding and mapObjData.data then
		return mapObjData.data.aid
	elseif mapObjData.type == gMapObjTypeDef.mapTypeMine then
		if mapObjData.data then
			return mapObjData.data.leagueID
		end
	elseif mapObjData.type == gMapObjTypeDef.stronghold and mapObjData.data and mapObjData.data.occupy then
		return mapObjData.data.occupy.aid
	end
end
function mapAllianceObjMgr:getAllianceObjMap(aid)
	return self.allianceObjMap[aid]
end
function mapAllianceObjMgr:clear()
	self.allianceObjID, _UPVALUE0_, self.allianceObjMap, _UPVALUE0_ = nil, nil, nil, nil
end
return mapAllianceObjMgr
