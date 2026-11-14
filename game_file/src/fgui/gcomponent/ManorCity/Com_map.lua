local instanceFactory = include("instanceFactory")
local manorCityRead = include("manorCityRead")
local manorFarmRead = include("manorFarmRead")
local mainCityGuideRead = include("mainCityGuideRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorCityUtil = include("manorCityUtil")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_map = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorCity/Com_map", Com_map)
_ENV = fgui.register_extension
fgui.register_extension.INSTANCE = 1
fgui.register_extension.QUEUE = 2
fgui.register_extension.SELECT = 3
fgui.register_extension.TILE = 4
local fgui.register_extension.MOVE, GROUP_ID = 5, fgui.register_extension
local p0 = cc.p(0, 0)
local w = 128
local h = 64
local ZOOM_SCALE_MIN = 0.3
local ZOOM_SCALE_MAX = 1
local ZOOM_SCALE_NORMAL = 0.3
local topTipOffset = cc.p(0, -120)
local farmUIOffset = cc.p(-32, 0)
local banquetUIOffset = cc.p(-32, -120)
local GUIDE_FARM_TYPE_FIRE = 1
function Com_map:registerEvent()
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MAP_INIT", handler(self, self.onMsgMapInit))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MAP_PLACE", handler(self, self.onMsgMapPlace))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MAP_MOVE", handler(self, self.onMsgMapMove))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_ENTER_BUILD", handler(self, self.onMsgEnterBuild))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_QUIT_BUILD", handler(self, self.onMsgQuitBuild))
	SoraDAddMessage(self, "MESSAGE_MANOR_LAYOUT_QUIT_BUILD", handler(self, self.onMsgQuitLayoutBuild))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_UPDATE", handler(self, self.onMsgBuildUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_VISIT_BANQUET_UPDATE", handler(self, self.onMsgVisitBanquetUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_REMOVE", handler(self, self.onMsgBuildRemove))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_JUMP", handler(self, self.onMsgBuildJump))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_UPGRADE_QUEUE", handler(self, self.onMsgUpgradeBuildQueue))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_TECH_QUEUE", handler(self, self.onMsgTechQueue))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_MAIN_LV_UP", handler(self, self.onMsgMainBuildLvUp))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_TOP_TIP_ADD", handler(self, self.onMsgBuildTopTipAdd))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_TOP_TIP_REMOVE", handler(self, self.onMsgBuildTopTipRemove))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_FARMUI_ADD", handler(self, self.onMsgShowFarmUI))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_UPDATE", handler(self, self.onMsgFarmTopTipUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_PLANT", handler(self, self.onMsgFarmTopTipUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_BANQUETUI_ADD", handler(self, self.onMsgShowBanquetUI))
	SoraDAddMessage(self, "MESSAGE_MANOR_FARM_WATERING_ANI", handler(self, self.onMsgWateringAni))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_MERGE", handler(self, self.onMsgMergeSeedUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_CULTIVATE_SEED_TIME_END", handler(self, self.onMsgMergeSeedUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_GO_TO_BUILD", handler(self, self.onMsgGoToBuild))
	SoraDAddMessage(self, "MESSAGE_MANOR_GUIDE_AUTO_PLACE_FARM", handler(self, self.onMsgGuideAutoPlaceFarm))
	SoraDAddMessage(self, "MESSAGE_MANOR_GUIDE_SELECT_FARM", handler(self, self.onMsgGuideSelectFarm))
	SoraDAddMessage(self, "MESSAGE_MANOR_GUIDE_SELECT_FARM_RESEARCH", handler(self, self.onMsgGuideSelectFarmResearch))
end
function Com_map:onInit()
	ZOOM_SCALE_MAX, self.tileMap, _ENV = nil, nil, nil
	self.topTips, _ENV, self.coolingTips, _ENV, self.queueTypeCfg, (nil)[1] = nil, nil, nil, nil, nil, gQueueTypeDef.garden_build_upgrade
	self.topTips, _ENV, self.coolingTips, _ENV, self.queueTypeCfg, (nil)[2] = nil, nil, nil, nil, nil, gQueueTypeDef.garden_technology
	fguiHelper.registMouseEvent(self)
	self:setZoomEnable(true)
	self:setMinScale(ZOOM_SCALE_MIN)
	self:setMaxScale(ZOOM_SCALE_MAX)
	self.scrollPane = self:getScrollPane()
	self.scrollPane:AddEventListener1(fgui.UIEventType.onScrollViewDidZoom, handler(self, self.onZoomScale))
	self.fields.Com_mapBg:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onEventTouchBegin))
	self.fields.Com_mapBg:addEventListener(fgui.UIEventType.TouchMove, handler(self, self.onEventTouchMove))
	self.fields.Com_mapBg:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onEventTouchEnd))
	self.fields.Com_mapBg:addClickListener(handler(self, self.onClickMap))
	self.curSelectTip = self.fields.Com_move:getChild("Com_tip")
	self.Com_moveBuild = self.fields.Com_move:getChild("Com_moveBuild")
	local createGroupNode = function(groupID)
		local node = fgui.UIPackage:createObject("CommonNew", "Com_empty")
		node:setGroupID(groupID, true)
		node:addTo(self)
		node:setName(string.format("GROUP(%d)", groupID))
	end
	createGroupNode(GROUP_ID.INSTANCE)
	createGroupNode(GROUP_ID.QUEUE)
	createGroupNode(GROUP_ID.SELECT)
	createGroupNode(GROUP_ID.TILE)
	createGroupNode(GROUP_ID.MOVE)
	self.fields.Group_tile:setGroupID(GROUP_ID.TILE)
	self.fields.Com_move:setGroupID(GROUP_ID.MOVE)
	local sSize = self.fields.Com_mapBg:getContentSize()
	self.mapContentH = sSize.height
	local zeroPos = self.fields.Node_zero:getPosition()
	self.scrollPane:setZoomScale(1)
	self:ensureBoundsCorrect()
	self:initWithTilesetInfo()
end
function Com_map:onShow()
	self:initScrollPane()
	self.isInEdit = false
	self.isInBuild = false
	self.isInVisit = false
	self.isDeleteModel = false
	self.isMoveModel = false
	self.fields.Com_move:setVisible(false)
	self.drawNode:setVisible(false)
	if self.tilesRolygon then
		self.tilesRolygon:setVisible(false)
	end
	self:clearCloneObj()
	self:clearMapData()
end
function Com_map:onHide()
	self:clearMergeSeedTipTimer()
	SoraDCloseLoading()
end
function Com_map:initScrollPane()
	self.scrollPane:setZoomScale(ZOOM_SCALE_NORMAL)
	self.scrollPane:setPercX(0.5)
	self.scrollPane:setPercY(0.5)
end
function Com_map:onZoomScale(EventContext)
	local scale = self:getZoomScale()
	print("==Com_Map:onZoomScale==", scale)
	local reverseScale = 1 / scale
	reverseScale = math.max(1.0, reverseScale * 0.8)
	if self.curSelectTip then
		self.curSelectTip:setScale(reverseScale)
	end
end
function Com_map:onEventTouchBegin(context)
	local _toPos = context:getInput():getPosition()
	print("==onEventTouchBegin==", _toPos)
	if not self.isInEdit or not self:getSelectedInstanceCanMove() then
		return
	end
	local _mapPos = self.fields.Com_mapBg:globalToLocal(_toPos)
	local position = self.fields.Com_move:getPosition()
	local size = self.curSelectTip.instance:getHoldSize()
	local rect = cc.rect(position.x - size * w / 2, position.y - size * h / 2, size * w, size * h)
	if not cc.rectContainsPoint(rect, _mapPos) then
		return
	end
	context:captureTouch()
	self.scrollPane:setTouchEffect(false)
