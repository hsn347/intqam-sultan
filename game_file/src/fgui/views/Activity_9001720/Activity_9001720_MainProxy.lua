local baseProxy = require("fgui.base.baseProxy")
local Activity_9001720_MainProxy = class("Activity_9001720_MainProxy", baseProxy)
function Activity_9001720_MainProxy:onRegisterEvent()
	print("=======Activity_9001720_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001720_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001720_MainProxy:judgeClose(target, event)
	self.view:judgeClose(target, event)
end
function Activity_9001720_MainProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001720_MainProxy
