local gametop = gModuleMgr.getObject("gametop")
local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
local mapSyncUtilClient = include("mapSyncUtilClient")
local worldMapViewMul = class("worldMapViewMul", function(target)
	return target
end)
local Z_ORDER = worldMapDefine.Z_ORDER
local Z_ORDER_CELL = worldMapDefine.Z_ORDER_CELL
local RECT_ZERO = cc.rect(0, 0, 0, 0)
local RECT_PERCENT = 0.75
local isSameMapRegion = function(kid1, kp1, kid2, kp2)
	local valid1 = kingdomCtrl:isFoundKingdomID(kid1)
	local valid2 = kingdomCtrl:isFoundKingdomID(kid2)
	if valid1 or valid2 then
		return valid1 and valid2 and kid1 == kid2
	end
	return kp1 and kp2 and kp1.x == kp2.x and kp1.y == kp2.y
end
function worldMapViewMul:ctor()
	self.isSingleMapCell = false
	self.isInSingle = false
	self.isMapCellTransposition = true
end
function worldMapViewMul:setLastMapRegion(mapViewCell)
	if not mapViewCell then
		self.lastMapRegionKid = nil
		self.lastMapRegionKp = nil
		return
	end
	local kp = mapViewCell:getKingdomPoint()
	self.lastMapRegionKid = mapViewCell:getKingdomID()
	self.lastMapRegionKp = kp and cc.p(kp.x, kp.y) or nil
end
function worldMapViewMul:initMapCell_imp()
	self.mapViewSwapPointArray, _ENV, self.mapViewPointArray, _ENV, self.mapViewCellArray, _ENV = nil, nil, nil, nil, nil, nil
	local scaleH = 3 + (display.height - 960) / 426 * 0.3
	self.containerViewSize = cc.size(self.mapViewSize.width * 2, self.mapViewSize.height * scaleH)
	local halfViewWidth, halfViewHeight = self.containerViewSize.width / 2, self.containerViewSize.height / 2
	self.mapViewPointArray[1] = cc.p(halfViewWidth, halfViewHeight + self.mapViewSize.height / 2)
	self.mapViewPointArray[2] = cc.p(halfViewWidth - self.mapViewSize.width / 2, halfViewHeight)
	self.mapViewPointArray[3] = cc.p(halfViewWidth, halfViewHeight - self.mapViewSize.height / 2)
	self.mapViewPointArray[4] = cc.p(halfViewWidth + self.mapViewSize.width / 2, halfViewHeight)
	self.mapViewSwapPointArray[1] = cc.p(halfViewWidth, halfViewHeight + self.mapViewSize.height * RECT_PERCENT)
	self.mapViewSwapPointArray[2] = cc.p(halfViewWidth - self.mapViewSize.width * RECT_PERCENT, halfViewHeight)
	self.mapViewSwapPointArray[3] = cc.p(halfViewWidth, halfViewHeight - self.mapViewSize.height * RECT_PERCENT)
	self.mapViewSwapPointArray[4] = cc.p(halfViewWidth + self.mapViewSize.width * RECT_PERCENT, halfViewHeight)
	for i = 1, #self.mapViewPointArray do
		local mapViewCell = self:createOneMapCell()
		mapViewCell:setName("mapViewCell" .. i)
		local mapViewCellPoint = self.mapViewPointArray[i]
		mapViewCell:setPosition(mapViewCellPoint)
		mapViewCell:setMapPointIndex(i)
		self.mapViewCellArray[i] = mapViewCell
	end
	local firstMapViewCell = self.mapViewCellArray[1]
	self.currentInMapViewCell = firstMapViewCell
	self:setLastMapRegion(firstMapViewCell)
	self.selfInMapView = firstMapViewCell
	self.containerView:setContentSize(self.containerViewSize)
	self:initColorLayer()
	self:setLightMapcell(self.currentInMapViewCell)
	self:setMapcellKingdomID(1)
	self:setLastMapRegion(self.currentInMapViewCell)
