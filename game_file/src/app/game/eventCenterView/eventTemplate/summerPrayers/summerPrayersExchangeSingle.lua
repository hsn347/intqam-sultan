local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local summerPrayersExchangeSingle = class("summerPrayersExchangeSingle", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("summerPrayersExchangeSingle")
end)
local colorRed = cc.c3b(255, 0, 0)
function summerPrayersExchangeSingle:ctor(properties)
	self.exChangeStatus = 0
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch:setSwallowTouches(false)
	SoraDGetChildByName(self, "Image_L"):setFillType(1)
	SoraDGetChildByName(self, "Image_R"):setFillType(1)
	self.CheckBox_notify = SoraDGetChildByName(self, "CheckBox_notify")
	self.CheckBox_notify:addEventListener(handler(self, self.checkBoxNotifyEventCallBack))
	self.Text_notify = SoraDGetChildByName(self, "Text_notify")
	self.Text_notify:setString(i18n("exchange_btn_01"))
	self.Text_leftCount = SoraDGetChildByName(self, "Text_leftCount")
	self.Button_exchange = SoraDGetChildByName(self, "Button_exchange")
	self.Button_exchange:setTitleText(i18n("common_text_1889"))
	self.Button_exchange:setSwallowTouches(false)
	self.Button_exchange:addTouchEventListener(handler(self, self.btnExchangeClick))
	self.nodeShopItem = SoraDGetChildByName(self, "Node_ShopItem")
	self.nodeShopItem = include("commonItemAward").new(self.nodeShopItem)
	self.nodeShopItem:setScale(0.9)
end
function summerPrayersExchangeSingle:initData(data, otherData)
	dump(data, "shopitem")
	if otherData then
		self.view = otherData.view
		self.activityID = otherData.activityID
		self.scroll = otherData.scroll
	end
	self.exChangeStatus = 0
	self.nodeShopItem:initData(data.shopitem, data.shopitemnum)
	self.nodeShopItem:setOwnScroll(self.scroll)
	self.nodeShopItem:setOwnView(self.view)
	self.shopItemID = data.shopItemID
	self.shopItem = data.shopitem
	self.shopItemNum = data.shopitemnum
	self.limitnum = data.limitnum
	self.canBuyCount = 0
	self.itemData = data
	if not self.nodeExchangeItem then
		self.nodeExchangeItem = self.nodeShopItem:clone()
		self.nodeExchangeItem:addTo(self.Panel_touch)
	end
	self.nodeExchangeItem, self.canBuyCount = self:createExchangeItem(self.nodeExchangeItem, data.exchangeitem, data.exchangenum)
	self.nodeExchangeItem:setPosition(SoraDFPosX(550, 624.0), 57)
	if self.nodeExchangeItem2 then
		self.nodeExchangeItem2:setVisible(false)
	end
	if data.exchangeitem2 then
		if not self.nodeExchangeItem2 then
			self.nodeExchangeItem2 = self.nodeShopItem:clone()
			self.nodeExchangeItem2:addTo(self.Panel_touch)
		end
		self.nodeExchangeItem2:setVisible(true)
		local canBuy = 0
		self.nodeExchangeItem2, canBuy = self:createExchangeItem(self.nodeExchangeItem2, data.exchangeitem2, data.exchangenum2)
		self.nodeExchangeItem2:setPosition(SoraDFPosX(450, 624.0), 57)
		self.canBuyCount = math.min(canBuy, self.canBuyCount)
		print("sdlfjslkdjfsldk222", self.canBuyCount)
	end
	self.buyNum = activityExchangeMallCtrl:getExchangeNum(self.activityID, self.shopItemID)
	local isNotify = activityExchangeMallCtrl:getRemindStatus(self.activityID, self.shopItemID) == 1
	self.CheckBox_notify:setSelected(isNotify)
	_ENV = 624.0
	;(624.0).left = string.formatnumberthousands(self.limitnum - (self.buyNum or 0))
	;(624.0).total = string.formatnumberthousands(self.limitnum)
	self.Text_leftCount:setString(i18n("pray_text_13", 624.0))
	self.Text_leftCount:setColor(cc.c3b(255, 255, 255))
	if self.buyNum >= self.limitnum and self.activityID ~= gActivityTimeActivityID.RAIDERS_LOST_ARK then
		self.exChangeStatus = 2
		self.Text_leftCount:setColor(cc.c3b(255, 0, 0))
	end
	if self.activityID and self.activityID == gActivityTimeActivityID.RAIDERS_LOST_ARK then
		self.Text_leftCount:setVisible(false)
	end
	self:setBtnExchangeStatus()
