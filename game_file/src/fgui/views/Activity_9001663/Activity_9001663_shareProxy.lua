local baseProxy = require("fgui.base.baseProxy")
local Activity_9001663_shareProxy = class("Activity_9001663_shareProxy", baseProxy)
function Activity_9001663_shareProxy:onRegisterEvent()
	print("=======Activity_9001663_shareProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_DATA_BACK", handler(self, self.initData))
end
function Activity_9001663_shareProxy:initData(target, data)
	self.view:initData(target, data)
end
return Activity_9001663_shareProxy
