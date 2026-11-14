local gametop = gModuleMgr.getObject("gametop")
local worldMapDefine = include("worldMapDefine")
local radianceWarDef = include("radianceWarDef")
local RADIANCE_WAR_STATE = radianceWarDef.RADIANCE_WAR_STATE
local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local radianceWarUtil = include("radianceWarUtil")
local radianceWarRead = include("radianceWarRead")
local resourceMapViewBase = class("resourceMapViewBase", function(fileName)
	if fileName == nil then
		fileName = "radianceWarMapView"
	end
	local target = SoraDCreateBasePanel(fileName)
	include("worldResourceMapNormal").new(target)
	return target
end)
function resourceMapViewBase:onEnterPanel()
	self:loadImagesFinish()
end
function resourceMapViewBase:ctor()
	self.isHideCurrentSceneView = true
	self.mapKindomID = worldMapDefine.currentMapKindomID
	self.myKindomID = gametop.playertop_:getMapID()
	self:setContentSize(display.size)
	self.isMoved = false
	self.leagueMembersArray, worldMapDefine, self.mySprite = self.setContentSize, self.setContentSize, nil
	self.cityPolygonPtArray, worldMapDefine, self.resourcePolygonPtArray, worldMapDefine, self.actionBtnList, worldMapDefine, self.closeIconList, worldMapDefine, self.isButtonControlOpen = self.setContentSize, self.setContentSize, self.setContentSize, self.setContentSize, self.setContentSize, self.setContentSize, self.setContentSize, self.setContentSize, true
	self:initWidget()
	self:initData()
end
function resourceMapViewBase:initWidget()
	self:initScroll("radianceWarMapView_Info")
	self:initTouchlayer()
	self:initBgArea()
	local containerViewSize = self.containerView:getContentSize()
	local offsetX = 20
	local offsetY = 210
	self.mapwidth = containerViewSize.width - offsetX * 2
	self.mapheight = containerViewSize.height - offsetY * 2
	self.ratioToResource = self.mapwidth / worldMapDefine.worldResourceMapSize.width
	self.zeroPoint = cc.p(self.containerView:getContentSize().width / 2, self.containerView:getContentSize().height - offsetY)
	self.tileW = self.mapwidth / 1201
	self.tileH = self.mapheight / 1201
	self:addResourcePoint(offsetX, offsetY)
	self:createBorder(1760)
	local buttonBackWorld = SoraDGetChildByName(self, "Button_goBack")
	if buttonBackWorld then
		buttonBackWorld:addTouchEventListener(handler(self, self.buttonBackWorldCall))
	end
	local nodeTop = SoraDGetChildByName(self, "Top_Node")
	if nodeTop then
		nodeTop:setPositionY(display.height)
	end
	self.Node_Info = SoraDGetChildByName(self, "Node_Info")
	if self.Node_Info then
		self.Node_Info:setVisible(false)
	end
	self.resource_belt = SoraDGetChildByName(self, "resource_belt")
	if self.resource_belt then
		self.resource_belt:setVisible(false)
	end
	self.Node_resources_tag = SoraDGetChildByName(self, "Node_resources_tag")
	if self.Node_resources_tag then
		self.Node_resources_tag:setLocalZOrder(12)
		self.Node_resources_tag:setVisible(false)
	end
	self:initColorLayer()
	local Node_cloud = SoraDGetChildByName(self, "Node_cloud")
	if Node_cloud then
		Node_cloud:setVisible(false)
	end
	self.buttonControl = SoraDGetChildByName(self, "Button_control")
	if self.buttonControl then
		self.buttonControl:addTouchEventListener(handler(self, self.buttonControlCall))
		self.buttonBg = SoraDGetChildByName(self.buttonControl, "btn_minimap_bg")
		self.buttonEye = SoraDGetChildByName(self.buttonControl, "btn_minimap_eye")
		self.buttonAct = SoraDGetChildByName(self.buttonControl, "btn_minimap_act")
		local newNode = display.newNode()
		newNode:addTo(self.buttonControl:getParent())
		self.actionNode = newNode
	end
	self.Node_tips = SoraDGetChildByName(self, "Node_tips")
	if self.Node_tips then
		self.Node_tips:setVisible(false)
	end
	self.Node_explain = SoraDGetChildByName(self, "Node_explain")
	if self.Node_explain then
		self.Node_explain:setVisible(false)
		self.kingdomTextArray = SoraDGetChildsArrayByName(self.Node_explain, "Text_kingdom", 4, 1)
	end
	self.nodeState = SoraDGetChildByName(self, "node_statues")
	if self.nodeState then
		self.nodeState:setVisible(false)
	end
