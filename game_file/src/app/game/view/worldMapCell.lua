local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local worldMapDefine = include("worldMapDefine")
local worldMapCell = class("worldMapCell", function(mapView)
	local view = ccui.Layout:create()
	return view
end)
local Z_ORDER = worldMapDefine.Z_ORDER
local Z_ORDER_CELL = worldMapDefine.Z_ORDER_CELL
local GROU_ID = worldMapDefine.GROU_ID
function worldMapCell:ctor(mapView)
	self.mapPointIndex = 0
	self.groupIndex = 0
	self.kingdomPoint = cc.p(0, 0)
	self.kingdomID = 0
	self.myKindomID = gametop.playertop_:getMapID()
	self.myPlayerID = gametop.playertop_:getPlayerID()
	self.myPlayerName = lordInfoCtrl:getBaseInfo().nickName
	self.isTransfering = false
	self.transferTilesArray, _ENV, self.transferView = lordInfoCtrl:getBaseInfo().nickName, lordInfoCtrl:getBaseInfo().nickName, nil
	self.currentShowRect = cc.rect(0, 0, 0, 0)
	self.mapViewSize = mapView.mapViewSize
	self.mapSize = mapView.mapSize
	self.tileSize = mapView.tileSize
	self.mapLayer = mapView.mapLayer
	self.groundLayer = mapView.groundLayer
	self.groundLayer_marsh = mapView.groundLayer_marsh
	if self.groundLayer_marsh then
		self.groundLayer_marsh:setGroupID(GROU_ID.group_build_gate)
	end
	self.isSingleMapCell = mapView.isSingleMapCell
	self.touchPlayerCallFun = nil
	self.mapClassType = mapView.mapClassType
	self:setTouchEnabled(true)
	self:ignoreAnchorPointForPosition(false)
	self:setAnchorPoint(cc.p(0.5, 0.5))
	self:setContentSize(self.mapViewSize)
	self:setSwallowTouches(false)
	self:addTouchEventListener(function(touchlayer, type, pos)
		self:viewOnClick(touchlayer, type, pos)
	end)
	self:setTouchChildrenEnabled(false)
	self.cacheLeagueManorNodes, self.setTouchChildrenEnabled[2], _ENV, self.setTouchChildrenEnabled[1], _ENV, _ENV = self.setTouchChildrenEnabled, self, self, self, self, self.setTouchChildrenEnabled
end
function worldMapCell:setMapPointIndex(mapPointIndex)
	self.mapPointIndex = mapPointIndex
end
function worldMapCell:setTouchPlayerCallFun(callFunc)
	self.touchPlayerCallFun = callFunc
end
function worldMapCell:viewOnClick(touchlayer, type, pos)
	local _ENV, pointArray
	pointArray[1] = cc.p(0, self.mapViewSize.height / 2)
	pointArray[2] = cc.p(self.mapViewSize.width / 2, self.mapViewSize.height)
	pointArray[3] = cc.p(self.mapViewSize.width, self.mapViewSize.height / 2)
	pointArray[4] = cc.p(self.mapViewSize.width / 2, 0)
	local touchPoint = pos or self:getTouchBeganPosition()
	local covertPoint
	if gEnableWorldMap3D then
		covertPoint = SoraConvertTouchToNodeSpace3D(self, touchPoint)
	else
		covertPoint = self:convertToNodeSpace(touchPoint)
	end
	local isTouchIn = SorDIsPointInPolygon(pointArray, covertPoint)
	if isTouchIn and self.touchPlayerCallFun then
		if gEnableWorldMap3D and type == ccui.TouchEventType.ended and self.drawNode then
			self.drawNode:setPosition(covertPoint)
			self.drawNode:setVisible(true)
		end
		self.touchPlayerCallFun(self, type, pos)
	elseif self.isSingleMapCell then
		_ENV = self
		self.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(self)
	end
end
function worldMapCell:setKingdomID(kid, kingdomPoint, regionId)
	self.kingdomID = kid
	kingdomPoint = kingdomPoint or kingdomPointDefine.getKingdomPointWithID(self.kingdomID)
	if kingdomPoint then
		self.kingdomPoint = kingdomPoint
	end
	if not regionId then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local rType, rId = nebulaActivityCtrl:getKingdomRegionType(kid)
		regionId = rId
	end
	if regionId then
		self.regionId = regionId
	end
end
function worldMapCell:getKingdomID(...)
	return self.kingdomID
