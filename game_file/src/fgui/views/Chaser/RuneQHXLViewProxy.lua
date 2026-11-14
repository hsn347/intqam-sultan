local baseProxy = require("fgui.base.baseProxy")
local RuneQHXLViewProxy = class("RuneQHXLViewProxy", baseProxy)
function RuneQHXLViewProxy:onRegisterEvent()
	print("=======RuneQHXLViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_REMAKE_LOCK", handler(self, self.lockChoose))
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_STRENGTHEN_RANDOM", handler(self, self.strengthChoose))
	SoraDAddMessage(self, "MESSAGE_RUNE_UPDATE", handler(self, self.updateXLView))
end
function RuneQHXLViewProxy:lockChoose(target, data)
	self.view:lockChoose(target, data)
end
function RuneQHXLViewProxy:strengthChoose(target, data)
	self.view:strengthChoose(target, data)
end
function RuneQHXLViewProxy:updateXLView(target, data)
	self.view:updateXLView(data.multipleIndex)
end
return RuneQHXLViewProxy