end
function worldMapViewMul:initColorLayer()
	local colorLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 128))
	colorLayer:setContentSize(self.containerViewSize)
	colorLayer:ignoreAnchorPointForPosition(false)
	colorLayer:setAnchorPoint(cc.p(0.5, 0.5))
	colorLayer:setPosition(cc.p(self.containerViewSize.width / 2, self.containerViewSize.height / 2))
	self.mapViewcliperNode = cc.ClippingNode:create()
	self.mapViewcliperNode:addChild(colorLayer)
	self.mapViewcliperNode:setInverted(true)
	self.mapViewcliperNode:addTo(self.containerView, Z_ORDER_CELL.objView)
	self.mapViewcliperNode:setName("mapViewcliperNode")
	_ENV = self.mapViewcliperNode.setName
	self.mapViewcliperNode.setName.fillColor = cc.c4f(1, 1, 1, 0.5)
	self.mapViewcliperNode.setName.borderColor = cc.c4f(0, 1, 0, 0)
	local _UPVALUE2_, _UPVALUE4_, self.mapViewcliperNode.setName.borderWidth, params = 0, cc.c4f(0, 1, 0, 0), 0, self.mapViewcliperNode.setName
	_UPVALUE2_, (0)[1] = -200, -200
	_UPVALUE2_, (0)[2] = -200, 0
	_UPVALUE2_, (-200)[1] = 0, 0
	_UPVALUE2_, (-200)[2] = 0, 100
	_UPVALUE2_, (0)[1] = 200, 200
	_UPVALUE2_, (0)[2] = 200, 0
	;(200)[1] = 0
	;(200)[2] = -100
	cc.c4f(0, 1, 0, 0)[1] = 0
	cc.c4f(0, 1, 0, 0)[2] = -200
	cc.c4f(0, 1, 0, 0)[3] = 0
	local cc.c4f(0, 1, 0, 0)[4], points = 200, cc.c4f(0, 1, 0, 0)
	local shapNode = display.newPolygon(points, params)
	shapNode:setName("shapNode")
	shapNode:setScale(self.mapViewSize.width / 400)
	shapNode:ignoreAnchorPointForPosition(false)
	shapNode:setAnchorPoint(cc.p(0.5, 0.5))
	self.mapViewcliperNode:setStencil(shapNode)
	self.shapNode = shapNode
end
function worldMapViewMul:getWorldMapCell(kingdomID, create)
	local worldMapCell
	kingdomID = kingdomID or gametop.playertop_:getMapID()
	for _, v in pairs(self.mapViewCellArray) do
		if kingdomID == v.kingdomID then
			worldMapCell = v
			break
		end
	end
	if not worldMapCell and create then
		self.preCenterPoint = nil
		worldMapCell = self.mapViewCellArray[1]
		worldMapCell:setKingdomID(kingdomID)
		self:setMapcellKingdomID(1)
		self.currentInMapViewCell = worldMapCell
		self.isMapCellTransposition = true
		self:onSwapMapViewCell()
	end
	return worldMapCell
