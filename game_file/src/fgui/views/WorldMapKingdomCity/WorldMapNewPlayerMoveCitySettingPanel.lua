local KWKingdomCtrl = SoraDGetCtrl("KWKingdomCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldMapNewPlayerMoveCitySettingPanel = class("WorldMapNewPlayerMoveCitySettingPanel", baseFguiPanel)
function WorldMapNewPlayerMoveCitySettingPanel:ctor(...)
	self.isLRU = true
	WorldMapNewPlayerMoveCitySettingPanel.super.ctor(self, ...)
	print("WorldMapNewPlayerMoveCitySettingPanel:ctor", self.viewName)
end
function WorldMapNewPlayerMoveCitySettingPanel:onInit()
	print("=======WorldMapNewPlayerMoveCitySettingPanel:onInit")
	self.fields.Panel_bg:setString(i18n("mail_text_69"))
	self.fields.Text_switch:setString(i18n("common_text_4956"))
	self.fields.Button_switch:addClickListener(handler(self, self.onClick_Button_switch))
	self.fields.Button_ok:setTitle(i18n("common_text_195"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClick_Button_ok))
	if not SoraDFIsRA() then
		self.fields.Text_switch:fixPos()
		self.fields.Button_switch:fixPos()
	end
end
function WorldMapNewPlayerMoveCitySettingPanel:endShow()
	print("=======WorldMapNewPlayerMoveCitySettingPanel:endShow")
	self.openMoveCity = KWKingdomCtrl:getNewPlayerMoveCitySwitch()
	self.fields.Button_switch:setSelected(self.openMoveCity)
end
function WorldMapNewPlayerMoveCitySettingPanel:onClick_Button_switch(context)
	SoraDPlaySound()
end
function WorldMapNewPlayerMoveCitySettingPanel:onClick_Button_ok(context)
	SoraDPlaySound()
	self:updateConfigMoveCity()
	self:closePanel()
end
function WorldMapNewPlayerMoveCitySettingPanel:updateConfigMoveCity(...)
	local isSelected = self.fields.Button_switch:isSelected()
	if self.openMoveCity == isSelected then
	end
	self.openMoveCity = isSelected
	KWKingdomCtrl:reqSetNewPlayerMoveCity(self.openMoveCity)
end
return WorldMapNewPlayerMoveCitySettingPanel
