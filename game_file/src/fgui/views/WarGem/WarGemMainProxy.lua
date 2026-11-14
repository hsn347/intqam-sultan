local baseProxy = require("fgui.base.baseProxy")
local WarGemMainProxy = class("WarGemMainProxy", baseProxy)
function WarGemMainProxy:onRegisterEvent()
	print("=======WarGemMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_CLOSE_GUIDE", handler(self, self.onGuideUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_STEP_END", handler(self, self.onGuideUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_STEP_ON", handler(self, self.onGuideUpdate))
end
function WarGemMainProxy:onGuideUpdate()
	self.view:showWarStarGemGuide()
end
return WarGemMainProxy
