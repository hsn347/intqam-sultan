local baseProxy = require("fgui.base.baseProxy")
local NebulaWarTeamBeInviteProxy = class("NebulaWarTeamBeInviteProxy", baseProxy)
function NebulaWarTeamBeInviteProxy:onRegisterEvent()
	print("=======NebulaWarTeamBeInviteProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_BEINVITE_BACK", handler(self, self.onMsgBeInviteBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INFO_NOTIFY", handler(self, self.onMsgTeamInfoNotify))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_TEAM_INFO", handler(self, self.onMsgReqTeamInfoBack))
end
function NebulaWarTeamBeInviteProxy:onMsgBeInviteBack(...)
	local teamCtrl = SoraDGetCtrl("teamCtrl")
	local myTeamInfo = teamCtrl:getTeamData(self.view.teamType)
	if myTeamInfo:isHasTeam() then
		self:removeView(self.view)
		return
	end
	self.view:refreshView()
end
function NebulaWarTeamBeInviteProxy:onMsgTeamInfoNotify(target, event)
	if event.teamType and event.teamType ~= self.view.teamType then
		return
	end
	local notifyType = event.notifyType
	if notifyType == "INVITE_JOIN" then
		self.view:refreshView()
	end
end
function NebulaWarTeamBeInviteProxy:onMsgReqTeamInfoBack(...)
	self.view:onMsgReqTeamInfoBack(...)
end
return NebulaWarTeamBeInviteProxy
