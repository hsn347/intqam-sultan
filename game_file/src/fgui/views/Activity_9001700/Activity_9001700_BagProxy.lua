local baseProxy = require("fgui.base.baseProxy")
local Activity_9001700_BagProxy = class("Activity_9001700_BagProxy", baseProxy)
function Activity_9001700_BagProxy:onRegisterEvent()
	print("=======Activity_9001700_BagProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001700_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001700_BagProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001700_BagProxy
