local baseProxy = require("fgui.base.baseProxy")
local Activity_9001558_MainProxy = class("Activity_9001558_MainProxy", baseProxy)
function Activity_9001558_MainProxy:onRegisterEvent()
	print("=======Activity_9001558_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001558_RECEIVE", handler(self, self.onMsgReceiveBack))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.onMsgUpdateTask))
end
function Activity_9001558_MainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.STELLAR_ODYSSEY_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001558_MainProxy:onMsgReceiveBack(...)
	self.view:onMsgReceiveBack()
end
function Activity_9001558_MainProxy:onMsgUpdateTask(...)
	self.view:onMsgUpdateTask()
end
return Activity_9001558_MainProxy
