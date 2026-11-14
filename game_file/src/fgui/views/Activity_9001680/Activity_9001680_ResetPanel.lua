local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001680_ResetPanel = class("Activity_9001680_ResetPanel", baseFguiPanel)
local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
function Activity_9001680_ResetPanel:ctor(...)
	self.isLRU = true
	Activity_9001680_ResetPanel.super.ctor(self, ...)
	print("Activity_9001680_ResetPanel:ctor", self.viewName)
end
function Activity_9001680_ResetPanel:onInit()
	self.view:fixChildrenPos()
	print("=======Activity_9001680_ResetPanel:onInit")
	self.fields.Button_doIt:setTitle(i18n("common_text_204"))
	self.fields.Button_cancel:setTitle(i18n("common_text_185"))
	self.fields.Button_doIt:addClickEventListener(handler(self, self.onSureReset))
	self.fields.Button_cancel:addClickEventListener(handler(self, self.onClickClose))
	self.fields.Panel_bg:setTitle(i18n("minecraft_text_17"))
end
function Activity_9001680_ResetPanel:endShow()
	print("=======Activity_9001680_ResetPanel:endShow")
	self:updateView()
end
function Activity_9001680_ResetPanel:updateView()
	_ENV = nil
	;(nil).num = activity_9001680_Ctrl:getMonsterLevel()
	self.fields.Text_1:setString(i18n("minecraft_text_18", nil))
	_ENV = i18n("minecraft_text_18", nil)
	i18n("minecraft_text_18", nil).num = activity_9001680_Ctrl:getBossLevel()
	self.fields.Text_2:setString(i18n("minecraft_text_19", i18n("minecraft_text_18", nil)))
	self.fields.Text_des:setString(i18n("minecraft_text_20"))
end
function Activity_9001680_ResetPanel:onSureReset()
	SoraDPlaySound()
	activity_9001680_Ctrl:reqGoldMinerReset()
	self:onClickClose()
end
return Activity_9001680_ResetPanel
