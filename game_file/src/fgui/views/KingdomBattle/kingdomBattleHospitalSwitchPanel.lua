local conquestWarReinforcementsCtrl = SoraDGetCtrl("conquestWarReinforcementsCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleHospitalSwitchPanel = class("kingdomBattleHospitalSwitchPanel", baseFguiPanel)
function kingdomBattleHospitalSwitchPanel:ctor(...)
	self.super.ctor(self, ...)
	print("kingdomBattleHospitalSwitchPanel:ctor", self.viewName)
end
function kingdomBattleHospitalSwitchPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function kingdomBattleHospitalSwitchPanel:onInit()
	print("=======kingdomBattleHospitalSwitchPanel:onInit")
	self.fields.Text_describe:fixPos()
	self.fields.Button_switch:fixPos()
	self.fields.Panel_bg:setString(i18n("common_text_4759"))
	self.fields.Button_Save:setString(i18n("common_text_195"))
	self.fields.Text_describe:setString(i18n("common_text_4760"))
	self.fields.Button_switch:setSelected(conquestWarReinforcementsCtrl:getHospitalSwitch())
	print("conquestWarReinforcementsCtrl:getHospitalSwitch()", conquestWarReinforcementsCtrl:getHospitalSwitch())
	self.fields.Button_Save:addClickListener(handler(self, self.onClickSave))
end
function kingdomBattleHospitalSwitchPanel:onShow()
	print("=======kingdomBattleHospitalSwitchPanel:onShow")
end
function kingdomBattleHospitalSwitchPanel:onClickSave()
	local isSelected = self.fields.Button_switch:isSelected()
	conquestWarReinforcementsCtrl:reqConquestWarHospitalSwitch(isSelected)
	self:close()
end
return kingdomBattleHospitalSwitchPanel
