local gametop = gModuleMgr.getObject("gametop")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local mapSyncUtilClient = include("mapSyncUtilClient")
local instanceFactory = include("instanceFactory")
local worldMapComNebulaAllStarSpoil = class("worldMapComNebulaAllStarSpoil", include("worldMapCom"))
function worldMapComNebulaAllStarSpoil:ctor()
	worldMapComNebulaAllStarSpoil.super.ctor(self, "worldMapComNebulaAllStarSpoil")
end
function worldMapComNebulaAllStarSpoil:init()
	worldMapComNebulaAllStarSpoil.super.init(self)
	self.currentShowTilesArray, worldMapComNebulaAllStarSpoil, self.worldMapCell = self.target_.currentInMapViewCell, self.target_.currentInMapViewCell, self.target_.currentInMapViewCell
	self.moveLines, worldMapComNebulaAllStarSpoil, self.curLod = self.target_.currentInMapViewCell, self.target_.currentInMapViewCell, nil
end
function worldMapComNebulaAllStarSpoil:onMessageListener()
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodLevel))
	self:addEventListener(worldMapEvent.EVENT_UPDATE_INFO, handler(self, self.updateInfo))
	self:addEventListener(worldMapEvent.EVENT_CELL_SWAP, handler(self, self.updateCellSwap))
	self:addEventListener(worldMapEvent.EVENT_TOOGLE_3D, handler(self, self.toggle3D))
	self:toggle3D()
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_REFRESH_DATA", handler(self, self.onMsgInitSpoil))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_INITDATA_UPDATE", handler(self, self.onMsgInitSpoil))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_SPOIL_UPDATE", handler(self, self.onMsgUpdateSpoil))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_SPOIL_COLLECTING", handler(self, self.onMsgUpdateShowCollecting))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_SPOIL_COLLECTED", handler(self, self.onMsgUpdateShowCollected))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_SPOIL_DEL_MOVELINE", handler(self, self.onMsgDelMoveLine))
	nebulaAllStarCtrl:updateSpoilQueueData()
	self:initSpoil()
	self:initSpoilQueue()
end
function worldMapComNebulaAllStarSpoil:resetData()
	worldMapComNebulaAllStarSpoil.super.resetData(self)
end
function worldMapComNebulaAllStarSpoil:updateLodLevel(event)
	local lodLevel = self.target_:getCurLod()
	if self.curLod == lodLevel then
		return
	end
	self.curLod = lodLevel
	self.Node_Spoil:setVisible(self.curLod <= 1)
end
function worldMapComNebulaAllStarSpoil:updateInfo(event)
	self:checkVisibleMoveLine()
end
function worldMapComNebulaAllStarSpoil:updateCellSwap(...)
	self:initSpoilQueue()
	self:refreshSpoil()
end
function worldMapComNebulaAllStarSpoil:toggle3D(...)
	for __, instances in pairs(self.currentShowTilesArray) do
		for __, instance in pairs(instances) do
			if instance and instance.__cname then
				instance:toggle3D()
			end
		end
	end
end
function worldMapComNebulaAllStarSpoil:onMsgInitSpoil(...)
	self:refreshSpoil()
	self:initSpoilQueue()
end
function worldMapComNebulaAllStarSpoil:checkVisibleMoveLine(...)
	for k, v in pairs(self.moveLines) do
		local troopInstance = v:getTroopInstance()
		if troopInstance:isVisible() then
			troopInstance:updateCheckVisible()
		end
	end
end
function worldMapComNebulaAllStarSpoil:addMoveLine(v, moveLine)
	dump(v, "worldMapComNebulaAllStarSpoil:addMoveLine")
	self.moveLines[v.id] = moveLine
end
function worldMapComNebulaAllStarSpoil:getSpecialMoveLine(moveLineID)
	dump(moveLineID, "worldMapComNebulaAllStarSpoil:getSpecialMoveLine")
	return self.moveLines[moveLineID]
end
function worldMapComNebulaAllStarSpoil:removeMoveLine(id)
	if id ~= nil and self.moveLines[id] then
		local moveLine = self.moveLines[id]
		local troopInstance = moveLine:getTroopInstance()
		troopInstance:finshWork()
		moveLine:deleteMoveLine()
		self.moveLines[id] = nil
		return
	end
	for i, v in pairs(self.moveLines) do
		local troopInstance = v:getTroopInstance()
		troopInstance:finshWork()
		v:deleteMoveLine()
	end
	self.moveLines, _ENV = pairs(self.moveLines)
