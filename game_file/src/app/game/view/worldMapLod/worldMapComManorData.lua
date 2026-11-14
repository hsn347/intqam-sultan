local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local worldMapComManorData = class("worldMapComManorData", include("worldMapCom"))
local instanceFactory = include("instanceFactory")
local gMapObjTypeDef = _G.gMapObjTypeDef
local LODREQ = worldMapDefine.worldLodDef.LOD5
function worldMapComManorData:ctor()
	worldMapComManorData.super.ctor(self, "worldMapComManorData")
	local instanceBuilderManor = include("instanceBuilderManor")
	self.builder = instanceBuilderManor.new(self)
end
function worldMapComManorData:init()
	worldMapComManorData.super.init(self)
	self.lodView = worldMapDefine.worldLodDef.LOD1
	self.lod = self.lodView
end
function worldMapComManorData:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_GET_RECT_DATA", self:getCheckSelfFun(self.serverMessage_AddMapInstace))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_INSTANCE_ADD", self:getCheckSelfFun(self.serverMessage_AddMapInstace))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_INSTANCE_REMOVE", self:getCheckSelfFun(self.serverMessage_RemoveMapInstace))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_INSTANCE_MODIFY", self:getCheckSelfFun(self.serverMessage_ModifyMapInstace))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_ALLIANCE_BUILD", handler(self, self.serverMessage_AllianceBuild))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_ALLIANCE_BUILD_SELF", handler(self, self.serverMessage_AllianceBuildSelf))
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_UPDATE_PIECE_DEL, handler(self, self.updateViewPieceIds))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodChange))
	self:addEventListener(worldMapEvent.EVENT_CELL_SWAP, handler(self, self.updateCellSwap))
	self:updateKingdomView()
end
function worldMapComManorData:getCheckSelfFun(fun)
	return function(target, data)
		if not self:isSelfKingdom() or data.isLocal or worldMapDefine.isInNebula() then
			fun(self, target, data)
		end
	end
end
function worldMapComManorData:isSelfKingdom()
	return self.kid == self.myKindomID
end
function worldMapComManorData:onEnter()
	self:updateKingdomView()
end
function worldMapComManorData:updateCellSwap()
	self:cleanData()
	self:updateKingdomView()
end
function worldMapComManorData:updateKingdomView()
	local kid = self.target_.currentInMapViewCell.kingdomID
	self.kid = kid
	self.requestKid = 0
	self:updateRequest()
end
_ENV, worldMapComManorData.doReqestData = function(self)
	self:sendGetAllAllianceBuild()
end, function(self)
	self:sendGetAllAllianceBuild()
end
;(function(self)
	self:sendGetAllAllianceBuild()
end)[gMapObjTypeDef.mapObjTypeAllianceBuild] = true
local (function(self)
	self:sendGetAllAllianceBuild()
end)[gMapObjTypeDef.stronghold], mapTypeBuild = true, function(self)
	self:sendGetAllAllianceBuild()
end
local isManorBuild = function(mapType, objId)
	return mapTypeBuild[mapType]
end
function worldMapComManorData:serverMessage_AddMapInstace(target, data)
	local lod = data.lod or self.target_:getCurLod()
	if lod >= LODREQ then
		return
	end
	local tilesDataArray = data.data
	for _, v in pairs(tilesDataArray) do
		if isManorBuild(v.type, v.objId) then
			self:createMapInstance(v)
		end
	end
	if self.isCheckInstanceUpdate then
		self:checkAdddMapInstace(data)
	end
end
function worldMapComManorData:checkAdddMapInstace(data)
	if not data.dataEnd then
		return
	end
	self.isCheckInstanceUpdate = false
	if not kingdomMapCtrl:getAllMapObj() then
		local kingdomMapCtrl, mapObjAll = kingdomMapCtrl:getAllMapObj(), kingdomMapCtrl:getAllMapObj()
	end
	for _, tileInstance in pairs(self.instanceMap) do
		local id = tileInstance:getInstanceID()
		if not mapObjAll[id] then
			self:removeInstanceFromManager(tileInstance)
		end
	end
end
function worldMapComManorData:serverMessage_RemoveMapInstace(target, data)
	local tilesDataArray = data.data
	for _, v in pairs(tilesDataArray) do
		if isManorBuild(v.type, v.objId) then
			local instance = self:getShowInstance(v)
			if instance then
				local kingdomID = v.kid or self.myKindomID
				if instance:getInstanceID() == v.id and instance:getKingdomID() == kingdomID then
					self:removeInstanceFromManager(instance)
				end
			end
		end
	end
end
function worldMapComManorData:modifyMapInstace(instance, data)
	local instanceType = instance:getInstanceType()
	local dataKey = instanceFactory.getInstanceDataKey(instanceType)
	if dataKey then
		local objData = data[dataKey]
		if objData then
			instance:updateData(objData)
		end
	end
end
function worldMapComManorData:serverMessage_ModifyMapInstace(target, data)
	local tilesDataArray = data.data
	for _, v in pairs(tilesDataArray) do
		if isManorBuild(v.type, v.objId) then
			local instance = self:getShowInstance(v)
			if instance then
				local kingdomID = v.kid or self.myKindomID
				if instance:getInstanceID() == v.id and instance:getKingdomID() == kingdomID then
					self:modifyMapInstace(instance, v)
				end
			end
		end
	end
