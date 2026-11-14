local baseProxy = require("fgui.base.baseProxy")
local WorldEscortBeginViewProxy = class("WorldEscortBeginViewProxy", baseProxy)
function WorldEscortBeginViewProxy:onRegisterEvent()
	print("=======WorldEscortBeginViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_ESCORT_SHOW_LOADING", handler(self, self.msgShowLoading))
	SoraDAddMessage(self, "MESSAGE_UI_ESCORT_CLOSE_LOADING", handler(self, self.msgCloseLoading))
	SoraDAddMessage(self, "MESSAGE_UI_ESCORT_ALLIANCE_MEMEBER_SELECTED", handler(self, self.msgAllianceMemberSelected))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_REQ_CAR_DATA_BACK", handler(self, self.sMsgCarDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_CAR_APPOINT_SUCCESS", handler(self, self.sMsgCarAppointSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_CAR_REFRESH_SUCCESS", handler(self, self.sMsgCarRefreshSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_INVITE_SUCCESS", handler(self, self.sMsgInviteSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_INVITE_FAILED", handler(self, self.sMsgInviteFailed))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_SEND_INVITE_TIME_OUT", handler(self, self.sMsgSendInviteTimeOut))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_ASSIST_INVITE_ACCEPTED", handler(self, self.sMsgAssistInviteAccepted))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_ASSIST_INVITE_REJECTED", handler(self, self.sMsgAssistInviteRected))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_SELF_ESCORT_TIMEOUT", handler(self, self.sMsgSelfEscortTimeOut))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_REQ_CAR_DATA_FAILED", handler(self, self.sMsgReqCarDataFailed))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_ESCORT_CAR_ADD_VALUE_UPDATE", handler(self, self.updateCarAddValue))
end
function WorldEscortBeginViewProxy:msgShowLoading(...)
	self.view:msgShowLoading(...)
end
function WorldEscortBeginViewProxy:msgCloseLoading(...)
	self.view:msgCloseLoading(...)
end
function WorldEscortBeginViewProxy:msgAllianceMemberSelected(...)
	self.view:msgAllianceMemberSelected(...)
end
function WorldEscortBeginViewProxy:sMsgCarDataBack(...)
	self.view:sMsgCarDataBack(...)
end
function WorldEscortBeginViewProxy:sMsgCarAppointSuccess(...)
	self.view:sMsgCarAppointSuccess(...)
end
function WorldEscortBeginViewProxy:sMsgCarRefreshSuccess(...)
	self.view:sMsgCarRefreshSuccess(...)
end
function WorldEscortBeginViewProxy:sMsgInviteSuccess(...)
	self.view:sMsgInviteSuccess(...)
end
function WorldEscortBeginViewProxy:sMsgInviteFailed(...)
	self.view:sMsgInviteFailed(...)
end
function WorldEscortBeginViewProxy:sMsgSendInviteTimeOut(...)
	self.view:sMsgSendInviteTimeOut(...)
end
function WorldEscortBeginViewProxy:sMsgAssistInviteAccepted(...)
	self.view:sMsgAssistInviteAccepted(...)
end
function WorldEscortBeginViewProxy:sMsgAssistInviteRected(...)
	self.view:sMsgAssistInviteRected(...)
end
function WorldEscortBeginViewProxy:sMsgSelfEscortTimeOut(...)
	self.view:sMsgSelfEscortTimeOut(...)
end
function WorldEscortBeginViewProxy:sMsgReqCarDataFailed(...)
	self.view:sMsgReqCarDataFailed(...)
end
function WorldEscortBeginViewProxy:updateCarAddValue(...)
	self.view:updateCarAddValue(...)
end
function WorldEscortBeginViewProxy:initWithData(...)
	self.view:initWithData(...)
end
return WorldEscortBeginViewProxy
