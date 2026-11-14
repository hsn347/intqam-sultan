local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local baseComponent = require("fgui.base.baseComponent")
local summerPrayersExchangeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SummerPrayersMainView/summerPrayersExchangeSingle", summerPrayersExchangeSingle)
function summerPrayersExchangeSingle:onInit()
	self.exChangeStatus = 0
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.CheckBox_notify = SoraDGetChildByName(self, "CheckBox_notify")
	self.CheckBox_notify:addClickListener(handler(self, self.checkBoxNotifyEventCallBack))
	self.Text_notify = SoraDGetChildByName(self, "Text_notify")
	self.Text_notify:setString(i18n("exchange_btn_01"))
	self.Text_leftCount = SoraDGetChildByName(self, "Text_leftCount")
	self.Button_exchange = SoraDGetChildByName(self, "Button_exchange")
	self.Button_exchange:setTitleText(i18n("common_text_1889"))
	self.Button_exchange:addClickListener(handler(self, self.btnExchangeClick))
	self.nodeShopItem = SoraDGetChildByName(self, "Node_ShopItem")
	if not SoraDFIsRA() then
		self.Panel_touch:fixChildren()
		self.Panel_touch:fixChildrenPos()
	end
end
function summerPrayersExchangeSingle:onShow()
end
function summerPrayersExchangeSingle:initData(data, otherData)
	dump(data, "shopitem")
	if otherData then
		self.view = otherData.view
		self.activityID = otherData.activityID
	end
	self.exChangeStatus = 0
	self.nodeShopItem:initData(data.shopitem, data.shopitemnum)
	self.shopItemID = data.shopItemID
	self.shopItem = data.shopitem
	self.shopItemNum = data.shopitemnum
	self.limitnum = data.limitnum
	self.canBuyCount = 0
	self.itemData = data
	if not self.nodeExchangeItem then
		self.nodeExchangeItem = self.nodeShopItem:clone()
		self.nodeExchangeItem:addTo(self.Panel_touch)
		self.nodeExchangeItem:setPivot(0.5, 0, true)
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
			self.nodeExchangeItem2:setPivot(0.5, 0, true)
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
	local haveCount = activityExchangeMallCtrl:getExchangeItemNum(itemID)
	target:initData(itemID, haveCount, needCount)
	if needCount > haveCount then
		self.exChangeStatus = 1
	end
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
function summerPrayersExchangeSingle:checkBoxNotifyEventCallBack()
	SoraDPlaySound()
	if self.CheckBox_notify:isSelected() then
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 1)
	else
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 0)
	end
end
function summerPrayersExchangeSingle:btnExchangeClick()
	SoraDPlaySound()
	self:onClickOperate()
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
