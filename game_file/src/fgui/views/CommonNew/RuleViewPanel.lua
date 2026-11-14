local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuleViewPanel = class("RuleViewPanel", baseFguiPanel)
function RuleViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuleViewPanel:ctor", self.viewName)
end
function RuleViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function RuleViewPanel:onInit()
	print("=======RuleViewPanel:onInit")
end
function RuleViewPanel:onShow()
	print("=======RuleViewPanel:onShow")
	self.fields.Panel_bg:setString(self.proxy.param.title or i18n("common_text_3657"))
	self.fields.Com_content:setText(self.proxy.param.content)
	self.fields.Com_content:setTitleColor(self.proxy.param.contentColor or cc.c3b(255, 255, 255))
	if self.proxy.param.contentAlignCenter then
		self.fields.Com_content:setAlignCenter()
	end
end
function RuleViewPanel:onHide()
	print("=======RuleViewPanel:onHide")
end
function RuleViewPanel:onDispose()
	print("=======RuleViewPanel:onDispose")
end
return RuleViewPanel
