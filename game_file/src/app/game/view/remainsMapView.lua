local gametop = gModuleMgr.getObject("gametop")
local worldMapDefine = include("worldMapDefine")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local remainsMapView = class("remainsMapView", function()
	local target = SoraDCreateBasePanel("remainsMapView")
	include("worldResourceMapNormal").new(target)
	return target
end)
function remainsMapView:onEnterPanel()
	self:loadImagesFinish()
end
function remainsMapView:ctor()
	self.isHideCurrentSceneView = true
	self.mapKindomID = worldMapDefine.currentMapKindomID
	self.myKindomID = gametop.playertop_:getMapID()
	self:setContentSize(display.size)
	self.isMoved = false
	self.cityPolygonPtArray, worldMapDefine, self.resourcePolygonPtArray, worldMapDefine, self.leagueMembersArray, worldMapDefine, self.mySprite = self.setContentSize, self.setContentSize, self.setContentSize, self.setContentSize, self.setContentSize, self.setContentSize, nil
	self.kingdomLabel = SoraDGetChildByName(self, "Text_kingDomName")
	self.kingdomLabel:setString(i18n("activityname_23"))
	self.labProtect = SoraDGetChildByName(self, "Text_protect")
	self.labProtectTime = SoraDGetChildByName(self, "Text_protect_time")
	self.labProtectTime = SoraDCreateTimerLabel(self, self.labProtectTime)
	self.nodeScore = SoraDGetExtendChildFromCCSByName(self, "CCS_teamInfoScore_title")
	self.nodeScore:initViewWar()
	self:initScroll("remainsMapView_Info")
	self:initTouchlayer()
	self:initBgArea()
	local containerViewSize = self.containerView:getContentSize()
	local offsetX = 80
	local offsetY = 170
	self.mapwidth = containerViewSize.width - offsetX * 2
	self.mapheight = containerViewSize.height - offsetY * 2
	self.ratioToResource = self.mapwidth / worldMapDefine.worldResourceMapSize.width
	self.zeroPoint = cc.p(self.containerView:getContentSize().width / 2, self.containerView:getContentSize().height - offsetY)
	self.tileW = self.mapwidth / 70
	self.tileH = self.mapheight / 70
	self:addResourcePoint(offsetX, offsetY)
	self:addPolygonPoint(self.containerViewCenterPoint, 80, 50)
	self:addPolygonPoint(cc.p(self.containerViewCenterPoint.x, containerViewSize.height - offsetY - 40), 80, 50)
	self:addPolygonPoint(cc.p(self.containerViewCenterPoint.x, offsetY + 50), 80, 50)
	self:createBorder(1238)
	local buttonBackWorld = SoraDGetChildByName(self, "Button_goBack")
	if buttonBackWorld then
		buttonBackWorld:addTouchEventListener(handler(self, self.buttonBackWorldCall))
	end
	local nodeCenter = SoraDGetChildByName(self, "Node_build_center")
	nodeCenter:setLocalZOrder(5)
	local nodeTop = SoraDGetChildByName(self, "Top_Node")
	nodeTop:setPositionY(display.height)
	self.imgProtectTimeBg = SoraDGetChildByName(self, "Image_protect_bg")
	self.imgProtectTimeBg:setVisible(false)
	self.node_refresh_time = SoraDGetChildByName(self, "Node_refresh_time")
	self.node_refresh_time:setVisible(false)
	self.node_refresh_my = SoraDGetChildByName(self, "Image_my_bg")
	self.node_refresh_my:setVisible(false)
	self.txt_refresh_my = SoraDGetChildByName(self, "Text_refresh_my_time")
	self.txt_refresh_my = SoraDCreateTimerLabel(self, self.txt_refresh_my)
	self.txt_refresh_my:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_439", nil)
	end)
	self.node_refresh_zjssg = SoraDGetChildByName(self, "Image_zjssg_bg")
	self.node_refresh_zjssg:setVisible(false)
	self.txt_refresh_zjssg = SoraDGetChildByName(self, "Text_refresh_zjssg_time")
	self.txt_refresh_zjssg = SoraDCreateTimerLabel(self, self.txt_refresh_zjssg)
	self.txt_refresh_zjssg:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_439", nil)
	end)
	self:initTips()
	self:setNodeInfoTitle()
	self:initData()
	self:initColorLayer()
	self:addCloudAction()
	local remainsWarUtil = include("remainsWarUtil")
	if remainsWarUtil.checkIsInRemainsXianXia() then
		function _UPVALUE6_(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end
		;(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[1] = "Icon_monster_zjssg"
		;(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[2] = "Sprite_monster_zjssg"
		;(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[3] = "Icon_monster_my"
		;(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[4] = "Sprite_monster_my"
		;(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[5] = "Text_info_monster1"
		;(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[6] = "Text_info_monster2"
		for i, v in ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end) do
			SoraDGetChildByName(self, v):setVisible(false)
		end
		_UPVALUE3_, worldMapDefine = ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)
		_UPVALUE3_, ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[1], ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[1] = ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)
		_UPVALUE3_, ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[1], ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[2] = ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)
		_UPVALUE3_, ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[1], ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[3] = ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)
		ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[2], ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[1] = ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)
		ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[2], ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[2] = ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)
		ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[2], ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)[3] = ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)
		local config = ipairs(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_439", nil)
		end)
		for i, v in ipairs(config) do
			local widget1 = SoraDGetChildByName(self, v[1])
			local posx, posy = widget1:getPosition()
			local widget2 = SoraDGetChildByName(self, v[2])
			widget2:setPosition(posx, posy)
			local widget3 = SoraDGetChildByName(self, v[3])
			widget3:setPosition(posx + SoraDFSign(30), posy)
		end
	end
