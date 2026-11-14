local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseProxy = require("fgui.base.baseProxy")
local NebulaWarTeamProxy = class("NebulaWarTeamProxy", baseProxy)
function NebulaWarTeamProxy:onRegisterEvent()
	print("=======NebulaWarTeamProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INFO_NOTIFY", handler(self, self.onMsgTeamInfoNotify))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_DISMISS_BACk", handler(self, self.onMsgTeamDisMissBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_QUIT_BACk", handler(self, self.onMsgQuickBack))
end
function NebulaWarTeamProxy:onMsgTeamInfoNotify(target, event)
	if event.teamType and event.teamType ~= self.view.teamType then
		return
	end
	local notifyType = event.notifyType
	if notifyType == "KICK" or notifyType == "DISMISS" then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NebulaWarTeamProxy:onMsgTeamDisMissBack(target, event)
	local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	if not myTeamInfo:isHasTeam() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NebulaWarTeamProxy:onMsgQuickBack(target, event)
	if event.err == gErrDef.Err_None then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return NebulaWarTeamProxy