end
function Com_map:onEventTouchMove(context)
	local _toPos = context:getInput():getPosition()
	if not self.isInEdit or not self:getSelectedInstanceCanMove() then
		return
	end
	local _mapPos = self.fields.Com_mapBg:globalToLocal(_toPos)
	local tilePos = self:getTileWithPoint(_mapPos)
	local size = self.curSelectTip.instance:getHoldSize()
	local _tilePos
	if size % 2 == 0 then
		_tilePos = cc.p(tilePos.x + 0.5, tilePos.y + 0.5)
	else
		_tilePos = tilePos
	end
	local mapPos = self:getPointWithTile(_tilePos)
	self.fields.Com_move:setPosition(mapPos)
	self.curSelectTip.instance:setPosition(mapPos)
	local topTip = self:getTopTip(self.curSelectTip.instance)
	if topTip then
		topTip:setPosition(cc.p(mapPos.x + topTipOffset.x, mapPos.y + topTipOffset.y))
		topTip:setVisible(false)
	end
	self:updateFarmUI(false)
	self:updateBanquetUI(false)
	self:updateMoveBuildCoolingTip(false)
	if not self.isInBuild then
		self.curSelectTip:setVisible(false)
		self:removeInstanceTilesArray(self.curSelectTip.instance)
	end
	self.drawNode:setVisible(true)
	local mapPos = self.fields.Com_move:getPosition()
	local tilePos = self:getTileWithPoint(mapPos)
	local _tilePos = self:getBuildLeftTopTilePos(tilePos, size)
	self:showTileWhite(_tilePos, size)
end
function Com_map:onEventTouchEnd(context)
	local _toPos = context:getInput():getPosition()
	print("==onEventTouchEnd==", _toPos)
	if self.isInEdit and not self:getSelectedInstanceCanMove() then
		return
	end
	if self.isInEdit then
		self.scrollPane:setTouchEffect(true)
		local size = self.curSelectTip.instance:getHoldSize()
		local mapPos = self.fields.Com_move:getPosition()
		local tilePos = self:getTileWithPoint(mapPos)
		local _tilePos = self:getBuildLeftTopTilePos(tilePos, size)
		if not self:getCanPlace(_tilePos, size) then
			return
		end
		self.curSelectTip:setVisible(true)
		if not self.isInLayoutEdit then
			self:updateMoveBuildCoolingTip(true)
			local topTip = self:getTopTip(self.curSelectTip.instance)
			if topTip then
				topTip:setPosition(cc.p(mapPos.x + topTipOffset.x, mapPos.y + topTipOffset.y))
				topTip:setVisible(true)
			end
			self:updateFarmUI(true)
			self:updateBanquetUI(true)
		end
		if not self.isInBuild then
			local instance = self.curSelectTip.instance
			instance:setTilePos(_tilePos)
			local tilesArray = instanceFactory.getTilesArrayByInstace(_tilePos, size)
			for __, v in ipairs(tilesArray) do
				self.tileMap[v] = instance
			end
			instance:setTilesArray(tilesArray)
			if self.isInLayoutEdit then
				local realId = instance:getRealId()
				local mapObj = self.mapData[realId]
				self.mapData[realId] = nil
				mapObj.x = _tilePos.x
				mapObj.y = _tilePos.y
				local _realId = manorCityUtil.spliceRealId(mapObj.x, mapObj.y, mapObj.id, mapObj.iid)
				mapObj.realId = _realId
				self.mapData[_realId] = mapObj
				instance:setInstanceData(mapObj)
			else
				manorCityCtrl:reqGardenMapMove(_tilePos.x, _tilePos.y, instance:getRealId())
				SoraDShowLoading()
			end
		else
			local instance = self.curSelectTip.instance
			instance:setTilePos(_tilePos)
		end
	end
	if not self.isInBuild then
		if not self.isMoveModel then
			self.drawNode:setVisible(false)
		end
		if self.tilesRolygon then
			self.tilesRolygon:setVisible(false)
		end
	end
end
function Com_map:onClickMap(context)
	if self.isInVisit or self.isInBuild then
		return
	elseif self.isInEdit then
		self:endEdit()
		return
	end
	local _toPos = context:getInput():getPosition()
	local _mapPos = self.fields.Com_mapBg:globalToLocal(_toPos)
	local tilePos = self:getTileWithPoint(_mapPos)
	print("==Com_map:onClickMap==", tilePos.x, tilePos.y)
	local instance = self:getInstanceByTilePos(tilePos)
	if instance then
		print("==Com_map:onClickMap===", instance)
		SoraDPlaySound()
		self:onClickInstance(instance)
		local tilePos = instance:getTilePos()
		local size = instance:getHoldSize()
		local centerTilePos = self:getBuildCenterTilePos(tilePos, size)
		self:scrollToTilePos(centerTilePos, true)
	end
end
function Com_map:onClickInstance(instance)
	if instance then
		if self.isDeleteModel then
			self:removeInstanceTilesArray(instance)
			local realId = instance:getRealId()
			self.mapData[realId] = nil
			instance:removeFromParent()
			return
		end
		if not instance:onClickInstance() then
			self:startEdit(instance)
		end
	end
end
function Com_map:getInstanceCanMove(instance)
	if not instance then
		return false
	end
	if self.isInBuild then
		return true
	end
	if instance:getBuildID() == MANOR_BUILD_ID.BANQUET then
		return false
	end
	return true
end
function Com_map:getSelectedInstanceCanMove()
	if not self.curSelectTip then
		return false
	end
	return self:getInstanceCanMove(self.curSelectTip.instance)
end
function Com_map:startEdit(instance, extra)
	local canMove = self:getInstanceCanMove(instance)
	self.isInEdit = true
	instance:setGroupID(GROUP_ID.SELECT)
	for _, queueType in ipairs(self.queueTypeCfg) do
		local tipNode = instance:getChild("ManorCityCoolingTip_" .. queueType)
		if tipNode then
			tipNode:setGroupID(GROUP_ID.SELECT)
		end
	end
	local topTip = self:getTopTip(instance)
	if topTip then
		topTip:setGroupID(GROUP_ID.SELECT)
	end
	self.fields.Com_move:setVisible(true)
	self.fields.Com_move:setPosition(instance:getPosition())
	self.curSelectTip:setVisible(true)
	GROUP_ID = true
	;(true).buildID = instance:getBuildID()
	;(true).isInBuild = self.isInBuild
	;(true).instance = instance
	;(true).isInVisit = self.isInVisit
	;(true).isInLayoutEdit = self.isInLayoutEdit
	;(true).extra = extra
	self.curSelectTip:initData(true)
	self:clearCloneObj()
	local size = instance:getHoldSize()
	local pos = cc.p(size * w / 4, size * h / 4)
	self.Com_moveBuild:initSelectedData(instance, pos, canMove)
	if instance.data.id == MANOR_BUILD_ID.FARM then
		local farmUI = self:getFarmUI(instance)
		if farmUI then
			farmUI:setVisible(false)
		end
	elseif instance.data.id == MANOR_BUILD_ID.BANQUET then
		local banquetUI = self:getBanquetUI(instance)
		if banquetUI then
			banquetUI:setVisible(false)
		end
	end