end
function worldMapComManorData:serverMessage_AllianceBuild(target, data)
	local kid = data.kid
	if kid ~= self.kid then
		return
	end
	local tilesDataArray = data.data
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE_RESET"
	SoraDSendMessage(nil)
	for _, v in pairs(tilesDataArray) do
		local kingdomID = v.kid or self.myKindomID
		local worldMapCell = self.target_:getWorldMapCell(kingdomID)
		if worldMapCell then
			self.builder:createMapInstance_quick(worldMapCell, v)
		end
	end
end
function worldMapComManorData:serverMessage_AllianceBuildSelf(target, data)
	local kid = data.kid
	if kid ~= self.kid then
		return
	end
	local v = data.data
	local updateType = data.updateType
	local kingdomID = v.kid or self.myKindomID
	local worldMapCell = self.target_:getWorldMapCell(kingdomID)
	if worldMapCell then
		self.builder:createMapInstance_quick(worldMapCell, v, updateType)
	end
end
function worldMapComManorData:getShowInstance(instanceData)
	local key = instanceData.id
	local instance = self.instanceMap[key]
	return instance
end
function worldMapComManorData:cleanData()
	if self.requestKid and self.requestKid > 0 then
		if not self:isSelfKingdom() then
			kingdomMapCtrl:onRemoeeAllianceBuild(self.requestKid)
		end
		self.requestKid = 0
	end
	for _, tileInstance in pairs(self.instanceMap) do
		tileInstance:showInstance(false)
	end
	self.instanceMap, kingdomMapCtrl = pairs(self.instanceMap)
end
function worldMapComManorData:resetData()
	self.instanceMap, gametop = nil, nil
	self.myKindomID = gametop.playertop_:getMapID()
end
function worldMapComManorData:createMapInstance(instanceData)
	local kingdomID = instanceData.kid or self.myKindomID
	local worldMapCell = self.target_:getWorldMapCell(kingdomID)
	if not worldMapCell then
		return
	end
	local currentInstance = self:getShowInstance(instanceData)
	if currentInstance and currentInstance:getInstanceID() == instanceData.id and currentInstance:getKingdomID() == kingdomID then
		if self.isCheckInstanceUpdate then
			self:modifyMapInstace(currentInstance, instanceData)
		end
		return
	end
	local tileInstance = self.builder:createMapInstance(worldMapCell, instanceData)
	if tileInstance then
		self:addInstanceFromManager(tileInstance)
	end
end
function worldMapComManorData:addInstanceFromManager(tileInstance)
	local id = tileInstance:getInstanceID()
	self.instanceMap[id] = tileInstance
end
function worldMapComManorData:removeInstanceFromManager(tileInstance)
	if tileInstance then
		local id = tileInstance:getInstanceID()
		self.instanceMap[id] = nil
		tileInstance:showInstance(false)
	end
end
function worldMapComManorData:getInstanceMapFromManager()
	return self.instanceMap
end
function worldMapComManorData:changePiece(event)
	if not event.curPieceIDS then
		local _ENV, curPieceIDS = event.curPieceIDS, event.curPieceIDS
	end
	for _, tileInstance in pairs(self.instanceMap) do
		local pieceIDNew = tileInstance:getPieceID(self.lodView)
		if not curPieceIDS[pieceIDNew] then
			self:removeInstanceFromManager(tileInstance)
		end
	end
end
function worldMapComManorData:delPiece(pieceIDS)
	for _, tileInstance in pairs(self.instanceMap) do
		local pieceIDNew = tileInstance:getPieceID(self.lodView)
		if pieceIDS[pieceIDNew] then
			self:removeInstanceFromManager(tileInstance)
		end
	end
end
function worldMapComManorData:updateViewPieceIds(event)
	local lod = event.lod
	if lod < LODREQ then
		if event.lodChange then
			self.lodView = lod
			self:changePiece(event)
		else
			if not event.delPieceIDS then
				local LODREQ, delPieceIDS = event.delPieceIDS, event.delPieceIDS
			end
			self:delPiece(delPieceIDS, true)
		end
	end
end
function worldMapComManorData:updateLodChange(event)
	local lod = event.lod
	self.lod = lod
	self:updateRequest()
end
function worldMapComManorData:updateRequest()
	if self.lod >= LODREQ or self:isSelfKingdom() then
		if not self.request then
			self.request = true
		end
		self:sendGetAllAllianceBuild()
	else
		if self.request then
			LODREQ = self
			self.msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE_RESET"
			SoraDSendMessage(self)
			for _, tileInstance in pairs(self.instanceMap) do
				tileInstance:showInstance(true)
			end
			self.isCheckInstanceUpdate = true
		end
		self.request = false
		self.requestKid = 0
	end
end
function worldMapComManorData:sendGetAllAllianceBuild()
	if self.request then
		if self.kid and self.kid > 0 and self.requestKid ~= self.kid then
			self.requestKid = self.kid
			kingdomMapCtrl:getAndRequestAllAllianceBuild(self.kid)
		elseif self.kid == 0 then
			kingdomMapCtrl = kingdomMapCtrl
			kingdomMapCtrl.msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE_RESET"
			SoraDSendMessage(kingdomMapCtrl)
		end
	end
end
function worldMapComManorData:exportMethods()
	_UPVALUE1_ = nil
	;(nil)[1] = "getInstanceMapFromManager"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComManorData
