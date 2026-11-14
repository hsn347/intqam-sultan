local worldMapComInstance = class("worldMapComInstance", include("worldMapCom"))
local instanceFactory = include("instanceFactory")
local worldMapUtil = include("worldMapUtil")
local socket = require("socket")
local MAX_DELINSTANCE, MAX_SHOWINSTANCE
if device.platform == "android" then
	MAX_SHOWINSTANCE = 4
	MAX_DELINSTANCE = 6
elseif device.platform == "ios" then
	MAX_SHOWINSTANCE = 4
	MAX_DELINSTANCE = 6
else
	MAX_SHOWINSTANCE = 10
	MAX_DELINSTANCE = 20
end
gMapSyncMsgType = _G.gMapSyncMsgType
function worldMapComInstance:ctor()
	worldMapComInstance.super.ctor(self, "worldMapComInstance")
	self.maxInstanceDel = MAX_DELINSTANCE
	self.maxInstanceShow = MAX_SHOWINSTANCE
end
function worldMapComInstance:init()
	worldMapComInstance.super.init(self)
	self.lodPreview = false
	self.lodFocus = false
	self.builder:init(self.target_.mapViewCellArray)
	self.lodView = worldMapDefine.worldLodDef.LOD1
end
function worldMapComInstance:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_GET_RECT_DATA", self:getCheckLodFun(self.serverMessage_AddMapInstace_rectData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_INSTANCE_ADD", self:getCheckLodFun(self.serverMessage_AddMapInstace))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_INSTANCE_REMOVE", handler(self, self.serverMessage_RemoveMapInstace))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_INSTANCE_MODIFY", self:getCheckLodFunKeep(self.serverMessage_ModifyMapInstace))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_REMOVE_MAPINSTANCE", handler(self, self.removeMapInstance))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_TOGGLE_3D", handler(self, self.toggle3D))
	local handlerChange = handler(self, self.updateRelationChange)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE", handlerChange)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", handlerChange)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_QUIT_SUCCESS", handlerChange)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_JOIN_SUCCESS", handlerChange)
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_UPDATE_INFO, handler(self, self.updateInfo))
	self:addEventListener(worldMapEvent.EVENT_UPDATE_PIECE_DEL, handler(self, self.updateViewPieceIds))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodChange))
end
function worldMapComInstance:toggle3D()
	for _, tileInstance in pairs(self.instanceMap) do
		if tileInstance and tileInstance.__cname then
			tileInstance:toggle3D()
		end
	end
end
function worldMapComInstance:updateRelationChange()
	self.isNeedRefresh = true
end
function worldMapComInstance:getCheckLodFun(fun)
	return function(target, data)
		local lod = data.lod or self.target_:getCurLod()
		if self:checkLodData(lod) then
			fun(self, data)
		end
	end
end
function worldMapComInstance:getCheckLodFunKeep(fun)
	return function(target, data)
		local lod = data.lod or self.target_:getCurLod()
		if self:checkLodData(lod) or self:checkLodKeep(lod) then
			fun(self, data)
		end
	end
end
function worldMapComInstance:checkAdddMapInstace(data)
	local lod = data.lod or self.target_:getCurLod()
	if not self:checkLodFocus(lod) then
		return
	end
	local piectIds = data.piectIds
	if piectIds then
		for pieceId, pieceData in pairs(piectIds) do
			local instanceMap = self.viewPieceDatas[pieceId]
			if instanceMap then
				for _, tileInstance in pairs(instanceMap) do
					local id = tileInstance:getInstanceID()
					if not pieceData[id] and tileInstance:isEnableCheckVisible() then
						self:removeInstanceFromManager(tileInstance)
					end
				end
			end
		end
	end
end
function worldMapComInstance:serverMessage_AddMapInstace_rectData(data)
	self:serverMessage_AddMapInstace(data, true)
end
function worldMapComInstance:serverMessage_AddMapInstace(data, isRectData)
	self:addShowTilesData(data.data, isRectData)
	self:checkAdddMapInstace(data)
