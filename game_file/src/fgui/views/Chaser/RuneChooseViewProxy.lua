local baseProxy = require("fgui.base.baseProxy")
local RuneChooseViewProxy = class("RuneChooseViewProxy", baseProxy)
function RuneChooseViewProxy:onRegisterEvent()
	print("=======RuneChooseViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_CHOOSE", handler(self, self.strengthenChooseBack))
	SoraDAddMessage(self, "MESSAGE_RUNE_UPDATE", handler(self, self.updateView))
end
function RuneChooseViewProxy:strengthenChooseBack(target, data)
	self.view:strengthenChooseBack(target, data)
end
function RuneChooseViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return RuneChooseViewProxy
