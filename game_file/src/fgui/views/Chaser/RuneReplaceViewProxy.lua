local baseProxy = require("fgui.base.baseProxy")
local RuneReplaceViewProxy = class("RuneReplaceViewProxy", baseProxy)
function RuneReplaceViewProxy:onRegisterEvent()
	print("=======RuneReplaceViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RUNE_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_LOCK_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_REPLACE", handler(self, self.chooseBack))
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_REPLACE_CHOOSE", handler(self, self.replace))
end
function RuneReplaceViewProxy:updateView(target, data)
	self.view:updateView()
end
function RuneReplaceViewProxy:chooseBack(target, data)
	self.view:chooseBack(target, data)
end
function RuneReplaceViewProxy:replace(target, data)
	self.view:replace(target, data)
end
return RuneReplaceViewProxy
