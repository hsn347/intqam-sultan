local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local manorCityRead = include("manorCityRead")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BanquetTypeViewPanel = class("BanquetTypeViewPanel", baseFguiPanel)
function BanquetTypeViewPanel:ctor(...)
	self.isLRU = true
	BanquetTypeViewPanel.super.ctor(self, ...)
	print("BanquetTypeViewPanel:ctor", self.viewName)
end
function BanquetTypeViewPanel:onInit()
	print("=======BanquetTypeViewPanel:onInit")
	self.fields.listType:setItemRenderer(handler(self, self.itemRenderer_listType))
	self.fields.listType:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listType))
	self.fields.Panel_bg1:setString(i18n("Socialize_text_35"))
end
function BanquetTypeViewPanel:endShow()
	print("=======BanquetTypeViewPanel:endShow")
	self:initData()
end
function BanquetTypeViewPanel:itemRenderer_listType(index, obj)
	local data = self.data[index + 1]
	obj:initData(data, self.param)
end
function BanquetTypeViewPanel:onClickItem_listType(context)
	self.selectedType = context.data.data
end
function BanquetTypeViewPanel:initData()
	self.data = manorCityRead.banquet_reward
	self.fields.listType:setNumItems(#self.data)
end
return BanquetTypeViewPanel