end
function Com_map:endEdit(removeInstance)
	local instance = self.curSelectTip.instance
	if not instance then
		return
	end
	if removeInstance then
		instance:removeFromParent()
	else
		instance:setVisible(true)
		local tilePos = instance:getTilePos()
		local size = instance:getHoldSize()
		local centerTilePos = self:getBuildCenterTilePos(tilePos, size)
		local centerPos = self:getPointWithTile(centerTilePos)
		instance:setPosition(centerPos)
		local tilesArray = instanceFactory.getTilesArrayByInstace(tilePos, size)
		for __, v in ipairs(tilesArray) do
			self.tileMap[v] = instance
		end
		instance:setTilesArray(tilesArray)
		instance:updateZOrder()
		instance:setGroupID(GROUP_ID.INSTANCE)
		local topTip = self:getTopTip(instance)
		if topTip then
			topTip:setGroupID(GROUP_ID.QUEUE)
		end
		for _, queueType in ipairs(self.queueTypeCfg) do
			local tipNode = instance:getChild("ManorCityCoolingTip_" .. queueType)
			if tipNode then
				tipNode:setGroupID(GROUP_ID.QUEUE)
			end
		end
		self:updateMoveBuildCoolingTip(true)
		if instance.data.id == MANOR_BUILD_ID.FARM then
			local farmUI = self:getFarmUI(instance)
			if farmUI then
				farmUI:setGroupID(GROUP_ID.QUEUE)
				farmUI:setVisible(true)
				farmUI:setPosition(cc.p(instance:getPositionX() + farmUIOffset.x, instance:getPositionY() + farmUIOffset.y))
			end
		elseif instance.data.id == MANOR_BUILD_ID.BANQUET then
			local banquetUI = self:getBanquetUI(instance)
			if banquetUI then
				banquetUI:setGroupID(GROUP_ID.QUEUE)
				banquetUI:setVisible(true)
				banquetUI:setPosition(cc.p(instance:getPositionX() + banquetUIOffset.x, instance:getPositionY() + banquetUIOffset.y))
			end
		end
	end
	self.fields.Com_move:setVisible(false)
	self:clearCloneObj()
	if not self.isMoveModel then
		self.drawNode:setVisible(false)
	end
	if self.tilesRolygon then
		self.tilesRolygon:setVisible(false)
	end
	self.isInEdit = false
	self.isInBuild = false
end
function Com_map:initWithTilesetInfo(...)
	local drawNode = cc.DrawNode:create()
	drawNode:addTo(self.fields.Com_mapBg)
	self.drawNode = drawNode
	self.drawNode:setVisible(false)
end
function Com_map:drawLine(beginTilePoint, endTilePoint)
	local tile1 = cc.p(beginTilePoint.x - 0.5, beginTilePoint.y - 0.5)
	local beginPoint = worldMapDefine.tile2point_fgui(p0, tile1, w, h)
	beginPoint = cc.p(beginPoint.x, self.mapContentH - beginPoint.y)
	local tile2 = cc.p(endTilePoint.x - 0.5, endTilePoint.y - 0.5)
	local endPoint = worldMapDefine.tile2point_fgui(p0, tile2, w, h)
	endPoint = cc.p(endPoint.x, self.mapContentH - endPoint.y)
	self.drawNode:drawLine(beginPoint, endPoint, cc.c4f(0, 1, 0, 1))
end
function Com_map:getPointWithTile(tilePoint)
	return worldMapDefine.tile2point_fgui(p0, tilePoint, w, h)
end
function Com_map:getTileWithPoint(point)
	return worldMapDefine.point2tileRounding_fgui(point, p0, w, h)
end
function Com_map:getBuildCenterTilePos(tilePos, size)
	return cc.p(tilePos.x + size / 2 - 0.5, tilePos.y + size / 2 - 0.5)
end
function Com_map:getBuildLeftTopTilePos(tilePos, size)
	return cc.p(math.ceil(tilePos.x - size / 2), math.ceil(tilePos.y - size / 2))
end
function Com_map:getCanPlace(tilePos, size)
	if not self:checkTileRange(tilePos, size) then
		return false
	end
	local tilesArray = instanceFactory.getTilesArrayByInstace(tilePos, size)
	for __, v in ipairs(tilesArray) do
		if self.tileMap[v] then
			return false
		end
	end
	return true
end
function Com_map:checkTileRange(tilePos, size)
	local min, max = self.tileRange.minX, self.tileRange.maxX
	local tileMax = cc.p(tilePos.x + size - 1, tilePos.y + size - 1)
	if min > tilePos.x or max < tileMax.x or min > tilePos.y or max < tileMax.y then
		return false
	end
	return true
end
function Com_map:getCanPlaceMap(tilePos, size)
	local canPlace = true
	local _ENV, canPlaceMap
	local min, max = self.tileRange.minX, self.tileRange.maxX
	for i = 0, size - 1 do
		for j = 0, size - 1 do
			local _tilePos = cc.p(tilePos.x + i, tilePos.y + j)
			local poskey = _tilePos.x .. "," .. _tilePos.y
			if min > _tilePos.x or max < _tilePos.x or min > _tilePos.y or max < _tilePos.y then
				canPlace = false
				canPlaceMap[poskey] = false
			elseif self.tileMap[poskey] then
				canPlace = false
				canPlaceMap[poskey] = false
			else
				canPlaceMap[poskey] = true
			end
		end
	end
	return canPlace, canPlaceMap
end
function Com_map:findEmptyTilePos(centerTilePos, size)
	local checkPos = centerTilePos
	if self:getCanPlace(checkPos, size) then
		return checkPos
	end
	local min, max = self.tileRange.minX, self.tileRange.maxX
	local maxRadius = math.max(math.max(centerTilePos.x - min, max - centerTilePos.x), math.max(centerTilePos.y - min, max - centerTilePos.y))
	for radius = 1, maxRadius do
		for dx = -radius, radius do
			local checkPos = cc.p(centerTilePos.x + dx, centerTilePos.y + radius)
			if self:getCanPlace(checkPos, size) then
				return checkPos
			end
		end
		for dy = radius - 1, -radius, -1 do
			local checkPos = cc.p(centerTilePos.x + radius, centerTilePos.y + dy)
			if self:getCanPlace(checkPos, size) then
				return checkPos
			end
		end
		for dx = radius - 1, -radius, -1 do
			local checkPos = cc.p(centerTilePos.x + dx, centerTilePos.y - radius)
			if self:getCanPlace(checkPos, size) then
				return checkPos
			end
		end
		for dy = -radius + 1, radius - 1 do
			local checkPos = cc.p(centerTilePos.x - radius, centerTilePos.y + dy)
			if self:getCanPlace(checkPos, size) then
				return checkPos
			end
		end
	end
	return nil