end
function worldMapComInstance:serverRemoveMapInstace(v)
	local instance = self:getShowInstanceByMap(v)
	if instance and instance.__cname then
		local kingdomID = v.kid or self.myKindomID
		if instance:getInstanceID() == v.id and instance:getKingdomID() == kingdomID then
			local delayTime = worldMapUtil.getDelayTimeInstance(v)
			self:delTileInstanceFromPiece(instance, delayTime, false)
		end
	end
end
function worldMapComInstance:serverMessage_RemoveMapInstace(target, data)
	local tilesDataArray = data.data
	local lod = data.lod or self.target_:getCurLod()
	local bUpdate = self:checkLodData(lod)
	if bUpdate then
		local msgType = gMapSyncMsgType.REMOVE_MAPOBJ
		for _, v in pairs(tilesDataArray) do
			self:addUpdateTilesData(v, msgType)
		end
	else
		for _, v in pairs(tilesDataArray) do
			self:serverRemoveMapInstace(v)
		end
	end
end
function worldMapComInstance:modifyMapInstace(instance, data)
	local instanceType = instance:getInstanceType()
	local dataKey = instanceFactory.getInstanceDataKey(instanceType)
	if dataKey then
		if not data[dataKey] then
			local instanceFactory, objData = data[dataKey], data[dataKey]
		end
		self:updateMapInstance(instance, objData, data)
	end
end
function worldMapComInstance:serverModifyMapInstace(v, bUpdate)
	local instance = self:getShowInstanceByMap(v)
	if instance and instance.__cname then
		local kingdomID = v.kid or self.myKindomID
		if instance:getInstanceID() == v.id and instance:getKingdomID() == kingdomID then
			if bUpdate then
				self:modifyMapInstace(instance, v)
			else
				instance:setDirtyData(true)
				self:updateMapInstanceHurtDie(instance, v)
			end
		end
	end
end
function worldMapComInstance:serverMessage_ModifyMapInstace(data)
	local tilesDataArray = data.data
	local lod = data.lod or self.target_:getCurLod()
	local bUpdate = self:checkLodData(lod)
	if bUpdate then
		local msgType = gMapSyncMsgType.UPDATE_MAPOBJ
		for _, v in pairs(tilesDataArray) do
			self:addUpdateTilesData(v, msgType)
		end
	else
		for _, v in pairs(tilesDataArray) do
			self:serverModifyMapInstace(v, bUpdate)
		end
	end
end
function worldMapComInstance:updateMapInstance(instance, objData, updateData)
	if objData then
		instance:updateInstanceData(objData, updateData)
		self:updateMapInstanceHurtDie(instance, updateData, objData)
	end
end
function worldMapComInstance:updateMapInstanceHurtDie(instance, updateData, objData)
	local instanceType = instance:getInstanceType()
	local isHurtDie = instanceFactory.isInstanceHurtDie(instanceType)
	if not isHurtDie then
		return
	end
	if not objData then
		local dataKey = instanceFactory.getInstanceDataKey(instanceType)
		if dataKey then
			objData = updateData[dataKey]
		end
	end
	if not objData then
		return
	end
	if not objData.status then
		return
	end
	if objData.status == gMapObjStateTypeDef.gMapObjStateTypeHurtDie then
		self:removeInstanceFromManager(instance)
	end
end
function worldMapComInstance:removeMapInstance(target, data)
	local mapInstance = data.instance
	if mapInstance then
		local key = mapInstance:getInstanceID()
		local instance = self.instanceMap[key]
		if instance and instance.__cname then
			self:removeInstanceFromManager(instance)
		end
	end
end
function worldMapComInstance:checkLodPreview(lod)
end
function worldMapComInstance:checkLodFocus(lod)
end
function worldMapComInstance:isCheckVisible(lod)
end
function worldMapComInstance:checkLodKeep(lod)
end
function worldMapComInstance:checkLodData(lod)
	return self:checkLodFocus(lod) or self:checkLodPreview(lod)
end
function worldMapComInstance:getShowInstanceByMap(instanceData)
	local key = instanceData.id
	local instance = self.instanceMap[key]
	return instance
end
function worldMapComInstance:cleanData()
	self:delPiece(self.viewPieceDatas)
	for tileInstance in pairs(self.tempCurrentShowTilesArray) do
		tileInstance:showInstance(false, 0)
	end
