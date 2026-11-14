local baseProxy = require("fgui.base.baseProxy")
local StarryNightJourneyDetailProxy = class("StarryNightJourneyDetailProxy", baseProxy)
function StarryNightJourneyDetailProxy:onRegisterEvent()
	print("=======StarryNightJourneyDetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_STARRY_NIGHT_JOURNEY", handler(self, self.initData))
end
function StarryNightJourneyDetailProxy:initData(target, data)
	if self.view then
		self.view:initData()
	end
end
return StarryNightJourneyDetailProxy