end
function Com_map:getNextPlaceTilePos(addObj)
	local tilePos = cc.p(addObj.x, addObj.y)
	local buildID = addObj.id
	local buildSize = manorCityRead.getBuildSize(buildID)
	local maxCount = manorCityRead.getBuildMaxNum(buildID)
	if buildSize[1] ~= 1 or buildSize[2] ~= 1 or not (1 < maxCount) then
		return nil
	end
	_ENV = nil
	;(nil).d = cc.p(0, 1)
	;(nil).u = cc.p(0, -1)
	;(nil).l = cc.p(-1, 0)
	local _UPVALUE4_, (nil).r, dir = cc.p(1, 0), cc.p(1, 0), nil
	cc.p(1, 0)[1] = dir.d
	cc.p(1, 0)[2] = dir.u
	cc.p(1, 0)[3] = dir.l
	local cc.p(1, 0)[4], dirList = dir.r, cc.p(1, 0)
	local _ENV, nearRoads = dir.d, dir.d
	for __, v in ipairs(dirList) do
		local checkPos = cc.p(tilePos.x + v.x, tilePos.y + v.y)
		local instance = self:getInstanceByTilePos(checkPos)
		if instance and instance:getBuildID() == buildID then
			table.insert(nearRoads, v)
		end
	end
	local nearRoadCount = #nearRoads
	if nearRoadCount == 0 then
		for __, v in ipairs(dirList) do
			local checkPos = cc.p(tilePos.x + v.x, tilePos.y + v.y)
			if self:getCanPlace(checkPos, 1) then
				return checkPos
			end
		end
	elseif 1 <= nearRoadCount and nearRoadCount <= 3 then
		for __, v in ipairs(nearRoads) do
			local reverse = cc.p(-v.x, -v.y)
			local checkPos = cc.p(tilePos.x + reverse.x, tilePos.y + reverse.y)
			if self:getCanPlace(checkPos, 1) then
				return checkPos
			end
		end
		for __, v in ipairs(dirList) do
			local checkPos = cc.p(tilePos.x + v.x, tilePos.y + v.y)
			if self:getCanPlace(checkPos, 1) then
				return checkPos
			end
		end
	else
		for i = 1, self.tileRange.maxX do
			for __, v in ipairs(dirList) do
				local checkPos = cc.p(tilePos.x + v.x * i, tilePos.y + v.y * i)
				local instance = self:getInstanceByTilePos(checkPos)
				if not instance then
					return checkPos
				end
			end
		end
	end
end
function Com_map:showTileWhite(tilePos, size)
	if not self.tilesRolygon then
		local obj = fgui.UIPackage:createObject("ManorCity", "Com_tilesRolygon")
		obj:addTo(self.fields.Group_tile)
		obj:setComMap(self)
		self.tilesRolygon = obj
	end
	self.tilesRolygon:setVisible(true)
	local obj = self.tilesRolygon
	local canPlace, canPlaceMap = self:getCanPlaceMap(tilePos, size)
	obj:showTilesRolygon(tilePos, size, canPlaceMap)
	self.curSelectTip:setCanPlace(canPlace)
end
function Com_map:createInstance(data)
	local instance = fgui.UIPackage:createObject("ManorCity", "ManorCityInstance")
	instance:addTo(self.fields.Group_instance)
	instance:setGroupAuto(true)
	instance:setGroupID(GROUP_ID.INSTANCE)
	instance:initInstanceData(data, self.player)
	local tilePos = instance:getTilePos()
	local size = instance:getHoldSize()
	local centerTilePos = self:getBuildCenterTilePos(tilePos, size)
	local centerPos = self:getPointWithTile(centerTilePos)
	instance:setPosition(centerPos)
	instance:updateZOrder()
	return instance
end
function Com_map:startBuild(buildID, tilePos, extra)
	manorCityRead, self.isInBuild = nil, true
	;(nil).x = 0
	;(nil).y = 0
	;(nil).id = buildID
	local (nil).extra, data = extra, nil
	local buildSize = manorCityRead.getBuildSize(buildID)
	if tilePos then
		data.x = tilePos.x
		data.y = tilePos.y
	else
		local min, max = self.tileRange.minX, self.tileRange.maxX
		local offset = max - min
		local centerTilePos = cc.p(math.floor(offset / 2) + min, math.floor(offset / 2) + min)
		local emptyTilePos = self:findEmptyTilePos(centerTilePos, buildSize[1])
		if emptyTilePos then
			data.x = emptyTilePos.x
			data.y = emptyTilePos.y
		else
			data.x = centerTilePos.x
			data.y = centerTilePos.y
		end
	end
	local tilePos = cc.p(data.x, data.y)
	local centerTilePos = self:getBuildCenterTilePos(tilePos, buildSize[1])
	self:scrollToTilePos(centerTilePos, true)
	local instance = self:createInstance(data)
	self:startEdit(instance, extra)
	self.drawNode:setVisible(true)
	local tilePos = cc.p(data.x, data.y)
	self:showTileWhite(tilePos, buildSize[1])
end
function Com_map:scrollToTilePos(tilePos, animated)
	local centerPos = self:getPointWithTile(tilePos)
	local zoomScale = self:getZoomScale()
	local targetPos = cc.p(centerPos.x * zoomScale - self:getWidth() / 2, centerPos.y * zoomScale - self:getHeight() / 2)
	self.scrollPane:setContentOffset(targetPos, animated)
end
function Com_map:onMsgEnterBuild(target, event)
	if (event.isInLayoutEdit or false) ~= (self.isInLayoutEdit or false) then
		return
	end
	self:checkEndEdit()
	local buildID = event.buildID
	if self.isInLayoutEdit then
		self:startBuild(buildID)
		return
	end
	if buildID == MANOR_BUILD_ID.FARM then
		_ENV = nil
		;(nil).isSwitch = false
		;(nil).comMap = self
		;(nil).callback = function(farmType, comMap)
			buildID = nil
			;(nil).type = farmType
			comMap:startBuild(buildID, nil, nil)
		end
		uiManager:show("PlantTypeView", nil)
		return
	elseif buildID == MANOR_BUILD_ID.BANQUET then
		_ENV = nil
		;(nil).comMap = self
		;(nil).callback = function(type, comMap)
			buildID = nil
			;(nil).lv = type
			comMap:startBuild(buildID, nil, nil)
		end
		uiManager:show("BanquetTypeView", nil)
		return
	end
	self:startBuild(buildID)
end
function Com_map:onMsgQuitBuild(target, event)
	if self.isInLayoutEdit then
		return
	end
	local subMsg = event.subMsg
	if subMsg == "recycle" then
		self:removeInstanceTilesArray(self.curSelectTip.instance)
		self:endEdit(true)
	elseif subMsg == "build_no" then
		self:endEdit(true)
	elseif subMsg == "build_yes" then
		self:endEdit(false)
	else
		self:endEdit(false)
	end
end
function Com_map:onMsgQuitLayoutBuild(target, event)
	if not self.isInLayoutEdit then
		return
	end
	local subMsg = event.subMsg
	if subMsg == "recycle" then
		local instance = self.curSelectTip.instance
		self:removeInstanceTilesArray(instance)
		local realId = instance:getRealId()
		self.mapData[realId] = nil
		self:endEdit(true)
	elseif subMsg == "build_no" then
		self:endEdit(true)
	elseif subMsg == "build_yes" then
		self:endEdit(false)
		local instance = self.curSelectTip.instance
		local tilePos = instance:getTilePos()
		local buildID = instance:getBuildID()
		local addObj = manorCityUtil.createMapObj(tilePos.x, tilePos.y, buildID)
		local realId = addObj.realId
		self.mapData[realId] = addObj
		manorCityUtil = nil
		;(nil).addObj = addObj
		self:onMsgMapPlace(target, nil)
	else
		self:endEdit(false)
	end
end
function Com_map:onMsgBuildUpdate(target, event)
	if self.isInVisit or self:checkIsInLayoutModel() then
		return
	end
	local data = event.data
	local instance = self:getInstanceByTilePos(cc.p(data.x, data.y))
	if instance then
		instance:updateInstance(data)
		if not self.isInVisit and data.id == MANOR_BUILD_ID.FARM then
			instance:showFarmUI()
			instance:checkShowTopTip()
		elseif data.id == MANOR_BUILD_ID.BANQUET then
			instance:showBanquetUI()
			instance:checkShowTopTip()
		end
	end
