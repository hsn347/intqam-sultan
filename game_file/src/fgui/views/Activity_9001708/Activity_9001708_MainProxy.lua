local baseProxy = require("fgui.base.baseProxy")
local Activity_9001708_MainProxy = class("Activity_9001708_MainProxy", baseProxy)
function Activity_9001708_MainProxy:onRegisterEvent()
	print("=======Activity_9001708_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001708_UPDATE", handler(self, self.onMsgUpdateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH", handler(self, self.onMsgUpdateExchange))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMsgUpdateItemCount))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_SET_REFRESH", handler(self, self.onMsgUpdateRemain))
end
function Activity_9001708_MainProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
function Activity_9001708_MainProxy:onMsgUpdateExchange(...)
	self.view:onMsgUpdateExchange(...)
end
function Activity_9001708_MainProxy:onMsgUpdateItemCount(...)
	self.view:onMsgUpdateItemCount(...)
end
function Activity_9001708_MainProxy:onMsgUpdateRemain(...)
	self.view:onMsgUpdateRemain(...)
end
return Activity_9001708_MainProxy
