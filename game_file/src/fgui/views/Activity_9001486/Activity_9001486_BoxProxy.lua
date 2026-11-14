local baseProxy = require("fgui.base.baseProxy")
local Activity_9001486_BoxProxy = class("Activity_9001486_BoxProxy", baseProxy)
function Activity_9001486_BoxProxy:onRegisterEvent()
	print("=======Activity_9001486_BoxProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001486_CLAIM", handler(self, self.onMsgUpdateClaim))
end
function Activity_9001486_BoxProxy:onMsgUpdateClaim(...)
	self.view:closePanel()
end
return Activity_9001486_BoxProxy
