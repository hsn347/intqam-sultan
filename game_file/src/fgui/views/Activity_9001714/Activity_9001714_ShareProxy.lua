local baseProxy = require("fgui.base.baseProxy")
local Activity_9001714_ShareProxy = class("Activity_9001714_ShareProxy", baseProxy)
function Activity_9001714_ShareProxy:onRegisterEvent()
	print("=======Activity_9001714_ShareProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_DATA_BACK", handler(self, self.friendDataBack))
end
function Activity_9001714_ShareProxy:friendDataBack(target, data)
	self.view:friendDataBack(target, data)
end
return Activity_9001714_ShareProxy
