local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
local checknumber = _G.checknumber
local pyramidBattleMapView = class("pyramidBattleMapView", function()
	local target = SoraDCreateBasePanel("pyramidBattleMapView")
	include("worldResourceMapNormal").new(target)
	return target
end)
function pyramidBattleMapView:onEnterPanel()
	_ENV, _UPVALUE1_ = nil, nil
	;(nil).name = "worldMap/worldResourceMap"
	local (nil)[1], imgArray
	self:loadImages(imgArray, handler(self, self.finishLoadImages))
end
function pyramidBattleMapView:ctor()
	self.isHideCurrentSceneView = true
	self.isShow = true
	self:setContentSize(display.size)
	self.isMoved = false
	self.mapKindomID = worldMapDefine.currentMapKindomID
	self.myKindomID = gametop.playertop_:getMapID()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	self.aid = allianceMgr:getOwnAid()
	self.mySprite = nil
	self.leagueMembersArray, _ENV, self.lorderSprite = allianceMgr:getOwnAid(), allianceMgr:getOwnAid(), nil
	self.isLeagueShow = true
	self.resourcePolygonPtArray, _ENV, self.buildingArrayGem, _ENV, self.buildingArray, _ENV, self.maxPoints = allianceMgr:getOwnAid(), allianceMgr:getOwnAid(), allianceMgr:getOwnAid(), allianceMgr:getOwnAid(), allianceMgr:getOwnAid(), allianceMgr:getOwnAid(), 80000
	self:initScroll("pyramidBattleMap_info")
	self:initTouchlayer()
	local containerViewSize = self.containerView:getContentSize()
	local offsetX = 140
	local offsetY = 220
	self.mapwidth = containerViewSize.width - offsetX * 2
	self.mapheight = containerViewSize.height - offsetY * 2
	self.ratioToResource = self.mapwidth / worldMapDefine.worldResourceMapSize.width
	self.zeroPoint = cc.p(self.containerView:getContentSize().width / 2, self.containerView:getContentSize().height - offsetY)
	self.tileW = self.mapwidth / 150
	self.tileH = self.mapheight / 150
	self:addResourcePoint(offsetX, offsetY)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.Top_Node:setPositionY(display.height)
	self.labTitle = SoraDGetChildByName(self, "Text_title")
	self.labTitle:setString(i18n("common_text_2517"))
	self.Node_progress_south = SoraDGetChildByName(self, "Node_progress_south")
	local lab_self_south = SoraDGetChildByName(self.Node_progress_south, "Text_Self")
	lab_self_south:setString(i18n("common_text_3139"))
	self.Node_progress_north = SoraDGetChildByName(self, "Node_progress_north")
	local lab_self_north = SoraDGetChildByName(self.Node_progress_north, "Text_Self")
	lab_self_north:setString(i18n("common_text_3139"))
	self.labStatusNode = SoraDGetChildByName(self, "Image_protect_bg")
	self.labStatusNode:setVisible(false)
	self.labStatus = SoraDGetChildByName(self, "Text_Time")
	self.labStatus:setString(i18n("common_text_3136"))
	self.labStatusHourglass = SoraDGetChildByName(self, "icon_hourglass")
	self.labTime = SoraDGetChildByName(self, "Text_applyTime")
	self.labTime = SoraDCreateTimerLabel(self, self.labTime)
	self.Top_Node_info = SoraDGetChildByName(self, "Top_Node_info")
	self.Top_Node_info:setPositionY(display.height - 200)
	self.btnShow = SoraDGetChildByName(self.Top_Node_info, "Button_show")
	self.btnShow:addTouchEventListener(handler(self, self.onShowClick))
	local Text_member = SoraDGetChildByName(self.Top_Node_info, "Text_member")
	Text_member:setString(i18n("common_text_2521"))
	self.width_title = Text_member:getContentSize().width
	local Text_moveTimes = SoraDGetChildByName(self.Top_Node_info, "Text_moveTimes")
	Text_moveTimes:setString(i18n("common_text_2522"))
	self.width_title = math.max(self.width_title, Text_moveTimes:getContentSize().width)
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.Node_info = SoraDGetChildByName(self.Bottom_Node, "Node_info")
	self.btnControl = SoraDGetChildByName(self.Bottom_Node, "Button_control")
	self.btnControl:addTouchEventListener(handler(self, self.onControlClick))
	self.buttonEye = SoraDGetChildByName(self.btnControl, "btn_minimap_eye")
	self.Image_forbidden = SoraDGetChildByName(self.btnControl, "Image_forbidden")
	self.btnGoback = SoraDGetChildByName(self.Bottom_Node, "Button_goBack")
	self.btnGoback:addTouchEventListener(handler(self, self.onGobackClick))
	local height = self.Top_Node:getPositionY()
	local legendTip = include("worldMapLegendTip").new()
	legendTip:setPosition(cc.p(display.cx, height - 250 + display.iPhoneXBottom))
	legendTip:addTo(self, 1)
	self.southData, _ENV, self.northData, _ENV = legendTip.addTo, legendTip.addTo, legendTip.addTo, legendTip.addTo
	self:updateData()
	self:updateStatus()
	self:initBuildings()
	self:updateBuildingStatus()
