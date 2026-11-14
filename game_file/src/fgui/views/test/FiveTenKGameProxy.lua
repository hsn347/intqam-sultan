local baseProxy = require("fgui.base.baseProxy")
local FiveTenKGameProxy = class("FiveTenKGameProxy", baseProxy)
function FiveTenKGameProxy:onRegisterEvent()
	print("=======FiveTenKGameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_GAME_FIVETENK_CARD_CHOOSE", handler(self, self.onCardChoose))
end
function FiveTenKGameProxy:onCardChoose(target, data)
	self.view:onCardChoose(target, data)
end
return FiveTenKGameProxy
