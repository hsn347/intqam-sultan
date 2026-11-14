local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseProxy = require("fgui.base.baseProxy")
local NebulaWarTeamMemberProxy = class("NebulaWarTeamMemberProxy", baseProxy)
function NebulaWarTeamMemberProxy:onRegisterEvent()
	print("=======NebulaWarTeamMemberProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_TRANSFER_LEADER", handler(self, self.onMsgTransferLeader))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_KICK_BACK", handler(self, self.onMsgKickBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_MEMBER_QUIT", handler(self, self.onMsgMemberQuit))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_QUIT_BACk", handler(self, self.onMsgQuickBack))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_REFRESH_DATA", handler(self, self.onMsgNebulaStateNotify))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INFO_NOTIFY", handler(self, self.onMsgTeamInfoNotify))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_PLAYER_HIST", handler(self, self.onMsgUpdatePlayerHist))
end
function NebulaWarTeamMemberProxy:onMsgTransferLeader(target, event)
	self:removeView(self.view)
end
function NebulaWarTeamMemberProxy:onMsgKickBack(target, event)
	self:removeView(self.view)
end
function NebulaWarTeamMemberProxy:onMsgMemberQuit(target, event)
	self.view:onMsgMemberQuit(target, event)
end
function NebulaWarTeamMemberProxy:onMsgQuickBack(target, event)
	if event.err ~= gErrDef.Err_None then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NebulaWarTeamMemberProxy:onMsgNebulaStateNotify(target, event)
	local nebulaWarUtil = include("nebulaWarUtil")
	if not nebulaWarUtil.checkChangeTeamNameState() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NebulaWarTeamMemberProxy:onMsgTeamInfoNotify(target, event)
	if event.teamType and event.teamType ~= self.view.teamType then
		return
	end
	local notifyType = event.notifyType
	if notifyType == "UPDATE_SETTING" and (event.key == "assemblers" or event.key == "commanders") then
		local myTeamInfo = self.view:getMyTeamInfo()
		if myTeamInfo:isTeamLeader() then
			SoraDCloseLoading(self.view)
			self.view:updateOperateBtns()
		end
	end
end
function NebulaWarTeamMemberProxy:onMsgUpdatePlayerHist(...)
	self.view:onMsgUpdatePlayerHist(...)
end
return NebulaWarTeamMemberProxy