end
function pyramidBattleMapView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_RESOURCEMAP_MOVETOCENTER", handler(self, self.moveSubPointToCenter))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_CAMP_DATA", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.updateStatus))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEONWERCHANGED", handler(self, self.updateBuildingStatus))
end
function pyramidBattleMapView:initBuildings()
	self.batchNode = display.newNode()
	self.batchNode:addTo(self.containerView, 9)
	local Node_building = SoraDGetChildByName(self.containerView, "Node_building")
	self.Node_info = display.newNode()
	self.Node_info:addTo(self.containerView, 10)
	local info = kingdomMapCtrl:getAllianceWarBuildings()
	for k, v in pairs(info) do
		local node = Node_building:clone()
		node:setVisible(true)
		node:addTo(self.Node_info)
		local offset = v.size / 2
		local tilex = v.x + offset
		local tiley = v.y + offset
		local x = self.zeroPoint.x + (tilex - tiley) * self.tileW / 2
		local y = self.zeroPoint.y + -(tilex + tiley) * self.tileH / 2
		local point = cc.p(x, y)
		node:setPosition(point)
		local strIcon = worldMapDefine.getPyramidbuildingIcon(v.type)
		local build = display.newSprite("#" .. strIcon)
		build:setPosition(point)
		build:setAnchorPoint(cc.p(0.5, 0.5))
		local scale = 0.6
		if gMapBattlefieldSiteTypeDef.subMapObjTypeBigPyramid == v.type or gMapBattlefieldSiteTypeDef.subTypeAWTemple == v.type then
			scale = 0.8
		elseif gMapBattlefieldSiteTypeDef.subMapObjTypeSmallPyramid == v.type then
			scale = 0.75
		end
		build:setScale(scale)
		build:addTo(self.batchNode)
		build:setName(tostring(v.id))
		self.buildingArray[tostring(v.id)] = build
		local Text_name = node:getChildByName("Text_name")
		if Text_name then
			Text_name:setString(worldMapDefine.getPyramidbuildingName(v.type, v.id))
		end
		if gMapBattlefieldSiteTypeDef.subMapTypeAWArmory == v.type then
			node:setVisible(false)
		end
	end
end
function pyramidBattleMapView:updateBuildingStatus()
	local info = kingdomMapCtrl:getAllianceWarBuildings()
	for k, v in pairs(info) do
		local strkey = tostring(v.id)
		local build = self.buildingArray[strkey]
		if build then
			local gem = self.buildingArrayGem[strkey]
			if v.allianceWarCamp and v.finishOccupy then
				if v.allianceWarCamp == gAllianceWarCampType.red then
					build:setColor(cc.c3b(237, 42, 66))
				elseif v.allianceWarCamp == gAllianceWarCampType.blue then
					build:setColor(cc.c3b(0, 170, 255))
				end
				if gem then
					gem:setVisible(false)
				end
			elseif v.allianceWarCamp and not v.finishOccupy then
				if not gem then
					gem = display.newSprite("#icon_battlefield_south.png")
					gem:setAnchorPoint(cc.p(0.5, 0))
					gem:setScale(0.5)
					gem:setPosition(cc.p(build:getPositionX(), build:getPositionY() - 20))
					gem:addTo(self.containerView, 10)
					self.buildingArrayGem[strkey] = gem
				end
				if gem then
					gem:setVisible(true)
					if v.allianceWarCamp == gAllianceWarCampType.red then
						gem:setSpriteFrame("icon_battlefield_south.png")
					elseif v.allianceWarCamp == gAllianceWarCampType.blue then
						gem:setSpriteFrame("icon_battlefield_north.png")
					end
				end
				build:setColor(cc.c3b(255, 255, 255))
			else
				build:setColor(cc.c3b(255, 255, 255))
				if gem then
					gem:setVisible(false)
				end
			end
		end
	end
