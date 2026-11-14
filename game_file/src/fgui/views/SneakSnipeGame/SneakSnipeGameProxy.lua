local baseProxy = require("fgui.base.baseProxy")
local SneakSnipeGameProxy = class("SneakSnipeGameProxy", baseProxy)
function SneakSnipeGameProxy:onRegisterEvent()
	print("=======SneakSnipeGameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE", handler(self, self.onResultClose))
	SoraDAddMessage(self, "MESSAGE_SNEAK_SNIPE_GAME_SUBBLOOD", handler(self, self.onSubBlood))
end
function SneakSnipeGameProxy:onResultClose()
	self.view:close()
end
function SneakSnipeGameProxy:onSubBlood()
	self.view:subBlood()
end
return SneakSnipeGameProxy
