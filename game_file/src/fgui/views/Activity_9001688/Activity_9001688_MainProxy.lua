local baseProxy = require("fgui.base.baseProxy")
local Activity_9001688_MainProxy = class("Activity_9001688_MainProxy", baseProxy)
function Activity_9001688_MainProxy:onRegisterEvent()
	print("=======Activity_9001688_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001688_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_COMMON_SIGN_UPDATE", handler(self, self.signBack))
end
function Activity_9001688_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
function Activity_9001688_MainProxy:signBack(target, data)
	if data and data.activityID == self.view.activityID then
		self.view:initView(target, data)
	end
end
return Activity_9001688_MainProxy
