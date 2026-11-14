local baseProxy = require("fgui.base.baseProxy")
local Activity_9001717_TaskProxy = class("Activity_9001717_TaskProxy", baseProxy)
function Activity_9001717_TaskProxy:onRegisterEvent()
	print("=======Activity_9001717_TaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001717_UPDATE", handler(self, self.onMsgUpdateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgCheckStage))
end
function Activity_9001717_TaskProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
function Activity_9001717_TaskProxy:onMsgCheckStage(target, data)
	self.view:onMsgCheckStage(target, data)
end
return Activity_9001717_TaskProxy
