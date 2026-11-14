local baseProxy = require("fgui.base.baseProxy")
local eventRamadanHarvestProxy = class("eventRamadanHarvestProxy", baseProxy)
function eventRamadanHarvestProxy:onRegisterEvent()
	print("=======eventRamadanHarvestProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_DROP_ACTIVITY_CURDAY_REFRESH", handler(self, self.refreshGot))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function eventRamadanHarvestProxy:refreshGot(target, data)
	self.view:refreshGot(target, data)
end
function eventRamadanHarvestProxy:judgeClose()
	self.view:judgeClose()
end
return eventRamadanHarvestProxy
