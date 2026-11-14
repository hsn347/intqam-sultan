local baseProxy = require("fgui.base.baseProxy")
local luckyFalconAdditionalViewProxy = class("luckyFalconAdditionalViewProxy", baseProxy)
function luckyFalconAdditionalViewProxy:onRegisterEvent()
	print("=======luckyFalconAdditionalViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LUCKY_FALCON_STAGE_REFRESH", handler(self, self.initData))
end
function luckyFalconAdditionalViewProxy:initData()
	self.view:initData()
end
return luckyFalconAdditionalViewProxy