end
function Com_map:onMsgVisitBanquetUpdate(target, event)
	if not self.isInVisit or self:checkIsInLayoutModel() then
		return
	end
	if not event.data then
		local _ENV, data = event.data, event.data
	end
	if not self.player or tonumber(self.player.uid) ~= tonumber(data.uid) then
		return
	end
	local mapObj = data.mapObj
	if not mapObj then
		return
	end
	if event.isRemove then
		_ENV = nil
		;(nil).data = mapObj.realId
		;(nil).isVisit = true
		self:onMsgBuildRemove(target, nil)
		return
	end
	self.mapData[mapObj.realId] = mapObj
	local instance = self:getInstanceByTilePos(cc.p(mapObj.x, mapObj.y))
	if instance then
		instance:updateInstance(mapObj)
		instance:showBanquetUI()
		instance:checkShowTopTip()
	end
end
function Com_map:onMsgBuildRemove(target, event)
	local realId = event.data
	if self:checkIsInLayoutModel() then
		return
	end
	local isVisit = event.isVisit == true
	if self.isInVisit ~= isVisit then
		return
	end
	self.mapData[realId] = nil
	local instance
	for i = 1, self.fields.Group_instance:numChildren() do
		local child = self.fields.Group_instance:getChildAt(i - 1)
		if child and child.getRealId and tostring(child:getRealId()) == tostring(realId) then
			instance = child
			break
		end
	end
	if not instance then
		return
	end
	self:removeInstanceTilesArray(instance)
	local topTip = self:getTopTip(instance)
	if topTip then
		topTip:removeFromParent()
	end
	local farmUI = self:getFarmUI(instance)
	if farmUI then
		farmUI:removeFromParent()
	end
	local banquetUI = self:getBanquetUI(instance)
	if banquetUI then
		banquetUI:removeFromParent()
	end
	if self.isInEdit and self.curSelectTip and self.curSelectTip.instance == instance then
		self:endEdit(true)
		return
	end
	instance:removeFromParent()
end
function Com_map:clearCloneObj()
	if self.curSelectTip.cloneObj then
		self.curSelectTip.cloneObj:removeFromParent()
		self.curSelectTip.cloneObj = nil
	end
end
function Com_map:removeInstanceTilesArray(instance)
	local tilesArray = instance:getTilesArray()
	for __, v in ipairs(tilesArray) do
		self.tileMap[v] = nil
	end
end
function Com_map:onMsgMapInit(target, event)
	if self:checkIsInLayoutModel() then
		return
	end
	if event.isReload then
		SoraDCloseLoading()
	else
		self:initScrollPane()
	end
	self:checkEndEdit()
	self:clearMapData()
	if not event.player then
		local _ENV, player = event.player, event.player
	end
	self:initVisitData(player)
	if not event.mapData then
		local _ENV, mapData = event.mapData, event.mapData
	end
	self:initMapData(mapData, self.isInVisit)
end
function Com_map:checkBanquetIsFinish(mapObj)
	if not mapObj or mapObj.id ~= MANOR_BUILD_ID.BANQUET then
		return false
	end
	if not mapObj.extra then
		local _ENV, extra = mapObj.extra, mapObj.extra
	end
	local cfg = manorCityRead.getBanquetRewardConfig(extra.lv)
	if not cfg then
		return true
	end
	return (extra.placeTime or 0) + cfg.time <= serviceFunctions.systemTime()
end
function Com_map:initMapData(mapData, isInVisit)
	self.mapData, _ENV = nil, nil
	for key, data in pairs(mapData) do
		if not self:checkIsInLayoutModel() and self:checkBanquetIsFinish(data) then
		else
			self.mapData[key] = data
			local obj = self:createInstance(data)
			local buildSize = manorCityRead.getBuildSize(data.id)
			local tilesArray = instanceFactory.getTilesArrayByInstace(data, buildSize[1])
			for __, tile in ipairs(tilesArray) do
				self.tileMap[tile] = obj
			end
			if not self:checkIsInLayoutModel() then
				obj:checkShowTopTip()
				if data.id == MANOR_BUILD_ID.FARM then
					obj:showFarmUI()
				elseif data.id == MANOR_BUILD_ID.BANQUET then
					obj:showBanquetUI()
				end
			end
		end
	end
	self:updateMapRange()
	if not self.isInVisit and not self:checkIsInLayoutModel() then
		instanceFactory = self:checkIsInLayoutModel()
		self:checkIsInLayoutModel()[1] = gQueueTypeDef.garden_build_upgrade
		local self:checkIsInLayoutModel()[2], table = gQueueTypeDef.garden_technology, self:checkIsInLayoutModel()
		for i, qtype in ipairs(table) do
			self:showBuildCoolingTip(qtype)
		end
		self:updateMergeSeedTipTimer()
	else
		self:clearMergeSeedTipTimer()
	end
end
function Com_map:initVisitData(player)
	if player.uid ~= SoraDGetPlayerID() then
		self.isInVisit = true
		self.player = player
	else
		self.isInVisit = false
		self.player = nil
	end
end
function Com_map:onMsgMapPlace(target, event)
	local addObj = event.addObj
	self.mapData[addObj.realId] = addObj
	self:onMsgMapMove(target, event)
	local buildID = addObj.id
	local buildType = manorCityRead.getBuildType(buildID)
	if buildType == MANOR_BUILD_TYPE.SCENERY then
		local mapData
		if self.isInLayoutEdit then
			mapData = self.mapData
		end
		local hasCount = manorCityCtrl:getBuildCountByBid(buildID, mapData)
		local unlockNum = manorCityUtil.getBuildUnlockNum(buildID)
		if hasCount >= unlockNum then
			SoraDShowMsgTip(i18n("garden_text_31"))
			return
		end
		local nextTilePos = self:getNextPlaceTilePos(addObj)
		self:startBuild(buildID, nextTilePos)
	end
end
function Com_map:onMsgMapMove(target, event)
	SoraDCloseLoading()
	local addObj = event.addObj
	local tilePos = cc.p(addObj.x, addObj.y)
	local instance = self:getInstanceByTilePos(tilePos)
	if instance then
		instance:setInstanceData(addObj)
		if not self:checkIsInLayoutModel() then
			if addObj.id == MANOR_BUILD_ID.FARM then
				instance:showFarmUI()
				instance:checkShowTopTip()
			elseif addObj.id == MANOR_BUILD_ID.BANQUET then
				instance:showBanquetUI()
				instance:checkShowTopTip()
			end
		end
	end
end
function Com_map:clearMapData()
	self.tileMap, _UPVALUE0_ = nil, nil
	self.fields.Group_instance:removeAllChildren()
	self.fields.Group_topTip:removeAllChildren()
	self.mapData, _UPVALUE0_, self.topTips, _UPVALUE0_, self.coolingTips, _UPVALUE0_ = self.fields.Group_topTip.removeAllChildren, self.fields.Group_topTip.removeAllChildren, self.fields.Group_topTip.removeAllChildren, self.fields.Group_topTip.removeAllChildren, self.fields.Group_topTip.removeAllChildren, self.fields.Group_topTip.removeAllChildren
	self:clearMergeSeedTipTimer()
end
function Com_map:clearMergeSeedTipTimer()
	if self.mergeSeedTipTimer then
		SoraDManagerRemoveTimer(self, self.mergeSeedTipTimer)
		self.mergeSeedTipTimer = nil
	end
	self.mergeSeedTipNextTime = nil
