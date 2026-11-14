local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NewStartInheritSurePanel = class("NewStartInheritSurePanel", baseFguiPanel)
function NewStartInheritSurePanel:ctor(...)
	self.super.ctor(self, ...)
	print("NewStartInheritSurePanel:ctor", self.viewName)
end
function NewStartInheritSurePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NewStartInheritSurePanel:onInit()
	print("=======NewStartInheritSurePanel:onInit")
	self.fields.Text_title:setString(i18n("newstart_text_28"))
	self.fields.Text_des:setString(i18n("newstart_text_29"))
	local data = self.proxy.param
	self.fields.Text_name:setString(data.inheritName)
	_ENV = i18n("newstart_text_29")
	i18n("newstart_text_29").kid = "#" .. data.kid
	self.fields.Text_kid:setString(i18n("common_text_342", i18n("newstart_text_29")))
	self.fields.Button_sure:setString(i18n("common_text_204"))
	self.fields.Button_sure:addClickListener(handler(self, self.onClickBtnSure))
	self.fields.Button_cancel:setString(i18n("common_text_185"))
	self.fields.Button_cancel:addClickListener(handler(self, self.onClickClose))
end
function NewStartInheritSurePanel:onShow()
	print("=======NewStartInheritSurePanel:onShow")
end
function NewStartInheritSurePanel:onClickBtnSure(...)
	SoraDPlaySound()
	newStartMainCtrl:reqCorreltion(self.proxy.param.code)
	SoraDShowLoading()
	self:closePanel()
end
return NewStartInheritSurePanel
