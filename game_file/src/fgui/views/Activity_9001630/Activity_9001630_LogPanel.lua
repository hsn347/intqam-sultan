local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001630_LogPanel = class("Activity_9001630_LogPanel", baseFguiPanel)
local activity_9001630_Ctrl = SoraDGetCtrl("activity_9001630_Ctrl")
function Activity_9001630_LogPanel:ctor(...)
	Activity_9001630_LogPanel.super.ctor(self, ...)
	print("Activity_9001630_LogPanel:ctor", self.viewName)
end
function Activity_9001630_LogPanel:onInit()
	print("=======Activity_9001630_LogPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("nebula_paradise_text_07"))
	self.fields.Text_Tips:setString(i18n("parliament_text_11"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	SoraDShowLoading(self)
	activity_9001630_Ctrl:reqRecord()
end
function Activity_9001630_LogPanel:onShow()
	print("=======Activity_9001630_LogPanel:onShow")
end
function Activity_9001630_LogPanel:initData(logData)
	self.logData = logData
	table.sort(self.logData, function(a, b)
		return a.time < b.time
	end)
	self.fields.Text_NoLog:setVisible(#self.logData == 0)
	self.fields.Text_NoLog:setString(i18n("common_text_1464"))
	self.fields.List:setNumItems(#self.logData)
end
function Activity_9001630_LogPanel:onItemRederer(index, target)
	target:initData(self.logData[#self.logData - index])
end
return Activity_9001630_LogPanel
