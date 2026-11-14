local gametop = gModuleMgr.getObject("gametop")
local settingCtrl = gametop.playertop_:getModule("settingCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gameLanguagePanel = class("gameLanguagePanel", baseFguiPanel)
function gameLanguagePanel:ctor(...)
	self.super.ctor(self, ...)
	print("gameLanguagePanel:ctor", self.viewName)
end
function gameLanguagePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function gameLanguagePanel:onInit()
	print("=======gameLanguagePanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_715"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function gameLanguagePanel:onShow()
	print("=======gameLanguagePanel:onShow")
	self.fields.List:setNumItems(3)
end
function gameLanguagePanel:onItemRederer(index, target)
	target:initData(index)
end
return gameLanguagePanel