end
function resourceMapViewBase:initNodeInfo(config)
	if not (self.Node_Info and config) or not next(config) then
		return
	end
	self.Node_Info:setVisible(true)
	local Panel_black = SoraDGetChildByName(self.Node_Info, "Panel_black")
	local Node_single = SoraDGetChildByName(self.Node_Info, "Node_info_single")
	Node_single:setVisible(false)
	local itemH = 70
	local num = math.ceil(#config / 3)
	local totalH = itemH * num
	Panel_black:setContentSize(cc.size(Panel_black:getContentSize().width, itemH * num))
	for i, v in ipairs(config) do
		local node = Node_single:clone()
		node:setVisible(true)
		node:addTo(self.Node_Info)
		local col = (i - 1) % 3 + 1
		local row = math.ceil(i / 3)
		node:setPosition(210 * SoraDFSign(2 - col) + SoraDFSign(70), totalH - itemH * (row - 0.5))
		local Sprite_info = SoraDGetChildByName(node, "Sprite_info")
		Sprite_info:setSpriteFrame(v.image)
		Sprite_info:setScale(45 / Sprite_info:getContentSize().height)
		local Text_info = SoraDGetChildByName(node, "Text_info")
		Text_info:setString(v.title)
	end
end
function resourceMapViewBase:onMessageListener()
end
function resourceMapViewBase:mapViewClose()
	self:close(nil, ccui.TouchEventType.ended)
end
function resourceMapViewBase:initData()
end
function resourceMapViewBase:viewOnClick(ref, event)
	if event == ccui.TouchEventType.ended then
		if not self.isMoved or SoraDIsGameGuide() then
			SoraDPlaySound()
			self.isMoved = false
			local touchEndPoint = self.touchlayer:getTouchEndPosition()
			local covertPoint = self.touchlayer:convertToNodeSpace(touchEndPoint)
			local isTouchInMember = false
			local _ENV, spArray = touchEndPoint, touchEndPoint
			if self.mySprite then
				table.insert(spArray, self.mySprite)
			end
			if self.lorderSprite then
				table.insert(spArray, self.lorderSprite)
			end
			_ENV, _ENV = spArray, table.insert
			spArray.isShow = true
			_ENV, table.insert[1], spArray.array = spArray, spArray, spArray
			spArray.isShow = self.isLeagueShow
			table.insert[2], spArray.array = spArray, self.leagueMembersArray
			local tab = table.insert
			for i, v in ipairs(tab) do
				if not isTouchInMember and v.isShow then
					for k, w in pairs(v.array) do
						if cc.rectContainsPoint(w:getCascadeBoundingBox(), touchEndPoint) then
							local x, y = w:getPosition()
							covertPoint = cc.p(x, y)
							isTouchInMember = true
							break
						end
					end
				end
			end
			if not isTouchInMember then
				if not SorDIsPointInPolygon(self.resourcePolygonPtArray, covertPoint) then
					return
				end
				for _, v in ipairs(self.cityPolygonPtArray) do
					if SorDIsPointInPolygon(v.cityPolygonPtArray, covertPoint) then
						covertPoint = v.point
					end
				end
			end
			if "radianceWarMainView" == self.enterType then
				SoraDShowLoading(nil, nil, nil, true)
				self:showJumpAction(covertPoint, function()
					local tile = worldMapDefine.point2tile(covertPoint, self.zeroPoint, self.tileW, self.tileH)
					SoraDGotoWorldMapPoint(tile)
					SoraDRemoveAllPanelFromManager()
					SoraDCloseLoading()
				end)
				return
			end
			local subPoint = cc.pSub(self.containerViewCenterPoint, covertPoint)
			local ratio = worldMapDefine.worldMapViewSize.width / self.mapwidth
			subPoint = cc.p(subPoint.x * ratio, subPoint.y * ratio)
			local mapKindomID = worldMapDefine.currentMapKindomID
			_ENV = subPoint.y * ratio
			;(subPoint.y * ratio).msg = "MESSAGE_WORLD_MAP_MOVETOCENTER_SUBPOINT"
			;(subPoint.y * ratio).subPoint = subPoint
			;(subPoint.y * ratio).kingdomID = mapKindomID
			SoraDSendMessage(subPoint.y * ratio)
			SoraDShowLoading()
			self:showJumpAction(covertPoint, function()
				self:close(nil, ccui.TouchEventType.ended)
				SoraDCloseLoading()
			end)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = self.touchlayer:getTouchBeganPosition()
		local touchmovePoint = self.touchlayer:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
	elseif event == ccui.TouchEventType.began then
		self.isMoved = false
	end
end
function resourceMapViewBase:buttonBackWorldCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(nil, ccui.TouchEventType.ended)
	end
end
function resourceMapViewBase:setLeagueInfo(fromTarget)
	for _, v in pairs(self.leagueMembersArray) do
		v:setVisible(self.isLeagueShow)
		if self.mapKindomID ~= self.myKindomID then
			v:setVisible(false)
		end
	end
	if self.mySprite then
		self.mySprite:setVisible(self.mapKindomID == self.myKindomID)
	end
	if self.lorderSprite then
		self.lorderSprite:setVisible(self.isLeagueShow)
		if self.mapKindomID ~= self.myKindomID then
			self.lorderSprite:setVisible(false)
		end
	end
	if self.node_arrow then
		self.node_arrow:setVisible(self.mapKindomID == worldMapDefine.currentMapKindomID)
	end
end
function resourceMapViewBase:computerMemberArray(data)
	local _ENV, memberArray
	for k, v in pairs(data) do
		if v.x and v.y then
			local tile = cc.p(v.x - 1, v.y - 1)
			local point = worldMapDefine.tile2point(self.zeroPoint, tile, self.tileW, self.tileH)
			local subPt = cc.pSub(self.containerViewCenterPoint, point)
			v.x = subPt.x / self.ratioToResource
			v.y = subPt.y / self.ratioToResource
			table.insert(memberArray, v)
		end
	end
	return memberArray
end
function resourceMapViewBase:setLeagueMembersInfo(memberArray)
	self.batchAllianceNode = display.newBatchNode(getImageFileNameByPlatform("worldMap/worldMapUI"), #memberArray)
	self.batchAllianceNode:addTo(self.containerView, 9)
	for _, v in pairs(memberArray) do
		local memberSprite
		local scale = 0.6
		if v.memberType == gWorldResourceMapPlayerType.youSelf then
			memberSprite = display.newSprite("#position_city.png")
			self.mySprite = memberSprite
			if self.mapKindomID ~= self.myKindomID then
				self.mySprite:setVisible(false)
			end
		elseif v.memberType == gWorldResourceMapPlayerType.leader then
			memberSprite = display.newSprite("#position_lord.png")
			self.lorderSprite = memberSprite
		elseif v.memberType == gWorldResourceMapPlayerType.other then
			memberSprite = display.newSprite("#position_alli.png")
			scale = 1.5
			memberSprite:setVisible(self.isLeagueShow)
			table.insert(self.leagueMembersArray, memberSprite)
		end
		v.x = v.x * self.ratioToResource
		v.y = v.y * self.ratioToResource
		local point = cc.pSub(self.containerViewCenterPoint, cc.p(v.x, v.y))
		memberSprite:setAnchorPoint(cc.p(0.5, 0.1))
		memberSprite:setPosition(point)
		memberSprite:setScale(scale)
		memberSprite:addTo(self.batchAllianceNode)
	end
	self:setLeagueInfo()
end
function resourceMapViewBase:loadImagesFinish()
	for i = 1, 9 do
		local imgBg = SoraDGetChildByName(self, "Image_bg_" .. i)
		if imgBg then
			imgBg:setSpriteFrame("radiance_thumbnail.png")
		end
	end
end
function resourceMapViewBase:updateBtnPosition()
	local posy = 90
	for i, v in ipairs(self.actionBtnList) do
		if v:isVisible() then
			v:setPosition(cc.p(0, posy))
			posy = posy + 70
		end
	end
end
function resourceMapViewBase:buttonControlCall(button, type)
	if type == ccui.TouchEventType.ended then
		self.isButtonControlOpen = not self.isButtonControlOpen
		self.buttonControl:setTouchEnabled(false)
		self:setBtnControlInfo()
	end
end
function resourceMapViewBase:setBtnControlInfo()
	local buttonImgName = "btn_minimap_02.png"
	if not self.isButtonControlOpen then
		buttonImgName = "btn_minimap_05.png"
	end
	if not self.isButtonControlOpen then
		_ENV = cc.ScaleTo
		cc.ScaleTo.easing = "BACKIN"
		function cc.ScaleTo.onComplete()
			self.buttonEye:setSpriteFrame(buttonImgName)
			self.buttonControl:setTouchEnabled(true)
		end
		transition.execute(self.actionNode, cc.ScaleTo:create(0.5, 0), cc.ScaleTo)
		self.buttonAct:runAction(cca.rotateTo(0.5, 0))
		self.buttonBg:runAction(cca.rotateTo(0.5, 0))
	else
		self.buttonEye:setSpriteFrame(buttonImgName)
		self.buttonAct:setRotation(0)
		self.buttonAct:runAction(cca.rotateTo(0.5, 45))
		self.buttonBg:setRotation(0)
		self.buttonBg:runAction(cca.rotateTo(0.5, -45))
		_ENV = cc.ScaleTo
		cc.ScaleTo.easing = "BACKOUT"
		function cc.ScaleTo.onComplete()
			self.buttonControl:setTouchEnabled(true)
		end
		transition.execute(self.actionNode, cc.ScaleTo:create(0.5, 1), cc.ScaleTo)
	end
end
function resourceMapViewBase:setRadianceWarBuildingInfo(...)
	self.buidlingNode = display.newNode()
	self.buidlingNode:addTo(self.containerView, 9)
	local radianceWarRead = include("radianceWarRead")
	local building = radianceWarRead.getBuildingList()
	for k, v in pairs(building) do
		local tilex = v.x - 1 + v.size / 2
		local tiley = v.y - 1 + v.size / 2
		local tile = cc.p(tilex, tiley)
		local point = worldMapDefine.tile2point(self.zeroPoint, tile, self.tileW, self.tileH)
		if v.mapType == gMapObjTypeDef.mapTypeRadianceWarPalace then
			self:addPolygonPoint(point, 80, 50)
		elseif v.mapType == gMapObjTypeDef.mapTypeRadianceWarGate then
			self:addPolygonPoint(point, 40, 25)
		end
	end
end
function resourceMapViewBase:refreshKingdomText()
	if not self.Node_explain then
		return
	end
	local curState = radianceActivityCtrl:getWarStatus()
	if curState == RADIANCE_WAR_STATE.RESULT or curState == RADIANCE_WAR_STATE.BATTLE or curState == RADIANCE_WAR_STATE.FINISH then
		self.Node_explain:setVisible(true)
		local radianceWarCtrl = SoraDGetCtrl("radianceWarCtrl")
		local data = radianceWarCtrl:getMatchData()
		if data and next(data) then
			for i, v in ipairs(self.kingdomTextArray) do
				if data[i] and data[i].kingdomName then
					v:setString(data[i].kingdomName)
				end
			end
		else
			self.Node_explain:setVisible(false)
		end
	else
		self.Node_explain:setVisible(false)
	end
end
function resourceMapViewBase:setRadianceWarBuildingStataues()
	if not self.buildingStatues then
		self.buildingStatues = display.newNode()
		self.buildingStatues:addTo(self.containerView, 9)
		self.buildingStatuesArray, _ENV = self.buildingStatues.addTo, self.buildingStatues.addTo
	end
	local curState = radianceActivityCtrl:getWarStatus()
	local isShow = curState and curState ~= RADIANCE_WAR_STATE.FINISH
	if isShow then
		local building = radianceWarRead.getBuildingList()
		for k, v in pairs(building) do
			local single = self.buildingStatuesArray[k]
			if not single then
				single = self.nodeState:clone()
				self.buildingStatuesArray[k] = single
				single:addTo(self.buildingStatues)
				local tilex = v.x - 1 + v.size / 2
				local tiley = v.y - 1 + v.size / 2
				local tile = cc.p(tilex, tiley)
				local point = worldMapDefine.tile2point(self.zeroPoint, tile, self.tileW, self.tileH)
				local offset = 40
				if v.mapType == gMapObjTypeDef.mapTypeRadianceWarPalace then
					offset = offset + 40
				end
				single:setPosition(cc.p(point.x, point.y + offset))
				local txtTime = SoraDGetChildByName(single, "Text_time")
				txtTime = SoraDCreateTimerLabel(self, txtTime)
				txtTime:setTimeEndListener(function()
					single.nodeTime:setVisible(false)
					single.spStats:setSpriteFrame("icon_lord_kill.png")
					single.spStats:setScale(1.0)
					single.spStats:setPositionY(0)
				end)
				single.txtTime = txtTime
				single.nodeTime = SoraDGetChildByName(single, "Node_time")
				single.spStats = SoraDGetChildByName(single, "Sprite_state")
			end
			single:setVisible(true)
			local time = radianceWarUtil.getBuildOpenLiftTime(v.mapType, v.lv or 1)
			if 0 < time then
				single.txtTime:beginTime(time)
				single.nodeTime:setVisible(true)
				single.spStats:setSpriteFrame("3007.png")
				single.spStats:setScale(0.3)
				single.spStats:setPositionY(30)
			else
				single.txtTime:endTime()
			end
		end
	else
		for _, v in pairs(self.buildingStatuesArray) do
			if v then
				v.txtTime:endTime()
				v:setVisible(false)
			end
		end
	end
end
return resourceMapViewBase
