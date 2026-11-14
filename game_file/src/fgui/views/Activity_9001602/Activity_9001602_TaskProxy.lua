local baseProxy = require("fgui.base.baseProxy")
local Activity_9001602_TaskProxy = class("Activity_9001602_TaskProxy", baseProxy)
function Activity_9001602_TaskProxy:onRegisterEvent()
	print("=======Activity_9001602_TaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_FIREDRAGON_OF_ANGER_REFRESH", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function Activity_9001602_TaskProxy:onUpdateView()
	self.view:updateView()
end
function Activity_9001602_TaskProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(self.view.activityID)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
return Activity_9001602_TaskProxy