end
function remainsMapView:initTips()
	local setIconBg = function(name, imageHdBg, imageBg, hasHD)
		local bg = hasHD and imageHdBg or imageBg
		local icon_monster_my = SoraDGetChildByName(self, name)
		if icon_monster_my then
			icon_monster_my:setSpriteFrame(bg)
		end
	end
	setIconBg("Icon_monster_zjssg", nil, "icon_yjzz_world_boss.png")
	setIconBg("Sprite_monster_zjssg", nil, "icon_yjzz_world_boss.png")
	setIconBg("Icon_monster_my", nil, "icon_yjzz_world_boss.png")
	setIconBg("Sprite_monster_my", nil, "icon_yjzz_world_boss.png")
end
function remainsMapView:setNodeInfoTitle()
	_ENV = nil
	;(nil).Text_info_city = "common_text_496"
	;(nil).Text_info_team = "remains_text_125"
	;(nil).Text_info_remains = "remains_name_04"
	;(nil).Text_info_monster1 = "remains_text_384"
	;(nil).Text_info_monster2 = "remains_text_384"
	;(nil).Text_info_bone_left = "remains_text_82"
	local (nil).Text_info_bone_right, nodeInfoTable = "remains_text_82", nil
	for k, v in pairs(nodeInfoTable) do
		local txtInfo = SoraDGetChildByName(self, k)
		if txtInfo then
			txtInfo:setString(i18n(v))
			SoraDSetTextWidthHeight(txtInfo, cc.size(140, 40))
		end
	end
end
function remainsMapView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_RESOURCEMAP_MOVETOCENTER", handler(self, self.moveSubPointToCenter))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMNAME_CHANGED", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_UI_LEGENDLORD_MAPVIEW_CLOSE", handler(self, self.mapViewClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_BOSS_REFRESH_TIME", handler(self, self.updateRefreshTime))
end
function remainsMapView:mapViewClose()
	self:close(nil, ccui.TouchEventType.ended)
