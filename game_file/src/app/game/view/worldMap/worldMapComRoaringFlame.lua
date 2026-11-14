local roaringFlameWarRead = include("roaringFlameWarRead")
local worldMapViewDef = include("worldMapViewDef")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local worldMapComRoaringFlame = class("worldMapComRoaringFlame", include("worldMapCom"))
function worldMapComRoaringFlame:ctor()
	worldMapComRoaringFlame.super.ctor(self, "worldMapComRoaringFlame")
end
local Z_ORDER = worldMapDefine.Z_ORDER
function worldMapComRoaringFlame:init()
	self.isSkillShow = false
	self.cityLine3Map, _UPVALUE0_, self.cityLineMap, _UPVALUE0_, self.connect, _UPVALUE0_, self.worldMapCell = self.target_.currentInMapViewCell, self.target_.currentInMapViewCell, self.target_.currentInMapViewCell, self.target_.currentInMapViewCell, self.target_.currentInMapViewCell, self.target_.currentInMapViewCell, self.target_.currentInMapViewCell
	self:initWidget()
	self:initCityLine()
end
function worldMapComRoaringFlame:onMessageListener(...)
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodChange))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_ZOOM, handler(self, self.updateScaleZoom))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_BUILD_UPDATE", handler(self, self.onMsgBuildUpdate))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_NODEINFO_SELECT_CHANGE", handler(self, self.updateNodeInfoSelect))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_COLLECT_MOVELINE", handler(self, self.onMsgUpdateMoveLine))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_WARDATA", handler(self, self.onMsgUpdateWarData))
	self:doReqestData()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local showRolygonSubType = roaringFlameWarRead.getShowRolygonSubType()
	for subType, __ in pairs(showRolygonSubType) do
		local buildIDList = roaringFlameWarRead.getBuildIDListByType(subType)
		for __, objId in ipairs(buildIDList) do
			local owner = kingdomMapCtrl:getWarBuildingOwner(worldMapDefine.currentMapKindomID, objId)
			roaringFlameWarUtil.sendMessageUpdateLegaueManor(objId, owner)
		end
	end
end
function worldMapComRoaringFlame:doReqestData(...)
	roaringFlameWarCtrl:reqWarData()
end
function worldMapComRoaringFlame:relogin()
	self.isSkillShow = false
	self:refreshSkillBtnEffect()
end
function worldMapComRoaringFlame:initWidget(...)
	local node = display.newNode()
	node:addTo(self.target_, Z_ORDER.topTipView)
	node:setPosition(SoraDFPosX(640, 640), 256)
	self.Node_war = node
	local obj = fguiHelper.createObject("RoaringFlameWorldMap", "roaringFlameUIBottom")
	obj:addTo(self.Node_war)
	obj:setName("roaringFlameUIBottom")
	self.roaringFlameUIBottom = obj
	self.btnMonsterSearch = SoraDGetChildByName(self.target_, "Button_monsterSearch")
	self.btnMonsterSearch:addTouchEventListener(handler(self, self.btnMonsterSearchCall))
	_UPVALUE2_ = self.btnMonsterSearch
	self.btnMonsterSearch[1] = "Sprite_monsterLock"
	self.btnMonsterSearch[2] = "Sprite_monsterBg"
	for __, v in ipairs(self.btnMonsterSearch) do
		local widget = SoraDGetChildByName(self.btnMonsterSearch, v)
		if widget then
			widget:setVisible(false)
		end
	end
	local height = display.height + display.iPhoneXBottom
	local pyramidTip = include("worldMapPyramidTip").new()
	pyramidTip:setPosition(cc.p(display.cx, height - 270))
	pyramidTip:addTo(self.target_, Z_ORDER.topTipView)
	self.pyramidTip = pyramidTip
	self:refreshSkillBtnEffect()
	self:fitNodeBottom()
