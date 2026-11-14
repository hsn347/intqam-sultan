local constantRead = include("constantRead")
local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NewStartPopTipBoxPanel = class("NewStartPopTipBoxPanel", baseFguiPanel)
function NewStartPopTipBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NewStartPopTipBoxPanel:ctor", self.viewName)
end
function NewStartPopTipBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NewStartPopTipBoxPanel:onInit()
	print("=======NewStartPopTipBoxPanel:onInit")
	self.fields.Panel_bg:setString(i18n("activity_name_9001404"))
	_ENV = i18n("activity_name_9001404")
	i18n("activity_name_9001404").kid = "#" .. self.proxy.param.kid
	self.fields.Text_des1:setString(i18n("newstart_text_8", i18n("activity_name_9001404")))
	self.fields.Text_title2:setString(i18n("newstart_text_34"))
	local goldStr = string.formatnumberthousands(self.proxy.param.gold)
	_ENV = i18n("newstart_text_34")
	i18n("newstart_text_34").pro = goldStr
	self.fields.Text_des2:setString(i18n("newstart_opt_rule_0001", i18n("newstart_text_34")))
end
function NewStartPopTipBoxPanel:onShow()
	print("=======NewStartPopTipBoxPanel:onShow")
end
return NewStartPopTipBoxPanel
