local militaryRankCtrl = SoraDGetCtrl("militaryRankCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local militaryMarshalSettingViewPanel = class("militaryMarshalSettingViewPanel", baseFguiPanel)
function militaryMarshalSettingViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("militaryMarshalSettingViewPanel:ctor", self.viewName)
end
function militaryMarshalSettingViewPanel:onInit()
	print("=======militaryMarshalSettingViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_4129"))
	self.fields.Button_switch:addClickListener(handler(self, self.btnSwitchClickCallBack))
	self.fields.Text_info:fixPos()
	self.fields.Button_switch:fixPos()
end
function militaryMarshalSettingViewPanel:endShow()
	self.isMarshal = self.param and self.param.isMarshal or false
	self.fields.Text_info:setString(self.isMarshal and i18n("common_text_4130") or i18n("common_text_4964"))
	self:initView()
end
function militaryMarshalSettingViewPanel:initView()
	if self.isMarshal then
		self.curSwitch = militaryRankCtrl:getData().marshalTip
	else
		self.curSwitch = militaryRankCtrl:getShowMarshalMarquee()
	end
	self.fields.Button_switch:setSelected(self.curSwitch)
end
function militaryMarshalSettingViewPanel:btnSwitchClickCallBack()
	SoraDPlaySound()
	self.curSwitch = not self.curSwitch
	if self.isMarshal then
		militaryRankCtrl:sendMarshalTip(self.curSwitch)
	else
		militaryRankCtrl:setShowMarshalMarquee(self.curSwitch)
	end
end
return militaryMarshalSettingViewPanel
