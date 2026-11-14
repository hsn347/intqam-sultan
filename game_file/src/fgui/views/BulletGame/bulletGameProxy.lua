local baseProxy = require("fgui.base.baseProxy")
local bulletGameProxy = class("bulletGameProxy", baseProxy)
function bulletGameProxy:onRegisterEvent()
	print("=======bulletGameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE", handler(self, self.onResultClose))
	SoraDAddMessage(self, "MESSAGE_BULLET_GAME_REPLAY", handler(self, self.msgEventBack))
end
function bulletGameProxy:onResultClose()
	self.view:close()
end
function bulletGameProxy:msgEventBack()
	self.view:onClickReset()
end
function bulletGameProxy:getCheatData(index)
	return self.view:getCheatData(index)
end
return bulletGameProxy
