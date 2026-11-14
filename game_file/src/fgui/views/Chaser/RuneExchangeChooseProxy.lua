local baseProxy = require("fgui.base.baseProxy")
local RuneExchangeChooseProxy = class("RuneExchangeChooseProxy", baseProxy)
function RuneExchangeChooseProxy:onRegisterEvent()
	print("=======RuneExchangeChooseProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_INHERIT_CHOOSE", handler(self, self.updateView))
end
function RuneExchangeChooseProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return RuneExchangeChooseProxy
