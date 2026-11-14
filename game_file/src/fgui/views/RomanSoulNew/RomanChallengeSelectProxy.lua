local baseProxy = require("fgui.base.baseProxy")
local RomanChallengeSelectProxy = class("RomanChallengeSelectProxy", baseProxy)
function RomanChallengeSelectProxy:onRegisterEvent()
	print("=======RomanChallengeSelectProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_SELECTDIFF", handler(self, self.eventArrived))
end
function RomanChallengeSelectProxy:eventArrived()
	self.view:eventArrived()
end
return RomanChallengeSelectProxy
