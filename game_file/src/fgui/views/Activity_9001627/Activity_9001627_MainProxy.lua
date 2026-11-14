local baseProxy = require("fgui.base.baseProxy")
local Activity_9001627_MainProxy = class("Activity_9001627_MainProxy", baseProxy)
function Activity_9001627_MainProxy:onRegisterEvent()
	print("=======Activity_9001627_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_DROP_ACTIVITY_CURDAY_REFRESH", handler(self, self.onMsgUpdateData))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.onMsgNewDay))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMsgUpdateItemCount))
end
function Activity_9001627_MainProxy:judgeClose()
	self.view:judgeClose()
end
function Activity_9001627_MainProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
function Activity_9001627_MainProxy:onMsgNewDay(...)
	self.view:onMsgNewDay(...)
end
function Activity_9001627_MainProxy:onMsgUpdateItemCount(...)
	self.view:onMsgUpdateItemCount(...)
end
return Activity_9001627_MainProxy
