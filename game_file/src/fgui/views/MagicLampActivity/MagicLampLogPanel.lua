local magicFlipCtrl = SoraDGetCtrl("magicFlipCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampLogPanel = class("MagicLampLogPanel", baseFguiPanel)
function MagicLampLogPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampLogPanel:ctor", self.viewName)
end
function MagicLampLogPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MagicLampLogPanel:onInit()
	print("=======MagicLampLogPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("magic_flip_3"))
	self.fields.Text_Tips:setString(i18n("parliament_text_11"))
	self.fields.Text_NoLog:setString(i18n("common_text_1464"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:setVirtual()
	self.logList = magicFlipCtrl:getFlipLog()
	self.fields.Text_NoLog:setVisible(#self.logList == 0)
	self.fields.List:setNumItems(#self.logList)
end
function MagicLampLogPanel:onShow()
	print("=======MagicLampLogPanel:onShow")
	SoraDCloseLoading()
end
function MagicLampLogPanel:onItemRederer(index, target)
	target:initData(self.logList[#self.logList - index])
end
return MagicLampLogPanel
