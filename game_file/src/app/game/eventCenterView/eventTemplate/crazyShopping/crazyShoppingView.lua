local gametop = gModuleMgr.getObject("gametop")
local crazyShoppingCtrl = gametop.playertop_:getModule("crazyShoppingCtrl")
local crazyShoppingRead = include("crazyShoppingRead")
local crazyShoppingView = class("crazyShoppingView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("crazyShoppingView")
	end
	return target
end)
function crazyShoppingView:closePanel(...)
	SoraDRemoveAllAfterPanelFromManager(self, true)
	include("basePanel").closePanel(self)
end
function crazyShoppingView:onEnterPanel(...)
	crazyShoppingCtrl:sendReqBuyInfo()
end
function crazyShoppingView:ctor()
	self.itemList, _UPVALUE0_ = nil, nil
	self:initWidget()
	self:addMessage()
	self:initData()
end
local HEIGHT_OF_DISK = 622
function crazyShoppingView:initWidget(...)
	self.Top_Image_cut = SoraDGetChildByName(self, "Top_Image_cut")
	SoraChangeSpriteImage(self.Top_Image_cut, "bg_activity_king_road.png")
	self.Top_Image_cut:setScale(display.height / self.Top_Image_cut:getContentSize().height)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("crazyshopping_text_01"))
	self.nodeTitle.title:ignoreContentAdaptWithSize(false)
	self.nodeTitle.title:setContentSize(cc.size(350, 70))
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	HEIGHT_OF_DISK = "CCS_commonGoldTop_gold"
	;("CCS_commonGoldTop_gold")[1] = "Text_time"
	self.labReturnTime = SoraDGetChildByFullPath(self.Top_Node, "CCS_commonGoldTop_gold")
	self.labReturnTime = SoraDCreateTimerLabel(self, self.labReturnTime)
	self.labReturnTime:setTimeLast(function(ticket)
		return i18n("common_text_2669") .. ticket
	end)
	self.labReturnTime:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end)
	function HEIGHT_OF_DISK()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end
	;(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end)[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.Top_Node, function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end)
	self.Button_help:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.CRAZY_SHOPPING)
	end)
	self.Center_Node_disk = SoraDGetChildByName(self, "Center_Node_disk")
	HEIGHT_OF_DISK = "Center_Node_disk"
	;("Center_Node_disk")[1] = "Node_day_4"
	self.Node_day_4 = SoraDGetChildByFullPath(self.Center_Node_disk, "Center_Node_disk")
	self.Node_day_4:setVisible(false)
	self.Panel_1 = SoraDGetChildByName(self.Center_Node_disk, "Panel_1")
	self.frame_ChooseNode = SoraDGetChildByName(self.Center_Node_disk, "frame_ChooseNode")
	self.choose_Node = SoraDGetChildByName(self.Center_Node_disk, "choose_Node")
	HEIGHT_OF_DISK = "choose_Node"
	;("choose_Node")[1] = "frame_disk"
	self.frame_disk = SoraDGetChildByFullPath(self.Center_Node_disk, "choose_Node")
	HEIGHT_OF_DISK = "choose_Node"
	;("choose_Node")[1] = "Text_1"
	self.text_BoxNum = SoraDGetChildByFullPath(self.frame_disk, "choose_Node")
	self.Panel_1:setLocalZOrder(2)
	self.frame_ChooseNode:setLocalZOrder(2)
	self.frame_disk:setLocalZOrder(3)
	self.choose_Node:setLocalZOrder(4)
	HEIGHT_OF_DISK = 4
	;(4)[1] = "crazyBoxButton"
	self.crazyBoxButton = SoraDGetChildByFullPath(self.frame_disk, 4)
	HEIGHT_OF_DISK = 4
	;(4)[1] = "crazyBoxNum"
	self.crazyBoxNum = SoraDGetChildByFullPath(self.frame_disk, 4)
	self.crazyBoxButton:setTag(853201)
	self.crazyBoxButton:setSwallowTouches(false)
	self.crazyBoxButton:setPressedActionEnabled(false)
	self.crazyBoxButton:addTouchEventListener(handler(self, self.showDetail))
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.Text_23 = SoraDGetChildByName(self, "Text_23")
	self.Text_23:setString(i18n("crazyshopping_text_05"))
	HEIGHT_OF_DISK = i18n("crazyshopping_text_05")
	i18n("crazyshopping_text_05")[1] = "ScrollView_1"
	self.scroll = SoraDGetChildByFullPath(self.Bottom_Node, i18n("crazyshopping_text_05"))
	HEIGHT_OF_DISK = i18n("crazyshopping_text_05")
	i18n("crazyshopping_text_05")[1] = "Node_info"
	self.Node_info = SoraDGetChildByFullPath(self.Bottom_Node, i18n("crazyshopping_text_05"))
	HEIGHT_OF_DISK = i18n("crazyshopping_text_05")
	i18n("crazyshopping_text_05")[1] = "Bottom_Node_fire"
	self.bottomFireNode = SoraDGetChildByFullPath(self.Bottom_Node, i18n("crazyshopping_text_05"))
	HEIGHT_OF_DISK = i18n("crazyshopping_text_05")
	i18n("crazyshopping_text_05")[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.Node_info, i18n("crazyshopping_text_05"))
	HEIGHT_OF_DISK = i18n("crazyshopping_text_05")
	i18n("crazyshopping_text_05")[1] = "Node_show"
	self.Node_show = SoraDGetChildByFullPath(self.Node_info, i18n("crazyshopping_text_05"))
	HEIGHT_OF_DISK = i18n("crazyshopping_text_05")
	i18n("crazyshopping_text_05")[1] = "Node_show_2"
	self.Node_show_2 = SoraDGetChildByFullPath(self.Node_show, i18n("crazyshopping_text_05"))
	HEIGHT_OF_DISK = i18n("crazyshopping_text_05")
	i18n("crazyshopping_text_05")[1] = "Text_5"
	self.labGold_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("crazyshopping_text_05"))
	HEIGHT_OF_DISK = i18n("crazyshopping_text_05")
	i18n("crazyshopping_text_05")[1] = "Sprite_gold_4"
	self.sprite_Gold_box = SoraDGetChildByFullPath(self.Node_show_2, i18n("crazyshopping_text_05"))
	HEIGHT_OF_DISK = i18n("crazyshopping_text_05")
	i18n("crazyshopping_text_05")[1] = "Node_invest"
	self.Node_invest = SoraDGetChildByFullPath(self.Node_info, i18n("crazyshopping_text_05"))
	HEIGHT_OF_DISK = i18n("crazyshopping_text_05")
	i18n("crazyshopping_text_05")[1] = "button_invest"
	self.button_invest = SoraDGetChildByFullPath(self.Node_invest, i18n("crazyshopping_text_05"))
	self.button_invest:addTouchEventListener(handler(self, self.btnInvestCallback))
	HEIGHT_OF_DISK = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_gold"
	self.labInvestGold = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	HEIGHT_OF_DISK = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_des"
	self.labInvest = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	self.labInvest = SoraDCreateTimerLabel(self, self.labInvest)
	self.labInvest:setTimeEndListener(function()
		self:closePane()
	end)
	function HEIGHT_OF_DISK()
		self:closePane()
	end
	;(function()
		self:closePane()
	end)[1] = "Text_gold"
	self.Text_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		self:closePane()
	end)
	function HEIGHT_OF_DISK()
		self:closePane()
	end
	;(function()
		self:closePane()
	end)[1] = "Sprite_gold"
	self.Sprite_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		self:closePane()
	end)
	self:addDoubleFireEffect()
	local heightDisk = self.Center_Node_disk:getPositionY() - self.bottomFireNode:getPositionY() - 115
	if heightDisk < HEIGHT_OF_DISK then
		self.Center_Node_disk:setScale(heightDisk / HEIGHT_OF_DISK)
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - (115 - 115 * heightDisk / HEIGHT_OF_DISK))
	else
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - (heightDisk - HEIGHT_OF_DISK) / 2)
	end
