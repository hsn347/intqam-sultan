local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaActivityPanel = class("NebulaActivityPanel", baseFguiPanel)
function NebulaActivityPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaActivityPanel:ctor", self.viewName)
end
function NebulaActivityPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaActivityPanel:onInit()
	print("=======NebulaActivityPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001430"), handler(self, self.onClickClose), handler(self, self.onHelpBack))
	self.fields.Label_time:initActivityTimeStyle(gActivityTimeActivityID.NEBULA_PRIVILEGE, "common_text_606")
	self.fields.Text_Info:setString(i18n("nebula_officer_text_010"))
end
function NebulaActivityPanel:onShow()
	print("=======NebulaActivityPanel:onShow")
end
function NebulaActivityPanel:onHelpBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("nebula_war_text_0547")
	uiManager:show("RuleView", nil)
end
return NebulaActivityPanel
