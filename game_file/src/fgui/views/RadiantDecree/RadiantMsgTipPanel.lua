local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RadiantMsgTipPanel = class("RadiantMsgTipPanel", baseFguiPanel)
function RadiantMsgTipPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RadiantMsgTipPanel:ctor", self.viewName)
end
function RadiantMsgTipPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RadiantMsgTipPanel:onInit()
	self.fields.Label_tip:setString(i18n(self.proxy.param.des))
	print("=======RadiantMsgTipPanel:onInit")
end
function RadiantMsgTipPanel:onShow()
	print("=======RadiantMsgTipPanel:onShow")
	self:runAction(ffa.seq(ffa.delay(2), ffa.callFunc(function(...)
		self:close()
	end)))
end
return RadiantMsgTipPanel
