local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local starryNightCarnivalltCtrl = include("starryNightCarnivalltCtrl")
local starryNightCarnivalCtrl = SoraDGetCtrl("starryNightCarnivalCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarryNightCarnivalBuyGiftPanel = class("StarryNightCarnivalBuyGiftPanel", baseFguiPanel)
function StarryNightCarnivalBuyGiftPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarryNightCarnivalBuyGiftPanel:ctor", self.viewName)
end
function StarryNightCarnivalBuyGiftPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NewServerReturn"
		self._packageList, self._packageList[2] = self._packageList, "fonts"
	end
	return self._packageList
end
function StarryNightCarnivalBuyGiftPanel:onInit()
	print("=======StarryNightCarnivalBuyGiftPanel:onInit")
	self.isEx2 = self.param.isEx2
	if self.isEx2 then
		self.fields.title:setString(i18n("StarlitNight_text_13"))
		self.fields.Text_adGet:setString(i18n("StarlitNight_text_14"))
		self.fields.Text_buyTip:setString(i18n("StarlitNight_text_15"))
	else
		self.fields.title:setString(i18n("StarlitNight_text_05"))
		self.fields.Text_adGet:setString(i18n("StarlitNight_text_06"))
		self.fields.Text_buyTip:setString(i18n("StarlitNight_text_03"))
	end
	self.fields.Text_giftGet:setString(i18n("Battle_Towers_30"))
	self.fields.Text_tip:setString(i18n("common_text_789"))
	self.config = starryNightCarnivalltCtrl.getRechargeCfg(self.isEx2)
	self.fields.Text_GoldNum:setString(self.config.Gold)
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.fields.Button_buyOAP:addClickListener(handler(self, self.onClickBuy))
	self.fields.Button_left:addClickListener(handler(self, self.onClickLeft))
	self.fields.Button_right:addClickListener(handler(self, self.onClickRight))
	self.classType = activityShowCtrl:getParamByID(gActivityTimeActivityID.STARRY_NIGHT_CARNIVAL).classtype
	self.reward = self.isEx2 and starryNightCarnivalltCtrl.getSeniorRewardItem(self.classType) or starryNightCarnivalltCtrl.getAdvanceRewardItem(self.classType)
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRendererReward))
	self.fields.List_reward:setNumItems(table.nums(self.reward) / 2)
	self.percent = 1 / (table.nums(self.reward) / 2) + 0.028
	self.fields.List_gift:setItemRenderer(handler(self, self.onItemRendererGift))
	self.fields.List_gift:setNumItems(table.nums(self.config.Rewards) / 2)
	self:updateBuyButton()
	dump(self.fields.List_reward:getFirstChildInView(), "fjslafjsjfkjkfjk")
	self.controllers.c1:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
end
function StarryNightCarnivalBuyGiftPanel:onClickLeft()
	local pane = self.fields.List_reward:getScrollPane()
	pane:setPercX(pane:getPercX() - self.percent)
end
function StarryNightCarnivalBuyGiftPanel:onClickRight()
	local pane = self.fields.List_reward:getScrollPane()
	pane:setPercX(pane:getPercX() + self.percent)
end
function StarryNightCarnivalBuyGiftPanel:updateBuyButton()
	self.fields.Button_buyOAP:initData(nil, nil, self.config.rechargeID)
	local nowPrice = paymentManager.judgePrice(self.config.rechargeID, self.config.price)
	local discount = self.config.OriginalPrice / self.config.price
	local oriPrice = paymentManager.calculateDiscount(self.config.rechargeID, nowPrice, discount, self.config.OriginalPrice)
	self.fields.Button_buy:initData(nowPrice, oriPrice, self.config.rechargeID)
end
function StarryNightCarnivalBuyGiftPanel:onItemRendererReward(index, object)
	object:initData(self.reward[index * 2 + 1], self.reward[index * 2 + 2])
end
function StarryNightCarnivalBuyGiftPanel:onItemRendererGift(index, object)
	_UPVALUE0_ = nil
	;(nil).id = self.config.Rewards[index * 2 + 1]
	;(nil).count = self.config.Rewards[index * 2 + 2]
	object:initData(index + 1, nil)
end
function StarryNightCarnivalBuyGiftPanel:onClickBuy(eventContext)
	if self.isEx2 and not starryNightCarnivalCtrl:getUnlockFurther() then
		SoraDShowMsgTip(i18n("StarlitNight_text_17"))
		return
	end
	local name = eventContext:getSender():getName()
	if name == "Button_buy" then
		starryNightCarnivalCtrl:sendOpenFutherRewardMsg(self.isEx2 and 2 or 1)
		paymentManager.OnemtReadyBuy(self.config.rechargeID, gRechargeActiveFromEnum.ROAD32)
	elseif name == "Button_buyOAP" then
		starryNightCarnivalCtrl, starryNightCarnivalCtrl = i18n("StarlitNight_text_17")
		i18n("StarlitNight_text_17").fromCenter = gRechargeActiveFromEnum.ROAD32
		SoraDShowH5PurchaseView(self.config.rechargeID, gRechargeActiveFromEnum.ROAD32, i18n("StarlitNight_text_17"))
	end
	self:close()
end
function StarryNightCarnivalBuyGiftPanel:onShow()
	print("=======StarryNightCarnivalBuyGiftPanel:onShow")
end
return StarryNightCarnivalBuyGiftPanel
