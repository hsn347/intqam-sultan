local baseProxy = require("fgui.base.baseProxy")
local eventSnowHarvestProxy = class("eventSnowHarvestProxy", baseProxy)
function eventSnowHarvestProxy:onRegisterEvent()
	print("=======eventSnowHarvestProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_DROP_ACTIVITY_CURDAY_REFRESH", handler(self, self.refreshGot))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function eventSnowHarvestProxy:refreshGot(target, data)
	self.view:refreshGot(target, data)
end
function eventSnowHarvestProxy:judgeClose()
	self.view:judgeClose()
end
return eventSnowHarvestProxy
