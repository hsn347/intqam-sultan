local baseProxy = require("fgui.base.baseProxy")
local Activity_9001638_MainProxy = class("Activity_9001638_MainProxy", baseProxy)
function Activity_9001638_MainProxy:onRegisterEvent()
	print("=======Activity_9001638_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_COMMON_BUBBLE_UPDATE", handler(self, self.onMsgUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMsgUpdateItemCount))
end
function Activity_9001638_MainProxy:onMsgUpdateView(...)
	self.view:onMsgUpdateView(...)
end
function Activity_9001638_MainProxy:onMsgUpdateItemCount(...)
	self.view:updateItemCount()
end
return Activity_9001638_MainProxy
