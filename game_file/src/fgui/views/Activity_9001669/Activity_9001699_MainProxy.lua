local baseProxy = require("fgui.base.baseProxy")
local Activity_9001699_MainProxy = class("Activity_9001699_MainProxy", baseProxy)
function Activity_9001699_MainProxy:onRegisterEvent()
	print("=======Activity_9001699_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_COMMON_KITCHEN_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001699_MainProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001699_MainProxy
