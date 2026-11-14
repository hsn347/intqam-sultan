local baseProxy = require("fgui.base.baseProxy")
local Activity_9001703_ReadyProxy = class("Activity_9001703_ReadyProxy", baseProxy)
function Activity_9001703_ReadyProxy:onRegisterEvent()
	print("=======Activity_9001703_ReadyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001703_UPDATE", handler(self, self.initView))
end
function Activity_9001703_ReadyProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001703_ReadyProxy
