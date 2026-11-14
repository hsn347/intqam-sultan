local gametop = gModuleMgr.getObject("gametop")
local worldMapDefine = include("worldMapDefine")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local legendLordWarltCtrl = include("legendLordWarltCtrl")
local hegemonRead = include("hegemonRead")
local legendLordMapView_Hegemon = include("legendLordMapView_Hegemon")
local legendLordMapView = class("legendLordMapView", function()
	local target = SoraDCreateBasePanel("legendLordMapView")
	include("worldResourceMapNormal").new(target)
	return target
end)
function legendLordMapView:ctor()
	self.isHideCurrentSceneView = true
	self.mapKindomID = worldMapDefine.currentMapKindomID
	self.myKindomID = gametop.playertop_:getMapID()
	self:setContentSize(display.size)
	self.isMoved = false
	self.mySprite = nil
	self.leagueMembersArray, worldMapDefine, self.lorderSprite = self.setContentSize, self.setContentSize, nil
	local teamCtrl = include("legendTeamUtil").getCurTeamCtrl(worldMapDefine.currentMapKindomID)
	self.cityPolygonPtArray, worldMapDefine, self.resourcePolygonPtArray, worldMapDefine, self.hasJoinAlliance = teamCtrl:isHasTeam(), teamCtrl:isHasTeam(), teamCtrl:isHasTeam(), teamCtrl:isHasTeam(), teamCtrl:isHasTeam()
	self.buildingArray, worldMapDefine, self.batchAllianceNode = teamCtrl:isHasTeam(), teamCtrl:isHasTeam(), nil
	self:initScroll("legendLordMapView_Info")
	self:initTouchlayer()
	self:addPolygonPoint(self.containerViewCenterPoint, 80, 50)
	local containerViewSize = self.containerView:getContentSize()
	local offsetX = 140
	local offsetY = 220
	self.mapwidth = containerViewSize.width - offsetX * 2
	self.mapheight = containerViewSize.height - offsetY * 2
	self.ratioToResource = self.mapwidth / worldMapDefine.worldResourceMapSize.width
	self.zeroPoint = cc.p(self.containerView:getContentSize().width / 2, self.containerView:getContentSize().height - offsetY)
	self.tileW = self.mapwidth / 300
	self.tileH = self.mapheight / 300
	self:addResourcePoint(offsetX, offsetY)
	worldMapDefine, self.kingdomLabel = SoraDGetChildByName(self, "Text_kingDomName"), SoraDGetChildByName(self, "Text_kingDomName")
	SoraDGetChildByName(self, "Text_kingDomName")[worldMapDefine.KINGSTAR_KINGDOM_ID] = i18n("kingstarbattle_text_20")
	worldMapDefine = nil
	;(nil).ranklist = i18n("remains_name_01")
	SoraDGetChildByName(self, "Text_kingDomName")[worldMapDefine.KINGSTAR_KINGDOM_ID_9001646] = i18n("king_star_rank_text2", nil)
	worldMapDefine = nil
	;(nil).ranklist = i18n("king_star_rank_text3")
	local SoraDGetChildByName(self, "Text_kingDomName")[worldMapDefine.KINGSTAR_KINGDOM_ID_9001647], titleCfg = i18n("king_star_rank_text2", nil), SoraDGetChildByName(self, "Text_kingDomName")
	self.kingdomLabel:setString(worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) and titleCfg[worldMapDefine.currentMapKindomID] or i18n("common_text_4244"))
	self.labProtect = SoraDGetChildByName(self, "Text_protect")
	self.labProtectTime = SoraDGetChildByName(self, "Text_protect_time")
	self.labProtectTime = SoraDCreateTimerLabel(self, self.labProtectTime)
	local buttonWorldSever = SoraDGetChildByName(self, "Button_worldSever")
	if buttonWorldSever then
		buttonWorldSever:addTouchEventListener(handler(self, self.buttonWorldSeverCall))
	end
	local buttonBackWorld = SoraDGetChildByName(self, "Button_goBack")
	if buttonBackWorld then
		buttonBackWorld:addTouchEventListener(handler(self, self.buttonBackWorldCall))
	end
	self.buttonLeague = SoraDGetChildByName(self, "Button_league")
	if self.buttonLeague then
		self.buttonLeague:addTouchEventListener(handler(self, self.buttonLeagueCall))
	end
	self.buttonLeagueCloseIcon = SoraDGetChildByName(self.buttonLeague, "Image_forbidden")
	self.buttonLeagueCloseIcon:setVisible(false)
	local imgTitleBg = SoraDGetChildByName(self, "Top_Image_kingdom_Bg")
	if imgTitleBg then
		imgTitleBg:setPositionY(display.height - 60)
	end
	self.imgProtectTimeBg = SoraDGetChildByName(self, "Top_Image_protect_bg")
	if self.imgProtectTimeBg then
		self.imgProtectTimeBg:setPositionY(display.height - 160)
	end
	self.imgProtectTimeBg:setVisible(false)
	self:setNodeInfoTitle()
	self:initData()
	self:initBuildings()
