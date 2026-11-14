local baseProxy = require("fgui.base.baseProxy")
local Activity_9001700_MakeProxy = class("Activity_9001700_MakeProxy", baseProxy)
function Activity_9001700_MakeProxy:onRegisterEvent()
	print("=======Activity_9001700_MakeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001700_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001700_MakeProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001700_MakeProxy
