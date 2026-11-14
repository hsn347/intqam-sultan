local baseProxy = require("fgui.base.baseProxy")
local ThirtyDaySign2021MainViewProxy = class("ThirtyDaySign2021MainViewProxy", baseProxy)
function ThirtyDaySign2021MainViewProxy:onRegisterEvent()
	print("=======ThirtyDaySign2021MainViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_SIGNREWARD_LAMPREFRESH", handler(self, self.refreshCumuDay))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_SIGNREWARD_BLOCKREFRESH", handler(self, self.refreshDay))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.eventStateChange))
end
function ThirtyDaySign2021MainViewProxy:refreshDay(target, data)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SIGN_REWARD_ACTIVITY) then
		self.view:refreshDay(target, data)
	end
end
function ThirtyDaySign2021MainViewProxy:refreshCumuDay(target, data)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SIGN_REWARD_ACTIVITY) then
		self.view:refreshCumuDay(target, data)
	end
end
function ThirtyDaySign2021MainViewProxy:dispatchFun(target, retData)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SIGN_REWARD_ACTIVITY) then
		self.view:initData()
	end
end
function ThirtyDaySign2021MainViewProxy:eventStateChange()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SIGN_REWARD_ACTIVITY) then
		if self.view then
			self.view:close()
		end
	else
		self.view:initData()
	end
end
return ThirtyDaySign2021MainViewProxy
