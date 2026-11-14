local baseProxy = require("fgui.base.baseProxy")
local Activity_9001601_MainProxy = class("Activity_9001601_MainProxy", baseProxy)
function Activity_9001601_MainProxy:onRegisterEvent()
	print("=======Activity_9001601_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001601_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001601_MainProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001601_MainProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001601_MainProxy
