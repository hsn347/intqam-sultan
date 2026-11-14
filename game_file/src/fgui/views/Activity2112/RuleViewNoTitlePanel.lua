local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuleViewNoTitlePanel = class("RuleViewNoTitlePanel", baseFguiPanel)
function RuleViewNoTitlePanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuleViewNoTitlePanel:ctor", self.viewName)
end
function RuleViewNoTitlePanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function RuleViewNoTitlePanel:onInit()
	print("=======RuleViewNoTitlePanel:onInit")
end
function RuleViewNoTitlePanel:onShow()
	print("=======RuleViewNoTitlePanel:onShow")
	self.fields.Panel_bg:setString(self.proxy.param.title or i18n("common_text_3657"))
	self.fields.Com_content:setText(self.proxy.param.content)
	self.fields.Com_content:setTitleColor(self.proxy.param.contentColor or cc.c3b(255, 255, 255))
	if self.proxy.param.contentAlignCenter then
	end
end
function RuleViewNoTitlePanel:onHide()
	print("=======RuleViewNoTitlePanel:onHide")
end
function RuleViewNoTitlePanel:onDispose()
	print("=======RuleViewNoTitlePanel:onDispose")
end
return RuleViewNoTitlePanel
