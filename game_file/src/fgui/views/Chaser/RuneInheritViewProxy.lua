local baseProxy = require("fgui.base.baseProxy")
local RuneInheritViewProxy = class("RuneInheritViewProxy", baseProxy)
function RuneInheritViewProxy:onRegisterEvent()
	print("=======RuneInheritViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_INHERIT_CHOOSE_SOURCE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_INHERIT_CHOOSE_TARGET", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_RUNE_INHERIT_UPDATE", handler(self, self.closeView))
end
function RuneInheritViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function RuneInheritViewProxy:closeView(target, data)
	self.view:closeView()
end
return RuneInheritViewProxy
