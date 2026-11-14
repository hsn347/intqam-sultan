local activity_9001727_Read = include("activity_9001727_Read")
local activity_9001727_Ctrl = SoraDGetCtrl("activity_9001727_Ctrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local rechargeRead = include("rechargeRead")
local commonBuyGiftCtrl = SoraDGetCtrl("commonBuyGiftCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001727_BuyGiftPanel = class("Activity_9001727_BuyGiftPanel", baseFguiPanel)
function Activity_9001727_BuyGiftPanel:ctor(...)
	self.isLRU = true
	Activity_9001727_BuyGiftPanel.super.ctor(self, ...)
	print("Activity_9001727_BuyGiftPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.ALBARQ_DECREE_ACTIVITY
end
function Activity_9001727_BuyGiftPanel:onInit()
	print("=======Activity_9001727_BuyGiftPanel:onInit")
	self.fields.BuffList:setItemRenderer(handler(self, self.itemRenderer_BuffList))
	self.fields.GiftAward:setItemRenderer(handler(self, self.itemRenderer_GiftAward))
	self.fields.AllSpecialAward:setItemRenderer(handler(self, self.itemRenderer_AllSpecialAward))
	self.fields.Button_Ques:addClickListener(handler(self, self.onClick_Button_Ques))
	self.fields.Text_Title2:setString(i18n("Battle_Towers_30"))
	self.fields.Text_Title3:setString(i18n("MagiclampDecree_12"))
end
function Activity_9001727_BuyGiftPanel:endShow()
	print("=======Activity_9001727_BuyGiftPanel:endShow")
	self.giftInfo = activity_9001727_Read.getRecharge()
	local info = rechargeRead.getPageViewData(self.giftInfo.RechargeID)
	self.fields.Text_Title:setString(i18n(info.activeName))
	self.fields.Text_Tips:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("Braque_text_09", nil)
	end)
	self.fields.Text_Tips:beginTime(activityShowCtrl:getRemainTime(self.activityID))
	self.buffList = activity_9001727_Read.getEffectShow(self.giftInfo.RechargeID)
	self.fields.BuffList:setNumItems(#self.buffList)
	self.fields.Text_GoldNum:setString(self.giftInfo.Gold)
	self.giftAward = self.giftInfo.Rewards
	self.fields.GiftAward:setNumItems(#self.giftAward)
	self.allSpecialAward = activity_9001727_Read.getAllReward()
	self.fields.AllSpecialAward:setNumItems(#self.allSpecialAward)
	local nowPrice = paymentManager.judgePrice(self.giftInfo.RechargeID, self.giftInfo.Price)
	local discount = self.giftInfo.OriginalPrice / self.giftInfo.Price
	local oriPrice = paymentManager.calculateDiscount(self.giftInfo.RechargeID, nowPrice, discount, self.giftInfo.OriginalPrice)
	_ENV = discount
	discount.rid = self.giftInfo.RechargeID
	discount.nowPrice = nowPrice
	_ENV, discount.oriPrice = self.giftInfo.RechargeID, oriPrice
	discount.logInfo, self.giftInfo.RechargeID.fromCenter = self.giftInfo.RechargeID, gRechargeActiveFromEnum.ROAD63
	discount.handleBuyClick = handlerEx(self, self.onGuyGift, self.giftInfo.RechargeID)
	self.fields.Com_OutAppPurchaseButtons:initData(discount)
end
function Activity_9001727_BuyGiftPanel:itemRenderer_BuffList(index, obj)
	local data = self.buffList[index + 1]
	obj:getChild("icon"):setIcon(data.EffectIcon)
	obj:setTitle(i18n(data.EffectDescription))
end
function Activity_9001727_BuyGiftPanel:itemRenderer_GiftAward(index, obj)
	local data = self.giftAward[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001727_BuyGiftPanel:itemRenderer_AllSpecialAward(index, obj)
	local data = self.allSpecialAward[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001727_BuyGiftPanel:onClick_Button_Ques(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001727_Buff")
end
function Activity_9001727_BuyGiftPanel:onGuyGift(giftId)
	SoraDPlaySound()
	commonBuyGiftCtrl:reqBuyGift(gBuyType.ALBARQ_DECREE, giftId)
end
return Activity_9001727_BuyGiftPanel
