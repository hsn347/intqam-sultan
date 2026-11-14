local baseProxy = require("fgui.base.baseProxy")
local eventSurpriseHarvestProxy = class("eventSurpriseHarvestProxy", baseProxy)
function eventSurpriseHarvestProxy:onRegisterEvent()
	print("=======eventSurpriseHarvestProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function eventSurpriseHarvestProxy:judgeClose()
	self.view:judgeClose()
end
return eventSurpriseHarvestProxy
