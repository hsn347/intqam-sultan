local baseProxy = require("fgui.base.baseProxy")
local Activity_9001735_MainProxy = class("Activity_9001735_MainProxy", baseProxy)
function Activity_9001735_MainProxy:onRegisterEvent()
	print("=======Activity_9001735_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001735_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initView))
end
function Activity_9001735_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001735_MainProxy
