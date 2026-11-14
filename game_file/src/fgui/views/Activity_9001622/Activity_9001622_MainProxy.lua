local baseProxy = require("fgui.base.baseProxy")
local Activity_9001622_MainProxy = class("Activity_9001622_MainProxy", baseProxy)
function Activity_9001622_MainProxy:onRegisterEvent()
	print("=======Activity_9001622_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001622_UPDATE", handler(self, self.onMsgUpdateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgCommonRefresh))
end
function Activity_9001622_MainProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
function Activity_9001622_MainProxy:onMsgCommonRefresh(...)
	self.view:onMsgCommonRefresh(...)
end
return Activity_9001622_MainProxy
