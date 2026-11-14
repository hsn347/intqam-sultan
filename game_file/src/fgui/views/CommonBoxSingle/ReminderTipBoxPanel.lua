local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ReminderTipBoxPanel = class("ReminderTipBoxPanel", baseFguiPanel)
function ReminderTipBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("ReminderTipBoxPanel:ctor", self.viewName)
end
function ReminderTipBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ReminderTipBoxPanel:onInit()
	print("=======ReminderTipBoxPanel:onInit")
	self.fields.Button_click:addClickListener(handler(self, self.onBtnClick))
	self.fields.Check_tick:addClickListener(handler(self, self.onClickCheck))
end
function ReminderTipBoxPanel:initData()
	print("=======GetWayPopBoxPanel:onInit")
	self.handle = self.data.btnCallBack
	self.fields.Text_tip:setString(self.data.tipTitle)
	self.fields.Text_subTip:setString(self.data.subTipTitle)
	self.fields.Text_remind:setString(self.data.reminderTitle)
	self.fields.Button_click:setTitleText(i18n("common_text_477"))
end
function ReminderTipBoxPanel:onBtnClick()
	SoraDPlaySound()
	self.handle(self.fields.Check_tick:isSelected())
	if tolua.isnull(self) then
		return
	end
	self:close()
end
function ReminderTipBoxPanel:onClickCheck()
	self.fields.Check_tick:setSelected(self.fields.Check_tick:isSelected())
end
function ReminderTipBoxPanel:onShow()
	print("=======ReminderTipBoxPanel:onShow")
	dump(self.proxy.param, "ReminderTipBoxPanel:onShow")
	self.data = self.proxy.param
	self:initData()
end
function ReminderTipBoxPanel:onHide()
	print("=======ReminderTipBoxPanel:onHide")
end
function ReminderTipBoxPanel:onDispose()
	print("=======ReminderTipBoxPanel:onDispose")
end
return ReminderTipBoxPanel