end
function worldMapViewMul:updateCheckSetMapViewCellPoint()
	for _, mapViewCell in pairs(self.mapViewCellArray) do
		local tilePos = mapViewCell:tilePositionFromLocation(self.displayCenterPoint)
		if tilePos.x >= 0 and 0 <= tilePos.y then
			local kp1 = mapViewCell:getKingdomPoint()
			local kid1 = mapViewCell:getKingdomID()
			local isSameKingdom = isSameMapRegion(kid1, kp1, self.lastMapRegionKid, self.lastMapRegionKp)
			if not isSameKingdom or self.isMapCellTransposition then
				local isK = kingdomCtrl:isFoundKingdomID(mapViewCell.kingdomID)
				if isK then
					worldMapDefine.currentMapKindomID = mapViewCell.kingdomID
				else
					worldMapDefine.currentMapKindomID = 0
				end
				if not isSameKingdom then
					self:addEnterOtherWorldmapCellFilm()
				end
				self.isMapCellTransposition = false
				if self.isInSingle then
					self.currentInMapViewCell.currentShowRect = RECT_ZERO
				end
				self.preCenterPoint = nil
				self.currentInMapViewCell = mapViewCell
				self:setLastMapRegion(mapViewCell)
				self:onSwapMapViewCell()
			end
			break
		end
	end
	self:updateLightMapcell()
	local covertCenterPoint = self.containerView:convertToNodeSpace(self.displayCenterPoint)
	local isCenterPointInPolgon = SorDIsPointInPolygon(self.mapViewSwapPointArray, covertCenterPoint)
	if isCenterPointInPolgon or not self.currentInMapViewCell then
		return
	end
	self:swapCell()
	self:updateLightMapcell()
	if self.selfInMapView then
		print("自己所在王国的地图块序号：" .. self.selfInMapView.mapPointIndex)
	else
		print("自己所在的王国不在其中")
	end
end
function worldMapViewMul:updateLightMapcell()
	local selfInMapView
	for _, mapViewCell in pairs(self.mapViewCellArray) do
		if self.myKindomID == mapViewCell.kingdomID then
			selfInMapView = mapViewCell
			mapViewCell:setLocalZOrder(Z_ORDER.containerViewSelf)
		else
			mapViewCell:setLocalZOrder(Z_ORDER.containerView)
		end
	end
	if self.selfInMapView ~= selfInMapView then
		self.selfInMapView = selfInMapView
	end
	self:setLightMapcell(self.currentInMapViewCell)
	self:updateBorderPosition()
end
function worldMapViewMul:setLightMapcell(mapViewCell)
	if mapViewCell then
		self.shapNode:setVisible(true)
		local posx, posy = mapViewCell:getPosition()
		local posViewX, posViewY = self.mapViewcliperNode:getPosition()
		self.shapNode:setPosition(cc.p((posx - posViewX) * 1.0, (posy - posViewY) * 1.0))
	else
		self.shapNode:setVisible(false)
	end
end
function worldMapViewMul:addEnterOtherWorldmapCellFilm()
	local addFilmAction = function()
		local _ENV, actionsArray
		actionsArray[#actionsArray + 1] = cc.DelayTime:create(2.0)
		actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
			self.enterKindomFilmNode:removeFromParent()
			self.enterKindomFilmNode = nil
		end)
		local actions = transition.sequence(actionsArray)
		if self.enterKindomFilmNode then
			self.enterKindomFilmNode:stopAllActions()
			self.enterKindomFilmNode:runAction(actions)
		end
	end
	local castleStyleID = 1
	local kingdomName = i18n("common_text_479") .. "#0"
	local isK, kingdomInfo = kingdomCtrl:isFoundKingdomID(worldMapDefine.currentMapKindomID)
	if isK then
		castleStyleID = kingdomInfo.palaceMode
		kingdomName = kingdomInfo.kname
	end
	local filmNode = worldMapFunction.moveKingdomAnimation(castleStyleID, kingdomName, self.enterKindomFilmNode)
	if self.enterKindomFilmNode then
		addFilmAction()
		return
	end
	filmNode:setPosition(cc.p(display.cx, display.cy))
	filmNode:addTo(self, Z_ORDER.otherTipView)
	self.enterKindomFilmNode = filmNode
	addFilmAction()
