local worldMapBuildManor = class("worldMapBuildManor")
local worldMapDefine = include("worldMapDefine")
local mapSyncUtilClient = include("mapSyncUtilClient")
local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
local DEFAULT_TILE_POINT = cc.p(0, 0)
function worldMapBuildManor:ctor()
	self.size = 1
	self.radioation = 1
	self.isRelationChanged = false
	self.manorLeagueID = 0
	self.instanceType = 0
	self.instanceID = 0
	self.kingdomID = 0
	self.worldMapCell = nil
	self.tilePoint = DEFAULT_TILE_POINT
	self.pieceID = nil
	self:resetData()
end
function worldMapBuildManor:resetData(...)
	self.activityStatus = true
	self.leagueID = 0
	self.manorLeagueID = 0
	self.sn = -1
	self.warStatus = nil
	self.colorId = 0
end
function worldMapBuildManor:setInstanceID(instanceID)
	self.instanceID = instanceID
end
function worldMapBuildManor:getInstanceID()
	return self.instanceID
end
function worldMapBuildManor:setKingdomID(kingdomID)
	self.kingdomID = kingdomID
end
function worldMapBuildManor:setMapTypeClass(mapTypeClass)
	self.mapTypeClass = mapTypeClass
end
function worldMapBuildManor:getKingdomID()
	return self.kingdomID
end
function worldMapBuildManor:setWorldMapCell(worldMapCell)
	self.worldMapCell = worldMapCell
end
function worldMapBuildManor:getWorldMapCell()
	return self.worldMapCell
end
function worldMapBuildManor:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function worldMapBuildManor:getTilePoint()
	return self.tilePoint
end
function worldMapBuildManor:setInstanceType(instanceType)
	self.instanceType = instanceType
end
function worldMapBuildManor:getInstanceType()
	return self.instanceType
end
function worldMapBuildManor:showInstance(show, delayTime)
	if self.leagueID then
		local updateType = worldMapLeagueManorUpdateType.leagueManorInstanceAdd
		if not show then
			updateType = worldMapLeagueManorUpdateType.leagueManorInstanceRemove
		end
		self:sendUpdateMsg(updateType)
	end
end
function worldMapBuildManor:setBuildSize(size, radioation)
	self.size = size
	self.radioation = radioation
end
function worldMapBuildManor:initInstanceData(objData, worldInstanceData, instanceData)
	local instanceType = self:getInstanceType()
	local buildClassID = worldInstanceData.class
	self.__init = false
	if instanceType == gMapObjTypeDef.mapObjTypeAllianceBuild then
		local buildInfo = worldMapDefine.getAllianceBuildInfo(buildClassID)
		if buildInfo then
			self:setBuildSize(buildInfo.size, buildInfo.radioation)
		end
	elseif instanceType == gMapObjTypeDef.stronghold then
		self:setBuildSize(2, 4)
		self.sn = gManorlineSn.strongHold
		self.leagueID = -1
	end
	self:updateData(objData, true)
	self.__init = true
end
function worldMapBuildManor:updateData(data, init)
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if data.colorId then
		self.colorId = data.colorId
	end
	if data.occupy then
		self.leagueID = data.occupy.leagueID or data.occupy.aid
		if data.occupy.colorId then
			self.colorId = data.occupy.colorId
		end
	end
	local sendMsg = false
	local leagueID
	local instanceType = self:getInstanceType()
	if instanceType == gMapObjTypeDef.stronghold and self.warStatus ~= data.warStatus then
		self.warStatus = data.warStatus
		sendMsg = true
		if data.warStatus == gKingdomWarStatusType.inWar then
			self:sendUpdateMsg(worldMapLeagueManorUpdateType.leagueManorInstanceRemove)
			leagueID = -1
			self.colorId = 0
		else
			self:sendUpdateMsg(worldMapLeagueManorUpdateType.leagueManorInstanceRemove)
		end
	end
	self.manorLeagueID = leagueID or self.leagueID
	if sendMsg then
		self:sendUpdateMsg(worldMapLeagueManorUpdateType.leagueManorInstanceAdd)
	end
	if data.sn then
		self.sn = data.sn
	end
	if data.isAct ~= nil then
		self.activityStatus = data.isAct
		self:sendUpdateMsg(worldMapLeagueManorUpdateType.leagueManorInstanceActiviy)
	end
	if data.isRelationChanged then
		self:sendUpdateMsg(worldMapLeagueManorUpdateType.leagueManorRelationChange)
	end
end
function worldMapBuildManor:sendUpdateMsg(updateType)
	if self.__init then
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE"
		;(nil).updateType = updateType
		;(nil).instanceID = self.instanceID
		;(nil).leagueID = self.manorLeagueID
		;(nil).kingdomID = self.kingdomID
		;(nil).tilePoint = self.tilePoint
		;(nil).size = self.size
		;(nil).radioation = self.radioation
		;(nil).sn = self.sn
		;(nil).activityStatus = self.activityStatus
		;(nil).colorId = self.colorId
		SoraDSendMessage(nil)
	end
end
function worldMapBuildManor:getPieceID(lod)
	lod = lod or self.lod
	if not self.pieceID then
		self.pieceID, mapSyncUtilClient = self.pieceID, self.pieceID
	end
	if not self.pieceID[lod] then
		local kingdomID = self:getKingdomID()
		local pos = self:getTilePoint()
		local id = mapSyncUtilClient.getPieceId(pos, self.mapTypeClass, lod or self.lod)
		local strkey = kingdomID .. "-" .. tostring(id)
		self.pieceID[lod] = strkey
	end
	return self.pieceID[lod]
end
return worldMapBuildManor