end
function Com_map:updateMergeSeedTipTimer()
	local nextTime = manorCityCtrl:getNextMergeSeedOutputTime()
	if not nextTime then
		self:clearMergeSeedTipTimer()
		return
	end
	self.mergeSeedTipNextTime = nextTime
	if not self.mergeSeedTipTimer then
		self.mergeSeedTipTimer = SoradCreateTimer(self, handler(self, self.onMergeSeedTipTimer))
	end
end
function Com_map:onMergeSeedTipTimer()
	if not self.mergeSeedTipNextTime then
		self:clearMergeSeedTipTimer()
		return
	end
	if serviceFunctions.systemTime() < self.mergeSeedTipNextTime then
		return
	end
	self:refreshMergeSeedTopTip()
end
function Com_map:refreshMergeSeedTopTip()
	if self.isInVisit or self:checkIsInLayoutModel() then
		self:clearMergeSeedTipTimer()
		return
	end
	local mapObj = manorCityCtrl:getMapObjByBid(MANOR_BUILD_ID.FARM_RESEARCH)
	if not mapObj then
		self:clearMergeSeedTipTimer()
		return
	end
	local instance = self:getInstanceByTilePos(cc.p(mapObj.x, mapObj.y))
	if instance then
		instance:checkShowTopTip()
	end
	self:updateMergeSeedTipTimer()
end
function Com_map:getInstanceByTilePos(tilePos)
	local poskey = tilePos.x .. "," .. tilePos.y
	return self.tileMap[poskey]
end
function Com_map:onMsgBuildJump(target, event)
	local buildID = event.buildID
	local iid = event.iid
	local mapObj = manorCityCtrl:getMapObjByBid(buildID, iid)
	if not mapObj then
		manorCityCtrl = nil
		;(nil).buildID = buildID
		uiManager:show("ManorCityBuildList", nil)
		return
	end
	local tilePos = cc.p(mapObj.x, mapObj.y)
	local buildSize = manorCityRead.getBuildSize(buildID)
	local centerTilePos = self:getBuildCenterTilePos(tilePos, buildSize[1])
	self:scrollToTilePos(centerTilePos, true)
	self:checkEndEdit()
	local instance = self:getInstanceByTilePos(tilePos)
	if instance and (event.selectBuild or event.opType) then
		self:onClickInstance(instance)
	end
	if event.opType and instance then
		local opBtn = self.curSelectTip:getBtnByOpType(event.opType)
		if opBtn then
			self:removeInstanceFinger(opBtn)
			local finger = SoraDFingerAction(nil, nil, 3)
			finger:setName("finger")
			finger:addTo(opBtn)
			finger:setPosition(cc.p(opBtn:getWidth() / 2, opBtn:getHeight() / 2))
			finger:setGroupID(GROUP_ID.MOVE)
		end
	end
	local showFinger = event.showFinger
	if showFinger and instance then
		self:removeInstanceFinger(instance)
		local finger = SoraDFingerAction(nil, nil, 3)
		finger:setName("finger")
		finger:addTo(instance)
		finger:setGroupID(GROUP_ID.TILE)
	end
end
function Com_map:onMsgGuideAutoPlaceFarm()
	if self.isInVisit or self:checkIsInLayoutModel() then
		return
	end
	local instance = self.curSelectTip and self.curSelectTip.instance
	if not instance or instance:getBuildID() ~= MANOR_BUILD_ID.FARM or not self.isInBuild then
		self:checkEndEdit()
		_ENV = nil
		;(nil).type = GUIDE_FARM_TYPE_FIRE
		self:startBuild(MANOR_BUILD_ID.FARM, nil, nil)
		instance = self.curSelectTip and self.curSelectTip.instance
	end
	if not instance then
		return
	end
	local tilePos = instance:getTilePos()
	local buildSize = manorCityRead.getBuildSize(MANOR_BUILD_ID.FARM)
	if not self:getCanPlace(tilePos, buildSize[1]) then
		return
	end
	local extra = instance:getExtra()
	manorCityCtrl:reqGardenMapPlace(tilePos.x, tilePos.y, MANOR_BUILD_ID.FARM, extra)
	SoraDShowLoading()
	_ENV = manorCityCtrl
	manorCityCtrl.msg = "MESSAGE_MANOR_CITY_QUIT_BUILD"
	manorCityCtrl.subMsg = "build_yes"
	SoraDSendMessage(manorCityCtrl)
	self:playGuideSeedFly()
	if tonumber(SoraDIsGameGuide()) == 1270104 then
		guideCtrl:CompleteGuideStep(1270104)
	end
end
function Com_map:playGuideSeedFly()
	local rewards = mainCityGuideRead:getReward(1270100)
	local reward = rewards[1]
	if reward then
		mainCityGuideRead, _ENV = nil, nil
		;(nil).id = reward.itemID
		;(nil).count = reward.itemCount
		;(nil)[1] = nil
		SoraDMailGainItems(nil, true, nil, nil, 1)
	end
end
function Com_map:guideSelectBuild(buildID)
	if self.isInVisit or self:checkIsInLayoutModel() then
		return
	end
	local mapObj = manorCityCtrl:getMapObjByBid(buildID)
	if not mapObj then
		return
	end
	local tilePos = cc.p(mapObj.x, mapObj.y)
	local buildSize = manorCityRead.getBuildSize(buildID)
	local centerTilePos = self:getBuildCenterTilePos(tilePos, buildSize[1])
	self:scrollToTilePos(centerTilePos, true)
	self:checkEndEdit()
	local instance = self:getInstanceByTilePos(tilePos)
	if instance then
		self:onClickInstance(instance)
	end
end
function Com_map:onMsgGuideSelectFarm()
	self:guideSelectBuild(MANOR_BUILD_ID.FARM)
end
function Com_map:onMsgGuideSelectFarmResearch()
	self:guideSelectBuild(MANOR_BUILD_ID.FARM_RESEARCH)
end
function Com_map:removeInstanceFinger(instance)
	local finger = instance:getChild("finger")
	if finger then
		finger:removeFromParent()
	end
end
function Com_map:showBuildCoolingTip(queueType)
	local tipNode = self.coolingTips[queueType]
	if tipNode then
		tipNode:removeFromParent()
		self.coolingTips[queueType] = nil
	end
	local queue = queueCtrl:queryQueue(queueType)
	if queue then
		local mapObj
		if queueType == gQueueTypeDef.garden_build_upgrade then
			local data = queue.data
			mapObj = manorCityCtrl:getMapObjByBid(data.bid, data.iid)
		elseif queueType == gQueueTypeDef.garden_technology then
			mapObj = manorCityCtrl:getMapObjByBid(MANOR_BUILD_ID.SMART_PALACE)
		end
		if not mapObj then
			return
		end
		local tilePos = cc.p(mapObj.x, mapObj.y)
		local instance = self:getInstanceByTilePos(tilePos)
		local tipNode = fgui.UIPackage:createObject("ManorCity", "ManorCityCoolingTip")
		tipNode:setName("ManorCityCoolingTip_" .. queueType)
		tipNode:addTo(instance)
		tipNode:setGroupID(GROUP_ID.QUEUE)
		self.coolingTips[queueType] = tipNode
		tipNode:initData(queueType)
	end
	self:sortCoolingTipsPos()
