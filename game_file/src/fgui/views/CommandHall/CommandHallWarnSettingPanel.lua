local commandHallUtil = include("commandHallUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommandHallWarnSettingPanel = class("CommandHallWarnSettingPanel", baseFguiPanel)
function CommandHallWarnSettingPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommandHallWarnSettingPanel:ctor", self.viewName)
end
function CommandHallWarnSettingPanel:onInit()
	print("=======CommandHallWarnSettingPanel:onInit")
	self.fields.Panel_bg:setString(i18n("commandhall_text_83"))
	self.fields.Text_switch1:setString(i18n("commandhall_text_81"))
	self.fields.Button_switch1:addClickListener(handler(self, self.onClickBtnSwitch))
	self.fields.Text_switch2:setString(i18n("commandhall_text_91"))
	self.fields.Button_switch2:addClickListener(handler(self, self.onClickBtnSwitch))
	self.fields.Button_ok:setString(i18n("common_text_195"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClickBtnOk))
	if not SoraDFIsRA() then
		self.fields.Text_switch1:fixPos()
		self.fields.Button_switch1:fixPos()
		self.fields.Text_switch2:fixPos()
		self.fields.Button_switch2:fixPos()
	end
end
function CommandHallWarnSettingPanel:onShow()
	print("=======CommandHallWarnSettingPanel:onShow")
	self.showWarning = commandHallUtil.getConfigShowWarning()
	self.fields.Button_switch1:setSelected(self.showWarning)
	self.showAttack = commandHallUtil.getConfigShowAttack()
	self.fields.Button_switch2:setSelected(self.showAttack)
end
function CommandHallWarnSettingPanel:onClickBtnSwitch(...)
	SoraDPlaySound()
end
function CommandHallWarnSettingPanel:onClickBtnOk(...)
	SoraDPlaySound()
	self:updateConfigShowWarning()
	self:updateConfigShowAttack()
	self:closePanel()
end
function CommandHallWarnSettingPanel:updateConfigShowWarning(...)
	local isSelected = self.fields.Button_switch1:isSelected()
	if self.showWarning == isSelected then
		return
	end
	commandHallUtil.setConfigShowWarning(isSelected)
	local proxy = uiManager:getProxy("CommandHallMain")
	if proxy then
		proxy:updateBtnWaring()
	end
	commandHallUtil.checkShowWarning()
end
function CommandHallWarnSettingPanel:updateConfigShowAttack(...)
	local isSelected = self.fields.Button_switch2:isSelected()
	if self.showAttack == isSelected then
		return
	end
	commandHallUtil.setConfigShowAttack(isSelected)
	commandHallUtil = isSelected
	isSelected.msg = "MESSAGE_COMMANDHALL_UPDATE_SHOW_ATTACK"
	SoraDSendMessage(isSelected)
end
return CommandHallWarnSettingPanel
