local baseProxy = require("fgui.base.baseProxy")
local Activity_9001718_MainProxy = class("Activity_9001718_MainProxy", baseProxy)
function Activity_9001718_MainProxy:onRegisterEvent()
	print("=======Activity_9001718_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001718_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateItem))
end
function Activity_9001718_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
function Activity_9001718_MainProxy:updateItem(target, data)
	self.view:updateItem(target, data)
end
return Activity_9001718_MainProxy
