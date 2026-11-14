local baseProxy = require("fgui.base.baseProxy")
local MagicLampBlessProxy = class("MagicLampBlessProxy", baseProxy)
function MagicLampBlessProxy:onRegisterEvent()
	print("=======MagicLampBlessProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_UPDATE", handler(self, self.msgUpdateView))
end
function MagicLampBlessProxy:msgUpdateView()
	self.view:updateView()
end
return MagicLampBlessProxy
