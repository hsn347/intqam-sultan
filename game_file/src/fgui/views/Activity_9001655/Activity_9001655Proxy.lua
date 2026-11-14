local baseProxy = require("fgui.base.baseProxy")
local Activity_9001655Proxy = class("Activity_9001655Proxy", baseProxy)
function Activity_9001655Proxy:onRegisterEvent()
	print("=======Activity_9001655Proxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001655_UPDATE", handler(self, self.onMsgUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMsgUpdateView))
end
function Activity_9001655Proxy:onMsgUpdateView(target, data)
	self.view:onMsgUpdateView(target, data)
end
return Activity_9001655Proxy