end
function worldMapComRoaringFlame:fitNodeBottom()
	local fitHeight = 1136
	if fitHeight <= display.height then
		self.Node_war:setPositionY(display.iPhoneXBottom + 256)
		self.btnMonsterSearch:setPositionY(display.iPhoneXBottom + 170)
		return
	end
	local fitWidth = fitHeight / display.height * 640
	local fitScale = 640 / fitWidth
	local addX = (640 - fitScale * 640) / 2
	local posX = self.btnMonsterSearch:getPositionX()
	self.Node_war:setScale(fitScale)
	self.Node_war:setPositionY(display.iPhoneXBottom + 256 * fitScale)
	self.btnMonsterSearch:setScale(fitScale)
	self.btnMonsterSearch:setPositionY(display.iPhoneXBottom + 170 * fitScale)
	self.btnMonsterSearch:setPositionX(SoraDFIsRA() and posX - addX / 2 or posX + addX / 2)
end
function worldMapComRoaringFlame:refreshSkillBtnEffect(...)
	if self.roaringFlameUIBottom then
		return self.roaringFlameUIBottom:refreshSkillBtnEffect(...)
	end
end
function worldMapComRoaringFlame:onMsgUpdateWarData(...)
	self.pyramidTip:updateData()
end
function worldMapComRoaringFlame:btnMonsterSearchCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(nil)
		local panel = SoraDCreatePanel("worldMapMonsterSearch")
		panel:show()
	end
end
local worldLodDef = worldMapDefine.worldLodDef
function worldMapComRoaringFlame:updateLodChange(event)
	local lod = event.lod
	if lod >= worldLodDef.LOD3 then
		self.Node_CityLine:setVisible(false)
		if lod >= worldLodDef.LOD4 then
			self:updateNodeInfoSelect()
		else
			self.Node_CityLine3:setVisible(true)
		end
	else
		self.Node_CityLine:setVisible(true)
		self.Node_CityLine3:setVisible(false)
	end
	if lod >= worldLodDef.LOD4 then
		if self.Node_AreaName then
			self.Node_AreaName:setVisible(true)
		else
			self:initAreaName()
		end
	elseif self.Node_AreaName then
		self.Node_AreaName:setVisible(false)
	end
end
function worldMapComRoaringFlame:updateScaleZoom(event)
	local lod = event.lod
	local zoomScale = event and event.scale or 1
	local revertScale = event.revertScale or 1
	local drawVisivle = lod >= worldLodDef.LOD3
	if drawVisivle then
		for __, cityLine3 in pairs(self.cityLine3Map) do
			cityLine3:setScale(revertScale)
			local distance = cityLine3.distance
			cityLine3:setWidth(distance * zoomScale)
		end
	end
end
function worldMapComRoaringFlame:initCityLine(...)
	local node = display.newNode()
	node:addTo(self.worldMapCell, -1)
	node:setName("Node_CityLine")
	node:setGroupID(worldMapDefine.GROU_ID.roaring_flame_line1)
	self.Node_CityLine = node
	local node = display.newNode()
	node:addTo(self.worldMapCell, -1)
	node:setName("Node_CityLine3")
	node:setGroupID(worldMapDefine.GROU_ID.roaring_flame_line2)
	self.Node_CityLine3 = node
	local _ENV, cityLineMap = node.setGroupID, node.setGroupID
	local _ENV, cityLine3Map = node, node
	local fromPos, toPos, cityLine, cityLine3
	local config = roaringFlameWarUtil.getBuildConnectConfig()
	for key, cfg in pairs(config) do
		cityLine = self:createCityLine(cfg.fromPos, cfg.toPos, cfg.lineType, 0, cfg.isGatewayLine)
		cityLine:addTo(self.Node_CityLine)
		cityLineMap[key] = cityLine
		cityLine3 = self:createCityLine(cfg.fromPos, cfg.toPos, cfg.lineType + 3, 0, cfg.isGatewayLine)
		cityLine3:addTo(self.Node_CityLine3)
		cityLine3Map[key] = cityLine3
	end
	self.cityLineMap = cityLineMap
	self.cityLine3Map = cityLine3Map
