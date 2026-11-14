local baseProxy = require("fgui.base.baseProxy")
local Activity_9001709_MainProxy = class("Activity_9001709_MainProxy", baseProxy)
function Activity_9001709_MainProxy:onRegisterEvent()
	print("=======Activity_9001709_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
end
return Activity_9001709_MainProxy
