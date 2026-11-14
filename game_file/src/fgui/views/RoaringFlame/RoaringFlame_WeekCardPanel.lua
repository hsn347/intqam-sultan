local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local commonBuyGiftCtrl = SoraDGetCtrl("commonBuyGiftCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_WeekCardPanel = class("RoaringFlame_WeekCardPanel", baseFguiPanel)
function RoaringFlame_WeekCardPanel:ctor(...)
	self.isLRU = true
	RoaringFlame_WeekCardPanel.super.ctor(self, ...)
	print("RoaringFlame_WeekCardPanel:ctor", self.viewName)
end
function RoaringFlame_WeekCardPanel:onInit()
	print("=======RoaringFlame_WeekCardPanel:onInit")
	fguiHelper.SoraDSetComFields(self)
	self.fields.Com_bg:setGradientColor()
	self.weekCfg = roaringFlameWarRead.getRechargeConfig(1)
	self.fields.Com_title:initData(i18n("flames_dunes_text51"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	local leftTime = serviceFunctions.getNextWeekDayUTC(1) - serviceFunctions.systemTime()
	self.fields.Com_title:initSpecialActivityTime(leftTime)
	self.fields.Text_tip:setString(i18n("flames_dunes_text52"))
	self.fields.Button_claim:setString(i18n("common_text_677"))
	self.fields.Button_claim:addClickListener(handler(self, self.btnClaimClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function RoaringFlame_WeekCardPanel:onItemRenderer(index, obj)
	obj:initData(index + 2)
end
function RoaringFlame_WeekCardPanel:endShow()
	print("=======RoaringFlame_WeekCardPanel:endShow")
	self:initView()
end
function RoaringFlame_WeekCardPanel:initView()
	SoraDCloseLoading(self)
	self.weekGift = roaringFlameWarCtrl:getWeeklyGift()
	self.fields.Button_claim:setVisible(self.weekGift.isBuy)
	local isCanClaim = serviceFunctions.getWeekDayEx() > self.weekGift.getedDay
	self.fields.Button_claim:setEnabled(isCanClaim)
	self.fields.Button_claim:setReddot(isCanClaim)
	self.fields.Com_OutAppPurchaseButtons:setVisible(not self.weekGift.isBuy)
	if not self.weekGift.isBuy then
		local showPrice, isGetPrice = paymentManager.judgePrice(self.weekCfg.rechargeID, self.weekCfg.price)
		local discount = self.weekCfg.originalPrice / self.weekCfg.price
		local oriShowPrice = paymentManager.calculateDiscount(self.weekCfg.rechargeID, showPrice, discount, self.weekCfg.originalPrice)
		_ENV = discount
		discount.rid = self.weekCfg.rechargeID
		discount.nowPrice = showPrice
		_ENV, discount.oriPrice = self.weekCfg.rechargeID, oriShowPrice
		discount.logInfo, self.weekCfg.rechargeID.fromCenter = self.weekCfg.rechargeID, gRechargeActiveFromEnum.ROAD57
		discount.handleBuyClick = handler(self, self.btnBuyClick)
		discount.handleItemBuyClick = handler(self, self.checkState)
		discount.handlePurchaseBack = handler(self, self.initView)
		self.fields.Com_OutAppPurchaseButtons:initData(discount)
	end
	self.fields.Com_day1:initData(1)
	self.fields.List:setNumItems(6)
end
function RoaringFlame_WeekCardPanel:checkState()
	if roaringFlameWarCtrl:getCurState() ~= ROARING_FLAME_WAR_STATE.BATTLE then
		SoraDShowMsgTip(i18n("common_text_2486"))
		return false
	end
	return true
end
function RoaringFlame_WeekCardPanel:btnBuyClick()
	SoraDPlaySound()
	if self:checkState() then
		commonBuyGiftCtrl:reqBuyGift(gBuyType.ROARING_FLAME_WAR, self.weekCfg.rechargeID)
	end
end
function RoaringFlame_WeekCardPanel:btnClaimClick()
	SoraDPlaySound()
	roaringFlameWarCtrl:reqWeeklyRewards()
	SoraDShowLoading(self)
end
function RoaringFlame_WeekCardPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("flames_dunes_second_rule23")
	;(nil).content = i18n("flames_dunes_second_rule24")
	uiManager:show("RuleView", nil)
end
return RoaringFlame_WeekCardPanel
