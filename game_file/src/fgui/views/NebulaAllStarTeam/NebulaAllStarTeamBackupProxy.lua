local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarTeamBackupProxy = class("NebulaAllStarTeamBackupProxy", baseProxy)
function NebulaAllStarTeamBackupProxy:onRegisterEvent()
	print("=======NebulaAllStarTeamBackupProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgCommonRefresh))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_REFRESH_DATA", handler(self, self.onMsgRefreshData))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_SIGN_UP_UPDATE", handler(self, self.onMsgUpdateSignUp))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_TEAM_INFO", handler(self, self.onMsgReqTeamInfoBack))
end
function NebulaAllStarTeamBackupProxy:onMsgCommonRefresh(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NebulaAllStarTeamBackupProxy:onMsgRefreshData(...)
	local nebulaAllStarUtil = include("nebulaAllStarUtil")
	if not nebulaAllStarUtil.checkSignBackupTeamState() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
		nebulaAllStarUtil.openBackupTeamView()
	end
end
function NebulaAllStarTeamBackupProxy:onMsgUpdateSignUp(...)
	self.view:onMsgUpdateSignUp(...)
end
function NebulaAllStarTeamBackupProxy:onMsgReqTeamInfoBack(...)
	self.view:onMsgReqTeamInfoBack(...)
end
return NebulaAllStarTeamBackupProxy
