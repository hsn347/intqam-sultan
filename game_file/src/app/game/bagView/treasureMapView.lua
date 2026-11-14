local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local treasureMapCtrl = gametop.playertop_:getModule("treasureMapCtrl")
local rad = math.rad(22.5)
local r = 150
_ENV, _ENV = nil, nil
;(nil).myCityPos = cc.p(-r, -100)
_ENV, (nil)[1], (nil).treasurePos = nil, nil, cc.p(r * math.cos(rad), 60 + r * math.sin(rad))
;(nil).myCityPos = cc.p(-r, -100)
_ENV, (nil)[2], (nil).treasurePos = nil, nil, cc.p(r * math.sin(rad), 60 + r * math.cos(rad))
;(nil).myCityPos = cc.p(r, -100)
_ENV, (nil)[3], (nil).treasurePos = nil, nil, cc.p(-r * math.sin(rad), 60 + r * math.cos(rad))
;(nil).myCityPos = cc.p(r, -100)
_ENV, (nil)[4], (nil).treasurePos = nil, nil, cc.p(-r * math.cos(rad), 60 + r * math.sin(rad))
;(nil).myCityPos = cc.p(r, 200)
_ENV, (nil)[5], (nil).treasurePos = nil, nil, cc.p(-r * math.cos(rad), 30 - r * math.sin(rad))
;(nil).myCityPos = cc.p(r, 200)
_ENV, (nil)[6], (nil).treasurePos = nil, nil, cc.p(-r * math.sin(rad), 30 - r * math.cos(rad))
;(nil).myCityPos = cc.p(-r, 200)
_ENV, (nil)[7], (nil).treasurePos = nil, nil, cc.p(r * math.sin(rad), 30 - r * math.cos(rad))
;(nil).myCityPos = cc.p(-r, 200)
;(nil)[8], (nil).treasurePos = nil, cc.p(r * math.cos(rad), 30 - r * math.sin(rad))
local mapTypeConfig
local treasureMapView = class("treasureMapView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("treasureMapView")
	end
	return target
end)
function treasureMapView:ctor()
	self:bindBtnClose()
	self:setBackGround(127.5)
	self.starCount = 5
	self.singleReq = 10
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.btnLeft = SoraDGetChildByName(self, "Button_left")
	self.btnRight = SoraDGetChildByName(self, "Button_right")
	self.textPage = SoraDGetChildByName(self, "Text_page")
	self.starsNode = SoraDGetChildByName(self, "Node_stars")
	self.Node_rTime = SoraDGetChildByName(self, "Node_rTime")
	self.Text_remain = SoraDGetChildByName(self, "Text_remain")
	self.Text_remain:setString(i18n("common_text_1663"))
	self.remainTime = SoraDGetChildByName(self, "Text_remainTime")
	self.stars, _ENV, self.remainTime = SoraDCreateTimerLabel(self, self.remainTime), SoraDCreateTimerLabel(self, self.remainTime), SoraDCreateTimerLabel(self, self.remainTime)
	for i = 1, self.starCount do
		self.stars[i] = SoraDGetChildByName(self.starsNode, "icon_star" .. i)
	end
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnGo = SoraDGetChildByName(self, "Button_Go")
	self.btnGo:setTitleText(i18n("common_text_477"))
	self.textTip = SoraDGetChildByName(self, "Text_tip")
	self.btnRefresh = SoraDGetChildByName(self, "Button_refreshPos")
	self.btnRefresh:setTitleText(i18n("common_text_1644"))
	self.btnRefresh:setEnabled(false)
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.nodeTime:setVisible(false)
	self.labTime = SoraDGetChildByName(self.nodeTime, "Text_time")
	self.labTime = SoraDCreateTimerLabel(self, self.labTime)
	self.treasure = SoraDGetChildByName(self, "icon_teasure")
	self.myCity = SoraDGetChildByName(self, "sprite_myCity")
	self.Text_boxPos = SoraDGetChildByName(self, "Text_boxPos")
	self.Text_boxPos:setString(i18n("tresure_text_01"))
	self.Text_pos = SoraDGetChildByName(self, "Text_pos")
	self.btnLeft:addTouchEventListener(handler(self, self.turnLeft))
	self.btnRight:addTouchEventListener(handler(self, self.turnRight))
	self.btnHelp:addTouchEventListener(handler(self, self.showHelp))
	self.btnGo:addTouchEventListener(handler(self, self.gotoWorldMap))
	self.btnRefresh:addTouchEventListener(handler(self, self.refreshInfo))
