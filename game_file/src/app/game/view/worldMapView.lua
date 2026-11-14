local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local worldMapDefine = include("worldMapDefine")
local mapSyncUtilClient = include("mapSyncUtilClient")
local socket = require("socket")
local worldMapViewDef = include("worldMapViewDef")
local worldMapEvent = include("worldMapEvent")
local paramsKey = "params_" .. device.platform
local instanceCacheMgr = include("instanceCacheMgr")
local worldMapView = class("worldMapView", function(config, param)
	local ccsFile = getCCSPath(config.ccsFile or "worldMapViewNormal")
	local view = include("ccsView")
	local target = view.new(ccsFile)
	include("worldMapViewObject").new(target, param)
	if config.isSingleMapCell then
		include("worldMapViewSingle").new(target)
	else
		include("worldMapViewMul").new(target)
	end
	return target
end)
local POINT_ZERO = cc.p(0, 0)
local Z_ORDER = worldMapDefine.Z_ORDER
local MIN_TIME_DRAG = worldMapViewDef.MIN_TIME_DRAG
local worldLodDef = worldMapDefine.worldLodDef
function worldMapView:ctor(config, param)
	self:addComponents(config)
	self:initParam(param)
	self:initView(config)
	self:callComFunc("init")
	self:initOther()
	self._ccsView:setLocalZOrder(Z_ORDER.otherTipView)
	self:setAnchorPoint(cc.p(0, 0))
	self:setPosition(cc.p(0, 0))
end
function worldMapView:initParam(param)
	if param then
		self.initTilePoint = param.tilePoint
		self.initIsSelected = param.isSelected or false
		self.layInstanceType = param.layInstance or worldMapLayInstanceTypeDef.layInstanceNone
		self.layInstanceData = param.layInstanceData
	else
		self.initIsSelected = false
		self.layInstanceType = worldMapLayInstanceTypeDef.layInstanceNone
		self.layInstanceData = nil
	end
	if not self.initTilePoint then
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		self.initTilePoint = cityCtrl:getCurCityPos()
	end
end
function worldMapView:initView(config)
	self.mapClassType = config.mapClassType
	self.createCustomLayer = config.createCustomLayer
	self.config = config
	self:initData()
	self:initMapCell(config)
end
function worldMapView:initOther()
	self.loadingPos = cc.p(SoraDFPosX(575), 160 + display.iPhoneXBottom)
end
function worldMapView:onEnterOther()
	kingdomMapCtrl:onSwitchWorldMap(gSwitchWorldMapTypeDef.switchWorldMapType_in, worldMapDefine.currentMapKindomID)
	local GAME_SWITCH_MODE = _G.GAME_SWITCH_MODE
	SoraDDelayCallOnce("worldMapView:finishLoadImages", function()
		self:finishLoadImages()
	end, 0.1)
	self:callComFunc("onEnter")
	if GAME_SWITCH_MODE then
		self:updateMapPos()
	end
end
function worldMapView:onExitOther()
	kingdomMapCtrl:onSwitchWorldMap(gSwitchWorldMapTypeDef.switchWorldMapType_out, worldMapDefine.currentMapKindomID)
	instanceCacheMgr.addNormalNodeByType(self._tmxview, self.tileMapTmx)
	self._tmxview:removeFromParent(false)
	self:callComFunc("onExit")
