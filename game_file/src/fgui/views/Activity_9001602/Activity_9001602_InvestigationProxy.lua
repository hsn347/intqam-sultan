local baseProxy = require("fgui.base.baseProxy")
local Activity_9001602_InvestigationProxy = class("Activity_9001602_InvestigationProxy", baseProxy)
function Activity_9001602_InvestigationProxy:onRegisterEvent()
	print("=======Activity_9001602_InvestigationProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function Activity_9001602_InvestigationProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(self.view.activityID)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
return Activity_9001602_InvestigationProxy