end
function worldMapCell:getKingdomPoint(...)
	return self.kingdomPoint
end
function worldMapCell:getRegionId(...)
	return self.regionId
end
function worldMapCell:tilePositionFromLocation(location, outSize)
	local pos
	if gEnableWorldMap3D then
		pos = SoraConvertTouchToNodeSpace3D(self, location)
	else
		pos = self:convertToNodeSpace(location)
	end
	local halfMapWidth = self.mapSize.width * 0.5
	local mapWidth = self.mapSize.width
	local mapHeight = self.mapSize.height
	local tileWidth = self.tileSize.width
	local tileHeight = self.tileSize.height
	local tilePosDiv = cc.p(pos.x / tileWidth, pos.y / tileHeight)
	local inverseTileY = mapHeight - tilePosDiv.y
	local posX = math.floor(inverseTileY + tilePosDiv.x - halfMapWidth)
	local posY = math.floor(inverseTileY - tilePosDiv.x + halfMapWidth)
	local ret
	if not outSize then
		if posX < 0 or posX > mapWidth - 1 or posY < 0 or posY > mapHeight - 1 then
			ret = cc.p(-1, -1)
		else
			ret = cc.p(posX, posY)
		end
	else
		if posX < 0 then
			posX = 0
		elseif posX > mapWidth - 1 then
			posX = mapWidth - 1
		end
		if posY < 0 then
			posY = 0
		elseif posY > mapHeight - 1 then
			posY = mapHeight - 1
		end
		ret = cc.p(posX, posY)
	end
	return ret
end
function worldMapCell:getPointWithTile(tilePoint, holdInstace)
	local tileWidth = self.tileSize.width
	local tileHeight = self.tileSize.height
	local point = self.mapLayer:getPositionAt(tilePoint)
	holdInstace = holdInstace or 1
	point.x = point.x + tileWidth / 2
	point.y = point.y + (2 - holdInstace) * tileHeight / 2
	return point
end
function worldMapCell:onClickMap(tileInstance, tilePos, onShowView)
	local isCanZhanling = true
	local isCanQiancheng = true
	local favoriteName = i18n("common_text_491")
	local tileGID = self.mapLayer:getTileGIDAt(tilePos)
	local groundGID = self.groundLayer:getTileGIDAt(tilePos)
	local soundID = 8
	local msgTipsKey
	if not worldMapDefine.isInNebula() and not worldMapDefine.isInNebulaEmperor() then
		if 5 <= tileGID and tileGID <= 23 then
			favoriteName = i18n("common_text_495")
			isCanZhanling = false
			soundID = 9
		elseif 62 <= tileGID and tileGID <= 70 then
			favoriteName = i18n("common_text_514")
			isCanZhanling = false
		elseif 71 <= tileGID and tileGID <= 79 then
			favoriteName = i18n("common_text_515")
			isCanZhanling = false
		elseif 99 <= groundGID and groundGID <= 111 then
			favoriteName = i18n("common_text_493")
			isCanZhanling = false
			soundID = 10
		elseif self.groundLayer_marsh then
			groundGID = self.groundLayer_marsh:getTileGIDAt(tilePos)
			if 0 < groundGID then
				favoriteName = i18n("brightWar_build_08")
				isCanZhanling = false
				soundID = 10
			end
		end
	end
	SoraDPlaySound("worldmap", soundID)
	local showPoint = self:getPointWithTile(tilePos)
	local screenPoint = SoraDConvertoScreenPos2DOr3D(self, showPoint)
	local coverShowPoint = onShowView:convertToNodeSpace(screenPoint)
	local selectShowPanel = include("worldMapTip").new(self.kingdomID)
	selectShowPanel:setTilePoint(tilePos)
	selectShowPanel:setWorldMapCell(self)
	selectShowPanel:setFavoriteName(favoriteName)
	if worldMapDefine.isInRemains() then
		local remainsWarUtil = include("remainsWarUtil")
		isCanZhanling = not remainsWarUtil.checkIsInForbidAreaZhanling(tilePos)
	elseif isCanZhanling and worldMapDefine.isInRadiance() then
		local radianceWarUtil = include("radianceWarUtil")
		isCanZhanling = radianceWarUtil.isInSelfLeagueManor(tilePos)
		if not isCanZhanling then
			function msgTipsKey()
				radianceWarUtil.showGuildToBuild(tilePos)
			end
		end
	elseif isCanZhanling and worldMapDefine.isInNebula() then
		local nebulaWarUtil = include("nebulaWarUtil")
		isCanZhanling, msgTipsKey = nebulaWarUtil.checkIsCanZhanling(tilePos)
	elseif isCanZhanling and worldMapDefine.isInNebulaEmperor() then
		local nebulaEmperorUtil = include("nebulaEmperorUtil")
		isCanZhanling, msgTipsKey = nebulaEmperorUtil.checkIsCanZhanling(tilePos)
	elseif isCanZhanling and worldMapDefine.isInNebulaAllStar() then
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		isCanZhanling, msgTipsKey = nebulaAllStarUtil.checkIsCanZhanling(tilePos)
	end
	if not isCanZhanling and not msgTipsKey then
		msgTipsKey = i18n("common_text_485")
	end
	print(isCanZhanling, "isCanZhanling")
	selectShowPanel:setIsCanZhanling(isCanZhanling, msgTipsKey)
	selectShowPanel:initMapData(tileInstance)
	selectShowPanel:setPosition(coverShowPoint)
	selectShowPanel:addTo(onShowView, Z_ORDER.selectView)
	return selectShowPanel
