local baseProxy = require("fgui.base.baseProxy")
local Activity_9001487_MainProxy = class("Activity_9001487_MainProxy", baseProxy)
function Activity_9001487_MainProxy:onRegisterEvent()
	print("=======Activity_9001487_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001487_CLAIM", handler(self, self.onMsgUpdateClaim))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001487_CUMUDAYDATA", handler(self, self.onMsgUpdateCumuDayData))
end
function Activity_9001487_MainProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001487_MainProxy:onMsgUpdateClaim(target, event)
	self.view:updateClaim(event.clientData)
end
function Activity_9001487_MainProxy:onMsgUpdateCumuDayData(...)
	self.view:onMsgUpdateCumuDayData()
end
function Activity_9001487_MainProxy:setActivityID(activityID)
	self.activityID = activityID
end
return Activity_9001487_MainProxy