end
function summerPrayersExchangeSingle:createExchangeItem(target, itemID, needCount)
	target = include("commonItemAward").new(target)
	local haveCount = activityExchangeMallCtrl:getExchangeItemNum(itemID)
	target:setScale(0.9)
	target:initData(itemID, needCount)
	target:setOwnScroll(self.scroll)
	target:setOwnView(self.view)
	local color = "#FFFFFF"
	if needCount > haveCount then
		color = "#FF0000"
		self.exChangeStatus = 1
	end
	_ENV = nil
	;(nil).member = haveCount
	_ENV, _ENV, (nil).total = nil, nil, needCount
	;(nil).member, (nil).color = nil, color
	target:setHtmlString(i18n_html("common_text_155", nil, nil))
	return target, math.floor(haveCount / needCount)
end
function summerPrayersExchangeSingle:setBtnExchangeStatus()
	if self.exChangeStatus == 0 then
		self.Button_exchange:setBright(true)
		self.Button_exchange:setTitleColor(cc.c3b(255, 255, 255))
	elseif self.exChangeStatus == 1 then
		self.Button_exchange:setBright(true)
		self.Button_exchange:setTitleColor(cc.c3b(255, 0, 0))
	elseif self.exChangeStatus == 2 then
		self.Button_exchange:setBright(false)
		self.Button_exchange:setTitleColor(cc.c3b(115, 115, 115))
	end
end
function summerPrayersExchangeSingle:checkBoxNotifyEventCallBack(target, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 1)
	elseif eventType == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 0)
	end
end
function summerPrayersExchangeSingle:btnExchangeClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("不在范围内")
			return
		end
		self:onClickOperate()
	end
end
function summerPrayersExchangeSingle:onClickOperate()
	if self.exChangeStatus == 1 then
		SoraDShowMsgTip(i18n("common_text_2512"))
	elseif self.exChangeStatus == 2 then
		SoraDShowMsgTip(i18n("spices_text_07"))
	else
		self:showBuyView()
	end
end
function summerPrayersExchangeSingle:showBuyView()
	local shopSingleBuy = SoraDCreatePanel("summerPrayersShopBuy")
	local total = self.limitnum
	local cur = self.buyNum
	local maxCount = total - cur
	if self.activityID == gActivityTimeActivityID.RAIDERS_LOST_ARK then
		maxCount = self.canBuyCount
	end
	maxCount = math.min(maxCount, self.canBuyCount)
	print("self.canBuyCount", maxCount, self.canBuyCount)
	local _ENV, exchangeInfo = print, print
	_ENV = self.canBuyCount
	self.canBuyCount.exchangeID = self.itemData.exchangeitem
	self.canBuyCount.singCount = self.itemData.exchangenum
	table.insert(exchangeInfo, self.canBuyCount)
	if self.itemData.exchangeitem2 then
		_ENV = self.canBuyCount
		self.canBuyCount.exchangeID = self.itemData.exchangeitem2
		self.canBuyCount.singCount = self.itemData.exchangenum2
		table.insert(exchangeInfo, self.canBuyCount)
	end
	_ENV = self.canBuyCount
	self.canBuyCount.targetID = self.shopItem
	self.canBuyCount.huntCount = self.shopitemnum
	self.canBuyCount.curNum = maxCount
	self.canBuyCount.exchangeInfo = exchangeInfo
	shopSingleBuy:initExchangeData(self.canBuyCount)
	shopSingleBuy:show()
	shopSingleBuy:setExchangeHandler(function(num)
		self:onBuyItem(self.itemData, num)
	end)
end
function summerPrayersExchangeSingle:onBuyItem(data, num)
	print("选择了数量:", num)
	activityExchangeMallCtrl:reqActivityExchange(self.shopItemID, num)
	SoraDShowLoading(self.view)
end
return summerPrayersExchangeSingle