end
function legendLordMapView:setNodeInfoTitle()
	_ENV = nil
	;(nil).Text_city = "common_text_496"
	;(nil).Text_lord = "free_team_text_77"
	local (nil).Text_alli, nodeInfoTable = "remains_text_125", nil
	self.nodeInfoView = SoraDGetChildByName(self, "Bottom_Node_Info")
	for k, v in pairs(nodeInfoTable) do
		local txtInfo = SoraDGetChildByName(self.nodeInfoView, k)
		if txtInfo then
			txtInfo:setString(i18n(v))
		end
	end
end
function legendLordMapView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_RESOURCEMAP_MOVETOCENTER", handler(self, self.moveSubPointToCenter))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMNAME_CHANGED", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_FLAG_CHANGED", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_UI_LEGENDLORD_MAPVIEW_CLOSE", handler(self, self.mapViewClose))
end
function legendLordMapView:mapViewClose()
	self:close(nil, ccui.TouchEventType.ended)
end
function legendLordMapView:initData()
	if not self.hasJoinAlliance then
		self.buttonLeague:setVisible(false)
		self.nodeInfoView:getChildByName("Image_lord"):setVisible(false)
		self.nodeInfoView:getChildByName("Image_alli"):setVisible(false)
		self.nodeInfoView:getChildByName("Text_lord"):setVisible(false)
		self.nodeInfoView:getChildByName("Text_alli"):setVisible(false)
	end
	self.isLeagueShow = true
	local isOpen = legendLordWarCtrl:isOpen()
	if worldMapDefine.isInLegendLord() and isOpen then
		self.imgProtectTimeBg:setVisible(true)
		local isInWar = legendLordWarCtrl:isInWar()
		local warTime = legendLordWarCtrl:getStatusTime()
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
	end
end
function legendLordMapView:viewOnClick(ref, event)
	if event == ccui.TouchEventType.ended then
		if not self.isMoved or SoraDIsGameGuide() then
			local touchEndPoint = self.touchlayer:getTouchEndPosition()
			local covertPoint = self.touchlayer:convertToNodeSpace(touchEndPoint)
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
						local cityPolygon = self.cityPolygonPtArray[1]
						if SorDIsPointInPolygon(cityPolygon.cityPolygonPtArray, covertPoint) then
							covertPoint = cityPolygon.point
						else
							for _, v in pairs(self.buildingArray) do
								if cc.rectContainsPoint(v:getBoundingBox(), touchEndPoint) then
									print("in Hegemon")
									local x, y = v:getPosition()
									covertPoint = cc.p(x, y)
									break
								end
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
function legendLordMapView:buttonWorldSeverCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if commonCheck.NEBULA_AREA then
			_ENV = nil
			;(nil).handler = function()
				_ENV = nil
				local (nil).legendLord, param = true, nil
				local nebulaWarRead = include("nebulaWarRead")
				if worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) then
					if worldMapDefine.currentMapKindomID == worldMapDefine.KINGSTAR_KINGDOM_ID then
						_ENV = worldMapDefine.currentMapKindomID
						param, worldMapDefine.currentMapKindomID.kingStar = worldMapDefine.currentMapKindomID, true
					else
						local activityID = worldMapDefine.getKingStarActivityID(worldMapDefine.currentMapKindomID)
						local _ENV, regionId = activityID, nebulaWarRead.getAreaID(activityID) or 102
						param, activityID.regionId = activityID, regionId
					end
				end
				uiManager:show("NebulaRegion", param)
			end
			uiManager:show("NebulaRegionSwitch", nil)
		else
			uiManager:show("BigWorldView")
		end
	end
