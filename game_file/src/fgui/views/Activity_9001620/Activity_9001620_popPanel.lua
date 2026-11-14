local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001620_popPanel = class("Activity_9001620_popPanel", baseFguiPanel)
function Activity_9001620_popPanel:ctor(...)
	Activity_9001620_popPanel.super.ctor(self, ...)
	print("Activity_9001620_popPanel:ctor", self.viewName)
end
function Activity_9001620_popPanel:onInit()
	print("=======Activity_9001620_popPanel:onInit")
	self.fields.Text_title:setString(i18n("common_text_3657"))
end
function Activity_9001620_popPanel:onShow()
	print("=======Activity_9001620_popPanel:onShow")
	self.data = self.param.data
	self.fields.Panel_bg:setString(i18n(self.data.activity_name))
	self.fields.banner:setIcon(self.data.activity_banner)
	if #self.data.opnetime == 1 then
		self.fields.Text_timeLast:setString(string.gsub(SoraDConvertTimeToYear(self.data.opnetime[1]), "-", "/"))
	else
		self.fields.Text_timeLast:setString(string.gsub(SoraDConvertTimeToYear(self.data.opnetime[1]), "-", "/") .. "、" .. string.gsub(SoraDConvertTimeToYear(self.data.opnetime[2]), "-", "/"))
	end
	self.fields.Text_des:setString(i18n(self.data.activity_desc))
end
return Activity_9001620_popPanel
