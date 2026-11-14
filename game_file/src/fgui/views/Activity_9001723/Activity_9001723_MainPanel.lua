local activity_9001723_Read = include("activity_9001723_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001723_MainPanel = class("Activity_9001723_MainPanel", baseFguiPanel)
function Activity_9001723_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001723_MainPanel.super.ctor(self, ...)
	print("Activity_9001723_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_2025_9001723
end
function Activity_9001723_MainPanel:onInit()
	print("=======Activity_9001723_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
end
function Activity_9001723_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("anniversary_2025_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001723_MainPanel:endShow()
	print("=======Activity_9001723_MainPanel:endShow")
	self:initData()
end
function Activity_9001723_MainPanel:initData(...)
	self.fields.map:initZoomParam(self.fields.map:getHeight())
	self.fields.map:initData()
end
return Activity_9001723_MainPanel
