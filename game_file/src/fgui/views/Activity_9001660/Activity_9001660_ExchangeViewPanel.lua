local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001660_Ctrl = SoraDGetCtrl("activity_9001660_Ctrl")
local activity_9001660_Read = include("activity_9001660_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001660_ExchangeViewPanel = class("Activity_9001660_ExchangeViewPanel", baseFguiPanel)
function Activity_9001660_ExchangeViewPanel:ctor(...)
	Activity_9001660_ExchangeViewPanel.super.ctor(self, ...)
	print("Activity_9001660_ExchangeViewPanel:ctor", self.viewName)
end
function Activity_9001660_ExchangeViewPanel:onInit()
	print("=======Activity_9001660_ExchangeViewPanel:onInit")
	self.priceConfig, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("mutated_tentacles_text2"))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
end
function Activity_9001660_ExchangeViewPanel:onShow()
	print("=======Activity_9001660_ExchangeViewPanel:onShow")
	self:initData()
end
function Activity_9001660_ExchangeViewPanel:onItemRenderer(index, obj)
	local id = activity_9001660_Read.gMutantTentaclesItem[index + 1]
	obj:initData(id, backpackCtrl:getItemCount(id))
end
function Activity_9001660_ExchangeViewPanel:onListRenderer(index, obj)
	obj:initData(self.priceConfig[index + 1], index + 1)
end
function Activity_9001660_ExchangeViewPanel:initData(target, redata)
	self.priceConfig = clone(activity_9001660_Read.get_feahtershop(activity_9001660_Ctrl:getZeroLv(), activity_9001660_Ctrl:getClassType()))
	self.fields.List:setNumItems(#self.priceConfig)
	self.fields.List_item:setNumItems(#activity_9001660_Read.gMutantTentaclesItem)
end
return Activity_9001660_ExchangeViewPanel
