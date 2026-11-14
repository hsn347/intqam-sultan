local baseProxy = require("fgui.base.baseProxy")
local rankingsScrollViewProxy = class("rankingsScrollViewProxy", baseProxy)
function rankingsScrollViewProxy:onRegisterEvent()
	print("=======rankingsScrollViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_RANKINGS_SUCCESS", handler(self, self.rankingsBack))
end
function rankingsScrollViewProxy:sMsgReqInfoBack(target, data)
	self.view:sMsgReqInfoBack(target, data)
end
function rankingsScrollViewProxy:rankingsBack(target, data)
	self.view:rankingsBack(target, data)
end
return rankingsScrollViewProxy
