local rechargeRead = include("rechargeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarsTowerPopFramePanel = class("StarsTowerPopFramePanel", baseFguiPanel)
function StarsTowerPopFramePanel:ctor(...)
	self.super.ctor(self, ...)
	print("StarsTowerPopFramePanel:ctor", self.viewName)
end
function StarsTowerPopFramePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarsTowerPopFramePanel:onInit()
	print("=======StarsTowerPopFramePanel:onInit")
	self.fields.Panel_bg:setString(i18n(self.param.name))
	self.fields.Text_tip:setString(i18n("common_text_789"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Lab_dis:fixPos()
	self.fields.Text_leftBuy:fixPos()
end
function StarsTowerPopFramePanel:onItemRenderer(index, obj)
	obj:initData(tonumber(self.giftArray[index + 1].id), tonumber(self.giftArray[index + 1].num))
end
function StarsTowerPopFramePanel:onShow()
	print("=======StarsTowerPopFramePanel:onShow")
	_ENV = nil
	;(nil).cur = self.param.leftBuyCount
	;(nil).total = self.param.limit
	self.fields.Text_leftBuy:setString(i18n("common_text_4417", nil))
	self.fields.Text_leftBuy:setColor(self.param.leftBuyCount > 0 and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
	self.fields.Lab_dis:setString(self.param.discount .. "%")
	self.giftArray = self.param.giftArray
	self.fields.List:setNumItems(#self.giftArray)
	_ENV = #self.giftArray
	;(#self.giftArray).rid = self.param.rechargeID
	;(#self.giftArray).nowPrice = self.param.priceStr
	_ENV, (#self.giftArray).oriPrice = self.param.oriPriceStr, self.param.oriPriceStr
	;(#self.giftArray).logInfo, self.param.oriPriceStr.fromCenter = self.param.oriPriceStr, gRechargeActiveFromEnum.ROAD42
	;(#self.giftArray).handleBuyClick = handler(self, self.onClickBuyGift)
	;(#self.giftArray).handleItemBuyClick = handler(self, self.onClickItemBuyGift)
	self.fields.Com_oap:initData(#self.giftArray)
end
function StarsTowerPopFramePanel:onClickItemBuyGift()
	SoraDPlaySound()
	if self.param.leftBuyCount <= 0 then
		SoraDShowMsgTip(i18n("Nebulastore_text_01"))
		return
	end
	return true
end
function StarsTowerPopFramePanel:onClickBuyGift()
	SoraDPlaySound()
	if self.param.leftBuyCount > 0 then
		paymentManager.OnemtReadyBuy(self.param.rechargeID, gRechargeActiveFromEnum.ROAD42)
		paymentManager.normalGiftBuyClassify(self.param.rechargeID)
	else
		SoraDShowMsgTip(i18n("Nebulastore_text_01"))
	end
end
return StarsTowerPopFramePanel
