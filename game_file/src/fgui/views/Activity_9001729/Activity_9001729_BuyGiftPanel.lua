local commonBuyGiftCtrl = SoraDGetCtrl("commonBuyGiftCtrl")
local activity_9001729_ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
local activity_9001729_Read = include("activity_9001729_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001729_BuyGiftPanel = class("Activity_9001729_BuyGiftPanel", baseFguiPanel)
function Activity_9001729_BuyGiftPanel:ctor(...)
	Activity_9001729_BuyGiftPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001729_BuyGiftPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY
end
function Activity_9001729_BuyGiftPanel:onInit()
	print("=======Activity_9001729_BuyGiftPanel:onInit")
	self.allSpecialAward, _ENV = print, print
	self.fields.Text_Title3:setString(i18n("common_text_789"))
	self.fields.Text_Title2:setString(i18n("Battle_Towers_30"))
	self.fields.Text_Tips:setString(i18n("ramadan_bless_text_03"))
	self.fields.GiftAward:setItemRenderer(handler(self, self.onGiftItemRenderer))
	self.fields.AllSpecialAward:setItemRenderer(handler(self, self.onSpecialItemRenderer))
end
function Activity_9001729_BuyGiftPanel:onShow()
	print("=======Activity_9001729_BuyGiftPanel:onShow")
	self:updateView()
end
function Activity_9001729_BuyGiftPanel:updateView()
	self.giftInfo = activity_9001729_Read.getRechargeCfg()
	local rewards = activity_9001729_Read.getRewardList()
	self.giftAward, activity_9001729_Read = nil, nil
	local activity_9001729_Read, giftAward
	for i, v in ipairs(rewards) do
		for i = 1, #v.advanceReward, 2 do
			if not giftAward[v.advanceReward[i]] then
				activity_9001729_Read = nil
				;(nil).id = v.advanceReward[i]
				giftAward[v.advanceReward[i]], (nil).count = nil, 0
			end
			giftAward[v.advanceReward[i]].count = giftAward[v.advanceReward[i]].count + (v.advanceReward[i + 1] or 0)
		end
	end
	for i, v in pairs(giftAward) do
		table.insert(self.giftAward, v)
	end
	self.fields.Text_Title:setString(i18n(self.giftInfo.rechargeName))
	dump(self.giftInfo, "self.giftInfo")
	local nowPrice = paymentManager.judgePrice(self.giftInfo.rechargeID, self.giftInfo.rechargePrice)
	local discount = self.giftInfo.originalPrice / self.giftInfo.rechargePrice
	local oriPrice = paymentManager.calculateDiscount(self.giftInfo.rechargeID, nowPrice, discount, self.giftInfo.originalPrice)
	activity_9001729_Read = discount
	discount.rid = self.giftInfo.rechargeID
	discount.nowPrice = nowPrice
	activity_9001729_Read, discount.oriPrice = self.giftInfo.rechargeID, oriPrice
	discount.logInfo, self.giftInfo.rechargeID.fromCenter = self.giftInfo.rechargeID, gRechargeActiveFromEnum.ROAD46
	discount.handleBuyClick = handler(self, self.onBuyGift)
	discount.handleItemBuyClick = handler(self, self.onBuyGiftItem)
	discount.handlePurchaseBack = handler(self, self.purchaseBack)
	self.fields.Com_OutAppPurchaseButtons:initData(discount)
	self.fields.Text_GoldNum:setString(self.giftInfo.gold)
	_UPVALUE2_ = self.giftInfo.gold
	self.giftInfo.gold[1] = "id"
	self.giftInfo.gold[2] = "count"
	self.allSpecialAward = serviceFunctions.tableFormat(self.giftInfo.reward, self.giftInfo.gold)
	dump(self.allSpecialAward, "self.allSpecialAward")
	self.fields.GiftAward:setNumItems(#self.giftAward)
	self.fields.AllSpecialAward:setNumItems(#self.allSpecialAward)
end
function Activity_9001729_BuyGiftPanel:onGiftItemRenderer(index, object)
	object:initData(self.giftAward[index + 1].id, self.giftAward[index + 1].count)
end
function Activity_9001729_BuyGiftPanel:onSpecialItemRenderer(index, object)
	object:initData(self.allSpecialAward[index + 1], index + 1)
end
function Activity_9001729_BuyGiftPanel:onBuyGift()
	SoraDShowLoading()
	SoraDPlaySound()
	commonBuyGiftCtrl:reqBuyGift(gBuyType.CRESCENT_TREASURE, self.giftInfo.rechargeID)
end
function Activity_9001729_BuyGiftPanel:onBuyGiftItem()
	SoraDPlaySound()
	return true
end
function Activity_9001729_BuyGiftPanel:purchaseBack(...)
	SoraDCloseLoading()
	self:close()
end
return Activity_9001729_BuyGiftPanel
