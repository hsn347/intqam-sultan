local baseProxy = require("fgui.base.baseProxy")
local summerPrayersMainViewProxy = class("summerPrayersMainViewProxy", baseProxy)
function summerPrayersMainViewProxy:onRegisterEvent()
	print("=======summerPrayersMainViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updataRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
end
function summerPrayersMainViewProxy:updataRedPoint(...)
	self.view:updataRedPoint(...)
end
function summerPrayersMainViewProxy:msgCallBack(...)
	self.view:msgCallBack(...)
end
return summerPrayersMainViewProxy
