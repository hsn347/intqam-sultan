local baseProxy = require("fgui.base.baseProxy")
local NebulaWarTeamSettingProxy = class("NebulaWarTeamSettingProxy", baseProxy)
function NebulaWarTeamSettingProxy:onRegisterEvent()
	print("=======NebulaWarTeamSettingProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INFO_NOTIFY", handler(self, self.onMsgTeamInfoNotify))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_REFRESH_DATA", handler(self, self.onMsgNebulaStateNotify))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_QUIT_BACk", handler(self, self.onMsgQuickBack))
end
function NebulaWarTeamSettingProxy:onMsgTeamInfoNotify(target, event)
	if event.teamType and event.teamType ~= self.view.teamType then
		return
	end
	local notifyType = event.notifyType
	if notifyType == "UPDATE_SETTING" then
		self.view:updateFlag()
	elseif notifyType == "UPDATE_NAME" or notifyType == "UPDATE_ABBR" then
		self.view:updateName()
	end
end
function NebulaWarTeamSettingProxy:onMsgNebulaStateNotify(target, event)
	local nebulaWarUtil = include("nebulaWarUtil")
	if not nebulaWarUtil.checkChangeTeamNameState() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NebulaWarTeamSettingProxy:onMsgQuickBack(target, event)
	if event.err ~= gErrDef.Err_None then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return NebulaWarTeamSettingProxy
