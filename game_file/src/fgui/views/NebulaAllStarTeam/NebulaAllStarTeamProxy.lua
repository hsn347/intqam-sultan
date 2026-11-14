local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarTeamProxy = class("NebulaAllStarTeamProxy", baseProxy)
function NebulaAllStarTeamProxy:onRegisterEvent()
	print("=======NebulaAllStarTeamProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_MEMBER_INFO_BACK", handler(self, self.onMsgMemberInfoBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_TEAM_INFO", handler(self, self.onMsgReqTeamInfoBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INFO_NOTIFY", handler(self, self.onMsgTeamInfoNotify))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MSG", handler(self, self.onMsgUpdateNewTeamMsg))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_QUIT_BACk", handler(self, self.onMsgQuickBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_BEINVITE_BACK", handler(self, self.onMsgBeInviteBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_APPLY_JOIN_BACK", handler(self, self.onMsgApplyJoinBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_APPLY_REMIND", handler(self, self.onMsgUpdateApplyRemind))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_REFRESH_DATA", handler(self, self.onMsgRefreshData))
end
function NebulaAllStarTeamProxy:onMsgMemberInfoBack(...)
	self.view:onMsgMemberInfoBack(...)
end
function NebulaAllStarTeamProxy:onMsgReqTeamInfoBack(...)
	self.view:onMsgReqTeamInfoBack(...)
end
function NebulaAllStarTeamProxy:onMsgTeamInfoNotify(target, event)
	if event.teamType and event.teamType ~= self.view.teamType then
		return
	end
	local notifyType = event.notifyType
	_ENV = self.view.teamType
	self.view.teamType.JOIN = true
	local self.view.teamType.QUIT, config = true, self.view.teamType
	if config[notifyType] then
		self.view:refreshMemberInfo()
	elseif notifyType == "UPDATE_SETTING" then
		local notifyKey = event.key
		if notifyKey == "commanders" then
			self.view:refreshTeamInfo()
		end
	elseif notifyType == "APPLY_JOIN" or notifyType == "HAS_APPLY" then
		self.view:updateApplyBtn()
	elseif notifyType == "INVITE_JOIN" then
		self.view:refreshInviteBtn()
	elseif notifyType == "AGREE_APPLY" then
		self.view:updateMyTeamInfo()
	elseif notifyType == "KICK" then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	elseif notifyType == "REJECT_APPLY" then
		self.view:onMsgRejectApply()
	end
end
function NebulaAllStarTeamProxy:onMsgUpdateNewTeamMsg(...)
	self.view:updateNewTeamMsg()
end
function NebulaAllStarTeamProxy:onMsgQuickBack(target, event)
	if event.err == gErrDef.Err_None then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NebulaAllStarTeamProxy:onMsgBeInviteBack(target, event)
	self.view:updateMyTeamInfo()
end
function NebulaAllStarTeamProxy:onMsgApplyJoinBack(...)
	self.view:onMsgApplyJoinBack(...)
end
function NebulaAllStarTeamProxy:onMsgUpdateApplyRemind(...)
	self.view:updateApplyBtn()
end
function NebulaAllStarTeamProxy:onMsgRefreshData(...)
	self.view:updateActivityState()
end
return NebulaAllStarTeamProxy
