local activity_9001710_Read = include("activity_9001710_Read")
local rechargeRead = include("rechargeRead")
local commonBuyGiftCtrl = SoraDGetCtrl("commonBuyGiftCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001710_GiftPanel = class("Activity_9001710_GiftPanel", baseFguiPanel)
function Activity_9001710_GiftPanel:ctor(...)
	self.isLRU = true
	Activity_9001710_GiftPanel.super.ctor(self, ...)
	print("Activity_9001710_GiftPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CRESCENT_ORDER_ACTIVITY
end
function Activity_9001710_GiftPanel:onInit()
	print("=======Activity_9001710_GiftPanel:onInit")
	self.Text_tips = SoraDCreateTimerLabel(self, self.fields.Text_tips)
	self.Text_tips:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#F0E6D2", strTime)
		return i18n("CrescentDecree_text_04", nil)
	end)
	self.fields.Button_help:addClickListener(handler(self, self.onHelpClick))
	self.fields.List_buff:setItemRenderer(handler(self, self.onBuffItemRender))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Label_title:setString(i18n("Battle_Towers_30"))
	self.fields.Button_recharge:addClickListener(handler(self, self.btnBuyClick))
end
function Activity_9001710_GiftPanel:onBuffItemRender(index, obj)
	local data = self.buffList[index + 1]
	obj:setIcon(data.bufftIcon)
	obj:setTitle(i18n(data.buffDescription))
end
function Activity_9001710_GiftPanel:onItemRender(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Activity_9001710_GiftPanel:endShow()
	print("=======Activity_9001710_GiftPanel:endShow")
	self.cfg = activity_9001710_Read.getRechargeCfg()
	local pageInfo = rechargeRead.getPageViewData(self.cfg.rechargeID)
	self.fields.Text_title:setString(i18n(pageInfo.activeName))
	self.Text_tips:beginTime(activityShowCtrl:getRemainTime(self.activityID))
	self.buffList = activity_9001710_Read.getBuffCfg()
	self.fields.List_buff:setNumItems(#self.buffList)
	self:initGiftInfo()
end
function Activity_9001710_GiftPanel:initGiftInfo()
	self.fields.Text_gold:setString(self.cfg.gold)
	_UPVALUE2_ = self.cfg.gold
	self.cfg.gold[1] = "id"
	self.cfg.gold[2] = "count"
	self.reward = serviceFunctions.tableFormat(self.cfg.rewards, self.cfg.gold)
	self.fields.List_item:setNumItems(#self.reward)
	local showPrice, isGetPrice = paymentManager.judgePrice(self.cfg.rechargeID, self.cfg.price)
	local discount = self.cfg.originalPrice / self.cfg.price
	local oriShowPrice = paymentManager.calculateDiscount(self.cfg.rechargeID, showPrice, discount, self.cfg.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self:updateOutAppPurchase()
end
function Activity_9001710_GiftPanel:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.cfg.rechargeID) then
		self.fields.Com_OutAppPurchaseButtons:setVisible(true)
		self.fields.Button_recharge:setVisible(false)
		_ENV = false
		;(false).rid = self.cfg.rechargeID
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		;(false).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD60
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.fields.Com_OutAppPurchaseButtons:initData(false)
	else
		self.fields.Com_OutAppPurchaseButtons:setVisible(false)
		self.fields.Button_recharge:initData(self.nowPrice, self.oriPrice)
		self.fields.Button_recharge:setVisible(true)
		self.fields.Button_recharge:setEnabled(true)
	end
end
function Activity_9001710_GiftPanel:btnBuyClick()
	SoraDPlaySound()
	commonBuyGiftCtrl:reqBuyGift(gBuyType.CRESCENT_ORDER, self.cfg.rechargeID)
end
function Activity_9001710_GiftPanel:buyGiftBack()
	self:close()
end
function Activity_9001710_GiftPanel:onHelpClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001710_Buff")
end
return Activity_9001710_GiftPanel
