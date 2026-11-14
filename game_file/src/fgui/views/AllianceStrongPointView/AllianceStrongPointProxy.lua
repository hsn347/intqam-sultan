local baseProxy = require("fgui.base.baseProxy")
local AllianceStrongPointProxy = class("AllianceStrongPointProxy", baseProxy)
function AllianceStrongPointProxy:onRegisterEvent()
	print("=======AllianceStrongPointProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_STRONTHOLD_BACK", handler(self, self.initData))
end
function AllianceStrongPointProxy:initData(...)
	self.view:initData(...)
end
return AllianceStrongPointProxy
