local constantRead = include("constantRead")
local rechargeRead = include("rechargeRead")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroReforgeGiftPanel = class("HeroReforgeGiftPanel", baseFguiPanel)
function HeroReforgeGiftPanel:ctor(...)
	HeroReforgeGiftPanel.super.ctor(self, ...)
	print("HeroReforgeGiftPanel:ctor", self.viewName)
end
function HeroReforgeGiftPanel:onInit()
	print("=======HeroReforgeGiftPanel:onInit")
	self.reward, _ENV = print, print
	self.rid = constantRead.getConstValue("HERO_RESHAPE_GIFT_ID", 19669)
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRederer))
end
function HeroReforgeGiftPanel:onItemRederer(index, obj)
	obj:initData(tonumber(self.reward[index + 1].id), tonumber(self.reward[index + 1].num))
end
function HeroReforgeGiftPanel:onShow()
	print("=======HeroReforgeGiftPanel:onShow")
	self.giftStyle = rechargeRead.getSpecialRechargeCfg(self.rid)
	self.rechargeData = rechargeActivityCtrl:getRechargeActivityData(self.rid)
	self.fields.Text_name:setString(i18n(self.giftStyle.rechargeName))
	self.reward = SoraDArrary2Table(self.rechargeData.gift)
	_ENV = i18n(self.giftStyle.rechargeName)
	i18n(self.giftStyle.rechargeName).id = gIDDef.GOLD
	i18n(self.giftStyle.rechargeName).num = self.giftStyle.gold
	table.insert(self.reward, 1, i18n(self.giftStyle.rechargeName))
	self.fields.List_reward:setNumItems(#self.reward)
	local showPrice, isGetPrice = paymentManager.judgePrice(self.rid, self.rechargeData.price)
	local discount = self.rechargeData.originalPrice / self.rechargeData.price
	local oriShowPrice = paymentManager.calculateDiscount(self.rid, showPrice, discount, self.rechargeData.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self.fields.Lab_discount:setString(self.giftStyle.discount[2] .. "%")
	local leftTime = self.rechargeData.endtime - serviceFunctions.systemTime()
	if 0 < leftTime then
		self.fields.time:beginTime(leftTime)
	end
	self:initView()
end
function HeroReforgeGiftPanel:initView()
	local rechargeData = rechargeActivityCtrl:getRechargeActivityData(self.rid)
	self.isHaveGift = rechargeData and true or false
	local limitNum = self.giftStyle.limitNum
	local leftTimes = self.isHaveGift and limitNum or 0
	rechargeActivityCtrl = nil
	;(nil).cur = fguiHelper.getColorString(limitNum > leftTimes and "#BE2828" or "#CDBE94", leftTimes)
	;(nil).total = limitNum
	self.fields.Text_explain:setString(i18n("common_text_4417", nil) .. "\n" .. i18n(self.giftStyle.rechargeDes))
	self:updateOutAppPurchase()
end
function HeroReforgeGiftPanel:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.rid) then
		self.fields.outAppPurchaseButtons:setVisible(true)
		self.fields.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.rid
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		;(false).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD55
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		;(false).handleItemBuyClick = not self.isHaveGift and handler(self, self.btnBuyClick)
		self.fields.outAppPurchaseButtons:initData(false)
		self.fields.outAppPurchaseButtons:setBrightBtn(self.isHaveGift)
	else
		self.fields.outAppPurchaseButtons:setVisible(false)
		self.fields.Button_buy:initData(self.nowPrice, self.oriPrice)
		self.fields.Button_buy:setVisible(true)
		self.fields.Button_buy:setEnabled(true)
		self.fields.Button_buy:setBright(self.isHaveGift)
	end
end
function HeroReforgeGiftPanel:btnBuyClick()
	SoraDPlaySound()
	if self.isHaveGift then
		paymentManager.normalGiftBuyClassify(self.rid)
		paymentManager.OnemtReadyBuy(self.rid, gRechargeActiveFromEnum.ROAD55)
	else
		SoraDShowMsgTip(i18n("back_recharge_text13"))
	end
end
return HeroReforgeGiftPanel
