local activity_9001719_Read = include("activity_9001719_Read")
local commonBuyGiftCtrl = SoraDGetCtrl("commonBuyGiftCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001719_BuyGiftPanel = class("Activity_9001719_BuyGiftPanel", baseFguiPanel)
function Activity_9001719_BuyGiftPanel:ctor(...)
	self.isLRU = true
	Activity_9001719_BuyGiftPanel.super.ctor(self, ...)
	print("Activity_9001719_BuyGiftPanel:ctor", self.viewName)
end
function Activity_9001719_BuyGiftPanel:onInit()
	print("=======Activity_9001719_BuyGiftPanel:onInit")
	self.giftList, _ENV, self.reward, _ENV = print, print, print, print
	self.cfg = activity_9001719_Read.getRechargeCfg()
	self.fields.Text_Title:setString(i18n("magic_carpet_02"))
	self.fields.Text_Tips:setString(i18n("ramadan_bless_text_03"))
	self.fields.Text_Title2:setString(i18n("Battle_Towers_30"))
	self.fields.Text_Title3:setString(i18n("common_text_789"))
	self.fields.GiftAward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.AllSpecialAward:setItemRenderer(handler(self, self.onRewardRenderer))
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
end
function Activity_9001719_BuyGiftPanel:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Activity_9001719_BuyGiftPanel:onRewardRenderer(index, obj)
	obj:initData(self.giftList[index + 1], index + 1)
end
function Activity_9001719_BuyGiftPanel:endShow()
	print("=======Activity_9001719_BuyGiftPanel:endShow")
	self.rid = self.cfg.rechargeID
	self.reward = activity_9001719_Read.getAdvRewards()
	self.fields.GiftAward:setNumItems(#self.reward)
	local showPrice, isGetPrice = paymentManager.judgePrice(self.rid, self.cfg.rechargePrice)
	local discount = self.cfg.originalPrice / self.cfg.rechargePrice
	local oriShowPrice = paymentManager.calculateDiscount(self.rid, showPrice, discount, self.cfg.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self:updateOutAppPurchase()
	self.fields.Text_GoldNum:setString(self.cfg.gold)
	_UPVALUE2_ = self.cfg.gold
	self.cfg.gold[1] = "id"
	self.cfg.gold[2] = "count"
	self.giftList = serviceFunctions.tableFormat(self.cfg.reward, self.cfg.gold)
	self.fields.AllSpecialAward:setNumItems(#self.giftList)
end
function Activity_9001719_BuyGiftPanel:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.rid) then
		self.fields.Com_OutAppPurchaseButtons:setVisible(true)
		self.fields.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.rid
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		;(false).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD62
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.fields.Com_OutAppPurchaseButtons:initData(false)
	else
		self.fields.Com_OutAppPurchaseButtons:setVisible(false)
		self.fields.Button_buy:initData(self.nowPrice, self.oriPrice)
		self.fields.Button_buy:setVisible(true)
		self.fields.Button_buy:setEnabled(true)
	end
end
function Activity_9001719_BuyGiftPanel:onBuyGiftMsg(target, data)
	self:close()
end
function Activity_9001719_BuyGiftPanel:btnBuyClick()
	SoraDPlaySound()
	commonBuyGiftCtrl:reqBuyGift(gBuyType.MAGIC_CARPET, self.rid)
end
return Activity_9001719_BuyGiftPanel
