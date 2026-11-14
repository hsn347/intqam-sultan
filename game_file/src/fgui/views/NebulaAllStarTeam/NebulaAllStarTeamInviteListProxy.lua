local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarTeamInviteListProxy = class("NebulaAllStarTeamInviteListProxy", baseProxy)
function NebulaAllStarTeamInviteListProxy:onRegisterEvent()
	print("=======NebulaAllStarTeamInviteListProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_INVITED_USERS", handler(self, self.onMsgUpdateInvitedUsers))
end
function NebulaAllStarTeamInviteListProxy:onMsgUpdateInvitedUsers(...)
	self.view:onMsgUpdateInvitedUsers(...)
end
return NebulaAllStarTeamInviteListProxy
