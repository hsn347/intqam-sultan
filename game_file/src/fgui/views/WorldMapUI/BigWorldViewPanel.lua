local gametop = gModuleMgr.getObject("gametop")
local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
local kingdomNode = include("kingdomNode")
local palaceInfoRead = include("palaceInfoRead")
local bigWorldConfig = include("bigWorldConfig")
local singleBgSize = bigWorldConfig.singleBgSize
local worldMapDefine = include("worldMapDefine")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarRead = include("nebulaWarRead")
local nebulaWarUtil = include("nebulaWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BigWorldViewPanel = class("BigWorldViewPanel", baseFguiPanel)
function BigWorldViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("BigWorldViewPanel:ctor", self.viewName)
end
function BigWorldViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function BigWorldViewPanel:onInit()
	print("=======BigWorldViewPanel:onInit")
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
	end
	self.realKingdomList, _ENV, self.drawArea, _ENV, self.pathList, _ENV, self.kingdomNodeList, _ENV = self.view.fixChildrenPos, self.view.fixChildrenPos, self.view.fixChildrenPos, self.view.fixChildrenPos, self.view.fixChildrenPos, self.view.fixChildrenPos, self.view.fixChildrenPos, self.view.fixChildrenPos
	self.pathIndex = 0
	self.isInLegendLord = false
	local buttonBackWorldResource = SoraDGetChildByName(self, "Bottom_Button_goBack")
	if buttonBackWorldResource then
		buttonBackWorldResource:addClickEventListener(handler(self, self.buttonBackWorldResourceCall))
	end
	local buttonSearch = SoraDGetChildByName(self, "Bottom_Button_search")
	if buttonSearch then
		buttonSearch:addClickEventListener(handler(self, self.buttonSearchCall))
	end
	local buttonRegion = SoraDGetChildByName(self, "Bottom_Button_region")
	self.buttonRegion = buttonRegion
	if buttonRegion then
		buttonRegion:addClickEventListener(handler(self, self.onClickBtnRegion))
		if not commonCheck.NEBULA_AREA then
			buttonRegion:setVisible(false)
		end
	end
	self.buttonMileStone = SoraDGetChildByName(self, "Bottom_Button_mileStone")
	if self.buttonMileStone then
		self.buttonMileStone:addClickEventListener(handler(self, self.openNebulaMileStoneUnock))
		self.buttonMileStone:setVisible(false)
	end
	self.buttonGarden = self.fields.Bottom_Button_garden
	if self.buttonGarden then
		self.buttonGarden:addClickEventListener(handler(self, self.onClickBtnGarden))
		self.buttonGarden:setVisible(false)
	end
	local rType, rId = nebulaActivityCtrl:getKingdomRegionType()
	self.selfRigionId = rId
	self.regionType = self.param and self.param.regionType or rType
	_ENV, self.regionId = self.param and self.param.regionId or rId, self.param and self.param.regionId or rId
	;(self.param and self.param.regionId or rId)[NEBULA_REGION_TYPE.SEPARATIST_REGIME] = "nebula_war_text_0138"
	;(self.param and self.param.regionId or rId)[NEBULA_REGION_TYPE.PREPARE_FOR_WAR] = "nebula_war_text_0139"
	local (self.param and self.param.regionId or rId)[NEBULA_REGION_TYPE.HEGEMONY_REGION], config = "nebula_war_text_0140", self.param and self.param.regionId or rId
	local titleTopStr = i18n("common_text_528")
	if commonCheck.NEBULA_AREA then
		titleTopStr = titleTopStr .. "\n" .. i18n(config[self.regionType])
		if self.regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION then
			titleTopStr = titleTopStr .. "--" .. nebulaWarRead.getAreaName(self.regionId)
		end
	end
	local titleTop = SoraDGetChildByName(self, "Text_kingdom")
	titleTop:setTitle(titleTopStr)
	local btnAtlantis = SoraDGetChildByName(self, "Button_atlantis_record")
	if btnAtlantis then
		btnAtlantis:addClickEventListener(handler(self, self.buttonAtlantisCall))
	end
end
function BigWorldViewPanel:onShow()
	print("=======BigWorldViewPanel:onShow")
	self:initBorder()
	if self.regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION then
		if self.selfRigionId == self.regionId then
			_ENV = nil
			;(nil).kingdomLevel = nebulaActivityCtrl:getTowerLv()
			self.nebulaTowerNode:updateKingdomLv(nil)
		else
			nebulaActivityCtrl:reqTowerGroup(self.regionId)
		end
	end
	self:updateBtnGarden()
	self:onNebulaRefreshData()
end
function BigWorldViewPanel:setInLenendLord()
	self.isInLegendLord = true
end
function BigWorldViewPanel:showView()
	self:addBgBathNode()
	self:getPath()
	self:initConquestWarData()
end
function BigWorldViewPanel:initView()
	self.containerView = self:createBaseBg()
	local viewScrollView = cc.ScrollView:create(self.view:getSize())
	viewScrollView:setContainer(self.containerView)
	viewScrollView:setMinScale(0.5)
	viewScrollView:setMaxScale(1.5)
	viewScrollView:setZoomScale(0.5)
	viewScrollView:setBounceable(false)
	local containerViewSize = self.containerView:getContentSize()
	local containerViewscale = viewScrollView:getZoomScale()
	viewScrollView:setContentOffset(cc.p(-(containerViewSize.width - display.width) / 2 * containerViewscale, -(containerViewSize.height - display.height) / 2 * containerViewscale), false)
	viewScrollView:setPosition(cc.p(0, 0))
	self.view:addChild(viewScrollView, -1)
	self.viewScrollView = viewScrollView
	self.viewScrollView:setDelegate()
	self.viewScrollView:registerScriptHandler(handler(self, self.scrollViewDidOffset), cc.SCROLLVIEW_SCRIPT_SCROLL)
end
function BigWorldViewPanel:scrollViewDidOffset()
	self:tryDrawArea()
	self:showKingdom()
end
function BigWorldViewPanel:tryDrawArea()
	self.drawArea = self:getShowArea()
end
function BigWorldViewPanel:getShowArea()
	local drawArea
	local offsetX = self.viewScrollView:getContentOffset().x
	local offsetY = self.viewScrollView:getContentOffset().y
	local zoomScale = self.viewScrollView:getZoomScale()
	local x = offsetX - display.width / 2
	local y = offsetY - display.height / 2
	local width = display.width * 2 / zoomScale
	local height = display.height * 2 / zoomScale
	_ENV = nil
	;(nil).x = x / zoomScale
	;(nil).y = y / zoomScale
	;(nil).width = width
	drawArea, (nil).height = nil, height
	return drawArea
end
function BigWorldViewPanel:isPosInArea(pos, area)
	local isIn = false
	if pos.x <= area.x + area.width / 2 and pos.x >= area.x - area.width / 2 and pos.y <= area.y + area.height / 2 and pos.y >= area.y - area.height / 2 then
		isIn = true
	end
	return isIn
end
function BigWorldViewPanel:createAKindom(kInfo)
	local isIn, posX, posY = self:isKingdomInArea(kInfo.kid)
	if not isIn then
		return
	end
	local index = kingdomPointDefine.getIndexByKid(kInfo.kid)
	if self.palaceBatchNode and self.palaceBatchNode:getChildByTag(index) then
		print("已经生成过了!!!!!!!!")
		return
	end
	local palace
	if worldMapDefine.isLegendLordKingdomID(kInfo.kid) then
		palace = worldMapDefine.getLegendLordBg()
		palace:setScale(0.5)
	else
		local icon = palaceInfoRead.getIcon(kInfo.palaceModel or 1)
		palace = display.newSprite("#" .. icon)
	end
	palace:setPosition(cc.p(posX, posY))
	palace:setTag(index)
	self.palaceBatchNode:addChild(palace, 2)
	self.kingdomNodeList[kInfo.kid] = kingdomNode.new(kInfo)
	self.kingdomNodeList[kInfo.kid]:setPosition(cc.p(posX + self.viewSize.width / 2, posY + self.viewSize.height / 2))
	self.kingdomNodeList[kInfo.kid].relyView = self
	self.containerView:addChild(self.kingdomNodeList[kInfo.kid], 6)
end
function BigWorldViewPanel:getPosByKid(kid, isNebulaTower)
	kid = kid or 1
	local _posX = 0
	local _posY = 0
	local kPos
	if isNebulaTower then
		kPos = cc.p(0.5, -0.5)
	elseif worldMapDefine.isLegendLordKingdomID(kid) then
		kPos = cc.p(0.5, 0.5)
	else
		local index = kingdomPointDefine.getIndexByKid(kid)
		kPos = kingdomPointDefine.getPointByIndex(self.regionType, index)
	end
	if kPos then
		_posX = kPos.x * bigWorldConfig.singleBgSize.width
		_posY = kPos.y * bigWorldConfig.singleBgSize.height
	end
	return _posX, _posY
end
function BigWorldViewPanel:isKingdomInArea(kid)
	local _isIn = false
	local _posX, _posY = self:getPosByKid(kid)
	if _posX and _posY then
		local offsetPosX = -_posX - self.viewSize.width / 2
		local offsetPosY = -_posY - self.viewSize.height / 2
		if self:isPosInArea(cc.p(offsetPosX, offsetPosY), self.drawArea) then
			_isIn = true
		end
	end
	return _isIn, _posX, _posY
end
function BigWorldViewPanel:showKingdom()
	if not self.palaceBatchNode then
		self.palaceBatchNode = display.newNode()
		self.palaceBatchNode:setPosition(cc.p(self.containerView:getContentSize().width / 2, self.containerView:getContentSize().height / 2))
		self.palaceBatchNode:addTo(self.containerView, 5)
		for i = 1, #self.realKingdomList do
			self:createAKindom(self.realKingdomList[i])
		end
		if self.regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION then
			local _ENV, ret = self.regionType, self.regionType
			for i = 1, #self.realKingdomList do
				local index = kingdomPointDefine.getIndexByKid(self.realKingdomList[i].kid)
				ret[index] = true
			end
			for index = 1, 96 do
				if not ret[index] then
					local kPos = kingdomPointDefine.getPointByIndex(self.regionType, index)
					local posX = kPos.x * singleBgSize.width
					local posY = kPos.y * singleBgSize.height
					local palace = display.newSprite("#Map_build_lostRuin.png")
					palace:setScale(0.5)
					palace:setPosition(cc.p(posX, posY))
					palace:setTag(index)
					self.palaceBatchNode:addChild(palace, 2)
				end
			end
			local palace = display.newSprite("#Map_build_nebula_tower.png")
			palace:setScale(0.5)
			local pos = cc.p(singleBgSize.width / 2, -singleBgSize.height / 2)
			palace:setPosition(pos)
			self.palaceBatchNode:addChild(palace, 2)
			_ENV = self.palaceBatchNode.addChild
			self.palaceBatchNode.addChild.isNebulaTower = true
			local self.palaceBatchNode.addChild.kingdomLevel, kInfo = 0, self.palaceBatchNode.addChild
			local nebulaTowerNode = kingdomNode.new(kInfo)
			nebulaTowerNode:setPosition(cc.p(pos.x + self.viewSize.width / 2, pos.y + self.viewSize.height / 2))
			self.containerView:addChild(nebulaTowerNode, 6)
			self.nebulaTowerNode = nebulaTowerNode
		end
	else
		for i = 1, #self.realKingdomList do
			local kid = self.realKingdomList[i].kid
			local index = kingdomPointDefine.getIndexByKid(kid)
			local palace = self.palaceBatchNode:getChildByTag(index)
			if not palace then
				self:createAKindom(self.realKingdomList[i])
			else
				local isVisible = self:isKingdomInArea(kid)
				palace:setVisible(isVisible)
				if self.kingdomNodeList[kid] then
					self.kingdomNodeList[kid]:setVisible(isVisible)
				end
			end
		end
	end
end
function BigWorldViewPanel:isSubset(index1, index2)
	local isSub = false
	local path1 = index1 .. "_" .. index2
	local path2 = index2 .. "_" .. index1
	local path
	if self.pathList[path1] or self.pathList[path2] then
		isSub = true
		path = self.pathList[path1] or self.pathList[path2]
	end
	return isSub, path
end
function BigWorldViewPanel:loadPath(index1, index2)
	if not (index1 and not (index1 <= 0) and index2) or index2 <= 0 or self:isSubset(index1, index2) then
		return
	end
	local kPos1 = kingdomPointDefine.getPointByIndex(self.regionType, index1)
	local posX1 = kPos1.x * bigWorldConfig.singleBgSize.width
	local posY1 = kPos1.y * bigWorldConfig.singleBgSize.height
	local kPos2 = kingdomPointDefine.getPointByIndex(self.regionType, index2)
	local posX2 = kPos2.x * bigWorldConfig.singleBgSize.width
	local posY2 = kPos2.y * bigWorldConfig.singleBgSize.height
	local pos = cc.p((posX1 + posX2) / 2, (posY1 + posY2) / 2)
	self.pathIndex = self.pathIndex + 1
	local dir = kingdomPointDefine.getDir(index1, index2, self.regionType)
	local isFlip = self.pathIndex % 2
	local pathDir = bigWorldConfig.getPathConfigByDir(dir + isFlip)
	local index = self.pathIndex % table.nums(pathDir)
	if index == 0 then
		index = table.nums(pathDir)
	end
	local selectPathData = pathDir[index]
	local path = display.newSprite("#" .. selectPathData.png)
	path:setPosition(pos)
	path:setFlippedX(selectPathData.style % 2 == 0)
	if selectPathData.scale then
		path:setScale(selectPathData.scale)
	end
	if selectPathData.rotate then
		path:setRotation(selectPathData.rotate)
	end
	if selectPathData.offset then
		path:setPosition(cc.pAdd(pos, selectPathData.offset))
	end
	self.pathBatchNode:addChild(path)
	self.pathList[index1 .. "_" .. index2] = path
end
function BigWorldViewPanel:getPath()
	self.pathBatchNode = display.newBatchNode()
	self.pathBatchNode:setPosition(cc.p(self.containerView:getContentSize().width / 2, self.containerView:getContentSize().height / 2))
	self.pathBatchNode:addTo(self.containerView, 3)
	if self.regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION then
		for index = 1, 96 do
			local upIndex, downIndex, leftIndex, rightIndex = kingdomPointDefine.getNeighbourKingdomsIndex(self.regionType, index)
			self:loadPath(upIndex, index)
			self:loadPath(downIndex, index)
			self:loadPath(leftIndex, index)
			self:loadPath(rightIndex, index)
		end
	else
		for k, v in pairs(self.baseKingdomList) do
			if not worldMapDefine.isLegendLordKingdomID(v.kid) then
				local index = kingdomPointDefine.getIndexByKid(v.kid)
				local upIndex, downIndex, leftIndex, rightIndex = kingdomPointDefine.getNeighbourKingdomsIndex(self.regionType, index)
				if kingdomPointDefine.getKidByIndex(upIndex, self.regionId) > 0 then
					self:loadPath(upIndex, index)
				end
				if kingdomPointDefine.getKidByIndex(downIndex, self.regionId) > 0 then
					self:loadPath(downIndex, index)
				end
				if kingdomPointDefine.getKidByIndex(leftIndex, self.regionId) > 0 then
					self:loadPath(leftIndex, index)
				end
				if kingdomPointDefine.getKidByIndex(rightIndex, self.regionId) > 0 then
					self:loadPath(rightIndex, index)
				end
			end
		end
	end
end
function BigWorldViewPanel:initData()
	self.realKingdomList = nebulaWarUtil.getBigWorldKingdomList(self.regionType, self.regionId)
	self.baseKingdomList = nebulaWarUtil.getBigWorldKingdomList(self.regionType, self.regionId, true)
end
function BigWorldViewPanel:checkKidNeedShow(kid)
	return kid and 0 < kid and kid <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END
end
function BigWorldViewPanel:refreshData(target, data)
	if not data.kInfo then
		local _UPVALUE0_, kInfo = data.kInfo, data.kInfo
	end
	local kid = kInfo.kid
	if self:checkKidNeedShow(kid) and kInfo and self.kingdomNodeList[kid] then
		self.kingdomNodeList[kid]:refreshData(kInfo)
	end
end
function BigWorldViewPanel:jumpToKingdom(target, data)
	local kid = data.kid
	if kid == worldMapDefine.LEGENDLORD_KINGDOM_ID then
		if commonCheck.NEBULA_AREA then
			worldMapDefine = nil
			;(nil).handler = function()
				_ENV = nil
				;(nil).legendLord = true
				uiManager:show("NebulaRegion", nil)
			end
			uiManager:show("NebulaRegionSwitch", nil)
		else
			self:moveToKingdom(kid)
		end
		return
	end
	if worldMapDefine.isKingStarMapId(kid) then
		worldMapDefine = nil
		;(nil).handler = function()
			if kid == worldMapDefine.KINGSTAR_KINGDOM_ID then
				kid = nil
				;(nil).kingStar = true
				uiManager:show("NebulaRegion", nil)
			else
				local activityID = worldMapDefine.getKingStarActivityID(kid)
				local regionId = nebulaWarRead.getAreaID(activityID) or 102
				kid = nil
				;(nil).regionId = regionId
				uiManager:show("NebulaRegion", nil)
			end
		end
		uiManager:show("NebulaRegionSwitch", nil)
		return
	end
	if not self:checkKidNeedShow(kid) then
		return
	end
	local regionType, regionId = nebulaActivityCtrl:getKingdomRegionType(kid)
	if regionId ~= self.regionId then
		worldMapDefine = nil
		;(nil).handler = function()
			self:closePanel()
			self = nil
			;(nil).regionType = regionType
			;(nil).regionId = regionId
			local bigWorldView = uiManager:show("BigWorldView", nil).view
			bigWorldView:moveToKingdom(kid)
		end
		uiManager:show("NebulaRegionSwitch", nil)
		return
	end
	local isIn = self.kingdomNodeList[kid]
	if not isIn then
		for i, v in ipairs(self.realKingdomList) do
			if v.kid == kid then
				isIn = true
				break
			end
		end
	end
	if isIn then
		self:moveToKingdom(kid)
	end
end
function BigWorldViewPanel:changeToKingdom(target, data)
	if self.isInLegendLord then
		return
	end
	local func = function()
		if self.isFguiClick then
			return
		end
		SoraDPlaySound()
		if data.isNebulaTower then
			if self.regionId ~= self.selfRigionId then
				self = self.selfRigionId
				self.selfRigionId.title = i18n("nebula_war_text_0152")
				self.selfRigionId.content = i18n("nebula_war_text_0236")
				SoraDShowServerTip(self.selfRigionId)
				return
			end
			if nebulaActivityCtrl:isNebulaActivityOpen() then
				nebulaWarUtil.openTowerView()
			else
				SoraDShowMsgTip(i18n("common_text_2486"))
			end
			return
		end
		local kid = data.kid
		if self:checkKidNeedShow(kid) then
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local gotoPoint = cityCtrl:getCurCityPos()
			if not self.isOwnKingdom then
				if worldMapDefine.isLegendLordKingdomID(kid) then
					gotoPoint = cc.p(150, 150)
				else
					gotoPoint = cc.p(600, 600)
				end
			end
			SoraDGotoWorldMapPoint(gotoPoint, false, kid)
			local self, actionsArray = SoraDGotoWorldMapPoint, SoraDGotoWorldMapPoint
			actionsArray[#actionsArray + 1] = ffa.delay(0.3)
			actionsArray[#actionsArray + 1] = ffa.callFunc(function()
				SorDCloseWordResourceMap()
				self:closePanel()
				_ENV = self
				self.msg = "MESSAGE_UI_LEGENDLORD_MAPVIEW_CLOSE"
				SoraDSendMessage(self)
			end)
			local actions = ffa.seq(actionsArray)
			self:runAction(actions)
		end
	end
	self:stopActionByTag(999)
	local seq = ffa.seq(ffa.delay(0.016666666666666666), ffa.callFunc(func))
	seq:setTag(999)
	self:runAction(seq)
end
function BigWorldViewPanel:initConquestWarData(target, data)
	local kwList = conquestWarCtrl:getMatchKingdomList()
	if kwList and next(kwList) then
		for k, v in pairs(kwList) do
			v = tonumber(v)
			if self:checkKidNeedShow(v) and self.kingdomNodeList[v] then
				self.kingdomNodeList[v]:setWarStatus(0 < v)
			end
		end
	end
end
function BigWorldViewPanel:moveToSelfKingdom()
	local gametop = gModuleMgr.getObject("gametop")
	local kid = gametop.playertop_:getKingdomID()
	self:moveToKingdom(kid)
end
function BigWorldViewPanel:moveToKingdom(kid, isNebulaTower)
	local posX, posY = self:getPosByKid(kid, isNebulaTower)
	posX = posX + self.viewSize.width / 2
	posY = posY + self.viewSize.height / 2
	local selfPos = cc.p(posX, posY)
	local zoomScale = self.viewScrollView:getZoomScale()
	local viewW = self.view:getWidth()
	local viewH = self.view:getHeight()
	local newOffsetPoint = cc.p(viewW / 2 - selfPos.x * zoomScale, viewH / 2 - selfPos.y * zoomScale)
	if newOffsetPoint.x < viewW - self.containerView:getContentSize().width then
		newOffsetPoint.x = viewW - self.containerView:getContentSize().width
	elseif newOffsetPoint.x > 0 then
		newOffsetPoint.x = 0
	end
	if newOffsetPoint.y < viewH - self.containerView:getContentSize().height then
		newOffsetPoint.y = viewH - self.containerView:getContentSize().height
	elseif newOffsetPoint.y > 0 then
		newOffsetPoint.y = 0
	end
	self.viewScrollView:setContentOffset(newOffsetPoint)
end
function BigWorldViewPanel:getLayerBg()
	local batchNode = display.newBatchNode()
	local sprite = display.newSprite("#worldSeverMap_BD_13.png")
	local offset = sprite:getContentSize()
	local land = 1
	if self.regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION then
		land = nebulaWarRead.getAreaLand(self.regionId)
	elseif self.regionType == NEBULA_REGION_TYPE.PREPARE_FOR_WAR then
		land = nebulaWarRead.getAreaLand(101)
	elseif self.regionType == NEBULA_REGION_TYPE.SEPARATIST_REGIME then
		land = nebulaWarRead.getAreaLand(102)
	end
	local landImage = string.format("worldSeverMap_bg_%d.png", land)
	_ENV, _ENV = land, "worldSeverMap_bg_%d.png"
	land.image = landImage
	land.pos = cc.p(self.viewSize.width / 2, self.viewSize.height / 2)
	land.width = self.viewSize.width
	_ENV, ("worldSeverMap_bg_%d.png")[1], land.height = land, land, self.viewSize.height
	land.image = "worldSeverMap_BD_8.png"
	land.anchorPoint = cc.p(0, 0.5)
	land.pos = cc.p(0, self.viewSize.height / 2)
	_ENV, ("worldSeverMap_bg_%d.png")[2], land.height = land, land, self.viewSize.height - offset.height * 2
	land.image = "worldSeverMap_BD_6.png"
	land.anchorPoint = cc.p(1, 0.5)
	land.pos = cc.p(self.viewSize.width, self.viewSize.height / 2)
	_ENV, ("worldSeverMap_bg_%d.png")[3], land.height = land, land, self.viewSize.height - offset.height * 2
	land.image = "worldSeverMap_BD_9.png"
	land.anchorPoint = cc.p(0.5, 1)
	land.pos = cc.p(self.viewSize.width / 2, self.viewSize.height)
	_ENV, ("worldSeverMap_bg_%d.png")[4], land.width = land, land, self.viewSize.width - offset.width * 2
	land.image = "worldSeverMap_BD_7.png"
	land.anchorPoint = cc.p(0.5, 0)
	land.pos = cc.p(self.viewSize.width / 2, 0)
	;("worldSeverMap_bg_%d.png")[5], land.width = land, self.viewSize.width - offset.width * 2
	local config = "worldSeverMap_bg_%d.png"
	for i, v in ipairs(config) do
		local image = ccui.ImageView:create(v.image, ccui.TextureResType.plistType)
		if v.anchorPoint then
			image:setAnchorPoint(v.anchorPoint)
		end
		image:setPosition(v.pos)
		image:addTo(batchNode, 2)
		image:setCapInsets(cc.rect(0, 0, image:getContentSize().width, image:getContentSize().height))
		image:setScale9Enabled(true)
		image:setFillType(1)
		image:setContentSize(cc.size(v.width or image:getContentSize().width, v.height or image:getContentSize().height))
	end
	_ENV, _ENV = ipairs(config)
	ipairs(config).image = "worldSeverMap_BD_13.png"
	ipairs(config).anchorPoint = cc.p(0, 1)
	_ENV, ipairs(config)[1], ipairs(config).pos = ipairs(config)
	ipairs(config).image = "worldSeverMap_BD_11.png"
	ipairs(config).anchorPoint = cc.p(0, 0)
	_ENV, ipairs(config)[2], ipairs(config).pos = ipairs(config)
	ipairs(config).image = "worldSeverMap_BD_12.png"
	ipairs(config).anchorPoint = cc.p(1, 1)
	_ENV, ipairs(config)[3], ipairs(config).pos = ipairs(config)
	ipairs(config).image = "worldSeverMap_BD_10.png"
	ipairs(config).anchorPoint = cc.p(1, 0)
	ipairs(config)[4], ipairs(config).pos = ipairs(config)
	local config = ipairs(config)
	for i, v in ipairs(config) do
		local sprite = display.newSprite("#" .. v.image)
		sprite:setAnchorPoint(v.anchorPoint)
		sprite:setPosition(v.pos)
		sprite:addTo(batchNode, 2)
	end
	return batchNode
end
function BigWorldViewPanel:createBaseBg()
	local layer = ccui.Layout:create()
	layer:setTouchEnabled(false)
	layer:setBackGroundColorType(1)
	local svrNum = math.max(table.nums(self.baseKingdomList), 25)
	local circle = math.ceil(math.sqrt(svrNum)) + 2
	local size = cc.size(circle * bigWorldConfig.singleBgSize.width, circle * bigWorldConfig.singleBgSize.height)
	if self.regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION then
		local viewSize = cc.size(10, 14)
		size = cc.size(viewSize.width * bigWorldConfig.singleBgSize.width, viewSize.height * bigWorldConfig.singleBgSize.height)
	end
	layer:setContentSize(size)
	self.viewSize = size
	return layer
end
function BigWorldViewPanel:addBgBathNode()
	local bgBathNode = self:getLayerBg()
	bgBathNode:setPosition(cc.p(0, 0))
	bgBathNode:addTo(self.containerView, 2)
end
function BigWorldViewPanel:buttonSearchCall(button, type)
	SoraDPlaySound()
	uiManager:show("LegendaryKingSearch")
	self:setFguiClicked()
end
function BigWorldViewPanel:buttonBackWorldResourceCall(button, type)
	SoraDPlaySound()
	self:closePanel()
end
function BigWorldViewPanel:onClickBtnRegion(button, event)
	SoraDPlaySound()
	local regionId = self.regionId
	_ENV = nil
	;(nil).handler = function()
		_ENV = nil
		;(nil).legendLord = false
		;(nil).regionId = regionId
		uiManager:show("NebulaRegion", nil)
	end
	uiManager:show("NebulaRegionSwitch", nil)
	self:setFguiClicked()
end
function BigWorldViewPanel:finishLoadImages()
	print("BigWorldViewPanel:加载资源完毕")
	self:showView()
end
function BigWorldViewPanel:initBorder()
	self:initData()
	self:initView()
	self:tryDrawArea()
	self:showKingdom()
	if self.selfRigionId == self.regionId then
		self:moveToSelfKingdom()
	else
		self:moveToKingdom(nil, true)
	end
	self:showView()
end
function BigWorldViewPanel:loadRes()
	_ENV, _UPVALUE1_ = nil, nil
	;(nil).name = "worldMap/worldSeverMap"
	;(nil).key = "worldSeverMap"
	local (nil)[1], imgArray
	local canLoad = true
	for _, v in ipairs(imgArray) do
		local ret = SoraDIsFileExistByKey(v.key)
		print(v.name .. " ret = ", ret)
		if not ret then
			canLoad = false
		end
	end
	if canLoad then
		self:loadImages(imgArray, handler(self, self.finishLoadImages))
	end
end
function BigWorldViewPanel:fileDownloadByKey(target, data)
	if data.key == "worldSeverMap" then
		self:loadRes()
	end
end
function BigWorldViewPanel:buttonAtlantisCall(button, type)
	SoraDPlaySound()
	self:setFguiClicked()
	local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
	if not atlantisActivityCtrl:checkShowRecordView() then
		return
	end
	local panel = SoraDSearchPanelFromManagerByName("AtlantisRecord")
	if panel then
		panel.isHidePrePanel = false
		panel:closePanel()
	end
	uiManager:show("AtlantisRecord")
end
function BigWorldViewPanel:onMsgGetTowerGroup(target, event)
	local towerData = event.rspdata
	if self.nebulaTowerNode then
		_UPVALUE0_ = nil
		;(nil).kingdomLevel = towerData.level
		self.nebulaTowerNode:updateKingdomLv(nil)
	end
end
function BigWorldViewPanel:onNebulaRefreshData(target, data)
	local curState = nebulaActivityCtrl:getActivityCurState()
	if curState == NEBULA_REGION_STATE.SETTLE then
		self.buttonMileStone:setVisible(true)
	elseif self.buttonMileStone ~= nil then
		self.buttonMileStone:setVisible(false)
	end
	self:sortBtnList()
end
function BigWorldViewPanel:openNebulaMileStoneUnock(button, type)
	SoraDPlaySound()
	uiManager:show("NebulaMileStoneUnlock")
	self:setFguiClicked()
end
function BigWorldViewPanel:setFguiClicked()
	self.isFguiClick = true
	self:stopActionByTag(998)
	local seq = ffa.seq(ffa.delay(0.03333333333333333), ffa.callFunc(function()
		self.isFguiClick = false
	end))
	seq:setTag(998)
	self:runAction(seq)
end
function BigWorldViewPanel:onClickBtnGarden(EventContext)
	SoraDPlaySound()
	self:setFguiClicked()
	SorDCloseWordResourceMap()
	local manorCityUtil = include("manorCityUtil")
	manorCityUtil.gotoGardenWar()
end
function BigWorldViewPanel:updateBtnGarden()
	local manorCityUtil = include("manorCityUtil")
	if manorCityUtil.checkServerUnlock() then
		self.buttonGarden:setVisible(true)
	else
		self.buttonGarden:setVisible(false)
	end
end
function BigWorldViewPanel:sortBtnList()
	_UPVALUE2_ = nil
	;(nil)[1] = self.buttonMileStone
	local (nil)[2], btnList = self.buttonGarden, nil
	local beginY = self.buttonRegion:getPositionY()
	for i, v in ipairs(btnList) do
		if v:isVisible() then
			beginY = beginY - 93
			v:setPositionY(beginY)
		end
	end
end
return BigWorldViewPanel
