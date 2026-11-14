local baseProxy = require("fgui.base.baseProxy")
local Activity_9001722_MainProxy = class("Activity_9001722_MainProxy", baseProxy)
function Activity_9001722_MainProxy:onRegisterEvent()
	print("=======Activity_9001722_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_NEBULA_EXCHANGE_BACK", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_COMMON_ICON_TIP", handler(self, self.updateCommonIconTip))
end
function Activity_9001722_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
function Activity_9001722_MainProxy:updateCommonIconTip(target, data)
	self.view:hideTips()
end
return Activity_9001722_MainProxy
