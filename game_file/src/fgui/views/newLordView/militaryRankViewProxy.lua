local baseProxy = require("fgui.base.baseProxy")
local militaryRankViewProxy = class("militaryRankViewProxy", baseProxy)
function militaryRankViewProxy:onRegisterEvent()
	print("=======militaryRankViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDMILITARY_GET_REWARD", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_LORDMILITARY_UPDATE", handler(self, self.initData))
end
function militaryRankViewProxy:initData(target, data)
	self.view:initData(target, data)
end
return militaryRankViewProxy
