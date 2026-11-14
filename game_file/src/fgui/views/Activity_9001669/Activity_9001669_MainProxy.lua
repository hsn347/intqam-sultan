local baseProxy = require("fgui.base.baseProxy")
local Activity_9001669_MainProxy = class("Activity_9001669_MainProxy", baseProxy)
function Activity_9001669_MainProxy:onRegisterEvent()
	print("=======Activity_9001669_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_COMMON_KITCHEN_UPDATE", handler(self, self.onMsgUpdateData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMsgUpdateItemCount))
end
function Activity_9001669_MainProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
function Activity_9001669_MainProxy:onMsgUpdateItemCount(...)
	self.view:onMsgUpdateItemCount(...)
end
return Activity_9001669_MainProxy
