local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local footballElfCtrl = SoraDGetCtrl("footballElfCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FootballSpiritPropPanel = class("FootballSpiritPropPanel", baseFguiPanel)
function FootballSpiritPropPanel:ctor(...)
	self.super.ctor(self, ...)
	print("FootballSpiritPropPanel:ctor", self.viewName)
end
function FootballSpiritPropPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function FootballSpiritPropPanel:onInit()
	print("=======FootballSpiritPropPanel:onInit")
	self.itemID = 858801
	self.shopItem = shopltCtrl:getQuickShopItemArrayByItemID(self.itemID)[1].shopItemID
	self.price = shopltCtrl:getPrice(self.shopItem)
	self.count = 1
	self.fields.text_des:setString(publicRead.getDes(self.itemID))
	self.fields.bg:setString(i18n("equip_text_46"))
	self.fields.slider:setSliderCallBack(handler(self, self.onSliderChange))
	self.fields.btn_buy:setString(i18n("common_text_282"))
	self.fields.btn_buy:addClickListener(handler(self, self.onBtnBuy))
	self.fields.btn_use:setString(i18n("common_text_314"))
	self.fields.btn_use:addClickListener(handler(self, self.onBtnUse))
	self.fields.slider:setInpuBoxFixPos()
end
function FootballSpiritPropPanel:onShow()
	print("=======FootballSpiritPropPanel:onShow")
	self.controllers.c1:setSelectedIndex(self.param.pType)
	self.gold = SoraDGetGold()
	self.max = math.min(backpackltCtrl:getBuyMax(self.itemID), math.floor(self.gold / self.price))
	if self.param.pType == 1 then
		self.max = math.min(backpackCtrl:getItemCount(self.itemID), backpackltCtrl:getUseMax(self.itemID))
		self.count = self.max
		self.fields.bg:setString(i18n("common_text_284"))
	end
	_ENV = i18n("common_text_284")
	i18n("common_text_284").maxValue = self.max
	i18n("common_text_284").minValue = 1
	i18n("common_text_284").curValue = self.count
	self.fields.slider:initData(i18n("common_text_284"))
	self.fields.item:fixPos()
	self.fields.text_des:fixPos()
end
function FootballSpiritPropPanel:onSliderChange(val)
	self.count = val
	self.fields.item:initData(self.itemID, self.count)
	if self.param.pType == 0 then
		self.fields.btn_buy:setCostNum(self.count * self.price, self.gold)
	end
end
function FootballSpiritPropPanel:onBtnBuy()
	SoraDPlaySound()
	if SoraDEnoughGold(self.count * self.price) then
		shopCtrl:reqBuyInItemShop(self.shopItem, self.count)
		self:close()
	end
end
function FootballSpiritPropPanel:onBtnUse()
	SoraDPlaySound()
	footballElfCtrl:sendUseProp(self.count)
	self:close()
end
return FootballSpiritPropPanel
