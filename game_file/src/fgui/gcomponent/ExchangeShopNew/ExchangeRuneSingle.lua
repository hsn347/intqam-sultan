local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
local exchangeMallCtrl = SoraDGetCtrl("exchangeMallCtrl")
local baseComponent = require("fgui.base.baseComponent")
local ExchangeRuneSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ExchangeShopNew/ExchangeRuneSingle", ExchangeRuneSingle)
function ExchangeRuneSingle:onInit()
	self.fields.Text_notify:setString(i18n("exchange_btn_01"))
	self.fields.Button_exchange:setTitle(i18n("common_text_1889"))
	self.fields.Button_exchange:addClickListener(handler(self, self.onBtnCallBack))
	self.fields.toItemL:setItemRenderer(handler(self, self.onToItemRender))
	self.fields.fromItemL:setItemRenderer(handler(self, self.onFromItemRender))
	self.fields.Check_tick:addClickListener(handler(self, self.onCheckBoxCallBack))
end
function ExchangeRuneSingle:onShow()
end
function ExchangeRuneSingle:onToItemRender(index, object)
	local itemInfo = self.shoItemList[index + 1]
	object:initData(itemInfo.id, itemInfo.count)
end
function ExchangeRuneSingle:onFromItemRender(index, object)
	local itemID = self.exchangeitemList[index + 1].id
	local needNum = self.exchangeitemList[index + 1].count
	object:initData(itemID, needNum)
end
function ExchangeRuneSingle:initData(data, otherData)
	dump(data, "ExchangeRuneSingle data===")
	self.activityID = otherData.activityID
	self.exchangeItemID = data.exchangeitem[1]
	self.shopItemID = data.shopItemID
	self.itemID = data.shopitem[1]
	self.singleGet = data.shopitem[2]
	self.toolID = data.exchangeitem[1]
	self.singleCount = data.exchangeitem[2]
	self.storeID = data.storeID
	self.limitNum = data.limitnum
	self.ownCount = 0
	self.curExchangeNum = activityExchangeMallCtrl:getExchangeNum(gActivityTimeActivityID.RUNE_EXCHANGE_MALL, self.shopItemID)
	_UPVALUE2_ = gActivityTimeActivityID.RUNE_EXCHANGE_MALL
	gActivityTimeActivityID.RUNE_EXCHANGE_MALL[1] = "id"
	gActivityTimeActivityID.RUNE_EXCHANGE_MALL[2] = "count"
	self.shoItemList = serviceFunctions.tableFormat(data.shopitem, gActivityTimeActivityID.RUNE_EXCHANGE_MALL)
	_UPVALUE2_ = gActivityTimeActivityID.RUNE_EXCHANGE_MALL
	gActivityTimeActivityID.RUNE_EXCHANGE_MALL[1] = "id"
	gActivityTimeActivityID.RUNE_EXCHANGE_MALL[2] = "count"
	self.exchangeitemList = serviceFunctions.tableFormat(data.exchangeitem, gActivityTimeActivityID.RUNE_EXCHANGE_MALL)
	self.fields.fromItemL:setNumItems(#self.exchangeitemList)
	self.fields.toItemL:setNumItems(#self.shoItemList)
	self:fixChildrenPos()
	for i = 1, 10 do
		if self.fields["n0" .. i] then
			self.fields["n0" .. i]:fix()
		end
	end
	self:setLeftCount(data.limitType, data.limitnum, self.curExchangeNum)
	local remindStatus = activityExchangeMallCtrl:getRemindStatus(gActivityTimeActivityID.RUNE_EXCHANGE_MALL, self.shopItemID)
	self.fields.Check_tick:setSelected(remindStatus == 1)
end
function ExchangeRuneSingle:setLeftCount(limitType, limitnum, curExchangeNum)
	if limitType == 0 or limitnum == 0 then
		self.fields.Text_leftCount:setString("")
	else
		self.leftCount = math.max(0, limitnum - curExchangeNum)
		local countStr = string.format("%d/%d", self.leftCount, limitnum)
		if limitType == 1 then
			_ENV = nil
			;(nil).count = countStr
			self.fields.Text_leftCount:setString(i18n("exchange_columntext_01", nil))
		elseif limitType == 3 then
			_ENV = i18n("exchange_columntext_01", nil)
			i18n("exchange_columntext_01", nil).num = self.leftCount
			i18n("exchange_columntext_01", nil).limitNum = limitnum
			self.fields.Text_leftCount:setString(i18n("shop_text_16", i18n("exchange_columntext_01", nil)))
		else
			_ENV = i18n("shop_text_16", i18n("exchange_columntext_01", nil))
			i18n("shop_text_16", i18n("exchange_columntext_01", nil)).count = countStr
			self.fields.Text_leftCount:setString(i18n("common_text_1673", i18n("shop_text_16", i18n("exchange_columntext_01", nil))))
		end
	end
end
function ExchangeRuneSingle:onBtnCallBack(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).shopItemID = self.shopItemID
	;(nil).rid = self.exchangeItemID
	uiManager:show("RuneExchangeChoose", nil)
end
function ExchangeRuneSingle:onCheckBoxCallBack(context)
	if self.fields.Check_tick:isSelected() then
		SoraDPlaySound()
		if self.storeID then
			newExchangeMallCtrl:reqNewExchangeRemind(self.storeID, 1)
		else
			activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 1)
		end
	elseif not self.fields.Check_tick:isSelected() then
		SoraDPlaySound()
		if self.storeID then
			newExchangeMallCtrl:reqNewExchangeRemind(self.storeID, 0)
		else
			activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 0)
		end
	end
end
return ExchangeRuneSingle
