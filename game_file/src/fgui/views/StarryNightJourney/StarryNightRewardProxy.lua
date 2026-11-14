local baseProxy = require("fgui.base.baseProxy")
local StarryNightRewardProxy = class("StarryNightRewardProxy", baseProxy)
function StarryNightRewardProxy:onRegisterEvent()
	print("=======StarryNightRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_STARRY_NIGHT_JOURNEY", handler(self, self.initData))
end
function StarryNightRewardProxy:initData(target, data)
	if self.view then
		self.view:initData()
	end
end
return StarryNightRewardProxy
