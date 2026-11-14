local basePanel = require("fgui.base.baseFguiPanel")
local troopsExchangeMsgTipsPanel = class("troopsExchangeMsgTipsPanel", basePanel)
function troopsExchangeMsgTipsPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function troopsExchangeMsgTipsPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "TroopsChange"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function troopsExchangeMsgTipsPanel:onInit()
	self.fields.Usm_Unlock:setCompleteCallback(handler(self, self.closePanel))
	self.fields.Usm_Unlock:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self:setPositionY(-display.height - 250)
end
function troopsExchangeMsgTipsPanel:onShow()
	SoraDPlaySound("uicontrol", 4)
	self.fields.title:setString(self.proxy.param.title)
end
return troopsExchangeMsgTipsPanel
