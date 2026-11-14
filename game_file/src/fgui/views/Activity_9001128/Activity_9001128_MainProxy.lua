local baseProxy = require("fgui.base.baseProxy")
local Activity_9001128_MainProxy = class("Activity_9001128_MainProxy", baseProxy)
function Activity_9001128_MainProxy:onRegisterEvent()
	print("=======Activity_9001128_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_SERVER_LUCKYBLESS_UPDATE", handler(self, self.initData))
end
function Activity_9001128_MainProxy:initData(target, data)
	self.view:initData(target, data)
end
return Activity_9001128_MainProxy