end
function Com_map:sortCoolingTipsPos()
	local offsetY = -60
	local _ENV, ret
	for queueType, v in pairs(self.coolingTips) do
		local queueData = v:getQueue()
		local bid
		if queueType == gQueueTypeDef.garden_technology then
			bid = MANOR_BUILD_ID.SMART_PALACE
		else
			bid = queueData.data.bid
		end
		if not ret[bid] then
			ret[bid], _ENV = ret[bid], ret[bid]
		end
		_ENV = nil
		;(nil).queueType = queueType
		;(nil).obj = v
		table.insert(ret[bid], nil)
	end
	for bid, data in pairs(ret) do
		table.sort(data, function(a, b)
			return a.queueType > b.queueType
		end)
	end
	for bid, data in pairs(ret) do
		for i, v in ipairs(data) do
			v.obj:setPositionY(offsetY * (i - 1))
		end
	end
end
function Com_map:updateMoveBuildCoolingTip(visible)
	for _, queueType in ipairs(self.queueTypeCfg) do
		local tipNode = self.curSelectTip.instance:getChild("ManorCityCoolingTip_" .. queueType)
		if tipNode then
			tipNode:setVisible(visible)
		end
	end
end
function Com_map:getTopTip(instance)
	if not instance:getiid() then
		return
	end
	return self.fields.Group_topTip:getChild("ManorCityTopTip" .. instance:getBuildID() .. "_" .. instance:getiid())
end
function Com_map:getFarmUI(instance)
	if not instance:getiid() then
		return
	end
	return self.fields.Group_topTip:getChild("ManorFarmUI" .. instance:getBuildID() .. "_" .. instance:getiid())
end
function Com_map:getBanquetUI(instance)
	if not instance:getiid() then
		return
	end
	return self.fields.Group_topTip:getChild("ManorBanquetUI" .. instance:getBuildID() .. "_" .. instance:getiid())
end
function Com_map:updateFarmUI(visible)
	local farmUI = self:getFarmUI(self.curSelectTip.instance)
	if farmUI then
		if visible then
			farmUI:setPosition(cc.p(self.curSelectTip.instance:getPositionX() + farmUIOffset.x, self.curSelectTip.instance:getPositionY() + farmUIOffset.y))
		end
		farmUI:setVisible(visible)
	end
end
function Com_map:updateBanquetUI(visible)
	local banquetUI = self:getBanquetUI(self.curSelectTip.instance)
	if banquetUI then
		if visible then
			banquetUI:setPosition(cc.p(self.curSelectTip.instance:getPositionX() + banquetUIOffset.x, self.curSelectTip.instance:getPositionY() + banquetUIOffset.y))
		end
		banquetUI:setVisible(visible)
	end
end
function Com_map:onMsgUpgradeBuildQueue(target, event)
	if self.isInVisit or self:checkIsInLayoutModel() then
		return
	end
	self:showBuildCoolingTip(gQueueTypeDef.garden_build_upgrade)
	local queueData = event.data
	local mapObj = manorCityCtrl:getMapObjByBid(queueData.bid, queueData.iid)
	local instance = self:getInstanceByTilePos(cc.p(mapObj.x, mapObj.y))
	if instance then
		instance:checkShowTopTip()
	end
	if self.isInEdit then
		local _data = self.curSelectTip.instance:getInstanceData()
		if _data.id == queueData.bid and _data.iid == queueData.iid then
			self:endEdit()
		end
	end
end
function Com_map:onMsgTechQueue(target, event)
	if self.isInVisit or self:checkIsInLayoutModel() then
		return
	end
	self:showBuildCoolingTip(gQueueTypeDef.garden_technology)
	local mapObj = manorCityCtrl:getMapObjByBid(MANOR_BUILD_ID.SMART_PALACE)
	local instance = self:getInstanceByTilePos(cc.p(mapObj.x, mapObj.y))
	if instance then
		instance:checkShowTopTip()
	end
	if self.isInEdit then
		local _data = self.curSelectTip.instance:getInstanceData()
		if _data.id == MANOR_BUILD_ID.SMART_PALACE then
			self:endEdit()
		end
	end
end
function Com_map:onMsgMainBuildLvUp(target, event)
	if self.isInVisit then
		return
	end
	self:updateMapRange()
end
function Com_map:updateMapRange()
	local buildLv = 0
	if self.isInVisit then
		for __, mapObj in pairs(self.mapData) do
			if mapObj.id == MANOR_BUILD_ID.MAIN then
				buildLv = mapObj.lv
				break
			end
		end
	else
		buildLv = manorCityCtrl:getBuildLvByBid(MANOR_BUILD_ID.MAIN)
	end
	local range, mapLv = manorCityRead.getGardenMapRange(buildLv)
	print("==Com_map:updateMapRange==", buildLv, mapLv, self.mapLv)
	if self.mapLv == mapLv then
		return
	end
	self.mapLv = mapLv
	local c1 = self.fields.Com_mapBg:getController("c1")
	c1:setSelectedIndex(self.mapLv - 1)
	_ENV = c1.setSelectedIndex
	c1.setSelectedIndex.minX = range[1]
	c1.setSelectedIndex.minY = range[2]
	c1.setSelectedIndex.maxX = range[3]
	self.tileRange, c1.setSelectedIndex.maxY = c1.setSelectedIndex, range[4]
	self.drawNode:clear()
	local min, max = self.tileRange.minX, self.tileRange.maxX
	for i = min, max + 1 do
		self:drawLine(cc.p(i, min), cc.p(i, max + 1))
		self:drawLine(cc.p(min, i), cc.p(max + 1, i))
	end
end
function Com_map:showBuildTopTip(data, tipType)
	if self:checkIsInLayoutModel() then
		return
	end
	dump(data, "==Com_map:showBuildTopTip==")
	local mapObj = self:getMapObjByBid(data.id, data.iid)
	if not mapObj then
		return
	end
	local tilePos = cc.p(mapObj.x, mapObj.y)
	local instance = self:getInstanceByTilePos(tilePos)
	if not instance then
		return
	end
	local tipNode = self:getTopTip(instance)
	if not tipNode then
		tipNode = fgui.UIPackage:createObject("ManorCity", "ManorCityTopTip")
		tipNode:setGroupID(GROUP_ID.QUEUE)
		tipNode:setName("ManorCityTopTip" .. data.id .. "_" .. data.iid)
		tipNode:addTo(self.fields.Group_topTip)
		tipNode:setPosition(cc.p(instance:getPositionX() + topTipOffset.x, instance:getPositionY() + topTipOffset.y))
		local cityBuildNodeCreator = include("cityBuildNodeCreator")
		local action = cityBuildNodeCreator:createAction("topTipEffect")
		tipNode:runAction(action)
		tipNode:setInstance(instance)
	end
	if not self.player then
		_ENV = self.player
		self.player.uid = SoraDGetPlayerID()
	end
	tipNode:initData(data, tipType, self.player)
end
function Com_map:onMsgBuildTopTipAdd(target, event)
	local data = event.data
	local tipType = event.tipType
	self:showBuildTopTip(data, tipType)
end
function Com_map:hideBuildTopTip(data)
	if self:checkIsInLayoutModel() then
		return
	end
	dump(data, "==Com_map:hideBuildTopTip==")
	local mapObj = self:getMapObjByBid(data.id, data.iid)
	if not mapObj then
		return
	end
	local tilePos = cc.p(mapObj.x, mapObj.y)
	local instance = self:getInstanceByTilePos(tilePos)
	if not instance then
		return
	end
	local tipNode = self:getTopTip(instance)
	if tipNode then
		tipNode:removeFromParent()
	end
end
function Com_map:onMsgBuildTopTipRemove(target, event)
	local data = event.data
	self:hideBuildTopTip(data)