end
function legendLordMapView:buttonBackWorldCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(nil, ccui.TouchEventType.ended)
	end
end
function legendLordMapView:buttonLeagueCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isLeagueShow = not self.isLeagueShow
		self:setLeagueInfo(button)
		worldMapDefine.btnLeagueState = self.isLeagueShow
	end
end
function legendLordMapView:setLeagueInfo(fromTarget)
	self.buttonLeagueCloseIcon:setVisible(not self.isLeagueShow)
	for _, v in pairs(self.leagueMembersArray) do
		v:setVisible(self.isLeagueShow)
	end
	if self.lorderSprite then
		self.lorderSprite:setVisible(self.isLeagueShow)
	end
	if self.node_arrow then
		self.node_arrow:setVisible(self.mapKindomID == worldMapDefine.currentMapKindomID)
	end
	if self.isLeagueShow then
		self.nodeInfoView:setOpacity(255)
		local _ENV, actionsArray = self.nodeInfoView.setOpacity, self.nodeInfoView.setOpacity
		actionsArray[#actionsArray + 1] = cc.DelayTime:create(10.0)
		actionsArray[#actionsArray + 1] = cc.FadeOut:create(0.5)
		local actions = transition.sequence(actionsArray)
		self.nodeInfoView:stopAllActions()
		self.nodeInfoView:runAction(actions)
	else
		self.nodeInfoView:setOpacity(0)
	end
end
function legendLordMapView:setLeagueMembersInfo(memberArray)
	if not SoraDGetCtrl("legendTeamCtrl"):isHasTeam() and worldMapDefine.isLegendMapId(gametop.playertop_:getMapID()) then
		_ENV, _ENV = gametop.playertop_:getMapID()
		gametop.playertop_:getMapID().memberType = gWorldResourceMapPlayerType.youSelf
		gametop.playertop_:getMapID().x = 0
		memberArray, worldMapDefine.isLegendMapId(gametop.playertop_:getMapID())[1], gametop.playertop_:getMapID().y = worldMapDefine.isLegendMapId(gametop.playertop_:getMapID()), gametop.playertop_:getMapID()
	end
	self.batchAllianceNode = display.newBatchNode(getImageFileNameByPlatform("worldMap/worldMapUI"), #memberArray)
	self.batchAllianceNode:addTo(self.containerView, 9)
	for _, v in pairs(memberArray) do
		local memberSprite
		local scale = 0.6
		if v.memberType == gWorldResourceMapPlayerType.youSelf then
			memberSprite = display.newSprite("#position_city.png")
			self.mySprite = memberSprite
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
function legendLordMapView:initBuildings()
	local info = legendLordWarltCtrl.getLegendLordWarBuilding(worldMapDefine.currentMapKindomID)
	for id, v in pairs(info) do
		if not hegemonRead.isLegendLordBuilding(id) then
			local build = legendLordMapView_Hegemon.new()
			local offset = v.size / 2
			local tilex = v.x + offset
			local tiley = v.y + offset
			local x = self.zeroPoint.x + (tilex - tiley) * self.tileW / 2
			local y = self.zeroPoint.y + -(tilex + tiley) * self.tileH / 2
			local point = cc.p(x, y)
			build:setPosition(point)
			build:addTo(self.containerView)
			build:initView(id, v)
			self.buildingArray[id] = build
		end
	end
end
return legendLordMapView
