local baseProxy = require("fgui.base.baseProxy")
local NumberGameProxy = class("NumberGameProxy", baseProxy)
function NumberGameProxy:onRegisterEvent()
	print("=======NumberGameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_GAME_NUMBER_GAME_UPDATE", handler(self, self.onDataUpdate))
end
function NumberGameProxy:onDataUpdate(target, data)
	self.view:onDataUpdate(target, data)
end
return NumberGameProxy
