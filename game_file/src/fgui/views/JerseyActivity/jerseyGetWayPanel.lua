local itemDesRead = include("itemDesRead")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local jerseyGetWayPanel = class("jerseyGetWayPanel", baseFguiPanel)
function jerseyGetWayPanel:ctor(...)
	self.super.ctor(self, ...)
	print("jerseyGetWayPanel:ctor", self.viewName)
end
function jerseyGetWayPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function jerseyGetWayPanel:onInit()
	print("=======jerseyGetWayPanel:onInit")
	self.fields.Text_name:fixPos()
	self.fields.Text_num:fixPos()
	self.fields.Com_Item:fixPos()
	self.fields.Panel_bg:setTitle(i18n("common_text_4342"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function jerseyGetWayPanel:onShow()
	print("=======jerseyGetWayPanel:onShow")
	self.sourceIds = itemDesRead.getOutput(self.proxy.param.itemID)
	self.fields.List:setNumItems(table.nums(self.sourceIds))
	self.fields.Com_Item:initData(self.proxy.param.itemID)
	self.fields.Text_name:setString(publicRead.getName(self.proxy.param.itemID))
	_ENV = publicRead.getName(self.proxy.param.itemID)
	publicRead.getName(self.proxy.param.itemID).count = backpackCtrl:getItemCount(self.proxy.param.itemID)
	self.fields.Text_num:setString(i18n("common_text_1377", publicRead.getName(self.proxy.param.itemID)))
end
function jerseyGetWayPanel:onItemRenderer(index, object)
	object:initData(self.sourceIds[index + 1])
end
return jerseyGetWayPanel
