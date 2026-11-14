local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanWorldExplorerTipPanel = class("RamadanWorldExplorerTipPanel", baseFguiPanel)
function RamadanWorldExplorerTipPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RamadanWorldExplorerTipPanel:ctor", self.viewName)
end
function RamadanWorldExplorerTipPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RamadanWorldExplorerTipPanel:onInit()
	print("=======RamadanWorldExplorerTipPanel:onInit")
	_ENV, _ENV = "=======RamadanWorldExplorerTipPanel:onInit", print
	;("=======RamadanWorldExplorerTipPanel:onInit").des = "exitic_pavillion_text_0103"
	_ENV, print[1], ("=======RamadanWorldExplorerTipPanel:onInit").title = "=======RamadanWorldExplorerTipPanel:onInit", "=======RamadanWorldExplorerTipPanel:onInit", "exitic_pavillion_text_0125"
	;("=======RamadanWorldExplorerTipPanel:onInit").des = "exitic_pavillion_text_0111"
	_ENV, print[2], ("=======RamadanWorldExplorerTipPanel:onInit").title = "=======RamadanWorldExplorerTipPanel:onInit", "=======RamadanWorldExplorerTipPanel:onInit", "exitic_pavillion_text_0124"
	;("=======RamadanWorldExplorerTipPanel:onInit").des = "exitic_pavillion_text_0115"
	_ENV, print[3], ("=======RamadanWorldExplorerTipPanel:onInit").title = "=======RamadanWorldExplorerTipPanel:onInit", "=======RamadanWorldExplorerTipPanel:onInit", "exitic_pavillion_text_0123"
	;("=======RamadanWorldExplorerTipPanel:onInit").des = "ramadan_world_explorer_text_0010"
	self.config, print[4], ("=======RamadanWorldExplorerTipPanel:onInit").title = print, "=======RamadanWorldExplorerTipPanel:onInit", "ramadan_world_explorer_text_0009"
	self.fields.Text_title:setString(i18n(self.config[self.proxy.param.taskID].title))
	self.fields.Text_Tips:setString(i18n(self.config[self.proxy.param.taskID].des))
end
function RamadanWorldExplorerTipPanel:onShow()
	print("=======RamadanWorldExplorerTipPanel:onShow")
end
function RamadanWorldExplorerTipPanel:onHide()
	print("=======RamadanWorldExplorerTipPanel:onHide")
end
function RamadanWorldExplorerTipPanel:onDispose()
	print("=======RamadanWorldExplorerTipPanel:onDispose")
end
return RamadanWorldExplorerTipPanel
