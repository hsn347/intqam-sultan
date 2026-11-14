local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarframeExchangePopPanel = class("WarframeExchangePopPanel", baseFguiPanel)
function WarframeExchangePopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WarframeExchangePopPanel:ctor", self.viewName)
end
function WarframeExchangePopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WarframeExchangePopPanel:onInit()
	print("=======WarframeExchangePopPanel:onInit")
	self.fields.n11:fix()
	self.fields.Com_ItemTo:fixPos()
	self.fields.Com_ItemFrom:fixPos()
	self.fields.Panel_bg:setString(i18n("Soldiers_armor_text_89"))
	self.fields.Button_exchange:setTitleText(i18n("common_text_1889"))
	self.fields.Button_exchange:addClickListener(handler(self, self.btnExchangeClick))
	self.fields.Com_Slider:setSliderCallBack(handler(self, self.sliderBack))
	self:initData(self.proxy.param)
end
function WarframeExchangePopPanel:onShow()
	print("=======WarframeExchangePopPanel:onShow")
end
function WarframeExchangePopPanel:initData(data)
	self.shopItemID = data.shopItemID
	self.shopItem = data.shopItem
	self.exchangeItem = data.exchangeItem
	self.itemNum = backpackCtrl:getItemCount(data.exchangeItem[1])
	backpackCtrl = data.exchangeItem[1]
	data.exchangeItem[1].maxValue = math.min(data.limitNum - armorSystemCtrl:getCurExchangeNum(self.shopItemID), math.floor(self.itemNum / data.exchangeItem[2]))
	data.exchangeItem[1].minValue = 1
	data.exchangeItem[1].curValue = 1
	self.fields.Com_Slider:initData(data.exchangeItem[1])
	self.fields.Com_ItemTo:initData(self.shopItem[1], self.shopItem[2])
	self.fields.Com_ItemFrom:initData(self.exchangeItem[1], self.exchangeItem[2])
end
function WarframeExchangePopPanel:sliderBack(value)
	self.exchageNum = value
	self.fields.Com_ItemTo:initData(self.shopItem[1], self.shopItem[2] * self.exchageNum)
	self.fields.Com_ItemFrom:initData(self.exchangeItem[1], self.exchangeItem[2] * self.exchageNum)
end
function WarframeExchangePopPanel:btnExchangeClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).shopItemID = self.shopItemID
	;(nil).count = self.exchageNum
	armorSystemCtrl:reqArmorExchange(nil)
	self:removeFromParent()
end
return WarframeExchangePopPanel
