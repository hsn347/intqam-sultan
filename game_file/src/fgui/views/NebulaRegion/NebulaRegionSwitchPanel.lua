local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaRegionSwitchPanel = class("NebulaRegionSwitchPanel", baseFguiPanel)
function NebulaRegionSwitchPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaRegionSwitchPanel:ctor", self.viewName)
end
function NebulaRegionSwitchPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaRegionSwitchPanel:onInit()
	print("=======NebulaRegionSwitchPanel:onInit")
end
function NebulaRegionSwitchPanel:onShow()
	print("=======NebulaRegionSwitchPanel:onShow")
	self.fields.Usm_ywzc:setCompleteCallback(handler(self, self.completeCallback))
	self.fields.Usm_ywzc:setPrepareCallback(handler(self, self.prepareCallback))
end
function NebulaRegionSwitchPanel:completeCallback(...)
	self:closePanel()
end
function NebulaRegionSwitchPanel:prepareCallback(target)
	target:start()
	_ENV = nil
	;(nil).frame = 36
	target:addFrameEventData(nil)
	target:setFrameEventCallback(handler(self, self.frameEventCallback))
end
function NebulaRegionSwitchPanel:frameEventCallback(event)
	if self.param and self.param.handler then
		self.param.handler()
	end
end
return NebulaRegionSwitchPanel