end
function worldMapView:initTmx(tileMapTmx)
	if worldMapDefine.isLegendLordKingdomID() then
		if worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) then
			tileMapTmx = tileMapTmx[2]
		else
			tileMapTmx = tileMapTmx[1]
		end
	end
	self.tileMapTmx = tileMapTmx
	local tmxview = instanceCacheMgr.getInstance(tileMapTmx)
	local isFromCache = true
	if tmxview == nil then
		isFromCache = false
		tmxview = SoraDTMXTiledMap:create(tileMapTmx)
		tmxview:setName("tileMapTmx")
		tmxview:ignoreAnchorPointForPosition(false)
		tmxview:setAnchorPoint(cc.p(0.5, 0.5))
		tmxview:setCascadeOpacityEnabled(true)
		tmxview:setCascadeColorEnabled(true)
	end
	if self.mapClassType == gKingdomClassType.radiance then
		local worldMapComTmx = include("worldMapComTmx")
		local mapLayer = tmxview:getLayer("desert")
		local groundLayer = tmxview:getLayer("desert-object")
		self.groundLayer_marsh = tmxview:getLayer("gate")
		if isFromCache then
			self.mapLayer = mapLayer
			self.groundLayer = groundLayer
		else
			self.mapLayer = worldMapComTmx.new(mapLayer)
			worldMapDefine, _ENV = cc.p(0.5, 0.5)
			cc.p(0.5, 0.5).name = "grassland"
			worldMapDefine, cc.p(0.5, 0.5).beginGID = cc.p(0.5, 0.5)
			cc.p(0.5, 0.5).name = "marsh"
			cc.p(0.5, 0.5).beginGID = 294
			cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5)
			cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5)
			self.mapLayer:init(tmxview, cc.p(0.5, 0.5))
			self.groundLayer = worldMapComTmx.new(groundLayer)
			worldMapDefine, _ENV = cc.p(0.5, 0.5)
			cc.p(0.5, 0.5).name = "grassland-object"
			worldMapDefine, cc.p(0.5, 0.5).beginGID = cc.p(0.5, 0.5)
			cc.p(0.5, 0.5).name = "marsh-object"
			cc.p(0.5, 0.5).beginGID = 392
			cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5)
			cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5)
			self.groundLayer:init(tmxview, cc.p(0.5, 0.5))
			if self.mapLayer.setBeginShowGid then
				self.mapLayer:setBeginShowGid(4)
			end
		end
	elseif self.mapClassType == gKingdomClassType.atlantis then
		local worldMapComTmx = include("worldMapComTmx")
		self.mapLayer = tmxview:getLayer("tile")
		self.mapLayer:setVisible(false)
		local groundLayer = tmxview:getLayer("tile01")
		if isFromCache then
			self.groundLayer = groundLayer
		else
			self.groundLayer = worldMapComTmx.new(groundLayer)
			worldMapDefine, instanceCacheMgr = cc.p(0.5, 0.5)
			cc.p(0.5, 0.5).name = "water"
			cc.p(0.5, 0.5).beginGID = 0
			;(4)[1] = cc.p(0.5, 0.5)
			self.groundLayer:init(tmxview, 4)
		end
	elseif self.mapClassType == gKingdomClassType.nebula then
		self.groundLayer = tmxview:getLayer("tile")
		self.mapLayer = self.groundLayer
		self.mapLayer:setVisible(false)
	elseif self.mapClassType == gKingdomClassType.normal then
		local worldMapComTmx = include("worldMapComTmx")
		local groundLayer = tmxview:getLayer("control")
		if isFromCache then
			self.groundLayer = groundLayer
		else
			self.groundLayer = worldMapComTmx.new(groundLayer)
			worldMapDefine = cc.p(0.5, 0.5)
			cc.p(0.5, 0.5).name = "control"
			worldMapDefine, cc.p(0.5, 0.5).beginGID = cc.p(0.5, 0.5)
			cc.p(0.5, 0.5)[95] = 5
			cc.p(0.5, 0.5).mapGID, cc.p(0.5, 0.5)[96] = cc.p(0.5, 0.5)
			self.groundLayer:init(tmxview, nil, cc.p(0.5, 0.5))
			self.groundLayer:setVisible(false)
		end
		self.mapLayer = self.groundLayer
	elseif self.mapClassType == gKingdomClassType.nebulaEmperor then
		self.groundLayer = tmxview:getLayer("tile")
		self.mapLayer = self.groundLayer
		self.mapLayer:setVisible(false)
	elseif self.mapClassType == gKingdomClassType.nebulaAllStar then
		self.groundLayer = tmxview:getLayer("tile")
		self.mapLayer = self.groundLayer
		self.mapLayer:setVisible(false)
	elseif self.mapClassType == gKingdomClassType.roaringFlame then
		self.groundLayer = tmxview:getLayer("tile")
		self.mapLayer = self.groundLayer
		self.mapLayer:setVisible(false)
	elseif self.mapClassType == gKingdomClassType.simulatedDrill then
		self.groundLayer = tmxview:getLayer("tile")
		self.mapLayer = self.groundLayer
		self.mapLayer:setVisible(false)
	elseif self.mapClassType == gKingdomClassType.garden then
		self.groundLayer = tmxview:getLayer("tile")
		self.mapLayer = self.groundLayer
		self.mapLayer:setVisible(false)
	else
		self.mapLayer = tmxview:getLayer("tile")
		self.mapLayer:setName("tile")
		self.groundLayer = tmxview:getLayer("ground")
		self.groundLayer:setName("ground")
		if self.mapLayer.setBeginShowGid then
			self.mapLayer:setBeginShowGid(4)
		end
	end
	self.tileSize = tmxview:getTileSize()
	self.mapViewSize = tmxview:getContentSize()
	self.mapSize = tmxview:getMapSize()
	self._tmxview = tmxview
	self._tmxview:addTo(self.containerView, Z_ORDER.tmxView)
	if isFromCache then
		self._tmxview:release()
	end
	self.mapViewCenterPoint = cc.p(self.mapViewSize.width / 2, self.mapViewSize.height / 2)
	worldMapDefine.worldMapViewSize = self.mapViewSize
	print("isCreateCustomLayer", tostring(self.isCreateCustomLayer))
	if self.createCustomLayer then
		self:createCustomMapLayer(self._tmxview, self.createCustomLayer)
	end
end
function worldMapView:createOneMapCell()
	local mapViewCell = include("worldMapCell").new(self, self.mapClassType)
	mapViewCell:ignoreAnchorPointForPosition(false)
	mapViewCell:setAnchorPoint(cc.p(0.5, 0.5))
	mapViewCell:setKingdomID(worldMapDefine.currentMapKindomID)
	mapViewCell:addTo(self.containerView, Z_ORDER.containerView)
	local worldMapWarDef = include("worldMapWarDef")
	if worldMapWarDef.isInWarForbidBonePoing(self.mapClassType) then
		mapViewCell:addShowBonePoing(self.mapClassType)
	end
	mapViewCell:setTouchPlayerCallFun(function(ref, type, pos)
		self:viewOnClick(ref, type, pos)
	end)
	return mapViewCell
end
function worldMapView:createCustomMapLayer(parent, name)
	local defaultPath = "app.game.worldMap.mapData."
	local mapPath = defaultPath .. name
	local conf = require_once(mapPath .. ".mapConf.lua")
	local shader = require("app.shader.customMeshShader")
	local defined
	if device.platform == "android" then
		defined = "ANDROID_PKM"
	end
	local node = display.newNode()
	node:setName("customMapLayer")
	node:addTo(parent, 999)
	parent.customMapLayer = node
	print("createCustomMapLayer", paramsKey)
	for k, v in ipairs(conf) do
		local meshCfg = require_once(string.format("%s.%s.lua", mapPath, v))
		local meshNode = SoraDCreateMeshNode(meshCfg, meshCfg.bounds.size, shader, meshCfg[paramsKey], nil, defined)
		meshNode:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		meshNode:setName(v)
		meshNode:addTo(node)
	end
end
function worldMapView:createTestMeshNode(mapViewCell)
	local meshCfg = require("app.shader.combine_land_8")
	local shader = require("app.shader.customMeshShader")
	_UPVALUE2_ = nil
	;(nil)[1] = 102400.0
	;(nil)[2] = 51200.0
	local meshNode = SoraDCreateMeshNode(meshCfg, nil, shader, meshCfg[paramsKey])
	meshNode:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
	local size = mapViewCell:getContentSize()
	meshNode:setName("worldTest")
	meshNode:addTo(mapViewCell, 999)
end
function worldMapView:reloadAllTestMesh()
	package.loaded["app.shader.combine_land_8"] = nil
	local meshCfg = require("app.shader.combine_land_8")
	package.loaded["app.shader.customMeshShader"] = nil
	local _shader = require("app.shader.customMeshShader")
	local program = cc.GLProgram:createWithByteArrays(_shader.vertBytes, _shader.fragBytes)
	local state = cc.GLProgramState:create(program)
	SoraDSetProgramStateParam(program, state, meshCfg[paramsKey])
	local meshNode = self.currentInMapViewCell:getChildByName("worldTest")
	if meshNode then
		meshNode:setGLProgramState(state)
	end
