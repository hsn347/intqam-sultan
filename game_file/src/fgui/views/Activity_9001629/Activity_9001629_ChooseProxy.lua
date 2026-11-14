local baseProxy = require("fgui.base.baseProxy")
local Activity_9001629_ChooseProxy = class("Activity_9001629_ChooseProxy", baseProxy)
function Activity_9001629_ChooseProxy:onRegisterEvent()
	print("=======Activity_9001629_ChooseProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS", handler(self, self.refreshMemberList))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_DATA_BACK", handler(self, self.refreshFriendList))
end
function Activity_9001629_ChooseProxy:refreshMemberList(target, data)
	self.view:refreshMemberList()
end
function Activity_9001629_ChooseProxy:refreshFriendList(target, data)
	self.view:refreshFriendList()
end
return Activity_9001629_ChooseProxy
