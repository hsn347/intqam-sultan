local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ExtremelySkillfulAwardPreviewPanel = class("ExtremelySkillfulAwardPreviewPanel", baseFguiPanel)
function ExtremelySkillfulAwardPreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ExtremelySkillfulAwardPreviewPanel:ctor", self.viewName)
end
function ExtremelySkillfulAwardPreviewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ExtremelySkillfulAwardPreviewPanel:onInit()
	print("=======ExtremelySkillfulAwardPreviewPanel:onInit")
	self.fields.panel_normal:setTitle(i18n("Battle_Towers_17"))
end
function ExtremelySkillfulAwardPreviewPanel:onShow()
	print("=======ExtremelySkillfulAwardPreviewPanel:onShow")
end
return ExtremelySkillfulAwardPreviewPanel
