local baseComponent = require("fgui.base.baseComponent")
local Com_activity9001605 = fgui.extension_class(fgui.GButton, baseComponent)
local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
fgui.register_extension("ui://MainUI/Com_activity9001605", Com_activity9001605)
function Com_activity9001605:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self.Text_Time:setTimeLast(function(timeStr)
		return timeStr
	end)
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.Node_etNew:setVisible(false)
	self.fields.Label_reddot:fixPos()
	self.fields.Node_etNew:fixPos()
end
function Com_activity9001605:onShow()
end
function Com_activity9001605:setTime(time)
	self.Text_Time:beginTime(time)
end
function Com_activity9001605:setNewJumpVisible(ret)
	self.fields.Node_etNew:setVisible(ret)
end
function Com_activity9001605:setRedVisible(ret)
	self.fields.Label_reddot:initData(ret)
end
function Com_activity9001605:onBtnClick()
	if not activity_9001606_Ctrl:getIsGotData() then
		return
	end
	SoraDPlaySound()
	local state = activity_9001606_Ctrl:getActivityState()
	SoraDGetCtrl("activityCenterUICtrl"):sendClearNewMsg(state)
	self:setNewJumpVisible(false)
	if state == activity_9001606_Ctrl.activityState.SHOWING then
		uiManager:show("Activity_9001606_showing")
	elseif state == activity_9001606_Ctrl.activityState.PREVIEW then
		if activity_9001606_Ctrl:getIsServerCanInvite() then
			uiManager:show("Activity_9001606_kingdoms")
		else
			uiManager:show("Activity_9001606_noInivtes")
		end
	end
end
return Com_activity9001605
