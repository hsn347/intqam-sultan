local baseProxy = require("fgui.base.baseProxy")
local Activity_9001700_SendProxy = class("Activity_9001700_SendProxy", baseProxy)
function Activity_9001700_SendProxy:onRegisterEvent()
	print("=======Activity_9001700_SendProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_LORD_SEARCH_BACK", handler(self, self.onMsgUpdateSearchList))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001700_UPDATE", handler(self, self.onMsgUpdateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS", handler(self, self.onMsgUpdateMemberList))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_DATA_BACK", handler(self, self.onMsgUpdateFriendList))
end
function Activity_9001700_SendProxy:onMsgUpdateSearchList(...)
	self.view:onMsgUpdateSearchList(...)
end
function Activity_9001700_SendProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
function Activity_9001700_SendProxy:onMsgUpdateMemberList(...)
	self.view:onMsgUpdateMemberList(...)
end
function Activity_9001700_SendProxy:onMsgUpdateFriendList(...)
	self.view:onMsgUpdateFriendList(...)
end
return Activity_9001700_SendProxy
