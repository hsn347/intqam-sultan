local baseProxy = require("fgui.base.baseProxy")
local ForeignPShootGameProxy = class("ForeignPShootGameProxy", baseProxy)
function ForeignPShootGameProxy:onRegisterEvent()
	print("=======ForeignPShootGameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE", handler(self, self.onClose))
end
function ForeignPShootGameProxy:onClose()
	self.view:close()
end
return ForeignPShootGameProxy
