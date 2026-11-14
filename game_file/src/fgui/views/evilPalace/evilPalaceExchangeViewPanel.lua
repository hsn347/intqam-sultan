local monsterpalaceCtrl = SoraDGetCtrl("monsterpalaceCtrl")
local monsterpalaceltCtrl = gModuleMgr.sharedMgr("monsterpalaceltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local evilPalaceExchangeViewPanel = class("evilPalaceExchangeViewPanel", baseFguiPanel)
function evilPalaceExchangeViewPanel:ctor(...)
	evilPalaceExchangeViewPanel.super.ctor(self, ...)
	print("evilPalaceExchangeViewPanel:ctor", self.viewName)
end
function evilPalaceExchangeViewPanel:onInit()
	print("=======evilPalaceExchangeViewPanel:onInit")
	self.priceConfig, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("common_text_3289"))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
end
function evilPalaceExchangeViewPanel:onShow()
	print("=======evilPalaceExchangeViewPanel:onShow")
	self:initData()
end
function evilPalaceExchangeViewPanel:onItemRenderer(index, obj)
	obj:initData(gMonsterpalaceFeather[index + 1])
end
function evilPalaceExchangeViewPanel:onListRenderer(index, obj)
	obj:initData(self.priceConfig[index + 1], index + 1)
end
function evilPalaceExchangeViewPanel:initData(target, redata)
	self.priceConfig = clone(monsterpalaceltCtrl:get_feahtershop(monsterpalaceCtrl:getZeroLv()))
	self.fields.List:setNumItems(#self.priceConfig)
	self.fields.List:setScrollEnable(#self.priceConfig * 154 > self.fields.List:getHeight())
	self.fields.List_item:setNumItems(#gMonsterpalaceFeather)
end
return evilPalaceExchangeViewPanel
