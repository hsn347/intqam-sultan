local baseProxy = require("fgui.base.baseProxy")
local SnowmanPointRewardProxy = class("SnowmanPointRewardProxy", baseProxy)
function SnowmanPointRewardProxy:onRegisterEvent()
	print("=======SnowmanPointRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SNOWMAN_CELEBRATION_BOX_REWARD", handler(self, self.refreshView))
end
function SnowmanPointRewardProxy:refreshView(target, data)
	if self.view then
		self.view:refreshView(data)
	end
end
return SnowmanPointRewardProxy
