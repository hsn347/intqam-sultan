local baseProxy = require("fgui.base.baseProxy")
local lordPowerViewProxy = class("lordPowerViewProxy", baseProxy)
function lordPowerViewProxy:onRegisterEvent()
	print("=======lordPowerViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_FCINFO", handler(self, self.initData))
end
function lordPowerViewProxy:initData()
	self.view:initData()
end
return lordPowerViewProxy
