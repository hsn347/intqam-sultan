local lifeWaterCtrl = SoraDGetCtrl("lifeWaterCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LifeSpringsSwitchSettingPanel = class("LifeSpringsSwitchSettingPanel", baseFguiPanel)
function LifeSpringsSwitchSettingPanel:ctor(...)
	LifeSpringsSwitchSettingPanel.super.ctor(self, ...)
	print("LifeSpringsSwitchSettingPanel:ctor", self.viewName)
end
function LifeSpringsSwitchSettingPanel:onInit()
	print("=======LifeSpringsSwitchSettingPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_4759"))
	self.fields.Text_switch:setString(i18n("common_text_4828"))
	self.fields.Button_switch:addClickListener(handler(self, self.btnSwitchClick))
	self.fields.Button_ok:setString(i18n("common_text_195"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnOKClick))
	self.fields.Text_switch:fixPos()
	self.fields.Button_switch:fixPos()
end
function LifeSpringsSwitchSettingPanel:onShow()
	print("=======LifeSpringsSwitchSettingPanel:onShow")
	self.fields.Button_switch:setSelected(lifeWaterCtrl:getHospitalSwitch())
end
function LifeSpringsSwitchSettingPanel:btnSwitchClick()
	SoraDPlaySound()
end
function LifeSpringsSwitchSettingPanel:btnOKClick()
	SoraDPlaySound()
	lifeWaterCtrl:reqKWHospitalSwitch(self.fields.Button_switch:isSelected())
	self:close()
end
return LifeSpringsSwitchSettingPanel