end
function worldMapComInstance:resetData()
	self.curPieceIDS, _ENV, self.instanceMap, _ENV, self.updateTilesDataArray, _ENV, self.tempCurrentShowTilesArray, _ENV, self.viewPieceDatas, _ENV = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	local gametop = gModuleMgr.getObject("gametop")
	self.myKindomID = gametop.playertop_:getMapID()
end
function worldMapComInstance:updateInfo(event)
	self:updateCheckDeleteTileInstance()
	if self.lodFocus then
		local isMoved = event.isMoved
		if not isMoved then
			self:updateShowTileInstance()
		end
		self:checkVisibleWorldMapInstance()
	elseif self.lodPreview then
		local isMoved = event.isMoved
		if not isMoved then
			self:updateShowTileInstance()
		end
	end
end
function worldMapComInstance:addShowTilesData(instanceDataArray, isRectData)
	if isRectData then
		local reqcenterTilePos = self.target_.reqcenterTilePos
		for _, v in ipairs(instanceDataArray) do
			local offsetX = math.abs(reqcenterTilePos.x - v.x)
			local offsetY = math.abs(reqcenterTilePos.y - v.y)
			v.__showPriority = offsetX + offsetY
		end
		table.sort(instanceDataArray, function(a, b)
			if a.__showPriority ~= b.__showPriority then
				return a.__showPriority < b.__showPriority
			end
			if a.type ~= b.type then
				return a.type < b.type
			end
			return a.id < b.id
		end)
	end
	local msgType = gMapSyncMsgType.ADD_MAPOBJ
	for _, v in ipairs(instanceDataArray) do
		_ENV = math.abs(reqcenterTilePos.x - v.x)
		math.abs(reqcenterTilePos.x - v.x).instanceData = v
		local math.abs(reqcenterTilePos.x - v.x).msgType, data = msgType, math.abs(reqcenterTilePos.x - v.x)
		if v.__showPriority and v.__showPriority <= 10 then
			table.insert(self.updateTilesDataArray, 1, data)
		else
			table.insert(self.updateTilesDataArray, data)
		end
	end
end
function worldMapComInstance:addUpdateTilesData(instanceData, msgType)
	_ENV = nil
	;(nil).instanceData = instanceData
	local (nil).msgType, data = msgType, nil
	table.insert(self.updateTilesDataArray, data)
end
function worldMapComInstance:markInstanceDirty()
	for _, tileInstance in pairs(self.instanceMap) do
		if tileInstance and tileInstance.__cname then
			tileInstance:setDirtyData(true)
		end
	end
end
function worldMapComInstance:updateShowTileInstance()
	if self.isNeedRefresh then
		self.isNeedRefresh = false
		self:markInstanceDirty()
	end
	local i = 0
	local maxTime = self.lodFocus and 1.0 or 0.5
	maxTime = self.maxInstanceShow * maxTime * 2
	local beginTime = socket.gettime() * 1000
	while 0 < #self.updateTilesDataArray and i < self.maxInstanceShow do
		local msg = table.remove(self.updateTilesDataArray, 1)
		if msg.msgType == gMapSyncMsgType.ADD_MAPOBJ then
			if not self:createMapInstance(msg.instanceData) then
				goto lbl_69
			end
			i = i + 1
			local curTime = socket.gettime() * 1000
			if maxTime < curTime - beginTime then
				break
			end
		elseif msg.msgType == gMapSyncMsgType.UPDATE_MAPOBJ then
			self:serverModifyMapInstace(msg.instanceData, true)
		elseif msg.msgType == gMapSyncMsgType.REMOVE_MAPOBJ then
			self:serverRemoveMapInstace(msg.instanceData)
		end
		::lbl_69::
	end
