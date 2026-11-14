local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseProxy = require("fgui.base.baseProxy")
local SixYearActivityProxy = class("SixYearActivityProxy", baseProxy)
function SixYearActivityProxy:ctor(...)
	self.super.ctor(self, ...)
	self.activityID = gActivityTimeActivityID.SIX_YEAR_ACTIVITY
end
function SixYearActivityProxy:onRegisterEvent()
	print("=======SixYearActivityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function SixYearActivityProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self.view:close()
	end
end
function SixYearActivityProxy:checkActivityIsShow(eid)
	local eventState = activityShowCtrl:getStateByID(eid)
	local clickEvent = clientEventMgr.getSingleClickEventConfig(eid)
	if clickEvent and (not clickEvent.checkIsOpen and clientEventMgr.judgeIsOnShow(eventState) or clickEvent.checkIsOpen and clientEventMgr.judgeIsOnlyOpenOnShow(eventState)) then
		return true
	end
	return false
end
return SixYearActivityProxy
