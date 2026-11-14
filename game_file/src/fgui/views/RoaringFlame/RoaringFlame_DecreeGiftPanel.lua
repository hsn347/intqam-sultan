local roaringFlameWarRead = include("roaringFlameWarRead")
local commonBuyGiftCtrl = SoraDGetCtrl("commonBuyGiftCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_DecreeGiftPanel = class("RoaringFlame_DecreeGiftPanel", baseFguiPanel)
function RoaringFlame_DecreeGiftPanel:ctor(...)
	RoaringFlame_DecreeGiftPanel.super.ctor(self, ...)
	print("RoaringFlame_DecreeGiftPanel:ctor", self.viewName)
end
function RoaringFlame_DecreeGiftPanel:onInit()
	print("=======RoaringFlame_DecreeGiftPanel:onInit")
	self.giftList, _ENV, self.reward, _ENV = print, print, print, print
	self.fields.title:setString(i18n("flames_dunes_text18"))
	self.fields.Text_adGet:setString(i18n("StarlitNight_text_14"))
	self.fields.Text_giftGet:setString(i18n("Battle_Towers_30"))
	self.fields.Text_tip:setString(i18n("common_text_789"))
	self.fields.Text_buyTip:setString(i18n("flames_dunes_text19"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_gift:setItemRenderer(handler(self, self.onRewardRenderer))
	self.fields.Button_left:addClickListener(handler(self, self.onClickLeft))
	self.fields.Button_right:addClickListener(handler(self, self.onClickRight))
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
	self.fields.Text_GoldNum:fixPos()
	self.fields.gold:fixPos()
	self.fields.gold:fix()
end
function RoaringFlame_DecreeGiftPanel:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function RoaringFlame_DecreeGiftPanel:onRewardRenderer(index, obj)
	obj:initData(self.giftList[index + 1], index + 1)
end
function RoaringFlame_DecreeGiftPanel:onShow()
	print("=======RoaringFlame_DecreeGiftPanel:onShow")
	self.reward = roaringFlameWarRead.getDecreeAdvRewards()
	self.fields.List_reward:setNumItems(#self.reward)
	self.percent = 0.5
	self.cfg = roaringFlameWarRead.getRechargeConfig(3)
	self.rid = self.cfg.rechargeID
	local showPrice, isGetPrice = paymentManager.judgePrice(self.rid, self.cfg.price)
	local discount = self.cfg.price / self.cfg.originalPrice
	local oriShowPrice = paymentManager.calculateDiscount(self.rid, showPrice, discount, self.cfg.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self:updateOutAppPurchase()
	self.fields.Text_GoldNum:setString(self.cfg.gold)
	_UPVALUE2_ = self.cfg.gold
	self.cfg.gold[1] = "id"
	self.cfg.gold[2] = "count"
	self.giftList = serviceFunctions.tableFormat(self.cfg.rewards, self.cfg.gold)
	self.fields.List_gift:setNumItems(#self.giftList)
end
function RoaringFlame_DecreeGiftPanel:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.rid) then
		self.fields.Com_OutAppPurchaseButtons:setVisible(true)
		self.fields.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.rid
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		;(false).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD56
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.fields.Com_OutAppPurchaseButtons:initData(false)
	else
		self.fields.Com_OutAppPurchaseButtons:setVisible(false)
		self.fields.Button_buy:initData(self.nowPrice, self.oriPrice)
		self.fields.Button_buy:setVisible(true)
		self.fields.Button_buy:setEnabled(true)
	end
end
function RoaringFlame_DecreeGiftPanel:onBuyGiftMsg(target, data)
	if data and data.rid == self.rid and data.success then
		self:close()
	end
end
function RoaringFlame_DecreeGiftPanel:onClickLeft()
	local pane = self.fields.List_reward:getScrollPane()
	pane:setPercX(pane:getPercX() - self.percent, true)
end
function RoaringFlame_DecreeGiftPanel:onClickRight()
	local pane = self.fields.List_reward:getScrollPane()
	pane:setPercX(pane:getPercX() + self.percent, true)
end
function RoaringFlame_DecreeGiftPanel:btnBuyClick()
	SoraDPlaySound()
	commonBuyGiftCtrl:reqBuyGift(gBuyType.ROARING_FLAME_WAR, self.rid)
end
return RoaringFlame_DecreeGiftPanel