end
function worldMapComInstance:createMapInstance(instanceData)
	if instanceData.pieceID and not self.curPieceIDS[instanceData.pieceID] then
		return
	end
	local kingdomID = instanceData.kid or self.myKindomID
	local worldMapCell = self.target_:getWorldMapCell(kingdomID)
	if not worldMapCell then
		return
	end
	local currentInstance = self:getShowInstanceByMap(instanceData)
	if currentInstance and currentInstance:getInstanceID() == instanceData.id and currentInstance:getKingdomID() == kingdomID then
		self:removeInstanceFromTempManager(currentInstance)
		if currentInstance:isDirtyData() then
			self:modifyMapInstace(currentInstance, instanceData)
		end
		return true
	end
	if self.target_.checkIsShowFakeInstance and not self.target_:checkIsShowFakeInstance(instanceData) then
		return
	end
	local tileInstance = self.builder:createMapInstance(worldMapCell, instanceData)
	self:addInstanceFromManager(tileInstance, instanceData)
	return true
end
function worldMapComInstance:checkVisibleWorldMapInstance()
	for _, tileInstance in pairs(self.instanceMap) do
		if tileInstance and tileInstance.__cname then
			tileInstance:updateCheckVisible()
		end
	end
end
function worldMapComInstance:updateCheckDeleteTileInstance()
	if next(self.tempCurrentShowTilesArray) == nil then
		return
	end
	for _ = 1, self.maxInstanceDel do
		local tileInstance, delayTime = next(self.tempCurrentShowTilesArray)
		if not tileInstance then
			break
		end
		self.tempCurrentShowTilesArray[tileInstance] = nil
		self:updateCheckDeleteTileInstance_imp(tileInstance, delayTime)
	end
end
function worldMapComInstance:updateCheckDeleteTileInstance_imp(tileInstance, delayTime)
	delayTime = delayTime or 0
	if tileInstance then
		if not tileInstance.__cname then
			return
		end
		local worldMapCell = tileInstance:getWorldMapCell()
		if not worldMapCell then
			return
		end
		self:delTileInstance(tileInstance, delayTime)
	end
end
function worldMapComInstance:onAddInstance(tileInstance, instanceData)
end
function worldMapComInstance:onRemoveInstance(tileInstance)
end
function worldMapComInstance:addInstanceFromManager(tileInstance, instanceData)
	if tileInstance then
		self:addTileInstanceTOPiece(tileInstance)
		local id = tileInstance:getInstanceID()
		self.instanceMap[id] = tileInstance
		self:onAddInstance(tileInstance, instanceData)
	end
end
function worldMapComInstance:removeInstanceFromManager(tileInstance, delayTime)
	delayTime = delayTime or 0
	if tileInstance then
		self:delTileInstanceFromPiece(tileInstance, delayTime, true)
	end
end
function worldMapComInstance:addInstanceFromTempManager(tileInstance, delayTime)
	delayTime = delayTime or 0
	tileInstance:enableCheckVisible(false)
	self.tempCurrentShowTilesArray[tileInstance] = delayTime
end
function worldMapComInstance:removeInstanceFromTempManager(tileInstance)
	if self.tempCurrentShowTilesArray[tileInstance] then
		self.tempCurrentShowTilesArray[tileInstance] = nil
		tileInstance:enableCheckVisible(true)
	end
end
function worldMapComInstance:addTileInstanceTOPiece(instance, pieceID)
	pieceID = pieceID or instance:getPieceID(self.lodView)
	local pieceData = self.viewPieceDatas[pieceID]
	if pieceData then
		pieceData[instance] = instance
	else
		pieceData, _UPVALUE0_ = instance, instance
		pieceData[instance] = instance
		self.viewPieceDatas[pieceID] = pieceData
	end
end
function worldMapComInstance:delTileInstanceFromPiece(instance, delayTime, update)
	local pieceID = instance:getPieceID(self.lodView)
	local pieceData = self.viewPieceDatas[pieceID]
	if not pieceData then
		return
	end
	if update then
		self:addInstanceFromTempManager(instance, delayTime)
	else
		self:delTileInstance(instance, delayTime)
	end
	pieceData[instance] = nil
end
function worldMapComInstance:delTileInstance(tileInstance, delayTime)
	if tileInstance and tileInstance.__cname then
		self:onRemoveInstance(tileInstance)
		local id = tileInstance:getInstanceID()
		self.instanceMap[id] = nil
		tileInstance:showInstance(false, delayTime or 0)
	end
