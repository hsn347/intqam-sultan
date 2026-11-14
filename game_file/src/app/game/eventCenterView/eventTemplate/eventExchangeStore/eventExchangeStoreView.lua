local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local exchangeMallCtrl = gametop.playertop_:getModule("exchangeMallCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local publicRead = include("publicRead")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local eventExchangeStoreView = class("eventExchangeStoreView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventExchangeStoreView")
	end
	return target
end)
local panelHeight = 244
local foreverTime = 315360000
function eventExchangeStoreView:ctor()
	self.itemTips = nil
	self.mallData, _ENV, self.singleIsMoved = nil, nil, false
	self.activityID = gActivityTimeActivityID.EXCHANGE_MALL
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.ccs_title:setTitle(i18n("common_text_1809"))
	self.node_item = SoraDGetChildByName(self, "Node_item")
	self.icon_item = SoraDGetChildByName(self.node_item, "icon_item")
	self.Text_num = SoraDGetChildByName(self.node_item, "Text_num")
	self.topNodeLine = SoraDGetChildByName(self, "Top_Node_line")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_items")
	self.nodeSingle = SoraDGetChildByName(self, "node_single")
	self.exchange_icon = SoraDGetChildByName(self, "exchange_icon")
	self.text_own = SoraDGetChildByName(self, "text_own")
	self.btnClick = SoraDGetChildByName(self, "btn_click")
	self.btnDetail = SoraDGetChildByName(self, "btn_detail")
	SoraDGetChildByName(self, "Image_tile_line"):setFillType(1)
	self.btnClick:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnDetail:addTouchEventListener(handler(self, self.btnDetailCallBack))
	self:addFire()
	self:initData()
end
function eventExchangeStoreView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.refreshRed))
end
function eventExchangeStoreView:addFire()
	self.Node_fire_L = SoraDGetChildByName(self, "Node_fire_L")
	local nodeFireL = _G.SoraDGetCommonJetFireNode(true)
	nodeFireL:setPosition(cc.p(-280, 80))
	nodeFireL:addTo(self.topNodeLine, 10)
	self.Node_fire_R = SoraDGetChildByName(self, "Node_fire_R")
	local nodeFireR = _G.SoraDGetCommonJetFireNode(true)
	nodeFireR:setPosition(cc.p(280, 80))
	nodeFireR:addTo(self.topNodeLine, 10)
end
function eventExchangeStoreView:initData()
	self:sortData()
	self:initScroll()
end
function eventExchangeStoreView:sortData()
	self.mallData, _ENV = nil, nil
	for i, v in ipairs(exchangeMallActivityID) do
		local state = activityShowCtrl:getStateByID(v)
		if state == gActivityState.OPEN then
			if not self.mallData[v] then
				self.mallData[v], _ENV = v, v
			end
			local remainTime = 0
			if activityShowCtrl:getTimeInfoByID(v) then
				remainTime = activityShowCtrl:getTimeInfoByID(v).timerNode.timer:getRemainTime()
			end
			local shopData = exchangeMallCtrl:getConfigByActivityID(v)
			self.mallData[v].state = state
			self.mallData[v].remainTime = remainTime
			self.mallData[v].shopData = shopData
			self.mallData[v].activityID = v
		end
	end
	self.mallData = serviceFunctions.mapConvertArrayAndSort(self.mallData, function(a, b)
		if a.state == b.state then
			if a.remainTime == b.remainTime then
				return a.activityID < b.activityID
			else
				return a.remainTime > b.remainTime
			end
		else
			return a.state > b.state
		end
	end)
	dump(self.mallData, "sakdfjsdkjfdsjkf", 10)
end
function eventExchangeStoreView:refreshRed(target, data)
	dump(data, "eventExchangeStoreView:refreshRed", 10)
	for i, v in ipairs(self.mallData) do
		if data.eventID == v.activityID then
			local cell = self.scroll:getChildByTag(v.activityID)
			local imageRed = SoraDGetChildByName(cell, "Image_Red")
			local ret, num = exchangeMallCtrl:getReceiveStatusAndNum(v.activityID)
			imageRed:setVisible(ret)
		end
	end
