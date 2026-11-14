local baseProxy = require("fgui.base.baseProxy")
local Activity_9001688_PopProxy = class("Activity_9001688_PopProxy", baseProxy)
function Activity_9001688_PopProxy:onRegisterEvent()
	print("=======Activity_9001688_PopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001688_UPDATE", handler(self, self.initView))
end
function Activity_9001688_PopProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001688_PopProxy
