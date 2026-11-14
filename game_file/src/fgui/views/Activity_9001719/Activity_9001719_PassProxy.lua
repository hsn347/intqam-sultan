local baseProxy = require("fgui.base.baseProxy")
local Activity_9001719_PassProxy = class("Activity_9001719_PassProxy", baseProxy)
function Activity_9001719_PassProxy:onRegisterEvent()
	print("=======Activity_9001719_PassProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001719_UPDATE", handler(self, self.initView))
end
function Activity_9001719_PassProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001719_PassProxy
