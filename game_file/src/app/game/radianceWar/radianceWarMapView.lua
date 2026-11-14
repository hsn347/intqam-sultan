local gametop = gModuleMgr.getObject("gametop")
local worldMapDefine = include("worldMapDefine")
local radianceWarUtil = include("radianceWarUtil")
local radianceWarCtrl = gametop.playertop_:getModule("radianceWarCtrl")
local radianceWarRead = include("radianceWarRead")
local resourceMapViewBase = include("resourceMapViewBase")
local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local radianceWarDef = include("radianceWarDef")
local RADIANCE_WAR_STATE = radianceWarDef.RADIANCE_WAR_STATE
local radianceWarMapView = class("radianceWarMapView", resourceMapViewBase)
function radianceWarMapView:ctor(...)
	self.isResourceShow = false
	self.isLeagueShow = true
	_ENV = nil
	;(nil).byUID = true
	local isTerritoryShow = SoraDConfigGet("Game:radianceWarMapView:isTerritoryShow~bool", nil)
	self.isTerritoryShow = isTerritoryShow
	radianceWarMapView.super.ctor(self, ...)
end
function radianceWarMapView:initWidget(...)
	radianceWarMapView.super.initWidget(self, ...)
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("brightWar_text_22"))
	self.nodeTitle:setVisible(false)
	radianceWarMapView, radianceWarMapView = self.nodeTitle, self.nodeTitle.setVisible
	self.nodeTitle.title = i18n("common_text_496")
	radianceWarMapView, self.nodeTitle.setVisible[1], self.nodeTitle.image = self.nodeTitle, self.nodeTitle, "position_city.png"
	self.nodeTitle.title = i18n("common_text_526")
	radianceWarMapView, self.nodeTitle.setVisible[2], self.nodeTitle.image = self.nodeTitle, self.nodeTitle, "position_lord.png"
	self.nodeTitle.title = i18n("common_text_180")
	radianceActivityCtrl, self.nodeTitle.setVisible[3], self.nodeTitle.image = self.nodeTitle, self.nodeTitle, "position_alli.png"
	local nodeInfo = self.nodeTitle.setVisible
	self.nodeTitle[1] = gMapObjTypeDef.mapTypeRadianceWarPalace
	self.nodeTitle[2] = 999
	local self.nodeTitle[3], tab = gMapObjTypeDef.mapTypeRadianceWarGate, self.nodeTitle
	for i, v in ipairs(tab) do
		radianceWarMapView = i18n("brightWar_text_22")
		i18n("brightWar_text_22").title = radianceWarRead.getBuildName(v)
		local i18n("brightWar_text_22").image, data = radianceWarRead.getBuildIcon(v), i18n("brightWar_text_22")
		table.insert(nodeInfo, data)
	end
	self:initNodeInfo(nodeInfo)
	self:setRadianceWarBuildingInfo()
	self:setRadianceWarBuildingStataues()
	self.resource_belt:setVisible(true)
	self.buttonResouce = SoraDGetChildByName(self, "Button_resouce")
	if self.buttonResouce then
		self.buttonResouce:addTouchEventListener(handler(self, self.buttonResouceCall))
		table.insert(self.actionBtnList, self.buttonResouce)
	end
	self.buttonLeague = SoraDGetChildByName(self, "Button_league")
	if self.buttonLeague then
		self.buttonLeague:addTouchEventListener(handler(self, self.buttonLeagueCall))
		table.insert(self.actionBtnList, self.buttonLeague)
	end
	self.buttonTerritory = SoraDGetChildByName(self, "Button_alliance_territory")
	if self.buttonTerritory then
		self.buttonTerritory:addTouchEventListener(handler(self, self.buttonTerritoryCall))
		table.insert(self.actionBtnList, self.buttonTerritory)
	end
	for i, v in ipairs(self.actionBtnList) do
		local closeIcon = SoraDGetChildByName(v, "Image_forbidden")
		self.closeIconList[i] = closeIcon
		v:removeFromParent()
		v:addTo(self.actionNode)
		v:setTag(i)
	end
	self.closeIconList[self.buttonLeague:getTag()]:setVisible(not self.isLeagueShow)
	self.closeIconList[self.buttonTerritory:getTag()]:setVisible(not self.isTerritoryShow)
	self:initResourceInfo()
	self.Image_time_bg = SoraDGetChildByName(self, "Image_time_bg")
	self.Text_time = SoraDGetChildByName(self.Image_time_bg, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	local activityStatusTime = radianceActivityCtrl:getWarStatusTime()
	if 86400 < activityStatusTime then
		self.Text_time:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return i18n("brightWar_text_31", nil)
		end)
	else
		self.Text_time:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return i18n("common_text_4235", nil)
		end)
	end
	self.Text_time:setTimeEndListener(function()
		self.Image_time_bg:setVisible(false)
		self:setRadianceWarBuildingStataues()
	end)
	self:updateBtnPosition()
	self:addCloudAction()
	self:setMiniMapInfo()
