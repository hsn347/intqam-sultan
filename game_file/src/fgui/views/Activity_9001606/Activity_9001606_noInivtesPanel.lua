local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001606_noInivtesPanel = class("Activity_9001606_noInivtesPanel", baseFguiPanel)
function Activity_9001606_noInivtesPanel:ctor(...)
	Activity_9001606_noInivtesPanel.super.ctor(self, ...)
	self.debug = true
	self.isHideCurrentSceneView = true
	print("Activity_9001606_noInivtesPanel:ctor", self.viewName)
end
function Activity_9001606_noInivtesPanel:onInit()
	print("=======Activity_9001606_noInivtesPanel:onInit")
	self.view:fixChildrenPos()
	self.fields.Com_title:initData(i18n("CombineServers_1"), handler(self, self.onClickClose))
	self.fields.btn_details:setTitle(i18n("CombineServers_8"))
	self.fields.btn_details:addClickEventListener(handler(self, self.onDetailsClick))
	_ENV = handler(self, self.onDetailsClick)
	handler(self, self.onDetailsClick).time = ""
	self.fields.txt_timeDes:setString(i18n("CombineServers_7", handler(self, self.onDetailsClick)))
	self.fields.Text_desc:setString(i18n("CombineServers_6"))
	self.timeLabel = SoraDCreateTimerLabel(self, self.fields.Text_time)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NORMAL_ACTIVITY_9001605)
	if eventTime then
		self.timeLabel:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function Activity_9001606_noInivtesPanel:onShow()
	print("=======Activity_9001606_noInivtesPanel:onShow")
end
function Activity_9001606_noInivtesPanel:initData()
end
function Activity_9001606_noInivtesPanel:onDetailsClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001606_rule")
end
return Activity_9001606_noInivtesPanel