end
function worldMapCell:onClickInstance(tilePos, tileInstance, onShowView, onShowViewNode)
	if not tilePos then
		return
	end
	local showRolygon = true
	local rolygonScale = 1.0
	local selectShowPanel, selectTileRolygon, selectTilesRolygon, coverShowPoint
	if not tileInstance then
		if worldMapDefine.isInNewTrial() then
			return
		end
		local showPoint = self:getPointWithTile(tilePos)
		coverShowPoint = SoraDCoverToPoint2DOr3D(self, showPoint, onShowView)
		selectShowPanel = self:onClickMap(tileInstance, tilePos, onShowViewNode)
	else
		local x, y = tileInstance:getPosition()
		local showPoint = cc.p(x, y)
		coverShowPoint = SoraDCoverToPoint2DOr3D(self, showPoint, onShowView)
		rolygonScale = tileInstance:getHoldInstace() or 1
		rolygonScale = math.min(rolygonScale, 4)
		selectShowPanel, showRolygon, selectTilesRolygon = tileInstance:onClickInstance(onShowViewNode)
		if selectTilesRolygon then
			selectTilesRolygon:setPosition(coverShowPoint)
			onShowView:addChild(selectTilesRolygon, Z_ORDER.selectBgView)
		end
	end
	if showRolygon then
		local tileRolygon = include("worldMapTileRolygon").new()
		tileRolygon:setPosition(coverShowPoint)
		tileRolygon:setScale(rolygonScale)
		onShowView:addChild(tileRolygon, Z_ORDER.selectBgView)
		selectTileRolygon = tileRolygon
	end
	worldMapDefine = tileRolygon
	include("worldMapTileRolygon").new().selectShowPanel = selectShowPanel
	include("worldMapTileRolygon").new().selectTileRolygon = selectTileRolygon
	include("worldMapTileRolygon").new().selectTilesRolygon = selectTilesRolygon
	return (include("worldMapTileRolygon").new())
