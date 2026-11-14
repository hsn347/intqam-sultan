local baseProxy = require("fgui.base.baseProxy")
local RunePopViewProxy = class("RunePopViewProxy", baseProxy)
function RunePopViewProxy:onRegisterEvent()
	print("=======RunePopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_LOCK_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_RUNE_INHERIT_UPDATE", handler(self, self.updateView))
end
function RunePopViewProxy:updateView(target, data)
	self.view:updateView()
end
return RunePopViewProxy
