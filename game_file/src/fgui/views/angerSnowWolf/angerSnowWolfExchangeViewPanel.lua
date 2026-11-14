local angrySnowWolfKingCtrl = SoraDGetCtrl("angrySnowWolfKingCtrl")
local snowWolfltCtrl = gModuleMgr.sharedMgr("snowWolfltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local angerSnowWolfExchangeViewPanel = class("angerSnowWolfExchangeViewPanel", baseFguiPanel)
function angerSnowWolfExchangeViewPanel:ctor(...)
	angerSnowWolfExchangeViewPanel.super.ctor(self, ...)
	print("angerSnowWolfExchangeViewPanel:ctor", self.viewName)
end
function angerSnowWolfExchangeViewPanel:onInit()
	print("=======angerSnowWolfExchangeViewPanel:onInit")
	self.priceConfig, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("Challenge_SnowWolf_text_06"))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
end
function angerSnowWolfExchangeViewPanel:onShow()
	print("=======angerSnowWolfExchangeViewPanel:onShow")
	self:initData()
end
function angerSnowWolfExchangeViewPanel:onItemRenderer(index, obj)
	obj:initData(gAngrySnowWolfKingItem[index + 1])
end
function angerSnowWolfExchangeViewPanel:onListRenderer(index, obj)
	obj:initData(self.priceConfig[index + 1], index + 1)
end
function angerSnowWolfExchangeViewPanel:initData(target, redata)
	self.priceConfig = clone(snowWolfltCtrl:get_feahtershop(angrySnowWolfKingCtrl:getZeroLv()))
	self.fields.List:setNumItems(#self.priceConfig)
	self.fields.List:setScrollEnable(#self.priceConfig * 154 > self.fields.List:getHeight())
	self.fields.List_item:setNumItems(#gAngrySnowWolfKingItem)
end
return angerSnowWolfExchangeViewPanel
