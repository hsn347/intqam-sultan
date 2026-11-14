local baseProxy = require("fgui.base.baseProxy")
local Activity_9001615_TaskPopViewProxy = class("Activity_9001615_TaskPopViewProxy", baseProxy)
function Activity_9001615_TaskPopViewProxy:onRegisterEvent()
	print("=======Activity_9001615_TaskPopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_SMELT_DATA", handler(self, self.initData))
end
function Activity_9001615_TaskPopViewProxy:initData(target, data)
	self.view:initData(target, data)
end
return Activity_9001615_TaskPopViewProxy
