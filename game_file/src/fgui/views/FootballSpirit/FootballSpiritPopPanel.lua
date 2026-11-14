local footballElfCtrl = SoraDGetCtrl("footballElfCtrl")
local footballElfRead = include("footballElfRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FootballSpiritPopPanel = class("FootballSpiritPopPanel", baseFguiPanel)
function FootballSpiritPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("FootballSpiritPopPanel:ctor", self.viewName)
end
function FootballSpiritPopPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Effect_baoxiang"
	end
	return self._packageList
end
function FootballSpiritPopPanel:onInit()
	print("=======FootballSpiritPopPanel:onInit")
	self.fields.title:setString(i18n("footballelf_12"))
	self.fields.Text_giftName1:setString(i18n("footballelf_03"))
	self.fields.Text_giftName2:setString(i18n("footballelf_04"))
	self.fields.Text_tip:setString(i18n("common_text_789"))
	self.fields.List_gift1:setAlignCenter(true)
	self.fields.List_gift1:setItemRenderer(handler(self, self.cellRender1))
	self.fields.List_gift2:setAlignCenter(true)
	self.fields.List_gift2:setItemRenderer(handler(self, self.cellRender2))
end
function FootballSpiritPopPanel:cellRender1(index, obj)
	local data = self.giftList1[index + 1]
	obj:initData(data.id, data.count)
end
function FootballSpiritPopPanel:cellRender2(index, obj)
	local data = self.giftList2[index + 1]
	obj:initData(data.id, data.count)
end
function FootballSpiritPopPanel:onShow()
	print("=======FootballSpiritPopPanel:onShow")
	self.cfg1 = footballElfRead.getRechargeCfg(1)
	self.cfg2 = footballElfRead.getRechargeCfg(2)
	paymentManager.OnemtOpenGiftUI(self.cfg1.RechargeID, gRechargeActiveFromEnum.ROAD13)
	paymentManager.OnemtOpenGiftUI(self.cfg2.RechargeID, gRechargeActiveFromEnum.ROAD13)
	_UPVALUE2_ = gRechargeActiveFromEnum.ROAD13
	gRechargeActiveFromEnum.ROAD13[1] = "id"
	gRechargeActiveFromEnum.ROAD13[2] = "count"
	self.giftList1 = serviceFunctions.tableFormat(self.cfg1.Rewards, gRechargeActiveFromEnum.ROAD13)
	self.fields.List_gift1:setNumItems(#self.giftList1)
	_UPVALUE2_ = #self.giftList1
	;(#self.giftList1)[1] = "id"
	;(#self.giftList1)[2] = "count"
	self.giftList2 = serviceFunctions.tableFormat(self.cfg2.Rewards, #self.giftList1)
	self.fields.List_gift2:setNumItems(#self.giftList2)
	local info1 = paymentManager.getPaymentBullets(self.cfg1.RechargeID)
	local priceStr1 = paymentManager.getRealPrice(info1 and info1.pid, self.cfg1.Price)
	_ENV = "count"
	;("count").rid = self.cfg1.RechargeID
	;("count").nowPrice = priceStr1
	_ENV, ("count").hideDicountLine = self.cfg1.RechargeID, true
	;("count").logInfo, self.cfg1.RechargeID.fromCenter = self.cfg1.RechargeID, gRechargeActiveFromEnum.ROAD13
	;("count").handleBuyClick = handler(self, self.onClickUnlock1)
	;("count").handlePurchaseBack = handler(self, self.close)
	self.fields.Com_oap1:initData("count")
	local info2 = paymentManager.getPaymentBullets(self.cfg2.RechargeID)
	local priceStr2 = paymentManager.getRealPrice(info2 and info2.pid, self.cfg2.Price)
	_ENV = self
	self.rid = self.cfg2.RechargeID
	self.nowPrice = priceStr2
	_ENV, self.hideDicountLine = self.cfg2.RechargeID, true
	self.logInfo, self.cfg2.RechargeID.fromCenter = self.cfg2.RechargeID, gRechargeActiveFromEnum.ROAD13
	self.handleBuyClick = handler(self, self.onClickUnlock2)
	self.handlePurchaseBack = handler(self, self.close)
	self.fields.Com_oap2:initData(self)
	_ENV = self
	self.num = fguiHelper.getColorString("#FFD246", string.formatnumberthousands(footballElfRead.getItemCount()))
	self.fields.Text_extra:setString(i18n("footballelf_14", self))
end
function FootballSpiritPopPanel:onClickUnlock1()
	SoraDPlaySound()
	paymentManager.OnemtReadyBuy(self.cfg1.RechargeID, gRechargeActiveFromEnum.ROAD13)
	paymentManager.normalGiftBuyClassify(self.cfg1.RechargeID)
end
function FootballSpiritPopPanel:onClickUnlock2()
	SoraDPlaySound()
	paymentManager.OnemtReadyBuy(self.cfg2.RechargeID, gRechargeActiveFromEnum.ROAD13)
	paymentManager.normalGiftBuyClassify(self.cfg2.RechargeID)
end
return FootballSpiritPopPanel
