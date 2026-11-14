local baseProxy = require("fgui.base.baseProxy")
local evilPalaceExchangeViewProxy = class("evilPalaceExchangeViewProxy", baseProxy)
function evilPalaceExchangeViewProxy:onRegisterEvent()
	print("=======evilPalaceExchangeViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_MONSTERPALACE_FEATHERSHOPBUY", handler(self, self.initData))
end
function evilPalaceExchangeViewProxy:initData(target, redata)
	self.view:initData(target, redata)
end
return evilPalaceExchangeViewProxy