end
function worldMapComNebulaAllStarSpoil:initSpoilQueue()
	self:removeMoveLine()
	local moveLineData = nebulaAllStarCtrl:getSpoilQueueData()
	dump(moveLineData, "==moveLineData==")
	if not moveLineData then
		return
	end
	self.moveLines, nebulaAllStarCtrl = dump, dump
	for i, v in ipairs(moveLineData) do
		self:addSpoilQueue(v)
	end
end
function worldMapComNebulaAllStarSpoil:addSpoilQueue(spoilData)
	local mapViewCell = self.target_:getWorldMapCell()
	if not mapViewCell then
		return
	end
	local movelineFactory = include("movelineFactory")
	local moveLine = movelineFactory.createMapMoveLine(mapViewCell, spoilData, nil, false, self.target_.mapClassType, 1)
	moveLine:getTroopInstance():setQueueData(spoilData)
	self:addMoveLine(spoilData, moveLine)
end
function worldMapComNebulaAllStarSpoil:initSpoil(...)
	local node = display.newNode()
	node:addTo(self.worldMapCell, -1)
	node:setName("Node_Spoil")
	self.Node_Spoil = node
	self:refreshSpoil()
	self:updateLodLevel()
end
function worldMapComNebulaAllStarSpoil:refreshSpoil(...)
	self:removeSpoil()
	local spoilDatas = nebulaAllStarCtrl:getSpoilMap()
	dump(spoilDatas, "worldMapComNebulaAllStarSpoil:refreshSpoil")
	for _, v in pairs(spoilDatas) do
		self:addSpoil(v)
	end
	dump(self.currentShowTilesArray, "==self.currentShowTilesArray==")
end
function worldMapComNebulaAllStarSpoil:removeSpoil(...)
	for __, instances in pairs(self.currentShowTilesArray) do
		for __, instance in pairs(instances) do
			if instance and instance.__cname then
				instance:removeFromParent()
			end
		end
	end
	self.currentShowTilesArray, _ENV = pairs(self.currentShowTilesArray)
end
function worldMapComNebulaAllStarSpoil:onMsgUpdateSpoil(target, event)
	dump(event, "==worldMapComNebulaAllStarSpoil:updateNpc==")
	local data = event.data
	if event.msgType == gMapSyncMsgType.REMOVE_MAPOBJ then
		self:delSpoil(data)
	elseif event.msgType == gMapSyncMsgType.ADD_MAPOBJ then
		self:addSpoil(data)
	elseif event.msgType == gMapSyncMsgType.UPDATE_MAPOBJ then
		local instance = self:getSpoil(data.pos)
		if instance then
			if data.statue == gMapObjStateTypeDef.gMapObjStateTypeFighting then
				_ENV = nil
				;(nil).statue = gMapObjStateTypeDef.gMapObjStateTypeFree
				instance:addFireEffect(8, nil)
			elseif data.statue == gMapObjStateTypeDef.gMapObjStateTypeHurtDie then
				_ENV = nil
				;(nil).statue = data.statue
				instance:addFireEffect(8, nil)
			end
		end
	end
end
function worldMapComNebulaAllStarSpoil:addSpoil(spoilData)
	if spoilData and spoilData.x then
		local instance = self:getSpecailInstance(cc.p(spoilData.x, spoilData.y), spoilData.id)
		if instance then
			return
		end
		local tilePoint = mapSyncUtilClient.serverTOClientPos(cc.p(spoilData.x + 1, spoilData.y + 1))
		local holdInstace = 1
		local instance = SoraDCreatePanel("worldMapNebulaAllStarSpoil")
		instance:addTo(self.Node_Spoil, spoilData.x + spoilData.y)
		local instancePoint = self.worldMapCell:getPointWithTile(tilePoint, holdInstace)
		instance:setPosition(instancePoint)
		local tilesArray = instanceFactory.getTilesArrayByInstace(tilePoint, holdInstace)
		instance:setTilesArray(tilesArray)
		instance:setTilePoint(tilePoint)
		instance:setHoldInstace(holdInstace)
		instance:initInstanceData(spoilData)
		instance:setWorldMapCell(self.worldMapCell)
		instance:setKingdomID(self.worldMapCell:getKingdomID())
		instance:toggle3D()
		local tilesArray = instance:getTilesArray()
		local spoilId = instance:getSpoilId()
		for _, v in pairs(tilesArray) do
			if not self.currentShowTilesArray[v] then
				local _ENV, instances = self.currentShowTilesArray[v], self.currentShowTilesArray[v]
			end
			instances[spoilId] = instance
			self.currentShowTilesArray[v] = instances
		end
	end
