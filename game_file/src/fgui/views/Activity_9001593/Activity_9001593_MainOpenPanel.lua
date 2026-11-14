local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001593_MainOpenPanel = class("Activity_9001593_MainOpenPanel", baseFguiPanel)
function Activity_9001593_MainOpenPanel:ctor(...)
	Activity_9001593_MainOpenPanel.super.ctor(self, ...)
	print("Activity_9001593_MainOpenPanel:ctor", self.viewName)
end
function Activity_9001593_MainOpenPanel:onInit()
	print("=======Activity_9001593_MainOpenPanel:onInit")
	self.activityID = gActivityTimeActivityID.CALENDAR_9001593_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001593"), handler(self, self.onClickClose))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Btn_open:setString(i18n("ramadan_pilgrimage_text02"))
	self.fields.Btn_open:addClickListener(handler(self, self.btnOpenClick))
end
function Activity_9001593_MainOpenPanel:onShow()
	print("=======Activity_9001593_MainOpenPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
end
function Activity_9001593_MainOpenPanel:initData()
	for hole = 1, 5 do
		self.fields["activity" .. hole]:initActivity(hole, 2)
	end
end
function Activity_9001593_MainOpenPanel:btnOpenClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001593_Main")
	self:close()
end
return Activity_9001593_MainOpenPanel
