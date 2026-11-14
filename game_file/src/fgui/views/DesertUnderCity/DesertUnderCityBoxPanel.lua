local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DesertUnderCityBoxPanel = class("DesertUnderCityBoxPanel", baseFguiPanel)
function DesertUnderCityBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DesertUnderCityBoxPanel:ctor", self.viewName)
end
function DesertUnderCityBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DesertUnderCityBoxPanel:onInit()
	print("=======DesertUnderCityBoxPanel:onInit")
	self.param = self.proxy.param
	self.fields.Button_confirm:addClickListener(handler(self, self.onClickConfirm))
	self.fields.Button_cancel:addClickListener(handler(self, self.onClickCancel))
end
function DesertUnderCityBoxPanel:onClickConfirm()
	local param = self.param
	SoraDPlaySound()
	self:close()
	if param.confirmFunc then
		param.confirmFunc()
	end
end
function DesertUnderCityBoxPanel:onClickCancel()
	if self.param.cancelFunc then
		self.param.cancelFunc()
	end
	self:onClickClose()
end
function DesertUnderCityBoxPanel:onShow()
	print("=======DesertUnderCityBoxPanel:onShow")
	self.fields.Text_content:setString(self.param.content)
	local cancelString = self.param.cancelString or i18n("common_text_185")
	self.fields.Button_cancel:setString(cancelString)
	local confirmString = self.param.confirmString or i18n("common_text_204")
	self.fields.Button_confirm:setString(confirmString)
end
return DesertUnderCityBoxPanel
