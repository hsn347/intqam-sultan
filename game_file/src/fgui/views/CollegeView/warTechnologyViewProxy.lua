local baseProxy = require("fgui.base.baseProxy")
local warTechnologyViewProxy = class("warTechnologyViewProxy", baseProxy)
function warTechnologyViewProxy:onRegisterEvent()
	print("=======warTechnologyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.updateStudy))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateStudy))
end
function warTechnologyViewProxy:updateStudy()
	self.view:updateStudy()
end
return warTechnologyViewProxy
