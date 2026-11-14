local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local baseComponent = require("fgui.base.baseComponent")
local shopSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TroopsChange/shopSingle", shopSingle)
function shopSingle:onInit()
	self:fixChildrenPos()
	self.fields.Button_exchange:addClickListener(handler(self, self.onBtnCallBack))
	self.fields.CheckBox_notify:addClickListener(handler(self, self.onCheckBoxCallBack))
	self.exChangeStatus = 0
	self.fields.Text_notify:setString(i18n("exchange_btn_01"))
	self.fields.Button_exchange:setTitleText(i18n("common_text_1889"))
	self.CheckBox_notify = self.fields.CheckBox_notify
	self.Text_leftCount = self.fields.Text_leftCount
	self.Button_exchange = self.fields.Button_exchange
	self.Button_exchange:setTitle(i18n("common_text_1889"))
end
function shopSingle:initData(data)
	self.activityID = data.activityID
	self.exchangeItemID = data.exchangeitem
	self.shopItemID = data.shopItemID
	self.singleCount = data.exchangenum
	self.shopitem = data.shopitem
	self.shopitemnum = data.shopitemnum
	self.curExchangeNum = activityExchangeMallCtrl:getExchangeNum(data.activityID, self.shopItemID)
	local isNotify = activityExchangeMallCtrl:getRemindStatus(data.activityID, self.shopItemID) == 1
	self.CheckBox_notify:setSelected(isNotify)
	self:setFromBtnData(data.exchangeitem, data.exchangenum)
	self.fields.Button_to:initData(data.shopitem, data.shopitemnum)
	self:setLeftCount(data.limitType, data.limitnum, self.curExchangeNum)
	self:setBtnExchangeStatus()
end
function shopSingle:setLeftCount(limitType, limitnum, curExchangeNum)
	if limitType == 0 or limitnum == 0 then
		self.Text_leftCount:setString("")
	else
		self.leftCount = math.max(0, limitnum - curExchangeNum)
		if limitnum <= curExchangeNum then
			self.exChangeStatus = 2
		end
		local countStr = string.format("%d/%d", self.leftCount, limitnum)
		self.Text_leftCount:setString(countStr)
		if 0 >= self.leftCount then
			self.Text_leftCount:setColor(display.COLOR_RED)
		end
		if limitType == 1 then
			self.fields.text_Type:setString(i18n("armyExchange_text_033"))
		else
			self.fields.text_Type:setString("")
		end
	end
end
function shopSingle:setBtnExchangeStatus()
	if self.exChangeStatus == 0 then
		self.Button_exchange:setGrayed(false)
		self.Button_exchange:setTitleColor(cc.c3b(255, 255, 255))
	elseif self.exChangeStatus == 1 then
		self.Button_exchange:setGrayed(false)
		self.Button_exchange:setTitleColor(cc.c3b(255, 0, 0))
	elseif self.exChangeStatus == 2 then
		self.Button_exchange:setTitleColor(cc.c3b(255, 255, 255))
		self.Button_exchange:setGoldColor(cc.c3b(255, 255, 255))
		self.Button_exchange:setGrayed(true)
	end
end
function shopSingle:onBtnCallBack(context)
	SoraDPlaySound()
	if self.exChangeStatus == 2 then
		SoraDShowMsgTip(i18n("common_text_1865"))
	elseif self.exChangeStatus == 1 then
		SoraDShowMsgTip(i18n("common_text_2512"))
	else
		local maxNum = math.floor(self.ownCount / self.singleCount)
		local tempItemID = self.itemID
		if self.leftCount and self.leftCount > 0 then
			maxNum = math.min(math.floor(self.ownCount / self.singleCount), self.leftCount)
		end
		_ENV, _ENV, _ENV = i18n("common_text_2512")
		i18n("common_text_2512").targetID = self.shopitem
		i18n("common_text_2512").exchangeID = self.exchangeItemID
		i18n("common_text_2512").singCount = self.singleCount
		i18n("common_text_2512").curNum = maxNum
		i18n("common_text_2512").exchangeData, i18n("common_text_2512").singleGet = i18n("common_text_2512")
		self.singleCount.exchangeCfg, i18n("common_text_2512").exchangeHandler = i18n("common_text_2512")
		uiManager:show("newShopSingleBuy", self.singleCount)
	end
end
function shopSingle:setFromBtnData(itemID, needNum)
	local ownNum = activityExchangeMallCtrl:getExchangeItemNum(itemID)
	self.ownCount = ownNum
	if needNum > ownNum then
		self.exChangeStatus = 1
	else
		self.exChangeStatus = 0
	end
	self.Button_exchange:setCost(itemID, needNum)
end
function shopSingle:onCheckBoxCallBack(context)
	if self.CheckBox_notify:isSelected() then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 1)
	elseif not self.CheckBox_notify:isSelected() then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 0)
	end
end
function shopSingle:onShow()
end
return shopSingle
