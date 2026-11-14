local roaringFlameWarRead = include("roaringFlameWarRead")
local commonBuyGiftCtrl = SoraDGetCtrl("commonBuyGiftCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_SkillGiftPanel = class("RoaringFlame_SkillGiftPanel", baseFguiPanel)
function RoaringFlame_SkillGiftPanel:ctor(...)
	self.isLRU = true
	RoaringFlame_SkillGiftPanel.super.ctor(self, ...)
	print("RoaringFlame_SkillGiftPanel:ctor", self.viewName)
end
function RoaringFlame_SkillGiftPanel:onInit()
	print("=======RoaringFlame_SkillGiftPanel:onInit")
	self.giftData = roaringFlameWarRead.getRechargeConfig(2)
	self.curGiftID = self.giftData.rechargeID
	self.fields.title:setString(i18n("flames_dunes_text112"))
	self.fields.Text_adGet:setString(i18n("flames_dunes_text113"))
	self.fields.Label_title:setString(i18n("celebrationgift_text_6"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	_UPVALUE2_ = handler(self, self.onItemRenderer)
	handler(self, self.onItemRenderer)[1] = "id"
	handler(self, self.onItemRenderer)[2] = "count"
	self.items = serviceFunctions.tableFormat(self.giftData.rewards, handler(self, self.onItemRenderer))
	self.fields.List_reward:setNumItems(#self.items)
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
end
function RoaringFlame_SkillGiftPanel:onItemRenderer(index, obj)
	obj:initData(self.items[index + 1].id, self.items[index + 1].count)
end
function RoaringFlame_SkillGiftPanel:endShow()
	print("=======RoaringFlame_SkillGiftPanel:endShow")
	local showPrice, isGetPrice = paymentManager.judgePrice(self.curGiftID, self.giftData.price)
	local discount = self.giftData.originalPrice / self.giftData.price
	local oriShowPrice = paymentManager.calculateDiscount(self.curGiftID, showPrice, discount, self.giftData.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self:updateOutAppPurchase()
end
function RoaringFlame_SkillGiftPanel:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.curGiftID) then
		self.fields.Com_OutAppPurchaseButtons:setVisible(true)
		self.fields.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.curGiftID
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		;(false).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD58
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		;(false).handlePurchaseBack = handler(self, self.purchaseBack)
		self.fields.Com_OutAppPurchaseButtons:initData(false)
	else
		self.fields.Com_OutAppPurchaseButtons:setVisible(false)
		self.fields.Button_buy:initData(self.nowPrice, self.oriPrice)
		self.fields.Button_buy:setVisible(true)
		self.fields.Button_buy:setEnabled(true)
	end
end
function RoaringFlame_SkillGiftPanel:btnBuyClick()
	SoraDPlaySound()
	commonBuyGiftCtrl:reqBuyGift(gBuyType.ROARING_FLAME_WAR, self.curGiftID)
end
function RoaringFlame_SkillGiftPanel:purchaseBack()
	self:close()
end
return RoaringFlame_SkillGiftPanel
