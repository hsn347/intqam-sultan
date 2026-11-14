local baseProxy = require("fgui.base.baseProxy")
local Activity_9001493_mainProxy = class("Activity_9001493_mainProxy", baseProxy)
function Activity_9001493_mainProxy:onRegisterEvent()
	print("=======Activity_9001493_mainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001493_UPDATE", handler(self, self.onMsgActivityUpdate))
end
function Activity_9001493_mainProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.GIVE_GIFTS_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001493_mainProxy:onMsgActivityUpdate(...)
	self.view:updateItemCount()
end
return Activity_9001493_mainProxy
