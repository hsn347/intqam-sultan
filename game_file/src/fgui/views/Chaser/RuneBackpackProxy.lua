local baseProxy = require("fgui.base.baseProxy")
local RuneBackpackProxy = class("RuneBackpackProxy", baseProxy)
function RuneBackpackProxy:onRegisterEvent()
	print("=======RuneBackpackProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RUNE_UPDATE", handler(self, self.updateView))
end
function RuneBackpackProxy:updateView(target, data)
	self.view:initData()
end
return RuneBackpackProxy
