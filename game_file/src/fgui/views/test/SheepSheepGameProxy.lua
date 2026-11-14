local baseProxy = require("fgui.base.baseProxy")
local SheepSheepGameProxy = class("SheepSheepGameProxy", baseProxy)
function SheepSheepGameProxy:onRegisterEvent()
	print("=======SheepSheepGameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_GAME_SHEEP_CHOOSE", handler(self, self.onSheepChoose))
end
function SheepSheepGameProxy:onSheepChoose(target, data)
	self.view:onSheepChoose(target, data)
end
return SheepSheepGameProxy
