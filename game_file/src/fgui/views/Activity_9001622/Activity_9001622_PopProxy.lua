local baseProxy = require("fgui.base.baseProxy")
local Activity_9001622_PopProxy = class("Activity_9001622_PopProxy", baseProxy)
function Activity_9001622_PopProxy:onRegisterEvent()
	print("=======Activity_9001622_PopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgCommonRefresh))
end
function Activity_9001622_PopProxy:onMsgCommonRefresh(...)
	self.view:onMsgCommonRefresh(...)
end
return Activity_9001622_PopProxy
