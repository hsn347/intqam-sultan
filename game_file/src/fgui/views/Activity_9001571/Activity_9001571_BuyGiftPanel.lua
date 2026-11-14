local activity_9001571_Ctrl = SoraDGetCtrl("activity_9001571_Ctrl")
local activity_9001571_Read = include("activity_9001571_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001571_BuyGiftPanel = class("Activity_9001571_BuyGiftPanel", baseFguiPanel)
function Activity_9001571_BuyGiftPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001571_BuyGiftPanel:ctor", self.viewName)
end
function Activity_9001571_BuyGiftPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001571_BuyGiftPanel:onInit()
	print("=======Activity_9001571_BuyGiftPanel:onInit")
	self.allSpecialAward, _ENV = print, print
	self.fields.Text_Title3:setString(i18n("MagiclampDecree_12"))
	self.fields.Text_Title2:setString(i18n("common_text_4061"))
	self.fields.Text_Title:setString(i18n("rechare_activename_19368"))
	self.fields.GiftAward:setItemRenderer(handler(self, self.onGiftItemRenderer))
	self.fields.AllSpecialAward:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001571_BuyGiftPanel:onShow()
	print("=======Activity_9001571_BuyGiftPanel:onShow")
	self:updateView()
	local num = 0
	local maxLv = activity_9001571_Read.getMaxLv(activity_9001571_Ctrl:getClassType(), activity_9001571_Ctrl:getGroupID())
	local heroName, itemID = activity_9001571_Read.getChooseHeroName(activity_9001571_Ctrl:getClassType(), activity_9001571_Ctrl:getGroupID())
	for i, v in ipairs(self.allSpecialAward) do
		if v.id == itemID then
			num = v.count
		end
	end
	_ENV = activity_9001571_Ctrl:getGroupID()
	activity_9001571_Ctrl:getGroupID().lv = maxLv
	activity_9001571_Ctrl:getGroupID().num = num
	activity_9001571_Ctrl:getGroupID().name = heroName
	self.fields.Text_Tips:setString(i18n("Back_battlefield_11", activity_9001571_Ctrl:getGroupID()))
end
function Activity_9001571_BuyGiftPanel:updateView()
	self.giftInfo = activity_9001571_Read.getGiftAwardInfo(activity_9001571_Ctrl:getClassType(), activity_9001571_Ctrl:getGroupID())
	dump(self.giftInfo, "self.giftInfo")
	local nowPrice = paymentManager.judgePrice(self.giftInfo.RechargeID, self.giftInfo.Price)
	local discount = self.giftInfo.OriginalPrice / self.giftInfo.Price
	local oriPrice = paymentManager.calculateDiscount(self.giftInfo.RechargeID, nowPrice, discount, self.giftInfo.OriginalPrice)
	activity_9001571_Read = discount
	discount.rid = self.giftInfo.RechargeID
	discount.nowPrice = nowPrice
	activity_9001571_Read, discount.oriPrice = self.giftInfo.RechargeID, oriPrice
	discount.logInfo, self.giftInfo.RechargeID.fromCenter = self.giftInfo.RechargeID, gRechargeActiveFromEnum.ROAD46
	discount.handleBuyClick = handler(self, self.onGuyGift)
	discount.handlePurchaseBack = handler(self, self.close)
	self.fields.Com_OutAppPurchaseButtons:initData(discount)
	self.fields.Text_GoldNum:setString(self.giftInfo.gold)
	self.giftAward = self.giftInfo.gift
	self.allSpecialAward = self.giftInfo.Rewards
	self.fields.GiftAward:setNumItems(#self.giftAward)
	self.fields.AllSpecialAward:setNumItems(#self.allSpecialAward)
end
function Activity_9001571_BuyGiftPanel:onGiftItemRenderer(index, object)
	object:initData(self.giftAward[index + 1].id, self.giftAward[index + 1].count)
end
function Activity_9001571_BuyGiftPanel:onItemRenderer(index, object)
	object:initData(self.allSpecialAward[index + 1].id, self.allSpecialAward[index + 1].count)
end
function Activity_9001571_BuyGiftPanel:onGuyGift()
	SoraDPlaySound()
	SoraDShowLoading()
	paymentManager.normalGiftBuyClassify(self.giftInfo.RechargeID)
	paymentManager.OnemtReadyBuy(self.giftInfo.RechargeID, gRechargeActiveFromEnum.ROAD18)
	self:removeFromParent()
end
return Activity_9001571_BuyGiftPanel
