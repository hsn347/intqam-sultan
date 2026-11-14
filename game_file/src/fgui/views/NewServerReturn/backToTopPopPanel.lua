local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local backToTopRead = include("backToTopRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local backToTopPopPanel = class("backToTopPopPanel", baseFguiPanel)
function backToTopPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("backToTopPopPanel:ctor", self.viewName)
end
function backToTopPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function backToTopPopPanel:onInit()
	print("=======backToTopPopPanel:onInit")
	self.rechargeID = 19080
	paymentManager.OnemtOpenGiftUI(self.rechargeID, gRechargeActiveFromEnum.ROAD13)
	self.fields.title:setString(i18n("return_peak_05"))
	self.fields.Text_adGet:setString(i18n("PrideRebate_text_25"))
	self.fields.Text_giftGet:setString(i18n("return_peak_07"))
	self.fields.List_reward:setAlignCenter(true)
	self.fields.List_reward:setItemRenderer(handler(self, self.cellRender1))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.cellRender2))
end
function backToTopPopPanel:cellRender1(index, obj)
	local data = self.giftCfg[index + 1]
	obj:initData(data.id, data.count)
end
function backToTopPopPanel:cellRender2(index, obj)
	local data = self.peakCfg[index + 1]
	obj:initData(data.id, data.count)
end
function backToTopPopPanel:onShow()
	print("=======backToTopPopPanel:onShow")
	local info = paymentManager.getPaymentBullets(self.rechargeID)
	local price, gold, award = backToTopRead.getGiftInfo(self.rechargeID)
	local priceStr, __ = paymentManager.getRealPrice(info and info.pid, price)
	self.priceStr = priceStr
	_ENV = nil
	;(nil).rid = self.rechargeID
	;(nil).nowPrice = self.priceStr
	_ENV, (nil).hideDicountLine = self.priceStr, true
	;(nil).logInfo, self.priceStr.fromCenter = self.priceStr, gRechargeActiveFromEnum.ROAD13
	;(nil).oriPrice = i18n("return_peak_05")
	;(nil).handleBuyClick = handler(self, self.onClickUnlock)
	;(nil).handlePurchaseBack = handler(self, self.close)
	self.fields.Com_OutAppPurchaseButtons:initData(nil)
	self.fields.Text_GoldNum:setString(string.formatnumberthousands(gold))
	self.giftCfg = award
	self.fields.List_reward:setNumItems(#self.giftCfg)
	self.peakCfg = backToTopRead.getAllPeakReward()
	self.fields.List:setNumItems(#self.peakCfg)
end
function backToTopPopPanel:onClickUnlock()
	SoraDPlaySound()
	paymentManager.OnemtReadyBuy(self.rechargeID, gRechargeActiveFromEnum.ROAD13)
	paymentManager.normalGiftBuyClassify(self.rechargeID)
end
return backToTopPopPanel