end
function worldMapViewMul:swapCell()
	local tilePoint = self.currentInMapViewCell:tilePositionFromLocation(self.displayCenterPoint)
	local SPLIT_POS = 300
	if self.currentInMapViewCell.mapPointIndex == 1 then
		if SPLIT_POS > tilePoint.x and SPLIT_POS > tilePoint.y then
			self:mapViewCellTransposition(1, 3)
		elseif SPLIT_POS > tilePoint.x and SPLIT_POS <= tilePoint.y then
			self:mapViewCellTransposition(1, 4)
		elseif SPLIT_POS <= tilePoint.x and SPLIT_POS > tilePoint.y then
			self:mapViewCellTransposition(1, 2)
		elseif not (SPLIT_POS <= tilePoint.x) or SPLIT_POS <= tilePoint.y then
		end
	elseif self.currentInMapViewCell.mapPointIndex == 2 then
		if SPLIT_POS > tilePoint.x and SPLIT_POS > tilePoint.y then
			self:mapViewCellTransposition(2, 3)
		elseif SPLIT_POS > tilePoint.x and SPLIT_POS <= tilePoint.y then
			self:mapViewCellTransposition(2, 4)
		elseif SPLIT_POS <= tilePoint.x and SPLIT_POS > tilePoint.y then
		elseif SPLIT_POS <= tilePoint.x and SPLIT_POS <= tilePoint.y then
			self:mapViewCellTransposition(2, 1)
		end
	elseif self.currentInMapViewCell.mapPointIndex == 3 then
		if SPLIT_POS > tilePoint.x and SPLIT_POS > tilePoint.y then
		elseif SPLIT_POS > tilePoint.x and SPLIT_POS <= tilePoint.y then
			self:mapViewCellTransposition(3, 4)
		elseif SPLIT_POS <= tilePoint.x and SPLIT_POS > tilePoint.y then
			self:mapViewCellTransposition(3, 2)
		elseif SPLIT_POS <= tilePoint.x and SPLIT_POS <= tilePoint.y then
			self:mapViewCellTransposition(3, 1)
		end
	elseif self.currentInMapViewCell.mapPointIndex == 4 then
		if SPLIT_POS > tilePoint.x and SPLIT_POS > tilePoint.y then
			self:mapViewCellTransposition(4, 3)
		elseif SPLIT_POS > tilePoint.x and SPLIT_POS <= tilePoint.y then
		elseif SPLIT_POS <= tilePoint.x and SPLIT_POS > tilePoint.y then
			self:mapViewCellTransposition(4, 2)
		elseif SPLIT_POS <= tilePoint.x and SPLIT_POS <= tilePoint.y then
			self:mapViewCellTransposition(4, 1)
		end
	end
end
function worldMapViewMul:mapViewCellTransposition(fromIndex, toIndex)
	print("互换位置：", fromIndex .. "," .. toIndex)
	self.preCenterPoint = nil
	local mapCovertPoint = self.currentInMapViewCell:convertToNodeSpace(self.displayCenterPoint)
	local tempMapViewCell = self.mapViewCellArray[fromIndex]
	self.mapViewCellArray[fromIndex] = self.mapViewCellArray[toIndex]
	self.mapViewCellArray[toIndex] = tempMapViewCell
	self.mapViewCellArray[fromIndex].mapPointIndex = fromIndex
	self.mapViewCellArray[toIndex].mapPointIndex = toIndex
	self.mapViewCellArray[fromIndex]:setPosition(self.mapViewPointArray[fromIndex])
	self.mapViewCellArray[toIndex]:setPosition(self.mapViewPointArray[toIndex])
	self:setMapcellKingdomID(toIndex)
	self:onSwitchMapViewCell()
	local scrollViewPoint = SoraDCoverToPoint2DOr3D(self.currentInMapViewCell, mapCovertPoint, self.containerView)
	self:moveMapPointToCenter(scrollViewPoint, 0, true)