end
function worldMapView:initMapCell(config)
	if config.minScale then
		worldMapViewDef.MIN_SCALE = config.minScale
	elseif config.noScaleLimit then
		worldMapViewDef.MIN_SCALE = worldMapViewDef.MIN_SCALE_NO_LIMIT
	else
		worldMapViewDef.MIN_SCALE = worldMapViewDef.MIN_SCALE_DEFAULT
	end
	if config.normalScale then
		worldMapViewDef.NORMAL_SCALE = config.normalScale
	else
		worldMapViewDef.NORMAL_SCALE = worldMapViewDef.NORMAL_SCALE_DEFAULT
	end
	self.containerViewNode = display.newNode()
	self.containerViewNode:addTo(self, Z_ORDER.containerViewNode)
	self.containerView = ccui.Layout:create()
	self.containerView:setName("containerView")
	self.containerView:setAnchorPoint(0, 0)
	self:initTmx(config.tileMapTmx)
	self:initMapCell_imp()
	self:initScrollView(config)
	self._tmxview:setPosition(cc.p(self.currentInMapViewCell:getPosition()))
end
function worldMapView:onSwitchMapViewCell()
	self._tmxview:setPosition(cc.p(self.currentInMapViewCell:getPosition()))
	_ENV = cc.p(self.currentInMapViewCell:getPosition())
	cc.p(self.currentInMapViewCell:getPosition()).name = worldMapEvent.EVENT_CELL_CHANGE
	self:dispatchEvent(cc.p(self.currentInMapViewCell:getPosition()))
end
function worldMapView:onSwapMapViewCell()
	self._tmxview:setPosition(cc.p(self.currentInMapViewCell:getPosition()))
	_ENV = cc.p(self.currentInMapViewCell:getPosition())
	cc.p(self.currentInMapViewCell:getPosition()).name = worldMapEvent.EVENT_CELL_SWAP
	self:dispatchEvent(cc.p(self.currentInMapViewCell:getPosition()))
end
function worldMapView:initScrollView(config)
	self.viewScrollView = cc.ScrollView:create(cc.size(display.rwidth, display.rheight))
	self.viewScrollView:setName("viewScrollView")
	self.viewScrollView.fairyBatching = false
	self.viewScrollView:setContainer(self.containerView)
	self.viewScrollView:setClippingToBounds(false)
	self.viewScrollView:setMinScale(worldMapViewDef.MIN_SCALE)
	self.viewScrollView:setMaxScale(worldMapViewDef.MAX_SCALE)
	self.viewScrollView:setZoomScale(worldMapViewDef.NORMAL_SCALE)
	self.viewScrollView:setBounceable(false)
	self.viewScrollView:setInertiaValue(1.0)
	if self.viewScrollView.setScrollSpeed then
		self.viewScrollView:setScrollSpeed(4.0)
		self.viewScrollView:setScrollAcceleration(-3.0)
	end
	self.viewScrollView:setPosition(cc.p(0, 0))
	self:addChild(self.viewScrollView, Z_ORDER.scrollView)
	self:initScrollDid()
end
function worldMapView:initData(config)
	self.displayCenterPoint = cc.p(display.rcx, display.rcy)
	self.reqMapCenterPoint = cc.p(display.cx, display.cy)
	self.reqcenterTilePos = POINT_ZERO
	self.sendTilePos = POINT_ZERO
	self.isWaitForData = false
	self.isShowLoading = false
	self.gotoSelectTilePoint = nil
	self.canDoSelected = false
	self.needShowHand = false
	self.gotoTransferCityPoint = nil
	self.canDoTransfer = false
	self.isMoved = false
	self.preCenterPoint = nil
	self.is_delay = false
	self.delay_frame = 0
	self.isNeedRefreshScroll = 0
	self.mapKingdomClassType = kingdomMapCtrl:getKingdomClass() or gKingdomClassType.normal
	self.myKindomID = gametop.playertop_:getMapID()
	self.MIN_TIME = MIN_TIME_DRAG
end
function worldMapView:initTimer()
	worldMapEvent = nil
	local (nil).name, event_timer = worldMapEvent.EVENT_UPDATE_INFO, nil
	local updateInfo = function(dt)
		if self.isNeedRefreshScroll and self.isNeedRefreshScroll > 0 then
			self:refreshScroll()
		end
		self:updateShowTileInstance()
		event_timer.isMoved = self.isMoved
		self:dispatchEvent(event_timer)
		self:updateDelayFrame(dt)
	end
	SoradCreateTimer(self, updateInfo, true, 1)
end
function worldMapView:onMessageListener()
	if self.isFinishInit then
		self:onMessageListener_FinishLoadImage()
	end
end
function worldMapView:finishLoadImages()
	print("worldMapView:加载资源完毕")
	self.isFinishInit = true
	self:initTimer()
	self:initEvent()
	self:onMessageListener_FinishLoadImage(true)
	self:moveTilePointToCenter(self.initTilePoint, self.initIsSelected, self.layInstanceType, self.layInstanceData)
	SoraDCloseSwitcherView()
	SoraDCloseLoginView(0.1)
	self:endShow()
end
function worldMapView:initEvent()
	self:addEventListener(worldMapEvent.EVENT_TOOGLE_3D, handler(self, self.toggle3D))
	self:addEventListener(worldMapEvent.EVENT_TILED_DEBUG, function()
		self._tmxview:toggleDebugLayer()
	end)
end
_ENV, worldMapView.onMessageListener_FinishLoadImage = function(self, add)
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", handler(self, self.gotoForeBackGroud))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.refreshRelogin))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_GOTO_TILEPOINT", handler(self, self.gotoTilePointOld))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_MOVETOCENTER_SUBPOINT", handler(self, self.moveSubPointToCenter))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_GET_RECT_DATA", handler(self, self.serverMessage_GetRectData))
	if add then
		self:callComFunc("onMessageListener")
		self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodChange))
	end
end, function(self, add)
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", handler(self, self.gotoForeBackGroud))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.refreshRelogin))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_GOTO_TILEPOINT", handler(self, self.gotoTilePointOld))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_MOVETOCENTER_SUBPOINT", handler(self, self.moveSubPointToCenter))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_GET_RECT_DATA", handler(self, self.serverMessage_GetRectData))
	if add then
		self:callComFunc("onMessageListener")
		self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodChange))
	end
