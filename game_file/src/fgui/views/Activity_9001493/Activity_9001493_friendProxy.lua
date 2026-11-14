local baseProxy = require("fgui.base.baseProxy")
local Activity_9001493_friendProxy = class("Activity_9001493_friendProxy", baseProxy)
function Activity_9001493_friendProxy:onRegisterEvent()
	print("=======Activity_9001493_friendProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_STATUS_UPDATE", handler(self, self.updateFriendList))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_DATA_BACK", handler(self, self.updateFriendList))
end
function Activity_9001493_friendProxy:updateFriendList(...)
	self.view:updateFriendList()
end
function Activity_9001493_friendProxy:showLoading(...)
	SoraDShowLoading(self.view:displayObject())
end
function Activity_9001493_friendProxy:closeLoading(...)
	SoraDCloseLoading(self.view:displayObject())
end
return Activity_9001493_friendProxy
