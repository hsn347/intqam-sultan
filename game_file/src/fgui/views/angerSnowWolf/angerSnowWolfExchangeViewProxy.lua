local baseProxy = require("fgui.base.baseProxy")
local angerSnowWolfExchangeViewProxy = class("angerSnowWolfExchangeViewProxy", baseProxy)
function angerSnowWolfExchangeViewProxy:onRegisterEvent()
	print("=======angerSnowWolfExchangeViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_SNOW_WOLF_KING_FEATHERSHOPBUY", handler(self, self.initData))
end
function angerSnowWolfExchangeViewProxy:initData(target, data)
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_SNOW_WOLF_KING_UPDATETIPS"
	SoraDSendMessage(nil)
	self.view:initData(target, data)
end
return angerSnowWolfExchangeViewProxy
