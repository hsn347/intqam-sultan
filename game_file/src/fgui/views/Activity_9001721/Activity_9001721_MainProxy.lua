local baseProxy = require("fgui.base.baseProxy")
local Activity_9001721_MainProxy = class("Activity_9001721_MainProxy", baseProxy)
function Activity_9001721_MainProxy:onRegisterEvent()
	print("=======Activity_9001721_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001721_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.initView))
end
function Activity_9001721_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
function Activity_9001721_MainProxy:updateView(target, data)
	if data and data.eventID == self.view.activityID then
		self.view:initView(target, data)
	end
end
return Activity_9001721_MainProxy
