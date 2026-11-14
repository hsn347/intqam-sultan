local baseProxy = require("fgui.base.baseProxy")
local IceFestivalProxy = class("IceFestivalProxy", baseProxy)
function IceFestivalProxy:onRegisterEvent()
	print("=======IceFestivalProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ICE_CUMULATIVE_RECHARGE_REFRESH", handler(self, self.msgUpdate))
end
function IceFestivalProxy:msgUpdate(target, data)
	SoraDCloseLoading()
	self.view:updateView()
	self.view:unLockBack(data.index, data.reward)
end
function IceFestivalProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		self.view:close()
	end
end
return IceFestivalProxy
