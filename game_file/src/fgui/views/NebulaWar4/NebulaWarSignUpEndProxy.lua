local nebulaWarUtil = include("nebulaWarUtil")
local baseProxy = require("fgui.base.baseProxy")
local NebulaWarSignUpEndProxy = class("NebulaWarSignUpEndProxy", baseProxy)
function NebulaWarSignUpEndProxy:onRegisterEvent()
	print("=======NebulaWarSignUpEndProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_SUPER_TEAM_INFO", handler(self, self.onMsgSuperTeamInfo))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_REFRESH_DATA", handler(self, self.onMsgStateChange))
end
function NebulaWarSignUpEndProxy:onMsgSuperTeamInfo(target, event)
	SoraDCloseLoading(self.view:displayObject())
	if not event.teamList then
		local _ENV, teamList = event.teamList, event.teamList
	end
	self.view:updateSuperTeam(teamList)
end
function NebulaWarSignUpEndProxy:onMsgStateChange(...)
	if nebulaWarUtil.checkSuperTeamSignUpState() then
		self.view:closePanel()
	end
end
return NebulaWarSignUpEndProxy
