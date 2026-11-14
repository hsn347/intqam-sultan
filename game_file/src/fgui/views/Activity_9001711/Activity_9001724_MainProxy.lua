local baseProxy = require("fgui.base.baseProxy")
local Activity_9001724_MainProxy = class("Activity_9001724_MainProxy", baseProxy)
function Activity_9001724_MainProxy:onRegisterEvent()
	print("=======Activity_9001724_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001711_UPDATE", handler(self, self.updateUI))
end
function Activity_9001724_MainProxy:updateUI(target, data)
	self.view:initData()
end
return Activity_9001724_MainProxy
