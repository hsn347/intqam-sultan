local baseProxy = require("fgui.base.baseProxy")
local Activity_9001716_MainProxy = class("Activity_9001716_MainProxy", baseProxy)
function Activity_9001716_MainProxy:onRegisterEvent()
	print("=======Activity_9001716_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001716_UPDATE_TASK", handler(self, self.onMsgActivityUpdate))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001716_GET_REWARD", handler(self, self.onMsgGetReward))
end
function Activity_9001716_MainProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.BUBBLEPUZZLE_ACTIVITY_9001716) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001716_MainProxy:onMsgActivityUpdate(...)
	SoraDCloseLoading(self.view:displayObject())
	self.view:initData()
end
function Activity_9001716_MainProxy:onMsgGetReward(...)
	SoraDCloseLoading(self.view)
	self.view:initData()
end
return Activity_9001716_MainProxy