end
local (function(self, add)
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", handler(self, self.gotoForeBackGroud))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.refreshRelogin))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_GOTO_TILEPOINT", handler(self, self.gotoTilePointOld))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_MOVETOCENTER_SUBPOINT", handler(self, self.moveSubPointToCenter))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_GET_RECT_DATA", handler(self, self.serverMessage_GetRectData))
	if add then
		self:callComFunc("onMessageListener")
		self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodChange))
	end
end).name, event_scroll = worldMapEvent.EVENT_SCROLL_DID, function(self, add)
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", handler(self, self.gotoForeBackGroud))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.refreshRelogin))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_GOTO_TILEPOINT", handler(self, self.gotoTilePointOld))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_MOVETOCENTER_SUBPOINT", handler(self, self.moveSubPointToCenter))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_GET_RECT_DATA", handler(self, self.serverMessage_GetRectData))
	if add then
		self:callComFunc("onMessageListener")
		self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodChange))
	end
end
function worldMapView:refreshScroll()
	self.isNeedRefreshScroll = 0
end
function worldMapView:initScrollDid()
	local scrollViewDidScroll = function()
		self.isNeedRefreshScroll = self.isNeedRefreshScroll + 1
		self:scrollFromBorder()
		self:updateMapPos()
		self:updateCenterAreaTiles()
		self:dispatchEvent(event_scroll)
	end
	self.viewScrollView:setDelegate()
	self.viewScrollView:registerScriptHandler(scrollViewDidScroll, cc.SCROLLVIEW_SCRIPT_SCROLL)
end
function worldMapView:setDisplayCenterTilePoint(pos)
end
local DELAY_SPEED = 10
local LODCHECK = worldLodDef.LOD4
function worldMapView:updateCenterAreaTiles()
	local lod = self:getCurLod()
	local lodCheck = lod > LODCHECK and lod or LODCHECK
	if self.preCenterPoint == nil then
		self:updateCheckSetMapViewCellPoint()
		self.reqcenterTilePos = self.currentInMapViewCell:tilePositionFromLocation(self.reqMapCenterPoint, true)
		self.sendTilePos = self.reqcenterTilePos
		self.preCenterPoint = mapSyncUtilClient.getPieceId(self.reqcenterTilePos, self.mapClassType, lod)
		self.preCheckPoint = mapSyncUtilClient.getPieceId(self.reqcenterTilePos, self.mapClassType, lodCheck)
		self:getMapTilesData()
		self:delUnshowMoveLine()
		self:setDisplayCenterTilePoint(self.reqcenterTilePos)
		return
	end
	local reqcenterTilePos = self.currentInMapViewCell:tilePositionFromLocation(self.reqMapCenterPoint)
	local piecePos = mapSyncUtilClient.getPieceId(reqcenterTilePos, self.mapClassType, lodCheck)
	if piecePos ~= self.preCheckPoint then
		self.preCheckPoint = mapSyncUtilClient.getPieceId(self.reqcenterTilePos, self.mapClassType, lodCheck)
		self:updateCheckSetMapViewCellPoint()
	end
	self:setDisplayCenterTilePoint(reqcenterTilePos)
	reqcenterTilePos = self.currentInMapViewCell:tilePositionFromLocation(self.reqMapCenterPoint, true)
	piecePos = mapSyncUtilClient.getPieceId(reqcenterTilePos, self.mapClassType, lod)
	if piecePos ~= self.preCenterPoint then
		self.reqcenterTilePos = self.currentInMapViewCell:tilePositionFromLocation(self.reqMapCenterPoint, true)
		local distance = cc.pGetDistance(self.sendTilePos, reqcenterTilePos)
		if self.preClockTime then
			local curTime = socket.gettime()
			local time = curTime - self.preClockTime
			if time == 0 then
				return
			elseif 0 < time then
				local v = distance / time
				if v > DELAY_SPEED then
					self.preCenterPoint = mapSyncUtilClient.getPieceId(self.reqcenterTilePos, self.mapClassType, lod)
					self.is_delay = true
					self.delay_time = self.MIN_TIME
					self.preClockTime = curTime
					return
				elseif time < self.MIN_TIME then
					self.preCenterPoint = mapSyncUtilClient.getPieceId(self.reqcenterTilePos, self.mapClassType, lod)
					self.is_delay = true
					self.delay_time = self.MIN_TIME
					return
				end
			else
				self.preClockTime = curTime
			end
		end
		self.preCenterPoint = mapSyncUtilClient.getPieceId(self.reqcenterTilePos, self.mapClassType, lod)
		self.sendTilePos = self.reqcenterTilePos
		self.is_delay = false
		self:getMapTilesData()
		self:delUnshowMoveLine()
	end
end
function worldMapView:updateDelayFrame(dt)
	if not self.is_delay then
		return
	end
	self.delay_time = self.delay_time - dt
	if self.delay_time <= 0 then
		self.is_delay = false
		self.preCenterPoint = nil
		self:updateCenterAreaTiles()
	end
end
function worldMapView:closeLoading()
	if self.loadView then
		if not tolua.isnull(self.loadView) then
			SoraDCloseLoading()
		end
		self.loadView = nil
	end
end
function worldMapView:updateShowTileInstance()
	if not self:hasShowTilesData() then
		if not self.isWaitForData then
			if self.isShowLoading then
				SoraDCloseLoading(self)
				self.isShowLoading = false
			end
			self:closeLoading()
		end
		if self.gotoSelectTilePoint and (self.canDoSelected or self.needShowHand) and not self.is_delay and self:getCurLod() == 1 and (not self.isWaitForData or self:getShowInstance(self.gotoSelectTilePoint)) then
			SoraDCreateDelayTimer(self, function()
				self:onClickInstance(self.gotoSelectTilePoint)
				self.gotoSelectTilePoint = nil
			end, 1.0)
			self:showHandTip()
			self.canDoSelected = false
		end
		if self.gotoTransferCityPoint and self.canDoTransfer then
			_ENV = self
			self.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
			SoraDSendMessage(self)
			SoraDCreateDelayTimer(self, function()
				worldMapEvent = nil
				;(nil).name = worldMapEvent.EVENT_TRANS
				;(nil).layInstanceType = self.layInstanceType
				;(nil).pos = self.gotoTransferCityPoint
				local (nil).layInstanceData, event = self.layInstanceData, nil
				self:dispatchEvent(event)
				self.gotoTransferCityPoint = nil
			end, 1.0)
			self.canDoTransfer = false
		end
	end
