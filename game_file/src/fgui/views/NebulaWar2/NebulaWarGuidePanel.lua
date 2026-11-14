local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarGuidePanel = class("NebulaWarGuidePanel", baseFguiPanel)
function NebulaWarGuidePanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarGuidePanel:ctor", self.viewName)
end
function NebulaWarGuidePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaWarGuidePanel:onInit()
	print("=======NebulaWarGuidePanel:onInit")
	local key = self.param and self.param.key
	if key == 2 then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(1.2)
	;(nil)[2] = ffa.callFunc(function()
		self:closePanel()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self:closePanel()
	end)
	self:runAction(ffa.seq(nil))
end
function NebulaWarGuidePanel:onShow()
	print("=======NebulaWarGuidePanel:onShow")
end
return NebulaWarGuidePanel
