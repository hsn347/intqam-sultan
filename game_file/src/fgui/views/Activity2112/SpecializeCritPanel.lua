local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SpecializeCritPanel = class("SpecializeCritPanel", baseFguiPanel)
function SpecializeCritPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SpecializeCritPanel:ctor", self.viewName)
end
function SpecializeCritPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function SpecializeCritPanel:onInit()
	print("=======SpecializeCritPanel:onInit", IsArClient)
	self.controllers.c_lang:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	self.fields.Text_ins:setString(i18n("awakeSkillCrit_text_01"))
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickGo))
end
function SpecializeCritPanel:onShow()
	print("=======SpecializeCritPanel:onShow")
end
function SpecializeCritPanel:onClickGo(EventContext)
	SoraDPlaySound()
	SoraDRemoveAllPanelFromManager()
	uiManager:show("newHeroListView")
end
return SpecializeCritPanel
