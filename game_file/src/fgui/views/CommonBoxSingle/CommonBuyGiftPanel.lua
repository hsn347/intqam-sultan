local commonBuyGiftUtil = include("commonBuyGiftUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonBuyGiftPanel = class("CommonBuyGiftPanel", baseFguiPanel)
function CommonBuyGiftPanel:ctor(...)
	self.isLRU = true
	CommonBuyGiftPanel.super.ctor(self, ...)
	print("CommonBuyGiftPanel:ctor", self.viewName)
end
function CommonBuyGiftPanel:onInit()
	print("=======CommonBuyGiftPanel:onInit")
	self.fields.Text_Title2:setString(i18n("Battle_Towers_30"))
	self.fields.Text_Title3:setString(i18n("common_text_789"))
	self.fields.Text_Tips:setString(i18n("ramadan_bless_text_03"))
	self.fields.GiftAward:setItemRenderer(handler(self, self.onGiftItemRenderer))
	self.fields.AllSpecialAward:setItemRenderer(handler(self, self.onSpecialItemRenderer))
end
function CommonBuyGiftPanel:endShow()
	print("=======CommonBuyGiftPanel:endShow")
	if not self.param then
		_ENV = self.param
	end
	self.param = self.param
	self.activityID = self.param.activityID or gActivityTimeActivityID.NORMAL_ACTIVITY_9001699
	self.rewardType = self.param.rewardType
	self:updateView()
end
function CommonBuyGiftPanel:updateView()
	self.giftInfo = commonBuyGiftUtil.getRechargeCfg(self.activityID, self.param)
	self.rid = self.giftInfo.rechargeID or self.giftInfo.giftId
	self.giftAward = commonBuyGiftUtil.getBattlePassRewardList(self.activityID, self.rewardType)
	local rechargeName = commonBuyGiftUtil.getRechargeName(self.activityID, self.rid)
	self.fields.Text_Title:setString(rechargeName)
	local price = self.giftInfo.rechargePrice or self.giftInfo.price
	local nowPrice = paymentManager.judgePrice(self.rid, price)
	local discount = self.giftInfo.originalPrice / price
	local oriPrice = paymentManager.calculateDiscount(self.rid, nowPrice, discount, self.giftInfo.originalPrice)
	commonBuyGiftUtil = discount
	discount.rid = self.rid
	discount.nowPrice = nowPrice
	commonBuyGiftUtil, discount.oriPrice = self.rid, oriPrice
	discount.logInfo, self.rid.fromCenter = self.rid, gRechargeActiveFromEnum.ROAD46
	discount.handleBuyClick = handler(self, self.onGuyGift)
	discount.handlePurchaseBack = handler(self, self.close)
	self.fields.Com_OutAppPurchaseButtons:initData(discount)
	self.fields.Text_GoldNum:setString(self.giftInfo.gold)
	local reward = self.giftInfo.reward or self.giftInfo.gift
	_UPVALUE2_ = handler(self, self.close)
	handler(self, self.close)[1] = "id"
	handler(self, self.close)[2] = "count"
	self.allSpecialAward = serviceFunctions.tableFormat(reward, (handler(self, self.close)))
	self.fields.AllSpecialAward:setNumItems(#self.allSpecialAward)
	self:updateActivityView()
end
function CommonBuyGiftPanel:onGiftItemRenderer(index, object)
	object:initData(self.giftAward[index + 1].id, self.giftAward[index + 1].count)
end
function CommonBuyGiftPanel:onSpecialItemRenderer(index, object)
	object:initData(self.allSpecialAward[index + 1])
end
function CommonBuyGiftPanel:onGuyGift()
	SoraDPlaySound()
	paymentManager.normalGiftBuyClassify(self.rid)
	paymentManager.OnemtReadyBuy(self.rid, gRechargeActiveFromEnum.ROAD18)
	self:removeFromParent()
end
function CommonBuyGiftPanel:updateActivityView()
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001704 then
		self.fields.GiftAward:setVisible(false)
		self.fields.Image_arrow1:setVisible(false)
		self.fields.Image_arrow2:setVisible(false)
		self:updateActivity9001704()
	elseif self.activityID == gActivityTimeActivityID.ANGRY_SNOW_WOLF_KING_ACTIVITY then
		self.fields.Image_arrow1:setVisible(false)
		self.fields.Image_arrow2:setVisible(false)
		self.fields.Text_Tips:setString(i18n("ramadan_bless_text_03"))
		self.fields.GiftAward:setVisible(true)
		self.fields.GiftAward:setNumItems(#self.giftAward)
	elseif self.activityID == gActivityTimeActivityID.UNDERWATER_TREASURE_ACTIVITY then
		self.fields.GiftAward:setVisible(true)
		self.fields.GiftAward:setNumItems(#self.giftAward)
		self.fields.Image_arrow1:setVisible(false)
		self.fields.Image_arrow2:setVisible(false)
	else
		self.fields.Text_Tips:setString(i18n("ramadan_bless_text_03"))
		self.fields.GiftAward:setVisible(true)
		self.fields.GiftAward:setNumItems(#self.giftAward)
		self.fields.Image_arrow1:setVisible(true)
		self.fields.Image_arrow2:setVisible(true)
	end
end
function CommonBuyGiftPanel:updateActivity9001704()
	self.fields.Text_Tips:setString(i18n("sky_island_text04"))
	local obj = fguiHelper.createObject("Activity_9001704", "Com_9001704_unlockList")
	obj:addTo(self.view)
	local posY = self.fields.GiftAward:getPositionY() + self.fields.GiftAward:getHeight() / 2
	obj:setPosition(self:getWidth() / 2, posY)
	local _fields = fguiHelper.get_fields(obj)
	_fields.Com_unlock1:setString(i18n("sky_island_text06"))
	_fields.Com_unlock2:setString(i18n("sky_island_text05"))
end
return CommonBuyGiftPanel
