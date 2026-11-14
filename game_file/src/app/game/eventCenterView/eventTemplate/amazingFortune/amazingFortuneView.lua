local amazingFortuneCtrl = SoraDGetCtrl("amazingFortuneCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local publicRead = include("publicRead")
local amazingFortuneView = class("amazingFortuneView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("amazingFortuneView")
	end
	return target
end)
function amazingFortuneView:ctor()
	self.isHideCurrentSceneView = true
	self.itemID = 816401
	self.itemCount = 0
	self.rechargeID = amazingFortuneCtrl:getRechargeID()
	self.activityID = gActivityTimeActivityID.AMAZING_FORTUNE
	self:setBackGround(255)
	self:initWidget()
	self:initData()
	self.Node_buy:setVisible(false)
	amazingFortuneCtrl:sendReqInitMsg()
	paymentManager.OnemtOpenGiftUI(self.rechargeID, gRechargeActiveFromEnum.ROAD13)
end
function amazingFortuneView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshItemCount))
	SoraDAddMessage(self, "MESSAGE_AMAZINGFORTUNE_REFRESH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function()
		if not clientEventMgr.judgeIsOpen(self.activityID) then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
end
function amazingFortuneView:initWidget(...)
	local root = self._ccsView
	local ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_crazyCollection")
	ccs_title:setTitle(i18n("activity_name_21"))
	publicRead = i18n("activity_name_21")
	i18n("activity_name_21")[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(ccs_title, i18n("activity_name_21"))
	self.Button_help:addTouchEventListener(handler(self, self.btn_onClick))
	publicRead = handler(self, self.btn_onClick)
	handler(self, self.btn_onClick)[1] = "Top_Node"
	self.Top_Node = SoraDGetChildByFullPath(root, handler(self, self.btn_onClick))
	publicRead = handler(self, self.btn_onClick)
	handler(self, self.btn_onClick)[1] = "Text_timelast"
	self.Text_timelast = SoraDGetChildByFullPath(self.Top_Node, handler(self, self.btn_onClick))
	publicRead = handler(self, self.btn_onClick)
	handler(self, self.btn_onClick)[1] = "Text_timeleft"
	self.Text_timeleft = SoraDGetChildByFullPath(self.Top_Node, handler(self, self.btn_onClick))
	self.Text_timeleft = SoraDCreateTimerLabel(self, self.Text_timeleft)
	self.Text_timeleft:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_766", nil)
	end)
	function publicRead(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_766", nil)
	end
	;(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_766", nil)
	end)[1] = "Button_record"
	self.Button_record = SoraDGetChildByFullPath(self.Top_Node, function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_766", nil)
	end)
	self.Button_record:setTitleText(i18n("valueTreasure_btn_01"))
	self.Button_record:addTouchEventListener(handler(self, self.btn_onClick))
	publicRead = handler(self, self.btn_onClick)
	handler(self, self.btn_onClick)[1] = "Text_final"
	SoraDGetChildByFullPath(self.Top_Node, handler(self, self.btn_onClick)):setString(i18n("valueTreasure_text_03"))
	publicRead = i18n("valueTreasure_text_03")
	i18n("valueTreasure_text_03")[1] = "frame_final"
	local frame_final = SoraDGetChildByFullPath(self.Top_Node, i18n("valueTreasure_text_03"))
	local iconName = SoraDFIsRA() and "frame_czdb_ar.png" or "frame_czdb_en.png"
	frame_final:setSpriteFrame(iconName)
	publicRead = iconName
	iconName[1] = "Bottom_Node"
	self.Bottom_Node = SoraDGetChildByFullPath(root, iconName)
	publicRead = iconName
	iconName[1] = "Text_more"
	self.Text_more = SoraDGetChildByFullPath(self.Bottom_Node, iconName)
	self.Text_more = SoraDChangeTextToHtml(self.Text_more)
	_ENV = "valueTreasure_text_04"
	;("valueTreasure_text_04").u = true
	;("valueTreasure_text_04").c = true
	local str = SoraDWrapHtmlTagByStyle(i18n("valueTreasure_text_04"), "valueTreasure_text_04")
	self.Text_more:setString(str)
	self.Text_more:setTouchEnabled(true)
	self.Text_more:addTouchEventListener(handler(self, self.btn_onClick))
	publicRead = handler(self, self.btn_onClick)
	handler(self, self.btn_onClick)[1] = "Node_item"
	self.Node_item = SoraDGetChildByFullPath(self.Bottom_Node, handler(self, self.btn_onClick))
	publicRead = handler(self, self.btn_onClick)
	handler(self, self.btn_onClick)[1] = "Text_item"
	SoraDGetChildByFullPath(self.Node_item, handler(self, self.btn_onClick)):setString(i18n("valueTreasure_text_06"))
	publicRead = i18n("valueTreasure_text_06")
	i18n("valueTreasure_text_06")[1] = "Sprite_item"
	self.Sprite_item = SoraDGetChildByFullPath(self.Node_item, i18n("valueTreasure_text_06"))
	self.Sprite_item:setSpriteFrame(publicRead.getIcon(self.itemID))
	self.Sprite_item:setScale(0.4)
	publicRead = 0.4
	;(0.4)[1] = "Text_num"
	self.Text_num = SoraDGetChildByFullPath(self.Node_item, 0.4)
	publicRead = 0.4
	;(0.4)[1] = "Node_list"
	self.Node_list = SoraDGetChildByFullPath(self.Bottom_Node, 0.4)
	publicRead = 0.4
	;(0.4)[1] = "Image_list"
	self.Image_list = SoraDGetChildByFullPath(self.Node_list, 0.4)
	self.Image_list:setTouchEnabled(true)
	self.Image_list:addTouchEventListener(handler(self, self.btn_onClick))
	publicRead = handler(self, self.btn_onClick)
	handler(self, self.btn_onClick)[1] = "Text_list"
	SoraDGetChildByFullPath(self.Node_list, handler(self, self.btn_onClick)):setString(i18n("valueTreasure_title_01"))
	publicRead = i18n("valueTreasure_title_01")
	i18n("valueTreasure_title_01")[1] = "Node_buy"
	self.Node_buy = SoraDGetChildByFullPath(self.Bottom_Node, i18n("valueTreasure_title_01"))
	publicRead = i18n("valueTreasure_title_01")
	i18n("valueTreasure_title_01")[1] = "Button_buy"
	self.Button_buy = SoraDGetChildByFullPath(self.Node_buy, i18n("valueTreasure_title_01"))
	self.Button_buy:addTouchEventListener(handler(self, self.btn_onClick))
	publicRead = handler(self, self.btn_onClick)
	handler(self, self.btn_onClick)[1] = "Text_buy"
	self.Text_buy = SoraDGetChildByFullPath(self.Node_buy, handler(self, self.btn_onClick))
	publicRead = handler(self, self.btn_onClick)
	handler(self, self.btn_onClick)[1] = "Text_price"
	self.Text_price = SoraDGetChildByFullPath(self.Node_buy, handler(self, self.btn_onClick))
	publicRead = handler(self, self.btn_onClick)
	handler(self, self.btn_onClick)[1] = "Text_bottom"
	self.Text_bottom = SoraDGetChildByFullPath(self.Bottom_Node, handler(self, self.btn_onClick))
	self.Text_bottom = SoraDChangeTextToHtml(self.Text_bottom)
	_ENV = "Text_bottom"
	_ENV, _ENV, ("Text_bottom").item = "X1", i18n("rechare_activename_1634") .. "X1", i18n("rechare_activename_1634") .. "X1"
	;("X1").u = true
	;("X1").c = true
	;(i18n("rechare_activename_1634") .. "X1").item, ("X1").name = "X1", "rechare_activename_1634"
	local str = i18n("valueTreasure_text_10") .. i18n_html("valueTreasure_text_11", "Text_bottom", i18n("rechare_activename_1634") .. "X1")
	self.Text_bottom:setString(str)
	self.Text_bottom:setTouchEnabled(true)
	self.Text_bottom:addTouchEventListener(handler(self, self.btn_onClick))
	self.outAppPurchaseButtons = SoraDGetExtendChildFromCCSByName(self, "CCS_outAppPurchaseButtons")
end
function amazingFortuneView:initData(...)
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	local leftTime = activityData.endtime - serviceFunctions.systemTime()
	self.Text_timelast:setString(string.format("%s-%s", os.date("!%Y.%m.%d", activityData.begintime), os.date("!%Y.%m.%d", activityData.endtime)))
	self.Text_timeleft:beginTime(leftTime)
	self:refreshItemCount()
	SoraDToCenter(self.Node_item, 0, SoraDFIsRA())
end
function amazingFortuneView:refreshBuyBtn(state)
	if state == self.state then
		return
	end
	self.state = state
	if state == 1 then
		self.Text_buy:setString(i18n("valueTreasure_btn_02"))
		self.Text_price:setVisible(true)
		local info = paymentManager.getPaymentBullets(self.rechargeID)
		local priceStr, __ = paymentManager.getRealPrice(info.pid, 0.99)
		self.nowPrice = priceStr
		self.oriPrice = i18n("valueTreasure_btn_02")
		self.Text_price:setString(priceStr)
	elseif state == 2 then
		self.Text_buy:setString(i18n("common_text_2580"))
		self.Text_price:setVisible(false)
	else
		self.Text_buy:setString(i18n("valueTreasure_btn_03"))
		self.Text_price:setVisible(false)
		self.Button_buy:setBright(false)
		self.Button_buy:setTouchEnabled(false)
	end
end
function amazingFortuneView:refreshItemCount(...)
	self.itemCount = backpackCtrl:getItemCount(self.itemID)
	self.Text_num:setString(string.format("X%d", self.itemCount))
	self:refreshBuyBtnState()
end
function amazingFortuneView:btn_onClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllAfterPanelFromManager(self, true)
		if button == self.Button_help then
			SoraDShowHelpMsgTip(i18n("valueTreasure_text_02"))
		elseif button == self.Button_record then
			SoraDShowLoading(self)
			SoraDCreatePanel("amazingFortuneRecordPopView"):show()
		elseif button == self.Text_more then
			SoraDCreatePanel("amazingFortuneRewardsPopView"):show()
		elseif button == self.Image_list then
			SoraDShowLoading(self)
			SoraDCreatePanel("amazingFortuneBuyListPopView"):show()
		elseif button == self.Button_buy or button == SoraDGetChildByName(self.outAppPurchaseButtons, "Button_buy") then
			local initData = amazingFortuneCtrl:getInitData()
			if self.itemCount > 0 and initData.drawTimes == 0 then
				SoraDShowLoading(self)
				amazingFortuneCtrl:sendReqDrawMsg()
			elseif not initData.buyGiftList or not next(initData.buyGiftList) then
				paymentManager.OnemtReadyBuy(self.rechargeID, gRechargeActiveFromEnum.ROAD13, nil, nil, nil, self.activityID)
				paymentManager.normalGiftBuyClassify(self.rechargeID)
			end
		elseif button == self.Text_bottom then
			local metaInfo = button:getTouchMetaInfo(button:getTouchEndPosition())
			dump(metaInfo, "metaInfo")
			SoraDCreatePanel("amazingFortuneFinalRewardShow"):show()
		end
	end
end
function amazingFortuneView:refreshView(target, event)
	SoraDCloseLoading(self)
	if "ResultPopView" == event.eventName then
		self:showResultPopView()
	elseif "reqInitBack" == event.eventName then
		self.Node_buy:setVisible(true)
		self:refreshBuyBtnState()
	end
end
function amazingFortuneView:refreshBuyBtnState(...)
	local initData = amazingFortuneCtrl:getInitData()
	local state = 1
	if initData.drawTimes > 0 then
		state = 3
	elseif 0 < self.itemCount then
		state = 2
	else
		state = 1
	end
	self:refreshBuyBtn(state)
	self:updateOutAppPurchase(state == 1)
end
function amazingFortuneView:showResultPopView(...)
	SoraDShowLoading(self, nil, nil, true)
	_ENV = nil
	;(nil).msg = "MESSAGE_AMAZINGFORTUNE_REFRESH"
	;(nil).eventName = "reqInitBack"
	self:refreshView(nil, nil)
	local node = SoraDCreatAnimation("chaozhi", nil, false)
	node:addTo(self, 99)
	node:setPosition(cc.p(display.cx, display.cy))
	_UPVALUE2_ = node
	node[1] = "Node_1"
	node[2] = "Node_2"
	for _, name in ipairs(node) do
		local node = SoraDGetChildByName(node, name)
		for k, v in pairs(node:getChildren()) do
			SoraDMixtureGLONE(v)
		end
	end
	amazingFortuneCtrl = "Node_2"
	;("Node_2")[1] = cca.delay(1.5)
	;("Node_2")[2] = cca.callFunc(function()
		SoraDCloseLoading(self)
		node:removeFromParent()
		SoraDRemoveAllAfterPanelFromManager(self, true)
		local panel = SoraDCreatePanel("amazingFortuneResultPopView")
		panel:initData(amazingFortuneCtrl:getRewardInfo())
		panel:show()
	end)
	;("Node_2")[3] = cca.callFunc(function()
		SoraDCloseLoading(self)
		node:removeFromParent()
		SoraDRemoveAllAfterPanelFromManager(self, true)
		local panel = SoraDCreatePanel("amazingFortuneResultPopView")
		panel:initData(amazingFortuneCtrl:getRewardInfo())
		panel:show()
	end)
	;("Node_2")[4] = cca.callFunc(function()
		SoraDCloseLoading(self)
		node:removeFromParent()
		SoraDRemoveAllAfterPanelFromManager(self, true)
		local panel = SoraDCreatePanel("amazingFortuneResultPopView")
		panel:initData(amazingFortuneCtrl:getRewardInfo())
		panel:show()
	end)
	;("Node_2")[5] = cca.callFunc(function()
		SoraDCloseLoading(self)
		node:removeFromParent()
		SoraDRemoveAllAfterPanelFromManager(self, true)
		local panel = SoraDCreatePanel("amazingFortuneResultPopView")
		panel:initData(amazingFortuneCtrl:getRewardInfo())
		panel:show()
	end)
	;("Node_2")[6] = cca.callFunc(function()
		SoraDCloseLoading(self)
		node:removeFromParent()
		SoraDRemoveAllAfterPanelFromManager(self, true)
		local panel = SoraDCreatePanel("amazingFortuneResultPopView")
		panel:initData(amazingFortuneCtrl:getRewardInfo())
		panel:show()
	end)
	;("Node_2")[7] = cca.callFunc(function()
		SoraDCloseLoading(self)
		node:removeFromParent()
		SoraDRemoveAllAfterPanelFromManager(self, true)
		local panel = SoraDCreatePanel("amazingFortuneResultPopView")
		panel:initData(amazingFortuneCtrl:getRewardInfo())
		panel:show()
	end)
	;("Node_2")[8] = cca.callFunc(function()
		SoraDCloseLoading(self)
		node:removeFromParent()
		SoraDRemoveAllAfterPanelFromManager(self, true)
		local panel = SoraDCreatePanel("amazingFortuneResultPopView")
		panel:initData(amazingFortuneCtrl:getRewardInfo())
		panel:show()
	end)
	;("Node_2")[9] = cca.callFunc(function()
		SoraDCloseLoading(self)
		node:removeFromParent()
		SoraDRemoveAllAfterPanelFromManager(self, true)
		local panel = SoraDCreatePanel("amazingFortuneResultPopView")
		panel:initData(amazingFortuneCtrl:getRewardInfo())
		panel:show()
	end)
	node:runAction(cca.seq("Node_2"))
end
function amazingFortuneView:updateOutAppPurchase(isShow)
	if isShow and SoraDCheckOAPIsOpen(self.rechargeID) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.Bottom_Node)
			self.outAppPurchaseButtons:setPosition(cc.p(320, 110))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.Node_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.rechargeID
		;(false).nowPrice = self.nowPrice
		;(false).oriPrice = self.oriPrice
		_ENV, (false).hideDicountLine = self.oriPrice, true
		self.oriPrice.fromCenter = gRechargeActiveFromEnum.ROAD13
		;(false).logInfo, self.oriPrice.activityID = self.oriPrice, self.activityID
		;(false).handleBuyClick = handler(self, self.btn_onClick)
		self.outAppPurchaseButtons:initData(false)
		_ENV, _UPVALUE1_ = false, self.outAppPurchaseButtons
		;(false).rechargeID = self.rechargeID
		self.outAppPurchaseButtons[1] = false
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, self.Bottom_Node, cc.p(85, 200))
	else
		_ENV, _UPVALUE1_ = self.Bottom_Node, self.outAppPurchaseButtons
		self.Bottom_Node.rechargeID = self.rechargeID
		self.outAppPurchaseButtons[1] = self.Bottom_Node
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, self.Bottom_Node, cc.p(85, 120))
		if self.outAppPurchaseButtons then
			self.outAppPurchaseButtons:setVisible(false)
		end
		self.Node_buy:setVisible(true)
	end
end
return amazingFortuneView
