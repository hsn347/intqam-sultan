local baseProxy = require("fgui.base.baseProxy")
local Activity_9001669_AchiProxy = class("Activity_9001669_AchiProxy", baseProxy)
function Activity_9001669_AchiProxy:onRegisterEvent()
	print("=======Activity_9001669_AchiProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_COMMON_KITCHEN_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001669_AchiProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001669_AchiProxy