end
function worldMapComNebulaAllStarSpoil:delSpoil(data)
	dump(nebulaAllStarCtrl:getCollectingTime(data.id), "worldMapComNebulaAllStarSpoil:delSp")
	if nebulaAllStarCtrl:getCollectingTime(data.id) ~= nil then
		return
	end
	local instance = data.instance
	if instance and instance.__cname then
		self:removeSpoilByInstance(instance)
	end
	local x = data.x
	if x then
		local instance = self:getSpecailInstance(cc.p(data.x, data.y), data.id)
		dump(instance, "worldMapComNebulaAllStarSpoil:delSpoil")
		if instance and instance.__cname then
			self:removeSpoilByInstance(instance)
		end
	end
end
function worldMapComNebulaAllStarSpoil:removeSpoilByInstance(instance)
	local tilesArray = instance:getTilesArray()
	local spoilId = instance:getSpoilId()
	for _, v in pairs(tilesArray) do
		local instances = self.currentShowTilesArray[v]
		if instances then
			instances[spoilId] = nil
		end
		if not next(instances) then
			self.currentShowTilesArray[v] = nil
		end
	end
	instance:removeFromParent()
end
function worldMapComNebulaAllStarSpoil:getSpecailInstance(pos, spoilId)
	local key = pos.x .. "," .. pos.y
	dump(key, "worldMapComNebulaAllStarSpoil:getSpecailInstance")
	local instances = self.currentShowTilesArray[key]
	if not instances then
		return
	end
	if spoilId then
		local instance = instances[spoilId]
		if instance and instance.__cname then
			return instance
		end
	else
		for __, instance in pairs(instances) do
			if instance and instance.__cname then
				return instance
			end
		end
	end
end
function worldMapComNebulaAllStarSpoil:onMsgUpdateShowCollecting(...)
	self:initSpoilQueue()
	for __, instances in pairs(self.currentShowTilesArray) do
		for __, instance in pairs(instances) do
			instance:updateCollectData()
		end
	end
end
function worldMapComNebulaAllStarSpoil:onMsgUpdateShowCollected(target, data)
	dump(data, "worldMapComNebulaAllStarSpoil:onMsgUpdateShowCollected")
	local moveLine = self:getSpecialMoveLine(data.spoil.id)
	if moveLine then
		local instance = self:getSpecailInstance(cc.p(data.spoil.x, data.spoil.y), data.spoil.id)
		if instance then
			instance:showCollecting(data.delay)
		end
		local troopInstance = moveLine:getTroopInstance()
		troopInstance:setMatrixState(gMapMoveLineStatusType.moveLineStatusTypeWorking)
		SoraDCreateDelayTimer(self, function()
			SoraDMailGainItems(data.reward, true)
			local gobackQueueData = nebulaAllStarCtrl:addSpoilQueueData("-" .. data.spoil.id, data.spoil, true)
			self:addSpoilQueue(gobackQueueData)
			nebulaAllStarCtrl:removeQueuueData(data.spoil.id)
			self:delSpoil(data.spoil)
			for __, instances in pairs(self.currentShowTilesArray) do
				for __, instance in pairs(instances) do
					instance:updateCollectData()
				end
			end
		end, data.delay)
	end
end
function worldMapComNebulaAllStarSpoil:onMsgDelMoveLine(target, data)
	self:removeMoveLine(data.id)
end
function worldMapComNebulaAllStarSpoil:exportMethods(...)
	_UPVALUE2_ = nil
	;(nil)[1] = "getSpecailInstance"
	;(nil)[2] = "getSpecialMoveLine"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComNebulaAllStarSpoil
