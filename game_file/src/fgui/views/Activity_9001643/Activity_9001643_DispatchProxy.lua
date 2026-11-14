local baseProxy = require("fgui.base.baseProxy")
local Activity_9001643_DispatchProxy = class("Activity_9001643_DispatchProxy", baseProxy)
function Activity_9001643_DispatchProxy:onRegisterEvent()
	print("=======Activity_9001643_DispatchProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001643_UPDATE", handler(self, self.updateView))
end
function Activity_9001643_DispatchProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return Activity_9001643_DispatchProxy