end
function worldMapView:showHandTip()
	if self.needShowHand then
		if not self.fingerNode then
			self.fingerNode = SoraDCreatAnimationEx("animationFinger", nil, true)
			self.fingerNode:getChildByName("Node_effect"):setVisible(false)
			self.fingerNode:getChildByName("shouzhi"):setVisible(true)
			self.fingerNode:setName("fingerNode")
			self.fingerNode:addTo(self.containerViewNode)
		else
			self.fingerNode.action:gotoFrameAndPlay(0, true)
		end
		self.fingerNode:stopActionByTag(233)
		self.fingerNode:setVisible(true)
		_UPVALUE1_ = self.fingerNode
		self.fingerNode[1] = cca.delay(5)
		self.fingerNode[2] = cca.callFunc(function()
			self.fingerNode:stopActionByTag(233)
			self.fingerNode:setVisible(false)
		end)
		self.fingerNode[3] = cca.callFunc(function()
			self.fingerNode:stopActionByTag(233)
			self.fingerNode:setVisible(false)
		end)
		self.fingerNode[4] = cca.callFunc(function()
			self.fingerNode:stopActionByTag(233)
			self.fingerNode:setVisible(false)
		end)
		self.fingerNode[5] = cca.callFunc(function()
			self.fingerNode:stopActionByTag(233)
			self.fingerNode:setVisible(false)
		end)
		local seq = cca.seq(self.fingerNode)
		seq:setTag(233)
		self.fingerNode:runAction(seq)
		local showPoint = self:getPointWithTile(self.gotoSelectTilePoint)
		local screenPoint = SoraDConvertoScreenPos2DOr3D(self.currentInMapViewCell, showPoint)
		local coverShowPoint = self.containerViewNode:convertToNodeSpace(screenPoint)
		self.fingerNode:setPosition(coverShowPoint)
		self.gotoSelectTilePoint = nil
	end
end
function worldMapView:hideHandTip()
	if self.fingerNode then
		self.fingerNode:setVisible(false)
		self.fingerNode:stopActionByTag(233)
	end
end
function worldMapView:onClickInstance(tilePos, mapViewCell)
	if not tilePos then
		return
	end
	mapViewCell = mapViewCell or self.currentInMapViewCell
	if self:removeSelectShowPanel() and not self.canDoSelected then
		return
	end
	local lod = self:getCurLod()
	if lod >= worldLodDef.LOD2 then
		return
	end
	local tileInstance = self:getShowInstance(tilePos)
	if (not tileInstance or tileInstance:getInstanceType() ~= gMapObjTypeDef.mapObjTypeKingdomLevelBuild) and kingdomMapCtrl:checkIsInNormalFog(tilePos, mapViewCell.kingdomID) then
		SoraDPlaySound()
		if mapViewCell.kingdomID == self.myKindomID then
			SoraDShowMsgBoxNew(i18n("alliance_stronghold_text_072"), i18n("common_text_477"), nil, function(exitType, target)
				if exitType == MSGBOX_CALLBACK_YES then
					local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
					mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.ANNALS)
				end
			end)
		else
			SoraDShowMsgTip(i18n("alliance_stronghold_text_094"))
		end
		return
	end
	local worldMapWarDef = include("worldMapWarDef")
	if worldMapWarDef.checkIsInWarFog(tilePos) then
		return
	end
	self:hideHandTip()
	local returnData = mapViewCell:onClickInstance(tilePos, tileInstance, self.containerView, self.containerViewNode)
	if not returnData then
		return
	end
	self:onClickInstance_imp(returnData)
end
function worldMapView:getPointWithTile(tilePoint)
	local tileWidth = self.tileSize.width
	local tileHeight = self.tileSize.height
	tilePoint = self.mapLayer:getPositionAt(tilePoint)
	local point = cc.p(tilePoint.x + tileWidth / 2, tilePoint.y + tileHeight / 2)
	return point
end
function worldMapView:getDisplayCenterTilePoint()
	local centerTilePos = self.currentInMapViewCell:tilePositionFromLocation(self.displayCenterPoint)
	return centerTilePos
end
function worldMapView:getClosestInstanceFromManager(instanceType, havePlayer, params)
	if not self.selfInMapView then
		return
	end
	return self:getClosestInstanceFromManager_imp(instanceType, havePlayer, params)
end
function worldMapView:getMapTilesData()
	local sendMsg = self:getMapTilesData_imp()
	if sendMsg then
		self.isWaitForData = true
		if self.mapClassType ~= gKingdomClassType.newTrial and not self.isShowLoading then
			local loading = SoraDShowLoading(self, cc.size(50, 50))
			loading:setSwallowTouches(false)
			loading:setPosition(self.loadingPos)
			self.isShowLoading = true
		end
		self.preClockTime = socket.gettime()
	end
end
function worldMapView:viewOnClick(mapView, type, pos)
	if not mapView then
		return
	end
	self:removeLodClickTip()
	if type == ccui.TouchEventType.ended then
		if self:isTransferShow() then
			self:resetTransferView()
		elseif not self.isMoved then
			local touchEndPoint = pos or mapView:getTouchEndPosition()
			local tilePos = mapView:tilePositionFromLocation(touchEndPoint)
			if worldMapDefine.isInAtlantis() then
				local atlantisWarUtil = include("atlantisWarUtil")
				if atlantisWarUtil.checkIsBattleAreaAndNotOpen(tilePos) then
					SoraDShowMsgTip(i18n("atlantiswar_text_0256"))
					_ENV = i18n("atlantiswar_text_0256")
					i18n("atlantiswar_text_0256").msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
					SoraDSendMessage(i18n("atlantiswar_text_0256"))
					return
				end
			end
			local lod = self:getCurLod()
			if lod >= worldLodDef.LOD2 then
				SoraDPlaySound()
				_ENV = i18n("atlantiswar_text_0256")
				i18n("atlantiswar_text_0256").toTilePos = tilePos
				i18n("atlantiswar_text_0256").touchEndPoint = touchEndPoint
				i18n("atlantiswar_text_0256").kingdomID = mapView.kingdomID
				self:showLodClickTip(i18n("atlantiswar_text_0256"))
				return
			end
			if not self:checkClickMoveLine(touchEndPoint) and tilePos.x >= 0 and 0 <= tilePos.y then
				self:onClickInstance(tilePos, mapView)
			end
		end
		self.isMoved = false
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = mapView:getTouchBeganPosition()
		local touchmovePoint = mapView:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
		if self:isTransferTouchIn() then
			self:moveTransferView(touchmovePoint, mapView)
		end
	end