end
function pyramidBattleMapView:updateData()
	self.southData, allianceWarCtrl, self.northData, allianceWarCtrl = nil, nil, nil, nil
	local data = allianceWarCtrl:getAllianceWarCampData(worldMapDefine.currentMapKindomID)
	for k, v in pairs(data) do
		if tonumber(k) == gAllianceWarCampType.red then
			self.southData = v
		elseif tonumber(k) == gAllianceWarCampType.blue then
			self.northData = v
		end
	end
	self:updatePoints()
	self:updateSideInfo()
end
function pyramidBattleMapView:updatePoints()
	local progress_south = SoraDGetChildByName(self.Node_progress_south, "LoadingBar_point")
	local lab_points_south = SoraDGetChildByName(self.Node_progress_south, "Text_point")
	local lab_self_south = SoraDGetChildByName(self.Node_progress_south, "Text_Self")
	local progress_north = SoraDGetChildByName(self.Node_progress_north, "LoadingBar_point")
	local lab_points_north = SoraDGetChildByName(self.Node_progress_north, "Text_point")
	local lab_self_north = SoraDGetChildByName(self.Node_progress_north, "Text_Self")
	local point_south = checknumber(self.southData.points)
	local point_north = checknumber(self.northData.points)
	progress_south:setPercent(point_south * 100 / self.maxPoints)
	_ENV = nil
	;(nil).score = point_south
	lab_points_south:setString(i18n("common_text_2518", nil))
	lab_self_south:setVisible(self.southData.aid == self.aid)
	progress_north:setPercent(point_north * 100 / self.maxPoints)
	_ENV = i18n("common_text_2518", nil)
	i18n("common_text_2518", nil).score = point_north
	lab_points_north:setString(i18n("common_text_2519", i18n("common_text_2518", nil)))
	lab_self_north:setVisible(self.northData.aid == self.aid)
end
function pyramidBattleMapView:updateSideInfo()
	local width = self.width_title
	local Text_south_member = SoraDGetChildByName(self.Top_Node_info, "Text_south_member")
	local Text_south_move = SoraDGetChildByName(self.Top_Node_info, "Text_south_move")
	local Text_north_member = SoraDGetChildByName(self.Top_Node_info, "Text_north_member")
	local Text_north_move = SoraDGetChildByName(self.Top_Node_info, "Text_north_move")
	local south_member = checknumber(self.southData.memberNum)
	_ENV = nil
	;(nil).count = south_member
	Text_south_member:setString(i18n("common_text_3137", nil))
	local north_member = checknumber(self.northData.memberNum)
	_ENV = i18n("common_text_3137", nil)
	i18n("common_text_3137", nil).count = north_member
	Text_north_member:setString(i18n("common_text_3138", i18n("common_text_3137", nil)))
	local south_move = checknumber(self.southData.moveCitySurplusTimes)
	_ENV = i18n("common_text_3138", i18n("common_text_3137", nil))
	i18n("common_text_3138", i18n("common_text_3137", nil)).count = south_move
	Text_south_move:setString(i18n("common_text_3137", i18n("common_text_3138", i18n("common_text_3137", nil))))
	local north_move = checknumber(self.northData.moveCitySurplusTimes)
	_ENV = i18n("common_text_3137", i18n("common_text_3138", i18n("common_text_3137", nil)))
	i18n("common_text_3137", i18n("common_text_3138", i18n("common_text_3137", nil))).count = north_move
	Text_north_move:setString(i18n("common_text_3138", i18n("common_text_3137", i18n("common_text_3138", i18n("common_text_3137", nil)))))
	width = math.max(width, Text_south_member:getContentSize().width)
	width = math.max(width, Text_north_member:getContentSize().width)
	width = math.max(width, Text_south_move:getContentSize().width)
	width = math.max(width, Text_north_move:getContentSize().width)
	width = width + 45
	self.width_info = width
	local image_info = SoraDGetChildByName(self.Top_Node_info, "Image_info_bg")
	local size = image_info:getContentSize()
	size.width = self.width_info
	image_info:setContentSize(size)
	if not SoraDFIsRA() then
		image_info:setPositionX(self.width_info)
		self.btnShow:setPositionX(self.width_info - 15)
	else
		image_info:setPositionX(-self.width_info)
		self.btnShow:setAnchorPoint(cc.p(0, 0.5))
		self.btnShow:setPositionX(-self.width_info + 15)
	end
end
function pyramidBattleMapView:onControlClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.Node_info:setVisible(not self.Node_info:isVisible())
		local buttonImgName = "btn_minimap_02.png"
		if not self.Node_info:isVisible() then
			buttonImgName = "btn_minimap_05.png"
			self.Image_forbidden:setVisible(true)
		else
			self.Image_forbidden:setVisible(false)
		end
		self.buttonEye:setSpriteFrame(buttonImgName)
	end
