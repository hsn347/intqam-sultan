local baseProxy = require("fgui.base.baseProxy")
local RuneInheritChooseProxy = class("RuneInheritChooseProxy", baseProxy)
function RuneInheritChooseProxy:onRegisterEvent()
	print("=======RuneInheritChooseProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RUNE_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_INHERIT_CHOOSE", handler(self, self.updateView))
end
function RuneInheritChooseProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return RuneInheritChooseProxy