end
function worldMapView:moveTilePointToCenter(tilePoint, isSelected, layInstance, layInstanceData, duration, mapViewCell, isShowHand)
	mapViewCell = mapViewCell or self.currentInMapViewCell
	isSelected = isSelected or false
	isShowHand = isShowHand or false
	layInstance = layInstance or worldMapLayInstanceTypeDef.layInstanceNone
	layInstanceData = layInstanceData or nil
	if layInstanceData and layInstanceData.duration then
		duration = layInstanceData.duration
	end
	duration = duration or 0
	if mapViewCell.kingdomID ~= self.currentInMapViewCell.kingdomID then
		self:addEnterOtherWorldmapCellFilm()
		self:closeLoading()
		self.loadView = SoraDShowLoading(nil, nil, nil, nil, 10)
	end
	local mapViewPoint = mapViewCell:getPointWithTile(tilePoint)
	mapViewPoint = SoraDCoverToPoint2DOr3D(mapViewCell, mapViewPoint, self.containerView)
	self:moveMapPointToCenter(mapViewPoint, duration)
	if isSelected then
		self.gotoSelectTilePoint = tilePoint
		self.canDoSelected = true
	end
	if isShowHand then
		self.gotoSelectTilePoint = tilePoint
		self.needShowHand = true
	else
		self.needShowHand = false
	end
	if layInstance and layInstance ~= worldMapLayInstanceTypeDef.layInstanceNone then
		self.gotoTransferCityPoint = tilePoint
		self.canDoTransfer = true
		self.layInstanceType = layInstance
		self.layInstanceData = layInstanceData
	end
end
function worldMapView:moveMapPointToCenter(point, duration, container)
	duration = duration or 0
	local zoomScale = self.viewScrollView:getZoomScale()
	local centerPoint = self.displayCenterPoint
	local covertPoint = SoraDConvertScreenPoint2NodePos2DOr3D(self.containerView, centerPoint)
	local offsetPoint = self.viewScrollView:getContentOffset()
	local subPoint = cc.pSub(covertPoint, point)
	subPoint = cc.p(subPoint.x * zoomScale, subPoint.y * zoomScale)
	local newOffsetPoint = cc.pAdd(offsetPoint, subPoint)
	newOffsetPoint = cc.p(newOffsetPoint.x, newOffsetPoint.y)
	if container then
		self.viewScrollView:getScrollPane():setPosition(newOffsetPoint)
	elseif 0 < duration then
		self.viewScrollView:setContentOffsetInDuration(newOffsetPoint, duration)
	else
		self.viewScrollView:setContentOffset(newOffsetPoint)
	end
end
function worldMapView:moveSubPointToCenter(target, data)
	local mapViewCell = self:getWorldMapCell(data.kingdomID, true)
	local subPoint = data.subPoint
	local targetPoint = cc.pSub(self.mapViewCenterPoint, subPoint)
	targetPoint = SoraDCoverToPoint2DOr3D(mapViewCell, targetPoint, self.containerView)
	self:moveMapPointToCenter(targetPoint)
end
function worldMapView:gotoTilePointOld(target, data)
	self:gotoTilePoint(target, data)
	worldMapViewDef = target
	target.scale = worldMapViewDef.NORMAL_SCALE
	self:setZoomScale(target)
	self:removeLodClickTip()
	if self:isTransferShow() then
		self:resetTransferView(nil, true)
	end
end
function worldMapView:gotoTilePoint(target, data)
	local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
	if data.kingdomID and kingdomCtrl:getIsKingdomMerged(data.kingdomID) then
		SoraDShowMsgTip(i18n("CombineServers_61"))
		return
	end
	local tilePoint = data.tilePoint
	local isSelected = data.isSelected or false
	local isShowHand = data.isShowHand or false
	local layInstance = data.layInstance or worldMapLayInstanceTypeDef.layInstanceNone
	local layInstanceData = data.layInstanceData or nil
	local mapViewCell = self:getWorldMapCell(data.kingdomID, true)
	print("isShowHand======", isShowHand)
	self:moveTilePointToCenter(tilePoint, isSelected, layInstance, layInstanceData, 0, mapViewCell, isShowHand)
end
function worldMapView:setZoomScale(data)
	local scale = data.scale or worldMapViewDef.NORMAL_SCALE
	local duration = data.duration or 0
	if 0 < duration then
		self.viewScrollView:setZoomScaleInDuration(scale, duration)
	elseif data.animated then
		self.viewScrollView:setZoomScale(scale, true)
	else
		self.viewScrollView:setZoomScale(scale)
	end
end
function worldMapView:gotoTilePointNew(target, params)
	local toTilePos = params.toTilePos
	local toScale = params.toScale
	local moveTime = params.moveTime or 0.5
	local scaleTime = params.scaleTime or 0.5
	local oldData = params.oldData
	local isSelected = params.isSelected or false
	local kingdomID = params.kingdomID
	local needAction = params.needAction
	if not needAction then
		moveTime = 0
		scaleTime = 0
	end
	local _ENV, actionList
	if toTilePos or oldData then
		table.insert(actionList, cca.callFunc(function()
			if oldData then
				local layInstanceData = oldData.layInstanceData
				if layInstanceData and not layInstanceData.duration then
					layInstanceData.duration = moveTime
				end
				self:gotoTilePoint(target, oldData)
			else
				oldData = target
				target.tilePoint = toTilePos
				oldData, target.isSelected = isSelected, isSelected
				target.layInstanceData, isSelected.duration = isSelected, moveTime
				target.kingdomID = kingdomID
				self:gotoTilePoint(target, target)
			end
		end))
		table.insert(actionList, cca.delay(moveTime))
	end
	local curScale = self.viewScrollView:getZoomScale()
	if toScale and toScale ~= curScale then
		table.insert(actionList, cca.callFunc(function()
			self = nil
			;(nil).scale = toScale
			;(nil).duration = scaleTime
			self:setZoomScale(nil)
		end))
		table.insert(actionList, cca.delay(scaleTime))
	end
	table.insert(actionList, cca.callFunc(function()
		SoraDCloseLoading()
	end))
	SoraDShowLoading(nil, nil, nil, true)
	self.viewScrollView:runAction(cca.seq(actionList))
	self:cleanShowPanel()
