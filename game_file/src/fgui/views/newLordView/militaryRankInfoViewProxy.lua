local baseProxy = require("fgui.base.baseProxy")
local militaryRankInfoViewProxy = class("militaryRankInfoViewProxy", baseProxy)
function militaryRankInfoViewProxy:onRegisterEvent()
	print("=======militaryRankInfoViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDMILITARY_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_LORDMILITARY_SKILL_STUDY", handler(self, self.initData))
end
function militaryRankInfoViewProxy:initData(target, data)
	self.view:initData(target, data)
end
return militaryRankInfoViewProxy
