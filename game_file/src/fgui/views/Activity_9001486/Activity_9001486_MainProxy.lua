local baseProxy = require("fgui.base.baseProxy")
local Activity_9001486_MainProxy = class("Activity_9001486_MainProxy", baseProxy)
function Activity_9001486_MainProxy:onRegisterEvent()
	print("=======Activity_9001486_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001486_CLAIM", handler(self, self.onMsgUpdateClaim))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001486_CUMUDAYDATA", handler(self, self.onMsgUpdateCumuDayData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001486_BUYGIFT", handler(self, self.onMsgBuyGift))
end
function Activity_9001486_MainProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001486_MainProxy:onMsgUpdateClaim(target, event)
	self.view:updateClaim(event.index)
end
function Activity_9001486_MainProxy:onMsgUpdateCumuDayData(...)
	self.view:onMsgUpdateCumuDayData()
end
function Activity_9001486_MainProxy:onMsgBuyGift(...)
	self.view:onMsgBuyGift()
end
function Activity_9001486_MainProxy:setActivityID(activityID)
	self.activityID = activityID
end
return Activity_9001486_MainProxy