end
function worldMapComRoaringFlame:createCityLine(beginTilePoint, endTilePoint, lineType, colorType, isGatewayLine)
	local beginPoint = self.worldMapCell:getPointWithTile(beginTilePoint)
	local endPoint = self.worldMapCell:getPointWithTile(endTilePoint)
	local cityLine = include("worldMapRoaringFlameLine").new(beginPoint, endPoint, lineType)
	cityLine:setPosition(beginPoint)
	cityLine:setMoveLineColor(colorType, isGatewayLine)
	return cityLine
end
function worldMapComRoaringFlame:onMsgBuildUpdate(target, event)
	dump(event, "==worldMapComRoaringFlame:onMsgBuildUpdate==")
	local objId = event.objId
	local camp = event.camp
	local connect = event.connect
	local subType1 = roaringFlameWarRead.getBuildSubType(objId)
	local binding = roaringFlameWarRead.getBuildBinding(objId)
	for __, _objId in ipairs(binding) do
		if not connect[tostring(_objId)] then
			_ENV = connect[tostring(_objId)]
		end
		connect[tostring(_objId)] = connect[tostring(_objId)]
	end
	for objIdStr, v in pairs(connect) do
		local subType2 = roaringFlameWarRead.getBuildSubType(tonumber(objIdStr))
		local key1 = objId .. "," .. objIdStr
		local key2 = objIdStr .. "," .. objId
		local isGatewayLine = roaringFlameWarUtil.checkIsGatewayBuild(subType1) and roaringFlameWarUtil.checkIsGatewayBuild(subType2)
		roaringFlameWarUtil = tonumber(objIdStr)
		tonumber(objIdStr)[1] = self.cityLineMap
		tonumber(objIdStr)[2] = self.cityLine3Map
		for i, map in ipairs(tonumber(objIdStr)) do
			local cityLine = map[key1] or map[key2]
			if cityLine then
				local lineType = i * 3 - 1
				local colorType = 0
				if camp and camp == v.camp then
					lineType = i * 3 - 2
					colorType = camp
				end
				if not isGatewayLine then
					cityLine:changeLineType(lineType)
				end
				cityLine:setMoveLineColor(colorType, isGatewayLine)
			end
		end
	end
end
function worldMapComRoaringFlame:updateNodeInfoSelect(target, event)
	worldMapViewDef = nil
	local (nil)[worldMapViewDef.NODEINFO_TYPE_MANORLINE], config = true, nil
	local isShow = config[worldMapDefine.curSelectNodeInfo] or false
	if self.Node_CityLine3 then
		self.Node_CityLine3:setVisible(isShow)
	end
end
function worldMapComRoaringFlame:onMsgUpdateMoveLine(target, event)
	_UPVALUE0_ = nil
	;(nil).qType = event.qType
	;(nil).buildId = event.buildId
	;(nil).data = event.data
	local (nil).isBack, params = event.isBack, nil
	local moveLineData = self:getCollectQueueData(params)
	if not moveLineData then
		return
	end
	self:addCollectQueue(moveLineData)
end
function worldMapComRoaringFlame:addCollectQueue(queueData)
	local mapViewCell = self.target_:getWorldMapCell()
	if not mapViewCell then
		return
	end
	local movelineFactory = include("movelineFactory")
	local moveLine = movelineFactory.createMapMoveLine(mapViewCell, queueData, nil, false, self.target_.mapClassType, 1)
	local totalTime = queueData.statusEndTime - queueData.statusStartTime
	moveLine:deleteMoveLine(totalTime)
	moveLine:getTroopInstance():setSoliderVisible(true)
