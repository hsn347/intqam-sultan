local baseProxy = require("fgui.base.baseProxy")
local SkyrocketRankViewProxy = class("SkyrocketRankViewProxy", baseProxy)
function SkyrocketRankViewProxy:onRegisterEvent()
	print("=======SkyrocketRankViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROCKETRUSH_UI_RANK", handler(self, self.updateView))
end
function SkyrocketRankViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return SkyrocketRankViewProxy
