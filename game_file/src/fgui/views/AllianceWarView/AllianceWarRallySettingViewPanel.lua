local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceWarRallySettingViewPanel = class("AllianceWarRallySettingViewPanel", baseFguiPanel)
function AllianceWarRallySettingViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceWarRallySettingViewPanel:ctor", self.viewName)
end
function AllianceWarRallySettingViewPanel:onInit()
	print("=======AllianceWarRallySettingViewPanel:onInit")
	self.tableTroop, _ENV = print, print
	self.isAllow = true
	self.fields.Panel_bg:setString(i18n("common_text_4510"))
	self.fields.Text_des:setString(i18n("common_text_4511"))
	self.fields.CheckBox_yes:setString(i18n("common_text_4518"))
	self.fields.CheckBox_no:setString(i18n("common_text_4519"))
	self.fields.CheckBox_yes:addClickListener(handler(self, self.checkClickYes))
	self.fields.CheckBox_no:addClickListener(handler(self, self.checkClickNo))
	self.fields.btn_confirm:setString(i18n("common_text_204"))
	self.fields.btn_confirm:addClickListener(handler(self, self.btnConfirmClick))
	self.fields.btn_white:setTitle(i18n("common_text_4891"))
	self.fields.btn_white:addClickListener(handler(self, self.btnWhiteClick))
	_UPVALUE2_ = self.fields.btn_white
	self.fields.btn_white[1] = "CheckBox_yes"
	self.fields.btn_white[2] = "CheckBox_no"
	for i, v in ipairs(self.fields.btn_white) do
		self.fields[v]:fixPos()
		self.fields[v]:fixChildrenPos()
	end
end
function AllianceWarRallySettingViewPanel:onShow()
	print("=======AllianceWarRallySettingViewPanel:onShow")
	if self.proxy.param then
		local troopData = self.proxy.param.troopData
		self:initData(troopData)
	end
end
function AllianceWarRallySettingViewPanel:initData(troopData)
	self.tableTroop = troopData
	print(self.tableTroop.isForbidSpeed)
	if self.tableTroop.isForbidSpeed == nil then
		self.fields.CheckBox_no:setSelected(false)
		self.fields.CheckBox_yes:setSelected(true)
		self.isAllow = true
	else
		self.fields.CheckBox_no:setSelected(self.tableTroop.isForbidSpeed)
		self.fields.CheckBox_yes:setSelected(not self.tableTroop.isForbidSpeed)
		self.isAllow = not self.tableTroop.isForbidSpeed
	end
end
function AllianceWarRallySettingViewPanel:checkClickYes(EventContext)
	SoraDPlaySound()
	self.fields.CheckBox_no:setSelected(false)
	self.isAllow = true
end
function AllianceWarRallySettingViewPanel:checkClickNo(EventContext)
	SoraDPlaySound()
	self.fields.CheckBox_yes:setSelected(false)
	self.isAllow = false
end
function AllianceWarRallySettingViewPanel:btnConfirmClick(EventContext)
	SoraDPlaySound()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	kingdomMapCtrl:reqSetQueueForbidSpeed(self.tableTroop:getId(), not self.isAllow)
	SoraDShowMsgTip(i18n("common_text_4512"))
	self:closePanel()
end
function AllianceWarRallySettingViewPanel:btnWhiteClick(EventContext)
	SoraDPlaySound()
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId()
	if mapClassType ~= gKingdomClassType.normal and mapClassType ~= gKingdomClassType.nebula and mapClassType ~= gKingdomClassType.legendLord then
		SoraDShowMsgTip(i18n("common_text_4884"))
		return
	end
	uiManager:show("WorldMassWhite")
end
return AllianceWarRallySettingViewPanel
