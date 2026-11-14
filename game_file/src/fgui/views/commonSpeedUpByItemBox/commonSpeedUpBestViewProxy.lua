local baseProxy = require("fgui.base.baseProxy")
local commonSpeedUpBestViewProxy = class("commonSpeedUpBestViewProxy", baseProxy)
function commonSpeedUpBestViewProxy:onRegisterEvent()
	print("=======commonSpeedUpBestViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.speedUpBack))
end
function commonSpeedUpBestViewProxy:speedUpBack()
	self.view:speedUpBack()
end
return commonSpeedUpBestViewProxy
