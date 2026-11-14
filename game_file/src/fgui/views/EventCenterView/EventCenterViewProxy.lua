local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseProxy = require("fgui.base.baseProxy")
local EventCenterViewProxy = class("EventCenterViewProxy", baseProxy)
function EventCenterViewProxy:onRegisterEvent()
	print("=======EventCenterViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_EVENTCENTER_REFRESHISNEW", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.refreshScroll))
end
function EventCenterViewProxy:initData(...)
	self.view:initData(...)
end
function EventCenterViewProxy:refreshScroll(...)
	self.view:refreshScroll(...)
end
function EventCenterViewProxy:getTextColor(singleData)
	local _state = singleData.eventState
	if _state == gActivityState.OPEN then
		return cc.c3b(112, 199, 35)
	elseif _state == gActivityState.PREPARE then
		return cc.c3b(200, 140, 70)
	elseif _state == gActivityState.CLOSE then
		return cc.c3b(224, 43, 43)
	elseif _state == gActivityState.CALCULATE then
		if gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY == singleData.eventID then
			return cc.c3b(224, 43, 43)
		else
			return cc.c3b(112, 199, 35)
		end
	end
end
return EventCenterViewProxy
