local baseProxy = require("fgui.base.baseProxy")
local Activity_9001689_MainProxy = class("Activity_9001689_MainProxy", baseProxy)
function Activity_9001689_MainProxy:onRegisterEvent()
	print("=======Activity_9001689_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001689_UPDATE", handler(self, self.initView))
end
function Activity_9001689_MainProxy:initView()
	self.view:initView()
end
return Activity_9001689_MainProxy
