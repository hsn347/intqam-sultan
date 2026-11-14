local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001680_BuyGiftPanel = class("Activity_9001680_BuyGiftPanel", baseFguiPanel)
local activity_9001680_Read = include("activity_9001680_Read")
local rechargeRead = include("rechargeRead")
function Activity_9001680_BuyGiftPanel:ctor(...)
	self.isLRU = true
	Activity_9001680_BuyGiftPanel.super.ctor(self, ...)
	print("Activity_9001680_BuyGiftPanel:ctor", self.viewName)
end
function Activity_9001680_BuyGiftPanel:onInit()
	print("=======Activity_9001680_BuyGiftPanel:onInit")
	self.allSpecialAward, _ENV = print, print
	self.fields.Text_Title3:setString(i18n("common_text_789"))
	self.fields.Text_Title2:setString(i18n("Battle_Towers_30"))
	self.fields.Text_Tips:setString(i18n("ramadan_bless_text_03"))
	self.fields.GiftAward:setItemRenderer(handler(self, self.onGiftItemRenderer))
	self.fields.AllSpecialAward:setItemRenderer(handler(self, self.onSpecialItemRenderer))
end
function Activity_9001680_BuyGiftPanel:endShow()
	print("=======Activity_9001680_BuyGiftPanel:endShow")
	self:updateView()
end
function Activity_9001680_BuyGiftPanel:updateView()
	self.giftInfo = activity_9001680_Read.getRechargeCfg(3)
	self.rid = self.giftInfo.giftId
	local rewards = activity_9001680_Read.getRewardList()
	self.giftAward, activity_9001680_Read = 3, 3
	local activity_9001680_Read, giftAward = 3, 3
	for i, v in ipairs(rewards) do
		for i2, v2 in ipairs(v.advanceReward) do
			giftAward[v2.id] = giftAward[v2.id] or 0
			giftAward[v2.id] = giftAward[v2.id] + v2.count
		end
	end
	for k, v in pairs(giftAward) do
		activity_9001680_Read = ipairs(v.advanceReward)
		ipairs(v.advanceReward).id = k
		ipairs(v.advanceReward).count = v
		table.insert(self.giftAward, ipairs(v.advanceReward))
	end
	local rechargeCfg = rechargeRead.getPageViewData(self.rid)
	self.fields.Text_Title:setString(i18n(rechargeCfg.activeName))
	dump(self.giftInfo, "self.giftInfo")
	local nowPrice = paymentManager.judgePrice(self.giftInfo.giftId, self.giftInfo.price)
	local discount = self.giftInfo.originalPrice / self.giftInfo.price
	local oriPrice = paymentManager.calculateDiscount(self.giftInfo.giftId, nowPrice, discount, self.giftInfo.originalPrice)
	activity_9001680_Read = discount
	discount.rid = self.giftInfo.giftId
	discount.nowPrice = nowPrice
	activity_9001680_Read, discount.oriPrice = self.giftInfo.giftId, oriPrice
	discount.logInfo, self.giftInfo.giftId.fromCenter = self.giftInfo.giftId, gRechargeActiveFromEnum.ROAD46
	discount.handleBuyClick = handler(self, self.onGuyGift)
	discount.handlePurchaseBack = handler(self, self.close)
	self.fields.Com_OutAppPurchaseButtons:initData(discount)
	self.fields.Text_GoldNum:setString(self.giftInfo.gold)
	rechargeRead = self.giftInfo.gold
	self.giftInfo.gold[1] = "id"
	self.giftInfo.gold[2] = "count"
	self.allSpecialAward = serviceFunctions.tableFormat(self.giftInfo.gift, self.giftInfo.gold)
	dump(self.allSpecialAward, "self.allSpecialAward")
	self.fields.GiftAward:setNumItems(#self.giftAward)
	self.fields.AllSpecialAward:setNumItems(#self.allSpecialAward)
end
function Activity_9001680_BuyGiftPanel:onGiftItemRenderer(index, object)
	object:initData(self.giftAward[index + 1].id, self.giftAward[index + 1].count)
end
function Activity_9001680_BuyGiftPanel:onSpecialItemRenderer(index, object)
	object:initData(self.allSpecialAward[index + 1])
end
function Activity_9001680_BuyGiftPanel:onGuyGift()
	SoraDPlaySound()
	SoraDShowLoading()
	paymentManager.normalGiftBuyClassify(self.giftInfo.giftId)
	paymentManager.OnemtReadyBuy(self.giftInfo.giftId, gRechargeActiveFromEnum.ROAD18)
	self:removeFromParent()
end
return Activity_9001680_BuyGiftPanel
