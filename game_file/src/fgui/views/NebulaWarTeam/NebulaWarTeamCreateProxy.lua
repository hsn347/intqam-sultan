local baseProxy = require("fgui.base.baseProxy")
local NebulaWarTeamCreateProxy = class("NebulaWarTeamCreateProxy", baseProxy)
function NebulaWarTeamCreateProxy:onRegisterEvent()
	print("=======NebulaWarTeamCreateProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_CREATE_BACk", handler(self, self.onMsgCreateBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_CHANGE_INFO", handler(self, self.onMsgChangeInfo))
end
function NebulaWarTeamCreateProxy:onMsgCreateBack(target, event)
	self.view:onMsgCreateBack(target, event)
end
function NebulaWarTeamCreateProxy:onMsgChangeInfo(target, event)
	self.view:onMsgChangeInfo(target, event)
end
return NebulaWarTeamCreateProxy
