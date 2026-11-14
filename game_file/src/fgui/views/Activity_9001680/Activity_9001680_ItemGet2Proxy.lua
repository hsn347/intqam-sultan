local baseProxy = require("fgui.base.baseProxy")
local Activity_9001680_ItemGet2Proxy = class("Activity_9001680_ItemGet2Proxy", baseProxy)
function Activity_9001680_ItemGet2Proxy:onRegisterEvent()
	print("=======Activity_9001680_ItemGet2Proxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001680_UPDATE", handler(self, self.updateView))
end
function Activity_9001680_ItemGet2Proxy:updateView(target, data)
	self.view:updateView(data)
end
return Activity_9001680_ItemGet2Proxy
