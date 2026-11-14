local baseProxy = require("fgui.base.baseProxy")
local worldMapCordinateShareViewProxy = class("worldMapCordinateShareViewProxy", baseProxy)
function worldMapCordinateShareViewProxy:onRegisterEvent()
	print("=======worldMapCordinateShareViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_REQ_ALL_CHAT_ROOM_INFO", handler(self, self.reqAllChatRoomInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_DATA_BACK", handler(self, self.friendDataBack))
end
function worldMapCordinateShareViewProxy:reqAllChatRoomInfo()
	self.view:reqAllChatRoomInfo()
end
function worldMapCordinateShareViewProxy:friendDataBack()
	self.view:friendDataBack()
end
return worldMapCordinateShareViewProxy
