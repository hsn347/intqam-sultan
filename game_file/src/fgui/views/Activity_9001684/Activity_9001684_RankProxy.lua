local baseProxy = require("fgui.base.baseProxy")
local Activity_9001684_RankProxy = class("Activity_9001684_RankProxy", baseProxy)
function Activity_9001684_RankProxy:onRegisterEvent()
	print("=======Activity_9001684_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001684_UPDATE", handler(self, self.initView))
end
function Activity_9001684_RankProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001684_RankProxy
