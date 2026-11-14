local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rechargePopViewPanel = class("rechargePopViewPanel", baseFguiPanel)
function rechargePopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("rechargePopViewPanel:ctor", self.viewName)
end
function rechargePopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function rechargePopViewPanel:onInit()
	print("=======rechargePopViewPanel:onInit")
	self.isAddToPopManager = true
	self.fields.Top_Button_close:addClickListener(handler(self, self.btnCloseClick))
end
function rechargePopViewPanel:onShow()
	print("=======rechargePopViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initView()
end
function rechargePopViewPanel:initView()
	if self.param.group then
		dump(self.param, "self.param")
		self.fields.Com_view:initGroupData(self.param, self.param.fromCenter, self.param.isPageTurn, self.param.targetID, self.param.isHideRechargeCenter)
	else
		self.fields.Com_view:initDataEX(self.param, self)
	end
end
function rechargePopViewPanel:btnCloseClick()
	SoraDPlaySound("uicontrol", 1)
	self:close()
	_ENV = self
	self.msg = "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWFRAMECLOSE"
	self.isForceClose = true
	SoraDSendMessage(self)
end
function rechargePopViewPanel:forceClose()
	SoraDCloseLoading()
	self:close()
end
function rechargePopViewPanel:doubleClose()
	self:close()
	_ENV = self
	self.msg = "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWFRAMECLOSE"
	SoraDSendMessage(self)
end
return rechargePopViewPanel