end
function crazyShoppingView:addMessage(...)
	SoraDAddMessage(self, "MESSAGE_CRAZYSHOPPING_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		self:initData()
		self:showRewards()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
end
function crazyShoppingView:initData(...)
	self.curDay = crazyShoppingCtrl:getCurDay()
	if self.chooseDay == nil then
		self.chooseDay = self.curDay
	end
	self.investGold = crazyShoppingRead.getInvestGold(self.chooseDay)
	crazyShoppingCtrl = nil
	;(nil).Day = self.chooseDay
	self.Text_1:setString(i18n("crazyshopping_text_04", nil))
	for i = 1, 7 do
		local singleItem = self.itemList[i]
		if not singleItem then
			singleItem = self:createSingleItem(i)
			singleItem:addTo(self.Node_day_4:getParent(), 1)
			singleItem:setVisible(true)
			self.itemList[i] = singleItem
		end
		singleItem.initData(self.curDay)
	end
	local angle = (self.chooseDay - 4) * 360 / 7
	self.choose_Node:setRotation(angle)
	self.frame_ChooseNode:setRotation(angle)
	self.labInvestGold:setString(string.formatnumberthousands(self.investGold))
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local rTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.CRAZY_SHOPPING_ACTIVITY)
	if rTime then
		self.labReturnTime:beginTime(rTime.timerNode.timer:getRemainTime())
	end
	self.Button_help:setPositionX(self.labReturnTime:getPositionX() + self.labReturnTime:getContentSize().width / 2 + 30)
	local iTime = crazyShoppingCtrl:getInvestLeftTime()
	self.labInvest:beginTime(iTime)
	self:initScroll()
	if crazyShoppingCtrl:checkHasInvest(self.chooseDay) then
		self.labInvest:setString(i18n("common_text_3833"))
		self.labInvest:setTimeLast(function(ticket)
			return i18n("common_text_3833")
		end)
	else
		self.labInvest:setString(string.format("%s(%s)", i18n("crazyshopping_text_06"), SoraDConvertSecondToString(iTime)))
		self.labInvest:setTimeLast(function(ticket)
			return string.format("%s(%s)", i18n("crazyshopping_text_06"), ticket)
		end)
	end
	if crazyShoppingCtrl:checkHasInvest(self.chooseDay) then
		self.Node_invest:setVisible(false)
	elseif self.chooseDay < self.curDay then
		self.Node_invest:setVisible(true)
	elseif self.chooseDay == self.curDay then
		self.Node_invest:setVisible(true)
	elseif self.chooseDay > self.curDay then
		self.Node_invest:setVisible(false)
	end
	local itemDesRead = include("itemDesRead")
	crazyShoppingCtrl = string.format("%s(%s)", i18n("crazyshopping_text_06"), SoraDConvertSecondToString(iTime))
	string.format("%s(%s)", i18n("crazyshopping_text_06"), SoraDConvertSecondToString(iTime)).Num = crazyShoppingCtrl:getCrazyBoxNum()
	self.text_BoxNum:setString(i18n("crazyshopping_text_03", string.format("%s(%s)", i18n("crazyshopping_text_06"), SoraDConvertSecondToString(iTime))))
	self.Text_23:setVisible(crazyShoppingRead.showDiscount(self.chooseDay))
	local textDiscount = SoraDGetChildByName(self, "discount")
	textDiscount:setString(math.floor(crazyShoppingRead.getDiscount(self.chooseDay)) .. "%")
	local width_1 = textDiscount:getContentSize().width
	local width_2 = self.Text_23:getContentSize().width
	local width_3 = (width_1 + width_2 - 50) / 2
	self.Text_23:setPositionX(320 - width_3 + width_2)
	textDiscount:setPositionX(self.Text_23:getPositionX())
	if crazyShoppingCtrl:getCrazyBoxNum() == 0 then
		self.labGold_4:setString(i18n("+2"))
		self.labGold_4:setPositionX(5)
		self.sprite_Gold_box:setPositionX(-5)
	else
		self.labGold_4:setString(i18n("Doublex200%"))
		self.labGold_4:setPositionX(-85)
		self.sprite_Gold_box:setPositionX(-95)
	end
