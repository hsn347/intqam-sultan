local baseProxy = require("fgui.base.baseProxy")
local Activity_9001737_DonateProxy = class("Activity_9001737_DonateProxy", baseProxy)
function Activity_9001737_DonateProxy:onRegisterEvent()
	print("=======Activity_9001737_DonateProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001737_RANK", handler(self, self.initView))
end
function Activity_9001737_DonateProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001737_DonateProxy