end
function eventExchangeStoreView:initScroll()
	self.scroll:removeAllChildren()
	local scrollH = math.max(#self.mallData * panelHeight, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(display.width, scrollH))
	for i, v in ipairs(self.mallData) do
		local cell = self.nodeSingle:clone()
		local cellBtn = SoraDGetChildByName(cell, "btn_click")
		local cellBg = SoraDGetChildByName(cell, "bg_single")
		local cellIcon = SoraDGetChildByName(cell, "bg_exchange_9001129_ar_154")
		local txtState = SoraDGetChildByName(cell, "text_state")
		local Node_icon = SoraDGetChildByName(cell, "Node_icon")
		local cellBtnDetail = SoraDGetChildByName(cell, "btn_detail")
		local imageRed = SoraDGetChildByName(cell, "Image_Red")
		local ret, num = exchangeMallCtrl:getReceiveStatusAndNum(v.activityID)
		imageRed:setVisible(ret)
		txtState = SoraDCreateTimerLabel(self, txtState)
		cell:setPosition(cc.p(self.scroll:getContentSize().width / 2, scrollH - (i - 1) * panelHeight))
		cell:addTo(self.scroll)
		cell:setTag(v.activityID)
		cellBtn:setTag(v.activityID)
		cellBtn:setSwallowTouches(false)
		local addStr = ""
		if v.activityID == 9001212 and not IsArClient then
			addStr = "_ros"
		end
		local bgName = string.format("bg_exchange_%d" .. addStr .. ".png", v.activityID)
		cellBg:setSpriteFrame(bgName)
		if v.activityID == 9001213 and not IsArClient then
			addStr = "_ros"
		end
		local exchangeItemID, costIDArray = exchangeMallCtrl:getCostIDByActivityID(v.activityID)
		exchangeMallCtrl = v.activityID
		v.activityID[1] = "ar"
		v.activityID[2] = "en"
		local iconName = SoraDGetImageNameByLang("bg_exchange_" .. v.activityID .. "_%s" .. addStr .. ".png", v.activityID)
		cellIcon:setSpriteFrame(iconName)
		cellIcon:setScale(0.9)
		local activityState = v.state
		local activityRemainTime = v.remainTime
		if activityState == gActivityState.OPEN then
			if activityRemainTime >= foreverTime then
				txtState:setString(i18n("shop_text_11"))
			else
				txtState:setTimeLast(function(str)
					_ENV = nil
					;(nil).Time = str
					return i18n("shop_text_12", nil)
				end)
				txtState:beginTime(activityRemainTime)
				txtState:setTimeEndListener(function(...)
					self:initData()
				end)
			end
			txtState:setColor(cc.c3b(0, 255, 0))
		elseif activityState == gActivityState.PREPARE then
			txtState:setTimeLast(function(str)
				_ENV = nil
				;(nil).Time = str
				return i18n("shop_text_13", nil)
			end)
			txtState:beginTime(activityRemainTime)
			txtState:setTimeEndListener(function(...)
				self:initData()
			end)
		elseif activityState == gActivityState.CLOSE then
			txtState:setString(i18n("shop_text_14"))
		end
		local costID = exchangeMallCtrl:getCostIDByActivityID(v.activityID)
		cellBtnDetail:setTag(costID or 0)
		cellBtnDetail:setEnabled(v.activityID ~= gActivityTimeActivityID.EXCHANGE_MALL_DRESS_ROLL)
		local suitScale = 1 < #costIDArray and 0.8 or 1.0
		if not IsArClient and suitScale < 1.0 then
			suitScale = 0.6
		end
		Node_icon:setScale(suitScale)
		if costIDArray and 1 <= #costIDArray then
			for k, v in ipairs(costIDArray) do
				local icon = self.exchange_icon:clone()
				local textOwn = self.text_own:clone()
				icon:setPosition(0, 0)
				icon:addTo(Node_icon)
				textOwn:setPosition(0, 0)
				textOwn:addTo(Node_icon)
				local count = backpackCtrl:getItemCount(v)
				icon:loadTexture(publicRead.getIcon(v), ccui.TextureResType.plistType)
				_ENV = i18n("shop_text_14")
				i18n("shop_text_14").count = count
				textOwn:setString(i18n("common_text_1377", i18n("shop_text_14")))
			end
		end
		SoraDToCenter(Node_icon):setVisible(v.activityID ~= gActivityTimeActivityID.EXCHANGE_MALL_DRESS_ROLL)
	end
end
function eventExchangeStoreView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local activityState = gActivityState.CLOSE
		for i, v in ipairs(self.mallData) do
			if button:getTag() == v.activityID then
				activityState = v.state
				break
			end
		end
		if activityState == gActivityState.OPEN then
			local panel = SoraDCreatePanel("eventKMExchangeStoreView")
			panel:setActivityID(button:getTag())
			panel:show()
		else
			SoraDShowMsgTip(i18n("shop_text_10"))
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function eventExchangeStoreView:btnDetailCallBack(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		if self.pFloor then
			self.pFloor:removeFromParent()
			self.pFloor = nil
		end
	elseif type == ccui.TouchEventType.began and not self.pFloor then
		local pos = self:convertToNodeSpace(button:getTouchBeganPosition())
		self:openItem(button, pos)
	end
end
function eventExchangeStoreView:openItem(item, pos)
	self.pFloor = SoraDCreatePanel("commonItemTips")
	self.pFloor:initData(item:getTag())
	if SoraDFIsRA() then
		if pos.x < 280 then
			self.pFloor:setPosition(pos.x + 280, pos.y + 100)
		else
			self.pFloor:setPosition(pos.x, pos.y + 100)
		end
	elseif pos.x > 360 then
		self.pFloor:setPosition(pos.x - 280, pos.y + 100)
	else
		self.pFloor:setPosition(pos.x, pos.y + 100)
	end
	self.pFloor:addTo(self, 100)
end
function eventExchangeStoreView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	else
		self:initData()
	end
end
function eventExchangeStoreView:onExitPanel()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	;(nil).eventID = self.activityID
	SoraDSendMessage(nil)
end
return eventExchangeStoreView
