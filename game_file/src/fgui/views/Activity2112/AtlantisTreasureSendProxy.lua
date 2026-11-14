local baseProxy = require("fgui.base.baseProxy")
local AtlantisTreasureSendProxy = class("AtlantisTreasureSendProxy", baseProxy)
function AtlantisTreasureSendProxy:onRegisterEvent()
	print("=======AtlantisTreasureSendProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_SENDTREASURE_REFRESH", handler(self, self.msgRefreshTreasure))
end
function AtlantisTreasureSendProxy:msgRefreshTreasure(target, data)
	self.view:refreshTreasureData()
end
return AtlantisTreasureSendProxy
