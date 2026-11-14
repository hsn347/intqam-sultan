local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001690_MainOpenPanel = class("Activity_9001690_MainOpenPanel", baseFguiPanel)
function Activity_9001690_MainOpenPanel:ctor(...)
	self.isLRU = true
	Activity_9001690_MainOpenPanel.super.ctor(self, ...)
	print("Activity_9001690_MainOpenPanel:ctor", self.viewName)
end
function Activity_9001690_MainOpenPanel:onInit()
	print("=======Activity_9001690_MainOpenPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.activityID = gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001690"), handler(self, self.onClickClose))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Btn_open:setString(i18n("ramadan_pilgrimage_text02"))
	self.fields.Btn_open:addClickListener(handler(self, self.btnOpenClick))
end
function Activity_9001690_MainOpenPanel:endShow()
	print("=======Activity_9001690_MainOpenPanel:endShow")
	self:initData()
end
function Activity_9001690_MainOpenPanel:initData()
	for hole = 1, 5 do
		self.fields["activity" .. hole]:initActivity(hole, 2)
	end
end
function Activity_9001690_MainOpenPanel:btnOpenClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001690_Main")
	self:close()
end
return Activity_9001690_MainOpenPanel
