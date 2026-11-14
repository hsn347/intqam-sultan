local baseProxy = require("fgui.base.baseProxy")
local Activity_9001602_MainProxy = class("Activity_9001602_MainProxy", baseProxy)
function Activity_9001602_MainProxy:onRegisterEvent()
	print("=======Activity_9001602_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_FIREDRAGON_OF_ANGER_REFRESH", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function Activity_9001602_MainProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(self.view.activityID)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
function Activity_9001602_MainProxy:onUpdateView()
	self.view:updateView()
end
return Activity_9001602_MainProxy
