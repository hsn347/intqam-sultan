local baseProxy = require("fgui.base.baseProxy")
local Activity_9001639_MainProxy = class("Activity_9001639_MainProxy", baseProxy)
function Activity_9001639_MainProxy:onRegisterEvent()
	print("=======Activity_9001639_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001639_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_EXCHANGE_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_SET_REFRESH", handler(self, self.updateView))
end
function Activity_9001639_MainProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return Activity_9001639_MainProxy