end
function worldMapViewMul:setMapcellKingdomID(cellIndex)
	local mapCell = self.mapViewCellArray[cellIndex]
	local cellKingdomPoint = mapCell:getKingdomPoint()
	local cellKingdomID = mapCell:getKingdomID()
	local cellRegionId = mapCell:getRegionId()
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local cellRegionType = nebulaActivityCtrl:getRegionTypeByRegionId(cellRegionId)
	_ENV, _ENV = cellRegionId, nebulaActivityCtrl
	cellRegionId[2] = cc.p(0, -1)
	cellRegionId[3] = cc.p(1, -1)
	_ENV, nebulaActivityCtrl[1], cellRegionId[4] = cellRegionId, cellRegionId, cc.p(1, 0)
	cellRegionId[1] = cc.p(0, 1)
	cellRegionId[4] = cc.p(1, 1)
	_ENV, nebulaActivityCtrl[2], cellRegionId[3] = cellRegionId, cellRegionId, cc.p(1, 0)
	cellRegionId[2] = cc.p(-1, 0)
	cellRegionId[1] = cc.p(-1, 1)
	_ENV, nebulaActivityCtrl[3], cellRegionId[4] = cellRegionId, cellRegionId, cc.p(0, 1)
	cellRegionId[1] = cc.p(-1, 0)
	cellRegionId[2] = cc.p(-1, -1)
	nebulaActivityCtrl[4], cellRegionId[3] = cellRegionId, cc.p(0, -1)
	local config = nebulaActivityCtrl
	for k, v in pairs(config[cellIndex]) do
		local kingdomPoint = cc.p(cellKingdomPoint.x + v.x, cellKingdomPoint.y + v.y)
		local kingdomID = kingdomPointDefine.getKingdomIDWithPoint(kingdomPoint, cellRegionId)
		self.mapViewCellArray[k]:setKingdomID(kingdomID, kingdomPoint, cellRegionId)
	end
end
local LODKEEP = worldMapDefine.worldLodDef.LOD4
function worldMapViewMul:getMapTilesData_imp()
	local reqcenterTilePos = self.reqcenterTilePos
	local kid = self.currentInMapViewCell.kingdomID
	local sendMsg
	local lod = self:getCurLod()
	local isInSingle
	if lod >= LODKEEP then
		isInSingle = true
	else
		isInSingle = mapSyncUtilClient.isViewInSingleMap(reqcenterTilePos, self.mapClassType)
	end
	if isInSingle then
		if not self.isInSingle then
			for _, mapViewCell in pairs(self.mapViewCellArray) do
				mapViewCell.currentShowRect = RECT_ZERO
			end
			self.isInSingle = true
		end
		sendMsg = mapSyncUtilClient.reqMapSync(self, kid, reqcenterTilePos, false, self.mapClassType, lod)
		self.currentInMapViewCell.currentShowRect = mapSyncUtilClient.getViewRect(reqcenterTilePos, self.mapClassType, lod)
	else
		if self.isInSingle then
			self.isInSingle = false
		end
		local LODKEEP, kidList = self.isInSingle, self.isInSingle
		for i, mapViewCell in ipairs(self.mapViewCellArray) do
			local _kid = mapViewCell.kingdomID
			if _kid ~= 0 then
				kidList[i] = _kid
			else
				kidList[i] = -i
			end
			if kid == 0 and mapViewCell == self.currentInMapViewCell then
				kid = -i
			end
		end
		local kid1, kid2, kid3, kid4 = kidList[1], kidList[2], kidList[3], kidList[4]
		sendMsg = mapSyncUtilClient.reqMapSyncBorder(self, kid, reqcenterTilePos, kid1, kid2, kid3, kid4, self.mapClassType, lod)
		local rectBorder = mapSyncUtilClient.getViewRectBorder(kid, reqcenterTilePos, kid1, kid2, kid3, kid4, self.mapClassType, lod)
		for i, mapViewCell in ipairs(self.mapViewCellArray) do
			local kingdomID = mapViewCell.kingdomID
			if kingdomID == 0 then
				kingdomID = -i
			end
			local showRect = rectBorder[kingdomID]
			if showRect then
				mapViewCell.currentShowRect = showRect
			else
				mapViewCell.currentShowRect = RECT_ZERO
			end
		end
	end
	return sendMsg
end
function worldMapViewMul:scrollFromBorder()
end
return worldMapViewMul
