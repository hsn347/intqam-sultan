local baseProxy = require("fgui.base.baseProxy")
local ChatAtSelectProxy = class("ChatAtSelectProxy", baseProxy)
function ChatAtSelectProxy:onRegisterEvent()
	print("=======ChatAtSelectProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS", handler(self, self.onMsgUpdateMemberList))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_SERVER_GET_MEMBERS_SUCCESS", handler(self, self.msgGetMembersSuccess))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_TEAM_INFO", handler(self, self.onMsgNebulaAllStarTeamInfo))
end
function ChatAtSelectProxy:onMsgUpdateMemberList(...)
	self.view:onMsgUpdateMemberList(...)
end
function ChatAtSelectProxy:msgGetMembersSuccess(...)
	self.view:msgGetMembersSuccess(...)
end
function ChatAtSelectProxy:onMsgNebulaAllStarTeamInfo(...)
	self.view:onMsgNebulaAllStarTeamInfo(...)
end
return ChatAtSelectProxy
