local baseProxy = require("fgui.base.baseProxy")
local RuneRintensifyProxy = class("RuneRintensifyProxy", baseProxy)
function RuneRintensifyProxy:onRegisterEvent()
	print("=======RuneRintensifyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RUNE_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_CHOOSE_UPDATE", handler(self, self.chooseBack))
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_STRENGTHEN_CHOOSE", handler(self, self.strengthenChooseBack))
end
function RuneRintensifyProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function RuneRintensifyProxy:chooseBack(target, data)
	self.view:chooseBack(target, data)
end
function RuneRintensifyProxy:strengthenChooseBack(target, data)
	self.view:strengthenChooseBack(target, data)
end
return RuneRintensifyProxy
