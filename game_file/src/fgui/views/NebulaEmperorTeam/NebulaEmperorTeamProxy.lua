local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorTeamProxy = class("NebulaEmperorTeamProxy", baseProxy)
function NebulaEmperorTeamProxy:onRegisterEvent()
	print("=======NebulaEmperorTeamProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_MEMBER_INFO_BACK", handler(self, self.onMsgMemberInfoBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_TEAM_INFO", handler(self, self.onMsgReqTeamInfoBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INFO_NOTIFY", handler(self, self.onMsgTeamInfoNotify))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MSG", handler(self, self.onMsgUpdateNewTeamMsg))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_QUIT_BACk", handler(self, self.onMsgQuickBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_BEINVITE_BACK", handler(self, self.onMsgBeInviteBack))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.onMsgUpdateGreenPoint))
end
function NebulaEmperorTeamProxy:onMsgMemberInfoBack(...)
	self.view:onMsgMemberInfoBack(...)
end
function NebulaEmperorTeamProxy:onMsgReqTeamInfoBack(...)
	self.view:onMsgReqTeamInfoBack(...)
end
function NebulaEmperorTeamProxy:onMsgTeamInfoNotify(target, event)
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
		elseif notifyKey == "assemblers" then
			self.view:refreshMemberInfo()
		end
	elseif notifyType == "APPLY_JOIN" or notifyType == "HAS_APPLY" then
		self.view:updateApplyBtn()
	elseif notifyType == "INVITE_JOIN" then
		self.view:refreshInviteBtn()
	elseif notifyType == "AGREE_APPLY" then
		self.view:updateMyTeamInfo()
	elseif notifyType == "KICK" then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NebulaEmperorTeamProxy:onMsgUpdateNewTeamMsg(...)
	self.view:updateNewTeamMsg()
end
function NebulaEmperorTeamProxy:onMsgQuickBack(target, event)
	if event.err == gErrDef.Err_None then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NebulaEmperorTeamProxy:onMsgBeInviteBack(target, event)
	self.view:updateMyTeamInfo()
end
function NebulaEmperorTeamProxy:onMsgUpdateGreenPoint(target, event)
	if event.type == GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR then
		self.view:updateButtonWar()
	end
end
return NebulaEmperorTeamProxy
