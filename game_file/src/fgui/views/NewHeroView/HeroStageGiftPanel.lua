local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroPowerSkillGiftCtrl = SoraDGetCtrl("heroPowerSkillGiftCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroStageGiftPanel = class("HeroStageGiftPanel", baseFguiPanel)
function HeroStageGiftPanel:ctor(...)
	HeroStageGiftPanel.super.ctor(self, ...)
	print("HeroStageGiftPanel:ctor", self.viewName)
end
function HeroStageGiftPanel:onInit()
	print("=======HeroStageGiftPanel:onInit")
	self.fields.Text_name:setString(i18n("common_text_4817"))
	self.fields.Text_timer:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("common_text_4823", nil)
	end)
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRederer))
end
function HeroStageGiftPanel:onItemRederer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function HeroStageGiftPanel:onShow()
	print("=======HeroStageGiftPanel:onShow")
	self.rid = self.param.rid
	self.giftCfg = heroltCtrl:getHeroStageGiftCfg(self.rid)
	self.fields.Lab_discount:setString(self.giftCfg.discount .. "%")
	_UPVALUE2_ = self.giftCfg.discount .. "%"
	;(self.giftCfg.discount .. "%")[1] = "id"
	;(self.giftCfg.discount .. "%")[2] = "count"
	self.reward = serviceFunctions.tableFormat(self.giftCfg.reward, self.giftCfg.discount .. "%")
	self.fields.List_reward:setNumItems(#self.reward)
	local showPrice, isGetPrice = paymentManager.judgePrice(self.rid, self.giftCfg.rechargePrice)
	local discount = self.giftCfg.rechargePrice / self.giftCfg.originalPrice
	local oriShowPrice = paymentManager.calculateDiscount(self.rid, showPrice, discount, self.giftCfg.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
	self:updateOutAppPurchase()
	self:initData()
end
function HeroStageGiftPanel:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.rid) then
		self.fields.outAppPurchaseButtons:setVisible(true)
		self.fields.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.rid
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		;(false).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD54
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.fields.outAppPurchaseButtons:initData(false)
	else
		self.fields.outAppPurchaseButtons:setVisible(false)
		self.fields.Button_buy:initData(self.nowPrice, self.oriPrice)
		self.fields.Button_buy:setVisible(true)
		self.fields.Button_buy:setEnabled(true)
	end
end
function HeroStageGiftPanel:initData()
	local ret, count, leftTime = heroPowerSkillGiftCtrl:getGiftBuyTimes(self.rid)
	if 0 < count then
		heroPowerSkillGiftCtrl = nil
		;(nil).left = count
		;(nil).limit = self.giftCfg.limitTime
		self.fields.Text_left:setString(i18n("common_text_4824", nil))
		self.fields.Text_timer:beginTime(leftTime)
	else
		self:close()
	end
end
function HeroStageGiftPanel:btnBuyClick()
	SoraDPlaySound()
	paymentManager.normalGiftBuyClassify(self.rid)
	paymentManager.OnemtReadyBuy(self.rid, gRechargeActiveFromEnum.ROAD54)
end
return HeroStageGiftPanel