end
function pyramidBattleMapView:onGobackClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(nil, ccui.TouchEventType.ended)
	end
end
function pyramidBattleMapView:onShowClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local btnBackImg = "btn_battlefield_back_01.png"
		local btnPopImg = "btn_battlefield_pop_01.png"
		local posx = self.btnShow:getPositionX()
		if self.isShow then
			self.Top_Node_info:runAction(cc.EaseBounceOut:create(cca.moveBy(0.5, -posx, 0)))
			self.btnShow:loadTextureNormal(btnPopImg, ccui.TextureResType.plistType)
		else
			self.Top_Node_info:runAction(cc.EaseBounceOut:create(cca.moveBy(0.5, posx, 0)))
			self.btnShow:loadTextureNormal(btnBackImg, ccui.TextureResType.plistType)
		end
		self.isShow = not self.isShow
	end
end
function pyramidBattleMapView:viewOnClick(ref, event)
	if event == ccui.TouchEventType.ended then
		if not self.isMoved or SoraDIsGameGuide() then
			local touchEndPoint = self.touchlayer:getTouchEndPosition()
			local covertPoint = self.touchlayer:convertToNodeSpace(touchEndPoint)
			SoraDPlaySound()
			if SorDIsPointInPolygon(self.resourcePolygonPtArray, covertPoint) then
				if self.mySprite and cc.rectContainsPoint(self.mySprite:getCascadeBoundingBox(), touchEndPoint) then
					local x, y = self.mySprite:getPosition()
					covertPoint = cc.p(x, y)
				elseif self.lorderSprite and cc.rectContainsPoint(self.lorderSprite:getCascadeBoundingBox(), touchEndPoint) then
					local x, y = self.lorderSprite:getPosition()
					covertPoint = cc.p(x, y)
				else
					local isTouchInMember = false
					if self.isLeagueShow then
						for k, v in pairs(self.leagueMembersArray) do
							if cc.rectContainsPoint(v:getCascadeBoundingBox(), touchEndPoint) then
								local x, y = v:getPosition()
								covertPoint = cc.p(x, y)
								isTouchInMember = true
								break
							end
						end
					end
					if not isTouchInMember then
						for k, v in pairs(self.buildingArray) do
							if cc.rectContainsPoint(v:getCascadeBoundingBox(), touchEndPoint) then
								local x, y = v:getPosition()
								covertPoint = cc.p(x, y)
								break
							end
						end
					end
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
				local guideStep = SoraDIsGameGuide()
				if guideStep and 28000 <= guideStep and guideStep < 29000 then
					SoraDGotoWorldMapPoint(cc.p(74, 74), true)
				end
				SoraDShowLoading()
				self:showJumpAction(covertPoint, function()
					self:close(nil, ccui.TouchEventType.ended)
					SoraDCloseLoading()
				end)
			end
		end
		self.isMoved = false
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
function pyramidBattleMapView:finishLoadImages()
	local guideStep = SoraDIsGameGuide()
	if guideStep and guideStep == 28002 then
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
		;(nil).step = 28003
		SoraDSendMessage(nil)
	end
end
function pyramidBattleMapView:setLeagueMembersInfo(memberArray)
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
end
function pyramidBattleMapView:updateStatus()
	local warStatus = allianceWarCtrl:getWarData(worldMapDefine.currentMapKindomID).warStatus
	print("warStatus=", warStatus)
	if warStatus then
		local warTime = allianceWarCtrl:getWarData(worldMapDefine.currentMapKindomID).warStatusTime or 0
		local time = kingdomMapCtrl:getPyramidWarStatusTime()
		print("warTime=", warTime, "time", time)
		if 0 < warTime and 0 < time then
			self.labStatusNode:setVisible(true)
			self.labTime:beginTime(time)
		else
			self.labStatusNode:setVisible(false)
		end
		if warStatus == gKingdomWarStatusType.close then
			self.labStatus:setString(i18n("common_text_1213"))
		elseif warStatus == gKingdomWarStatusType.inWar then
			self.labStatus:setString(i18n("common_text_3136"))
		elseif warStatus == gKingdomWarStatusType.rule then
			self.labStatus:setString(i18n("common_text_1213"))
		end
	else
		self.labStatusNode:setVisible(false)
	end
end
function pyramidBattleMapView:gameGuide_getTarget(itemName, parameters)
	if itemName == "101" then
		local build = SoraDGetChildByName(self.batchNode, itemName)
		local buildPos = cc.p(build:getPositionX(), build:getPositionY())
		self:moveMapPointToCenter(buildPos)
		return build
	else
		return SoraDGetChildByName(self, itemName)
	end
end
return pyramidBattleMapView
