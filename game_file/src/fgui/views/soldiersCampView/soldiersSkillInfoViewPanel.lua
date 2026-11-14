local armyDesRead = include("armyDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local soldiersSkillInfoViewPanel = class("soldiersSkillInfoViewPanel", baseFguiPanel)
function soldiersSkillInfoViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("soldiersSkillInfoViewPanel:ctor", self.viewName)
end
function soldiersSkillInfoViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function soldiersSkillInfoViewPanel:onInit()
	print("=======soldiersSkillInfoViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("atlantiswar_skill_text_052"))
end
function soldiersSkillInfoViewPanel:onShow()
	print("=======soldiersSkillInfoViewPanel:onShow")
	self.skillID = self.param.skillID
	self:initData()
end
function soldiersSkillInfoViewPanel:initData()
	self.fields.skill:initData(self.skillID)
	self.fields.Text_name:setString(armyDesRead.getSkillName(self.skillID))
	self.fields.Text_des:setString(armyDesRead.getSkillDes(self.skillID))
end
return soldiersSkillInfoViewPanel