end
function radianceWarMapView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_MINIMAP", handler(self, self.updateMiniMap))
	SoraDAddMessage(self, "MESSAGE_WORLD_RESOURCEMAP_MOVETOCENTER", handler(self, self.moveSubPointToCenter))
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_MATCH_BACK", handler(self, self.refreshKingdomText))
end
function radianceWarMapView:initData()
	local leftTime = radianceWarUtil.getWarLeftTime()
	_UPVALUE3_ = nil
	;(nil)[1] = radianceActivityCtrl:isWarBattle()
	;(nil)[2] = leftTime
	;(nil)[3] = 0 < leftTime
	dump(nil, "radianceActivityCtrl:isWarBattle() and leftTime and leftTime > 0")
	if radianceActivityCtrl:isWarBattle() and leftTime and 0 < leftTime then
		self.Text_time:beginTime(leftTime)
	else
		self.Image_time_bg:setVisible(false)
	end
	self:refreshKingdomText()
end
function radianceWarMapView:buttonResouceCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isResourceShow = not self.isResourceShow
		self.closeIconList[button:getTag()]:setVisible(not self.isResourceShow)
		self:setResourceInfo()
	end
end
function radianceWarMapView:buttonLeagueCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isLeagueShow = not self.isLeagueShow
		self.closeIconList[button:getTag()]:setVisible(not self.isLeagueShow)
		self:setLeagueInfo(button)
	end
end
function radianceWarMapView:buttonTerritoryCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isTerritoryShow = not self.isTerritoryShow
		self.closeIconList[button:getTag()]:setVisible(not self.isTerritoryShow)
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:radianceWarMapView:isTerritoryShow~bool", self.isTerritoryShow, nil)
		self:setMiniMapInfo()
	end
end
function radianceWarMapView:setMiniMapInfo()
	if self.isTerritoryShow then
		if not self.miniMap then
			self:initMiniMap()
		end
		self.miniMap:setVisible(true)
		local mapId = radianceWarUtil:getWarMapId()
		if worldMapDefine.isRadianceKingdomID(mapId) then
			radianceWarCtrl:reqRadianceWarMinis(mapId)
			SoraDShowLoading(self)
		end
	elseif self.miniMap then
		self.miniMap:setVisible(false)
	end
end
function radianceWarMapView:initMiniMap()
	self.Node_miniMap = SoraDGetChildByName(self, "Node_miniMap")
	local miniMap = include("radianceWarMiniMap").new()
	miniMap:addTo(self.Node_miniMap)
	miniMap:setVisible(self.isTerritoryShow)
	self.miniMap = miniMap
