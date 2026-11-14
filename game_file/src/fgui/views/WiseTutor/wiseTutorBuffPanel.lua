local basePanel = require("fgui.base.baseFguiPanel")
local wiseTutorBuffPanel = class("wiseTutorBuffPanel", basePanel)
function wiseTutorBuffPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function wiseTutorBuffPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "WiseTutor"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
	end
	return self._packageList
end
function wiseTutorBuffPanel:onInit()
	self.fields.panel_normal:setTitle(i18n("Battle_Towers_23"))
end
function wiseTutorBuffPanel:onShow()
end
return wiseTutorBuffPanel
