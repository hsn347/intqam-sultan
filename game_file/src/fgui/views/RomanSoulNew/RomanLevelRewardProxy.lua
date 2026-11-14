local baseProxy = require("fgui.base.baseProxy")
local RomanLevelRewardProxy = class("RomanLevelRewardProxy", baseProxy)
function RomanLevelRewardProxy:onRegisterEvent()
	print("=======RomanLevelRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_INFOREQUEST", handler(self, self.initData))
end
function RomanLevelRewardProxy:initData()
	if self.view then
		self.view:close()
	end
end
return RomanLevelRewardProxy