end
function Com_map:onMsgMergeSeedUpdate()
	if self.isInVisit or self:checkIsInLayoutModel() then
		return
	end
	self:refreshMergeSeedTopTip()
end
function Com_map:onMsgFarmTopTipUpdate()
	self:refreshFarmTopTip()
end
function Com_map:refreshFarmTopTip()
	if self.isInVisit or self:checkIsInLayoutModel() then
		return
	end
	if not self.mapData then
		_ENV = self.mapData
	end
	for _, mapObj in pairs(self.mapData) do
		if mapObj.id == MANOR_BUILD_ID.FARM then
			local farmObj = manorCityCtrl:getMapObjByBid(MANOR_BUILD_ID.FARM, mapObj.iid) or mapObj
			local instance = self:getInstanceByTilePos(cc.p(mapObj.x, mapObj.y))
			if instance then
				instance:updateInstance(farmObj)
				instance:checkShowTopTip()
			end
		end
	end
end
function Com_map:onMsgShowFarmUI(target, event)
	if self:checkIsInLayoutModel() then
		return
	end
	local data = event.data
	local isInVisit = event.isInVisit
	local mapObj = event.data
	local tilePos = cc.p(mapObj.x, mapObj.y)
	local instance = self:getInstanceByTilePos(tilePos)
	if not instance then
		return
	end
	local farmUINode = self:getFarmUI(instance)
	if not farmUINode then
		farmUINode = fgui.UIPackage:createObject("ManorCity", "ManorFarmUI")
		farmUINode:setGroupID(GROUP_ID.QUEUE)
		farmUINode:setName("ManorFarmUI" .. data.id .. "_" .. data.iid)
		farmUINode:addTo(self.fields.Group_topTip)
	end
	farmUINode:setPosition(cc.p(instance:getPositionX() + farmUIOffset.x, instance:getPositionY() + farmUIOffset.y))
	farmUINode:initData(data, instance, isInVisit)
end
function Com_map:onMsgShowBanquetUI(target, event)
	local data = event.data
	local isInVisit = event.isInVisit
	local mapObj = event.data
	local tilePos = cc.p(mapObj.x, mapObj.y)
	local instance = self:getInstanceByTilePos(tilePos)
	if not instance then
		return
	end
	local banquetUINode = self:getBanquetUI(instance)
	if not banquetUINode then
		banquetUINode = fgui.UIPackage:createObject("ManorCity", "ManorBanquetUI")
		banquetUINode:setGroupID(GROUP_ID.QUEUE)
		banquetUINode:setName("ManorBanquetUI" .. data.id .. "_" .. data.iid)
		banquetUINode:addTo(self.fields.Group_topTip)
	end
	banquetUINode:setPosition(cc.p(instance:getPositionX() + banquetUIOffset.x, instance:getPositionY() + banquetUIOffset.y))
	banquetUINode:initData(data, instance, isInVisit)
end
function Com_map:getMapObjByBid(bid, iid)
	for __, mapObj in pairs(self.mapData) do
		if mapObj.id == bid and (iid == nil or mapObj.iid == iid) then
			return mapObj
		end
	end
	return nil
end
function Com_map:onMsgWateringAni(target, event)
	local iids = event.iids
	if not iids then
		return
	end
	for _, iid in ipairs(iids) do
		if not self.mapData then
			_ENV = self.mapData
		end
		for _, mapObj in pairs(self.mapData) do
			if mapObj.id == MANOR_BUILD_ID.FARM and mapObj.iid == iid then
				local instance = self:getInstanceByTilePos(cc.p(mapObj.x, mapObj.y))
				local farmUINode = self.fields.Group_topTip:getChild("ManorFarmUI" .. mapObj.id .. "_" .. iid)
				if farmUINode then
					farmUINode:showWateringAni()
				end
				if instance then
					instance:checkShowTopTip()
				end
			end
		end
	end
end
function Com_map:moveAllBuild(dir)
	self:checkEndEdit()
	local canMove = true
	for _, mapObj in pairs(self.mapData) do
		local instance = self:getInstanceByTilePos(cc.p(mapObj.x, mapObj.y))
		local _tilePos = cc.p(mapObj.x + dir.x, mapObj.y + dir.y)
		local size = instance:getHoldSize()
		if not self:checkTileRange(_tilePos, size) then
			canMove = false
			break
		end
	end
	if not canMove then
		SoraDShowMsgTip(i18n("Socialize_text_30"))
		return
	end
	for _, mapObj in pairs(self.mapData) do
		local instance = self:getInstanceByTilePos(cc.p(mapObj.x, mapObj.y))
		local _tilePos = cc.p(mapObj.x + dir.x, mapObj.y + dir.y)
		instance:setTilePos(_tilePos)
		mapObj.x = _tilePos.x
		mapObj.y = _tilePos.y
		instance:setInstanceData(mapObj)
		local size = instance:getHoldSize()
		local centerTilePos = self:getBuildCenterTilePos(_tilePos, size)
		local centerPos = self:getPointWithTile(centerTilePos)
		instance:setPosition(centerPos)
		mapObj._instance = instance
		self:removeInstanceTilesArray(instance)
	end
	local _ENV, ret = (for generator), pairs(self.mapData)
	for __, mapObj in pairs(self.mapData) do
		local realId = manorCityUtil.spliceRealId(mapObj.x, mapObj.y, mapObj.id, mapObj.iid)
		mapObj.realId = realId
		ret[realId] = mapObj
	end
	self.mapData = ret
	for _, mapObj in pairs(self.mapData) do
		local instance = mapObj._instance
		local tilePos = cc.p(mapObj.x, mapObj.y)
		local size = instance:getHoldSize()
		local tilesArray = instanceFactory.getTilesArrayByInstace(tilePos, size)
		for __, v in ipairs(tilesArray) do
			self.tileMap[v] = instance
		end
		instance:setTilesArray(tilesArray)
		mapObj._instance = nil
	end
end
function Com_map:setMoveModel(isMoveModel)
	self.isMoveModel = isMoveModel
	self.drawNode:setVisible(self.isMoveModel)
end
function Com_map:getMapData()
	return self.mapData
end
function Com_map:setDeleteModel(isDeleteModel)
	self.isDeleteModel = isDeleteModel
end
function Com_map:initInLayoutEdit()
	self.isInLayoutEdit = true
	self:initScrollPane()
	self:clearMapData()
end
function Com_map:initInLayoutPreview()
	self.isInLayoutPreview = true
	self:initScrollPane()
	self:clearMapData()
	_UPVALUE0_ = nil
	self:initVisitData(nil)
end
function Com_map:checkIsInLayoutModel()
	return self.isInLayoutEdit or self.isInLayoutPreview
end
function Com_map:checkEndEdit()
	if self.isInBuild or self.isInEdit then
		self:endEdit(self.isInBuild)
	end
end
function Com_map:onMsgGoToBuild(target, event)
	if self.isInLayoutPreview then
		return
	end
	if (event.isInLayoutEdit or false) ~= (self.isInLayoutEdit or false) then
		return
	end
	local mapObj = self:getMapObjByBid(event.buildID, event.iid)
	print("==Com_map:onMsgGoToBuild==", event.buildID, event.iid, mapObj)
	if not mapObj then
		return
	end
	local instance = self:getInstanceByTilePos(cc.p(mapObj.x, mapObj.y))
	if not instance then
		return
	end
	local tilePos = instance:getTilePos()
	local size = instance:getHoldSize()
	local centerTilePos = self:getBuildCenterTilePos(tilePos, size)
	self:scrollToTilePos(centerTilePos, true)
end
return Com_map
