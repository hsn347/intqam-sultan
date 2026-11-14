local baseProxy = require("fgui.base.baseProxy")
local Activity_9001703_PassProxy = class("Activity_9001703_PassProxy", baseProxy)
function Activity_9001703_PassProxy:onRegisterEvent()
	print("=======Activity_9001703_PassProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001703_UPDATE", handler(self, self.initView))
end
function Activity_9001703_PassProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001703_PassProxy
