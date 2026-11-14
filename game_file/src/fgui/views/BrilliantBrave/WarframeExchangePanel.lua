local armorSystemRead = include("armorSystemRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarframeExchangePanel = class("WarframeExchangePanel", baseFguiPanel)
function WarframeExchangePanel:ctor(...)
	self.super.ctor(self, ...)
	print("WarframeExchangePanel:ctor", self.viewName)
end
function WarframeExchangePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WarframeExchangePanel:onInit()
	print("=======WarframeExchangePanel:onInit")
	self.fields.Com_title:initData(i18n("Soldiers_armor_text_88"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function WarframeExchangePanel:onShow()
	print("=======WarframeExchangePanel:onShow")
	self:updateList()
end
function WarframeExchangePanel:updateList()
	self.listData = armorSystemRead:getArmoExchange()
	self.fields.List:setNumItems(#self.listData)
end
function WarframeExchangePanel:onItemRederer(index, target)
	target:initData(self.listData[index + 1])
end
return WarframeExchangePanel
