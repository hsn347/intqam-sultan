local baseProxy = require("fgui.base.baseProxy")
local warTechViewProxy = class("warTechViewProxy", baseProxy)
function warTechViewProxy:onRegisterEvent()
	print("=======warTechViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.updateStudy))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateStudy))
end
function warTechViewProxy:updateStudy(target, data)
	self.view:updateStudy(target, data)
end
return warTechViewProxy