end
function treasureMapView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_TREASUREMAP_INFO_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_TREASUREMAP_REFRESH_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_TREASUREMAP_DELETE_BACK", handler(self, self.refreshData))
end
function treasureMapView:initData()
	SoraDCloseLoading(self)
	self.data = treasureMapCtrl:getTreasureMapDataByIndex(self.curPage)
	if self.data and next(self.data) then
		if self.data.x == 9999 or self.data.y == 9999 then
			treasureMapCtrl:sendRefresh(self.curPage)
		end
		local quality = self.data.quality
		_ENV = nil
		;(nil).lv = quality
		self.Text_title:setString(i18n("tresure_text_02", nil))
		for i = 1, self.starCount do
			self.stars[i]:setSpriteFrame(quality >= i and "icon_star1_01.png" or "icon_star1_02.png")
		end
		self.remainTime:beginTime(self.data.disappearLeftTime)
		SoraDToCenter(self.Node_rTime)
		self.Text_pos:setString(self.data.x .. "," .. self.data.y)
		if self.data.isMarch then
			self.btnGo:setBright(false)
			self.btnGo:setEnabled(false)
			self.btnRefresh:setEnabled(false)
			self.btnRefresh:setBright(false)
			self.btnRefresh:setTitleColor(cc.c3b(120, 120, 120))
			self.nodeTime:setVisible(false)
			self.textTip:setString(i18n("common_text_1645"))
		else
			if not self.data.isEndCD then
				self.btnRefresh:setEnabled(false)
				self.btnRefresh:setBright(false)
				self.btnRefresh:setTitleColor(cc.c3b(120, 120, 120))
				self.nodeTime:setVisible(true)
				self.labTime:beginTime(self.data.refreshLeftTime)
				SoraDToCenter(self.nodeTime)
			else
				self.btnRefresh:setEnabled(true)
				self.btnRefresh:setBright(true)
				self.btnRefresh:setTitleColor(cc.c3b(255, 255, 255))
				self.nodeTime:setVisible(false)
			end
			self.btnGo:setBright(true)
			self.btnGo:setEnabled(true)
			self.textTip:setString(i18n("common_text_1646"))
		end
		self.textPage:setString(self.curPage .. "/" .. self.treasureMapCount)
		local mType = self.data.treasureMapType
		self.myCity:setPosition(mapTypeConfig[mType].myCityPos)
		self.treasure:setPosition(mapTypeConfig[mType].treasurePos)
	end
end
function treasureMapView:setItemCount(itemID)
	self.itemID = itemID
	self.treasureMapCount = backpackCtrl:getItemCount(self.itemID) or 0
	self.curPage = 1
	local reqCount = self.treasureMapCount
	if reqCount > self.singleReq then
		reqCount = self.singleReq
	end
	self.reqedList, backpackCtrl = self.singleReq, self.singleReq
	for i = self.curPage, reqCount do
		table.insert(self.reqedList, i)
	end
	treasureMapCtrl:sendTreasureMapByRange(self.curPage, reqCount)
	SoraDShowLoading(self)
end
function treasureMapView:refreshData(target, data)
	self.treasureMapCount = backpackCtrl:getItemCount(self.itemID) or 0
	if self.treasureMapCount < 1 then
		self:removeFromParent()
	else
		self:setItemCount(self.itemID)
	end
end
function treasureMapView:turnLeft(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.curPage = self.curPage - 1
		if self.curPage < 1 then
			self.curPage = self.treasureMapCount
		end
		if not SoraDisInList(self.curPage, self.reqedList) then
			treasureMapCtrl:sendTreasureMapByRange(self.curPage - self.singleReq, self.curPage)
			for i = self.curPage - self.singleReq, self.curPage do
				table.insert(self.reqedList, i)
			end
			SoraDShowLoading(self)
		end
		self:initData()
	end
end
function treasureMapView:turnRight(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.curPage = self.curPage + 1
		if self.curPage > self.treasureMapCount then
			self.curPage = 1
		end
		local endIndex = self.curPage + self.singleReq - 1
		if endIndex > self.treasureMapCount then
			endIndex = self.treasureMapCount
		end
		if not SoraDisInList(self.curPage, self.reqedList) then
			treasureMapCtrl:sendTreasureMapByRange(self.curPage, endIndex)
			for i = self.curPage, endIndex do
				table.insert(self.reqedList, i)
			end
			SoraDShowLoading(self)
		end
		self:initData()
	end
end
function treasureMapView:showHelp(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_1173"
		;("common_text_1173")[1] = i18n("common_text_1643")
		;("common_text_1173")[2] = i18n("common_text_1643")
		SoraDShowFixWindow(i18n("common_text_1173"), "common_text_1173")
	end
end
function treasureMapView:gotoWorldMap(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).x = self.data.x
		;(nil).y = self.data.y
		SoraDGotoWorldMapPoint(nil, true)
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(1)
		;(nil)[2] = cca.callFunc(function()
			SoraDRemoveAllPanelFromManager()
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			mildGuideManager:starToOccupy()
		end)
		;(nil)[3] = cca.callFunc(function()
			SoraDRemoveAllPanelFromManager()
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			mildGuideManager:starToOccupy()
		end)
		local seq = cca.seq(nil)
		self:runAction(seq)
	end
end
function treasureMapView:refreshInfo(button, type)
	if type == ccui.TouchEventType.ended then
		treasureMapCtrl:sendRefresh(self.curPage)
	end
end
return treasureMapView
