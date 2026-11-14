local baseProxy = require("fgui.base.baseProxy")
local RuneAddViewProxy = class("RuneAddViewProxy", baseProxy)
function RuneAddViewProxy:onRegisterEvent()
	print("=======RuneAddViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RUNE_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_REPLACE_UNCHOOSE", handler(self, self.unChoose))
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_REPLACE_CHOOSE", handler(self, self.replace))
end
function RuneAddViewProxy:updateView(target, data)
	self.view:initData()
end
function RuneAddViewProxy:unChoose(target, data)
	self.view:unChoose(target, data)
end
function RuneAddViewProxy:replace(target, data)
	self.view:replace(target, data)
end
return RuneAddViewProxy
