local baseProxy = require("fgui.base.baseProxy")
local NebulaWarTeamChangeFlagProxy = class("NebulaWarTeamChangeFlagProxy", baseProxy)
function NebulaWarTeamChangeFlagProxy:onRegisterEvent()
	print("=======NebulaWarTeamChangeFlagProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INFO_NOTIFY", handler(self, self.onMsgTeamInfoNotify))
end
function NebulaWarTeamChangeFlagProxy:onMsgTeamInfoNotify(target, event)
	if event.teamType and event.teamType ~= self.view.teamType then
		return
	end
	if event.notifyType == "UPDATE_SETTING" then
		SoraDCloseLoading(self.view:displayObject())
		self.view:refreshTeamFlag()
		self.view:refreshBtnChange()
	end
end
return NebulaWarTeamChangeFlagProxy
