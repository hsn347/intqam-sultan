local activity_9001624_Read = include("activity_9001624_Read")
local activity_9001717_Read = include("activity_9001717_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001624_BuyGiftPanel = class("Activity_9001624_BuyGiftPanel", baseFguiPanel)
function Activity_9001624_BuyGiftPanel:ctor(...)
	Activity_9001624_BuyGiftPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001624_BuyGiftPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001624
end
function Activity_9001624_BuyGiftPanel:onInit()
	print("=======Activity_9001624_BuyGiftPanel:onInit")
	self.allSpecialAward, _ENV = print, print
	self.fields.Text_Title3:setString(i18n("common_text_789"))
	self.fields.Text_Title2:setString(i18n("Battle_Towers_30"))
	self.fields.Text_Tips:setString(i18n("ramadan_bless_text_03"))
	self.fields.text_tip:setString(i18n("eidalfitr_market_text_07"))
	self.fields.GiftAward:setItemRenderer(handler(self, self.onGiftItemRenderer))
	self.fields.AllSpecialAward:setItemRenderer(handler(self, self.onSpecialItemRenderer))
end
function Activity_9001624_BuyGiftPanel:onShow()
	print("=======Activity_9001624_BuyGiftPanel:onShow")
	self:updateView()
end
function Activity_9001624_BuyGiftPanel:updateView()
	if self.activityID == gActivityTimeActivityID.FANTASY_LAND then
		local rewardType = self.param.rewardType
		self.rewardType = rewardType
		self.giftInfo = activity_9001717_Read.getRechargeCfg(rewardType)
		_ENV, self.giftAward = activity_9001717_Read.getRechargeGiftAward(rewardType), activity_9001717_Read.getRechargeGiftAward(rewardType)
		activity_9001717_Read.getRechargeGiftAward(rewardType)[2] = i18n("ramadan_bless_text_03")
		local activity_9001717_Read.getRechargeGiftAward(rewardType)[3], config = i18n("ramadan_bless_text_04"), activity_9001717_Read.getRechargeGiftAward(rewardType)
		self.fields.Text_Tips:setString(config[rewardType] or "")
		if rewardType == 3 then
			self.fields.text_tip:setVisible(false)
		end
		self.fields.Image_arrow1:setVisible(false)
		self.fields.Image_arrow2:setVisible(false)
	else
		self.giftInfo = activity_9001624_Read.getRechargeCfg(self.activityID)
		local rewards = activity_9001624_Read.getRewards(self.activityID)
		self.giftAward, _ENV = self.activityID, self.activityID
		local _ENV, giftAward = self.activityID, self.activityID
		for i, v in ipairs(rewards) do
			for i2, v2 in ipairs(v.advanceReward) do
				giftAward[v2.id] = giftAward[v2.id] or 0
				giftAward[v2.id] = giftAward[v2.id] + v2.count
			end
		end
		for k, v in pairs(giftAward) do
			_ENV = ipairs(v.advanceReward)
			ipairs(v.advanceReward).id = k
			ipairs(v.advanceReward).count = v
			table.insert(self.giftAward, ipairs(v.advanceReward))
		end
	end
	self.fields.Text_Title:setString(i18n(self.giftInfo.rechargeName))
	dump(self.giftInfo, "self.giftInfo")
	local nowPrice = paymentManager.judgePrice(self.giftInfo.rechargeID, self.giftInfo.rechargePrice)
	local discount = self.giftInfo.originalPrice / self.giftInfo.rechargePrice
	local oriPrice = paymentManager.calculateDiscount(self.giftInfo.rechargeID, nowPrice, discount, self.giftInfo.originalPrice)
	_ENV = discount
	discount.rid = self.giftInfo.rechargeID
	discount.nowPrice = nowPrice
	_ENV, discount.oriPrice = self.giftInfo.rechargeID, oriPrice
	discount.logInfo, self.giftInfo.rechargeID.fromCenter = self.giftInfo.rechargeID, gRechargeActiveFromEnum.ROAD46
	discount.handleBuyClick = handler(self, self.onGuyGift)
	discount.handleItemBuyClick = handler(self, self.onGuyGiftByItem)
	discount.handlePurchaseBack = handler(self, self.close)
	self.fields.Com_OutAppPurchaseButtons:initData(discount)
	self.fields.Text_GoldNum:setString(self.giftInfo.gold)
	activity_9001624_Read = self.giftInfo.gold
	self.giftInfo.gold[1] = "id"
	self.giftInfo.gold[2] = "count"
	self.allSpecialAward = serviceFunctions.tableFormat(self.giftInfo.reward, self.giftInfo.gold)
	self.fields.GiftAward:setNumItems(#self.giftAward)
	self.fields.AllSpecialAward:setNumItems(#self.allSpecialAward)
end
function Activity_9001624_BuyGiftPanel:onGiftItemRenderer(index, object)
	object:initData(self.giftAward[index + 1].id, self.giftAward[index + 1].count)
end
function Activity_9001624_BuyGiftPanel:onSpecialItemRenderer(index, object)
	object:initData(self.allSpecialAward[index + 1].id, self.allSpecialAward[index + 1].count)
end
function Activity_9001624_BuyGiftPanel:onGuyGift()
	SoraDPlaySound()
	if not self:checkGiftUnlock() then
		return
	end
	SoraDShowLoading()
	paymentManager.normalGiftBuyClassify(self.giftInfo.rechargeID)
	paymentManager.OnemtReadyBuy(self.giftInfo.rechargeID, gRechargeActiveFromEnum.ROAD18)
	self:removeFromParent()
end
function Activity_9001624_BuyGiftPanel:onGuyGiftByItem(giftId)
	if not self:checkGiftUnlock() then
		return
	end
	return true
end
function Activity_9001624_BuyGiftPanel:checkGiftUnlock(...)
	if self.activityID == gActivityTimeActivityID.FANTASY_LAND then
		local activity_9001717_Ctrl = SoraDGetCtrl("activity_9001717_Ctrl")
		if self.rewardType == 3 and not activity_9001717_Ctrl:getIsAdvanceRewardUnlock() then
			SoraDShowMsgTip(i18n("Bubble_island_rebuild_text_16"))
			return
		end
	end
	return true
end
return Activity_9001624_BuyGiftPanel
