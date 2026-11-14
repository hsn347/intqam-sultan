local baseProxy = require("fgui.base.baseProxy")
local worldRecommandEscortViewProxy = class("worldRecommandEscortViewProxy", baseProxy)
function worldRecommandEscortViewProxy:onRegisterEvent()
	print("=======worldRecommandEscortViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_GET_ROB_RECOMMAND_SUCCESS", handler(self, self.sMsgGetRobRecommandSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_GET_ROB_RECOMMAND_FAILED", handler(self, self.sMsgGetRobRecommandFailed))
end
function worldRecommandEscortViewProxy:sMsgGetRobRecommandSuccess(...)
	self.view:sMsgGetRobRecommandSuccess(...)
end
function worldRecommandEscortViewProxy:sMsgGetRobRecommandFailed(...)
	self.view:sMsgGetRobRecommandFailed(...)
end
return worldRecommandEscortViewProxy
