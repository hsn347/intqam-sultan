local baseProxy = require("fgui.base.baseProxy")
local SkyrocketPointsGiftBoxProxy = class("SkyrocketPointsGiftBoxProxy", baseProxy)
function SkyrocketPointsGiftBoxProxy:onRegisterEvent()
	print("=======SkyrocketPointsGiftBoxProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROCKETRUSH_UI_REFRESH", handler(self, self.updateView))
end
function SkyrocketPointsGiftBoxProxy:updateView()
	self.view:updateView()
end
return SkyrocketPointsGiftBoxProxy
