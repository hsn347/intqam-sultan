local baseProxy = require("fgui.base.baseProxy")
local Activity_9001721_TaskProxy = class("Activity_9001721_TaskProxy", baseProxy)
function Activity_9001721_TaskProxy:onRegisterEvent()
	print("=======Activity_9001721_TaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001721_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updateView))
end
function Activity_9001721_TaskProxy:initView(target, data)
	self.view:initView(target, data)
end
function Activity_9001721_TaskProxy:updateView(target, data)
	if data and data.eventID == self.view.activityID then
		self.view:initView(target, data)
	end
end
return Activity_9001721_TaskProxy
