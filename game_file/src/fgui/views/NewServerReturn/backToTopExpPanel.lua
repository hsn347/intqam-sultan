local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local backToTopRead = include("backToTopRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local backToTopExpPanel = class("backToTopExpPanel", baseFguiPanel)
function backToTopExpPanel:ctor(...)
	self.super.ctor(self, ...)
	print("backToTopExpPanel:ctor", self.viewName)
end
function backToTopExpPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function backToTopExpPanel:onInit()
	print("=======backToTopExpPanel:onInit")
	self.rechargeID = 19079
	paymentManager.OnemtOpenGiftUI(self.rechargeID, gRechargeActiveFromEnum.ROAD13)
	self.fields.Panel_bg:setString(i18n("rechare_activename_19079"))
	self.fields.Text_tip:setString(i18n("rechare_activeexplain_19079"))
	self.fields.List_award:setAlignCenter(true)
	self.fields.List_award:setItemRenderer(handler(self, self.cellRender))
end
function backToTopExpPanel:cellRender(index, obj)
	local data = self.giftCfg[index + 1]
	obj:initData(data.id, data.count)
end
function backToTopExpPanel:onShow()
	print("=======backToTopExpPanel:onShow")
	local info = paymentManager.getPaymentBullets(self.rechargeID)
	local price, gold, award = backToTopRead.getGiftInfo(self.rechargeID)
	local priceStr, __ = paymentManager.getRealPrice(info and info.pid, price)
	self.priceStr = priceStr
	_ENV = nil
	;(nil).rid = self.rechargeID
	;(nil).nowPrice = self.priceStr
	_ENV, (nil).hideDicountLine = self.priceStr, true
	;(nil).logInfo, self.priceStr.fromCenter = self.priceStr, gRechargeActiveFromEnum.ROAD13
	;(nil).handleBuyClick = handler(self, self.onClickUnlock)
	;(nil).handlePurchaseBack = handler(self, self.close)
	self.fields.Com_recharge:initData(nil)
	self.fields.Text_GoldNum:setString(string.formatnumberthousands(gold))
	self.giftCfg = award
	self.fields.List_award:setNumItems(#self.giftCfg)
end
function backToTopExpPanel:onClickUnlock()
	SoraDPlaySound()
	paymentManager.OnemtReadyBuy(self.rechargeID, gRechargeActiveFromEnum.ROAD13)
	paymentManager.normalGiftBuyClassify(self.rechargeID)
end
return backToTopExpPanel