end
function crazyShoppingView:createSingleItem(day)
	local node = self.Node_day_4:clone()
	crazyShoppingCtrl = nil
	;(nil)[1] = "frame_bg"
	node.frame_bg = SoraDGetChildByFullPath(node, nil)
	crazyShoppingCtrl = nil
	;(nil)[1] = "Node_day"
	node.Node_day = SoraDGetChildByFullPath(node, nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "Node_day"
	;(nil)[2] = "Text_1"
	node.Text_1 = SoraDGetChildByFullPath(node, nil)
	node.Text_1:setVisible(false)
	local numChar = cc.Label:createWithCharMap("fonts/font_svip.png", 25, 36, 48)
	numChar:addTo(node.Text_1:getParent())
	numChar:setPosition(node.Text_1:getPosition())
	_UPVALUE2_ = node.Text_1:getPosition()
	node.Text_1:getPosition()[1] = "Node_day"
	node.Text_1:getPosition()[2] = "Text_2"
	node.Text_2 = SoraDGetChildByFullPath(node, node.Text_1:getPosition())
	local angle = (day - 4) * 360 / 7
	node:setRotation(angle)
	node.Node_day:setRotation(-angle)
	util.addTouch(node.frame_bg, handlerEx(self, self.btnShowClick, day), false, nil, util.hitAlphaTest)
	node.day = day
	function node.initData(_curDay)
		local day = node.day
		if crazyShoppingCtrl:checkHasInvest(day) then
			node.frame_bg:loadTexture("frame_zwjj5.png", ccui.TextureResType.plistType)
			node.Text_2:setString(string.format([[
DAY
(%s)]], i18n("common_text_3833")))
			node.Text_2:setColor(cc.c3b(112, 112, 112))
			numChar:setString(day)
			numChar:setColor(cc.c3b(112, 112, 112))
		elseif _curDay > day then
			node.frame_bg:loadTexture("frame_zwjj3.png", ccui.TextureResType.plistType)
			node.Text_2:setString(string.format([[
DAY
(%s)]], i18n("crazyshopping_text_02")))
			node.Text_2:setColor(cc.c3b(255, 167, 53))
			numChar:setString(day)
		elseif day == _curDay then
			node.frame_bg:loadTexture("frame_zwjj4.png", ccui.TextureResType.plistType)
			node.Text_2:setString(string.format([[
DAY
(%s)]], i18n("common_text_3826")))
			node.Text_2:setColor(cc.c3b(255, 204, 0))
			numChar:setString(day)
		elseif _curDay < day then
			node.frame_bg:loadTexture("frame_zwjj2.png", ccui.TextureResType.plistType)
			node.Text_2:setString(string.format([[
DAY
(%s)]], i18n("new_lord_fund_text_08")))
			node.Text_2:setColor(cc.c3b(173, 173, 173))
			numChar:setString(day)
		end
	end
	return node
end
function crazyShoppingView:initScroll(...)
	self.scroll:removeAllChildren()
	local rewards = crazyShoppingRead.getInvestRewards(self.chooseDay)
	local rCount = #rewards / 2
	local itemW = 110
	local sSize = self.scroll:getContentSize()
	local scrollW = math.max(sSize.width, itemW * rCount)
	self.scroll:setInnerContainerSize(cc.size(scrollW, sSize.height))
	self.scroll:setBounceEnabled(5 < rCount)
	for i = 1, rCount do
		local singleItem = include("itemSingleView").new()
		singleItem:setPosition(cc.p(itemW * (i - 1), sSize.height))
		singleItem:addTo(self.scroll)
		singleItem:setScale(0.7)
		crazyShoppingRead, crazyShoppingRead = cc.p(itemW * (i - 1), sSize.height)
		cc.p(itemW * (i - 1), sSize.height).id = rewards[2 * i - 1]
		;(0.7).itemData, cc.p(itemW * (i - 1), sSize.height).count = cc.p(itemW * (i - 1), sSize.height)
		singleItem:initData(0.7)
		singleItem:setButtonTag(rewards[2 * i - 1])
		singleItem:setItemClickCallback(handler(self, self.showDetail))
	end
end
TOUCH_MOVED_CANCELD_VALUE = 100
function crazyShoppingView:showDetail(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		button:stopAllActions()
		SoraDCloseCommonTips()
	elseif type == ccui.TouchEventType.began then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.2)
		;(nil)[2] = cca.callFunc(function()
			SoraDShowCommonTips(button, button:getTag())
		end)
		;(nil)[3] = cca.callFunc(function()
			SoraDShowCommonTips(button, button:getTag())
		end)
		button:runAction(cca.seq(nil))
	elseif type == ccui.TouchEventType.moved then
		local beginPos = button:getTouchBeganPosition()
		local movePos = button:getTouchMovePosition()
		local distance = cc.pGetDistance(beginPos, movePos)
		if tonumber(distance) > TOUCH_MOVED_CANCELD_VALUE then
			self:showDetail(button, ccui.TouchEventType.canceled)
		end
	end
end
function crazyShoppingView:addDoubleFireEffect()
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_flame1_display.plist"
	;(nil).x = 33
	_ENV, (nil).pos, (nil).y = nil, nil, 48
	;(nil).x = 1.5
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1.5
	_ENV, (nil).plist = nil, "et_flame2_display.plist"
	;(nil).x = 33
	_ENV, (nil).pos, (nil).y = nil, nil, 78
	;(nil).x = 2.5
	_ENV, (nil)[2], (nil).scale, (nil).y = nil, nil, nil, 2.5
	_ENV, (nil).plist = nil, "et_flame3_display.plist"
	;(nil).x = 33
	;(nil)[3], (nil).pos, (nil).y = nil, nil, 48
	local param
	local parNode1 = SoraDCreateEffectNode(param)
	parNode1:addTo(SoraDGetChildByName(self, "frame_lace_base_1"), -2)
	local parNode2 = SoraDCreateEffectNode(param)
	parNode2:addTo(SoraDGetChildByName(self, "frame_lace_base_2"), -2)
end
function crazyShoppingView:checkInvestCond(...)
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.CRAZY_SHOPPING_ACTIVITY)
	if state ~= gActivityState.OPEN then
		SoraDShowMsgTip(i18n("common_text_1859"))
		self:closePanel()
	end
	if self.chooseDay and self.chooseDay > self.curDay then
		SoraDShowMsgTip(i18n("crazyshopping_tips_01"))
		return
	end
	if crazyShoppingCtrl:checkHasInvest(self.chooseDay) then
		SoraDShowMsgTip(i18n("crazyshopping_tips_02"))
		return
	end
	if not SoraDEnoughGold(self.investGold) then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
		return
	end
	return true
