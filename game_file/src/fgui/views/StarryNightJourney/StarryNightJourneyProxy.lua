local baseProxy = require("fgui.base.baseProxy")
local StarryNightJourneyProxy = class("StarryNightJourneyProxy", baseProxy)
function StarryNightJourneyProxy:onRegisterEvent()
	print("=======StarryNightJourneyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_STARRY_NIGHT_JOURNEY", handler(self, self.initData))
end
function StarryNightJourneyProxy:initData(target, data)
	if self.view then
		self.view:initData()
	end
end
function StarryNightJourneyProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.STARRY_NIGHT_JOURNEY) then
		self.view:close()
	end
end
return StarryNightJourneyProxy
