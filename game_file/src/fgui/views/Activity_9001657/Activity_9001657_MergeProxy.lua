local baseProxy = require("fgui.base.baseProxy")
local Activity_9001657_MergeProxy = class("Activity_9001657_MergeProxy", baseProxy)
function Activity_9001657_MergeProxy:onRegisterEvent()
	print("=======Activity_9001657_MergeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001657_KINGDOM_LIST", handler(self, self.onMsgUpdateKingdomList))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001657_ENTER_CHATROOM", handler(self, self.onMsgEnterChatRoom))
end
function Activity_9001657_MergeProxy:onMsgUpdateKingdomList(...)
	self.view:onMsgUpdateKingdomList(...)
end
function Activity_9001657_MergeProxy:onMsgEnterChatRoom(...)
	self.view:onMsgEnterChatRoom(...)
end
return Activity_9001657_MergeProxy
