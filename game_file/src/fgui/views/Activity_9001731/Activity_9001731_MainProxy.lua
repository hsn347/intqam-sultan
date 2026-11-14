local baseProxy = require("fgui.base.baseProxy")
local Activity_9001731_MainProxy = class("Activity_9001731_MainProxy", baseProxy)
function Activity_9001731_MainProxy:onRegisterEvent()
	print("=======Activity_9001731_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001731_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initView))
end
function Activity_9001731_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001731_MainProxy