end
function worldMapView:refreshRelogin()
	local mapKingdomClassType = kingdomMapCtrl:getKingdomClass() or gKingdomClassType.normal
	if mapKingdomClassType ~= self.mapKingdomClassType then
		print("refreshRelogin", mapKingdomClassType, self.mapKingdomClassType)
		if mapKingdomClassType == gKingdomClassType.garden or self.mapKingdomClassType == gKingdomClassType.garden then
			return
		end
		kingdomMapCtrl = gKingdomClassType.garden
		gKingdomClassType.garden.msg = "MESSAGE_MAINSCEN_ONSHOW"
		gKingdomClassType.garden.viewType = VIEW_TYPE_MAP
		SoraDSendMessage(gKingdomClassType.garden)
		return
	end
	self.myKindomID = gametop.playertop_:getMapID()
	self:initTimer()
	self:refreshMapDataAndView()
	self:updateCheckSetMapViewCellPoint()
	self:callComFunc("relogin")
end
function worldMapView:refreshMapDataAndView()
	kingdomMapCtrl:onSwitchWorldMap(gSwitchWorldMapTypeDef.switchWorldMapType_out, worldMapDefine.currentMapKindomID)
	self:doClearData()
	kingdomMapCtrl:onSwitchWorldMap(gSwitchWorldMapTypeDef.switchWorldMapType_in, worldMapDefine.currentMapKindomID)
	self:doReqestData()
end
function worldMapView:doReqestData()
	self.preCenterPoint = nil
	self:updateCenterAreaTiles()
	self:callComFunc("doReqestData")
end
function worldMapView:updateLodChange()
	self.is_delay = true
	self.delay_time = 0.25
	self:cleanShowPanel()
end
function worldMapView:cleanShowPanel(...)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
	self:removeLodClickTip()
	if self:isTransferShow() then
		self:resetTransferView(nil, true)
	end
end
function worldMapView:doClearData()
	self:callComFunc("doClearData")
	self.MIN_TIME = MIN_TIME_DRAG
end
_ENV, worldMapView.gotoForeBackGroud = function(self, target, data)
	print("worldMapView:gotoForeBackGroud")
	local groudType = data.groudType
	if groudType == GOTO_FOREG_GROUD then
		print("地图切换到了前台，不需要刷新")
		self:doReqestData()
	elseif groudType == GOTO_BACK_GROUD then
		print("地图收到切到后台信息")
		self:doClearData()
	end
end, function(self, target, data)
	print("worldMapView:gotoForeBackGroud")
	local groudType = data.groudType
	if groudType == GOTO_FOREG_GROUD then
		print("地图切换到了前台，不需要刷新")
		self:doReqestData()
	elseif groudType == GOTO_BACK_GROUD then
		print("地图收到切到后台信息")
		self:doClearData()
	end
end
local (function(self, target, data)
	print("worldMapView:gotoForeBackGroud")
	local groudType = data.groudType
	if groudType == GOTO_FOREG_GROUD then
		print("地图切换到了前台，不需要刷新")
		self:doReqestData()
	elseif groudType == GOTO_BACK_GROUD then
		print("地图收到切到后台信息")
		self:doClearData()
	end
end).name, event_piece = worldMapEvent.EVENT_UPDATE_PIECE, function(self, target, data)
	print("worldMapView:gotoForeBackGroud")
	local groudType = data.groudType
	if groudType == GOTO_FOREG_GROUD then
		print("地图切换到了前台，不需要刷新")
		self:doReqestData()
	elseif groudType == GOTO_BACK_GROUD then
		print("地图收到切到后台信息")
		self:doClearData()
	end
end
function worldMapView:setViewPieceIds(viewPieceIDs, lod)
	event_piece.viewPieceIDs = viewPieceIDs
	event_piece.lod = lod
	self:dispatchEvent(event_piece)
end
_ENV, worldMapView.serverMessage_GetRectData = function(self, target, data)
	if data.dataEnd then
		self.isWaitForData = false
	end
end, function(self, target, data)
	if data.dataEnd then
		self.isWaitForData = false
	end
end
local _ENV, (function(self, target, data)
	if data.dataEnd then
		self.isWaitForData = false
	end
end).name, event_pixel_pos = worldMapEvent.EVENT_PIXEL_POS, worldMapEvent.EVENT_PIXEL_POS, function(self, target, data)
	if data.dataEnd then
		self.isWaitForData = false
	end
end
local worldMapEvent.EVENT_PIXEL_POS.name, event_tile_pos = worldMapEvent.EVENT_TILE_POS, worldMapEvent.EVENT_PIXEL_POS
function worldMapView:updateMapPos()
	local posx, posy = self.containerView:getPosition()
	local scale = self.containerView:getScale()
	self.containerViewNode:setPosition(cc.p(posx, display.height + posy))
	self.containerViewNode:setScale(scale)
	if self.currentInMapViewCell == nil then
		return
	end
	local pixel_pos = self.currentInMapViewCell:convertToNodeSpace(POINT_ZERO)
	pixel_pos = cc.p(math.floor(pixel_pos.x), math.floor(pixel_pos.y))
	if not self._zeroPixelPos or self._zeroPixelPos.x ~= pixel_pos.x or self._zeroPixelPos.y ~= pixel_pos.y then
		self._zeroPixelPos = pixel_pos
		event_pixel_pos.tile_pos = pixel_pos
		self:dispatchEvent(event_pixel_pos)
	end
	local tile_pos = self:getDisplayCenterTilePoint()
	if not self._zeroTilePos or self._zeroTilePos.x ~= tile_pos.x or self._zeroTilePos.y ~= tile_pos.y then
		self._zeroTilePos = tile_pos
		event_tile_pos.tile_pos = tile_pos
		self:dispatchEvent(event_tile_pos)
	end
