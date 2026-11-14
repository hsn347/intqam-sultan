local rechargeRead = include("rechargeRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
local warOrderRead = include("warOrderRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarHornBuyGiftPanel = class("WarHornBuyGiftPanel", baseFguiPanel)
function WarHornBuyGiftPanel:ctor(...)
	WarHornBuyGiftPanel.super.ctor(self, ...)
	print("WarHornBuyGiftPanel:ctor", self.viewName)
end
function WarHornBuyGiftPanel:onInit()
	print("=======WarHornBuyGiftPanel:onInit")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581
	self.curCtrl = warOrderCtrl:getCurCtrl(self.activityID)
	self.type = self.param and self.param.type
	self.fields.Text_Title:setString(i18n("wardrum_text_18"))
	self.fields.Text_Title2:setString(i18n("Battle_Towers_30"))
	self.fields.Text_Title3:setString(i18n("MagiclampDecree_12"))
	self.fields.GiftAward:setItemRenderer(handler(self, self.onGiftItemRenderer))
	self.fields.AllSpecialAward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_Tips = SoraDCreateTimerLabel(self, self.fields.Text_Tips)
	self.fields.Text_Tips:setTimeLast(function(str)
		_ENV = nil
		;(nil).time = str
		return i18n("Braque_text_09", nil)
	end)
	self.view:fixChildrenPos()
end
function WarHornBuyGiftPanel:onShow()
	print("=======WarHornBuyGiftPanel:onShow")
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.fields.Text_Tips:beginTime(leftTime)
	end
	self:updateView()
end
function WarHornBuyGiftPanel:onGiftItemRenderer(index, object)
	object:initData(self.giftAward[index + 1].id, self.giftAward[index + 1].count)
end
function WarHornBuyGiftPanel:onItemRenderer(index, object)
	object:initData(self.allSpecialAward[index + 1].id, self.allSpecialAward[index + 1].count)
end
function WarHornBuyGiftPanel:onTabItemRenderer(index, object)
	print("self.tabDatas[index+1]", self.tabDatas[index + 1])
	object:setString(i18n(self.tabDatas[index + 1].title))
end
function WarHornBuyGiftPanel:updateView()
	self.giftInfo = warOrderRead.getGiftAwardInfo(self.activityID, self.type)
	local nowPrice = paymentManager.judgePrice(self.giftInfo.RechargeID, self.giftInfo.Price)
	local discount = self.giftInfo.OriginalPrice / self.giftInfo.Price
	local oriPrice = paymentManager.calculateDiscount(self.giftInfo.RechargeID, nowPrice, discount, self.giftInfo.OriginalPrice)
	warOrderRead = discount
	discount.rid = self.giftInfo.RechargeID
	discount.nowPrice = nowPrice
	warOrderRead, discount.oriPrice = self.giftInfo.RechargeID, oriPrice
	discount.logInfo, self.giftInfo.RechargeID.fromCenter = self.giftInfo.RechargeID, gRechargeActiveFromEnum.ROAD46
	discount.handleBuyClick = handlerEx(self, self.onGuyGift, self.giftInfo.RechargeID)
	discount.handleItemBuyClick = handlerEx(self, self.onGuyGiftByItem, self.giftInfo.RechargeID)
	self.fields.Com_OutAppPurchaseButtons:initData(discount)
	_UPVALUE2_ = discount
	discount[1] = "id"
	discount[2] = "count"
	self.allSpecialAward, warOrderRead, self.giftAward = serviceFunctions.tableFormat(self.giftInfo.Rewards, discount), serviceFunctions.tableFormat(self.giftInfo.Rewards, discount), serviceFunctions.tableFormat(self.giftInfo.Rewards, discount)
	self.fields.GiftAward:setNumItems(#self.giftAward)
	self.fields.Text_GoldNum:setString(self.giftInfo.Gold)
	self.allSpecialAward = warOrderRead.getAllAward(self.activityID, self.type, self.giftInfo.RechargeID)
	self.fields.AllSpecialAward:setNumItems(#self.allSpecialAward)
end
function WarHornBuyGiftPanel:onGuyGift(giftId)
	SoraDPlaySound()
	print("giftId", giftId)
	paymentManager.normalGiftBuyClassify(giftId)
	paymentManager.OnemtReadyBuy(giftId, gRechargeActiveFromEnum.ROAD46)
	self:close()
end
function WarHornBuyGiftPanel:onGuyGiftByItem(giftId)
	print("giftId", giftId)
	_ENV, _ENV = nil, giftId
	;(nil).fromCenter = gRechargeActiveFromEnum.ROAD46
	SoraDShowH5PurchaseView(giftId, giftId, nil)
	self:close()
	return false
end
function WarHornBuyGiftPanel:buyGift(buyHandle)
	self:realBuyGift(buyHandle)
end
function WarHornBuyGiftPanel:realBuyGift(buyHandle)
	local _eventTime = SoraDGetCtrl("activityShowCtrl"):getTimeInfoByID(self.activityID)
	local contentKey = self.type == 1 and "activity_9001581_text_07" or "activity_9001581_text_08"
	_ENV = nil
	_ENV = nil
	_ENV, _ENV, (nil).time = _eventTime.timerNode.timer:getRemainTime()
	_ENV, _eventTime.timerNode.timer:getRemainTime().color = _eventTime.timerNode.timer:getRemainTime()
	SoraDConvertSecondToString(_eventTime.timerNode.timer:getRemainTime()).item, _eventTime.timerNode.timer:getRemainTime().__default, _eventTime.timerNode.timer:getRemainTime().color = _eventTime.timerNode.timer:getRemainTime()
	;(nil).content = i18n_html(contentKey, nil, (SoraDConvertSecondToString(_eventTime.timerNode.timer:getRemainTime())))
	;(nil).confirmString = i18n("common_text_282")
	;(nil).cancelString = i18n("common_text_185")
	;(nil).confirmFunc = buyHandle
	uiManager:show("MessageBox", nil)
end
return WarHornBuyGiftPanel
