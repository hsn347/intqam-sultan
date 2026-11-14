local baseProxy = require("fgui.base.baseProxy")
local worldEscortOpenViewProxy = class("worldEscortOpenViewProxy", baseProxy)
function worldEscortOpenViewProxy:onRegisterEvent()
	print("=======worldEscortOpenViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_REQ_ESCORT_ALLIANCE_ADD_SUCCESS", handler(self, self.sMsgAddSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_REQ_ESCORT_ALLIANCE_ADD_FAILED", handler(self, self.sMsgAddFailed))
end
function worldEscortOpenViewProxy:sMsgAddSuccess(...)
	self.view:sMsgAddSuccess(...)
end
function worldEscortOpenViewProxy:sMsgAddFailed(...)
	self.view:sMsgAddFailed(...)
end
return worldEscortOpenViewProxy
