local baseProxy = require("fgui.base.baseProxy")
local Activity_9001608_MainProxy = class("Activity_9001608_MainProxy", baseProxy)
function Activity_9001608_MainProxy:onRegisterEvent()
	print("=======Activity_9001608_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgCommonRefresh))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001608_UPDATE_RED", handler(self, self.onMsgUpdateRed))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001608_JUMP_ACTIVITY", handler(self, self.onMsgJumpActivity))
end
function Activity_9001608_MainProxy:onMsgCommonRefresh(target, event)
	local activityID = event.activityID
	if not activityID then
		return
	end
	if type(activityID) == "table" then
		for __, _activityID in ipairs(activityID) do
			self.view:updateActivityState(_activityID)
		end
	else
		self.view:updateActivityState(activityID)
	end
end
function Activity_9001608_MainProxy:onMsgUpdateRed(...)
	self.view:onMsgUpdateRed(...)
end
function Activity_9001608_MainProxy:onMsgJumpActivity(...)
	self.view:onMsgJumpActivity(...)
end
return Activity_9001608_MainProxy
