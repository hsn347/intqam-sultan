local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001606_rulePanel = class("Activity_9001606_rulePanel", baseFguiPanel)
local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
function Activity_9001606_rulePanel:ctor(...)
	Activity_9001606_rulePanel.super.ctor(self, ...)
	print("Activity_9001606_rulePanel:ctor", self.viewName)
end
function Activity_9001606_rulePanel:onInit()
	print("=======Activity_9001606_rulePanel:onInit")
	self.view:fixChildrenPos()
	self.fields.Com_title:initData(i18n("CombineServers_1"), handler(self, self.onClickClose))
	if activity_9001606_Ctrl:getActivityState() == gActivityTimeActivityID.NORMAL_ACTIVITY_9001605 then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NORMAL_ACTIVITY_9001605)
		if eventTime then
			_ENV = handler(self, self.onClickClose)
			handler(self, self.onClickClose).time = ""
			self.fields.Com_title:initSpecialActivityTime(eventTime.timerNode.timer:getRemainTime(), i18n("CombineServers_7", handler(self, self.onClickClose)))
		end
	else
		self.fields.Com_title:setTimeShow(false)
	end
end
function Activity_9001606_rulePanel:onShow()
	print("=======Activity_9001606_rulePanel:onShow")
end
return Activity_9001606_rulePanel
