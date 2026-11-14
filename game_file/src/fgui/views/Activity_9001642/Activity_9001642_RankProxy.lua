local baseProxy = require("fgui.base.baseProxy")
local Activity_9001642_RankProxy = class("Activity_9001642_RankProxy", baseProxy)
function Activity_9001642_RankProxy:onRegisterEvent()
	print("=======Activity_9001642_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001642_RANK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function Activity_9001642_RankProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function Activity_9001642_RankProxy:sMsgReqInfoBack(target, data)
	self.view:sMsgReqInfoBack(target, data)
end
return Activity_9001642_RankProxy
