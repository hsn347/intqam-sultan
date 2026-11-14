local gametop = gModuleMgr.getObject("gametop")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonItemExtraShowBoxPanel = class("CommonItemExtraShowBoxPanel", baseFguiPanel)
function CommonItemExtraShowBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommonItemExtraShowBoxPanel:ctor", self.viewName)
end
function CommonItemExtraShowBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function CommonItemExtraShowBoxPanel:onInit()
	print("=======CommonItemExtraShowBoxPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Promise_Summit_text_41"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Title:setString(i18n("common_text_4711"))
	local itemID = self.proxy.param.itemID
	self.itemList = backpackltCtrl:getExtraItems(itemID)
	self.fields.List:setNumItems(#self.itemList)
end
function CommonItemExtraShowBoxPanel:onShow()
	print("=======CommonItemExtraShowBoxPanel:onShow")
end
function CommonItemExtraShowBoxPanel:onItemRederer(index, target)
	target:initData(self.itemList[index + 1])
	target:showbg(index % 2 == 1)
end
return CommonItemExtraShowBoxPanel