end
function radianceWarMapView:initResourceInfo()
	self.isResourceShow = false
	self.Node_resources_tag = SoraDGetChildByName(self, "Node_resources_tag")
	self.Node_resources_tag:setLocalZOrder(12)
	self.Node_resources_tag:setVisible(true)
	_UPVALUE2_, _UPVALUE3_, self.resourceInfoArray, _ENV = self.Node_resources_tag, self.Node_resources_tag.setVisible, self.Node_resources_tag.setVisible, self.Node_resources_tag.setVisible
	_UPVALUE2_, self.Node_resources_tag[1] = 1, 1
	_UPVALUE2_, self.Node_resources_tag[2] = 1, 4
	_UPVALUE2_, (1)[1] = 3, 3
	_UPVALUE2_, (1)[2] = 3, 6
	;(3)[1] = 7
	;(3)[2] = 8
	self.Node_resources_tag.setVisible[1] = self.Node_resources_tag
	self.Node_resources_tag.setVisible[2] = 1
	local self.Node_resources_tag.setVisible[3], tableLv = 3, self.Node_resources_tag.setVisible
	for i = 1, 3 do
		local resoureName = "Node_resource" .. i
		local resourceInfo = SoraDGetChildByName(self.Node_resources_tag, resoureName)
		resourceInfo:setVisible(self.isResourceShow)
		table.insert(self.resourceInfoArray, resourceInfo)
		_ENV = nil
		;(nil).preLv = tableLv[i][1]
		;(nil).nextLv = tableLv[i][2]
		resourceInfo:getChildByName("Text_info"):setString(i18n("common_text_527", nil))
	end
	local tableNum = radianceWarDef.RADIANCE_PERCENT
	_UPVALUE3_ = 3
	;(3)[1] = "brightWar_text_216"
	;(3)[2] = "brightWar_text_217"
	local (3)[3], tableStr = "brightWar_text_218", 3
	for i = 1, 3 do
		local resoureName = "Node_resource" .. i + 3
		local resourceInfo = SoraDGetChildByName(self.Node_resources_tag, resoureName)
		resourceInfo:setVisible(self.isResourceShow)
		table.insert(self.resourceInfoArray, resourceInfo)
		_ENV = i18n("common_text_527", nil)
		i18n("common_text_527", nil).num = tableNum[i]
		resourceInfo:getChildByName("Text_info"):setString(i18n(tableStr[i], i18n("common_text_527", nil)))
	end
	self:setResourceInfo()
end
function radianceWarMapView:setResourceInfo()
	if self.isResourceShow then
		self:moveMapPointToCenter(cc.p(900, 750))
	end
	self.resource_belt:setVisible(self.isResourceShow)
	for k, v in ipairs(self.resourceInfoArray) do
		_ENV = cc.DelayTime
		cc.DelayTime.delay = 0.15 * k
		function cc.DelayTime.onComplete()
			v:setVisible(self.isResourceShow)
		end
		transition.execute(v, cc.DelayTime:create(0.2), cc.DelayTime)
	end
end
function radianceWarMapView:updateMiniMap(target, data)
	SoraDCloseLoading(self)
	local map = data.map
	if map and self.miniMap then
		self.miniMap:updateMiniMap(map)
	end
end
function radianceWarMapView:setEnterType(enterType)
	self.enterType = enterType
	if "radianceWarMainView" == self.enterType then
		self.nodeTitle:setVisible(true)
		local buttonBackWorld = SoraDGetChildByName(self, "Button_goBack")
		if buttonBackWorld then
			buttonBackWorld:setVisible(false)
		end
	end
end
function radianceWarMapView:viewOnClick(ref, event)
	if event == ccui.TouchEventType.ended and not worldMapDefine.isRadianceKingdomID() and not self.isMoved then
		SoraDPlaySound()
		self.isMoved = false
		local curState = radianceActivityCtrl:getWarStatus()
		if curState and curState ~= RADIANCE_WAR_STATE.BATTLE then
			SoraDShowMsgTip(i18n("common_text_699"))
		else
			SoraDShowMsgTip(i18n("brightWar_text_79"))
		end
		return
	end
	radianceWarMapView.super.viewOnClick(self, ref, event)
end
return radianceWarMapView