end
function worldMapComRoaringFlame:getCollectQueueData(params)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local selfPoint = cityCtrl:getCurCityPos()
	local startTime = serviceFunctions.systemTime()
	local totalTime = 5
	_ENV = nil
	;(nil).status = gMapMoveLineStatusType.moveLineStatusTypeMoving
	_ENV, (nil).id = gMapMoveLineStatusType.moveLineStatusTypeMoving, "11"
	gMapMoveLineStatusType.moveLineStatusTypeMoving.x = selfPoint.x
	_ENV, (nil).from, gMapMoveLineStatusType.moveLineStatusTypeMoving.y = gMapMoveLineStatusType.moveLineStatusTypeMoving, gMapMoveLineStatusType.moveLineStatusTypeMoving, selfPoint.y
	gMapMoveLineStatusType.moveLineStatusTypeMoving.x = selfPoint.x + 10
	gMapMoveLineStatusType.moveLineStatusTypeMoving.y = selfPoint.y + 10
	;(nil).to, gMapMoveLineStatusType.moveLineStatusTypeMoving.type = gMapMoveLineStatusType.moveLineStatusTypeMoving, gMapObjTypeDef.roaringFlameWarBuilding
	;(nil).kingdomId = worldMapDefine.currentMapKindomID
	;(nil).statusStartTime = startTime
	_ENV, roaringFlameWarRead, (nil).statusEndTime = gMapObjTypeDef.roaringFlameWarBuilding, startTime + totalTime, startTime + totalTime
	gMapObjTypeDef.roaringFlameWarBuilding.distancePrecent = 1
	gMapObjTypeDef.roaringFlameWarBuilding.time = totalTime
	;(nil).moveTimeSpan, (startTime + totalTime)[1] = startTime + totalTime, gMapObjTypeDef.roaringFlameWarBuilding
	;(nil).matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeCollection
	;(nil).client_queue = true
	local (nil).moveLineColor, queueData = gMapMoveLineColor.moveLineColorGreen, nil
	local qType = params.qType
	if qType == 1 then
		queueData.matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeCollection
		local buildId = params.buildId
		local buildPos = roaringFlameWarRead.getBuildCoord(buildId)
		queueData.to.x = buildPos.x - 0.5
		queueData.to.y = buildPos.y - 0.5
		queueData.to.type = gMapObjTypeDef.roaringFlameWarBuilding
	elseif qType == 2 then
		queueData.matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeDetection
		queueData.to.x = params.data.x
		queueData.to.y = params.data.y
		queueData.to.type = gMapObjTypeDef.roaringFlameWarCave
	end
	if params.isBack then
		queueData.from, queueData.to = queueData.to, queueData.from
	end
	return queueData
end
function worldMapComRoaringFlame:initAreaName(...)
	local node = display.newNode()
	node:addTo(self.worldMapCell, -1)
	node:setName("Node_AreaName")
	node:setGroupID(worldMapDefine.GROU_ID.roaring_flame_plot)
	self.Node_AreaName = node
	local fontSize = 88
	local fontScale = 880 / fontSize
	local obj
	for i, cfg in ipairs(roaringFlameWarRead.get_flames_dunes_plot()) do
		local plotType = cfg.type
		local plotName = roaringFlameWarRead.getPlotName(plotType)
		local coordList = roaringFlameWarRead.getPlotCoordList(plotType)
		for __, coord in ipairs(coordList) do
			_ENV = roaringFlameWarRead.get_flames_dunes_plot()
			roaringFlameWarRead.get_flames_dunes_plot().text = plotName
			roaringFlameWarRead.get_flames_dunes_plot().size = fontSize
			obj = SoraDCreateLabelNoChild(roaringFlameWarRead.get_flames_dunes_plot())
			obj:addTo(self.Node_AreaName)
			obj:setAnchorPoint(cc.p(0.5, 0.5))
			local point = self.worldMapCell:getPointWithTile(coord)
			obj:setPosition(cc.p(point.x, point.y))
			obj:setScale(fontScale)
			obj:setOpacity(127.5)
		end
	end
end
function worldMapComRoaringFlame:getNodeWar()
	return self.Node_war
end
function worldMapComRoaringFlame:exportMethods()
	_UPVALUE1_ = nil
	;(nil)[1] = "getNodeWar"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComRoaringFlame
