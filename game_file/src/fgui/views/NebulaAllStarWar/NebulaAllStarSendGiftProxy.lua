local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarSendGiftProxy = class("NebulaAllStarSendGiftProxy", baseProxy)
function NebulaAllStarSendGiftProxy:onRegisterEvent()
	print("=======NebulaAllStarSendGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_SEND_GIFT", handler(self, self.updateView))
end
function NebulaAllStarSendGiftProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return NebulaAllStarSendGiftProxy