end
function worldMapView:setTmxCulledRect(tmxView)
	if gEnableWorldMap3D then
		local width = display.width
		local height = display.rheight
		local ret, touch3DPos = SoraDGet3DTouchPos(self.viewScrollView, cc.p(width, height))
		if ret then
			local point = SoraConvertToNodeSpace3D(self.viewScrollView, touch3DPos)
			local offsetX = math.max(point.x - width, 0)
			local offsetY = math.max(point.y - height, 0)
			local rect = cc.rect(0, 0, width + offsetX, height + offsetY)
			tmxView:setCulledRect(rect)
		end
	else
		local rect = cc.rect(0, 0, display.width, display.rheight)
		tmxView:setCulledRect(rect)
	end
	if worldMapDefine.isNebulaAllStarKingdomID() then
		local rect = cc.rect(-display.width, -display.rheight * 0.5, display.width * 3, display.rheight * 2)
		_UPVALUE2_ = -display.rheight * 0.5
		;(-display.rheight * 0.5)[1] = "worldMap_nebula01_11"
		;(-display.rheight * 0.5)[2] = "worldMap_nebula02_12"
		for __, layerName in ipairs(-display.rheight * 0.5) do
			local nebulaLayer = tmxView:getLayer(layerName)
			if nebulaLayer then
				nebulaLayer:setCulledRect(rect)
			end
		end
	end
end
function worldMapView:toggle3D()
	if gEnableWorldMap3D then
		self.viewScrollView:setRotation3D(gWorldMapRotation3D)
		if self.viewScrollView.setEnable3d then
			self.viewScrollView:setEnable3d(true)
		end
		local width = display.cx
		local height = display.rheight
		local ret, touch3DPos = SoraDGet3DTouchPos(self, cc.p(width, height))
		local ret1, touch3DPosZero = SoraDGet3DTouchPos(self, cc.p(width, 0))
		if ret and ret1 then
			_ENV = cc.p(width, 0)
			cc.p(width, 0).x = touch3DPos.x
			cc.p(width, 0).y = (touch3DPos.y - touch3DPosZero.y) * 0.45
			local cc.p(width, 0).z, center = (touch3DPos.z - touch3DPosZero.z) * 0.45, cc.p(width, 0)
			local point = SoraDProject2ScreenPos3D(self, center)
			self.reqMapCenterPoint = cc.p(point.x, point.y)
		end
	else
		self.viewScrollView:setRotation3D(gWorldMapRotation2D)
		if self.viewScrollView.setEnable3d then
			self.viewScrollView:setEnable3d(false)
		end
		self.reqMapCenterPoint = cc.p(display.cx, display.cy)
	end
	self:setTmxCulledRect(self._tmxview)
	self:updateMapPos()
end
function worldMapView:getRadianceGatePos()
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	myPoint = cityCtrl:getCurCityPos()
	local radianceWarRead = include("radianceWarRead")
	local gateList = radianceWarRead.getBuildingList()
	local point, minLength
	for i, v in pairs(gateList) do
		if v.mapType == gWorldTypeServerDef.mapTypeRadianceWarGate then
			if not minLength then
				local offsetX = v.x - myPoint.x
				local offsetY = v.y - myPoint.y
				minLength = offsetX * offsetX + offsetY * offsetY
				point = cc.p(v.x - 1, v.y - 1)
			else
				local offsetX = v.x - myPoint.x
				local offsetY = v.y - myPoint.y
				local tmp = offsetX * offsetX + offsetY * offsetY
				if minLength > tmp then
					point = cc.p(v.x - 1, v.y - 1)
				end
				minLength = minLength > tmp and tmp or minLength
			end
		end
	end
	return point
end
function worldMapView:endShow()
	local moudle = gModuleMgr.sharedMgr("mildGuideManager"):getVariate(self.__cname, "gGuideModule")
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	print(gGuideModule.ESCORT)
	local isMoudleDone = guideCtrl:isGuideNotCompleted(gGuideModule.ESCORT)
	local step = guideCtrl:isStep(gGuideStep.ESCORT_STEP_1)
	print(isMoudleDone, step)
	dump(moudle, "世界地图弱引导")
	if isstring(moudle) and 0 < #moudle and isMoudleDone and step then
		print("worldMapView", moudle)
		local View = include("gameGuideView").new()
		View:show()
		View:startGuideWithStep(67001)
		guideCtrl:CompleteGuideStep(67001)
	end
end
function worldMapView:getCurrentInMapViewCell(...)
	return self.currentInMapViewCell
end
function worldMapView:gameGuide_callFunc(callFunc, data)
	dump(data, "gameGuide_callFunc", 10)
	if callFunc == "buttonWorldResouceCall" then
		self:callComFuncArgs(callFunc, nil, ccui.TouchEventType.ended)
		return
	end
	if self[callFunc] then
		self[callFunc](self, data)
	else
		self:callComFunc(callFunc)
	end
end
function worldMapView:gameGuide_callFunc_JumpToBuilding(data)
	dump(data, "gameGuide_callFunc_JumpToBuilding", 10)
	local findMonsterCtrl = SoraDGetCtrl("findMonsterCtrl")
	if data.mapID == gWorldTypeServerDef.mapTypeRadianceWarPalace then
		_ENV = gWorldTypeServerDef.mapTypeRadianceWarPalace
		gWorldTypeServerDef.mapTypeRadianceWarPalace.x = 599
		gWorldTypeServerDef.mapTypeRadianceWarPalace.y = 599
		SoraDGotoWorldMapPoint(gWorldTypeServerDef.mapTypeRadianceWarPalace, true)
	elseif data.mapID == gWorldTypeServerDef.mapTypeRadianceWarGate then
		SoraDGotoWorldMapPoint(self:getRadianceGatePos(), true)
	elseif data.mapID == gWorldTypeServerDef.mapTypeRadianceWarBeacon then
		findMonsterCtrl:sendSearchRadianceWarBeaconMsg()
	elseif data.mapID == gWorldTypeServerDef.mapTypeRadianceWarResource then
		findMonsterCtrl:sendSearchRadianceResourcesMsg(data.subMapID, data.minLv)
	elseif data.pos then
		SoraDGotoWorldMapPoint(data.pos, true)
	end
end
function worldMapView:gameGuide_callFunc_openMonsterSearch(data)
	dump(data, "gameGuide_callFunc_openMonsterSearch", 10)
	SoraDCreatePanel("worldMapMonsterSearch"):show()
end
return worldMapView
