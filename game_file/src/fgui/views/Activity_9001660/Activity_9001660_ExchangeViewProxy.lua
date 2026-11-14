local baseProxy = require("fgui.base.baseProxy")
local Activity_9001660_ExchangeViewProxy = class("Activity_9001660_ExchangeViewProxy", baseProxy)
function Activity_9001660_ExchangeViewProxy:onRegisterEvent()
	print("=======Activity_9001660_ExchangeViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_MUTANT_TENTACLES_FEATHERSHOPBUY", handler(self, self.initData))
end
function Activity_9001660_ExchangeViewProxy:initData(target, data)
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_MUTANT_TENTACLES_UPDATETIPS"
	SoraDSendMessage(nil)
	self.view:initData(target, data)
end
return Activity_9001660_ExchangeViewProxy
