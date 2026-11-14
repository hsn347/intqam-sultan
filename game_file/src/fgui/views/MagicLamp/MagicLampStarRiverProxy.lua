local baseProxy = require("fgui.base.baseProxy")
local MagicLampStarRiverProxy = class("MagicLampStarRiverProxy", baseProxy)
function MagicLampStarRiverProxy:onRegisterEvent()
	print("=======MagicLampStarRiverProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_UPDATE", handler(self, self.msgUpdateView))
end
function MagicLampStarRiverProxy:msgUpdateView()
	self.view:updateView(self.view.curSelectedSlot)
end
return MagicLampStarRiverProxy
