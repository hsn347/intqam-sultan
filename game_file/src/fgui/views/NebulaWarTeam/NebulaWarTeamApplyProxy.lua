local baseProxy = require("fgui.base.baseProxy")
local NebulaWarTeamApplyProxy = class("NebulaWarTeamApplyProxy", baseProxy)
function NebulaWarTeamApplyProxy:onRegisterEvent()
	print("=======NebulaWarTeamApplyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_APPLY_LIST_BACK", handler(self, self.onMsgApplyListBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_AGREE_APPLY_BACK", handler(self, self.onMsgAgreeApplyBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INFO_NOTIFY", handler(self, self.onMsgTeamInfoNotify))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_REFRESH_DATA", handler(self, self.onMsgRefreshData))
end
function NebulaWarTeamApplyProxy:onMsgApplyListBack(...)
	self.view:onMsgApplyListBack(...)
end
function NebulaWarTeamApplyProxy:onMsgAgreeApplyBack(...)
	self.view:onMsgAgreeApplyBack(...)
end
function NebulaWarTeamApplyProxy:onMsgTeamInfoNotify(target, event)
	if event.teamType and event.teamType ~= self.view.teamType then
		return
	end
	local notifyType = event.notifyType
	_UPVALUE0_ = self.view.teamType
	self.view.teamType.JOIN = true
	local self.view.teamType.QUIT, config = true, self.view.teamType
	if config[notifyType] then
		self.view:refreshTextRemain()
	end
end
function NebulaWarTeamApplyProxy:onMsgRefreshData(...)
	local teamAreaEnum = include("teamDef").teamAreaEnum
	if self.view.teamType ~= teamAreaEnum.NEBULA_ALL_STAR then
		return
	end
	local nebulaAllStarUtil = include("nebulaAllStarUtil")
	if not nebulaAllStarUtil.checkQuitTeamState() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
		return
	end
end
return NebulaWarTeamApplyProxy
