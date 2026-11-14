local baseProxy = require("fgui.base.baseProxy")
local Activity_9001566_mainProxy = class("Activity_9001566_mainProxy", baseProxy)
function Activity_9001566_mainProxy:onRegisterEvent()
	print("=======Activity_9001566_mainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001566_UPDATE", handler(self, self.onMsgUpdateReward))
end
function Activity_9001566_mainProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001566_mainProxy:onMsgUpdateReward(...)
	self.view:onMsgUpdateReward(...)
end
return Activity_9001566_mainProxy
