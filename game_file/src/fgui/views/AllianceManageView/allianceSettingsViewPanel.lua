local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceSettingsViewPanel = class("allianceSettingsViewPanel", baseFguiPanel)
function allianceSettingsViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceSettingsViewPanel:ctor", self.viewName)
end
function allianceSettingsViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceSettingsViewPanel:onInit()
	print("=======allianceSettingsViewPanel:onInit")
	self.tableMenu, _ENV = print, print
	self.curTag = 0
	self.fields.Com_title:initData(i18n("common_text_259"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function allianceSettingsViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableMenu[index + 1], self.curTag)
end
function allianceSettingsViewPanel:onShow()
	print("=======allianceSettingsViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.curTag = self.param and self.param.tag or 0
	self:initData()
end
function allianceSettingsViewPanel:settingMenuSetBack(target, data)
	if self.curTag == data.tag then
		self.curTag = 0
	else
		self.curTag = data.tag
	end
	self.fields.List:setNumItems(#self.tableMenu)
end
function allianceSettingsViewPanel:initData()
	self.tableMenu = permissionCtrl:getSettingsMenu()
	self.fields.List:setNumItems(#self.tableMenu)
end
return allianceSettingsViewPanel