end
function crazyShoppingView:btnInvestCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self:checkInvestCond() then
			return
		end
		_ENV = nil
		;(nil).Gold = self.investGold
		SoraDShowMsgBox(i18n("crazyshopping_tips_03", nil), i18n("common_text_204"), nil, function(type)
			if type ~= MSGBOX_CALLBACK_YES then
				return
			end
			if not self:checkInvestCond() then
				return
			end
			_ENV = nil
			;(nil).buyDay = self.chooseDay
			crazyShoppingCtrl:sendReqBuy(nil)
		end)
	end
end
function crazyShoppingView:btnShowClick(day, button, type, pos)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.chooseDay = day
		self:initData()
	end
end
function crazyShoppingView:judgeEventClose(target, redata)
	if not crazyShoppingCtrl:isShowFundPage() then
		self:closePanel()
	end
end
function crazyShoppingView:showRewards(...)
	SoraDCloseLoading()
	local reward = crazyShoppingRead.getInvestRewards(self.chooseDay)
	local _ENV, itemData = self.chooseDay, self.chooseDay
	local itemCount = math.floor(#reward / 2)
	for i = 1, itemCount do
		_ENV = nil
		;(nil).id = reward[i * 2 - 1]
		;(nil).count = reward[i * 2]
		table.insert(itemData, nil)
	end
	SoraDMailGainItems(itemData, true)
end
return crazyShoppingView