end
function worldMapComInstance:delTileInPiece(pieceID, update)
	local pieceData = self.viewPieceDatas[pieceID]
	if not pieceData then
		return
	end
	if update then
		for _, tileInstance in pairs(pieceData) do
			self:addInstanceFromTempManager(tileInstance)
		end
	else
		for _, tileInstance in pairs(pieceData) do
			self:delTileInstance(tileInstance)
		end
	end
	self.viewPieceDatas[pieceID] = nil
end
function worldMapComInstance:delPiece(pieceIDS, update)
	for k in pairs(pieceIDS) do
		self:delTileInPiece(k, update)
	end
end
function worldMapComInstance:changeTileInPiece(pieceID, lod, curPieceIDS)
	local pieceData = self.viewPieceDatas[pieceID]
	if not pieceData then
		return
	end
	self.viewPieceDatas[pieceID] = nil
	for _, tileInstance in pairs(pieceData) do
		local pieceIDNew = tileInstance:getPieceID(lod)
		if curPieceIDS[pieceIDNew] then
			self:addTileInstanceTOPiece(tileInstance, pieceIDNew)
		else
			self:addInstanceFromTempManager(tileInstance)
		end
	end
end
function worldMapComInstance:changePiece(event)
	if not event.delPieceIDS then
		local _ENV, delPieceIDS = event.delPieceIDS, event.delPieceIDS
	end
	local lod = event.lod
	if not event.curPieceIDS then
		local _ENV, curPieceIDS = event.curPieceIDS, event.curPieceIDS
	end
	for k in pairs(curPieceIDS) do
		self:changeTileInPiece(k, lod, curPieceIDS)
	end
	for k in pairs(delPieceIDS) do
		self:changeTileInPiece(k, lod, curPieceIDS)
	end
end
function worldMapComInstance:updateViewPieceIds(event)
	if not event.curPieceIDS then
		_UPVALUE0_ = event.curPieceIDS
	end
	self.curPieceIDS = event.curPieceIDS
	if event.lodChange then
		local lod = event.lod
		self.lodView = lod
		if self:checkLodFocus(lod) then
			self:changePiece(event)
		elseif self:checkLodPreview(lod) or self:checkLodKeep(lod) then
			self:changePiece(event)
		else
			if not event.delPieceIDS then
				local _UPVALUE0_, delPieceIDS = event.delPieceIDS, event.delPieceIDS
			end
			self:delPiece(delPieceIDS, true)
			if not event.curPieceIDS then
				local _UPVALUE0_, curPieceIDS = event.curPieceIDS, event.curPieceIDS
			end
			self:delPiece(curPieceIDS, true)
		end
	else
		if not event.delPieceIDS then
			local _UPVALUE0_, delPieceIDS = event.delPieceIDS, event.delPieceIDS
		end
		self:delPiece(delPieceIDS, true)
	end
end
function worldMapComInstance:doLodChange(focus, lod)
	if focus then
		self.builder:updateLodChange(lod)
	end
	self.builder:updateLodFocusChange(focus)
end
function worldMapComInstance:updateLodChange(event)
	local lod = event.lod
	if self:checkLodFocus(lod) then
		self.lodFocus = true
		self.lodPreview = false
		self:doLodChange(true, lod)
		self:updateInstanceLod(lod)
		if self:isCheckVisible() then
			self:updateInstanceVisible()
		end
	else
		self.lodFocus = false
		if self:checkLodPreview(lod) then
			self.lodPreview = true
		else
			self.isNeedRefresh = true
			self.lodPreview = false
		end
		self:doLodChange(false, lod)
		self.updateTilesDataArray, _UPVALUE0_ = self.doLodChange, self.doLodChange
	end
end
function worldMapComInstance:updateInstanceLod(lod)
	for _, tileInstance in pairs(self.instanceMap) do
		if tileInstance and tileInstance.__cname then
			tileInstance:doLodChange(lod)
		end
	end
end
function worldMapComInstance:updateInstanceVisible(lod)
	for _, tileInstance in pairs(self.instanceMap) do
		local show = self.builder:checkInstanceShowLod(tileInstance)
		tileInstance:enableCheckVisible(show)
	end
end
return worldMapComInstance
