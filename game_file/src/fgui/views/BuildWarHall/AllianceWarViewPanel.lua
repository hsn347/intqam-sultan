local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceWarViewPanel = class("AllianceWarViewPanel", baseFguiPanel)
function AllianceWarViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("AllianceWarViewPanel:ctor", self.viewName)
end
function AllianceWarViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceWarViewPanel:onInit()
	print("=======AllianceWarViewPanel:onInit")
	self.fields.Com_title:initData("", handler(self, self.onClickClose), handler(self, self.btnSettingClick))
	self.fields.Com_AllianceWarView:setTitleUI(self.fields.Com_title)
	self.fields.Com_AllianceWarView:initComboBox(self)
end
function AllianceWarViewPanel:onShow()
	local isWar = self.param and self.param.isWar or false
	self.fields.Com_AllianceWarView.isWar = isWar
end
function AllianceWarViewPanel:tabChange(...)
	self.fields.Com_AllianceWarView:tabChange(...)
end
function AllianceWarViewPanel:setShowTeamTab(...)
	self.fields.Com_AllianceWarView:setShowTeamTab(...)
end
function AllianceWarViewPanel:btnSettingClick(button, type)
	SoraDPlaySound()
	_ENV = nil
	;(nil).viewType = 2
	uiManager:show("AllianceWarSettingView", nil)
end
return AllianceWarViewPanel
