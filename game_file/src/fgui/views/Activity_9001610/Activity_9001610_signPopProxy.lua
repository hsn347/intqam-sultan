local baseProxy = require("fgui.base.baseProxy")
local Activity_9001610_signPopProxy = class("Activity_9001610_signPopProxy", baseProxy)
function Activity_9001610_signPopProxy:onRegisterEvent()
	print("=======Activity_9001610_signPopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.closeSelf))
end
function Activity_9001610_signPopProxy:closeSelf()
	self.view:close()
end
return Activity_9001610_signPopProxy