end
function remainsMapView:initData()
	self.isLeagueShow = worldMapDefine.btnLeagueState
	local isOpen = remainsWarCtrl:isOpen()
	if worldMapDefine.isRemainsKingdomID() and isOpen then
		self.imgProtectTimeBg:setVisible(true)
		self.node_refresh_time:setVisible(true)
		local isInWar = remainsWarCtrl:isInWar()
		local warTime = remainsWarCtrl:getStatusTime()
		if 0 < warTime then
			self.labProtectTime:beginTime(warTime)
		end
		if isInWar then
			self.labProtect:setString(i18n("common_text_1214"))
		else
			self.labProtect:setString(i18n("common_text_1213"))
		end
	else
		self.imgProtectTimeBg:setVisible(false)
		self.node_refresh_time:setVisible(false)
	end
	self:updateRefreshTime()
end
function remainsMapView:viewOnClick(ref, event)
	if event == ccui.TouchEventType.ended then
		if not self.isMoved or SoraDIsGameGuide() then
			local touchEndPoint = self.touchlayer:getTouchEndPosition()
			local covertPoint = self.touchlayer:convertToNodeSpace(touchEndPoint)
			if SorDIsPointInPolygon(self.resourcePolygonPtArray, covertPoint) then
				if self.mySprite and cc.rectContainsPoint(self.mySprite:getCascadeBoundingBox(), touchEndPoint) then
					local x, y = self.mySprite:getPosition()
					covertPoint = cc.p(x, y)
				else
					local isTouchInMember = false
					if self.isLeagueShow then
						for _, v in pairs(self.leagueMembersArray) do
							if cc.rectContainsPoint(v:getCascadeBoundingBox(), touchEndPoint) then
								local x, y = v:getPosition()
								covertPoint = cc.p(x, y)
								isTouchInMember = true
								break
							end
						end
					end
					if not isTouchInMember then
						for _, v in ipairs(self.cityPolygonPtArray) do
							if SorDIsPointInPolygon(v.cityPolygonPtArray, covertPoint) then
								covertPoint = v.point
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
function remainsMapView:buttonBackWorldCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(nil, ccui.TouchEventType.ended)
	end
end
function remainsMapView:setLeagueInfo(fromTarget)
	for _, v in pairs(self.leagueMembersArray) do
		v:setVisible(self.isLeagueShow)
		if self.mapKindomID ~= self.myKindomID then
			v:setVisible(false)
		end
	end
	if self.mySprite then
		self.mySprite:setVisible(self.mapKindomID == self.myKindomID)
	end
	if self.node_arrow then
		self.node_arrow:setVisible(self.mapKindomID == worldMapDefine.currentMapKindomID)
	end
end
function remainsMapView:setLeagueMembersInfo(memberArray)
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
		elseif v.memberType == gWorldResourceMapPlayerType.leader or v.memberType == gWorldResourceMapPlayerType.other then
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
function remainsMapView:loadImagesFinish()
	for i = 1, 9 do
		local imgBg = SoraDGetChildByName(self, "Image_bg_" .. i)
		if imgBg then
			imgBg:setSpriteFrame("map_center.png")
		end
	end
end
function remainsMapView:updateRefreshTime_imp(node, txtTime, time)
	if 0 < time then
		node:setVisible(true)
		txtTime:beginTime(time)
		txtTime:setTimeEndListener(function()
			node:setVisible(false)
		end)
	else
		node:setVisible(false)
		txtTime:removeTime()
	end
end
function remainsMapView:updateRefreshTime()
	local timeMy = remainsWarCtrl:getBossRefreshTime_My()
	self:updateRefreshTime_imp(self.node_refresh_my, self.txt_refresh_my, timeMy)
	local timeZjssg = remainsWarCtrl:getBossRefreshTime_Zjssg()
	self:updateRefreshTime_imp(self.node_refresh_zjssg, self.txt_refresh_zjssg, timeZjssg)
end
return remainsMapView
