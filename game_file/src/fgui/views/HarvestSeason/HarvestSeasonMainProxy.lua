local baseProxy = require("fgui.base.baseProxy")
local HarvestSeasonMainProxy = class("HarvestSeasonMainProxy", baseProxy)
function HarvestSeasonMainProxy:onRegisterEvent()
	print("=======HarvestSeasonMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function HarvestSeasonMainProxy:judgeClose()
	if self and self.view then
		self.view:judgeClose()
	end
end
return HarvestSeasonMainProxy
