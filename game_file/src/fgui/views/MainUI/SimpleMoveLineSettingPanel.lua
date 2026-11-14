local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SimpleMoveLineSettingPanel = class("SimpleMoveLineSettingPanel", baseFguiPanel)
local dailyRemindManager = include("dailyRemindManager")
function SimpleMoveLineSettingPanel:ctor(...)
	SimpleMoveLineSettingPanel.super.ctor(self, ...)
	self.debug = true
	print("SimpleMoveLineSettingPanel:ctor", self.viewName)
end
function SimpleMoveLineSettingPanel:onInit()
	print("=======SimpleMoveLineSettingPanel:onInit")
	self.fields.Btn_ok:setTitle(i18n("common_text_195"))
	self.fields.Btn_ok:addClickEventListener(handler(self, self.onSaveClick))
	self.fields.Panel_bg:setTitle(i18n("common_text_4853"))
	self.fields.text_title:setString(i18n("common_text_4843"))
	self.fields.text_1:setString(i18n("common_text_4850"))
	self.fields.text_2:setString(i18n("common_text_4851"))
	self.fields.text_3:setString(i18n("common_text_4852"))
	self.fields.text_tips:setString(i18n("common_text_4868"))
	self.remindKey = "SimpleMoveLineSettingPanel:dailyRemind:saveTime~integer"
end
function SimpleMoveLineSettingPanel:onShow()
	print("=======SimpleMoveLineSettingPanel:onShow")
	self.fields.Button_switch1:setSelected(worldMapDefine.moveLineAutoHideOption.isCastleHideSkin)
	self.fields.Button_switch2:setSelected(worldMapDefine.moveLineAutoHideOption.isMoveLineHideArmy)
	self.fields.Button_switch3:setSelected(worldMapDefine.moveLineAutoHideOption.isMoveLineHideOther)
	self.recordTime = SoraDConfigGet(self.remindKey) or 0
	self.fields.Check_tick:setSelected(serviceFunctions.isSameDay(self.recordTime))
end
function SimpleMoveLineSettingPanel:onHide()
	if self.fields.Check_tick:isSelected() then
		SoraDConfigSet(self.remindKey, serviceFunctions.systemTime())
	else
		SoraDConfigSet(self.remindKey, 0)
	end
end
function SimpleMoveLineSettingPanel:onSaveClick()
	SoraDPlaySound()
	worldMapDefine.moveLineAutoHideOption.isCastleHideSkin = self.fields.Button_switch1:isSelected()
	worldMapDefine.moveLineAutoHideOption.isMoveLineHideArmy = self.fields.Button_switch2:isSelected()
	worldMapDefine.moveLineAutoHideOption.isMoveLineHideOther = self.fields.Button_switch3:isSelected()
	_ENV = self.fields.Button_switch3:isSelected()
	self.fields.Button_switch3:isSelected().msg = "MESSAGE_LOCAL_OPTION_CATLE_WAR_LV_SHOW"
	SoraDSendMessage((self.fields.Button_switch3:isSelected()))
	_ENV = self.fields.Button_switch3:isSelected()
	self.fields.Button_switch3:isSelected().data, _ENV, self.fields.Button_switch3:isSelected().msg = self.fields.Button_switch3, self.fields.Button_switch3, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ALL_SHOW"
	SoraDSendMessage(self.fields.Button_switch3:isSelected(), nil)
	self:close()
end
return SimpleMoveLineSettingPanel
