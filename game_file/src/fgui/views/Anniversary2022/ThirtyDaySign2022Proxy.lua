local baseProxy = require("fgui.base.baseProxy")
local ThirtyDaySign2022Proxy = class("ThirtyDaySign2022Proxy", baseProxy)
function ThirtyDaySign2022Proxy:onRegisterEvent()
	print("=======ThirtyDaySign2022Proxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_2022_SIGN", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.initData))
end
function ThirtyDaySign2022Proxy:refreshView(target, data)
	if self.view then
		self.view:refreshView(data)
	end
end
function ThirtyDaySign2022Proxy:initData()
	if self.view then
		self.view:refreshPageInZero()
	end
end
function ThirtyDaySign2022Proxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANNIVERSARY_SIGN_2022_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return ThirtyDaySign2022Proxy
