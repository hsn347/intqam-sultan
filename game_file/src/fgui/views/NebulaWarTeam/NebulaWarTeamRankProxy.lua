local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseProxy = require("fgui.base.baseProxy")
local NebulaWarTeamRankProxy = class("NebulaWarTeamRankProxy", baseProxy)
function NebulaWarTeamRankProxy:onRegisterEvent()
	print("=======NebulaWarTeamRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_SUPER_TEAM_FC_RANK", handler(self, self.onMsgSuperTeamFcRankBack))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_REFRESH_DATA", handler(self, self.onMsgStateChange))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_APPLY_JOIN_BACK", handler(self, self.onMsgApplyJoinBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INFO_NOTIFY", handler(self, self.onMsgTeamInfoNotify))
end
function NebulaWarTeamRankProxy:onMsgSuperTeamFcRankBack(target, event)
	self.view:onMsgSuperTeamFcRankBack(target, event)
end
function NebulaWarTeamRankProxy:onMsgStateChange()
	self.view:updateState()
end
function NebulaWarTeamRankProxy:onMsgApplyJoinBack(target, event)
	local err = event.err
	if err == gErrDef.Err_NOT_FOUND_TEAM or err == gErrDef.Err_TEAM_MEMBER_FULL then
		self.view:resetRankAndReqData()
	end
end
function NebulaWarTeamRankProxy:onMsgTeamInfoNotify(target, event)
	if event.teamType and event.teamType ~= self.view.teamType then
		return
	end
	local justLook = self.param and self.param.justLook
	if justLook then
		return
	end
	local notifyType = event.notifyType
	if notifyType ~= "INVITE_JOIN" then
		self:refreshMyTeamInfo()
	end
end
function NebulaWarTeamRankProxy:refreshMyTeamInfo(...)
	local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	if myTeamInfo:isHasTeam() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
		uiManager:show("NebulaWarTeam")
	end
end
return NebulaWarTeamRankProxy
