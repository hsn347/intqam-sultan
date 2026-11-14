local baseProxy = require("fgui.base.baseProxy")
local Activity_9001640_MainProxy = class("Activity_9001640_MainProxy", baseProxy)
function Activity_9001640_MainProxy:onRegisterEvent()
	print("=======Activity_9001640_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_COMMON_DRAW_UPDATE", handler(self, self.onMsgCommonDrawUpdate))
end
function Activity_9001640_MainProxy:judgeClose(target, event)
	if not clientEventMgr.getEventInfoByeid(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001640_MainProxy:onMsgCommonDrawUpdate(target, event)
	if event.activityID ~= self.view.activityID then
		return
	end
	self.view:onMsgCommonDrawUpdate(target, event)
end
return Activity_9001640_MainProxy