end
function worldMapCell:mergePolygonAndDraw(rectangleData, activityStatus, lineColor, onShowView, offset, isDisableCpp, isDisablePerlin, lineImage, disCross)
	if activityStatus == nil then
		activityStatus = true
	end
	if lineColor == nil then
		lineColor = cc.c3b(255, 255, 255)
	end
	dump(rectangleData, "第一步：绘制矩形初始化数据", 10)
	local RecognizeOutline = include("RecognizeOutline")
	local recognize = RecognizeOutline.new()
	local outlines = recognize:GetOutline(rectangleData)
	dump(outlines, "第二步：合并后的多边形数组", 10)
	local offsetPoint = offset or 0.42
	local j = 1
	local _ENV, pointsArrayAll = "第二步：合并后的多边形数组", "第二步：合并后的多边形数组"
	for k, w in ipairs(outlines) do
		local _ENV, pointsArray
		local _ENV, pointsRoundArraryAll
		for i, v in ipairs(w) do
			if j == 1 then
				local _ENV, point
				pointsArray[#pointsArray + 1] = point
			end
			local point = pointsArray[#pointsArray]
			point[j] = v
			if j == 2 then
				local pointX = math.round(point[1])
				local pointY = math.round(point[2])
				local swapIndex = 0
				for index, point in ipairs(pointsRoundArraryAll) do
					if point.x == pointX and point.y == pointY then
						swapIndex = index
						break
					end
				end
				pointsRoundArraryAll[#pointsRoundArraryAll + 1] = cc.p(pointX, pointY)
				if pointX < 0 then
					pointX = 0
				end
				if 1201 < pointX then
					pointX = 1201
				end
				if pointY < 0 then
					pointY = 0
				end
				if 1201 < pointY then
					pointY = 1201
				end
				if pointX < point[1] and pointY < point[2] then
					pointX = pointX - 1.0 + offsetPoint
					pointY = pointY - 1.0 + offsetPoint
				elseif pointX < point[1] and pointY > point[2] then
					pointX = pointX - 1.0 + offsetPoint
					pointY = pointY - offsetPoint
				elseif pointX > point[1] and pointY > point[2] then
					pointX = pointX - offsetPoint
					pointY = pointY - offsetPoint
				elseif pointX > point[1] and pointY < point[2] then
					pointX = pointX - offsetPoint
					pointY = pointY - 1.0 + offsetPoint
				end
				local showPoint = self:getPointWithTile(cc.p(pointX, pointY))
				local worldPoint = SoraDCoverToPoint2DOr3D(self, showPoint, onShowView)
				pointsArray[#pointsArray] = worldPoint
				if 0 < swapIndex then
					local midPoint = cc.pMidpoint(pointsArray[swapIndex], worldPoint)
					pointsArray[swapIndex] = midPoint
					pointsArray[#pointsArray] = midPoint
				end
			end
			j = j + 1
			if 2 < j then
				j = 1
			end
		end
		pointsArrayAll[k] = pointsArray
	end
	local _ENV, manorLineArrary = (for generator), ipairs(outlines)
	for k, pointsArray in ipairs(pointsArrayAll) do
		local cacheType = 1
		if not activityStatus then
			cacheType = 2
		end
		local glLineNode, isFromCache = self:getLeagueManorNode(cacheType)
		local firstPoint = pointsArray[1]
		glLineNode:setPosition(firstPoint)
		glLineNode:setContentSize(cc.size(0, 0))
		if not isFromCache then
			glLineNode:addTo(onShowView, Z_ORDER.rolygonView)
		end
		glLineNode.cacheType = cacheType
		for i, point in ipairs(pointsArray) do
			pointsArray[i] = SoraDCoverToPoint2DOr3D(onShowView, point, glLineNode)
			pointsArray[i].x, pointsArray[i].y = math.floor(pointsArray[i].x + 0.5), math.floor(pointsArray[i].y + 0.5)
		end
		if not lineImage then
			lineImage = "SinglePicture/leagueLine1.png"
			if not activityStatus then
				lineImage = "SinglePicture/leagueLine2.png"
			end
		end
		if not isFromCache then
			_ENV = ipairs(pointsArray)
			ipairs(pointsArray).meshNode = glLineNode
			ipairs(pointsArray).color = lineColor
			ipairs(pointsArray).posArray = pointsArray
			SoraDCreateCurveNode(lineImage, ipairs(pointsArray))
		else
			print("从缓存获取--------")
			_ENV = ipairs(pointsArray)
			ipairs(pointsArray).color = lineColor
			ipairs(pointsArray).posArray = pointsArray
			glLineNode:updateData(ipairs(pointsArray))
		end
		table.insert(manorLineArrary, glLineNode)
	end
	return manorLineArrary
end
function worldMapCell:checkVisibleByPos(pos)
	if not self.currentShowRect or not cc.rectContainsPoint(self.currentShowRect, pos) then
		return false
	end
	return true
end
function worldMapCell:doThrowAction(target, endPoint)
	local x, y = target:getPosition()
	local beginPoint = cc.p(x, y)
	worldMapFunction.createThrowAction(target, beginPoint, endPoint)
end
function worldMapCell:removeTiledMap(tilesArray)
	if not self.groundLayer.setupTileAt then
		return
	end
	for _, v in pairs(tilesArray) do
		local tilePoint = SoraDStringSplit(v, ",")
		local tilePos = cc.p(tilePoint[1], tilePoint[2])
		local tileGID = self.groundLayer:getTileGIDAt(tilePos)
		if 0 < tileGID then
			tileGID = tileGID * -1
			self.groundLayer:setupTileAt(tileGID, tilePos)
		end
	end
end
function worldMapCell:recoverTiledMap(tilesArray)
	if not self.groundLayer.setupTileAt then
		return
	end
	for _, v in pairs(tilesArray) do
		local tilePoint = SoraDStringSplit(v, ",")
		local tilePos = cc.p(tilePoint[1], tilePoint[2])
		local tileGID = self.groundLayer:getTileGIDAt(tilePos)
		if tileGID < 0 then
			tileGID = tileGID * -1
			self.groundLayer:setupTileAt(tileGID, tilePos)
		end
	end
end
function worldMapCell:addToCache(glNode, cacheType)
	if self.cacheLeagueManorNodes[cacheType] then
		glNode:setVisible(false)
		table.insert(self.cacheLeagueManorNodes[cacheType], glNode)
	end
end
function worldMapCell:createLeagueManorNode()
	local glLineNode = gl.meshNodeCreate()
	glLineNode.worldMapCell = self
	return glLineNode
end
function worldMapCell:getLeagueManorNodeFromCache(cacheType)
	local cache = self.cacheLeagueManorNodes[cacheType]
	if not cache or #cache <= 0 then
		return nil
	end
	local glNode = table.remove(cache)
	glNode:setVisible(true)
	return glNode
end
function worldMapCell:getLeagueManorNode(cacheType)
	local isFromCache = false
	local glNode = self:getLeagueManorNodeFromCache(cacheType)
	if glNode then
		isFromCache = true
	end
	glNode = glNode or self:createLeagueManorNode()
	return glNode, isFromCache
end
function worldMapCell:addShowBonePoing_imp(node, img, pos, scale, offset)
	local spPoint = display.newSprite(img)
	local instancePoint
	if offset then
		local point = self:getPointWithTile(pos)
		instancePoint = cc.p(point.x + offset.x, point.y + offset.y)
	else
		local tileWidth = self.tileSize.width
		local point = self.mapLayer:getPositionAt(pos)
		instancePoint = cc.p(point.x + tileWidth / 2, point.y)
	end
	spPoint:setPosition(instancePoint)
	if scale then
		spPoint:setScale(scale)
	end
	spPoint:addTo(node, 1)
end
function worldMapCell:addShowBonePoing(mapClassType)
	local node = display.newNode()
	node:addTo(self)
	node:setGroupID(worldMapDefine.GROU_ID.group_particle_bg)
	node:setGroupAuto(true)
	if mapClassType == gKingdomClassType.remains then
		for _, camp in ipairs(_G.RW_PLAYER_CAMP_POS) do
			for _, pos in ipairs(camp) do
				self:addShowBonePoing_imp(node, "#res_tile.png", cc.p(pos[1] - 1, pos[2] - 1), 2.0)
			end
		end
		for _, pos in ipairs(_G.RW_WAR_REVIVAL_POS) do
			self:addShowBonePoing_imp(node, "#map_ruins_revival.png", cc.p(pos[1], pos[2]), 1.0)
		end
	elseif mapClassType == gKingdomClassType.newTrial then
		local devilValleyltCtrl = include("devilValleyltCtrl")
		local dataPlayer = devilValleyltCtrl.getWarPlayer()
		for _, pos in pairs(dataPlayer) do
			self:addShowBonePoing_imp(node, "#res_tile.png", cc.p(pos.x, pos.y), 2.0)
		end
	elseif mapClassType == gKingdomClassType.radiance then
		node:setGroupID(worldMapDefine.GROU_ID.buildRadiance)
		_ENV, _UPVALUE14_ = node, node.setGroupID
		node.img = "#Map_build_radiance_rampart_01.png"
		node.x = 209
		node.y = 1008
		node.offsetX = 29.72
		_ENV, node.offsetY = worldMapDefine.GROU_ID.buildRadiance, -9.43
		worldMapDefine.GROU_ID.buildRadiance.img = "#Map_build_radiance_rampart_02.png"
		worldMapDefine.GROU_ID.buildRadiance.x = 991
		worldMapDefine.GROU_ID.buildRadiance.y = 1008
		worldMapDefine.GROU_ID.buildRadiance.offsetX = 17.29
		_ENV, worldMapDefine.GROU_ID.buildRadiance.offsetY = pairs(dataPlayer)
		pairs(dataPlayer).img = "#Map_build_radiance_rampart_03.png"
		pairs(dataPlayer).x = 991
		pairs(dataPlayer).y = 192
		pairs(dataPlayer).offsetX = 19.35
		_ENV, pairs(dataPlayer).offsetY = pairs(dataPlayer)
		pairs(dataPlayer).img = "#Map_build_radiance_rampart_04.png"
		pairs(dataPlayer).x = 209
		pairs(dataPlayer).y = 192
		pairs(dataPlayer).offsetX = 23.45
		_ENV, pairs(dataPlayer).offsetY = self.addShowBonePoing_imp, -6.17
		self.addShowBonePoing_imp.img = "#Map_build_radiance_rampart_01.png"
		self.addShowBonePoing_imp.x = 452
		self.addShowBonePoing_imp.y = 743
		self.addShowBonePoing_imp.offsetX = 29.72
		_ENV, self.addShowBonePoing_imp.offsetY = self, -9.43
		self.img = "#Map_build_radiance_rampart_02.png"
		self.x = 748
		self.y = 743
		self.offsetX = 17.29
		_ENV, self.offsetY = self.addShowBonePoing_imp, -6.33
		self.addShowBonePoing_imp.img = "#Map_build_radiance_rampart_03.png"
		self.addShowBonePoing_imp.x = 748
		self.addShowBonePoing_imp.y = 457
		self.addShowBonePoing_imp.offsetX = 19.35
		_ENV, self.addShowBonePoing_imp.offsetY = self, -8.44
		self.img = "#Map_build_radiance_rampart_04.png"
		self.x = 452
		self.y = 457
		self.offsetX = 23.45
		_ENV, self.offsetY = node, -6.17
		node.img = "#Map_build_radiance_rampart_07.png"
		node.x = 209
		node.y = 600
		node.offsetX = 21.21
		_ENV, node.offsetY = "#res_tile.png", -9.59
		;("#res_tile.png").img = "#Map_build_radiance_rampart_07.png"
		;("#res_tile.png").x = 991
		;("#res_tile.png").y = 600
		;("#res_tile.png").offsetX = 21.21
		_ENV, ("#res_tile.png").offsetY = cc.p(pos.x, pos.y), -9.59
		cc.p(pos.x, pos.y).img = "#Map_build_radiance_rampart_09.png"
		cc.p(pos.x, pos.y).x = 452
		cc.p(pos.x, pos.y).y = 600
		cc.p(pos.x, pos.y).offsetX = 33.11
		_ENV, cc.p(pos.x, pos.y).offsetY = 2.0, -4.8
		;(2.0).img = "#Map_build_radiance_rampart_10.png"
		;(2.0).x = 600
		;(2.0).y = 1008
		;(2.0).offsetX = 22.02
		_ENV, (2.0).offsetY = pos.y, -19.68
		pos.y.img = "#Map_build_radiance_rampart_11.png"
		pos.y.x = 748
		pos.y.y = 600
		pos.y.offsetX = 20.7
		_ENV, pos.y.offsetY = cc.p(pos[1] - 1, pos[2] - 1), -21.03
		cc.p(pos[1] - 1, pos[2] - 1).img = "#Map_build_radiance_rampart_12.png"
		cc.p(pos[1] - 1, pos[2] - 1).x = 600
		cc.p(pos[1] - 1, pos[2] - 1).y = 192
		cc.p(pos[1] - 1, pos[2] - 1).offsetX = 30.68
		cc.p(pos[1] - 1, pos[2] - 1).offsetY = -17.67
		node.setGroupID[1] = node
		node.setGroupID[2] = worldMapDefine.GROU_ID.buildRadiance
		node.setGroupID[3] = pairs(dataPlayer)
		node.setGroupID[4] = pairs(dataPlayer)
		node.setGroupID[5] = self.addShowBonePoing_imp
		node.setGroupID[6] = self
		node.setGroupID[7] = self.addShowBonePoing_imp
		node.setGroupID[8] = self
		node.setGroupID[9] = node
		node.setGroupID[10] = "#res_tile.png"
		node.setGroupID[11] = cc.p(pos.x, pos.y)
		node.setGroupID[12] = 2.0
		node.setGroupID[13] = pos.y
		local node.setGroupID[14], rampart = cc.p(pos[1] - 1, pos[2] - 1), node.setGroupID
		for _, pos in pairs(rampart) do
			self:addShowBonePoing_imp(node, pos.img, cc.p(pos.x, pos.y), 1.0, cc.p(pos.offsetX, pos.offsetY))
		end
	end
end
return worldMapCell
