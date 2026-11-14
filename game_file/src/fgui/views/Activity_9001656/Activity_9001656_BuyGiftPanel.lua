local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001656_BuyGiftPanel = class("Activity_9001656_BuyGiftPanel", baseFguiPanel)
local activity_9001656_Read = include("activity_9001656_Read")
local activity_9001656_Ctrl = SoraDGetCtrl("activity_9001656_Ctrl")
function Activity_9001656_BuyGiftPanel:ctor(...)
	Activity_9001656_BuyGiftPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001656_BuyGiftPanel:ctor", self.viewName)
end
function Activity_9001656_BuyGiftPanel:getPackageList()
	_UPVALUE1_ = nil
	;(nil)[1] = "NewServerReturn"
	return nil
end
function Activity_9001656_BuyGiftPanel:onInit()
	print("=======Activity_9001656_BuyGiftPanel:onInit")
	self.fields.title:setString(i18n("StarlitNight_text_05"))
	self.fields.Text_adGet:setString(i18n("StarlitNight_text_06"))
	self.fields.Text_buyTip:setString(i18n("StarlitNight_text_03"))
	self.fields.Text_giftGet:setString(i18n("Battle_Towers_30"))
	self.config = activity_9001656_Read.getRechargeCfg()
	self.fields.Text_GoldNum:setString(self.config.gold)
	self.fields.Button_left:addClickListener(handler(self, self.onClickLeft))
	self.fields.Button_right:addClickListener(handler(self, self.onClickRight))
	self.reward = activity_9001656_Read.getAdvanceRewardItem()
	dump(self.reward, "self.reward")
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRendererReward))
	self.fields.List_reward:setNumItems(#self.reward / 2)
	self.percent = 1 / (#self.reward / 2) + 0.028
	self.fields.List_gift:setItemRenderer(handler(self, self.onItemRendererGift))
	self.fields.List_gift:setNumItems(#self.config.reward / 2)
	self:updateBuyButton()
end
function Activity_9001656_BuyGiftPanel:onShow()
	print("=======Activity_9001656_BuyGiftPanel:onShow")
end
function Activity_9001656_BuyGiftPanel:onClickLeft()
	local pane = self.fields.List_reward:getScrollPane()
	pane:setPercX(pane:getPercX() - self.percent)
end
function Activity_9001656_BuyGiftPanel:onClickRight()
	local pane = self.fields.List_reward:getScrollPane()
	pane:setPercX(pane:getPercX() + self.percent)
end
function Activity_9001656_BuyGiftPanel:updateBuyButton()
	local nowPrice = paymentManager.judgePrice(self.config.rechargeID, self.config.rechargePrice)
	local discount = self.config.originalPrice / self.config.rechargePrice
	local oriPrice = paymentManager.calculateDiscount(self.config.rechargeID, nowPrice, discount, self.config.originalPrice)
	_ENV = discount
	discount.rid = self.config.rechargeID
	discount.nowPrice = nowPrice
	_ENV, discount.oriPrice = self.config.rechargeID, oriPrice
	discount.logInfo, self.config.rechargeID.fromCenter = self.config.rechargeID, gRechargeActiveFromEnum.ROAD46
	discount.handleBuyClick = handler(self, self.onBuyGift)
	discount.handlePurchaseBack = handler(self, self.close)
	self.fields.Com_OutAppPurchaseButtons:initData(discount)
end
function Activity_9001656_BuyGiftPanel:onItemRendererReward(index, object)
	object:initData(self.reward[index * 2 + 1], self.reward[index * 2 + 2])
end
function Activity_9001656_BuyGiftPanel:onItemRendererGift(index, object)
	_UPVALUE0_ = nil
	;(nil).id = self.config.reward[index * 2 + 1]
	;(nil).count = self.config.reward[index * 2 + 2]
	object:initData(index + 1, nil)
end
function Activity_9001656_BuyGiftPanel:onBuyGift()
	SoraDPlaySound()
	SoraDShowLoading()
	paymentManager.normalGiftBuyClassify(self.config.rechargeID)
	paymentManager.OnemtReadyBuy(self.config.rechargeID, gRechargeActiveFromEnum.ROAD18)
	self:removeFromParent()
end
function Activity_9001656_BuyGiftPanel:onShow()
	print("=======Activity_9001656_BuyGiftPanel:onShow")
end
return Activity_9001656_BuyGiftPanel
