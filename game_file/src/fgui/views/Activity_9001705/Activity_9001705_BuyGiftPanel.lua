local activity_9001705_Read = include("activity_9001705_Read")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001705_BuyGiftPanel = class("Activity_9001705_BuyGiftPanel", baseFguiPanel)
function Activity_9001705_BuyGiftPanel:ctor(...)
	Activity_9001705_BuyGiftPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001705_BuyGiftPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001624
end
function Activity_9001705_BuyGiftPanel:onInit()
	print("=======Activity_9001705_BuyGiftPanel:onInit")
	self.allSpecialAward, _ENV = print, print
	self.fields.Text_Title3:setString(i18n("common_text_789"))
	self.fields.Text_Title2:setString(i18n("Battle_Towers_30"))
	self.fields.Text_Tips:setString(i18n("ramadan_bless_text_03"))
	self.fields.GiftAward:setItemRenderer(handler(self, self.onGiftItemRenderer))
	self.fields.AllSpecialAward:setItemRenderer(handler(self, self.onSpecialItemRenderer))
end
function Activity_9001705_BuyGiftPanel:onShow()
	print("=======Activity_9001705_BuyGiftPanel:onShow")
	self:updateView()
end
function Activity_9001705_BuyGiftPanel:updateView()
	self.rid = constantRead.getConstValue("SKY_COMPETITION_BATTLEPASS_RECHARGE", 19734)
	self.giftInfo = activity_9001705_Read.getRechargeCfg(self.rid)
	local rewards = activity_9001705_Read.getRewardList()
	self.giftAward, constantRead = self.rid, self.rid
	local constantRead, giftAward = self.rid, self.rid
	for i, v in ipairs(rewards) do
		for i2, v2 in ipairs(v.advanceReward) do
			giftAward[v2.id] = giftAward[v2.id] or 0
			giftAward[v2.id] = giftAward[v2.id] + v2.count
		end
	end
	for k, v in pairs(giftAward) do
		constantRead = ipairs(v.advanceReward)
		ipairs(v.advanceReward).id = k
		ipairs(v.advanceReward).count = v
		table.insert(self.giftAward, ipairs(v.advanceReward))
	end
	self.fields.Text_Title:setString(i18n(self.giftInfo.rechargeName))
	dump(self.giftInfo, "self.giftInfo")
	local nowPrice = paymentManager.judgePrice(self.giftInfo.rechargeID, self.giftInfo.rechargePrice)
	local discount = self.giftInfo.originalPrice / self.giftInfo.rechargePrice
	local oriPrice = paymentManager.calculateDiscount(self.giftInfo.rechargeID, nowPrice, discount, self.giftInfo.originalPrice)
	constantRead = discount
	discount.rid = self.giftInfo.rechargeID
	discount.nowPrice = nowPrice
	constantRead, discount.oriPrice = self.giftInfo.rechargeID, oriPrice
	discount.logInfo, self.giftInfo.rechargeID.fromCenter = self.giftInfo.rechargeID, gRechargeActiveFromEnum.ROAD46
	discount.handleBuyClick = handler(self, self.onGuyGift)
	discount.handlePurchaseBack = handler(self, self.close)
	self.fields.Com_OutAppPurchaseButtons:initData(discount)
	self.fields.Text_GoldNum:setString(self.giftInfo.gold)
	_ENV = self.giftInfo.gold
	self.giftInfo.gold[1] = "id"
	self.giftInfo.gold[2] = "count"
	self.allSpecialAward = serviceFunctions.tableFormat(self.giftInfo.reward, self.giftInfo.gold)
	dump(self.allSpecialAward, "self.allSpecialAward")
	self.fields.GiftAward:setNumItems(#self.giftAward)
	self.fields.AllSpecialAward:setNumItems(#self.allSpecialAward)
end
function Activity_9001705_BuyGiftPanel:onGiftItemRenderer(index, object)
	object:initData(self.giftAward[index + 1].id, self.giftAward[index + 1].count)
end
function Activity_9001705_BuyGiftPanel:onSpecialItemRenderer(index, object)
	object:initData(self.allSpecialAward[index + 1])
end
function Activity_9001705_BuyGiftPanel:onGuyGift()
	SoraDPlaySound()
	SoraDShowLoading()
	paymentManager.normalGiftBuyClassify(self.giftInfo.rechargeID)
	paymentManager.OnemtReadyBuy(self.giftInfo.rechargeID, gRechargeActiveFromEnum.ROAD18)
	self:removeFromParent()
end
return Activity_9001705_BuyGiftPanel
